import 'package:fhir_auth_core/fhir_auth_core.dart';
import 'package:http/http.dart' as http;

/// The app's SMART client ID, from `--dart-define=CICADA_CLIENT_ID=...`.
const String cicadaClientId = String.fromEnvironment('CICADA_CLIENT_ID');

/// The FHIR servers cicada will sign in to. The launch address names the
/// server (`iss`), and anyone can write a launch address: an `iss` naming
/// another server would send the sign-in, and then the chart read, there.
/// Any server not listed is refused.
const Set<String> allowedIssuers = {
  'https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4',
};

/// What the page address asks for.
enum LaunchRequest {
  /// No SMART parameters: not opened by an EHR or a sign-in.
  none,

  /// `iss` (with `launch` from an EHR, without it for a standalone launch):
  /// start the sign-in.
  begin,

  /// `state`: the authorization server sent the page back; finish it.
  finish,
}

/// Which step [address] is.
LaunchRequest launchRequestOf(Uri address) {
  final query = address.queryParameters;
  if (query.containsKey('state')) return LaunchRequest.finish;
  if (query.containsKey('iss')) return LaunchRequest.begin;
  return LaunchRequest.none;
}

/// A finished sign-in: a client that signs its requests, the server and the
/// patient the EHR has open.
class EhrSession {
  const EhrSession({
    required this.client,
    required this.fhirBase,
    required this.patientId,
  });

  final SmartFhirClient client;
  final Uri fhirBase;
  final String patientId;
}

/// A sign-in that cannot go on.
class EhrSignInException implements Exception {
  const EhrSignInException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Starts and finishes the same-window SMART sign-in in [window].
class EhrSignIn {
  EhrSignIn({
    required this.window,
    this.clientId = cicadaClientId,
    this.httpClient,
  });

  final BrowserWindow window;
  final String clientId;

  /// For tests; a real client otherwise.
  final http.Client? httpClient;

  /// Build the authorization request for the launch in the page address and
  /// send the page to it.
  Future<void> begin() async {
    final address = window.location;
    final query = address.queryParameters;
    final iss = query['iss'];
    if (iss == null || !allowedIssuers.contains(iss)) {
      throw EhrSignInException('Cicada does not sign in to $iss.');
    }
    if (clientId.isEmpty) {
      throw const EhrSignInException(
        'This build has no client ID (CICADA_CLIENT_ID).',
      );
    }
    final launch = query['launch'];
    final config = SmartConfig(
      fhirBaseUrl: Uri.parse(iss),
      clientId: clientId,
      redirectUri: Uri.parse('${address.origin}/callback.html'),
      launchType: launch == null ? LaunchType.standalone : LaunchType.ehr,
      launchToken: launch,
      iss: iss,
      audience: iss,
    );
    final url = await SmartFhirClient(
      config: config,
      tokenStorage: const _NoTokensBeforeSignIn(),
      httpClient: httpClient,
    ).beginRedirectLogin(store: window.sessionStorage);
    window.assign(url);
  }

  /// Finish the sign-in the authorization server sent the page back from,
  /// or rebuild it after a reload.
  Future<EhrSession> finish() async {
    final address = window.location;
    final error = address.queryParameters['error'];
    if (error != null) {
      final description = address.queryParameters['error_description'];
      throw EhrSignInException(
        'The sign-in was refused: $error'
        '${description == null ? '' : ' ($description)'}.',
      );
    }
    final client = await SmartFhirClient.completeRedirectLogin(
      callbackUrl: address,
      store: window.sessionStorage,
      httpClient: httpClient,
    );
    // Drop the spent code from the address and keep the tab's id.
    window.replaceUrl(SmartFhirClient.redirectCallbackUrlToKeep(address));
    final patientId = (await client.getStoredTokens())?.patientContext;
    if (patientId == null) {
      throw const EhrSignInException(
        'The sign-in finished without a patient in context.',
      );
    }
    return EhrSession(
      client: client,
      fhirBase: client.smartConfig!.fhirBaseUrl,
      patientId: patientId,
    );
  }
}

/// The storage given to the client that only starts the sign-in.
///
/// fhir_auth_core's `SmartFhirClient` requires a token storage, but
/// `beginRedirectLogin` keeps its login record in the window's session
/// storage and holds no tokens: the tokens come later, in the client
/// `completeRedirectLogin` builds over the tab's own storage. Any use of
/// this one is a mistake, so it says so instead of keeping anything.
class _NoTokensBeforeSignIn implements TokenStorage {
  const _NoTokensBeforeSignIn();

  Never _used(String call) => throw StateError(
    'Token storage $call before the sign-in finished: starting the sign-in '
    'keeps no tokens.',
  );

  @override
  Future<void> saveTokens(SmartTokenResponse tokens) async =>
      _used('saveTokens');

  @override
  Future<SmartTokenResponse?> loadTokens() async => _used('loadTokens');

  @override
  Future<void> clearTokens() async => _used('clearTokens');

  @override
  Future<void> saveAuthState(AuthState state) async => _used('saveAuthState');

  @override
  Future<AuthState?> loadAuthState() async => _used('loadAuthState');

  @override
  Future<bool> hasTokens() async => _used('hasTokens');
}
