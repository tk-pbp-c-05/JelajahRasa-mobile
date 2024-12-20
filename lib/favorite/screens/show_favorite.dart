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
  Future<List<FavoriteDishEntry>> fetchFavoriteDishes(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/MyFavoriteDishes/json/');
    List<FavoriteDishEntry> listFavoriteDish = [];
    for (var d in response) {
      listFavoriteDish.add(FavoriteDishEntry.fromJson(d));
    }
    return listFavoriteDish;
  }

  
  Future<void> deleteFavoriteDish(CookieRequest request, String dishId) async {
    try {
      final response = await request.post(
        'http://127.0.0.1:8000/MyFavoriteDishes/delete-flutter/$dishId/',{},
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
            SnackBar(content: Text(response['message'] ?? 'Failed to delete dish')),
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar & Buttons (unchanged)
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
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Buttons
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CustomDishFormPage()),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectFromMenuFormPage()),
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
                      itemCount: dishes.length,
                      itemBuilder: (context, index) {
                        final dish = dishes[index];
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
                                  ? const Icon(Icons.fastfood, color: Colors.grey)
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
                                  icon: const Icon(Icons.edit, color: Colors.black54),
                                   onPressed: () async {
                                    if (dish.fields.food == null) {
                                      final updatedDish = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditFavDishFormPage(dish: dish),
                                        ),
                                      );
                                      if (updatedDish != null) {
                                        setState(() {
                                          dishes[index] = updatedDish;
                                        });
                                      }
                                    } else {
                                      // If it's not null, show a Snackbar with an error message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('This dish cannot be edited as it is from the catalog.'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.black54),
                                  onPressed: () async {
                                    setState(() {
                                      dishes.removeWhere((dish) => dish.pk == dish.pk);  // Remove the dish from the local list
                                    });
                                    await deleteFavoriteDish(request, dish.pk);  // Directly call the delete function
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