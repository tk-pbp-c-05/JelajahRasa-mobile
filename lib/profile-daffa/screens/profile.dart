import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/models/user_comment.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/models/user_favorite.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/models/user_reviewed.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/models/user.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/screens/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({
    super.key,
    required this.username,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> userProfileFuture;
  late Future<List<UserReviews>> userReviewsFuture;
  late Future<List<UserFavorite>> userFavoritesFuture;

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    userProfileFuture = fetchUserProfile(request);
    userReviewsFuture = fetchUserReviews(request);
    userFavoritesFuture = fetchUserFavorites(request);
  }

  Future<UserProfile> fetchUserProfile(CookieRequest request) async {
    try {
      final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/profile/api/user-profile/${widget.username}/',
      );

      return UserProfile.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  Future<List<UserComment>> fetchUserComments(CookieRequest request) async {
    final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/profile/api/user-comments/${widget.username}/');

    var data = response;
    List<UserComment> comments = [];
    for (var d in data) {
      if (d != null) {
        if (d['food'] == null) {
          d['food'] = 'No food';
        }
        comments.add(UserComment.fromJson(d));
      }
    }
    return comments;
  }

  Future<List<UserFavorite>> fetchUserFavorites(CookieRequest request) async {
    final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/profile/api/user-favorites/${widget.username}/');
    var data = response;
    List<UserFavorite> favorites = [];
    for (var d in data) {
      if (d != null) {
        favorites.add(UserFavorite.fromJson(d));
      }
    }
    return favorites;
  }

  Future<List<UserReviews>> fetchUserReviews(CookieRequest request) async {
    final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/profile/api/user-reviews/${widget.username}/');
    var data = response;
    List<UserReviews> reviews = [];
    for (var d in data) {
      if (d != null) {
        reviews.add(UserReviews.fromJson(d));
      }
    }
    return reviews;
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${widget.username}'s Profile"),
        actions: [
          FutureBuilder<UserProfile>(
            future: userProfileFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          username: widget.username,
                          userProfile: snapshot.data!,
                        ),
                      ),
                    ).then((_) {
                      setState(() {
                        final request = context.read<CookieRequest>();
                        userProfileFuture = fetchUserProfile(request);
                      });
                    });
                  },
                  tooltip: 'Edit Profile',
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFAB4A2F),
        elevation: 1,
      ),
      body: FutureBuilder<UserProfile>(
        future: userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final userProfile = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  color: const Color(0xFFFAE7E0),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            userProfile.userProfile.imageUrl.isNotEmpty
                                ? NetworkImage(userProfile.userProfile.imageUrl)
                                : null,
                        child: userProfile.userProfile.imageUrl.isEmpty
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userProfile.userProfile.username,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAB4A2F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${userProfile.userProfile.firstName} ${userProfile.userProfile.lastName}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userProfile.userProfile.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      if (userProfile.userProfile.isAdmin) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1A85F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                              userProfile.favoriteDishesCount.toString(),
                              'Favorite\nDishes'),
                          _buildStatColumn(userProfile.reviewsCount.toString(),
                              'Reviewed\nDishes'),
                          _buildStatColumn(userProfile.commentsCount.toString(),
                              'Forum\nComments'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Toggle Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton(
                        0,
                        const Icon(FontAwesomeIcons.penToSquare),
                      ),
                    ),
                    Expanded(
                      child: _buildToggleButton(
                        1,
                        const Icon(FontAwesomeIcons.heart),
                      ),
                    ),
                    Expanded(
                      child: _buildToggleButton(
                        2,
                        const Icon(FontAwesomeIcons.comment),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 0),
                // Content Area - Now using Column instead of GridView
                _selectedIndex == 0
                    ? _buildReviewsList()
                    : _selectedIndex == 1
                        ? _buildFavoritesList()
                        : _buildCommentsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFAB4A2F),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildToggleButton(int index, Icon icon) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFE1A85F) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Icon(
          icon.icon,
          color: isSelected ? const Color(0xFFE1A85F) : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    return FutureBuilder<List<UserReviews>>(
      future: userReviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reviews yet'));
        }

        final reviews = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8),
          itemCount: reviews.length,
          itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return FutureBuilder<List<UserFavorite>>(
      future: userFavoritesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorites yet'));
        }

        final favorites = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8),
          itemCount: favorites.length,
          itemBuilder: (context, index) => _buildFavoriteCard(favorites[index]),
        );
      },
    );
  }

  Widget _buildCommentsList() {
    return FutureBuilder<List<UserComment>>(
      future: fetchUserComments(context.read<CookieRequest>()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No comments yet'));
        }

        final comments = snapshot.data!;
        return Column(
          children:
              comments.map((comment) => _buildCommentCard(comment)).toList(),
        );
      },
    );
  }

  Widget _buildReviewCard(UserReviews review) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              review.fields.foodImage,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.fields.food,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        size: 12,
                        color: index < review.fields.rating
                            ? const Color.fromARGB(255, 255, 204, 0)
                            : Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(UserFavorite favorite) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              favorite.fields.image,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite.fields.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Rp ${favorite.fields.price}',
                  style: const TextStyle(
                    color: Color(0xFFAB4A2F),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(UserComment comment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFFFFF6F0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (comment.fields.foodImage != "No image") ...[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                comment.fields.foodImage,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox(height: 0),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Daffa ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '@daffadesra',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (comment.fields.food != "No food")
                          Text(
                            comment.fields.food,
                            style: const TextStyle(
                              color: Color(0xFFAB4A2F),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  comment.fields.content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(comment.fields.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${comment.fields.replies} Replies',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return 'Sunday, ${date.day} October ${date.year} At ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
