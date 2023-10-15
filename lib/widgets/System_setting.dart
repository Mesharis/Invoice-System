import 'package:Crack/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoice/widgets/pallete.dart';
import '../Model/systemnodel.dart';
import '../utils/FirebaseManager.dart';

class System_setting extends StatefulWidget {
  systemmodel? update;

  System_setting({
    Key? key,
    this.update,
  }) : super(key: key);

  @override
  State<System_setting> createState() => _System_settingState();
}

class _System_settingState extends State<System_setting> {
  @override
  List<String> _images = [];
  late bool googlelogin;
  late bool systemads;
  late String uid;
  late String titleEn;
  late String titleAr;

  @override
  void initState() {
    super.initState();
    if (widget.update != null) {
      _images = widget.update!.Ads;
      googlelogin = widget.update!.googlelogin;
      systemads = widget.update!.systemads;
      titleAr = widget.update!.titleAr;
      titleEn = widget.update!.titleEn;
      uid = FirebaseManager.shared.auth.currentUser!.uid;
    }
  }

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
                  child: Column(
                    children: [
                      _renderSlider(images: _images),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: titleEn,
                        textAlign: TextAlign.center,
                        cursorColor: OMNIColors.BlackBolor,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: OMNIColors.BlackBolor)),
                          hintText: 'title_System_EN'.tr,
                          labelText: 'title_System_EN'.tr,
                          labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue: titleAr,
                        textAlign: TextAlign.center,
                        cursorColor: OMNIColors.BlackBolor,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: OMNIColors.BlackBolor)),
                          hintText: 'title_System_Ar'.tr,
                          labelText: 'title_System_Ar'.tr,
                          labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("ADS".tr),
                          Switch(
                            activeColor: OMNIColors.BlackBolor,
                            value: systemads,
                            onChanged: (value) {
                              setState(() {
                                systemads = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Login with Google".tr),
                          Switch(
                            activeColor: OMNIColors.BlackBolor,
                            value: googlelogin,
                            onChanged: (value) {
                              setState(() {
                                googlelogin = value;
                              });
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseManager.shared.systemupdate(
                            images: _images,
                            uid: uid,
                            ads: systemads,
                            google: googlelogin,
                            titleEn: titleEn,
                            titleAr: titleAr,
                          );
                          Get.back();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.all(10),
                          ),
                        ),
                        child: Text("Save".tr,
                            style: TextStyle(color: OMNIColors.BlackBolor)),
                      ),
                    ],
                  ),
                ))));
  }

  _renderSlider({required List<String> images}) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * (380 / 812),
        enableInfiniteScroll: false,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: [...images, "empty"].map((item) {
        return Builder(
          builder: (BuildContext context) {
            return item == "empty"
                ? _addImage(context)
                : InkWell(
                    onTap: () {
                      _deleteImage(item);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Image.network(
                        scale: 1,
                        item,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
          },
        );
      }).toList(),
    );
  }

  _getImage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: OMNIColors.BlackBolor,
                  ),
                  title: Text(
                    'Camera'.tr,
                    style: TextStyle(color: OMNIColors.BlackBolor),
                  ),
                  onTap: () => _selectImage(imageSource: ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(
                    Icons.image,
                    color: OMNIColors.BlackBolor,
                  ),
                  title: Text(
                    'Gallery'.tr,
                    style: TextStyle(color: OMNIColors.BlackBolor),
                  ),
                  onTap: () => _selectImage(imageSource: ImageSource.gallery),
                ),
              ],
            ),
          );
        });
  }

  Widget _addImage(context) {
    return InkWell(
      onTap: () => _getImage(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: OMNIColors.BlackBolor),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 56,
            color: OMNIColors.BlackBolor,
          ),
        ),
      ),
    );
  }

  _selectImage({required ImageSource imageSource}) async {
    final image = await ImagePicker().pickImage(source: imageSource);
    String? task = await FirebaseManager.shared
        .uploadImage(folderName: "system", imagePath: image);
    if (task != null) {
      setState(() {
        _images = [..._images, task];
      });
    }
    Get.back();
  }

  _deleteImage(String image) {
    setState(() {
      _images.remove(image);
    });
  }
}
