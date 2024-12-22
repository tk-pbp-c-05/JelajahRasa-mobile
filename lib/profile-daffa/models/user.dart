// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  UserProfileClass userProfile;
  int favoriteDishesCount;
  int reviewsCount;
  int commentsCount;

  UserProfile({
    required this.userProfile,
    required this.favoriteDishesCount,
    required this.reviewsCount,
    required this.commentsCount,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userProfile: UserProfileClass.fromJson(json["user_profile"]),
        favoriteDishesCount: json["favorite_dishes_count"],
        reviewsCount: json["reviews_count"],
        commentsCount: json["comments_count"],
      );

  Map<String, dynamic> toJson() => {
        "user_profile": userProfile.toJson(),
        "favorite_dishes_count": favoriteDishesCount,
        "reviews_count": reviewsCount,
        "comments_count": commentsCount,
      };
}

class UserProfileClass {
  String username;
  String firstName;
  String lastName;
  String location;
  String imageUrl;
  bool isAdmin;

  UserProfileClass({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.imageUrl,
    required this.isAdmin,
  });

  factory UserProfileClass.fromJson(Map<String, dynamic> json) =>
      UserProfileClass(
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        location: json["location"],
        imageUrl: json["image_url"],
        isAdmin: json["is_admin"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "location": location,
        "image_url": imageUrl,
        "is_admin": isAdmin,
      };
}
