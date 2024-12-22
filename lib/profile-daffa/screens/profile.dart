import 'dart:convert';

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
        'http://127.0.0.1:8000/profile/api/user-profile/${widget.username}/',
      );

      return UserProfile.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  Future<List<UserComment>> fetchUserComments(CookieRequest request) async {
    final response = await request.get(
        'http://127.0.0.1:8000/profile/api/user-comments/${widget.username}/');

    var data = response;
    List<UserComment> comments = [];
    for (var d in data) {
      if (d != null) {
        comments.add(UserComment.fromJson(d));
      }
    }
    return comments;
  }

  Future<List<UserFavorite>> fetchUserFavorites(CookieRequest request) async {
    final response = await request.get(
        'http://127.0.0.1:8000/profile/api/user-favorites/${widget.username}/');
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
        'http://127.0.0.1:8000/profile/api/user-reviews/${widget.username}/');
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
    final request = context.watch<CookieRequest>();
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
                      // Refresh the profile data when returning from edit screen
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
          return Column(
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
              // Content Area
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    _buildReviewsGrid(),
                    _buildFavoritesGrid(),
                    _buildCommentsGrid(),
                  ],
                ),
              ),
            ],
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

  Widget _buildReviewsGrid() {
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
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Clicked on ${review.fields.food}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8)),
                        child: Image.network(
                          review.fields.foodImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            review.fields.food,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    Icons.star,
                                    size: 16,
                                    color: starIndex < review.fields.rating
                                        ? const Color.fromARGB(255, 255, 204, 0)
                                        : Colors.grey[300],
                                  );
                                }),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${review.fields.rating}/5)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildFavoritesGrid() {
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
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.6,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final favorite = favorites[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: favorite.fields.image.isNotEmpty
                          ? Image.network(
                              Uri.encodeFull(favorite.fields.image),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              headers: const {
                                'User-Agent': 'Mozilla/5.0',
                                'Accept': 'image/jpeg,image/png,*/*',
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[100],
                              child: const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favorite.fields.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Flavor: ${favorite.fields.flavor}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Rp ${favorite.fields.price}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFAB4A2F),
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentsGrid() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('Bakso Malang'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Great food! Would recommend to everyone.'),
                const SizedBox(height: 4),
                Text(
                  '2 days ago',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
