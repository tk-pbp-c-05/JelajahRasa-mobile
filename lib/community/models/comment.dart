// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

Comment commentFromJson(String str) => Comment.fromJson(json.decode(str));

String commentToJson(Comment data) => json.encode(data.toJson());

class Comment {
  List<CommentElement> comments;

  Comment({
    required this.comments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comments: List<CommentElement>.from(
            json["comments"].map((x) => CommentElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class CommentElement {
  String uuid;
  String username;
  String firstName;
  String userImage;
  String content;
  String createdAt;
  String updatedAt;
  bool foodMentioned;
  String foodUuid;
  String foodName;
  String foodImage;
  int repliesCount;

  CommentElement({
    required this.uuid,
    required this.username,
    required this.firstName,
    required this.userImage,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.foodMentioned,
    required this.foodUuid,
    required this.foodName,
    required this.foodImage,
    required this.repliesCount,
  });

  factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
        uuid: json["uuid"],
        username: json["username"],
        firstName: json["first_name"],
        userImage: json["user_image"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        foodMentioned: json["food_mentioned"],
        foodUuid: json["food_uuid"],
        foodName: json["food_name"],
        foodImage: json["food_image"],
        repliesCount: json["replies_count"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
        "first_name": firstName,
        "user_image": userImage,
        "content": content,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "food_mentioned": foodMentioned,
        "food_uuid": foodUuid,
        "food_name": foodName,
        "food_image": foodImage,
        "replies_count": repliesCount,
      };
}
