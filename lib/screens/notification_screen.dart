import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_font.dart';

/// Notifications tab. dummyjson.com has no notifications endpoint, so
/// this screen renders a small set of sample local notifications,
/// styled to resemble the Facebook notifications list. Colors are
/// pulled from the app's existing ThemeProvider / AppColors via
/// [_Palette.of].
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const List<_NotificationItem> _newNotifications = [
    _NotificationItem(
      title: 'Welcome to Facebook!',
      subtitle: 'Thanks for signing in. Check out the newsfeed.',
      time: '2h',
      icon: Icons.celebration,
      iconColor: Color(0xFFF7B928),
      unread: true,
    ),
    _NotificationItem(
      title: 'New comment on your post',
      subtitle: 'Someone replied to one of your posts.',
      time: '4h',
      icon: Icons.mode_comment,
      iconColor: AppColors.primary,
      unread: true,
    ),
  ];

  static const List<_NotificationItem> _earlierNotifications = [
    _NotificationItem(
      title: 'Weekly digest',
      subtitle: 'See what you missed this week.',
      time: '2d',
      icon: Icons.article,
      iconColor: AppColors.success,
      unread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    final hasAny = _newNotifications.isNotEmpty || _earlierNotifications.isNotEmpty;

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 20,
        title: Text(
          'Notifications', 
          style: CustomFont.heading(size: 24).copyWith(color: p.textPrimary),
        ),
        actions: [
          IconButton(
            splashRadius: 24,
            icon: Icon(Icons.more_horiz, color: p.textPrimary), 
            onPressed: () {}
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: !hasAny
          ? _buildEmptyState(p)
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 32, top: 8),
              children: [
                _buildSearchBar(p),
                const SizedBox(height: 12),
                if (_newNotifications.isNotEmpty) ...[
                  const _SectionHeader(label: 'New'),
                  ..._newNotifications.map((n) => _NotificationTile(item: n)),
                ],
                if (_earlierNotifications.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const _SectionHeader(label: 'Earlier'),
                  ..._earlierNotifications.map((n) => _NotificationTile(item: n)),
                ],
              ],
            ),
    );
  }

  Widget _buildSearchBar(_Palette p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // Uses the theme's divider color for a very subtle, mode-safe background
          color: p.divider.withOpacity(0.3), 
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: p.textSecondary),
            const SizedBox(width: 12),
            Text(
              'Search notifications', 
              style: CustomFont.body(size: 15).copyWith(color: p.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(_Palette p) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: p.divider.withOpacity(0.2),
              ),
              child: Icon(Icons.notifications_none_rounded, size: 48, color: p.iconInactive),
            ),
            const SizedBox(height: 24),
            Text(
              "You're all caught up", 
              style: CustomFont.heading(size: 18).copyWith(color: p.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'New notifications will show up here.',
              style: CustomFont.body(size: 14).copyWith(color: p.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool unread;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.unread,
  });
}

class _SectionHeader extends StatelessWidget {
  final String label;

  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        label, 
        style: CustomFont.heading(size: 18).copyWith(color: p.textPrimary),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16), // Gives the ripple effect rounded corners
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // Soft background tint if unread, completely transparent if read
            color: item.unread ? p.primary.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 28, // Slightly larger for better modern look
                    backgroundColor: p.divider.withOpacity(0.3),
                    child: Icon(Icons.person, color: p.textSecondary, size: 30),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: item.iconColor,
                        shape: BoxShape.circle,
                        // Uses the scaffold background to cleanly "cut out" the badge from the avatar
                        border: Border.all(color: p.background, width: 2.5),
                      ),
                      child: Icon(item.icon, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: CustomFont.body(size: 15).copyWith(
                        color: p.textPrimary,
                        fontWeight: item.unread ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle, 
                      style: CustomFont.body(size: 13).copyWith(
                        color: p.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.time,
                      style: CustomFont.caption(size: 12).copyWith(
                        color: item.unread ? p.primary : p.textSecondary, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.unread)
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 8, left: 8),
                  decoration: BoxDecoration(
                    color: p.primary, 
                    shape: BoxShape.circle,
                  ),
                ),
            ],
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
  final Color background;
  final Color surface;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color iconInactive;

  const _Palette({
    required this.background,
    required this.surface,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.iconInactive,
  });

  factory _Palette.of(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return _Palette(
      background: theme.scaffoldBackgroundColor,
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      primary: cs.primary,
      textPrimary: cs.onSurface,
      textSecondary: cs.onSurfaceVariant,
      divider: cs.outlineVariant,
      iconInactive: cs.onSurfaceVariant,
    );
  }
}