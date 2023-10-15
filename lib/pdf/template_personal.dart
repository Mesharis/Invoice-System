import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:invoice/utils/utils.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../Model/invoice1model.dart';
import '../utils/FirebaseManager.dart';

Future<Uint8List> generateDocument(context,inventoryEntries) async {
  final doc = Document(pageMode: PdfPageMode.outlines);
  String Link = 'https://invoice-system-flutter.web.app/#/Invoice/${inventoryEntries.uid}';

  var arabicFont = Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  var regular = await PdfGoogleFonts.nunitoSansRegular();
  var italic = await PdfGoogleFonts.nunitoSansItalic();
  var bold = await PdfGoogleFonts.nunitoSansBold();
  var boldItalic = await PdfGoogleFonts.nunitoSansBoldItalic();
  final titles = <String>[
    'Invoice Number:${inventoryEntries.id}',
    'Invoice Date:${Utils.formatDate(inventoryEntries.createdDate)}',
    'Merchant ID:${inventoryEntries.idUser}',
    'Merchant Name:${inventoryEntries.NameUser}'
  ];

  List<List<String>> itemList = [['No.', 'Description', 'Quantity', 'Price', 'Vat', 'Vat Total', 'Disc', 'Disc Total', 'Amount']];
  List<Meshari> services = await FirebaseManager.shared.getAllData(ID: inventoryEntries.uid).first;
  for (var i = 0; i < services.length; i++) {
    String serialNo = (i + 1).toString();
    String itemDescription = services[i].stockItemName;
    String quantity = services[i].billedQty.toString();
    String rate = services[i].rate.toString();
    String discount = services[i].discount.toString();
    String taxAmount = services[i].taxAmount.toString();
    String vat = services[i].vat.toString();
    double dis = services[i].dis;
    double op = double.parse(services[i].billedQty.toString()) * double.parse(services[i].rate);
    op = op + double.parse(services[i].taxAmount) - dis;

    itemList.add([
      serialNo,
      itemDescription,
      quantity,
      rate,
      '%$vat',
      Utils.formatPrice(double.parse(taxAmount)),
      '%$discount',
      '$dis',
      ' ${Utils.formatPrice(double.parse(op.toString()))}',
    ]);

  }

  doc.addPage(page(
      itemList:itemList,
      Link:Link,
      regular: regular,
      italic: italic,
      bold: bold,
      inventoryEntries: inventoryEntries,
      boldItalic: boldItalic,
      arabicFont: arabicFont, titles: titles));

  return await doc.save();
}

MultiPage page(
    {required Font regular,
    required Font italic,
    required titles,
    required Link,
    required itemList,
    required Font bold,
    required  inventoryEntries,
    required Font arabicFont,
    required Font boldItalic
    }) {
  return MultiPage(
      pageTheme: PageTheme(
//        margin: const EdgeInsets.all(1),
        buildBackground: (Context context) => FullPage(
            ignoreMargins: false,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80.0,
                    height: 80.0,
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data:  Link,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: PdfColors.white,
                        fontBold: bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ])),
        theme: ThemeData.withFont(
            fontFallback: [regular],
            base: arabicFont,
            italic: italic,
            bold: bold,
            boldItalic: boldItalic),
      ),
      header: (Context context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(titles.length, (index) {
                    final title = titles[index];
                    return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(title)
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 0.0 * PdfPageFormat.cm),
          ],
        );
      },
      footer: (Context context) {return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 1.5 * PdfPageFormat.mm),
          UrlLink(
              child: Text(
                "Copyright 2022 | Electronic invoice",
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 15,
                ),
              ),
              destination: 'https://invoice-system-flutter.web.app/'),
        ],
      );
      },
      build: (context) {
        return [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5 * PdfPageFormat.mm),
              SizedBox(height: 5 * PdfPageFormat.mm),
              SizedBox(height: 5 * PdfPageFormat.mm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UrlLink(
                child: Text(
                   "Invoice Link",
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: PdfColors.blue,
                    fontSize: 20,
                  ),
                ),
                destination:  Link),
                ],
              ),
              SizedBox(height: 5 * PdfPageFormat.mm),
              Text(
                'Client Name:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(inventoryEntries.name)),
                ],
              ),
              SizedBox(height: 0.8 * PdfPageFormat.cm),
            ],
          ),
          SizedBox(height: 15),
          Table.fromTextArray(
            data: itemList,
            border: null,
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: Alignment.center,
              1: Alignment.center,
              2: Alignment.center,
              3: Alignment.center,
              4: Alignment.center,
              5: Alignment.center,
              6: Alignment.center,
              7: Alignment.center,
              8: Alignment.center,
              9: Alignment.center,
            },
          ),
          Divider(),
          Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Spacer(flex: 6),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1 * PdfPageFormat.mm),
                      Text('Number VAT:    ${inventoryEntries.Tax_Number}',
                        style: TextStyle(
                          color: PdfColors.red,
                        ),
                      ),
                      Divider(),
                      Text('Total amount:  ${Utils.formatPrice(inventoryEntries.Total)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2 * PdfPageFormat.mm),
                      Container(height: 1, color: PdfColors.grey400),
                      SizedBox(height: 0.5 * PdfPageFormat.mm),
                      Container(height: 1, color: PdfColors.grey400),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Padding(padding: const EdgeInsets.all(10)),
        ];
      });
}
