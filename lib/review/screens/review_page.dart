import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jelajah_rasa_mobile/catalogue/models/food.dart';
import 'package:jelajah_rasa_mobile/main/screens/login.dart';
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
  late Future<Review> _reviewsFuture;
  late Food _currentFood;

  @override
  void initState() {
    super.initState();
    _currentFood = widget.food;
    _reviewsFuture = _fetchReviews();
  }

  Future<Food> _fetchUpdatedFood() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/catalog/${widget.food.pk}/json/'
      );
      return Food.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load food data: $e');
    }
  }

  Future<Review> _fetchReviews() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/review/food/${widget.food.pk}/json/'
      );
      return reviewFromJson(jsonEncode(response));
    } catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }
  
  Future<void> _refreshData() async {
    if (!mounted) return;

    try {
      final updatedFood = await _fetchUpdatedFood();
      final updatedReviews = await _fetchReviews();
      
      if (!mounted) return;

      setState(() {
        _currentFood = updatedFood;
        _reviewsFuture = Future.value(updatedReviews);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error refreshing data: $e')),
        );
      }
    }
  }

  Future<void> _deleteReview(String reviewId) async {
    final request = context.read<CookieRequest>();
    
    try {
      final response = await request.post(
        "https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/review/food/$reviewId/delete-review-flutter/",
        {},
      );
      
      if (!mounted) return;
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review successfully deleted!")),
        );
        await _refreshData();
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting review: $e")),
        );
      }
    }
  }

  void _navigateToCreateReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReviewPage(food: _currentFood),
      ),
    );
    
    if (mounted) {
      await _refreshData();
    }
  }

  void _navigateToUpdateReview(ReviewElement review) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateReviewPage(
          food: _currentFood,
          review: review,
        ),
      ),
    );
    
    if (mounted) {
      await _refreshData();
    }
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat("MMMM d, yyyy, h:mm a");
    return formatter.format(dateTime);
  }
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final isGuest = !request.loggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Reviews'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Column(
          children: [
            FoodCard(
              key: ValueKey(_currentFood.pk),
              food: _currentFood,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isGuest ? _navigateToLogin : _navigateToCreateReview,
                child: Text(isGuest ? 'Login to Leave a Review' : 'Add Review'),
              ),
            ),
            Expanded(
              child: FutureBuilder<Review>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.reviews.isEmpty) {
                    return const Center(child: Text('No reviews yet.'));
                  }
                  
                  final reviewData = snapshot.data!;
                  return ListView.builder(
                    itemCount: reviewData.reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviewData.reviews[index];
                      final isReviewMaker = reviewData.currentUser.username == review.fields.user;
                      return ReviewCardWidget(
                        key: ValueKey(review.pk),
                        username: review.fields.user,
                        comment: review.fields.comment,
                        rating: review.fields.rating,
                        timestamp: formatDateTime(review.fields.timestamp),
                        isReviewMaker: isReviewMaker,
                        isAdmin: reviewData.currentUser.isAdmin,
                        onUpdate: () => _navigateToUpdateReview(review),
                        onDelete: () => _deleteReview(review.pk),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}