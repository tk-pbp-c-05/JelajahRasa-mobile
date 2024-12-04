import 'package:flutter/material.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/user_profile.jpg'),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
          height: 160, // Adjust height as needed
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              FoodCard(image: 'assets/food1.jpg', title: 'Bakso Malang', price: 'Rp 14.290', rating: 5.0, reviews: 5),
              FoodCard(image: 'assets/food2.jpg', title: 'Rawon Malang', price: 'Rp 20.000', rating: 4.8, reviews: 10),
              FoodCard(image: 'assets/food3.jpg', title: 'Bakso Malang', price: 'Rp 17.500', rating: 4.8, reviews: 5),
            ],
          ),
        ),
      ],
    );
  }
}
