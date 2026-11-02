import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import 'custom_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      prefixIcon: widget.prefixIcon,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
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
