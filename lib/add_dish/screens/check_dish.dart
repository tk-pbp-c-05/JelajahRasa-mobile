import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';

class PendingDishesScreen extends StatefulWidget {
  const PendingDishesScreen({super.key});

  @override
  _PendingDishesScreenState createState() => _PendingDishesScreenState();
}

class _PendingDishesScreenState extends State<PendingDishesScreen> {
  List<NewDishEntry> pendingDishes = [];
  List<NewDishEntry> filteredDishes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPendingDishes();
    _searchController.addListener(_filterDishes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchPendingDishes() async {
    final request = context.read<CookieRequest>();
    const String apiUrl =
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/module4/flutter-get-pending-dishes/';

    try {
      final response = await request.get(apiUrl);

      if (response is List) {
        List<NewDishEntry> dishes = response
            .map((item) {
              try {
                return NewDishEntry.fromJson(item);
              } catch (e) {
                print('Error parsing dish: $e');
                return null;
              }
            })
            .whereType<NewDishEntry>()
            .toList();

        setState(() {
          pendingDishes = dishes;
          filteredDishes = dishes;
        });
      } else {
        throw Exception('${response['message']}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterDishes() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredDishes = pendingDishes.where((dish) {
        return dish.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> approveDish(String uuid) async {
    final request = context.read<CookieRequest>();
    final String apiUrl =
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/module4/flutter-approve-dish/$uuid/';

    try {
      final response = await request.post(
        apiUrl,
        jsonEncode({'action': 'approve'}),
      );

      bool? isSuccess = response['success'];

      if (isSuccess == true) {
        setState(() {
          pendingDishes.removeWhere((dish) => dish.uuid == uuid);
          filteredDishes.removeWhere((dish) => dish.uuid == uuid);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dish approved successfully!')),
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
    final String apiUrl =
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/module4/flutter-approve-dish/$uuid/';

    try {
      final response = await request.post(
        apiUrl,
        jsonEncode({'action': 'reject'}),
      );

      bool? isSuccess = response['success'];

      if (isSuccess == true) {
        setState(() {
          pendingDishes.removeWhere((dish) => dish.uuid == uuid);
          filteredDishes.removeWhere((dish) => dish.uuid == uuid);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dish rejected successfully!')),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFF4B5A4)),
            onPressed: fetchPendingDishes,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Dish',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: filteredDishes.isEmpty
                ? const Center(child: Text('No pending dishes found.'))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: filteredDishes.length,
                      itemBuilder: (context, index) {
                        final dish = filteredDishes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Name: ${dish.name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('Flavor: ${dish.flavor}'),
                                      Text('Category: ${dish.category}'),
                                      Text('Vendor: ${dish.vendorName}'),
                                      Text(
                                          'Price: Rp${dish.price}'),
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
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://i.imgur.com/qCP9R4y.jpeg', // Gambar default
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const FaIcon(FontAwesomeIcons.check,
                                          color: Colors.green),
                                      onPressed: () => approveDish(dish.uuid),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red),
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
          ),
        ],
      ),
    );
  }
}
