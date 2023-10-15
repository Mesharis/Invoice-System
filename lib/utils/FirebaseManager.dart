import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Crack/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/Model/notification-model.dart';
import 'package:invoice/Model/user-model.dart';
import 'package:invoice/widgets/extensions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Model/enum.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import '../Model/InvoiceModel.dart';
import '../Model/SettingsModel.dart';
import '../Model/invoice1model.dart';
import '../Model/systemnodel.dart';
import '../Model/user_profile.dart';
import '../widgets/language.dart';


class FirebaseManager {
  static final FirebaseManager shared = FirebaseManager();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final userRef = FirebaseFirestore.instance.collection('Users');
  final invoiceRef = FirebaseFirestore.instance.collection('invoicee');
  final systemRef = FirebaseFirestore.instance.collection('system');

//TODO:- Start system
  systemset() async {
    systemRef.doc('Beta').set({
    "Ads": "",
    "title_ar": "المدفوعات الفاتورة",
    "title_en": "invoice payments",
    "googlelogin": false,
    "systemads": false,
    "uid": null,
    "Version": "Beta",
    "Totel_USER": 0,
    "Totel_INVOICE": 0,
  });}
  systemupdate({required String titleEn,required String titleAr,required String uid,required bool ads,required bool google,required List<String> images}) async {
    systemRef.doc('Beta').update({
    "Ads": images.join( " , "),
    "googlelogin": google,
    "systemads": ads,
    "uid": uid,
    "title_en": titleEn,
    "title_ar": titleAr,
    });
  }
  systeadduser(add) async {
    systemRef.doc('Beta').update({
      "Totel_USER": add,
    });
  }
  systeaddInvoice(add) async {
    systemRef.doc('Beta').update({
      "Totel_INVOICE": add,
    });
  }
  Stream<List<systemmodel>> getAllsystem() {
    return systemRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return systemmodel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<systemmodel> systemwhere() {
    return systemRef.where("Version", isEqualTo: 'Beta').snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return systemmodel.fromJson(doc.data());
      }).first;
    });
  }
//TODO:- end system

//TODO:- Start User
  signInGoogle() async {
     if (kIsWeb) {
       GoogleAuthProvider authProvider = GoogleAuthProvider();
       try {
         final UserCredential userCredential = await auth.signInWithPopup(authProvider);
         DocumentSnapshot doc = await userRef.doc(userCredential.user!.uid).get();
         if (!doc.exists) {
           createGoogle( user: userCredential, userType: UserType.USER);
         } else {
           await getUserByUid(uid: userCredential.user!.uid).then((UserModel user) {
             switch (user.accountStatus) {
               case Status.ACTIVE:
                 Get.back();
                 break;
               case Status.Deleted:
                 Get.customSnackbar(
                   title: "Error".tr,
                   message: "Your account has been deleted".tr,
                   isError: true,
                 );
                 auth.signOut();
                 break;
               case Status.Disable:
                 Get.customSnackbar(
                   title: "Error".tr,
                   message: "Your account has been disabled".tr,
                   isError: true,
                 );
                 auth.signOut();
                 break;
             }
           });
         }
       } catch (e) {
         print(e);
       }
     } else {
       final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: "500159637805-t8peuoi1kipaje9tlthpqnjfrfpqup4t.apps.googleusercontent.com").signIn();
       final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
       final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,);
       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
       DocumentSnapshot doc = await userRef.doc(userCredential.user!.uid).get();
       if (!doc.exists) {
         createGoogle( user: userCredential, userType: UserType.USER);
       } else {
         await getUserByUid(uid: userCredential.user!.uid).then((UserModel user) {
           switch (user.accountStatus) {
             case Status.ACTIVE:
               Get.back();
               break;
             case Status.Deleted:
               Get.customSnackbar(
                 title: "Error".tr,
                 message: "Your account has been deleted".tr,
                 isError: true,
               );
               auth.signOut();
               break;
             case Status.Disable:
               Get.customSnackbar(
                 title: "Error".tr,
                 message: "Your account has been disabled".tr,
                 isError: true,
               );
               auth.signOut();
               break;
           }
         });
       }
     }
}
  createGoogle({required UserType userType,required UserCredential user,}) async {
     var userId = user.user!.uid;
     if (userId != null) {
       userRef.doc(userId).set({
         "id": "${Random().nextInt(999)}",
         "image": user.user!.photoURL,
         "name": user.user!.displayName,
         "phone": user.user!.phoneNumber == null ? "" : user.user!.phoneNumber,
         "email": user.user!.email,
         "city": "",
         "Firebase!": {"emailVerified": user.user!.emailVerified},
         "support": false,
         "uid_Team": userId,
         "status-account": 0,
         "createdDate": DateTime.now().toString(),
         "type_user": userType.index,
         "uid": userId,
       }).then((value) async {
         addNotifications(uidUser: userId, title: "Welcome", details: "Welcome to our app\nWe wish you a happy experience");
         await getAllsystem().first.then((users) async {
           for (var OMNI in users) {
             addNotifications(uidUser: OMNI.uid, title: "New User",details: " ${user.user!.email} new created a new account");
             double add = OMNI.Totel_USER! + 1;
             print(add);
             systeadduser(add);
           }
         });
         await getUserByUid(uid: userId).then((UserModel user) {
           switch (user.accountStatus) {
             case Status.ACTIVE:
               Get.back();
               break;
             case Status.Deleted:
               Get.customSnackbar(
                 title: "Error".tr,
                 message: "Your account has been deleted".tr,
                 isError: true,
               );
               auth.signOut();
               break;
             case Status.Disable:
               Get.customSnackbar(
                 title: "Error".tr,
                 message: "Your account has been disabled".tr,
                 isError: true,
               );
               auth.signOut();
               break;
           }
         });
         Get.customSnackbar(
           title: "successful".tr,
           message: "created successfully, Your account in now under review".tr,
           isError: false,
         );
       }).catchError((err) {
         Get.customSnackbar(
           title: "Error".tr,
           message: "Something went wrong".tr,
           isError: true,
         );
       });
     } else {
     }
  }

  createAccountUser({required String name, required String phone, required String email, String? uid_Team, required String city, required String password, required UserType userType,}) async {
    var userId = await createAccountInFirebase(email: email, password: password);
    String imgUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/2560px-Google-flutter-logo.svg.png";
    if (userId != null) {
      userRef.doc(userId).set({
        "id": "${Random().nextInt(999)}",
        "image": imgUrl,
        "name": name,
        "phone": phone,
        "email": email,
        "city": city,
        "support": false,
        "uid_Team": uid_Team ?? userId,
        "status-account": 0,
        "createdDate": DateTime.now().toString(),
        "type_user": userType.index,
        "uid": userId,
      }).then((value) async {
        addNotifications(uidUser: userId, title: "Welcome", details: "Welcome to our app\nWe wish you a happy experience");
        await getAllsystem().first.then((users)  {
          for (var user in users) {
            addNotifications(uidUser: user.uid, title: "New User", details: "$email new created a new account");
            double add = user.Totel_USER! + 1;
            print(add);
            systeadduser(add);
          }
        });
        Get.customSnackbar(
          title: "successful".tr,
          message: "created successfully, Your account in now under review".tr,
          isError: false,
        );
      }).catchError((err) {
        Get.customSnackbar(
          title: "Error".tr,
          message: "Something went wrong".tr,
          isError: true,
        );
      });
    } else {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    }
  }
  void signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.currentUser?.reload();
      await getByuid(uid: auth.currentUser!.uid);
      final Firebase = FirebaseAuth.instance.currentUser;
      if (Firebase!.emailVerified == true) {
        FirebaseManager.shared.getUserByUid(uid: Firebase.uid).then((user) {
          switch (user.accountStatus) {
            case Status.ACTIVE:
              Get.back();
              break;
            case Status.Deleted:
              Get.customSnackbar(
                title: "Error".tr,
                message: "Your account has been deleted".tr,
                isError: true,
              );
              auth.signOut();
              break;
            case Status.Disable:
              Get.customSnackbar(
                title: "Error".tr,
                message: "Your account has been disabled".tr,
                isError: true,
              );
              auth.signOut();
              break;
          }
        });
      } else {
        Get.offNamed('/vieryemail');
      }
    } on FirebaseAuthException catch (e) {
      String? message;
      if (e.code == 'user-not-found') {
        message = "User not found".tr;
      } else if (e.code == 'wrong-password') {
        message = "Wrong password".tr;
      } else if (e.code == 'too-many-requests') {
        message = "Account temporarily locked".tr;
      } else {
        message = "Something went wrong! Please try again later".tr;
      }
      Get.customSnackbar(
        title: "Error".tr,
        message: message,
        isError: true,
      );
    } finally {}
  }


  Stream<UserModel> getByuid({required String? uid}) {
    return userRef.doc(uid).snapshots().map((QueryDocumentSnapshot) {
      return UserModel.fromJson(QueryDocumentSnapshot.data() ?? {});
    });
  }
  Stream<List<UserModel>> getAllUsers() {
    return userRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<UserModel>> getuid_Team({required String? uid}) {
    return userRef.where("uid_Team", isEqualTo: uid).snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<UserModel>> Online({required bool status}) {
    return userRef.where("support", isEqualTo: status).snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<UserModel>> getUsersBYsearch({required String Name, required String fieldType}) {
    return userRef.where(fieldType, isGreaterThanOrEqualTo: Name, isLessThan: '${Name}z').snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return UserModel.fromJson(doc.data());
      }).toList();
    });
  }
  Future<UserModel> getUserByUid({required String? uid}) async {
    UserModel userTemp;
    var user = await userRef.doc(uid).snapshots().first;
    userTemp = UserModel.fromJson(user.data());
    return userTemp;
  }
  update_team(context, {required String uid,required bool balance}) {
    userRef.doc(uid).update({
      "balance": balance,
    });
  }
  changeStatusAccount({required String userId, required Status status,}) {
    userRef.doc(userId).update({"status-account": status.index}).then((value) async {
      Get.customSnackbar(
        title: "successful".tr,
        message: "",
        isError: false,
      );
    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
  }
  changeTypeAccount({required String userId, required UserType userType,}) {
    userRef.doc(userId).update({"type_user": userType.index}).then((value) async {
      Get.customSnackbar(
        title: "successful".tr,
        message: "",
        isError: false,
      );
    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
  }
  changeStatusOnline({required String userId, required bool support}) {
    userRef.doc(userId).update({
      "support": support
    }).then((value) async {
      Get.customSnackbar(
        title: "successful".tr,
        message: "",
        isError: false,
      );
    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
  }
  updateAccount({required String url, required String uid, required String name,  required String email,  required String city,  required String phoneNumber,}) async {
    userRef.doc(uid).update({
      "image": url,
      "name": name,
      "phone": phoneNumber,
      "email": email,
      "city": city,
    }).then((value) async {
      final Firebase = FirebaseAuth.instance.currentUser;
      await Firebase?.updateEmail(email);
    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
  }
  Future<String?> createAccountInFirebase({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,);
      if (userCredential.user!.emailVerified == false){
        await userCredential.user!.sendEmailVerification();
      }
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.customSnackbar(
          title: "Error".tr,
          message: "the email is already used".tr,
          isError: true,
        );
      }
      return null;
    } catch (e) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
      print(e);
      return null;
    }
  }
  signOut(context) async {
    try {
      Get.offNamed('/');
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    }
 }
  forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email,);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.customSnackbar(
          title: "Error".tr,
          message: "user not found".tr,
          isError: true,
        );
        return false;
      }
    }
  }
  Settings({required double vat, required String Name_Team, required String Tax_Number, required bool review, required String uid, required String Logo}) async {
    userRef.doc(uid).collection("settings").doc(uid).set({
      "Logo": Logo,
      "review": review,
      "uid_Team": uid,
      "Tax_Number": Tax_Number,
      "balance": 0.0,
      "vat": vat,
      "Team_Name": Name_Team
    }).then((value) async {
      Get.back();
    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
  }
  Stream<SettingsModel> getsettingsByuid({required String uid}) {
    return userRef.doc(uid).collection("settings").doc(uid).snapshots().map((QueryDocumentSnapshot) {
      return SettingsModel.fromJson(QueryDocumentSnapshot.data() ?? {});
    });
  }
  Future<SettingsModel> getsettingsByUid({required String uid}) async {
    SettingsModel userTemp;
    var user = await userRef.doc(uid).collection("settings").doc(uid).snapshots().first;
    userTemp = SettingsModel.fromJson(user.data());
    return userTemp;
  }
//TODO:- End User

//TODO:- Start Notifications
  addNotifications({required String uidUser, required String title, required String details,}) async {
    String uid = userRef.doc().id;
    userRef.doc(uidUser).collection('Notification').doc(uid).set({
      "userid": uidUser,
      "title": title,
      "details": details,
      "createdDate": DateTime.now().toString(),
      "is-read": false,
      "uid": uid,
    }).then((value) {

    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
  }
  setNotificationRead({required String? uid }) async {
    List<NotificationModel> items = await getMyNotifications(uid: uid).first;
    for (var item in items) {
      if (item.userId == item.userId && !item.isRead) {
        userRef.doc(item.userId).collection('Notification').doc(item.uid).update({
          "is-read": true,
        });
      }
    }
  }
  Stream<List<NotificationModel>> getMyNotifications({required String? uid }) {
    return userRef.doc(uid).collection('Notification').where(
        "userid", isEqualTo: uid).snapshots().map((
        QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data());
      }).toList();
    });
  }
//TODO:- End Notifications

//todo invoce
  addinvoice({required String uid_Team,required String Server, required String? uid_owner, required String? idUser, required String? NameUser, required String? Tax_Number, required String name, required String phone, required double Total, required double VATTOTAL, VAT, required String email, required Payment payment, required String images,}) async {
    List<InvoiceModel> id = await getAllinvoicee().first;
    String? uid = invoiceRef.doc().id;
    invoiceRef.doc(uid).set({
      "id": "${id.length}${Random().nextInt(9999)}",
      "invoice": payment.index,
      "Total": Total,
      "VATTOTAL": VATTOTAL,
      "VAT": VAT,
      "idUser": idUser,
      "Server": Server,
      "NameUser": NameUser,
      "Tax_Number": Tax_Number == null ? "" : Tax_Number,
      "images": images == null ? "" : images,
      "createdDate": DateTime.now(),
      "uid_owner": uid_owner,
      "name": name == null ? "" : name,
      "phone": phone == null ? "" : phone,
      "email": email == null ? "" : email,
      "uid_Team": uid_Team == null ? "" : uid_Team,
      "uid": uid,
    }).then((value) {
      Get.offNamed('/Invoice/$uid');
    }).catchError((err) {
      Get.customSnackbar(
        title: "Error".tr,
        message: "Something went wrong".tr,
        isError: true,
      );
    });
    return uid;
}
  addinvoiceDitiles({stockItemName, rate, billedQty, taxAmount, vat, uid ,dis ,discount}) async {
      invoiceRef.doc(uid).collection("Ditiles").doc().set({
      'item_name': stockItemName,
      'Price': rate,
      'qty': billedQty,
      'tax': taxAmount,
      'vat': vat,
      'dis': dis,
      'Discount': discount,
    });
  }
  Stream<List<Meshari>> getAllData({required String ID}) {
    return invoiceRef.doc(ID).collection("Ditiles").snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return Meshari.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<InvoiceModel>> getAllinvoicee() {
    return invoiceRef.snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return InvoiceModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<InvoiceModel>> getinvoicedone({required Payment status}) {
    return invoiceRef.where("invoice", isEqualTo: status.index).snapshots()
        .map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return InvoiceModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<InvoiceModel>> invoicebyuid({required String uid}) {
    return invoiceRef.where("uid_Team", isEqualTo: uid).snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return InvoiceModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<List<InvoiceModel>> invoice({required String uid}) {
    return invoiceRef.where("uid_owner", isEqualTo: uid).snapshots().map((QueryDocumentSnapshot) {
      return QueryDocumentSnapshot.docs.map((doc) {
        return InvoiceModel.fromJson(doc.data());
      }).toList();
    });
  }
  Stream<InvoiceModel> getinvoiceyId({required String id}) {
    return invoiceRef.doc(id).snapshots().map((QueryDocumentSnapshot) {
      return InvoiceModel.fromJson(QueryDocumentSnapshot.data());
    });
  }
  updateinvoicestatus({required String uid,required Payment payment}){
    invoiceRef.doc(uid).update({
      "invoice": payment.index,
    });
  }
//todo invoce end

//todo uploud img
  Future<String> uploadImage({required String folderName, required XFile? imagePath}) async {
    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref();
    final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg', customMetadata: {'picked-file-path': imagePath!.path});
    if (kIsWeb){
       uploadTask =  ref.child('$folderName').child('/${Random().nextInt(999)}image.jpg').putData(await imagePath.readAsBytes(),metadata);
      String url = await (await uploadTask).ref.getDownloadURL();
      return url;
    } else {
       uploadTask = ref.child('$folderName').child('/${Random().nextInt(999)}image.jpg').putFile(File(imagePath.path),metadata);
      String url = await (await uploadTask).ref.getDownloadURL();
      return url;
    }
}
//todo uploud end

//todo renderSlider start
  renderSlider(context, {required List<String> images}) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery
            .of(context)
            .size
            .height * (80 / 500),
        enableInfiniteScroll: true,
        autoPlay: true,
        viewportFraction: 1,
      ),
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: double.infinity,
                child: Image.network(
                  scale: 1,
                  image,
                  fit: BoxFit.cover,
                ));
          },
        );
      }).toList(),
    );
  }
//todo renderSlider end
  changeLanguage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                title: Text('English'.tr),
                onTap: () {
                  Get.updateLocale(LanguageEnum.english.locale);
                  UserProfile.shared.setLanguage(lang: LanguageEnum.english);
                  UserProfile.shared.language = LanguageEnum.english;
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Arabic'.tr),
                onTap: () {
                  Get.updateLocale(LanguageEnum.arabic.locale);
                  UserProfile.shared.setLanguage(lang: LanguageEnum.arabic);
                  UserProfile.shared.language = LanguageEnum.arabic;
                  Get.back();
                },
              ),
              ListTile(
                title: Text('Swedish'.tr),
                onTap: () {
                  Get.updateLocale(LanguageEnum.Swedish.locale);
                  UserProfile.shared.setLanguage(lang: LanguageEnum.Swedish);
                  UserProfile.shared.language = LanguageEnum.Swedish;
                  Get.back();
                },
              ),
              ListTile(
                title: Text('French'.tr),
                onTap: () {
                  Get.updateLocale(LanguageEnum.france.locale);
                  UserProfile.shared.setLanguage(lang: LanguageEnum.france);
                  UserProfile.shared.language = LanguageEnum.france;
                  Get.back();
                },
              ),
            ],
          );
        });
  }
}
