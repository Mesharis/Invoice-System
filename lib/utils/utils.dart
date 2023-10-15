import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => '${price.toStringAsFixed(2)}';
  static formatk(double price) => '${price.toStringAsFixed(0)} \K';
  static formatM(double price) => '${price.toStringAsFixed(0)} \M';
  static formatB(double price) => '${price.toStringAsFixed(0)} \B';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
