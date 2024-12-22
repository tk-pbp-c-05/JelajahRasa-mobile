// To parse this JSON data, do
//
//     final commentWithReply = commentWithReplyFromJson(jsonString);

import 'dart:convert';

CommentWithReply commentWithReplyFromJson(String str) =>
    CommentWithReply.fromJson(json.decode(str));

String commentWithReplyToJson(CommentWithReply data) =>
    json.encode(data.toJson());

class CommentWithReply {
  Comment comment;

  CommentWithReply({
    required this.comment,
  });

  factory CommentWithReply.fromJson(Map<String, dynamic> json) =>
      CommentWithReply(
        comment: Comment.fromJson(json["comment"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment.toJson(),
      };
}

class Comment {
  String uuid;
  String username;
  String firstName;
  String userImage;
  String content;
  String createdAt;
  String updatedAt;
  Food food;
  List<Reply> replies;
  int repliesCount;

  Comment({
    required this.uuid,
    required this.username,
    required this.firstName,
    required this.userImage,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.food,
    required this.replies,
    required this.repliesCount,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        uuid: json["uuid"],
        username: json["username"],
        firstName: json["first_name"],
        userImage: json["user_image"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        food: Food.fromJson(json["food"]),
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
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
        "food": food.toJson(),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
        "replies_count": repliesCount,
      };
}

class Food {
  String uuid;
  String name;
  String image;

  Food({
    required this.uuid,
    required this.name,
    required this.image,
  });

  factory Food.fromJson(Map<String, dynamic> json) => Food(
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

class Reply {
  String uuid;
  String username;
  String firstName;
  String? userImage;
  String content;
  String createdAt;

  Reply({
    required this.uuid,
    required this.username,
    required this.firstName,
    required this.userImage,
    required this.content,
    required this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        uuid: json["uuid"],
        username: json["username"],
        firstName: json["first_name"],
        userImage: json["user_image"],
        content: json["content"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
        "first_name": firstName,
        "user_image": userImage,
        "content": content,
        "created_at": createdAt,
      };
}
