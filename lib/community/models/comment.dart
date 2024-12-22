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
  String userImage;
  String content;
  String createdAt;
  String updatedAt;
  dynamic food;
  int repliesCount;

  CommentElement({
    required this.uuid,
    required this.username,
    required this.userImage,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.food,
    required this.repliesCount,
  });

  factory CommentElement.fromJson(Map<String, dynamic> json) => CommentElement(
        uuid: json["uuid"],
        username: json["username"],
        userImage: json["user_image"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        food: json["food"],
        repliesCount: json["replies_count"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
        "user_image": userImage,
        "content": content,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "food": food,
        "replies_count": repliesCount,
      };
}

class FoodClass {
  String uuid;
  String name;
  String image;

  FoodClass({
    required this.uuid,
    required this.name,
    required this.image,
  });

  factory FoodClass.fromJson(Map<String, dynamic> json) => FoodClass(
        uuid: json["uuid"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "name": name,
        "image": image,
      };
}
