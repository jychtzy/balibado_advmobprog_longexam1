import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/post_card.dart';
import 'detail_screen.dart';

/// Home tab: renders the global feed of posts from
/// https://dummyjson.com/docs/posts.
/// Redesigned with a premium, sleek card-based interface.
/// Colors are pulled from the app's existing ThemeProvider via [_Palette.of].
class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({super.key});

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  final PostService _postService = PostService();
  late Future<List<PostModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _postService.getAllPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      _postsFuture = _postService.getAllPosts();
    });
    await _postsFuture;
  }

  PreferredSizeWidget _buildAppBar(_Palette p) {
    return AppBar(
      backgroundColor: p.background, // Blends seamlessly into the background
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleSpacing: 20,
      title: Text(
        'Newsfeed',
        style: CustomFont.heading(size: 26).copyWith(
          color: p.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: p.textPrimary, size: 26),
          splashRadius: 24,
          onPressed: () {},
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: Icon(Icons.chat_bubble_outline_rounded, color: p.textPrimary, size: 24),
          splashRadius: 24,
          onPressed: () {},
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildComposer(_Palette p) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.divider.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: p.divider.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: p.primary.withOpacity(0.1),
                child: Icon(Icons.person, color: p.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: p.background, // Deeper contrast against the surface card
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Share what's on your mind...",
                      style: CustomFont.body(size: 15).copyWith(color: p.textSecondary),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ComposerAction(
                icon: Icons.image_outlined,
                iconColor: const Color(0xFF45BD62),
                label: 'Photo',
                onTap: () {},
              ),
              _ComposerAction(
                icon: Icons.videocam_outlined,
                iconColor: const Color(0xFFF3425F),
                label: 'Video',
                onTap: () {},
              ),
              _ComposerAction(
                icon: Icons.sentiment_satisfied_alt_rounded,
                iconColor: const Color(0xFFF7B928),
                label: 'Feeling',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(_Palette p) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3,
      itemBuilder: (context, index) => const _PostSkeleton(),
    );
  }

  Widget _buildError(_Palette p, Object? error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 56, color: p.divider),
          const SizedBox(height: 20),
          Text(
            "Couldn't load your feed",
            style: CustomFont.heading(size: 18).copyWith(color: p.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: CustomFont.body(size: 14).copyWith(color: p.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: p.textPrimary, // High-contrast modern button
              foregroundColor: p.surface,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(Icons.refresh, size: 20, color: p.surface),
            label: Text('Try Again', style: CustomFont.body(size: 15).copyWith(color: p.surface, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(_Palette p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dynamic_feed_outlined, size: 56, color: p.divider),
          const SizedBox(height: 20),
          Text(
            'No posts found',
            style: CustomFont.heading(size: 18).copyWith(color: p.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh your feed.',
            style: CustomFont.body(size: 14).copyWith(color: p.textSecondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      appBar: _buildAppBar(p),
      body: RefreshIndicator(
        color: p.primary,
        backgroundColor: p.surface,
        onRefresh: _refresh,
        child: FutureBuilder<List<PostModel>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _buildComposer(p),
                  _buildLoadingSkeleton(p),
                ],
              );
            }
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildComposer(p),
                  _buildError(p, snapshot.error),
                ],
              );
            }
            final posts = snapshot.data ?? [];
            if (posts.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildComposer(p),
                  _buildEmpty(p),
                ],
              );
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return _buildComposer(p);
                
                final post = posts[index - 1];
                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: p.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: p.divider.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: p.divider.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  // ClipRRect ensures the PostCard respects the nice new rounded corners
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PostCard(
                      post: post,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DetailScreen(post: post)),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ComposerAction extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ComposerAction({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: CustomFont.body(size: 14).copyWith(
                color: p.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostSkeleton extends StatelessWidget {
  const _PostSkeleton();

  Widget _bar(_Palette p, {double width = double.infinity, double height = 12}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: p.divider.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: p.divider.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: p.divider.withOpacity(0.15), 
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bar(p, width: 120, height: 12),
                    const SizedBox(height: 8),
                    _bar(p, width: 80, height: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _bar(p, height: 12),
          const SizedBox(height: 10),
          _bar(p, width: 220, height: 12),
          const SizedBox(height: 20),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: p.divider.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
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