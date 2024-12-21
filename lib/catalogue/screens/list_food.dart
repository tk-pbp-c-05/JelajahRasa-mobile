import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/models/food.dart';
// import 'package:[APP_NAME]/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  Future<List<Food>> fetchMood(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object Food
    List<Food> listMood = [];
    for (var d in data) {
      if (d != null) {
        listMood.add(Food.fromJson(d));
      }
    }
    return listMood;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food List'),
      ),
      // drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMood(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data makanan pada Jelajah Rasa.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].fields.name}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.flavor}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.category}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.vendorName}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.price}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.maplink}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.address}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.image}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.ratingCount}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.averageRating}")
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}