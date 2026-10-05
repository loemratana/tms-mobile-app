import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constants/storage_keys.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/user.dart';
import '../services/auth_api_service.dart';

/// The single place the app goes to for anything auth related.
///
/// It calls [AuthApiService] for the network part and keeps the session
/// tokens in secure storage.
class AuthRepository {
  AuthRepository({
    required AuthApiService api,
    FlutterSecureStorage? storage,
  }) : _api = api,
       _storage = storage ?? const FlutterSecureStorage();

  final AuthApiService _api;
  final FlutterSecureStorage _storage;

  /// Logs in, saves the tokens, then returns the logged-in user.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      password: password,
      deviceId: await _getDeviceId(),
      deviceName: LoginRequest.currentDeviceType,
      deviceType: LoginRequest.currentDeviceType,
    );

    final tokens = await _api.login(request);
    await _saveTokens(tokens);
    return _api.getCurrentUser();
  }

  Future<UserModel> register(RegisterRequest request) {
    return _api.register(request);
  }

  Future<UserModel> getCurrentUser() {
    return _api.getCurrentUser();
  }

  /// Always clears the local session, even if the backend call fails.
  Future<void> logout() async {
    try {
      await _api.logout();
    } finally {
      await _clearTokens();
    }
  }

  Future<void> forgotPassword(String email) {
    return _api.forgotPassword(email);
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) {
    return _api.resetPassword(
      token: token,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  Future<void> verifyEmail(String code) {
    return _api.verifyEmail(code);
  }

  Future<bool> hasSavedSession() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    return token != null;
  }

  Future<void> _saveTokens(LoginResponse tokens) async {
    await _storage.write(
      key: StorageKeys.accessToken,
      value: tokens.accessToken,
    );
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: tokens.refreshToken,
    );
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }

  /// Returns this device's id, creating and saving one on first use.
  Future<String> _getDeviceId() async {
    final savedId = await _storage.read(key: StorageKeys.deviceId);
    if (savedId != null) return savedId;

    final newId = 'device_${DateTime.now().millisecondsSinceEpoch}';
    await _storage.write(key: StorageKeys.deviceId, value: newId);
    return newId;
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(api: ref.watch(authApiServiceProvider)),
);
