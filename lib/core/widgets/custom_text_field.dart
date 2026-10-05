import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hint,
    this.type = TextInputType.text,
    this.prefix,
    this.suffix,
    this.controller,
    this.validator,
    this.onChange,
    this.onFieldSubmitted,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
    this.fillColor,
    this.borderColor,
    this.inputFormatters,
    this.autofocus = false,
    this.borderRadius = 50,
  });

  final String hint;
  final TextInputType type;

  final Widget? prefix;
  final Widget? suffix;

  final TextEditingController? controller;
  final String? Function(String?)? validator;

  final void Function(String)? onChange;
  final void Function(String)? onFieldSubmitted;

  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  final bool enabled;
  final bool autofocus;

  final Color? fillColor;
  final Color? borderColor;

  final List<TextInputFormatter>? inputFormatters;

  final double borderRadius;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showPassword = false;

  bool get _isPassword => widget.type == TextInputType.visiblePassword;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? AppColors.black10;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: BorderSide(color: borderColor, width: 1),
    );

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,

      keyboardType: widget.type,
      textInputAction: widget.textInputAction,

      validator: widget.validator,
      onChanged: widget.onChange,
      onFieldSubmitted: widget.onFieldSubmitted,

      inputFormatters: widget.inputFormatters,

      obscureText: _isPassword && !_showPassword,

      style: const TextStyle(fontSize: 15, color: AppColors.black),

      decoration: InputDecoration(
        hintText: widget.hint,

        hintStyle: const TextStyle(fontSize: 15, color: AppColors.black40),

        filled: true,
        fillColor: widget.fillColor ?? Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),

        prefixIcon: widget.prefix,

        suffixIcon:
            widget.suffix ??
            (_isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.black40,
                      size: 20,
                    ),
                  )
                : null),

        border: border,
        enabledBorder: border,

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
