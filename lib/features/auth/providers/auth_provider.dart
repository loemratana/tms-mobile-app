import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';
import '../models/register_request.dart';
import '../models/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  bool get isLoading => status == AuthStatus.loading;
}

/// Holds the auth state that the screens watch.
///
/// Each action returns `true` on success. On failure it returns `false`
/// and puts the reason in [AuthState.errorMessage].
class AuthNotifier extends Notifier<AuthState> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthState build() => const AuthState();

  /// Called once at app start to restore a previous session.
  Future<void> checkAuthStatus() async {
    try {
      if (!await _repository.hasSavedSession()) {
        state = const AuthState(status: AuthStatus.unauthenticated);
        return;
      }
      final user = await _repository.getCurrentUser();
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (_) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final user = await _repository.login(email: email, password: password);
      state = AuthState(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> register(RegisterRequest request) {
    return _runRequest(() => _repository.register(request));
  }

  Future<bool> verifyEmail(String code) {
    return _runRequest(() => _repository.verifyEmail(code));
  }

  Future<bool> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) {
    return _runRequest(
      () => _repository.resetPassword(
        token: token,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  /// Runs a request that does not log the user in, such as register.
  /// The user still has to log in afterwards.
  Future<bool> _runRequest(Future<void> Function() request) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await request();
      state = const AuthState(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      _showError(e);
      return false;
    }
  }

  void _showError(Object error) {
    final message = error is ApiException
        ? error.message
        : 'Something went wrong. Please try again.';
    state = AuthState(status: AuthStatus.error, errorMessage: message);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
