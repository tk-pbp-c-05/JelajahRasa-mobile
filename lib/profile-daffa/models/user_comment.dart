// To parse this JSON data, do
//
//     final userComment = userCommentFromJson(jsonString);

import 'dart:convert';

List<UserComment> userCommentFromJson(String str) => List<UserComment>.from(
    json.decode(str).map((x) => UserComment.fromJson(x)));

String userCommentToJson(List<UserComment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserComment {
  String model;
  String pk;
  Fields fields;

  UserComment({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
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
  int user;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  String food;
  String foodImage;
  int replies;

  Fields({
    required this.user,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.food,
    required this.foodImage,
    required this.replies,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        food: json["food"],
        foodImage: json["food_image"],
        replies: json["replies"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "food": food,
        "food_image": foodImage,
        "replies": replies,
      };
}
