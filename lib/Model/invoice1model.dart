import 'dart:convert';


Meshari invoiceModelFromJson(String str) => Meshari.fromJson(json.decode(str));

class Meshari {
  Meshari({
    required this.stockItemName,
    required this.vat,
    required this.billedQty,
    required this.discount,
    required this.dis,
    required this.rate,
    required this.taxAmount,
  });

   double vat;
   String stockItemName;
   String rate;
   String discount;
   double dis;
   double billedQty;
   String taxAmount;


  factory Meshari.fromJson(Map<String, dynamic>? json) => Meshari(
    stockItemName: json!["item_name"],
    rate: json["Price"],
    billedQty: (json["qty"] ?? 0) * 1.0,
    vat: (json["vat"] ?? 0) * 1.0,
    dis: (json["dis"] ?? 0) * 1.0,
    taxAmount: json["tax"],
    discount: json["Discount"] ?? "",
  );
}