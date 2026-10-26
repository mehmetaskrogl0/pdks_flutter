import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Ana işlem butonu (Giriş Yap / Hesap Oluştur).
/// [busy] true iken buton pasif olur ve [busyText] gösterilir.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.busy = false,
    this.busyText,
  });

  final String text;
  final String? busyText;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.strong,
      ),
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: AppColors.onBrand,
          disabledBackgroundColor: AppColors.brand.withValues(alpha: 0.85),
          disabledForegroundColor: AppColors.onBrand,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (busy) ...[
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onBrand,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              busy ? (busyText ?? text) : text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
