import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/social_icons.dart';

enum SocialLogin { apple, google, facebook }

/// The whole login page UI: animation on top, then a white sheet with the
/// header, form and social login buttons.
///
/// It only shows the UI and validates input. What happens on submit or on
/// a tap is decided by the screen through the callbacks.
class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    required this.isLoading,
    required this.onSubmit,
    required this.onForgotPassword,
    required this.onSignUp,
    required this.onSocialLogin,
  });

  final bool isLoading;
  final void Function(String email, String password) onSubmit;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;
  final void Function(SocialLogin provider) onSocialLogin;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_emailController.text.trim(), _passwordController.text);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // The sheet always keeps its full size, and the animation only takes the
    // space that is left above it. When the keyboard opens there is no space
    // left, so the animation shrinks away and the page becomes scrollable.
    return ColoredBox(
      color: AppColors.primaryLight,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(child: _buildAnimation()),
                  _buildContentSheet(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    // Positioned.fill keeps the Lottie from asking for its own (large)
    // height, so it just fills whatever space the Column gives it.
    return Stack(
      children: [
        Positioned.fill(
          child: Lottie.asset(
            'assets/lotties/Online shopping  Black Friday.json',
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildContentSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _buildForm(),
          const SizedBox(height: 24),
          _buildSocialLogin(),
          const SizedBox(height: 8),
          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _emailController,
            hint: 'Email',
            type: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _passwordController,
            hint: 'Password',
            type: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              child: const Text('Forgot password?'),
            ),
          ),

          AppButton(
            label: 'Log In',
            isLoading: widget.isLoading,
            onPressed: _submit,
            backgroundColor: AppColors.primary,
            width: double.infinity,
            height: 52,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: AppColors.black10)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'or continue with',
                style: TextStyle(color: AppColors.black60),
              ),
            ),

            Expanded(child: Divider(color: AppColors.black10)),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildSocialButton(AppImages.apple, SocialLogin.apple),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSocialButton(AppImages.google, SocialLogin.google),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSocialButton(
                AppImages.facebook,
                SocialLogin.facebook,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String image, SocialLogin provider) {
    return SocialIcons(
      assetPath: image,
      onTap: () => widget.onSocialLogin(provider),
    );
  }

  Widget _buildSignUpLink() {
    // Wrap instead of Row, so on narrow screens "Sign up" moves to a second
    // line instead of overflowing.
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: AppColors.black60),
        ),
        TextButton(onPressed: widget.onSignUp, child: const Text('Sign up')),
      ],
    );
  }
}
