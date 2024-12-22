import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/favorite/screens/show_favorite.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class SelectFromMenuFormPage extends StatefulWidget {
  const SelectFromMenuFormPage({super.key});

  @override
  State<SelectFromMenuFormPage> createState() => _SelectFromMenuFormPageState();
}

class _SelectFromMenuFormPageState extends State<SelectFromMenuFormPage> {
  String? selectedFoodId;

  Future<List<Map<String, String>>> fetchFoodsFromServer() async {
    final request = CookieRequest();
    final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/MyFavoriteDishes/getfood-json/');

    // Konversi setiap item ke Map<String, String>
    return response.map<Map<String, String>>((food) {
      final map =
          food as Map<String, dynamic>; // Casting food ke Map<String, dynamic>
      final fields = map['fields']
          as Map<String, dynamic>; // Casting fields ke Map<String, dynamic>
      return {
        "pk": map['pk'] as String,
        "name": fields['name'] as String,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          "Select from Catalog",
          style: TextStyle(
            color: Color(0xFFAB4A2F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select One Dish",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Map<String, String>>>(
              future: fetchFoodsFromServer(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error loading data: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No dishes available');
                }
                final foods = snapshot.data!;
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: selectedFoodId,
                  hint: const Text('Select a dish'),
                  items: foods.map((food) {
                    return DropdownMenuItem<String>(
                      value: food["pk"], // Gunakan pk sebagai value
                      child: Text(food["name"]!), // Tampilkan name
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFoodId = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 32), // Add spacing before the submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedFoodId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a dish')),
                    );
                    return;
                  }
                  final request =
                      Provider.of<CookieRequest>(context, listen: false);
                  final body = jsonEncode({"pk": selectedFoodId});
                  final response = await request.post(
                    'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/MyFavoriteDishes/select-favdish-flutter/',
                    body,
                  );
                  if (context.mounted) {
                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Favorite Dish successfully saved!"),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text("Terdapat kesalahan, silakan coba lagi."),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAB4A2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
