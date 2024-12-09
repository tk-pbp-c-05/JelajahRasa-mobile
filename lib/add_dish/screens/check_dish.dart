import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PendingDishesScreen extends StatefulWidget {
  @override
  _PendingDishesScreenState createState() => _PendingDishesScreenState();
}

class _PendingDishesScreenState extends State<PendingDishesScreen> {
  List<NewDishEntry> pendingDishes = [
    NewDishEntry(
      uuid: '1',
      name: 'Pizza',
      flavor: 'Salty',
      category: 'Food',
      vendorName: 'Pizza Hut',
      price: 12,
      mapLink: 'https://www.google.com/maps',
      address: '123 Pizza Street',
      image: 'https://via.placeholder.com/100',
      isApproved: false,
      isRejected: false,
      status: 'Pending',
      userUsername: 'admin',
    ),
    NewDishEntry(
      uuid: '2',
      name: 'Burger',
      flavor: 'Savory',
      category: 'Food',
      vendorName: 'McDonalds',
      price: 8,
      mapLink: 'https://www.google.com/maps',
      address: '456 Burger Avenue',
      image: 'https://via.placeholder.com/100',
      isApproved: false,
      isRejected: false,
      status: 'Pending',
      userUsername: 'john_doe',
    ),
  ];
  bool isLoading = false;

  @override
  // void initState() {
  //   super.initState();
  //   fetchPendingDishes();
  // }

  // Future<void> fetchPendingDishes() async {
  //   final response = await http.get(Uri.parse('YOUR_API_ENDPOINT_HERE'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     List<NewDishEntry> dishes = data.map((item) => NewDishEntry.fromJson(item)).toList();

  //     // Filter hanya yang status Pending, isApproved false, dan isRejected false
  //     setState(() {
  //       pendingDishes = dishes.where((dish) => 
  //         dish.status == 'Pending' && !dish.isApproved && !dish.isRejected
  //       ).toList();
  //       isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load dishes');
  //   }
  // }

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
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
                            dish.image,
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
    );
  }
}
