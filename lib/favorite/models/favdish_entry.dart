// To parse this JSON data, do
//
//     final favoriteDishEntry = favoriteDishEntryFromJson(jsonString);

import 'dart:convert';

List<FavoriteDishEntry> favoriteDishEntryFromJson(String str) => List<FavoriteDishEntry>.from(json.decode(str).map((x) => FavoriteDishEntry.fromJson(x)));

String favoriteDishEntryToJson(List<FavoriteDishEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavoriteDishEntry {
    String model;
    String pk;
    Fields fields;

    FavoriteDishEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FavoriteDishEntry.fromJson(Map<String, dynamic> json) => FavoriteDishEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String? food;
    String name;
    String flavor;
    String category;
    String vendorName;
    int price;
    String mapLink;
    String address;
    String image;
    int user;
    bool isFavorite;

    Fields({
        required this.food,
        required this.name,
        required this.flavor,
        required this.category,
        required this.vendorName,
        required this.price,
        required this.mapLink,
        required this.address,
        required this.image,
        required this.user,
        required this.isFavorite,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        food: json["food"],
        name: json["name"],
        flavor: json["flavor"],
        category: json["category"],
        vendorName: json["vendor_name"],
        price: json["price"],
        mapLink: json["map_link"],
        address: json["address"],
        image: json["image"],
        user: json["user"],
        isFavorite: json["is_favorite"],
    );

    Map<String, dynamic> toJson() => {
        "food": food,
        "name": name,
        "flavor": flavor,
        "category": category,
        "vendor_name": vendorName,
        "price": price,
        "map_link": mapLink,
        "address": address,
        "image": image,
        "user": user,
        "is_favorite": isFavorite,
    };
}
