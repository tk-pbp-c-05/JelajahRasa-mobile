import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/add_dish.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/check_dish.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/request_status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Variabel untuk menandakan halaman aktif

  // Daftar halaman yang ingin ditampilkan saat bottom nav item ditekan
  final List<Widget> _pages = [
    const Text("Home Page"), // Halaman utama
    PendingDishesScreen(), // Halaman katalog
    const AddDish(), // Halaman komunitas
    RequestStatusScreen(), // Halaman favorit
    const AddDish(), // Halaman Add Dish
  ];

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(FontAwesomeIcons.userCircle, color: Colors.brown, size: 28),
            onSelected: (value) {
              // Handle menu item selection
              switch (value) {
                case 'Profile':
                  // Navigate to Profile Screen
                  break;
                case 'Request Status':
                  RequestStatusScreen();
                  break;
                case 'Logout':
                  // Handle logout logic
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem(
                value: 'Settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Request Status'),
                ),
              ),
              const PopupMenuItem(
                value: 'Logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12), // Spacer for better spacing
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _pages[_currentIndex], // Menampilkan halaman berdasarkan currentIndex
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Menunjukkan halaman yang sedang aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mengubah halaman aktif
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFAB4A2F),
            icon: Icon(
              _currentIndex == 0 ? Icons.home : Icons.home_outlined, // Full icon jika selected
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 1 ? FontAwesomeIcons.solidCompass : FontAwesomeIcons.compass, // Full icon jika selected
            ),
            label: "Catalogue",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2 ? Icons.people_alt : Icons.people_alt_outlined, // Full icon jika selected
            ),
            label: "Community",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 3 ? Icons.favorite : Icons.favorite_border_outlined, // Full icon jika selected
            ),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 4 ? FontAwesomeIcons.circlePlus : FontAwesomeIcons.squarePlus, // Full icon jika selected
            ),
            label: "Add Dish",
          ),
        ],
        selectedItemColor: Color(0xFFE1A85F), // Warna ikon yang dipilih
        unselectedItemColor: Color(0xFFE1A85F), // Warna ikon yang tidak dipilih
        backgroundColor: Color(0xFFAB4A2F), // Warna latar belakang bottom nav
      ),
    );
  }
}
