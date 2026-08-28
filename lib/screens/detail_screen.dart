import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../providers/auth_provider.dart';
import '../services/comment_service.dart';
import '../widgets/comment_tile.dart';
import '../widgets/custom_dialogs.dart';
import '../widgets/custom_font.dart';

class DetailScreen extends StatefulWidget {
  final PostModel post;

  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CommentService _commentService = CommentService();
  late Future<List<CommentModel>> _commentsFuture;
  List<CommentModel> _comments = [];
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    _commentsFuture = _commentService.getCommentsByPost(widget.post.id).then((c) {
      _comments = c;
      return c;
    });
  }

  void _toggleLike(CommentModel comment) {
    setState(() => comment.toggleLike());
  }

  Future<void> _handleAddComment() async {
    final text = await CustomDialogs.addCommentDialog(context);
    if (text == null || text.isEmpty) return;

    final currentUser = context.read<AuthProvider>().currentUser;
    setState(() => _isPosting = true);
    try {
      final newComment = await _commentService.addComment(
        body: text,
        postId: widget.post.id,
        userId: currentUser?.id ?? 1,
      );
      setState(() {
        _comments = [newComment, ..._comments];
      });
    } catch (e) {
      if (mounted) CustomDialogs.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  /// Placeholder for sharing functionality
  void _handleShare() {
    // To implement real native sharing, install the 'share_plus' package
    // and use: Share.share('Check out this post: ${widget.post.title}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening share dialog...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final p = _Palette.of(context);
    final currentUser = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: p.background,
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: p.textPrimary),
        title: Text(
          'Post', 
          style: CustomFont.heading(size: 20).copyWith(color: p.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // --- POST CONTENT ---
                Container(
                  color: p.surface,
                  padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title, 
                        style: CustomFont.heading(size: 22).copyWith(
                          color: p.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        post.body, 
                        style: CustomFont.body(size: 16).copyWith(
                          color: p.textPrimary.withOpacity(0.9), // Slightly darker for readability
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Styled Tags
                      if (post.tags.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: post.tags.map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: p.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '#$t', 
                              style: CustomFont.caption(size: 13).copyWith(
                                color: p.primary, 
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )).toList(),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      // Metrics Row (Counts only)
                      Row(
                        children: [
                          Icon(Icons.thumb_up, size: 16, color: p.primary),
                          const SizedBox(width: 6),
                          Text(
                            '${post.reactions.likes}',
                            style: CustomFont.body(size: 14).copyWith(color: p.textSecondary),
                          ),
                          const Spacer(),
                          Text(
                            '${post.views} views',
                            style: CustomFont.body(size: 14).copyWith(color: p.textSecondary),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      Divider(height: 1, color: p.divider.withOpacity(0.5)),
                      
                      // Action Bar (Like, Comment, Share buttons)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(Icons.thumb_up_outlined, 'Like', p, () {
                            // Implement post like logic here if needed
                          }),
                          _buildActionButton(Icons.chat_bubble_outline, 'Comment', p, _handleAddComment),
                          _buildActionButton(Icons.share_outlined, 'Share', p, _handleShare),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Thick feed separator
                Container(height: 8, color: p.background),

                // --- COMMENTS SECTION ---
                Container(
                  color: p.surface,
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Text(
                          'Comments', 
                          style: CustomFont.heading(size: 18).copyWith(color: p.textPrimary),
                        ),
                      ),
                      FutureBuilder<List<CommentModel>>(
                        future: _commentsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(24),
                              child: Center(
                                child: Text(
                                  'Failed to load comments',
                                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                                ),
                              ),
                            );
                          }
                          if (_comments.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'No comments yet. Be the first!',
                                  style: CustomFont.body(size: 15).copyWith(color: p.textSecondary),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: _comments.map((c) => CommentTile(
                                  comment: c,
                                  onLikeTap: () => _toggleLike(c),
                                )).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // --- BOTTOM COMMENT BAR (Facebook Style) ---
          Container(
            decoration: BoxDecoration(
              color: p.surface,
              boxShadow: [
                BoxShadow(
                  color: p.divider.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: p.divider.withOpacity(0.3),
                    backgroundImage: (currentUser != null && currentUser.image.isNotEmpty)
                        ? NetworkImage(currentUser.image)
                        : null,
                    child: (currentUser == null || currentUser.image.isEmpty)
                        ? Icon(Icons.person, color: p.textSecondary, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _isPosting ? null : _handleAddComment,
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: p.divider.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _isPosting ? 'Posting...' : 'Write a comment...',
                                style: CustomFont.body(size: 14).copyWith(
                                  color: p.textSecondary,
                                ),
                              ),
                            ),
                            if (_isPosting)
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: p.primary),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build the Like, Comment, and Share buttons evenly
  Widget _buildActionButton(IconData icon, String label, _Palette p, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: p.iconInactive),
            const SizedBox(width: 6),
            Text(
              label, 
              style: CustomFont.body(size: 14).copyWith(
                color: p.iconInactive, 
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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