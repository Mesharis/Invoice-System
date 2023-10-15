import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/Model/systemnodel.dart';
import 'package:invoice/widgets/pallete.dart';

import '../Model/user_profile.dart';
import 'language.dart';

class Footer extends StatefulWidget {
  systemmodel items;

  Footer(this.items, {Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {


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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Totel Users".tr,
                        style: const TextStyle(
                          color: OMNIColors.BlackBolor,

                        ),
                      ),
                      Text(
                        "${widget.items.Totel_USER}",
                        style: const TextStyle(
                          color: OMNIColors.BlackBolor,

                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text(
                          "|",
                          style: TextStyle(
                            color: OMNIColors.BlackBolor,

                          ),
                        ),
                      ),
                      Text(
                        "Totel Invoices".tr,
                        style: const TextStyle(
                          color: OMNIColors.BlackBolor,
                        ),
                      ),
                      Text(
                        "${widget.items.Totel_INVOICE} ",
                        style: const TextStyle(
                          color: OMNIColors.BlackBolor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50.0,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                        "Copyright".tr,
                          style: const TextStyle(
                            color: OMNIColors.BlackBolor,

                          ),
                        ),
                        const Text(
                          " ",
                          style: TextStyle(
                            color: OMNIColors.BlackBolor,

                          ),
                        ),
                        Text(lang == LanguageEnum.arabic ? widget.items.titleAr : lang == LanguageEnum.english ? widget.items.titleEn : Get.deviceLocale.toString() == 'ar' ? widget.items.titleAr : widget.items.titleEn ,
                          style: const TextStyle(
                            color: OMNIColors.BlackBolor,

                          ),
                        ),
                        const Text(
                          " ",
                          style: TextStyle(
                            color: OMNIColors.BlackBolor,

                          ),
                        ),
                        Text(
                        "All rights Reserved".tr,
                          style: const TextStyle(
                            color: OMNIColors.BlackBolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
