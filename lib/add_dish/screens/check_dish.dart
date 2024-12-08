import 'package:flutter/material.dart';

class PendingDishesScreen extends StatefulWidget {
  @override
  _PendingDishesScreenState createState() => _PendingDishesScreenState();
}

class _PendingDishesScreenState extends State<PendingDishesScreen> {
  TextEditingController _searchController = TextEditingController();
  
  // Sample data for pending dishes
  List<Dish> pendingDishes = [
    Dish(
      name: 'Pizza',
      flavor: 'Salty',
      category: 'Food',
      vendorName: 'Pizza Hut',
      price: 12.99,
      mapLink: 'https://www.google.com/maps',
      imageUrl: 'https://via.placeholder.com/100', // Image URL for the dish
    ),
    Dish(
      name: 'Burger',
      flavor: 'Savory',
      category: 'Food',
      vendorName: 'McDonalds',
      price: 8.50,
      mapLink: 'https://www.google.com/maps',
      imageUrl: 'https://via.placeholder.com/100', // Image URL for the dish
    ),
    // Add more Dish objects here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Dishes',
          style: TextStyle(fontSize: 24, color: Color(0xFFF4B5A4)),
        ),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search dish',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            
            // Table
            Expanded(
              child: ListView.builder(
                itemCount: pendingDishes.length,
                itemBuilder: (context, index) {
                  final dish = pendingDishes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Left side: Data in columns
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${dish.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Flavor: ${dish.flavor}'),
                                Text('Category: ${dish.category}'),
                                Text('Vendor: ${dish.vendorName}'),
                                Text('Price: \$${dish.price.toStringAsFixed(2)}'),
                                Text('Map Link: ${dish.mapLink}'),
                              ],
                            ),
                          ),
                          
                          // Right side: Image
                          SizedBox(width: 12),
                          Image.network(
                            dish.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          
                          // Right side: Checkbox and Cross buttons
                          SizedBox(width: 12),
                          Column(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (bool? value) {
                                  // Handle checkbox change
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  // Handle cancel action
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Dish {
  final String name;
  final String flavor;
  final String category;
  final String vendorName;
  final double price;
  final String mapLink;
  final String imageUrl;

  Dish({
    required this.name,
    required this.flavor,
    required this.category,
    required this.vendorName,
    required this.price,
    required this.mapLink,
    required this.imageUrl,
  });
}