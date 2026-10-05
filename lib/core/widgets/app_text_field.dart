import 'package:flutter/material.dart';

/// A [TextFormField] with the app's standard decoration and, when
/// [obscureText] is true, a built-in show/hide toggle for password entry.
///
/// ```dart
/// AppTextField(
///   label: 'Password',
///   controller: _passwordController,
///   obscureText: true,
///   validator: (value) =>
///       (value == null || value.isEmpty) ? 'Password is required' : null,
/// )
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Only meaningful when widget.obscureText is true; tracks whether the
  // user has toggled the value into view.
  late bool _obscured = widget.obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      enabled: widget.enabled,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscureText && _obscured,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
    );
  }
}
