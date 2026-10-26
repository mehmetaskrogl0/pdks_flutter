import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_text_field.dart';
import '../widgets/form_card.dart';
import '../widgets/primary_button.dart';

/// Kayıt ekranı (React Native sürümündeki `app/(auth)/register.tsx`).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _busy = false;
  String _error = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    setState(() => _error = '');

    final name = _nameCtrl.text.trim();
    final surname = _surnameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Tüm alanlar zorunlu');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Şifre en az 6 karakter olmalı');
      return;
    }

    setState(() => _busy = true);
    try {
      await context
          .read<AuthProvider>()
          .register(name, surname, email, password);
      // Kayıt + otomatik giriş başarılı: ilk ekrana (AuthGate) dön,
      // AuthGate kullanıcıyı ana ekrana yönlendirir.
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
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
          padding: const EdgeInsets.all(AppSpacing.xl),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: AppColors.surfaceSecondary,
                  shape: const CircleBorder(),
                  child: IconButton(
                    key: const Key('back-button'),
                    icon: const Icon(Icons.chevron_left,
                        color: AppColors.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Kayıt Ol',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'Yeni çalışan hesabı oluşturun',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FormCard(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextField(
                          key: const Key('reg-name-input'),
                          label: 'Ad',
                          controller: _nameCtrl,
                          hint: 'Ayşe',
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppTextField(
                          key: const Key('reg-surname-input'),
                          label: 'Soyad',
                          controller: _surnameCtrl,
                          hint: 'Yılmaz',
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('reg-email-input'),
                    label: 'E-posta',
                    controller: _emailCtrl,
                    hint: 'ornek@sirket.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('reg-password-input'),
                    label: 'Şifre',
                    controller: _passwordCtrl,
                    hint: 'En az 6 karakter',
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleRegister(),
                  ),
                  if (_error.isNotEmpty)
                    ErrorText(_error, key: const Key('reg-error')),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    key: const Key('reg-submit-button'),
                    text: 'Hesap Oluştur',
                    busyText: 'Kaydediliyor…',
                    busy: _busy,
                    onPressed: _handleRegister,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Zaten hesabınız var mı?',
                    style: TextStyle(
                      color: AppColors.onSurfaceSecondary,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    key: const Key('goto-login-button'),
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      ' Giriş Yap',
                      style: TextStyle(
                        color: AppColors.brand,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
