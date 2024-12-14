import 'package:flutter/material.dart';
//import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import '../widgets/food_card.dart';
import '../widgets/navbar.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "JelajahRasa",
          style: TextStyle(fontFamily: 'CustomFont', fontSize: 24),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.brown),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.brown),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back, user",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text("What food do you have in mind?",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            _buildSection("Most Liked Food", context),
            const SizedBox(height: 16),
            _buildSection("Recently Added Foods", context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Catalogue"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Dish"),
        ],
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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
              FoodCard(title: 'Bakso Malang', price: 'Rp 14.290', rating: 5.0, reviews: 5),
              FoodCard(title: 'Rawon Malang', price: 'Rp 20.000', rating: 4.8, reviews: 10),
              FoodCard(title: 'Bakso Malang', price: 'Rp 17.500', rating: 4.8, reviews: 5),
            ],
          ),
        ),
      ],
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<MyHomePage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const HomeContent(),
//     const Text('Catalogue Page'), // Ganti dengan widget Catalogue
//     const Text('Community Page'), // Ganti dengan widget Community
//     const Text('Favourites Page'), // Ganti dengan widget Favourites
//     const Text('Add Dish Page'), // Ganti dengan widget Add Dish
//   ];

//   void _onItemTapped(int index) {
//      if (index == 3) { // Indeks untuk Favourites
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const ShowFavorite(), // Ganti dengan halaman yang diinginkan
//         ),
//       );
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Jelajah Rasa'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               // Handle search
//             },
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavbar(
//         selectedIndex: _selectedIndex,
//         onItemTapped: _onItemTapped,
//       ),
//     );
//   }
// }

// class HomeContent extends StatelessWidget {
//   const HomeContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "What food do you have in mind?",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             "Most Liked Food",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           const SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 FoodCard(title: "Bakso Malang", price: 14290, rating: 5.0, reviews: 5),
//                 FoodCard(title: "Bakso Malang", price: 14290, rating: 5.0, reviews: 5),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             "Recently Added Food",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: GridView.count(
//               crossAxisCount: 2,
//               childAspectRatio: 3 / 4,
//               mainAxisSpacing: 16,
//               crossAxisSpacing: 16,
//               children: const [
//                 FoodCard(title: "Bakso Malang", price: 14290, rating: 5.0, reviews: 5),
//                 FoodCard(title: "Bakso Malang", price: 14290, rating: 5.0, reviews: 5),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
