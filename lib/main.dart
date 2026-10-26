import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..init(),
      child: const PdksApp(),
    ),
  );
}

class PdksApp extends StatelessWidget {
  const PdksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atlas PDKS',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthGate(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
      },
    );
  }
}

/// Oturum durumuna göre hangi ekranın gösterileceğine karar verir
/// (React Native sürümündeki `app/index.tsx`).
///  - yükleniyor → açılış göstergesi
///  - kullanıcı yok → giriş ekranı
///  - kullanıcı var → profil / ana ekran
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.loading) {
      return const Scaffold(
        key: Key('splash-screen'),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.brand),
        ),
      );
    }

    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
