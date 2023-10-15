import 'dart:convert';

systemmodel SettingsFromJson(String str) => systemmodel.fromJson(json.decode(str));


class systemmodel {
  systemmodel({
    required this.googlelogin,
    required this.systemads,
    required this.uid,
    required this.Ads,
    required this.INVOICE,
    required this.Totel_USER,
    required this.Totel_INVOICE,
    required this.titleEn,
    required this.titleAr,
  });


  bool googlelogin;
  String uid;
  String INVOICE;
  bool systemads;
  List<String> Ads;
  double? Totel_USER;
  double? Totel_INVOICE;
  String titleEn;
  String titleAr;

  factory systemmodel.fromJson(Map<String, dynamic>? json) => systemmodel(
    Ads: json!["Ads"].toString().split(", "),
    googlelogin: json["googlelogin"]?? false,
    systemads: json["systemads"]?? false,
    uid: json["uid"]?? "",
    INVOICE: json["Version"]?? "",
    Totel_USER: (json["Totel_USER"] ?? 0) * 1.0,
    Totel_INVOICE: (json["Totel_INVOICE"] ?? 0) * 1.0,
    titleEn: json["title_en"],
    titleAr: json["title_ar"],
  );
}
