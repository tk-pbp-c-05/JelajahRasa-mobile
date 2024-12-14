import 'dart:convert';

List<NewDishEntry> newDishEntryFromJson(String str) => List<NewDishEntry>.from(json.decode(str).map((x) => NewDishEntry.fromJson(x)));

String newDishEntryToJson(List<NewDishEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewDishEntry {
    String uuid;
    String name;
    String flavor;
    String category;
    String vendorName;
    int price;
    String mapLink;
    String address;
    String image;
    bool isApproved;
    bool isRejected;
    String status;
    String userUsername;

    NewDishEntry({
        required this.uuid,
        required this.name,
        required this.flavor,
        required this.category,
        required this.vendorName,
        required this.price,
        required this.mapLink,
        required this.address,
        required this.image,
        required this.isApproved,
        required this.isRejected,
        required this.status,
        required this.userUsername,
    });

    factory NewDishEntry.fromJson(Map<String, dynamic> json) => NewDishEntry(
        uuid: json["uuid"],
        name: json["name"],
        flavor: json["flavor"],
        category: json["category"],
        vendorName: json["vendor_name"],
        price: json["price"],
        mapLink: json["map_link"],
        address: json["address"],
        image: json["image"],
        isApproved: json["is_approved"],
        isRejected: json["is_rejected"],
        status: json["status"],
        userUsername: json["user__username"],
    );

    Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "flavor": flavor,
        "category": category,
        "vendor_name": vendorName,
        "price": price,
        "map_link": mapLink,
        "address": address,
        "image": image,
        "is_approved": isApproved,
        "is_rejected": isRejected,
        "status": status,
        "user__username": userUsername,
    };
}
