import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  NotificationModel({
    required this.userId,
    required this.title,
    required this.details,
    required this.createdDate,
    required this.uid,
    required this.isRead,
  });

  String userId;
  String title;
  String details;
  String createdDate;
  String uid;
  bool isRead;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    userId: json["userid"],
    title: json["title"],
    details: json["details"],
    createdDate: json["createdDate"],
    uid: json["uid"],
    isRead: json["is-read"],
  );
}
