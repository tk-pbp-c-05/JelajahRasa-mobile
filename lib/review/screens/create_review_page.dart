// create_review_page.dart
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/catalogue/models/food.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class CreateReviewPage extends StatefulWidget {
  final Food food;

  const CreateReviewPage({super.key, required this.food});

  @override
  _CreateReviewPageState createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;

  Future<void> _submitReview() async {
          if (_formKey.currentState!.validate()) {
            final request = context.read<CookieRequest>();

            // Make the POST request directly with parameters
            final response = await request.post(
              "https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/review/food/${widget.food.pk}/update-review-flutter/",
              {
                'comment': _commentController.text, // Directly passing parameters
                'rating': _rating.toString(),
              }
            );
          
          if (context.mounted) {
              if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Review successfully created!"),
                      ),
                  );
                  Navigator.pop(context); // Return to previous page
              } else {
                  String errorMessage = response['message'] ?? 'An error occurred.';
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(errorMessage),
                      ),
                  );
              }
          }
      } 
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review for ${widget.food.fields.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  hintText: 'Write your review here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Rating: $_rating',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toString(),
                onChanged: (double value) {
                  setState(() {
                    _rating = value.round();
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Submit Review'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
