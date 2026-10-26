import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

/// Girişten sonra açılan profil ekranı ve "Çıkış Yap" butonu
/// (React Native sürümündeki `app/(tabs)/profile.tsx`).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    // Token silinir, kullanıcı null olur; AuthGate otomatik olarak
    // giriş ekranını gösterir.
    await context.read<AuthProvider>().logout();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      key: const Key('profile-screen'),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _ProfileHero(user: user),
            const SizedBox(height: AppSpacing.lg),
            _InfoRow(
              icon: Icons.person,
              label: 'Ad Soyad',
              value: user.fullName,
            ),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.mail,
              label: 'E-posta',
              value: user.email,
            ),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.badge,
              label: 'Rol',
              value: user.isAdmin ? 'Yönetici' : 'Çalışan',
            ),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Icons.business,
              label: 'İş Yeri',
              value: user.workplaceId != null
                  ? '#${user.workplaceId}'
                  : 'Atanmamış',
            ),
            const SizedBox(height: AppSpacing.lg),
            Material(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: InkWell(
                key: const Key('logout-button'),
                borderRadius: BorderRadius.circular(AppRadius.md),
                onTap: () => _logout(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 18, color: AppColors.error),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Çıkış Yap',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.brandTertiary,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.brand,
              shape: BoxShape.circle,
              boxShadow: AppShadows.strong,
            ),
            child: Text(
              user.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.brand,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              user.isAdmin ? 'Yönetici' : 'Çalışan',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.brandTertiary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.brand),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
