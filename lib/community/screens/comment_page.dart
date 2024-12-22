import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jelajah_rasa_mobile/community/screens/create_reply.dart';

class CommentPage extends StatefulWidget {
  final String uuid;

  const CommentPage({super.key, required this.uuid});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Key _futureBuilderKey = UniqueKey();

  Future<Map<String, dynamic>> fetchCommentDetail(CookieRequest request) async {
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/community/api/comments/${widget.uuid}/',
      );
      return response['comment'];
    } catch (e) {
      throw Exception('Failed to fetch comment: $e');
    }
  }

  void _refreshComment() {
    setState(() {
      _futureBuilderKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Comment',
          style: TextStyle(
            color: Color(0xFFAB4A2F),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFFAB4A2F)),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        key: _futureBuilderKey,
        future: fetchCommentDetail(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final comment = snapshot.data!;
          final replies = List<Map<String, dynamic>>.from(comment['replies']);

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Main comment card
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(comment['user_image']),
                              onBackgroundImageError: (e, s) =>
                                  const Icon(Icons.person),
                            ),
                            title: Text(
                              comment['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text('@${comment['username'].toLowerCase()}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              comment['content'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          if (comment['food'] != null) ...[
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                comment['food']['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAB4A2F),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (comment['food']['image'] != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    comment['food']['image'],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(Icons.broken_image,
                                              size: 40, color: Colors.grey),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              comment['created_at'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Replies section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Replies (${comment['replies_count']})',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFAB4A2F),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateReplyScreen(
                                        commentUuid: comment['uuid'],
                                        username: comment['username'],
                                        userImage: comment['user_image'],
                                        content: comment['content'],
                                        food: comment['food'] != 'No food'
                                            ? comment['food']
                                            : null,
                                      ),
                                    ),
                                  );

                                  if (result == true && mounted) {
                                    _refreshComment();
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFAB4A2F),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Add Reply',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (comment['replies_count'] == 0)
                            const Text(
                              'No replies yet.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            )
                          else
                            ...replies
                                .map((reply) => Card(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                FutureBuilder(
                                                  future: request.get(
                                                    'http://127.0.0.1:8000/profile/api/user-profile/${reply['username']}/',
                                                  ),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircleAvatar(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }

                                                    if (snapshot.hasError ||
                                                        !snapshot.hasData) {
                                                      return const CircleAvatar(
                                                        child:
                                                            Icon(Icons.person),
                                                      );
                                                    }

                                                    final userProfile = snapshot
                                                        .data!['user_profile'];
                                                    return CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(userProfile[
                                                                  'image_url'] ??
                                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png'),
                                                      onBackgroundImageError:
                                                          (e, s) => const Icon(
                                                              Icons.person),
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 12),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      reply['username'],
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '@${reply['username'].toLowerCase()}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(reply['content']),
                                            const SizedBox(height: 8),
                                            Text(
                                              reply['created_at'],
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
