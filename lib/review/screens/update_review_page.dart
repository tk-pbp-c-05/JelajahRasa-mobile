import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/catalogue/models/food.dart';
import 'package:jelajah_rasa_mobile/review/models/review.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class UpdateReviewPage extends StatefulWidget {
  final Food food;
  final ReviewElement review;

  const UpdateReviewPage({
    super.key,
    required this.food,
    required this.review,
  });

  @override
  _UpdateReviewPageState createState() => _UpdateReviewPageState();
}

class _UpdateReviewPageState extends State<UpdateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _commentController;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(text: widget.review.fields.comment);
    _rating = widget.review.fields.rating;
  }

  Future<void> _updateReview() async {
    if (_formKey.currentState!.validate()) {
      final request = context.read<CookieRequest>();
      final response = await request.post(
        "https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/review/food/${widget.review.pk}/update-review-flutter/",
        {
          'comment': _commentController.text, // Directly passing parameters
          'rating': _rating.toString(),
        }
      );
      
      if (context.mounted) {
        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Review successfully updated!"),
            ),
          );
          Navigator.pop(context); // Return to previous page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("An error occurred, please try again."),
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
        title: const Text('Update Review'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Review for ${widget.food.fields.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  hintText: 'Update your review here...',
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
                  onPressed: _updateReview,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Update Review'),
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

