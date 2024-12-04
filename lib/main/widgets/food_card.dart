import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final double rating;
  final int reviews;

  const FoodCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width for each card
      margin: const EdgeInsets.only(right: 16), // Spacing between cards
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              maxLines: 1, // Ensure text does not overflow vertically
              overflow: TextOverflow.ellipsis, // Add ellipsis for long text
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(
              price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  "$rating ($reviews Reviews)",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Prevent overflow
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
