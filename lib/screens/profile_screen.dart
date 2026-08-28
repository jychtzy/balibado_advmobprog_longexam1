import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/post.dart';
import '../providers/auth_provider.dart';
import '../services/post_service.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_info.dart';
import '../widgets/post_card.dart';
import 'detail_screen.dart';
import 'settings_screen.dart';

/// Profile tab: shows the logged-in user's info and renders their
/// posts by userID via GET https://dummyjson.com/posts/user/{id}
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PostService _postService = PostService();
  Future<List<PostModel>>? _postsFuture;
  int? _loadedForUserId;

  void _ensurePostsLoaded(int userId) {
    if (_loadedForUserId != userId) {
      _loadedForUserId = userId;
      _postsFuture = _postService.getPostsByUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final theme = Theme.of(context); // Used to adapt colors to Light/Dark mode

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not signed in')),
      );
    }

    _ensurePostsLoaded(user.id);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Profile', style: CustomFont.heading(size: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            splashRadius: 24,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _postsFuture = _postService.getPostsByUser(user.id);
          });
          await _postsFuture;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // --- PROFILE HEADER ---
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withOpacity(0.3), 
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.accent.withOpacity(0.1),
                    backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
                    child: user.image.isEmpty
                        ? Text(
                            user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: CustomFont.heading(size: 22),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: CustomFont.caption(size: 14).copyWith(
                    color: theme.hintColor, // Adapts safely to dark/light mode
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 28),

            // --- USER INFO CARD ---
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.dividerColor), // Uses theme border color
              ),
              // Removed hardcoded background color so it uses the Theme's Card color
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomInfo(
                      icon: Icons.email_outlined, 
                      label: 'Email', 
                      value: user.email,
                    ),
                    if (user.phone != null) ...[
                      const Divider(height: 24, thickness: 0.5),
                      CustomInfo(
                        icon: Icons.phone_outlined, 
                        label: 'Phone', 
                        value: user.phone!,
                      ),
                    ],
                    if (user.university != null) ...[
                      const Divider(height: 24, thickness: 0.5),
                      CustomInfo(
                        icon: Icons.school_outlined,
                        label: 'University',
                        value: user.university!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // --- POSTS SECTION ---
            Text(
              'Posts by ${user.firstName}',
              style: CustomFont.heading(size: 18),
            ),
            const SizedBox(height: 12),
            
            FutureBuilder<List<PostModel>>(
              future: _postsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                  );
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Failed to load posts.\nTap to retry.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  );
                }
                
                final posts = snapshot.data ?? [];
                
                if (posts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No posts yet.',
                        style: TextStyle(color: theme.hintColor, fontSize: 16),
                      ),
                    ),
                  );
                }
                
                return Column(
                  children: posts.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PostCard(
                      post: p,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailScreen(post: p)),
                      ),
                    ),
                  )).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}