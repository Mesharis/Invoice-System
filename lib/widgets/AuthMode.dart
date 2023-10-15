import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/widgets/extensions.dart';
import 'package:invoice/widgets/pallete.dart';

import '../Model/enum.dart';
import '../Model/systemnodel.dart';
import '../utils/FirebaseManager.dart';
import 'vilidator.dart';

extension on AuthMode {
  String get label => this == AuthMode.login
      ? 'Login'.tr
      : this == AuthMode.phone
          ? 'Rest password'.tr
          : this == AuthMode.login
              ? 'Hello Word'
              : 'Register Now'.tr;
}

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AuthMode mode = AuthMode.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String email;
  late String password;
  final TextEditingController _emailController = TextEditingController();
  Validator validator = Validator();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<systemmodel>(
        stream: FirebaseManager.shared.systemwhere(),
        builder: (context, snapshot) {
          bool system = snapshot.hasData;
          return Dialog(
              backgroundColor:OMNIColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 400,
                  color:OMNIColors.backgroundColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            mode == AuthMode.login
                                ? 'Login'.tr
                                : mode == AuthMode.phone
                                    ? 'Rest password'.tr
                                    : mode == AuthMode.login
                                        ? 'Hello Word'
                                        : 'Register Now'.tr,
                              style: TextStyle(fontSize: 15 , fontWeight: FontWeight.bold,color: OMNIColors.BlackBolor)

                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SafeArea(
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (mode != AuthMode.phone)
                                      Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            textAlign: TextAlign.center,
                                            cursorColor: OMNIColors.BlackBolor,
                                            validator: (email) {
                                              return validator
                                                  .validateEmail(email!);
                                            },
                                            controller: _emailController,
                                            onSaved: (value) => email = value!.trim(),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textInputAction:
                                                TextInputAction.next,
                                              decoration: InputDecoration(
                                                focusedBorder:  UnderlineInputBorder(
                                                    borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                                ),
                                              hintText: 'Enter Your Email'.tr,
                                              labelText: 'Email'.tr,
                                                labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            textAlign: TextAlign.center,
                                            cursorColor: OMNIColors.BlackBolor,
                                            validator: (password) {
                                              return validator
                                                  .validatepass(password!);
                                            },
                                            obscureText: true,
                                            onSaved: (value) =>
                                                password = value!.trim(),
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration:  InputDecoration(
                                              focusedBorder: const UnderlineInputBorder(
                                                  borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                              ),
                                              hintText: 'Enter Your Password'.tr,
                                              labelText: 'Password'.tr,
                                              labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (mode == AuthMode.phone)
                                      TextFormField(
                                        textAlign: TextAlign.center,
                                        cursorColor: OMNIColors.BlackBolor,
                                        validator: (Email) {
                                          return validator
                                              .validateEmail(Email!);
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        textInputAction: TextInputAction.done,
                                        onSaved: (value) =>
                                            email = value!.trim(),
                                        decoration:  InputDecoration(
                                          focusedBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                          ),
                                          hintText: 'Enter Your Email'.tr,
                                          labelText: 'Email'.tr,
                                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(OMNIColors.BlackBolor)),
                                        onPressed:_emailAndPassword,
                                        child: Text(mode.label,style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: OutlinedButton(
                                        onPressed: () {
                                                if (mode != AuthMode.phone) {
                                                  setState(() {
                                                    mode = AuthMode.phone;
                                                  });
                                                } else {
                                                  setState(() {
                                                    mode = AuthMode.login;
                                                  });
                                                }
                                              },
                                        child: Text(
                                                mode != AuthMode.phone
                                                    ? 'Forgot password'.tr
                                                    : 'Sign in with Email and Password'.tr
                                          ,style: TextStyle(color: OMNIColors.BlackBolor),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 40.0,
                                        right: 40.0,
                                      ),
                                      child: Container(
                                        height: 1,
                                        width: double.maxFinite,
                                        color: OMNIColors.BlackBolor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (mode != AuthMode.phone)
                                      RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          children: [
                                            TextSpan(
                                              text: mode == AuthMode.login
                                                  ? "Don't have an account? ".tr
                                                  : 'You have an account? '.tr,
                                              style: TextStyle(fontSize: 11 , fontWeight: FontWeight.bold,)
                                            ),
                                            TextSpan(
                                              text: mode == AuthMode.login
                                                  ? 'Register Now'.tr
                                                  : 'Click to login'.tr,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  setState(() {
                                                    mode =
                                                        mode == AuthMode.login
                                                            ? AuthMode.register
                                                            : AuthMode.login;
                                                  });
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 20),
                                    Center(
                                        child: Visibility(
                                      visible: system ? snapshot.data!.googlelogin : false,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            FirebaseManager.shared
                                                .signInGoogle();
                                          },
                                          child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Image(
                                                      image: AssetImage(
                                                          "lib/img/google_logo.png"),
                                                      height: 15.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20),
                                                      child: Text(
                                                        'Login with Google'.tr,
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: OMNIColors.BlackBolor,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
              )));
        });
  }

  Future<void> _emailAndPassword() async {
    try {
      if (mode == AuthMode.login) {
        _formKey.currentState!.save();
        if (_formKey.currentState!.validate()) {
          FirebaseManager.shared.signInWithEmailAndPassword(email: email, password: password);
        }
      } else if (mode == AuthMode.register) {
        _formKey.currentState!.save();
        if (_formKey.currentState!.validate()) {
          FirebaseManager.shared.createAccountUser(
            name: "username",
            phone: "phoneNumber",
            email: email,
            city: "city",
            password: password,
            userType: UserType.USER,
          ).then((value) async {
            FirebaseManager.shared.signInWithEmailAndPassword(email: email, password: password);
          });
        }
      } else {
        await Password_reset();
      }
    } finally {
    }
  }

  Future<void> Password_reset() async {
    if (mode != AuthMode.phone) {
      setState(() {
        mode = AuthMode.phone;
      });
    } else {
      _formKey.currentState!.save();
      if (email != "") {
        bool success = await FirebaseManager.shared.forgotPassword(email: email);
        if (success) {
          _emailController.text = "";
          Get.customSnackbar(
            title: "successful".tr,
            message: "The link has been sent to your email".tr,
            isError: false,
          );
        }
      } else {
        Get.customSnackbar(
          title: "Error".tr,
          message: "Please enter email".tr,
          isError: true,
        );
      }
    }
  }
}
