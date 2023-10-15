

import 'package:get/get.dart';

class Validator{
  String? validateMobile(String value) {
    String pattern = r'(^(?:[+0][0-9])?[0-9]*$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile phone number'.tr;
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid mobile phone number'.tr;
    }
    return null;
  }

  String? validateEmail(String value) {
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter email'.tr;
    } else if (!regExp.hasMatch(value)) {
      return 'please enter a working email address'.tr;
    }
    return null;
  }

  String? validatepass(String value) {
    if (value.isEmpty) {
      return 'Please enter the password'.tr;
    } else if (value.length < 8) {
      return 'Please enter a valid valid password more than 8 numbers and letters'.tr;
    }
    return null;
  }

  String? validatvalue(String value) {
    if (value.isEmpty) {
      return 'Please enter the value'.tr;
    }
    return null;
  }
}