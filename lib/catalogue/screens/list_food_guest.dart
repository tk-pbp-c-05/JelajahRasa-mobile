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
    try {
      final response = await request.get('http://127.0.0.1:8000/catalog/json/');

      print("API Response Type: ${response.runtimeType}");

      if (response == null) {
        throw Exception('Response is null');
      }

      List<Food> listFood = [];

      if (response is List) {
        for (var d in response) {
          try {
            if (d != null) {
              print("\n--- Processing Food Item ---");
              print("Raw data: $d");
              print("Fields data: ${d['fields']}");

              final fields = d['fields'];
              if (fields != null) {
                print("Name: ${fields['name']}");
                print("Flavor: ${fields['flavor']}");
                print("Category: ${fields['category']}");
                print("Price: ${fields['price']}");
                print("Vendor: ${fields['vendor_name']}");
                print("Image: ${fields['image']}");
                print("Rating Count: ${fields['rating_count']}");
                print("Average Rating: ${fields['average_rating']}");
              } else {
                print("Fields is null!");
              }

              Food food = Food.fromJson(d);
              listFood.add(food);
            }
          } catch (e, stackTrace) {
            print("\n--- Error Details ---");
            print("Error type: ${e.runtimeType}");
            print("Error message: $e");
            print("Stack trace: $stackTrace");
            print("Problematic data structure: ${d.runtimeType}");
            print("Problematic data: $d");
          }
        }
      } else {
        throw Exception('Response is not a List: ${response.runtimeType}');
      }

      return listFood;
    } catch (e, stackTrace) {
      print("Error fetching food: $e");
      print("Stack trace: $stackTrace");
      throw Exception('Failed to fetch food: $e');
    }
  }

  List<Food> _filterAndSortFoods(List<Food> foods) {
    var filteredFoods = foods.where((food) {
      final searchTerm = _searchQuery.toLowerCase();
      final matchesSearch =
          food.fields.name.toLowerCase().contains(searchTerm) ||
              food.fields.vendorName.toLowerCase().contains(searchTerm);

      final matchesFlavor = _selectedFlavor == 'all' ||
          food.fields.flavor.toString().toLowerCase().split('.').last ==
              _selectedFlavor;

      final matchesCategory = _selectedCategory == 'all' ||
          food.fields.category.toString().toLowerCase().split('.').last ==
              _selectedCategory;

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
                          DropdownMenuItem(
                              value: 'all', child: Text('All Categories')),
                          DropdownMenuItem(value: 'food', child: Text('Food')),
                          DropdownMenuItem(
                              value: 'beverage', child: Text('Beverage')),
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
                          DropdownMenuItem(
                              value: 'all', child: Text('All Flavors')),
                          DropdownMenuItem(
                              value: 'sweet', child: Text('Sweet')),
                          DropdownMenuItem(
                              value: 'salty', child: Text('Salty')),
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
                    DropdownMenuItem(
                        value: 'price_asc', child: Text('Price (Low to High)')),
                    DropdownMenuItem(
                        value: 'price_desc',
                        child: Text('Price (High to Low)')),
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No food items found",
                      style: TextStyle(
                        color: Color(0xff59A96A),
                        fontSize: 20,
                      ),
                    ),
                  );
                }

                List<Food> filteredFoods = _filterAndSortFoods(snapshot.data!);

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = filteredFoods[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image with loading and error handling
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
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.restaurant,
                                        size: 32,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      color: const Color(0xFFAB4A2F),
                                    ),
                                  ),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'By ${food.fields.vendorName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp ${food.fields.price}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFAB4A2F),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        food.fields.category
                                            .toString()
                                            .split('.')
                                            .last,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        food.fields.flavor
                                            .toString()
                                            .split('.')
                                            .last,
                                        style: const TextStyle(fontSize: 12),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
