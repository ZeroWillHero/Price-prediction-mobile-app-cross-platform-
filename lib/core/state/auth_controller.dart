import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_models.dart';
import '../network/vege_predict_api.dart';

class AuthController extends ChangeNotifier {
  AuthController({VegePredictApi? api}) : _api = api ?? VegePredictApi();

  static const String _tokenKey = 'auth_token';

  final VegePredictApi _api;

  bool _isRestoring = true;
  bool _isSubmitting = false;
  String? _token;
  UserOut? _user;
  String? _errorMessage;

  bool get isRestoring => _isRestoring;
  bool get isSubmitting => _isSubmitting;
  bool get isAuthenticated => _token != null && _user != null;
  UserOut? get user => _user;
  String? get errorMessage => _errorMessage;

  /// Restores a previously saved session, if any. Called once at app start.
  Future<void> restore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString(_tokenKey);
    if (token != null) {
      try {
        final UserOut user = await _api.me(token);
        _token = token;
        _user = user;
      } catch (_) {
        await prefs.remove(_tokenKey);
      }
    }
    _isRestoring = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final TokenOut token = await _api.login(email, password);
      final UserOut user = await _api.me(token.accessToken);
      _token = token.accessToken;
      _user = user;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token.accessToken);
      _isSubmitting = false;
      notifyListeners();
      return true;
    } on UnauthorizedException {
      _errorMessage = 'Incorrect email or password.';
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
    }
    _isSubmitting = false;
    notifyListeners();
    return false;
  }

  /// Creates a farmer account, then logs in with the same credentials.
  /// Note: `POST /users` requires an admin/superadmin bearer token per the
  /// API contract, and this is called with none — it will fail with a 401
  /// until the backend exposes a public signup path.
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _api.createUser(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      return login(email, password);
    } on EmailInUseException catch (e) {
      _errorMessage = e.message;
    } on UnauthorizedException {
      _errorMessage = 'Sign-up isn\'t open yet — ask an admin to create your account.';
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
    }
    _isSubmitting = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
