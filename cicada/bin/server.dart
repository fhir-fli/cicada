import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'package:cicada/cicada.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');
  final results = parser.parse(args);
  final port =
      int.parse(Platform.environment['PORT'] ?? results['port'] as String);

  final router = Router()
    ..post(r'/$immds-forecast', _handleForecast)
    ..post(r'/$immds-forecast-who', _handleForecastWho)
    ..post('/', _handleForecast)
    ..post('/<anything|.*>', _handleForecast)
    ..get('/metadata', _handleMetadata)
    ..get('/', _handleRoot);

  final handler = const Pipeline()
      .addMiddleware(_logRequests())
      .addMiddleware(_cors())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  print('Cicada ImmDS server listening on port ${server.port}');
}

/// POST /$immds-forecast — run the CDC forecasting engine.
Future<Response> _handleForecast(Request request) =>
    _runForecast(request, ForecastMode.cdc);

/// POST /$immds-forecast-who — run the WHO forecasting engine.
Future<Response> _handleForecastWho(Request request) =>
    _runForecast(request, ForecastMode.who);

/// Shared forecast handler. Accepts JSON or XML input, runs the engine with
/// the given [mode], and returns the corresponding format.
Future<Response> _runForecast(Request request, ForecastMode mode) async {
  try {
    final body = await request.readAsString();
    print('  Body length: ${body.length} (mode: ${mode.name})');

    if (body.isEmpty) {
      return _operationOutcome('No request body provided', 400);
    }

    final contentType = request.headers['content-type'] ?? '';
    final accept = request.headers['accept'] ?? '';
    final isXmlInput =
        contentType.contains('xml') || body.trimLeft().startsWith('<');
    final wantsXml = accept.contains('xml');

    // --- Parse input ---
    final Map<String, dynamic> json;
    if (isXmlInput) {
      try {
        json = fhirXmlToJson(body);
        print('  XML→JSON: resourceType=${json['resourceType']}');
      } catch (e) {
        return _operationOutcome('XML parse error: $e', 400);
      }
    } else {
      try {
        json = jsonDecode(body) as Map<String, dynamic>;
      } catch (e) {
        return _operationOutcome('Invalid JSON: $e', 400);
      }
    }

    // --- Run forecast ---
    final output = forecastFromMap(json, mode: mode);
    final outputJson = output.toJson();

    // --- Format output ---
    if (wantsXml) {
      try {
        final xmlResponse = fhirJsonToXml(outputJson);
        print('  Response XML length: ${xmlResponse.length}');
        _logOnce('request', body);
        _logOnce('response', xmlResponse);
        final xmlContentType = accept.contains('fhir')
            ? 'application/fhir+xml'
            : 'application/xml';
        return Response.ok(
          xmlResponse,
          headers: {'content-type': xmlContentType},
        );
      } catch (e) {
        print('  JSON→XML conversion failed: $e, returning JSON');
      }
    }

    final jsonResponse = jsonEncode(outputJson);
    print('  Response JSON length: ${jsonResponse.length}');
    return Response.ok(
      jsonResponse,
      headers: {'content-type': 'application/fhir+json'},
    );
  } catch (e, st) {
    print('Error processing forecast: $e\n$st');
    return _operationOutcome('Internal error: $e', 500);
  }
}

/// GET /metadata — minimal CapabilityStatement
Response _handleMetadata(Request request) {
  final cs = {
    'resourceType': 'CapabilityStatement',
    'status': 'active',
    'date': DateTime.now().toIso8601String().substring(0, 10),
    'kind': 'instance',
    'fhirVersion': '4.0.1',
    'format': [
      'application/fhir+json',
      'application/json',
      'application/fhir+xml',
      'application/xml',
    ],
    'implementation': {
      'description': 'Cicada CDSi Immunization Forecasting Engine',
    },
    'rest': [
      {
        'mode': 'server',
        'operation': [
          {
            'name': 'immds-forecast',
            'definition':
                'http://hl7.org/fhir/us/immds/OperationDefinition/immds-forecast',
          },
          {
            'name': 'immds-forecast-who',
            'definition':
                'http://hl7.org/fhir/us/immds/OperationDefinition/immds-forecast',
          },
        ],
      },
    ],
    'software': {
      'name': 'Cicada',
      'version': '0.0.1',
    },
  };
  return Response.ok(
    jsonEncode(cs),
    headers: {'content-type': 'application/fhir+json'},
  );
}

/// GET / — health check
Response _handleRoot(Request request) {
  return Response.ok(
    jsonEncode({
      'name': 'Cicada ImmDS Forecast Server',
      'status': 'ok',
      'fhirVersion': '4.0.1',
      'operations': [
        r'POST /$immds-forecast (CDC/CDSi)',
        r'POST /$immds-forecast-who (WHO EPI)',
      ],
    }),
    headers: {'content-type': 'application/json'},
  );
}

/// Request logging middleware
Middleware _logRequests() {
  return (Handler innerHandler) {
    return (Request request) async {
      print('${request.method} ${request.requestedUri}');
      print('  Headers: ${request.headers}');
      final response = await innerHandler(request);
      print('  -> ${response.statusCode}');
      return response;
    };
  };
}

/// CORS middleware
Middleware _cors() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await innerHandler(request);
      return response.change(headers: _corsHeaders);
    };
  };
}

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Accept',
};

/// Log request/response pairs to /tmp for debugging.
int _logCount = 0;
void _logOnce(String label, String content) {
  try {
    File('/tmp/fits_${_logCount}_$label.xml').writeAsStringSync(content);
    if (label == 'response') _logCount++;
  } catch (_) {}
}

/// Return a FHIR OperationOutcome error response
Response _operationOutcome(String message, int statusCode) {
  final oo = {
    'resourceType': 'OperationOutcome',
    'issue': [
      {
        'severity': 'error',
        'code': statusCode >= 500 ? 'exception' : 'invalid',
        'diagnostics': message,
      },
    ],
  };
  return Response(
    statusCode,
    body: jsonEncode(oo),
    headers: {'content-type': 'application/fhir+json'},
  );
}
