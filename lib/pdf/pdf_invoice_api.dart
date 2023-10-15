import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pdf/src/widgets/barcode.dart';
import 'package:printing/printing.dart';
import '../utils/utils.dart';

Future<Uint8List> generate(invoice) async {
  var arabicFont = Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));
  var regular = await PdfGoogleFonts.nunitoSansRegular();
  var italic = await PdfGoogleFonts.nunitoSansItalic();
  var bold = await PdfGoogleFonts.nunitoSansBold();
  var boldItalic = await PdfGoogleFonts.nunitoSansBoldItalic();
  final pdf = pw.Document();
  String Link = 'https://invoice-system-flutter.web.app/#/Invoice/${invoice.uid}';

  pw.Widget buildInvoiceInfo() {
    final titles = <String>[
      'Invoice Number:${invoice.id}',
      'Invoice Date:${Utils.formatDate(invoice.createdDate)}',
      'Merchant ID:${invoice.idUser}',
      'Merchant Name:${invoice.NameUser}'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Text(title));
      }),
    );
  }

  pw.Widget buildInvoice() {
    final headers = ['Number VAT', 'VAT', 'Price', 'VAT Total', 'Total'];
    double price = invoice.Total - invoice.VATTOTAL;
    return Table.fromTextArray(
      headers: headers,
      data: [[
        invoice.Tax_Number,
        invoice.VAT,
        Utils.formatPrice(price),
        Utils.formatPrice(invoice.VATTOTAL),
        Utils.formatPrice(invoice.Total)
      ]],
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
      },
    );
  }

  pw.Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          UrlLink(
              child: Text(
                "Copyright 2022 | Electronic invoice",
                style: const TextStyle(
                  color: PdfColors.black,
                  fontSize: 10,
                ),
              ),
              destination: 'https://invoice-system-flutter.web.app/')
        ],
      );

  pw.Widget buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInvoiceInfo(),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UrlLink(
                  child: Text(
                    "Invoice Link",
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: PdfColors.blueAccent,
                      fontSize: 15,
                    ),
                  ),
                  destination: Link),
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
                  child: Text(invoice.name)),
            ],
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  pdf.addPage(MultiPage(
    pageTheme: PageTheme(
 //       margin: const EdgeInsets.all(1),
        theme: ThemeData.withFont(
            fontFallback: [regular],
            base: arabicFont,
            italic: italic,
            bold: bold,
            boldItalic: boldItalic),
        buildBackground: (pw.Context context) {
          return FullPage(
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
                        data: Link,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: PdfColors.white,
                          fontBold: bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ]));
        }),
    build: (context) => [
      buildHeader(),
      SizedBox(height: 1 * PdfPageFormat.cm),
      buildInvoice(),
      Divider(),
    ],
    footer: (context) => buildFooter(),
  ));
  return pdf.save();
}
