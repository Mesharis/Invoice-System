import 'package:backdrop/backdrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/Model/user_profile.dart';
import 'package:invoice/widgets/language.dart';
import '../Model/systemnodel.dart';
import '../main.dart';
import '../utils/FirebaseManager.dart';
import '../widgets/AuthMode.dart';
import '../widgets/pallete.dart';
import 'HomeMASTAR.dart';
import '../widgets/footer.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      if (value == null) {
        return;
      }
      Get.updateLocale(value.locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Scaffold(
                    body: Center(
                        child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child:
                            Text('خطأ أثناء الاتصال: لا يوجد اتصال بالإنترنت',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ))),
                  ],
                )));
              } else if (snapshot.hasData) {
                return MASTAR();
              } else {
                return wrapper();
              }
          }
        });
  }
}

class wrapper extends StatefulWidget {
  wrapper({Key? key}) : super(key: key);

  @override
  State<wrapper> createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  LanguageEnum? lang;

  void initState() {
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      if (value != null) {
        setState(() {
          lang = value;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return StreamBuilder<systemmodel>(
        stream: FirebaseManager.shared.systemwhere(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              setPageTitle('Waiting'.tr, context);
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            default:
              if (snapshot.hasError) {
                setPageTitle('Create Your System'.tr, context);
                return Scaffold(
                    body: Center(
                        child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: TextButton(
                          onPressed: () async {
                            FirebaseManager.shared.systemset();
                          },
                          child: Text(
                            'Create Your System'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          )),
                    ),
                  ],
                )));
              } else if (snapshot.hasData) {
                systemmodel items = snapshot.data!;
                setPageTitle(
                    lang == LanguageEnum.arabic
                        ? items.titleAr
                        : lang == LanguageEnum.english
                            ? items.titleEn
                            : Get.deviceLocale.toString() == 'ar'
                                ? items.titleAr
                                : items.titleEn,
                    context);
                return BackdropScaffold(
                  appBar: BackdropAppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(
                        lang == LanguageEnum.arabic
                            ? items.titleAr
                            : lang == LanguageEnum.english
                                ? items.titleEn
                                : Get.deviceLocale.toString() == 'ar'
                                    ? items.titleAr
                                    : items.titleEn,
                        style: const TextStyle(color: OMNIColors.backgroundColor)),
                    centerTitle: true,
                    actions: [
                      Text(Get.deviceLocale.toString(),
                          style: const TextStyle(color: OMNIColors.backgroundColor))
                    ],
                  ),
                  backLayer: ListView(
                    padding: const EdgeInsets.only(bottom: 128.0),
                    children: <Widget>[
                      ListTile(
                        leading: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 30,
                            child: Icon(
                              color: OMNIColors.backgroundColor,
                              Icons.person,
                              size: 50,
                            )),
                        title: InkWell(
                          onTap: () {
                            Get.dialog(const AuthGate());
                          },
                          child: Text(
                            'Login'.tr,
                            style: const TextStyle(
                              color: OMNIColors.backgroundColor,
                            ),
                          ),
                        ),
                        trailing: InkWell(
                            onTap: () =>
                                FirebaseManager.shared.changeLanguage(context),
                            child: const Icon(Icons.language ,color: OMNIColors.backgroundColor,)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                "Privacy Policy".tr,
                                style: const TextStyle(
                                  color: OMNIColors.backgroundColor,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: const Text(
                              "|",
                              style: TextStyle(
                                color: OMNIColors.backgroundColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                "Terms & Conditions".tr,
                                style: const TextStyle(
                                  color: OMNIColors.backgroundColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(color: OMNIColors.backgroundColor,),
                      const SizedBox(
                        height: 50.0,
                      ),
                    ],
                  ),
                  backLayerBackgroundColor: Colors.transparent,
                  subHeader: Visibility(
                    visible: items.systemads,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        FirebaseManager.shared
                            .renderSlider(context, images: items.Ads),
                      ],
                    ),
                  ),
                  frontLayer: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 50.0,
                      ),
                      const SizedBox(
                        height: 100.0,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 28.0)),
                      Footer(items),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
          }
        });
  }
}
