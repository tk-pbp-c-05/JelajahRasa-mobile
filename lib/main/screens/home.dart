import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/add_dish.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/request_status.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/check_dish.dart';
import 'package:jelajah_rasa_mobile/catalogue/screens/list_food_guest.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import '../widgets/food_card.dart';
import '../widgets/navbar.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jelajah_rasa_mobile/catalogue/screens/list_food.dart';
import 'package:jelajah_rasa_mobile/report/screens/report_page.dart';
import 'package:jelajah_rasa_mobile/profile-daffa/screens/profile.dart';
import 'package:jelajah_rasa_mobile/community/screens/community_page.dart';

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
      drawer: const LeftDrawer(),
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

  Widget _buildSection(String title, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              FoodCard(
                  title: 'Bakso Malang',
                  price: 'Rp 14.290',
                  rating: 5.0,
                  reviews: 5),
              FoodCard(
                  title: 'Rawon Malang',
                  price: 'Rp 20.000',
                  rating: 4.8,
                  reviews: 10),
              FoodCard(
                  title: 'Bakso Malang',
                  price: 'Rp 17.500',
                  rating: 4.8,
                  reviews: 5),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePageContent extends StatelessWidget {
  final bool isAdmin;

  const HomePageContent({
    super.key,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAdmin
                      ? "Welcome Back, Admin"
                      : "Welcome Back, ${request.jsonData['username'] ?? 'User'}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFAB4A2F),
                  ),
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
                      onTap: () {},
                      context: context,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.heart,
                      label: 'Favourites',
                      onTap: () {},
                      context: context,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.plus,
                      label: 'Add Dish',
                      onTap: () {},
                      context: context,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Explore Malang's Culinary Gems!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for foods or drinks',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFEFE7),
                  ),
                ),
                const SizedBox(height: 24),
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
              if (label == 'Catalogue') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FoodPage()),
                );
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Opening $label..."),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                onTap();
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

  Widget _buildFoodSection(BuildContext context, String title) {
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
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text("Opening $title list..."),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                // TODO: Implement navigation to full list
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => FoodListPage(title: title),
                //   ),
                // );
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFFAB4A2F)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text("Opening food details..."),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    // TODO: Implement navigation to food detail
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FoodDetailPage(foodId: index),
                    //   ),
                    // );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 160,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              'https://i0.wp.com/resepkoki.id/wp-content/uploads/2017/05/Resep-Bakso-malang.jpg?fit=500%2C365&ssl=1',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bakso Malang',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    Text(' 4.8'),
                                    Text(' (5 Reviews)'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLatestComments(BuildContext context) {
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
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text("Opening Community..."),
                      duration: Duration(seconds: 1),
                    ),
                  );
                // TODO: Implement navigation to community
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => CommunityPage(),
                //   ),
                // );
              },
              child: const Text(
                'See More',
                style: TextStyle(color: Color(0xFFAB4A2F)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8=',
                  ),
                ),
                title: const Text('Bakso Malang'),
                subtitle: const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
                ),
                onTap: () {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text("Opening comment details..."),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  // TODO: Implement navigation to comment detail
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => CommentDetailPage(commentId: index),
                  //   ),
                  // );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
