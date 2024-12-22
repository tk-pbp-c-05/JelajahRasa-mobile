import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jelajah_rasa_mobile/community/screens/select_food.dart';

class CreateCommentScreen extends StatefulWidget {
  const CreateCommentScreen({super.key});

  @override
  State<CreateCommentScreen> createState() => _CreateCommentScreenState();
}

class _CreateCommentScreenState extends State<CreateCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  Map<String, dynamic>? selectedFood;
  String? userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final request = context.read<CookieRequest>();
    try {
      final username = request.jsonData['username'];
      final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/profile/api/user-profile/$username/',
      );
      if (mounted) {
        setState(() {
          userImage = response['user_profile']['image_url'];
        });
      }
    } catch (e) {
      // Handle error silently - will use default image
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
      backgroundColor: const Color(0xFFFAF3F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          alignment: Alignment.centerLeft,
          width: 80, // Increased width
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ),
        leadingWidth: 80, // Match container width
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: _commentController.text.isEmpty
                  ? null
                  : () => _submitComment(context),
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Color(0xFFAB4A2F),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userImage ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'),
                    onBackgroundImageError: (e, s) => const Icon(Icons.person),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      maxLength: 500,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Enter your comment here...',
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: selectedFood != null
                      ? null
                      : () async {
                          final currentComment = _commentController.text;

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SelectFromMenuFormPage(),
                            ),
                          );

                          if (result != null && mounted) {
                            setState(() {
                              selectedFood = result;
                              _commentController.text = currentComment;
                            });
                          }
                        },
                  icon: const Icon(
                    Icons.restaurant_menu,
                    color: Color(0xFFAB4A2F),
                  ),
                  label: Row(
                    children: [
                      Text(
                        'Mention Food From Catalogue',
                        style: TextStyle(
                          color: selectedFood != null
                              ? Colors.grey
                              : const Color(0xFFAB4A2F),
                        ),
                      ),
                      if (selectedFood != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            selectedFood!['name'],
                            style: const TextStyle(fontSize: 12),
                          ),
                          onDeleted: () {
                            setState(() {
                              selectedFood = null;
                            });
                          },
                          deleteIconColor: Colors.grey,
                          backgroundColor: Colors.grey[200],
                        ),
                      ],
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

  Future<void> _submitComment(BuildContext context) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/community/api/add-comment/',
        {
          'content': _commentController.text,
          'food_uuid': selectedFood?['uuid'] ?? '',
        },
      );

      if (context.mounted) {
        if (response['status'] == 'success') {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response['message'] ?? 'Failed to post comment')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error posting comment')),
        );
      }
    }
  }
}
