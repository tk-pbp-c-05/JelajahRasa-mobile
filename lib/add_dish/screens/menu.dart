import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/add_dish.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/request_status.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/check_dish.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Variabel untuk menandakan halaman aktif

  // Simulasi status autentikasi dan role user
  bool isAuthenticated = false; // Ganti ke true jika user sudah login
  bool isStaff = false; // Ganti ke true jika user adalah staff/admin

  // Daftar halaman untuk user yang sudah login
  final List<Widget> _authenticatedPages = [
    const Text("Home Page"), // Halaman utama
    PendingDishesScreen(), // Halaman katalog
    const AddDish(), // Halaman komunitas
    RequestStatusScreen(), // Halaman favorit
    const AddDish(), // Halaman Add Dish
  ];

  // Daftar halaman untuk user yang belum login
  final List<Widget> _guestPages = [
    const Text("Home Page"), // Halaman utama
    PendingDishesScreen(), // Halaman katalog
  ];

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Profile':
        // Navigasi ke halaman profil
        break;
      case 'Check New Dish':
        Navigator.push(context, MaterialPageRoute(builder: (context) => PendingDishesScreen()));
        break;
      case 'Request Status':
        Navigator.push(context, MaterialPageRoute(builder: (context) => RequestStatusScreen()));
        break;
      case 'Logout':
        setState(() {
          isAuthenticated = false; // Set status autentikasi ke false saat logout
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
    final List<Widget> pages = isAuthenticated ? _authenticatedPages : _guestPages;

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
                _currentIndex == 1 ? FontAwesomeIcons.solidCompass : FontAwesomeIcons.compass,
              ),
              label: "Catalogue",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2 ? Icons.people_alt : Icons.people_alt_outlined,
              ),
              label: "Community",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3 ? Icons.favorite : Icons.favorite_border_outlined,
              ),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 4 ? FontAwesomeIcons.circlePlus : FontAwesomeIcons.squarePlus,
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
                _currentIndex == 1 ? FontAwesomeIcons.solidCompass : FontAwesomeIcons.compass,
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
                  ? FontAwesomeIcons.solidCircleUser // Ikon saat user sudah login
                  : FontAwesomeIcons.circleUser,     // Ikon saat user belum login
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
                          Text('Check New Dish', style: TextStyle(color: Colors.black)),
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
                          Text('Request Status', style: TextStyle(color: Colors.black)),
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
                  ),                ];
              }
            },
          ),
          const SizedBox(width: 12), // Spacer for better spacing
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pages[_currentIndex], // Menampilkan halaman berdasarkan currentIndex
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Menunjukkan halaman yang sedang aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman aktif
          });
        },
        items: bottomNavItems,
        selectedItemColor: const Color(0xFFE1A85F),
        unselectedItemColor: const Color(0xFFE1A85F),
        backgroundColor: const Color(0xFFAB4A2F),
      ),
    );
  }
}
