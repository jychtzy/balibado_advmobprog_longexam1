import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';
import 'signin_screen.dart';

/// User-preference settings screen: dark mode toggle, notification
/// toggle, and Sign Out button that clears the shared_preferences
/// session and returns to SigninScreen (Enhancement 2).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled =
          prefs.getBool(AppConstants.prefNotificationsEnabled) ?? true;
    });
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefNotificationsEnabled, value);
  }

  Future<void> _handleSignOut() async {
    final confirmed = await CustomDialogs.confirmSignOut(context);
    if (!confirmed) return;

    if (!mounted) return;
    await context.read<AuthProvider>().signOut();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SigninScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: CustomFont.heading(size: 20))),
      body: ListView(
        children: [
          if (user != null)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.accent,
                backgroundImage:
                    user.image.isNotEmpty ? NetworkImage(user.image) : null,
              ),
              title: Text(user.fullName),
              subtitle: Text(user.email),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('Preferences', style: CustomFont.subheading(size: 14)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            subtitle: const Text('Switch between light and dark theme'),
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleDarkMode,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Enable push notifications'),
            value: _notificationsEnabled,
            onChanged: _setNotifications,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleSignOut,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
