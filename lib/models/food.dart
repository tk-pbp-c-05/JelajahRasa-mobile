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
  int averageRating;

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
        flavor: flavorValues.map[json["flavor"]]!,
        category: categoryValues.map[json["category"]]!,
        vendorName: json["vendor_name"],
        price: json["price"],
        mapLink: json["map_link"],
        address: json["address"],
        image: json["image"],
        ratingCount: json["rating_count"],
        averageRating: json["average_rating"],
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

enum Category { beverage, food }

final categoryValues =
    EnumValues({"Beverage": Category.beverage, "Food": Category.food});

enum Flavor { salty, sweet }

final flavorValues = EnumValues({"Salty": Flavor.salty, "Sweet": Flavor.sweet});

enum Model { mainFood }

final modelValues = EnumValues({"main.food": Model.mainFood});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
