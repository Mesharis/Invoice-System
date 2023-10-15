import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/widgets/pallete.dart';
import 'package:invoice/widgets/vilidator.dart';
import '../Model/enum.dart';
import '../utils/FirebaseManager.dart';

class ADD_TEAM extends StatefulWidget {
  final String uid;

  const ADD_TEAM(this.uid, {Key? key}) : super(key: key);

  @override
  State<ADD_TEAM> createState() => _ADD_TEAMState();
}

class _ADD_TEAMState extends State<ADD_TEAM> {
  Validator validator = Validator();
  String? email;
  String? password;
  String? Phone;
  String? username;
  String? city;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: OMNIColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    width: 400,
                    color: OMNIColors.backgroundColor,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            iconSize: 24,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          Center(
                            child: Text(
                              'Register Team account'.tr,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: SafeArea(
                                  child: Form(
                                      key: _formKey,
                                      autovalidateMode: AutovalidateMode.always,
                                      onChanged: () {
                                        Form.of(primaryFocus!.context!).save();
                                      },
                                      child: Column(children: [
                                        TextFormField(
                                          validator: (email) {
                                            return validator
                                                .validateEmail(email!);
                                          },
                                          onSaved: (value) =>
                                              email = value!.trim(),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: OMNIColors
                                                            .BlackBolor)),
                                            hintText: 'Enter Your Email'.tr,
                                            labelText: 'Email'.tr,
                                            labelStyle: const TextStyle(
                                                color: OMNIColors.BlackBolor),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: (username) {
                                            return validator
                                                .validatvalue(username!);
                                          },
                                          onSaved: (value) =>
                                              username = value!.trim(),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: OMNIColors
                                                            .BlackBolor)),
                                            hintText: 'Enter username'.tr,
                                            labelText: 'username'.tr,
                                            labelStyle: const TextStyle(
                                                color: OMNIColors.BlackBolor),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: (Phone) {
                                            return validator
                                                .validateMobile(Phone!);
                                          },
                                          onSaved: (value) =>
                                              Phone = value!.trim(),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: OMNIColors
                                                            .BlackBolor)),
                                            hintText:
                                                'Please enter mobile phone number'
                                                    .tr,
                                            labelText: 'phone'.tr,
                                            labelStyle: const TextStyle(
                                                color: OMNIColors.BlackBolor),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: (city) {
                                            return validator
                                                .validatvalue(city!);
                                          },
                                          onSaved: (value) =>
                                              city = value!.trim(),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: OMNIColors
                                                            .BlackBolor)),
                                            hintText: 'Enter country'.tr,
                                            labelText: 'country'.tr,
                                            labelStyle: const TextStyle(
                                                color: OMNIColors.BlackBolor),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: (password) {
                                            return validator
                                                .validatepass(password!);
                                          },
                                          obscureText: true,
                                          onSaved: (value) =>
                                              password = value!.trim(),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your Password'.tr,
                                            labelText: 'Password'.tr,
                                            labelStyle: const TextStyle(
                                                color: OMNIColors.BlackBolor),
                                            border: const OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ])))),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  FirebaseManager.shared.createAccountUser(
                                    userType: UserType.USER,
                                    email: email!,
                                    phone: Phone!,
                                    password: password!,
                                    uid_Team: widget.uid,
                                    city: city!,
                                    name: username!,
                                  );
                                  Get.back();
                                }
                              },
                              child: Text(
                                "Save".tr,
                                style: const TextStyle(color: OMNIColors.BlackBolor),
                              ),
                            ),
                          )
                        ])))));
  }
}
