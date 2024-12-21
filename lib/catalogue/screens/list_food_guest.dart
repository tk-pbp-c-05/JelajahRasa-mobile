import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/catalogue/models/food.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FoodPageGuest extends StatefulWidget {
  const FoodPageGuest({super.key});

  @override
  State<FoodPageGuest> createState() => _FoodPageGuestState();
}

class _FoodPageGuestState extends State<FoodPageGuest> {
  final _formKey = GlobalKey<FormState>();
  String _selectedIssueType = '';
  String _description = '';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name'; // Options: name, price_asc, price_desc
  String _selectedFlavor = 'all';
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Food>> fetchFood(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/catalog/json/');
    var data = response;
    List<Food> listFood = [];
    for (var d in data) {
      if (d != null) {
        listFood.add(Food.fromJson(d));
      }
    }
    return listFood;
  }

  List<Food> _filterAndSortFoods(List<Food> foods) {
    var filteredFoods = foods.where((food) {
      final searchTerm = _searchQuery.toLowerCase();
      final matchesSearch = food.fields.name.toLowerCase().contains(searchTerm) ||
             food.fields.vendorName.toLowerCase().contains(searchTerm);

      final matchesFlavor = _selectedFlavor == 'all' ||
             food.fields.flavor.toString().toLowerCase().split('.').last  == _selectedFlavor;

      final matchesCategory = _selectedCategory == 'all' ||
             food.fields.category.toString().toLowerCase().split('.').last == _selectedCategory;

      return matchesSearch && matchesFlavor && matchesCategory;
    }).toList();

    switch (_sortBy) {
      case 'name':
        filteredFoods.sort((a, b) => a.fields.name.compareTo(b.fields.name));
        break;
      case 'price_asc':
        filteredFoods.sort((a, b) => a.fields.price.compareTo(b.fields.price));
        break;
      case 'price_desc':
        filteredFoods.sort((b, a) => a.fields.price.compareTo(b.fields.price));
        break;
    }

    return filteredFoods;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Catalogue'),
        backgroundColor: const Color(0xFFAB4A2F),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search foods...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Filter Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCategory,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Categories')),
                          DropdownMenuItem(value: 'food', child: Text('Food')),
                          DropdownMenuItem(value: 'beverage', child: Text('Beverage')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Flavor Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Flavor',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedFlavor,
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Flavors')),
                          DropdownMenuItem(value: 'sweet', child: Text('Sweet')),
                          DropdownMenuItem(value: 'salty', child: Text('Salty')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFlavor = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Sort Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sort by',
                    border: OutlineInputBorder(),
                  ),
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
                    DropdownMenuItem(value: 'price_asc', child: Text('Price (Low to High)')),
                    DropdownMenuItem(value: 'price_desc', child: Text('Price (High to Low)')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Food Grid
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: fetchFood(request),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final sortedAndFilteredFoods = _filterAndSortFoods(snapshot.data!);

                  if (sortedAndFilteredFoods.isEmpty) {
                    return const Center(
                      child: Text('No matching foods found'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: sortedAndFilteredFoods.length,
                      itemBuilder: (context, index) {
                        var food = sortedAndFilteredFoods[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  food.fields.image,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.fields.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'By ${food.fields.vendorName}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${food.fields.price.toString()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFAB4A2F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          food.fields.category.toString().split('.').last,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          food.fields.flavor.toString().split('.').last,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
