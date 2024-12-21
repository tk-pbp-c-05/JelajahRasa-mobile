import 'package:flutter/material.dart';

class ReviewInputWidget extends StatefulWidget {
  final Function(String comment, int rating) onSubmit;

  const ReviewInputWidget({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ReviewInputWidget> createState() => _ReviewInputWidgetState();
}

class _ReviewInputWidgetState extends State<ReviewInputWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  int _selectedRating = 0;

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_commentController.text, _selectedRating);
      _commentController.clear();
      setState(() => _selectedRating = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Comment',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Comment cannot be empty'
                : null,
          ),
          const SizedBox(height: 16),
          Text('Rating:', style: TextStyle(fontSize: 16)),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() => _selectedRating = index + 1);
                },
              );
            }),
          ),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
