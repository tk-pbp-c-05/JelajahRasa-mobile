// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) =>
    List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
  Model model;
  String pk;
  Fields fields;

  Food({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String name;
  Flavor flavor;
  Category category;
  String vendorName;
  int price;
  String mapLink;
  String address;
  String image;
  int ratingCount;
  double averageRating;

  Fields({
    required this.name,
    required this.flavor,
    required this.category,
    required this.vendorName,
    required this.price,
    required this.mapLink,
    required this.address,
    required this.image,
    required this.ratingCount,
    required this.averageRating,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        flavor: json["flavor"] != null
            ? (flavorValues.map[json["flavor"]] ?? Flavor.SALTY)
            : Flavor.SALTY,
        category: json["category"] != null
            ? (categoryValues.map[json["category"]] ?? Category.FOOD)
            : Category.FOOD,
        vendorName: json["vendor_name"] ?? "",
        price: json["price"] ?? 0,
        mapLink: json["map_link"] ?? "",
        address: json["address"] ?? "",
        image: json["image"] ?? "",
        ratingCount: json["rating_count"] ?? 0,
        averageRating: json["average_rating"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "flavor": flavorValues.reverse[flavor],
        "category": categoryValues.reverse[category],
        "vendor_name": vendorName,
        "price": price,
        "map_link": mapLink,
        "address": address,
        "image": image,
        "rating_count": ratingCount,
        "average_rating": averageRating,
      };
}

enum Category { BEVERAGE, FOOD }

final categoryValues =
    EnumValues({"Beverage": Category.BEVERAGE, "Food": Category.FOOD});

enum Flavor { SALTY, SWEET }

final flavorValues = EnumValues(
    {"Salty": Flavor.SALTY, "Salty ": Flavor.SALTY, "Sweet": Flavor.SWEET});

enum Model { MAIN_FOOD }

final modelValues = EnumValues({"main.food": Model.MAIN_FOOD});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
