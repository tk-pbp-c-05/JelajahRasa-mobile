import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/customdish_form.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/selectmenu_form.dart';
import 'package:jelajah_rasa_mobile/main/widgets/navbar.dart';
//import 'package:jelajah_rasa_mobile/favorite/models/favdish_entry.dart';

class ShowFavorite extends StatelessWidget {
  const ShowFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Favourite Dishes",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search by name",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.grey),
                  onPressed: () {
                    // Filter functionality here
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to CustomizeDishPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomizeDishPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Customize Your Dish",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Select from Menu functionality here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectFromMenuPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Select from Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text(
                  "Dish cards will go here",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
