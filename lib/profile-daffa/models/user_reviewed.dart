// To parse this JSON data, do
//
//     final userReviews = userReviewsFromJson(jsonString);

import 'dart:convert';

List<UserReviews> userReviewsFromJson(String str) => List<UserReviews>.from(
    json.decode(str).map((x) => UserReviews.fromJson(x)));

String userReviewsToJson(List<UserReviews> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserReviews {
  String model;
  String pk;
  Fields fields;

  UserReviews({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory UserReviews.fromJson(Map<String, dynamic> json) => UserReviews(
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
  int user;
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
