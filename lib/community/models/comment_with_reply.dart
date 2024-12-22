// To parse this JSON data, do
//
//     final commentWithReplies = commentWithRepliesFromJson(jsonString);

import 'dart:convert';

CommentWithReplies commentWithRepliesFromJson(String str) =>
    CommentWithReplies.fromJson(json.decode(str));

String commentWithRepliesToJson(CommentWithReplies data) =>
    json.encode(data.toJson());

class CommentWithReplies {
  Comment comment;

  CommentWithReplies({
    required this.comment,
  });

  factory CommentWithReplies.fromJson(Map<String, dynamic> json) =>
      CommentWithReplies(
        comment: Comment.fromJson(json["comment"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment.toJson(),
      };
}

class Comment {
  String uuid;
  String username;
  String userImage;
  String content;
  String createdAt;
  String updatedAt;
  dynamic food;
  List<Reply> replies;
  int repliesCount;

  Comment({
    required this.uuid,
    required this.username,
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
        userImage: json["user_image"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        food: json["food"],
        replies:
            List<Reply>.from(json["replies"].map((x) => Reply.fromJson(x))),
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
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
        "replies_count": repliesCount,
      };
}

class Reply {
  String uuid;
  String username;
  String content;
  String createdAt;

  Reply({
    required this.uuid,
    required this.username,
    required this.content,
    required this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        uuid: json["uuid"],
        username: json["username"],
        content: json["content"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "username": username,
        "content": content,
        "created_at": createdAt,
      };
}
