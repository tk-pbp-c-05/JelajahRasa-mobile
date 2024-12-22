import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/catalogue/models/food.dart';
import 'package:jelajah_rasa_mobile/review/screens/review_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
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
    List<Food> listFood = [];

    if (response is List) {
      for (var d in response) {
        if (d != null) {
          Food food = Food.fromJson(d);
          listFood.add(food);
        }
      }
    }
    return listFood;
  }

  Future<void> _reportFood(
      BuildContext context, CookieRequest request, String foodId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/report/api/food/$foodId/report/',
        jsonEncode({
          'issue_type': _selectedIssueType,
          'description': _description,
        }),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Food reported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to report food: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showReportDialog(
      BuildContext context, CookieRequest request, String foodId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Food'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Issue Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedIssueType.isEmpty ? null : _selectedIssueType,
                  items: const [
                    DropdownMenuItem(
                        value: 'quality', child: Text('Quality Issue')),
                    DropdownMenuItem(
                        value: 'incorrect_info',
                        child: Text('Incorrect Information')),
                    DropdownMenuItem(
                        value: 'out_of_stock', child: Text('Out of Stock')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedIssueType = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an issue type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value ?? '';
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.pop(context);
                  _reportFood(context, request, foodId);
                }
              },
              child: const Text('Submit Report'),
            ),
          ],
        );
      },
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Required'),
          content: const Text('Please login to report issues with food items.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  List<Food> _filterAndSortFoods(List<Food> foods) {
    var filteredFoods = foods.where((food) {
      final searchTerm = _searchQuery.toLowerCase();
      final matchesSearch =
          food.fields.name.toLowerCase().contains(searchTerm) ||
              food.fields.vendorName.toLowerCase().contains(searchTerm);

      final matchesFlavor = _selectedFlavor == 'all' ||
          flavorValues.reverse[food.fields.flavor] == _selectedFlavor;

      final matchesCategory = _selectedCategory == 'all' ||
          categoryValues.reverse[food.fields.category] == _selectedCategory;

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

  void _navigateToReview(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodReviewPage(food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final bool isAuthenticated = request.loggedIn;
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
                          DropdownMenuItem(
                              value: 'Makanan', child: Text('Makanan')),
                          DropdownMenuItem(
                              value: 'Minuman', child: Text('Minuman')),
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
                          DropdownMenuItem(value: 'asin', child: Text('Asin')),
                          DropdownMenuItem(
                              value: 'asin ', child: Text('Asin ')),
                          DropdownMenuItem(
                              value: 'manis', child: Text('Manis')),
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
                if (snapshot.hasData) {
                  final sortedAndFilteredFoods =
                      _filterAndSortFoods(snapshot.data!);

                  if (sortedAndFilteredFoods.isEmpty) {
                    return const Center(
                      child: Text('No matching foods found'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          food.fields.category
                                              .toString()
                                              .split('.')
                                              .last,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          food.fields.flavor
                                              .toString()
                                              .split('.')
                                              .last,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _navigateToReview(food);
                                          },
                                          child: const Text('Review'),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.report_problem_outlined,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            if (isAuthenticated) {
                                              _showReportDialog(
                                                  context, request, food.pk);
                                            } else {
                                              _showLoginPrompt(context);
                                            }
                                          },
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
