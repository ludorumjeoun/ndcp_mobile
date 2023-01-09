import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSubmitted;
  final Widget? prefix;

  final bool obscureText;
  final bool autofocus;
  final bool enabled;

  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.label,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.prefix,
    this.enabled = true,
    this.obscureText = false,
    this.autofocus = false,
  });

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(48),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Theme.of(context).primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      prefixIcon: prefix != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prefix!,
                  const SizedBox(width: 8),
                  const SizedBox(
                      width: 1,
                      height: 16,
                      child: VerticalDivider(color: Colors.white)),
                ],
              ),
            )
          : null,
      hintText: label,
      hintStyle: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      obscureText: obscureText,
      textAlignVertical: TextAlignVertical.center,
      textInputAction: textInputAction,
      decoration: _decoration(context),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
