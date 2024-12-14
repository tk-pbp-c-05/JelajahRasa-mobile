import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class PendingDishesScreen extends StatefulWidget {
  @override
  _PendingDishesScreenState createState() => _PendingDishesScreenState();
}

class _PendingDishesScreenState extends State<PendingDishesScreen> {
  List<NewDishEntry> pendingDishes = [];

  @override
  void initState() {
    super.initState();
    fetchPendingDishes();
  }

Future<void> fetchPendingDishes() async {
  final request = context.read<CookieRequest>();
  const String apiUrl = 'http://127.0.0.1:8000/module4/flutter-get-pending-dishes/';

  try {
    final response = await request.get(apiUrl);

    if (response is List) {
      List<NewDishEntry> dishes = response.map((item) {
        try {
          return NewDishEntry.fromJson(item);
        } catch (e) {
          print('Error parsing dish: $e');
          return null; // Jika parsing gagal, kembalikan null
        }
      }).whereType<NewDishEntry>().toList(); // Filter out null values

      setState(() {
        pendingDishes = dishes;
      });
    } else {
      throw Exception('Failed to load dishes');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  Future<void> approveDish(String uuid) async {
    final request = context.read<CookieRequest>();
    final String apiUrl = 'http://127.0.0.1:8000/module4/approve-dish/$uuid/';

    try {
      final response = await request.post(
        apiUrl,
        jsonEncode({'action': 'approve'}),
      );

      bool? isSuccess = response['success']; // Nullable type

      if (isSuccess == true) {
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
    final request = context.read<CookieRequest>();
    final String apiUrl = 'http://127.0.0.1:8000/module4/approve-dish/$uuid/';

    try {
      final response = await request.post(
        apiUrl,
        jsonEncode({'action': 'reject'}),
      );

      bool? isSuccess = response['success']; // Nullable type

      if (isSuccess == true) {
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
        title: const Text(
          'Pending Dishes',
          style: TextStyle(fontSize: 24, color: Color(0xFFF4B5A4)),
        ),
        backgroundColor: Colors.white70,
      ),
      body: pendingDishes.isEmpty
          ? const Center(child: Text('No pending dishes found.'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: pendingDishes.length,
                itemBuilder: (context, index) {
                  final dish = pendingDishes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${dish.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('Flavor: ${dish.flavor}'),
                                Text('Category: ${dish.category}'),
                                Text('Vendor: ${dish.vendorName}'),
                                Text('Price: \$${dish.price.toStringAsFixed(2)}'),
                                Text('Map Link: ${dish.mapLink}'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Image.network(
                            dish.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            children: [
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.check, color: Colors.green),
                                onPressed: () => approveDish(dish.uuid),
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red),
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
