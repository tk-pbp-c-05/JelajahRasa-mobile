import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PendingDishesScreen extends StatefulWidget {
  @override
  _PendingDishesScreenState createState() => _PendingDishesScreenState();
}

class _PendingDishesScreenState extends State<PendingDishesScreen> {
  List<NewDishEntry> pendingDishes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPendingDishes();
  }

  Future<void> fetchPendingDishes() async {
    setState(() => isLoading = true);

    const String apiUrl = 'http://127.0.0.1:8000/module4/flutter-get-pending-dishes/';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer your-access-token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<NewDishEntry> dishes = data.map((item) => NewDishEntry.fromJson(item)).toList();

        setState(() {
          pendingDishes = dishes;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load dishes');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> approveDish(String uuid) async {
    final String apiUrl = 'http://127.0.0.1:8000/module4/approve-dish/$uuid/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer your-access-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'action': 'approve'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          pendingDishes.removeWhere((dish) => dish.uuid == uuid);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dish approved successfully!')),
        );
      } else {
        throw Exception('Failed to approve dish');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> rejectDish(String uuid) async {
    final String apiUrl = 'http://127.0.0.1:8000/module4/approve-dish/$uuid/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer your-access-token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'action': 'reject'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          pendingDishes.removeWhere((dish) => dish.uuid == uuid);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dish rejected successfully!')),
        );
      } else {
        throw Exception('Failed to reject dish');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
                          SizedBox(width: 12),
                          Image.network(
                            dish.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 12),
                          Column(
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.check, color: Colors.green),
                                onPressed: () => approveDish(dish.uuid),
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => rejectDish(dish.uuid),
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
