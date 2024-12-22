import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/models/food.dart';

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image of the food
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              food.fields.image,
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Padding for content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food name
                Text(
                  food.fields.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Vendor name
                Text(
                  'By: ${food.fields.vendorName}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 8.0),

                // Price
                Text(
                  'Price: \$${food.fields.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),

                const SizedBox(height: 8.0),

                Text(
                  food.fields.address,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black, // Changed color to default
                  ),
                ),

                const SizedBox(height: 8.0),

                // Average rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4.0),
                    Text(
                      food.fields.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
