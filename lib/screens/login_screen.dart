import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_card.dart';
import '../widgets/primary_button.dart';
import 'register_screen.dart';

/// Giriş ekranı (React Native sürümündeki `app/(auth)/login.tsx`).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _busy = false;
  String _error = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = '');

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'E-posta ve şifre gerekli');
      return;
    }

    setState(() => _busy = true);
    try {
      // Başarılı girişte AuthGate kullanıcıyı otomatik olarak
      // ana ekrana yönlendirir.
      await context.read<AuthProvider>().login(email, password);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xxl,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _BrandHeader(),
                const SizedBox(height: AppSpacing.xl),
                const Text(
                  'Hoş geldiniz',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Konum doğrulamalı çalışan takibi',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                FormCard(
                  children: [
                    AppTextField(
                      key: const Key('login-email-input'),
                      label: 'E-posta',
                      controller: _emailCtrl,
                      hint: 'ornek@sirket.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      key: const Key('login-password-input'),
                      label: 'Şifre',
                      controller: _passwordCtrl,
                      hint: '••••••••',
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    if (_error.isNotEmpty)
                      ErrorText(_error, key: const Key('login-error')),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      key: const Key('login-submit-button'),
                      text: 'Giriş Yap',
                      busyText: 'Giriş yapılıyor…',
                      busy: _busy,
                      onPressed: _handleLogin,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hesabınız yok mu?',
                      style: TextStyle(
                        color: AppColors.onSurfaceSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      key: const Key('goto-register-button'),
                      onTap: () => Navigator.of(context)
                          .pushNamed(RegisterScreen.routeName),
                      child: const Text(
                        ' Kayıt Ol',
                        style: TextStyle(
                          color: AppColors.brand,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Container(
                  key: const Key('admin-hint'),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandTertiary,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user,
                          size: 16, color: AppColors.brand),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Admin: admin@atlaspdks.com / Admin1234!',
                          style: TextStyle(
                            color: AppColors.brand,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Üstteki logo + "Atlas PDKS" yazısı.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.brandTertiary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.business, size: 22, color: AppColors.brand),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Text(
          'Atlas PDKS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.brand,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}
