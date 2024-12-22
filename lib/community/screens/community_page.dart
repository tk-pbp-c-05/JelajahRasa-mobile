import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/community/models/comment.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:jelajah_rasa_mobile/community/screens/comment_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  Future<List<CommentElement>> fetchComments(CookieRequest request) async {
    try {
      final response =
          await request.get('http://127.0.0.1:8000/community/api/comments/');

      if (response == null) {
        throw Exception('Response is null');
      }

      Comment commentData = Comment.fromJson(response);
      return commentData.comments;
    } catch (e) {
      print("Error fetching comments: $e");
      throw Exception('Failed to fetch comments: $e');
    }
  }

  String formatDate(String dateString) {
    try {
      final parts = dateString.split(' At ');
      final datePart = parts[0].split('/');
      final timePart = parts[1];

      final isoString =
          '${datePart[2]}-${datePart[1]}-${datePart[0]} $timePart';

      // First parse the date without timezone adjustment
      DateTime date = DateTime.parse(isoString);

      // Format with time
      return DateFormat('EEEE, dd MMMM yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: const Color(0xFFAB4A2F),
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'JelajahRasa Community',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE1A85F),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Hear what people has to say about Malang's Culinaries",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<CommentElement>>(
        future: fetchComments(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No comments yet.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final comment = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(uuid: comment.uuid),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (comment.food != null &&
                          comment.food is FoodClass) ...[
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.network(
                            (comment.food as FoodClass).image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            comment.food.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment.userImage),
                          onBackgroundImageError: (e, s) =>
                              const Icon(Icons.person),
                        ),
                        title: Text(
                          comment.username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('@${comment.username.toLowerCase()}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          comment.content,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDate(comment.createdAt),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${comment.repliesCount} Replies',
                              style: const TextStyle(
                                color: Color(0xFFAB4A2F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
