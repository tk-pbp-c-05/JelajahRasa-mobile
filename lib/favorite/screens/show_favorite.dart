import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/favorite/models/favdish_entry.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/editdish_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/customdish_form.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/selectmenu_form.dart';

class ShowFavorite extends StatefulWidget {
  const ShowFavorite({super.key});

  @override
  State<ShowFavorite> createState() => _ShowFavoritePageState();
}

class _ShowFavoritePageState extends State<ShowFavorite> {
  List<FavoriteDishEntry> dishes = [];
  List<FavoriteDishEntry> filteredDishes = [];
  String searchQuery = '';
  String selectedCategory = '';
  String selectedFlavor = '';

  Future<List<FavoriteDishEntry>> fetchFavoriteDishes(
      CookieRequest request) async {
    final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/MyFavoriteDishes/json/');
    List<FavoriteDishEntry> listFavoriteDish = [];
    for (var d in response) {
      listFavoriteDish.add(FavoriteDishEntry.fromJson(d));
    }
    return listFavoriteDish;
  }

  Future<void> deleteFavoriteDish(CookieRequest request, String dishId) async {
    try {
      final response = await request.post(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/MyFavoriteDishes/delete-flutter/$dishId/',
        {},
      );

      if (response['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Favorite dish deleted successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response['message'] ?? 'Failed to delete dish')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void applyFilters() {
    setState(() {
      filteredDishes = dishes.where((dish) {
        final matchesSearchQuery =
            dish.fields.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesCategory = selectedCategory.isEmpty ||
            dish.fields.category == selectedCategory;
        return matchesSearchQuery && matchesCategory;
      }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      searchQuery = '';
      selectedCategory = '';
      filteredDishes = dishes;
    });
  }

  Future<void> fetchAndFilterDishes(CookieRequest request) async {
    final fetchedDishes = await fetchFavoriteDishes(request);
    setState(() {
      dishes = fetchedDishes;
      filteredDishes = fetchedDishes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    hint: const Text("Category"),
                    items: ['Food', 'Beverage'].map((category) {
                      return DropdownMenuItem(
                          value: category, child: Text(category));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? '';
                        applyFilters();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 200, // Set a fixed width for the search bar
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search by name",
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                          applyFilters();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: clearFilters,
                    child: const Text("Clear All",
                        style: TextStyle(color: Color(0xFFAB4A2F))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB4A2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomDishFormPage()),
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
                    backgroundColor: const Color(0xFFF18F73),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectFromMenuFormPage()),
                    );
                  },
                  child: const Text(
                    "Select from Catalog",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Dish Cards
            Expanded(
              child: FutureBuilder<List<FavoriteDishEntry>>(
                future: fetchFavoriteDishes(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No favorite dishes found.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    dishes = snapshot.data!;
                    return ListView.builder(
                      itemCount: filteredDishes.isNotEmpty
                          ? filteredDishes.length
                          : dishes.length,
                      itemBuilder: (context, index) {
                        if (index >=
                            (filteredDishes.isNotEmpty
                                ? filteredDishes.length
                                : dishes.length)) {
                          return const SizedBox(); // Prevent out-of-bounds error
                        }
                        final dish = filteredDishes.isNotEmpty
                            ? filteredDishes[index]
                            : dishes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                                image: dish.fields.image.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(dish.fields.image),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: dish.fields.image.isEmpty
                                  ? const Icon(Icons.fastfood,
                                      color: Colors.grey)
                                  : null,
                            ),
                            title: Text(
                              dish.fields.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              "Rp${dish.fields.price}\n${dish.fields.vendorName}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.black54),
                                  onPressed: () async {
                                    if (dish.fields.food == null) {
                                      final updatedDish = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditFavDishFormPage(dish: dish),
                                        ),
                                      );
                                      if (updatedDish != null) {
                                        setState(() {
                                          dishes[index] = updatedDish;
                                        });
                                      }
                                    } else {
                                      // If it's not null, show a Snackbar with an error message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'This dish cannot be edited as it is from the catalog.'),
                                        ),
                                      );
                                    }
                                    // final updatedDish = await Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           EditFavDishFormPage(dish: dish),
                                    //     ),
                                    //   );
                                    //   if (updatedDish != null) {
                                    //     setState(() {
                                    //       dishes[index] = updatedDish;
                                    //     });
                                    //   }
                                     
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black54),
                                  onPressed: () async {
                                    setState(() {
                                      dishes.removeWhere((dish) =>
                                          dish.pk ==
                                          dish.pk); // Remove the dish from the local list
                                    });
                                    await deleteFavoriteDish(request,
                                        dish.pk); // Directly call the delete function
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

