import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final FormFieldErrorBuilder? errorBuilder;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onChanged,
    this.enabled = true,
    this.errorBuilder,
    this.focusNode,
  });

  static Widget defaultErrorBuilder(BuildContext context, String errorText) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: FaIcon(
              FontAwesomeIcons.circleExclamation,
              size: 12,
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              errorText,
              style: AppTextStyles.error,
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final GlobalKey<FormFieldState<String>> _fieldKey =
      GlobalKey<FormFieldState<String>>();
  bool _hasBeenValidated = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _hasBeenValidated = false;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    // Re-validate only if validation was already triggered on this particular field
    if (_hasBeenValidated || (_fieldKey.currentState?.hasError ?? false)) {
      _hasBeenValidated = true;
      if (WidgetsBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _fieldKey.currentState?.didChange(widget.controller.text);
            _fieldKey.currentState?.validate();
          }
        });
      } else {
        _fieldKey.currentState?.didChange(widget.controller.text);
        _fieldKey.currentState?.validate();
      }
    }
  }

  String? _validate(String? value) {
    _hasBeenValidated = true;
    final text = widget.controller.text;
    return widget.validator?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: _fieldKey,
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: _validate,
          autovalidateMode: widget.autovalidateMode,
          inputFormatters: widget.inputFormatters,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          style: AppTextStyles.bodyMedium,
          errorBuilder: widget.errorBuilder ?? AppTextField.defaultErrorBuilder,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
