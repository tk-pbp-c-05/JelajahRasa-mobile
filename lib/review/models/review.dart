// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
    CurrentUser currentUser;
    List<ReviewElement> reviews;

    Review({
        required this.currentUser,
        required this.reviews,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        currentUser: CurrentUser.fromJson(json["current_user"]),
        reviews: List<ReviewElement>.from(json["reviews"].map((x) => ReviewElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "current_user": currentUser.toJson(),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
    };
}

class CurrentUser {
    String username;
    bool isAdmin;
    bool isGuest;

    CurrentUser({
        required this.username,
        required this.isAdmin,
        required this.isGuest,
    });

    factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        username: json["username"],
        isAdmin: json["is_admin"],
        isGuest: json["is_guest"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "is_admin": isAdmin,
        "is_guest": isGuest,
    };
}

class ReviewElement {
    String model;
    String pk;
    Fields fields;

    ReviewElement({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ReviewElement.fromJson(Map<String, dynamic> json) => ReviewElement(
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
    String food;
    String user;
    int rating;
    String comment;
    DateTime timestamp;

    Fields({
        required this.food,
        required this.user,
        required this.rating,
        required this.comment,
        required this.timestamp,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        food: json["food"],
        user: json["user"],
        rating: json["rating"],
        comment: json["comment"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "food": food,
        "user": user,
        "rating": rating,
        "comment": comment,
        "timestamp": timestamp.toIso8601String(),
    };
}
