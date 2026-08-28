import 'package:flutter/material.dart';

import '../models/post.dart';
import 'custom_font.dart';
import 'custom_inkwell_button.dart';

/// Card used to render a single post preview in the newsfeed and on
/// the profile screen's "posts by this user" list.
class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  final VoidCallback? onLikeTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Clean, modern flat look
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)), // Subtle border
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: CustomFont.subheading(size: 17),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: CustomFont.body(size: 14, color: Colors.grey[600]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 14),
              
              // Upgraded, modern tag design
              if (post.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: post.tags
                      .take(3)
                      .map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#$t', 
                              style: const TextStyle(
                                fontSize: 12, 
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                
              const SizedBox(height: 16),
              
              // THE FIX: FittedBox guarantees it will shrink gracefully on small screens instead of overflowing
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    CustomInkwellButton(
                      icon: Icons.thumb_up_alt_outlined,
                      label: '${post.reactions.likes}',
                      onTap: onLikeTap ?? () {},
                    ),
                    const SizedBox(width: 12),
                    CustomInkwellButton(
                      icon: Icons.remove_red_eye_outlined,
                      label: '${post.views}',
                      onTap: () {},
                    ),
                    
                    // Replaced Spacer() with a large SizedBox. 
                    // Spacer() causes layout errors inside scaled/fitted containers.
                    const SizedBox(width: 32), 
                    
                    CustomInkwellButton(
                      icon: Icons.mode_comment_outlined,
                      label: 'Comment', // Shortened from "Comments" to save space
                      onTap: onTap,
                    ),
                    const SizedBox(width: 12),
                    CustomInkwellButton(
                      icon: Icons.share_outlined, // Changed to outlined icon for consistency
                      label: 'Share', // Shortened from "Shared" to save space
                      onTap: onTap,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}