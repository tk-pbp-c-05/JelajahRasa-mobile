import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/add_dish.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/request_status.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/check_dish.dart';
import 'package:jelajah_rasa_mobile/catalogue/screens/list_food_guest.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jelajah_rasa_mobile/catalogue/screens/list_food.dart';
import 'package:jelajah_rasa_mobile/report/screens/report_page.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/screens/profile.dart';
import 'package:jelajah_rasa_mobile/community/screens/community_page.dart';
import 'package:jelajah_rasa_mobile/catalogue/models/food.dart';
import 'package:jelajah_rasa_mobile/community/models/comment.dart';

class MyHomePage extends StatefulWidget {
  final bool isAuthenticated;
  final bool isAdmin;

  const MyHomePage({
    super.key,
    this.isAuthenticated = false,
    this.isAdmin = false,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Variabel untuk menandakan halaman aktif

  // Simulasi status autentikasi dan role user
  bool isAuthenticated = false; // Ganti ke true jika user sudah login
  bool isAdmin = false; // Ganti ke true jika user adalah staff/admin

  // Daftar halaman untuk user yang sudah login
  List<Widget> _getAuthenticatedPages() => [
        HomePageContent(isAdmin: isAdmin),
        const FoodPage(),
        const CommunityPage(),
        const AddDish(),
        const ShowFavorite(),
        if (isAdmin) const ReportPage(),
      ];

  // Daftar halaman untuk user yang belum login
  List<Widget> get _guestPages => [
        const HomePageContent(),
        const FoodPageGuest(), // Add this line
      ];

  @override
  void initState() {
    super.initState();
    isAuthenticated = widget.isAuthenticated;
    isAdmin = widget.isAdmin;
  }

  void _handleMenuSelection(String value, BuildContext context) {
    final request = context.read<CookieRequest>();
    switch (value) {
      case 'Profile':
        // Navigasi ke halaman profil
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                      username: request.jsonData['username'],
                    )));
        break;
      case 'Check New Dish':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PendingDishesScreen()));
        break;
      case 'Request Status':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RequestStatusScreen()));
        break;
      case 'Logout':
        final request = context.read<CookieRequest>();
        request.loggedIn = false;
        request.jsonData.clear();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
        break;
      case 'Login':
        // Navigasi ke halaman login
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        break;
      case 'Register':
        // Navigasi ke halaman register
        Navigator.pushNamedAndRemoveUntil(
            context, '/register', (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan daftar halaman berdasarkan status autentikasi
    final List<Widget> pages =
        isAuthenticated ? _getAuthenticatedPages() : _guestPages;

    // Tentukan item Bottom Navigation Bar berdasarkan status autentikasi
    final List<BottomNavigationBarItem> bottomNavItems = isAuthenticated
        ? [
            BottomNavigationBarItem(
              backgroundColor: const Color(0xFFAB4A2F),
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color(0xFFAB4A2F),
              icon: Icon(
                _currentIndex == 1
                    ? FontAwesomeIcons.solidCompass
                    : FontAwesomeIcons.compass,
              ),
              label: "Catalogue",
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color(0xFFAB4A2F),
              icon: Icon(
                _currentIndex == 2
                    ? Icons.people_alt
                    : Icons.people_alt_outlined,
              ),
              label: "Community",
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color(0xFFAB4A2F),
              icon: Icon(
                _currentIndex == 3
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
              ),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              backgroundColor: const Color(0xFFAB4A2F),
              icon: Icon(
                _currentIndex == 4
                    ? FontAwesomeIcons.circlePlus
                    : FontAwesomeIcons.squarePlus,
              ),
              label: "Add Dish",
            ),
            if (isAdmin)
              BottomNavigationBarItem(
                backgroundColor: const Color(0xFFAB4A2F),
                icon: Icon(
                  _currentIndex == 5 ? Icons.report : Icons.report_outlined,
                ),
                label: "Reports",
              ),
          ]
        : [
            BottomNavigationBarItem(
              backgroundColor: const Color(0xFFAB4A2F),
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1
                    ? FontAwesomeIcons.solidCompass
                    : FontAwesomeIcons.compass,
              ),
              label: "Catalogue",
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/jelajah_rasa_text.png',
          height: 40,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              isAuthenticated
                  ? FontAwesomeIcons.solidCircleUser
                  : FontAwesomeIcons.circleUser,
              color: const Color(0xFFE1A85F),
              size: 28,
            ),
            color: const Color(0xFFE1A85F),
            offset: const Offset(0, 50),
            onSelected: (value) => _handleMenuSelection(value, context),
            itemBuilder: (context) {
              if (isAuthenticated) {
                return [
                  const PopupMenuItem(
                    value: 'Profile',
                    child: Row(
                      children: [
                        Icon(Icons.person, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Profile', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  if (isAdmin)
                    const PopupMenuItem(
                      value: 'Check New Dish',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Check New Dish',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    )
                  else
                    const PopupMenuItem(
                      value: 'Request Status',
                      child: Row(
                        children: [
                          Icon(Icons.assignment, color: Colors.black),
                          SizedBox(width: 10),
                          Text('Request Status',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'Logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Logout', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ];
              } else {
                return [
                  const PopupMenuItem(
                    value: 'Login',
                    child: Row(
                      children: [
                        Icon(Icons.login, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Login', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Register',
                    child: Row(
                      children: [
                        Icon(Icons.app_registration, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Register', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ];
              }
            },
          ),
          const SizedBox(width: 12),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: bottomNavItems,
        selectedItemColor: const Color(0xFFE1A85F),
        unselectedItemColor: const Color(0xFFE1A85F),
        backgroundColor: const Color(0xFFAB4A2F),
      ),
    );
  }

  Future<List<dynamic>> fetchComments(CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/community/api/comments/');
    return response['comments'] ?? [];
  }

  Widget _buildFoodSection(BuildContext context, String title) {
    final request = context.watch<CookieRequest>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                final _MyHomePageState? homeState =
                    context.findAncestorStateOfType<_MyHomePageState>();
                if (homeState != null) {
                  homeState.setState(() => homeState._currentIndex = 1);
                }
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFFAB4A2F)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Food>>(
            future: fetchFood(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No foods available'));
              }

              List<Food> foods = snapshot.data!;
              List<Food> topFoods;

              if (title == 'Most Liked Food') {
                foods.sort((a, b) {
                  int ratingCompare =
                      b.fields.averageRating.compareTo(a.fields.averageRating);
                  if (ratingCompare != 0) return ratingCompare;
                  return a.fields.price.compareTo(b.fields.price);
                });
              } else {
                foods.sort((a, b) {
                  int countCompare =
                      b.fields.ratingCount.compareTo(a.fields.ratingCount);
                  if (countCompare != 0) return countCompare;
                  return a.fields.price.compareTo(b.fields.price);
                });
              }

              topFoods = foods.take(5).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topFoods.length,
                itemBuilder: (context, index) {
                  final food = topFoods[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: 160,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    food.fields.image,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.restaurant,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      food.fields.category
                                          .toString()
                                          .split('.')
                                          .last,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.fields.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${food.fields.price}',
                                    style: const TextStyle(
                                      color: Color(0xFFAB4A2F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        ' ${food.fields.averageRating}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                      Text(
                                        ' (${food.fields.ratingCount})',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestComments(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final bool isAuthenticated = request.loggedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Latest Food Mentions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                if (!isAuthenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                  return;
                }

                final _MyHomePageState? homeState =
                    context.findAncestorStateOfType<_MyHomePageState>();
                if (homeState != null) {
                  homeState.setState(() => homeState._currentIndex = 2);
                }
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFFAB4A2F)),
              ),
            ),
          ],
        ),
        if (!isAuthenticated)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please login to see latest food mentions',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          FutureBuilder<List<dynamic>>(
            future: fetchComments(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No comments available'));
              }

              // Filter comment untuk mengambil top 3
              final comments = snapshot.data!
                  .where((comment) => comment['food'] != 'No food')
                  .take(3)
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  String content = comment['content'];
                  if (content.length > 100) {
                    content = '${content.substring(0, 100)}...';
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Image and Name
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    comment['food']['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 100,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.restaurant),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    comment['food']['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // User Info and Comment
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Info Row
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage:
                                          NetworkImage(comment['user_image']),
                                      onBackgroundImageError: (e, s) =>
                                          const Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment['username'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '@${comment['username']}',
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
                                // Comment Text
                                Text(
                                  content,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
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
      ],
    );
  }

  Future<List<Food>> fetchFood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/catalog/json/');

    if (response == null) {
      throw Exception('Response is null');
    }

    List<Food> listFood = [];
    if (response is List) {
      for (var d in response) {
        Food food = Food.fromJson(d);
        listFood.add(food);
      }
    }
    return listFood;
  }
}

class HomePageContent extends StatelessWidget {
  final bool isAdmin;

  const HomePageContent({
    super.key,
    this.isAdmin = false,
  });

  Future<List<Food>> fetchFood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/catalog/json/');

    if (response == null) {
      throw Exception('Response is null');
    }

    List<Food> listFood = [];
    if (response is List) {
      for (var d in response) {
        Food food = Food.fromJson(d);
        listFood.add(food);
      }
    }
    return listFood;
  }

  Future<List<dynamic>> fetchComments(CookieRequest request) async {
    final response =
        await request.get('http://127.0.0.1:8000/community/api/comments/');
    return response['comments'] ?? [];
  }

  Widget _buildFoodSection(BuildContext context, String title) {
    final request = context.watch<CookieRequest>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                final _MyHomePageState? homeState =
                    context.findAncestorStateOfType<_MyHomePageState>();
                if (homeState != null) {
                  homeState.setState(() => homeState._currentIndex = 1);
                }
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFFAB4A2F)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<Food>>(
            future: fetchFood(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No foods available'));
              }

              List<Food> foods = snapshot.data!;
              List<Food> topFoods;

              if (title == 'Most Liked Food') {
                foods.sort((a, b) {
                  int ratingCompare =
                      b.fields.averageRating.compareTo(a.fields.averageRating);
                  if (ratingCompare != 0) return ratingCompare;
                  return a.fields.price.compareTo(b.fields.price);
                });
              } else {
                foods.sort((a, b) {
                  int countCompare =
                      b.fields.ratingCount.compareTo(a.fields.ratingCount);
                  if (countCompare != 0) return countCompare;
                  return a.fields.price.compareTo(b.fields.price);
                });
              }

              topFoods = foods.take(5).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topFoods.length,
                itemBuilder: (context, index) {
                  final food = topFoods[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SizedBox(
                        width: 160,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    food.fields.image,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.restaurant,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      food.fields.category
                                          .toString()
                                          .split('.')
                                          .last,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food.fields.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Rp ${food.fields.price}',
                                    style: const TextStyle(
                                      color: Color(0xFFAB4A2F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        ' ${food.fields.averageRating}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      Text(
                                        ' (${food.fields.ratingCount})',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestComments(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final bool isAuthenticated = request.loggedIn;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Latest Food Mentions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                if (!isAuthenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                  return;
                }

                final _MyHomePageState? homeState =
                    context.findAncestorStateOfType<_MyHomePageState>();
                if (homeState != null) {
                  homeState.setState(() => homeState._currentIndex = 2);
                }
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFFAB4A2F)),
              ),
            ),
          ],
        ),
        if (!isAuthenticated)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please login to see latest food mentions',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          FutureBuilder<List<dynamic>>(
            future: fetchComments(request),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No comments available'));
              }

              // Filter comment untuk mengambil top 3
              final comments = snapshot.data!
                  .where((comment) => comment['food'] != 'No food')
                  .take(3)
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  String content = comment['content'];
                  if (content.length > 100) {
                    content = '${content.substring(0, 100)}...';
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Image and Name
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  child: Image.network(
                                    comment['food']['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 100,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.restaurant),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    comment['food']['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // User Info and Comment
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Info Row
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage:
                                          NetworkImage(comment['user_image']),
                                      onBackgroundImageError: (e, s) =>
                                          const Icon(Icons.person),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment['username'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '@${comment['username']}',
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
                                // Comment Text
                                Text(
                                  content,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFFAE7E0),
            ),
            child: Column(
              children: [
                Text(
                  isAdmin
                      ? "Welcome Back, Admin"
                      : context.watch<CookieRequest>().loggedIn
                          ? "Welcome Back, ${context.watch<CookieRequest>().jsonData['username']}"
                          : "Welcome, guest user!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAB4A2F),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconButton(
                      icon: FontAwesomeIcons.book,
                      label: 'Catalogue',
                      onTap: () {},
                      context: context,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.users,
                      label: 'Community',
                      onTap: () {
                        if (!context.watch<CookieRequest>().loggedIn) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      context: context,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.heart,
                      label: 'Favourites',
                      onTap: () {
                        if (!context.watch<CookieRequest>().loggedIn) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      context: context,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.plus,
                      label: 'Add Dish',
                      onTap: () {
                        if (!context.watch<CookieRequest>().loggedIn) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      context: context,
                    ),
                    if (isAdmin)
                      _buildIconButton(
                        icon: Icons.report,
                        label: 'Reports',
                        onTap: () {},
                        context: context,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFoodSection(context, 'Most Liked Food'),
                const SizedBox(height: 24),
                _buildFoodSection(context, 'Most Popular Foods'),
                const SizedBox(height: 24),
                _buildLatestComments(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFAB4A2F),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: () {
              final request = context.read<CookieRequest>();

              // Check if user is not logged in for protected routes
              if (!request.loggedIn &&
                  (label == 'Community' ||
                      label == 'Favourites' ||
                      label == 'Add Dish')) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
                return;
              }

              // Get the parent Scaffold's state to access _currentIndex
              final _MyHomePageState? homeState =
                  context.findAncestorStateOfType<_MyHomePageState>();

              if (homeState != null) {
                switch (label) {
                  case 'Catalogue':
                    homeState.setState(() => homeState._currentIndex = 1);
                    break;
                  case 'Community':
                    homeState.setState(() => homeState._currentIndex = 2);
                    break;
                  case 'Favourites':
                    homeState.setState(() => homeState._currentIndex = 3);
                    break;
                  case 'Add Dish':
                    homeState.setState(() => homeState._currentIndex = 4);
                    break;
                  case 'Reports':
                    homeState.setState(() => homeState._currentIndex = 5);
                    break;
                }
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAB4A2F),
          ),
        ),
      ],
    );
  }
}
