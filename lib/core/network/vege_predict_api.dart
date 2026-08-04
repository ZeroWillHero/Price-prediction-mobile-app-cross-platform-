import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_models.dart';

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thrown by [VegePredictApi.login]/[VegePredictApi.me] on a 401 — invalid
/// credentials or an expired/invalid token.
class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message);
}

/// Thrown by [VegePredictApi.createUser] on a 409 — the email is already
/// registered.
class EmailInUseException extends ApiException {
  EmailInUseException(super.message);
}

/// Thin client for the VegePredict REST API (see project CLAUDE.md for the
/// endpoint contract). All reads are pre-computed server-side and cached, so
/// this client just fetches and decodes JSON — no local caching here.
class VegePredictApi {
  VegePredictApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? 'http://3.111.37.80';

  final http.Client _client;
  final String _baseUrl;
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<String>> listVegetables() async {
    final dynamic body = await _getJson('/vegetables');
    return (body as List<dynamic>).cast<String>();
  }

  Future<ForecastOut> latestPrediction(String vegetable) async {
    final dynamic body = await _getJson('/predictions/$vegetable');
    return ForecastOut.fromJson(body as Map<String, dynamic>);
  }

  Future<List<ForecastOut>> futurePredictions(String vegetable) async {
    final dynamic body = await _getJson('/predictions/$vegetable/future');
    return (body as List<dynamic>)
        .map((dynamic row) => ForecastOut.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<HistoricalPriceOut>> priceHistory(
    String vegetable, {
    int limit = 1000,
  }) async {
    final dynamic body =
        await _getJson('/prices/$vegetable/history?limit=$limit');
    return (body as List<dynamic>)
        .map((dynamic row) => HistoricalPriceOut.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<ModelMetricOut>> models({String? vegetable}) async {
    final String query = vegetable != null ? '?vegetable=$vegetable' : '';
    final dynamic body = await _getJson('/models$query');
    return (body as List<dynamic>)
        .map((dynamic row) => ModelMetricOut.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<TokenOut> login(String email, String password) async {
    final dynamic body = await _postJson('/auth/login', <String, dynamic>{
      'email': email,
      'password': password,
    });
    return TokenOut.fromJson(body as Map<String, dynamic>);
  }

  Future<UserOut> me(String token) async {
    final dynamic body = await _getJson('/auth/me', token: token);
    return UserOut.fromJson(body as Map<String, dynamic>);
  }

  /// Creates a new `farmer` account. Per the API contract this requires an
  /// admin/superadmin bearer token — called here with none, as requested, so
  /// it will fail with 401 until the backend exposes a public signup path.
  Future<UserOut> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final dynamic body = await _postJson('/users', <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'role': 'farmer',
    });
    return UserOut.fromJson(body as Map<String, dynamic>);
  }

  Future<dynamic> _getJson(String path, {String? token}) async {
    final Uri uri = Uri.parse('$_baseUrl$path');
    late final http.Response response;
    try {
      response = await _client
          .get(uri, headers: _headers(token))
          .timeout(_timeout);
    } catch (_) {
      throw ApiException('Could not reach the server. Check your connection.');
    }
    return _decode(response);
  }

  Future<dynamic> _postJson(String path, Map<String, dynamic> body) async {
    final Uri uri = Uri.parse('$_baseUrl$path');
    late final http.Response response;
    try {
      response = await _client
          .post(uri, headers: _headers(null), body: jsonEncode(body))
          .timeout(_timeout);
    } catch (_) {
      throw ApiException('Could not reach the server. Check your connection.');
    }
    return _decode(response);
  }

  Map<String, String> _headers(String? token) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException('Incorrect email or password.');
    }
    if (response.statusCode == 409) {
      throw EmailInUseException('An account with this email already exists.');
    }
    if (response.statusCode == 404) {
      throw ApiException('No data found for this request.');
    }
    if (response.statusCode >= 400) {
      throw ApiException('Server error (${response.statusCode}).');
    }
    return jsonDecode(response.body);
  }
}
