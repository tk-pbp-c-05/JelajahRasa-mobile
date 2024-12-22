import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jelajah_rasa_mobile/models/food.dart';
import 'package:jelajah_rasa_mobile/review/screens/create_review_page.dart';
import 'package:jelajah_rasa_mobile/review/screens/update_review_page.dart';
import 'package:jelajah_rasa_mobile/review/models/review.dart';
import 'package:jelajah_rasa_mobile/review/widgets/food_card.dart';
import 'package:jelajah_rasa_mobile/review/widgets/review_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class FoodReviewPage extends StatefulWidget {
  final Food food;

  const FoodReviewPage({Key? key, required this.food}) : super(key: key);

  @override
  _FoodReviewPageState createState() => _FoodReviewPageState();
}

class _FoodReviewPageState extends State<FoodReviewPage> {
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
      final request = context.read<CookieRequest>();
      try {
          final response = await request.get(
              'https://localhost:8000/review/food/${widget.food.pk}/'
          );
          setState(() {
              _reviewsFuture = Future.value(reviewFromJson(jsonEncode(response)));
          });
      } catch (e) {
          throw Exception('Failed to load reviews: $e');
      }
  }

  Future<void> _deleteReview(String reviewId) async {
      final request = context.read<CookieRequest>();
      
      final response = await request.postJson(
          "https://localhost:8000/review/food/$reviewId/delete-review-flutter/",
          jsonEncode({}),  // Empty body for delete
      );
      
      if (context.mounted) {
          if (response['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Review successfully deleted!"),
                  ),
              );
              _fetchReviews();  // Refresh the reviews
          } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("An error occurred, please try again."),
                  ),
              );
          }
      }
  }

  void _navigateToCreateReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReviewPage(food: widget.food),
      ),
    ).then((_) => _fetchReviews()); // Refresh reviews when returning from create page
  }

  void _navigateToUpdateReview(Review review) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateReviewPage(
          food: widget.food,
          review: review,
        ),
      ),
    ).then((_) => _fetchReviews()); // Refresh reviews when returning from update page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Reviews'),
      ),
      body: Column(
        children: [
          FoodCard(food: widget.food),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _navigateToCreateReview,
              child: const Text('Add Review'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Review>>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No reviews yet.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final review = snapshot.data![index];
                      return ReviewCardWidget(
                        comment: review.fields.comment,
                        rating: review.fields.rating,
                        timestamp: review.fields.timestamp.toIso8601String(),
                        onUpdate: () => _navigateToUpdateReview(review),
                        onDelete: () => _deleteReview(review.pk),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}