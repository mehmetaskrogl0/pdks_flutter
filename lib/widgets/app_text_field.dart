import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Etiketli metin giriş alanı (React Native'deki Text + TextInput ikilisi).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onSubmitted: onSubmitted,
          autocorrect: !obscure && keyboardType != TextInputType.emailAddress,
          enableSuggestions: !obscure,
          style: const TextStyle(fontSize: 15, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.muted),
            filled: true,
            fillColor: AppColors.surfaceSecondary,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.brand),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color),
      );
}
