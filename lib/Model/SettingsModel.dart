import 'dart:convert';

SettingsModel SettingsFromJson(String str) => SettingsModel.fromJson(json.decode(str));


class SettingsModel {
  SettingsModel({
    this.review,
    this.Logo,
    this.vat,
    this.Tax_Number,
    this.uid_Team,
    this.Team_Name,
    this.server,
  });


  bool? review;
  double? vat;
  String? Tax_Number;
  String? uid_Team;
  String? Logo;
  String? Team_Name;
  String? server;

  factory SettingsModel.fromJson(Map<String, dynamic>? json) => SettingsModel(
    review: json!["review"]?? false,
    Tax_Number: json["Tax_Number"] ?? "",
    uid_Team: json["uid_Team"],
    Logo: json["Logo"] ?? "",
    Team_Name: json["Team_Name"] ?? "",
    server: json["Server"] ?? "",
    vat: (json["vat"] ?? 0) * 1.0,
  );

}