import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invoice/Model/enum.dart';


InvoiceModel invoiceModelFromJson(String str) => InvoiceModel.fromJson(json.decode(str));

class InvoiceModel {
  InvoiceModel({
    required this.id,
    required this.Server,
    required this.invoice,
    required this.Total,
    required this.Price,
    required this.idUser,
    required this.NameUser,
    required this.images,
    required this.createdDate,
    required this.uid_owner,
    required this.name,
    required this.phone,
    required this.email,
    required this.uid_Team,
    required this.uid,
    required this.Tax_Number,
    required this.VATTOTAL,
    required this.VAT,
  });

  Payment invoice;
  double Total;
  double Price;
  double VATTOTAL;
  double VAT;
  DateTime createdDate;
  String uid_owner;
  String Server;
  String NameUser;
  String name;
  String idUser;
  String phone;
  String email;
  String uid_Team;
  String uid;
  String id;
  String images;
  String Tax_Number;


  factory InvoiceModel.fromJson(Map<String, dynamic>? json) => InvoiceModel(
    images: json!["images"],
    invoice: Payment.values[json["invoice"]],
    Total: (json["Total"] ?? 0) * 1.0,
    Price: (json["Price"] ?? 0) * 1.0,
    VATTOTAL: (json["VATTOTAL"] ?? 0) * 1.0,
    VAT: (json["VAT"] ?? 0) * 1.0,
    createdDate: json["createdDate"] = ((json["createdDate"] as Timestamp).toDate()),
    uid_owner: json["uid_owner"],
    NameUser: json["NameUser"],
    uid: json["uid"],
    idUser: json["idUser"],
    id: json["id"],
    Server: json["Server"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    uid_Team: json["uid_Team"],
    Tax_Number: json["Tax_Number"],
  );
}