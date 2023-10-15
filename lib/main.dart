import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:invoice/widgets/language.dart';
import 'package:invoice/widgets/routes.dart';
import 'package:invoice/unknown/unknown_route.dart';
import 'package:invoice/Model/user_profile.dart';
import 'utils/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// This function is used to update the page title
void setPageTitle(String title, BuildContext context) {
  SystemChrome.setApplicationSwitcherDescription(ApplicationSwitcherDescription(
    label: title,
    primaryColor: Theme.of(context).primaryColor.value, // This line is required
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      debugShowCheckedModeBanner: false,
      translations: LocalizationService(),
      locale: UserProfile.shared.language?.locale ?? Get.deviceLocale,
      fallbackLocale: Get.deviceLocale,
      theme: ThemeData(
        primarySwatch:Colors.grey,
        canvasColor: Colors.white,
        fontFamily: 'HacenTunisia',

      ),
      title: 'Waiting'.tr,
      initialRoute: '/',
      unknownRoute: GetPage(name: '/unknown', page: () => const UnknownRoute()),
      getPages: getPages,
    );
  }
}