import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/comment.dart';
import 'custom_font.dart';

/// Renders a single comment with a clickable like button.
/// Tapping the heart toggles [CommentModel.isLikedByMe] and adjusts
/// the like count (Enhancement 3).
class CommentTile extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onLikeTap;

  const CommentTile({
    super.key,
    required this.comment,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.accent,
            child: Text(
              comment.user.fullName.isNotEmpty
                  ? comment.user.fullName[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.fullName,
                  style: CustomFont.subheading(size: 13.5),
                ),
                const SizedBox(height: 2),
                Text(comment.body, style: CustomFont.body(size: 14)),
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: onLikeTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        comment.isLikedByMe
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: comment.isLikedByMe
                            ? AppColors.error
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${comment.likes}',
                        style: CustomFont.caption(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
