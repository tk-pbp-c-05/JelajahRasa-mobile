import 'package:flutter/material.dart';

class ReviewCardWidget extends StatelessWidget {
  final String username;
  final String comment;
  final int rating;
  final String timestamp;
  final bool isReviewMaker;
  final bool isAdmin;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const ReviewCardWidget({
    Key? key,
    required this.username,
    required this.comment,
    required this.rating,
    required this.timestamp,
    required this.isReviewMaker,
    required this.isAdmin,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comment,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(
                  rating,
                  (index) => const Icon(Icons.star, color: Colors.amber, size: 20),
                ),
                ...List.generate(
                  5 - rating,
                  (index) => const Icon(Icons.star_border, color: Colors.amber, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'Rating: $rating',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              timestamp,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isReviewMaker)
                  TextButton(
                    onPressed: onUpdate,
                    child: const Text('Update'),
                  ),
                if (isReviewMaker || isAdmin)
                  TextButton(
                    onPressed: onDelete,
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}