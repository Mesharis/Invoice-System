import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/widgets/extensions.dart';
import 'package:invoice/widgets/pallete.dart';
import '../Model/SettingsModel.dart';
import '../Model/enum.dart';
import '../utils/FirebaseManager.dart';




class Edit_VAT extends StatefulWidget {
  SettingsModel? updateUser;
  UserType?  userType;
  String? uidUserActive;
  String? uidTeam;
  String? Email;
  String? id;

  Edit_VAT({Key? key, this.updateUser , this.id ,this.userType, this.uidUserActive ,this.uidTeam,this.Email}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Edit_VATState();
}

class _Edit_VATState extends State<Edit_VAT> {

  late String vat;
  late String Tax_Number;
  late String Team_Name;
  late String Logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/2560px-Google-flutter-logo.svg.png";
  late String id;
  late bool review;

  @override
  void initState() {
    super.initState();
    if (widget.updateUser != null) {
      vat = widget.updateUser!.vat!.toString();
      Tax_Number = widget.updateUser!.Tax_Number!;
      Team_Name = widget.updateUser!.Team_Name!;
      Logo = widget.updateUser!.Logo!;
      review = widget.updateUser!.review!;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    width: 400,
                    color: Colors.white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                maxRadius: 60,
                                backgroundColor: Colors.white,
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Image.network(
                                      scale: 1,
                                      Logo,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              Positioned.directional(
                                textDirection:
                                Directionality.of(
                                    context),
                                end: 0,
                                bottom: 0,
                                child: Material(
                                  clipBehavior:
                                  Clip.antiAlias,
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      40),
                                  child: InkWell(
                                    onTap: () async {
                                      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      Logo = await FirebaseManager.shared.uploadImage(folderName: widget.Email!, imagePath: file);
                                      if (Logo != null) {
                                        setState(() {
                                          Logo = Logo;
                                        });
                                      }
                                    },
                                    radius: 50,
                                    child: const SizedBox(
                                      width: 35,
                                      height: 35,
                                      child: Icon(
                                          Icons.arrow_upward),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: Team_Name,
                            obscureText: false,
                            onChanged: (val) => setState(() => Team_Name = val),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration:
                             InputDecoration(focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                              hintText:
                              'Enter Your Merchant Name'.tr,
                              labelText: 'Merchant Name'.tr,
                               labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                              border:
                              OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: vat.toString(),
                            obscureText: false,
                            onChanged: (val) => setState(() => vat = val),
                            keyboardType:
                            TextInputType.number,
                            textInputAction:
                            TextInputAction.next,
                            decoration: InputDecoration(
                              focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                              hintText:
                              'Enter Your VAT %'.tr,
                              labelText: 'VAT %'.tr,
                              labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                              border:
                              OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            initialValue: Tax_Number,
                            obscureText: false,
                            onChanged: (val) => setState(() => Tax_Number = val),
                            keyboardType:
                            TextInputType.text,
                            textInputAction:
                            TextInputAction.done,
                            decoration: InputDecoration(
                              focusedBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                              hintText:
                              'Enter Your Number VAT'.tr,
                              labelText: 'Number VAT'.tr,
                              labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                              border:
                              OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Visibility(
                            visible: widget.userType != UserType.USER,
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("review".tr),
                                Switch(
                                  activeColor: OMNIColors.BlackBolor,
                                  value: review,
                                  onChanged: (value) {
                                    setState(() {
                                      review = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ), //
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  OMNIColors.backgroundColor,
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
                              onPressed: () =>
                                  _btnChange(widget.uidTeam),
                              child: Text(
                                "Save".tr,
                              style: TextStyle(color:OMNIColors.BlackBolor)),
                            ),
                          )
                        ])))));
  }


  _btnChange(String? uid) async {
    if (Team_Name == "" || vat == "") {
      Get.customSnackbar(
        title: "Error".tr,
        message:
        "Please enter all fields".tr,
        isError: true,
      );
      return;
    }
    FirebaseManager.shared.Settings(
        vat: double.parse("${vat}"),
        Tax_Number: Tax_Number,
        uid: uid!,
        review: review,
        Logo: Logo,
        Name_Team: Team_Name,
      );
      await FirebaseManager.shared.getAllsystem().first.then((omni) {
        for (var system in omni) {
          FirebaseManager.shared.addNotifications(
              uidUser: system.uid,
              title: "${widget.uidUserActive} Edit ${widget.id}",
              details: "change setting Account",
          );
        }
      });
    }
}