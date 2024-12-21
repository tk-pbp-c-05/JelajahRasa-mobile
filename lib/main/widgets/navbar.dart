import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import 'package:jelajah_rasa_mobile/main/screens/home.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Jelajah Rasa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Discover Malang's Culinary!",
                  textAlign: TextAlign.center, // Center alignment
                  style: TextStyle(
                  fontSize: 15.0, // Font size 15
                  color: Colors.white, // White color
                  fontWeight: FontWeight.normal, // Normal weight
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home Page'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              // Route menu ke halaman produk
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ShowFavorite()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// class BottomNavbar extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   const BottomNavbar({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: selectedIndex,
//       onTap: onItemTapped,
//       selectedItemColor: Colors.orange,
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.menu_book),
//           label: 'Catalogue',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.group),
//           label: 'Community',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.favorite),
//           label: 'Favourites',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.add),
//           label: 'Add Dish',
//         ),
//       ],
//     );
//   }
// }
