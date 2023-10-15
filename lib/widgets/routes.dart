import 'package:get/get.dart';
import 'package:invoice/Home/splash.dart';
import 'package:invoice/unknown/unknown_route.dart';
import '../utils/Very-email.dart';
import 'PayInvoice.dart';
import '../unknown/not_logged_in.dart';

List<GetPage> getPages = [
  GetPage(name: '/', page: () =>  Splash()),
  GetPage(name: '/vieryemail', page: () =>  const vieryemail()),
  GetPage(name: '/Invoice/:InvoiceId', page: () =>  const PayInvoice()), // work (Url))
  GetPage(name: '/unknown', page: () => const UnknownRoute()),
  GetPage(name: '/NoLoginRoute', page: () => const NoLoginRoute()),
];

