import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'signin_screen.dart';

/// First screen shown when the app launches.
/// Reads the persisted session from shared_preferences (via
/// [AuthProvider.restoreSession]) and routes to [HomeScreen] if the
/// user is already logged in, or [SigninScreen] otherwise.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Small delay so the splash branding is actually visible.
    final authProvider = context.read<AuthProvider>();
    final results = await Future.wait([
      authProvider.restoreSession(),
      Future.delayed(const Duration(milliseconds: 900)),
    ]);
    final isLoggedIn = results[0] as bool;

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomeScreen() : const SigninScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/NUCCITLogo_White.png',
              width: 120,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.facebook,
                size: 96,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'FACEBOOK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
