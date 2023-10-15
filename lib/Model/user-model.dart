import 'dart:convert';

import 'enum.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    this.id,
    this.image,
    this.name,
    this.phone,
    this.email,
    this.city,
    this.uid,
    required this.accountStatus,
    required this.userType,
    required this.uid_Team,
    required this.support,
    this.dateCreated,
  });

  bool support;
  String uid_Team;
  String? id;
  String? image;
  String? name;
  String? phone;
  String? email;
  String? city;
  String? uid;
  Status accountStatus;
  UserType userType;
  String? dateCreated;

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
        id: json!["id"],
        image: json["image"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        city: json["city"],
        uid: json["uid"],
        accountStatus: Status.values[json["status-account"]],
        userType: UserType.values[json["type_user"]],
        support: json["support"]?? false,
        dateCreated: json["createdDate"] ?? DateTime.now().toString(),
        uid_Team: json["uid_Team"] ??  "",
  );

}
