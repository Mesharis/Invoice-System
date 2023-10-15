import 'package:flutter/material.dart';
import '../widgets/AuthMode.dart';
import '../widgets/pallete.dart';

class NoLoginRoute extends StatelessWidget {
  const NoLoginRoute({Key? key}) : super(key: key);

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
                'You need to be logged in to access this page.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 250,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AuthGate(),
                    );
                    },
                  child: Text(
                    '>> Go to login',
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
