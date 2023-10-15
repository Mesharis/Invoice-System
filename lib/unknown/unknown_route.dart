import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/pallete.dart';


class UnknownRoute extends StatelessWidget {
  const UnknownRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OMNIColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.error,
                color: OMNIColors.redolor,
                size: 48,
              ),
            ),
            SizedBox(
              width: 250,
              child: Text(
                'This page does not exist or you do not have permission to access this page.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 250,
                child: GestureDetector(
                  onTap: () {
                    Get.offNamed('/');
                  },
                  child: Text(
                    '>> Back to home',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
