import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/add_dish.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/request_status.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/check_dish.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import '../widgets/food_card.dart';
import '../widgets/navbar.dart';

class MyHomePage extends StatefulWidget {
  final bool isAuthenticated;
  const MyHomePage({
    super.key,
    this.isAuthenticated = true,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0; // Variabel untuk menandakan halaman aktif

  // Simulasi status autentikasi dan role user
  bool isAuthenticated = true; // Ganti ke true jika user sudah login
  bool isStaff = false; // Ganti ke true jika user adalah staff/admin

  // Daftar halaman untuk user yang sudah login
  final List<Widget> _authenticatedPages = [
    const HomePageContent(), // Halaman utama
    PendingDishesScreen(), // Halaman katalog
    const AddDish(), // Halaman komunitas
    const ShowFavorite(), // Halaman favorit
    const AddDish(), // Halaman Add Dish
  ];

  // Daftar halaman untuk user yang belum login
  final List<Widget> _guestPages = [
    const HomePageContent(), // Halaman utama
    PendingDishesScreen(), // Halaman katalog
  ];

  @override
  void initState() {
    super.initState();
    isAuthenticated = widget.isAuthenticated;
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Profile':
        // Navigasi ke halaman profil
        break;
      case 'Check New Dish':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PendingDishesScreen()));
        break;
      case 'Request Status':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RequestStatusScreen()));
        break;
      case 'Logout':
        setState(() {
          isAuthenticated =
              false; // Set status autentikasi ke false saat logout
          _currentIndex = 0; // Reset ke halaman Home
        });
        break;
      case 'Login':
        // Navigasi ke halaman login
        break;
      case 'Register':
        // Navigasi ke halaman register
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan daftar halaman berdasarkan status autentikasi
    final List<Widget> pages =
        isAuthenticated ? _authenticatedPages : _guestPages;

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
              icon: Icon(
                _currentIndex == 1
                    ? FontAwesomeIcons.solidCompass
                    : FontAwesomeIcons.compass,
              ),
              label: "Catalogue",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2
                    ? Icons.people_alt
                    : Icons.people_alt_outlined,
              ),
              label: "Community",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
              ),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 4
                    ? FontAwesomeIcons.circlePlus
                    : FontAwesomeIcons.squarePlus,
              ),
              label: "Add Dish",
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
        title: const Text(
          "JelajahRasa",
          style: TextStyle(fontFamily: 'CustomFont', fontSize: 24),
        ),
        centerTitle: true,
        leading: const Icon(Icons.search, color: Colors.brown),
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
            onSelected: _handleMenuSelection,
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
                  if (isStaff)
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
      drawer: const LeftDrawer(), // Keep the drawer here
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
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back, user",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "What food do you have in mind?",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
