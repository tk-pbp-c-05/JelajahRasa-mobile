import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/community/models/comment.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:jelajah_rasa_mobile/community/screens/comment_page.dart';
import 'package:jelajah_rasa_mobile/community/screens/create_comment.dart';
import 'package:jelajah_rasa_mobile/community/screens/edit_comment.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  Key _futureBuilderKey = UniqueKey();

  Future<List<CommentElement>> fetchComments(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/community/api/comments/',
      );

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
        key: _futureBuilderKey,
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
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(uuid: comment.uuid),
                    ),
                  );

                  // If we got a result back with a UUID, navigate to that comment
                  if (result is Map<String, dynamic> &&
                      result['edited_uuid'] != null) {
                    if (context.mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentPage(uuid: result['edited_uuid']),
                        ),
                      );
                    }
                  }

                  // Refresh the comments list
                  if (result == true ||
                      (result is Map<String, dynamic> &&
                          result['refresh'] == true)) {
                    setState(() {
                      _futureBuilderKey = UniqueKey();
                    });
                  }
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: const Color(0xFFFFF8F3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundImage:
                                            NetworkImage(comment.userImage),
                                        onBackgroundImageError: (e, s) =>
                                            const Icon(Icons.person),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.firstName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '@${comment.username.toLowerCase()}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    comment.content,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    formatDate(comment.createdAt),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (comment.foodMentioned) ...[
                              const SizedBox(width: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  comment.foodImage,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (comment.foodMentioned)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFAB4A2F),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.foodName,
                                style: const TextStyle(
                                  color: Color(0xFFE1A85F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${comment.repliesCount} Replies',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(12),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFAB4A2F),
        onPressed: () async {
          if (!request.loggedIn) {
            Navigator.pushNamed(context, '/login');
            return;
          }

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCommentScreen(),
            ),
          );

          if (result == true) {
            // Refresh comments list
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
