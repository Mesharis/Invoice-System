import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/widgets/pallete.dart';


class ChatWidget extends StatelessWidget {
  String uid;

   ChatWidget({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
         return Padding(
              padding: const EdgeInsets.all(5),
              child: Stack(
                children: [
                  IconButton(
                      icon:  Icon(Icons.chat_bubble_outline, color: OMNIColors.BlackBolor,),
                      tooltip: "Notifications".tr,
                      onPressed: () {}),
                ],
              ),
    );
  }
}
