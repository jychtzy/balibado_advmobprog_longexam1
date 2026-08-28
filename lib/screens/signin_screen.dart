import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_textformfield.dart';
import 'home_screen.dart';

/// Sign-in screen. Authenticates against POST /user/login
/// (https://dummyjson.com/docs/users) via [AuthProvider]. On success the
/// session is written to shared_preferences and the user is routed to
/// [HomeScreen]. Styled to resemble the Facebook login screen, with
/// colors pulled from the app's existing ThemeProvider / AppColors via
/// [_Palette.of] (no separate theme file, follows light/dark mode).
///
/// Any valid username/password pair from https://dummyjson.com/users
/// works, e.g. username: emilys / password: emilyspass.
class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      CustomDialogs.showError(
        context,
        authProvider.errorMessage ?? 'Unable to sign in',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: p.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                // Facebook logo mark.
                Icon(Icons.facebook, size: 72, color: p.primary),
                const SizedBox(height: 8),
                Text(
                  'facebook',
                  style: CustomFont.heading(size: 34).copyWith(
                    color: p.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with friends and the world around you.',
                  textAlign: TextAlign.center,
                  style: CustomFont.body(size: 14).copyWith(color: p.textSecondary),
                ),
                const SizedBox(height: 36),
                CustomTextFormField(
                  controller: _usernameController,
                  label: 'Username',
                  prefixIcon: Icons.person_outline,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Username is required' : null,
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  // Functional: toggles password visibility.
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Password is required' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  // Functional: calls the real login API via _handleSignIn.
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                // Decorative — no password-reset flow exists, same as before.
                TextButton(
                  onPressed: () {},
                  child: Text('Forgot password?', style: TextStyle(color: p.primary)),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: p.divider),
                const SizedBox(height: 20),
                // Functional: same _handleSignIn, styled as the secondary
                // "Create new account" action Facebook shows below the divider.
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: authProvider.isLoading ? null : _handleSignIn,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: p.primary,
                      side: BorderSide(color: p.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      'Create new account',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Try username "emilys" / password "emilyspass"\n'
                  '(any dummyjson.com/users account works)',
                  textAlign: TextAlign.center,
                  style: CustomFont.caption().copyWith(color: p.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small color bundle derived from the app's existing theme
/// (set up in ThemeProvider / AppColors) so this screen can pull
/// consistent light/dark colors without a separate theme file.
class _Palette {
  final Color surface;
  final Color primary;
  final Color textSecondary;
  final Color divider;

  const _Palette({
    required this.surface,
    required this.primary,
    required this.textSecondary,
    required this.divider,
  });

  factory _Palette.of(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return _Palette(
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      // cs.primary is AppColors.primary in light mode and AppColors.secondary
      // in dark mode, matching the seeds ThemeProvider already uses.
      primary: cs.primary,
      textSecondary: cs.onSurfaceVariant,
      divider: cs.outlineVariant,
    );
  }
}