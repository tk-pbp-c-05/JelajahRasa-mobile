import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class EditCommentScreen extends StatefulWidget {
  final String uuid;
  final String content;
  final Map<String, dynamic>? food;

  const EditCommentScreen({
    super.key,
    required this.uuid,
    required this.content,
    this.food,
  });

  @override
  State<EditCommentScreen> createState() => _EditCommentScreenState();
}

class _EditCommentScreenState extends State<EditCommentScreen> {
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.content);
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
        title: const Text('Edit Comment'),
        actions: [
          TextButton(
            onPressed: () => _updateComment(context),
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              maxLength: 500,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Edit your comment...',
              ),
            ),
            if (widget.food != null)
              ListTile(
                leading: const Icon(Icons.restaurant),
                title: Text(widget.food!['name']),
                subtitle: const Text('Mentioned food cannot be changed'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateComment(BuildContext context) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        'http://127.0.0.1:8000/community/api/edit-comment/${widget.uuid}/',
        jsonEncode({
          'content': _commentController.text,
        }),
      );

      if (context.mounted) {
        if (response['status'] == 'success') {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating comment')),
        );
      }
    }
  }
}
