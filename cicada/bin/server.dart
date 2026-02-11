import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'package:cicada/forecast/forecast.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: '8080');
  final results = parser.parse(args);
  final port =
      int.parse(Platform.environment['PORT'] ?? results['port'] as String);

  final router = Router()
    ..post(r'/$immds-forecast', _handleForecast)
    ..get('/metadata', _handleMetadata)
    ..get('/', _handleRoot);

  final handler =
      const Pipeline().addMiddleware(_cors()).addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  print('Cicada ImmDS server listening on port ${server.port}');
}

/// POST /$immds-forecast — run the forecasting engine
Future<Response> _handleForecast(Request request) async {
  try {
    final body = await request.readAsString();
    if (body.isEmpty) {
      return _operationOutcome('No request body provided', 400);
    }

    final Map<String, dynamic> json;
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      return _operationOutcome('Invalid JSON: $e', 400);
    }

    final output = forecastFromMap(json);
    return Response.ok(
      jsonEncode(output.toJson()),
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
    'format': ['application/fhir+json', 'application/json'],
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
      'operation': r'POST /$immds-forecast',
    }),
    headers: {'content-type': 'application/json'},
  );
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
