import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


extension StringExtensions on String {
  Color toHexa() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  String changeDateFormat({String format = 'yyyy-MM-dd'}) {
    String newData = "";
    DateTime dt = DateTime.parse(this);
    DateFormat formatter = DateFormat(format);
    newData = formatter.format(dt);
    return newData;
  }

}
extension DateTimeExtensions on DateTime {
  String convertToDateStringOnly() => "$year-$month-$day";
}
extension TextEditingControllerExtensions on TextEditingController {

  isEmptyValue() => text.trim().isNotEmpty && text.trim() != '';

}

extension CustomExtenstionGetInterface on GetInterface {
  void customSnackbar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
    );
  }
}
