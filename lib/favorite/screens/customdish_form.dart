import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CustomDishFormPage extends StatefulWidget {
  const CustomDishFormPage({super.key});

  @override
  State<CustomDishFormPage> createState() => _CustomDishFormPageState();
}

class _CustomDishFormPageState extends State<CustomDishFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _vendorName = "";
  int _price = 0;
  String _image = "";
  String _address = "";
  String _flavor = "Sweet"; // Default flavor set to Sweet
  String _category = "Food"; // Default category set to Food
  String _mapLink = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Customize Your Dish",
          style: TextStyle(
            color: Color(0xFFAB4A2F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // This allows the form to scroll
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Dish details",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Food/Drink Name",
                  labelText: "Food/Drink Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _name = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Food/Drink can not be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _category = newValue!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Category cannot be empty!";
                  }
                  return null;
                },
                items: <String>['Food', 'Beverage']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Restaurant Name",
                  labelText: "Restaurant",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _vendorName = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Restaurant cannot be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _flavor,
                decoration: const InputDecoration(
                  labelText: "Flavor",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _flavor = newValue!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Flavor cannot be empty!";
                  }
                  return null;
                },
                items: <String>['Sweet', 'Salty']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "Price",
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _price = int.tryParse(value!) ?? 0;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Price can not be empty!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Price needs to be in numbers!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _address = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Address can not be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Map Link",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _mapLink = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Address can not be empty!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "You dont have to fill in image url",
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _image = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB4A2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      final response = await request.postJson(
                        "https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/MyFavoriteDishes/addfavdish-flutter/",
                        jsonEncode(<String, String>{
                          'name': _name,
                          'price': _price.toString(),
                          'vendor_name': _vendorName,
                          'image': _image,
                          'flavor': _flavor,
                          'category': _category,
                          'address': _address,
                          'map_link': _mapLink,
                        }),
                      );
                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Favorite Dish successfully saved!"),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowFavorite()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Terdapat kesalahan, silakan coba lagi."),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
                    "SUBMIT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
