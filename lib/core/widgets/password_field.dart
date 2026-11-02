import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import 'app_text_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final FormFieldErrorBuilder? errorBuilder;

  const PasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onFieldSubmitted,
    this.enabled = true,
    this.errorBuilder,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      prefixIcon: widget.prefixIcon,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      errorBuilder: widget.errorBuilder,
      suffixIcon: IconButton(
        icon: FaIcon(
          _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
          color: AppColors.textMuted,
          size: 16,
        ),
        onPressed: _toggleVisibility,
      ),
    );
  }
}
