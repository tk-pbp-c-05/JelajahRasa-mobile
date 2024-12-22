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
          'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/community/api/comments/');

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
                  color: const Color(0xFFFFF8F3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (comment.food != null &&
                          comment.food is FoodClass) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  (comment.food as FoodClass).image,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 150,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
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
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                comment.firstName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      comment.content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    if (comment.food != null) ...[
                                      const SizedBox(height: 12),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Food Mentioned: ',
                                              style: TextStyle(
                                                color: Color(0xFFAB4A2F),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            TextSpan(
                                              text: (comment.food as FoodClass)
                                                  .name,
                                              style: const TextStyle(
                                                color: Color(0xFFAB4A2F),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                (comment.food as FoodClass).name,
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
                        ),
                      ] else ...[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment.userImage),
                            onBackgroundImageError: (e, s) =>
                                const Icon(Icons.person),
                          ),
                          title: Text(
                            comment.firstName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('@${comment.username.toLowerCase()}'),
                              const SizedBox(height: 4),
                              Text(comment.content),
                            ],
                          ),
                        ),
                      ],
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
                            if (comment.food == null)
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
