import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/login_view.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _login(
    BuildContext context,
    WidgetRef ref,
    String email,
    String password,
  ) async {
    final auth = ref.read(authProvider.notifier);
    final success = await auth.login(email: email, password: password);
    if (!context.mounted) return;

    if (success) {
      context.go('/products');
    } else {
      final error = ref.read(authProvider).errorMessage ?? 'Login failed.';
      _showMessage(context, error);
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: LoginView(
          isLoading: isLoading,
          onSubmit: (email, password) => _login(context, ref, email, password),
          onForgotPassword: () => context.go('/forgot-password'),
          onSignUp: () => context.go('/register'),
          // The backend has no social login yet.
          onSocialLogin: (_) => _showMessage(context, 'Coming soon.'),
        ),
      ),
    );
  }
}
