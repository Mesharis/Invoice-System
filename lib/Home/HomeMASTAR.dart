import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Crack/stepper.dart';
import 'package:invoice/widgets/q_invoice.dart';
import '../pdf/template_personal.dart';
import '../widgets/ADD_TEAM.dart';
import '../utils/FirebaseManager.dart';
import 'package:invoice/widgets/extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import '../Model/enum.dart';
import '../Model/InvoiceModel.dart';
import '../Model/SettingsModel.dart';
import '../Model/notification-model.dart';
import '../Model/systemnodel.dart';
import '../Model/user-model.dart';
import '../main.dart';
import '../pdf/pdf_invoice_api.dart';
import '../utils/utils.dart';
import '../unknown/unknown_route.dart';
import '../widgets/Setting.dart';
import '../widgets/chart.dart';
import '../widgets/pallete.dart';
import '../widgets/System_setting.dart';

class MASTAR extends StatefulWidget {
  bool searchMode = false;

  MASTAR({Key? key}) : super(key: key);

  @override
  State<MASTAR> createState() => _MASTARState();
}

class _MASTARState extends State<MASTAR> {
  final TextEditingController? searchTextField = TextEditingController();
  Page_OMNI userOMNI = Page_OMNI.AllHome;
  Status status = Status.ACTIVE;
  UserType userType = UserType.USER;
  bool OMNI_Widget = true;
  bool PROFILE_Widget = true;
  bool Notifications = true;
  UserModel? TEWAMLISTOMNI;

  String? title;
  String? details;
  String totalMoney = '';
  String? name;
  String? phone;
  String? email;
  String? city;
  String? UID_TEAM;
  String totalMoneyToday = '';
  String? LOGO;
  ScrollController? _contoller;

  @override
  void initState() {
    super.initState();
    _contoller = ScrollController();
  }

  @override
  void dispose() {
    searchTextField!.dispose();
    super.dispose();
  }

  Widget appBarTitle = Text(
    "Users".tr,
    style: const TextStyle(color: Colors.black54),
  );
  Icon actionIcon = const Icon(
    Icons.search,
    color: Colors.black,
  );

  @override
  Widget build(BuildContext context) {
    return PAGE_OMNI_START();
  }

  PAGE_OMNI_START() {
    if (userOMNI == Page_OMNI.AllHome) {
      return PAGEMASTAR();
    } else if (userOMNI == Page_OMNI.AllUser) {
      return AllUSERS_OMNI();
    } else if (userOMNI == Page_OMNI.TEAM_OMNI) {
      return TEAM_LIST_OMNI(TEWAMLISTOMNI!);
    } else if (userOMNI == Page_OMNI.Invoice_Mastar) {
      return Invoice_Mastar();
    }
  }

  Widget PAGEMASTAR() {
    return Notifications
        ? StreamBuilder<systemmodel>(
            stream: FirebaseManager.shared.systemwhere(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                systemmodel items = snapshot.data!;
                return StreamBuilder<UserModel>(
                    stream: FirebaseManager.shared.getByuid(
                        uid: FirebaseManager.shared.auth.currentUser!.uid),
                    builder: (BuildContext, AsyncSnapshot) {
                      if (AsyncSnapshot.hasData) {
                        if (OMNI_Widget == true && PROFILE_Widget == true) {
                          setPageTitle('Dashboard'.tr, context);
                        } else if (OMNI_Widget == false &&
                            PROFILE_Widget == true) {
                          setPageTitle('Support'.tr, context);
                        } else if (OMNI_Widget == true &&
                            PROFILE_Widget == false) {
                          setPageTitle('Dashboard/Profile'.tr, context);
                        } else if (OMNI_Widget == false &&
                            PROFILE_Widget == false) {
                          setPageTitle('Support/Profile'.tr, context);
                        }
                        UserModel User = AsyncSnapshot.data!;
                        if (User.accountStatus != Status.ACTIVE) {
                          FirebaseManager.shared.signOut(context);
                        }
                        return StreamBuilder<SettingsModel>(
                            stream: FirebaseManager.shared
                                .getsettingsByuid(uid: User.uid_Team),
                            builder: (BuildContext, AsyncSnapshot) {
                              if (AsyncSnapshot.hasData) {
                                SettingsModel Setting = AsyncSnapshot.data!;
                                return BackdropScaffold(
                                    appBar: BackdropAppBar(
                                      backgroundColor:
                                          OMNIColors.backgroundColor,
                                      centerTitle: true,
                                      title: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: OMNI_Widget == true
                                                    ? "Dashboard".tr
                                                    : "Support".tr,
                                                style: const TextStyle(
                                                    color: Colors.green)),
                                            TextSpan(
                                                text: PROFILE_Widget == true
                                                    ? ""
                                                    : "/Profile".tr,
                                                style: const TextStyle(
                                                    color: Colors.green)),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Stack(
                                            children: [
                                              Visibility(
                                                visible:
                                                    User.uid_Team == User.uid &&
                                                        PROFILE_Widget == false,
                                                child: IconButton(
                                                    icon: const Icon(
                                                      Icons.settings,
                                                      color: Colors.black,
                                                    ),
                                                    tooltip: "Settings".tr,
                                                    onPressed: () {
                                                      Get.dialog(Edit_VAT(
                                                        updateUser: Setting,
                                                        userType: User.userType,
                                                        uidUserActive: User.id,
                                                        uidTeam: User.uid_Team,
                                                        Email: User.email,
                                                        id: User.id,
                                                      ));
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        StreamBuilder<List<NotificationModel>>(
                                            stream: FirebaseManager.shared
                                                .getMyNotifications(
                                                    uid: User.uid),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List<NotificationModel> items =
                                                    [];
                                                for (var item
                                                    in snapshot.data!) {
                                                  if (!item.isRead) {
                                                    items.add(item);
                                                  }
                                                }
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Stack(
                                                    children: [
                                                      IconButton(
                                                          icon: const Icon(
                                                            Icons.notifications,
                                                            color: Colors.black,
                                                          ),
                                                          tooltip:
                                                              "Notifications"
                                                                  .tr,
                                                          onPressed: () {
                                                            setState(() {
                                                              Notifications =
                                                                  false;
                                                            });
                                                          }),
                                                      Visibility(
                                                        visible:
                                                            items.isNotEmpty,
                                                        child: Positioned(
                                                            top: -3,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Text(
                                                                items.length
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox();
                                              }
                                            })
                                      ],
                                    ),
                                    backLayer: PROFILE_Widget
                                        ? ListView(
                                            padding: const EdgeInsets.only(
                                                bottom: 128.0),
                                            children: <Widget>[
                                              ListTile(
                                                  leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      radius: 30,
                                                      child: Image.network(
                                                        scale: 1,
                                                        User.image!,
                                                        fit: BoxFit.cover,
                                                      )),
                                                  title: Text(
                                                    User.name ?? User.email!,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                  trailing: TextButton(
                                                    onPressed: () async {
                                                      FirebaseManager.shared
                                                          .signOut(context);
                                                    },
                                                    child: Text(
                                                      'Log out'.tr,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  )),
                                              ListTile(
                                                title: RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        color: Colors.black54),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              'Account Status :'
                                                                  .tr),
                                                      TextSpan(
                                                          text:
                                                              Setting.review !=
                                                                      false
                                                                  ? " Active".tr
                                                                  : null,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green)),
                                                      TextSpan(
                                                        text: Setting.review ==
                                                                false
                                                            ? " Under review".tr
                                                            : null,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: User.userType ==
                                                                  UserType
                                                                      .MASTAR
                                                              ? " MASTAR".tr
                                                              : null,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green)),
                                                      TextSpan(
                                                        text: User.userType ==
                                                                UserType.ADMIN
                                                            ? " ADMIN".tr
                                                            : null,
                                                        style: const TextStyle(
                                                            color: Colors.blue),
                                                      ),
                                                      TextSpan(
                                                        text: User.userType ==
                                                                UserType.USER
                                                            ? " USER".tr
                                                            : null,
                                                        style: const TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Divider(),
                                              Visibility(
                                                visible: true,
                                                child: ListTile(
                                                  leading:
                                                      const Icon(Icons.code),
                                                  title: Text(
                                                      'Team management'.tr,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54)),
                                                  onTap: () {
                                                    setState(() {
                                                      userOMNI =
                                                          Page_OMNI.TEAM_OMNI;
                                                      TEWAMLISTOMNI = User;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Visibility(
                                                visible: User.userType !=
                                                    UserType.USER,
                                                child: ListTile(
                                                  leading: const Icon(Icons
                                                      .supervised_user_circle_sharp),
                                                  title: Text('Users'.tr,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54)),
                                                  onTap: () {
                                                    setState(() {
                                                      userOMNI =
                                                          Page_OMNI.AllUser;
                                                    });
                                                  },
                                                ),
                                              ), // Done
                                              ListTile(
                                                leading: const Icon(Icons.person),
                                                title: Text('Profile'.tr,
                                                    style: const TextStyle(
                                                        color: Colors.black54)),
                                                onTap: () {
                                                  setState(() {
                                                    PROFILE_Widget = false;
                                                  });
                                                },
                                              ),
                                              Visibility(
                                                visible: User.userType ==
                                                    UserType.MASTAR,
                                                child: ListTile(
                                                    leading: const Icon(
                                                        Icons.settings),
                                                    title: Text(
                                                        'System setting'.tr,
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54)),
                                                    onTap: () async {
                                                      Get.dialog(System_setting(
                                                          update: items));
                                                    }),
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.language),

                                                /// add img lang in wid..
                                                title: Text(
                                                    'Change Language'.tr,
                                                    style: const TextStyle(
                                                        color: Colors.black54)),
                                                onTap: () => FirebaseManager
                                                    .shared
                                                    .changeLanguage(context),
                                              ),
                                              Visibility(
                                                visible: true,
                                                child: ListTile(
                                                  leading:
                                                      const Icon(Icons.delete),
                                                  title: Text(
                                                      'Delete Account'.tr,
                                                      style: const TextStyle(
                                                          color: Colors.red)),
                                                  onTap: () async {
                                                    FirebaseManager.shared
                                                        .changeStatusAccount(
                                                            userId: User.uid!,
                                                            status:
                                                                Status.Deleted);
                                                    FirebaseManager.shared
                                                        .signOut(context);
                                                    await FirebaseManager.shared
                                                        .getAllsystem()
                                                        .first
                                                        .then((omni) {
                                                      for (var system in omni) {
                                                        FirebaseManager.shared
                                                            .addNotifications(
                                                                uidUser:
                                                                    system.uid,
                                                                title: User.id!,
                                                                details:
                                                                    "Delete Account"
                                                                        .tr);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : SingleChildScrollView(
                                            child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      maxRadius: 60,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Image.network(
                                                            scale: 1,
                                                            LOGO ?? User.image!,
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
                                                            BorderRadius
                                                                .circular(40),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            final file =
                                                                await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                            String? task = await FirebaseManager
                                                                .shared
                                                                .uploadImage(
                                                                    folderName: User
                                                                        .email!,
                                                                    imagePath:
                                                                        file);
                                                            setState(() {
                                                              LOGO = task;
                                                            });
                                                          },
                                                          radius: 50,
                                                          child: const SizedBox(
                                                            width: 35,
                                                            height: 35,
                                                            child: Icon(Icons
                                                                .arrow_upward),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                TextFormField(
                                                  initialValue: User.name,
                                                  obscureText: false,
                                                  onChanged: (val) => setState(
                                                      () => name = val),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    hintText:
                                                        'Enter Your Full Name'
                                                            .tr,
                                                    labelText: 'Full Name'.tr,
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                TextFormField(
                                                  initialValue: User.phone,
                                                  obscureText: false,
                                                  onChanged: (val) => setState(
                                                      () => phone = val),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    hintText:
                                                        'Enter Your Phone Number'
                                                            .tr,
                                                    labelText:
                                                        'Phone Number'.tr,
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                TextFormField(
                                                  initialValue: User.email,
                                                  obscureText: false,
                                                  onChanged: (val) => setState(
                                                      () => email = val),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    hintText:
                                                        'Enter Your Email'.tr,
                                                    labelText: 'Email'.tr,
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                TextFormField(
                                                  initialValue: User.city,
                                                  obscureText: false,
                                                  onChanged: (val) => setState(
                                                      () => city = val),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                    hintText:
                                                        'Enter country'.tr,
                                                    labelText: 'country'.tr,
                                                    labelStyle: const TextStyle(
                                                        color: Colors.black),
                                                    border:
                                                        const OutlineInputBorder(),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                    "${'VAT %'.tr}${Setting.vat}"),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  width: double.infinity,
                                                  height: 50,
                                                  child: OutlinedButton(
                                                    onPressed: () async {
                                                      if (name == "" ||
                                                          city == "" ||
                                                          email == "" ||
                                                          phone == "") {
                                                        Get.customSnackbar(
                                                          title: "Error".tr,
                                                          message:
                                                              "Please enter all fields"
                                                                  .tr,
                                                          isError: true,
                                                        );
                                                        return;
                                                      }
                                                      FirebaseManager.shared
                                                          .updateAccount(
                                                        name:
                                                            name ?? User.name!,
                                                        city:
                                                            city ?? User.city!,
                                                        email: email ??
                                                            User.email!,
                                                        phoneNumber: phone ??
                                                            User.phone!,
                                                        uid: User.uid!,
                                                        url:
                                                            LOGO ?? User.image!,
                                                      );

                                                      await FirebaseManager
                                                          .shared
                                                          .getAllsystem()
                                                          .first
                                                          .then((omni) {
                                                        for (var system
                                                            in omni) {
                                                          FirebaseManager.shared
                                                              .addNotifications(
                                                            uidUser: system.uid,
                                                            title: User.id!,
                                                            details:
                                                                "change profile Account",
                                                          );
                                                        }
                                                      });

                                                      setState(() {
                                                        PROFILE_Widget = true;
                                                        OMNI_Widget = true;
                                                      });
                                                    },
                                                    child: Text(
                                                      'Save'.tr,
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    backLayerBackgroundColor:
                                        Colors.transparent,
                                    subHeader: OMNI_Widget
                                        ? BackTeam(
                                            trailing: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  OMNI_Widget = false;
                                                });
                                              },
                                              child: Text(
                                                "Support".tr,
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            title: Text(User.name!,
                                                style: const TextStyle(
                                                    color: Colors.black54)))
                                        : Visibility(
                                            visible: items.systemads,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                FirebaseManager.shared
                                                    .renderSlider(context,
                                                        images: items.Ads),
                                              ],
                                            )),
                                    frontLayer: OMNI_Widget
                                        ? historyWidget(User)
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              BackTeam(
                                                title: Text(User.name!,
                                                    style: const TextStyle(
                                                        color: Colors.black54)),
                                                trailing: InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      OMNI_Widget = true;
                                                    });
                                                  },
                                                  child: Text(
                                                    "Dashboard".tr,
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Flutter_Online_Support(
                                                      User.uid!))
                                            ],
                                          ),
                                    //  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                                    floatingActionButton: FloatingActionButton(
                                      backgroundColor: Colors.black,
                                      mini: true,
                                      onPressed: () {
                                        Get.dialog(Q_invoice(
                                            OMNI: Setting, USER: User));
                                      },
                                      child: const Icon(Icons.add,
                                          color: Colors.white),
                                    ));
                              } else {
                                return const Center();
                              }
                            });
                      } else {
                        return const Center();
                      }
                    });
              } else {
                return const Center();
              }
            })
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(
                    Icons.dashboard,
                    color: Colors.black,
                  ),
                  tooltip: "Dashboard".tr,
                  onPressed: () {
                    setState(() {
                      Notifications = true;
                    });
                  }),
              backgroundColor: Theme.of(context).canvasColor,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Notifications".tr,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: StreamBuilder<List<NotificationModel>>(
                stream: FirebaseManager.shared.getMyNotifications(
                    uid: FirebaseManager.shared.auth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    setPageTitle('Dashboard/Notifications'.tr, context);
                    List<NotificationModel>? items = snapshot.data;
                    FirebaseManager.shared.setNotificationRead(
                        uid: FirebaseManager.shared.auth.currentUser!.uid);
                    items!.sort((a, b) {
                      return DateTime.parse(b.createdDate)
                          .compareTo(DateTime.parse(a.createdDate));
                    });
                    return items.isEmpty
                        ? Center(
                            child: Text(
                            "You have no notifications".tr,
                            style: const TextStyle(color: Colors.black, fontSize: 18),
                          ))
                        : ListView.builder(
                            padding: const EdgeInsets.all(20),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return _item(item: items[index]);
                            },
                          );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.black54,
                      backgroundColor: OMNIColors.backgroundColor,
                    ));
                  }
                }),
          );
  }

  Widget historyWidget(MYUSER) {
    if (MYUSER.userType == UserType.MASTAR) {
      return MASTAR();
    } else {
      if (MYUSER!.uid == MYUSER.uid_Team) {
        return _adminuid(MYUSER.uid_Team);
      }
      return _useruid(MYUSER.uid);
    }
  }

  Widget MASTAR() {
    return StreamBuilder<List<InvoiceModel>>(
        stream:
            FirebaseManager.shared.getinvoicedone(status: Payment.Payment_Done),
        builder: (BuildContext, AsyncSnapshot) {
          if (AsyncSnapshot.hasData) {
            List<InvoiceModel>? inv = AsyncSnapshot.data;
            List<InvoiceModel> rp = [];
            for (var pay in AsyncSnapshot.data!) {
              DateTime dateToday = DateTime.now();
              String date = dateToday.convertToDateStringOnly();
              if (pay.createdDate.convertToDateStringOnly() == date) {
                if (pay.invoice == Payment.Payment_Done) {
                  rp.add(pay);
                }
              }
            }
            _buildTotalMoney(rp, inv!);
            inv.sort((a, b) {
              return DateTime.parse(b.createdDate.toString())
                  .compareTo(DateTime.parse(a.createdDate.toString()));
            });
            if (inv.isEmpty) {
              return Center(
                  child: Text(
                'You have no invoices'.tr,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ));
            }
            return Scaffold(
                appBar: AppBar(
                  flexibleSpace: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${'Total Invoice : '.tr}${totalMoney}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: OMNIColors.backgroundColor,
                  title: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '${'Total Today:'.tr}$totalMoneyToday  ',
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.add_chart_outlined,
                                  color: Colors.green),
                              tooltip: "chart".tr,
                              onPressed: () {
                                Get.dialog(Chart(inv: inv));
                              }),
                        ],
                      ),
                    )
                  ],
                  centerTitle: true,
                ),
                body: ListView.builder(
                    controller: _contoller,
                    itemCount: inv.length,
                    itemBuilder: (item, index) {
                      String statusTitle = "";
                      Widget statusIcon = const Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.green,
                      );
                      switch (inv[index].invoice) {
                        case Payment.Payment_Done:
                          statusTitle = "Pay Done".tr;
                          statusIcon = const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.green,
                          );
                          break;
                        case Payment.PENDING:
                          statusTitle = "In Review".tr;
                          statusIcon = const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.black54,
                          );
                          break;
                        case Payment.payment_processed:
                          statusTitle = "Unpaid".tr;
                          statusIcon = const Icon(
                            Icons.report,
                            size: 15,
                            color: Colors.blue,
                          );
                          break;
                        case Payment.Ruten:
                          statusTitle = "Return".tr;
                          statusIcon = const Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.red,
                          );
                          break;
                      }
                      return InkWell(
                        onTap: () {
                          Get.toNamed('/Invoice/${inv[index].uid}');
                        },
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  color: Colors.black,
                                  iconSize: 26,
                                  icon: const Icon(Icons.picture_as_pdf_sharp),
                                  onPressed: () async {
                                    if (inv[index].VAT == 999) {
                                      await Printing.sharePdf(
                                          bytes: await generateDocument(
                                              context, inv[index]),
                                          filename: '#${inv[index].id}');
                                    } else {
                                      await Printing.sharePdf(
                                          bytes: await generate(inv[index]),
                                          filename: '#${inv[index].id}');
                                    }
                                  }),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${'#Reference Number: '.tr}${inv[index].id}",
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(inv[index].name)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        statusIcon,
                                        const SizedBox(width: 5),
                                        Text(
                                          statusTitle,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${Utils.formatPrice(inv[index].Total)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              inv[index]
                                                  .createdDate
                                                  .convertToDateStringOnly(),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black54,
              backgroundColor: OMNIColors.backgroundColor,
            ));
          }
        });
  }

  Widget _adminuid(String uidTeam) {
    return StreamBuilder<List<InvoiceModel>>(
        stream: FirebaseManager.shared.invoicebyuid(uid: uidTeam),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<InvoiceModel>? inv = snapshot.data;
            List<InvoiceModel> rp = [];
            List<InvoiceModel> test = [];
            for (var pay in snapshot.data!) {
              if (pay.invoice == Payment.Payment_Done) {
                test.add(pay);
              }
              DateTime dateToday = DateTime.now();
              String date = dateToday.convertToDateStringOnly();
              if (pay.createdDate.convertToDateStringOnly() == date) {
                if (pay.invoice == Payment.Payment_Done) {
                  rp.add(pay);
                }
              }
            }
            _buildTotalMoney(rp, test);
            inv!.sort((a, b) {
              return DateTime.parse(b.createdDate.toString())
                  .compareTo(DateTime.parse(a.createdDate.toString()));
            });

            if (inv.isEmpty) {
              return Center(
                  child: Text(
                'You have no invoices'.tr,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ));
            }
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '${'Total Invoice : '.tr}${totalMoney}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                elevation: 0,
                backgroundColor: OMNIColors.backgroundColor,
                title: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: '${'Total Today:'.tr}$totalMoneyToday  ',
                          style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Stack(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.add_chart_outlined,
                                color: Colors.green),
                            tooltip: "chart".tr,
                            onPressed: () {
                              Get.dialog(Chart(inv: test));
                            }),
                      ],
                    ),
                  )
                ],
                centerTitle: true,
              ),
              body: ListView.builder(
                  controller: _contoller,
                  itemCount: inv.length,
                  itemBuilder: (item, index) {
                    String statusTitle = "";
                    Widget statusIcon = const Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.green,
                    );
                    switch (inv[index].invoice) {
                      case Payment.Payment_Done:
                        statusTitle = "Pay Done".tr;
                        statusIcon = const Icon(
                          Icons.check,
                          size: 15,
                          color: Colors.green,
                        );
                        break;
                      case Payment.PENDING:
                        statusTitle = "In Review".tr;
                        statusIcon = const Icon(
                          Icons.access_time,
                          size: 15,
                          color: Colors.black54,
                        );
                        break;
                      case Payment.payment_processed:
                        statusTitle = "Unpaid".tr;
                        statusIcon = const Icon(
                          Icons.report,
                          size: 15,
                          color: Colors.blue,
                        );
                        break;
                      case Payment.Ruten:
                        statusTitle = "Return".tr;
                        statusIcon = const Icon(
                          Icons.remove,
                          size: 15,
                          color: Colors.red,
                        );
                        break;
                    }
                    return InkWell(
                      onTap: () {
                        Get.toNamed('/Invoice/${inv[index].uid}');
                      },
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                                color: Colors.black,
                                iconSize: 26,
                                icon: const Icon(Icons.picture_as_pdf_sharp),
                                onPressed: () async {
                                  if (inv[index].VAT == 999) {
                                    await Printing.sharePdf(
                                        bytes: await generateDocument(
                                            context, inv[index]),
                                        filename: '#${inv[index].id}');
                                  } else {
                                    await Printing.sharePdf(
                                        bytes: await generate(inv[index]),
                                        filename: '#${inv[index].id}');
                                  }
                                }),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${'#Reference Number: '.tr}${inv[index].id}",
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(inv[index].name)
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  border: Border.all(color: Colors.white),
                                ),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      statusIcon,
                                      const SizedBox(width: 5),
                                      Text(
                                        statusTitle,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${Utils.formatPrice(inv[index].Total)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            inv[index]
                                                .createdDate
                                                .convertToDateStringOnly(),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black54,
              backgroundColor: OMNIColors.backgroundColor,
            ));
          }
        });
  }

  Widget _useruid(String? uid) {
    return StreamBuilder<List<InvoiceModel>>(
        stream: FirebaseManager.shared.invoice(uid: uid!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<InvoiceModel>? inv = snapshot.data;
            List<InvoiceModel> rp = [];
            List<InvoiceModel> test = [];
            for (var pay in snapshot.data!) {
              if (pay.invoice == Payment.Payment_Done) {
                test.add(pay);
              }
              DateTime dateToday = DateTime.now();
              String date = dateToday.convertToDateStringOnly();
              if (pay.createdDate.convertToDateStringOnly() == date) {
                if (pay.invoice == Payment.Payment_Done) {
                  rp.add(pay);
                }
              }
            }
            _buildTotalMoney(rp, test);
            inv!.sort((a, b) {
              return DateTime.parse(b.createdDate.toString())
                  .compareTo(DateTime.parse(a.createdDate.toString()));
            });
            if (inv.isEmpty) {
              return Center(
                  child: Text(
                'You have no invoices'.tr,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ));
            }
            return Scaffold(
                appBar: AppBar(
                  flexibleSpace: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '${'Total Invoice : '.tr}${totalMoney}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: OMNIColors.backgroundColor,
                  title: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: '${'Total Today:'.tr}$totalMoneyToday  ',
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.add_chart_outlined,
                                  color: Colors.green),
                              tooltip: "chart".tr,
                              onPressed: () {
                                Get.dialog(Chart(inv: inv));
                              }),
                        ],
                      ),
                    )
                  ],
                  centerTitle: true,
                ),
                body: ListView.builder(
                    controller: _contoller,
                    itemCount: inv.length,
                    itemBuilder: (item, index) {
                      String statusTitle = "";
                      Widget statusIcon = const Icon(
                        Icons.check,
                        size: 15,
                        color: Colors.green,
                      );
                      switch (inv[index].invoice) {
                        case Payment.Payment_Done:
                          statusTitle = "Pay Done".tr;
                          statusIcon = const Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.green,
                          );
                          break;
                        case Payment.PENDING:
                          statusTitle = "In Review".tr;
                          statusIcon = const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.black54,
                          );
                          break;
                        case Payment.payment_processed:
                          statusTitle = "Unpaid".tr;
                          statusIcon = const Icon(
                            Icons.report,
                            size: 15,
                            color: Colors.blue,
                          );
                          break;
                        case Payment.Ruten:
                          statusTitle = "Return".tr;
                          statusIcon = const Icon(
                            Icons.remove,
                            size: 15,
                            color: Colors.red,
                          );
                          break;
                      }
                      return InkWell(
                        onTap: () {
                          Get.toNamed('/Invoice/${inv[index].uid}');
                        },
                        child: Card(
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  color: Colors.black,
                                  iconSize: 26,
                                  icon: const Icon(Icons.picture_as_pdf_sharp),
                                  onPressed: () async {
                                    if (inv[index].VAT == 999) {
                                      await Printing.sharePdf(
                                          bytes: await generateDocument(
                                              context, inv[index]),
                                          filename: '#${inv[index].id}');
                                    } else {
                                      await Printing.sharePdf(
                                          bytes: await generate(inv[index]),
                                          filename: '#${inv[index].id}');
                                    }
                                  }),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${'#Reference Number: '.tr}${inv[index].id}",
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(inv[index].name)
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        statusIcon,
                                        const SizedBox(width: 5),
                                        Text(
                                          statusTitle,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${Utils.formatPrice(inv[index].Total)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              inv[index]
                                                  .createdDate
                                                  .convertToDateStringOnly(),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }));
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black54,
              backgroundColor: OMNIColors.backgroundColor,
            ));
          }
        });
  }

  Widget Flutter_Online_Support(String uid) {
    return StreamBuilder<List<UserModel>>(
        stream: FirebaseManager.shared.Online(status: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel>? Online = snapshot.data;
            if (Online!.isEmpty) {
              return Center(
                  child: Text(
                "No Online Support".tr,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
              ));
            }
            return ListView.builder(
                controller: _contoller,
                itemCount: Online.length,
                itemBuilder: (item, index) {
                  return Card(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: Image.network(
                            scale: 1,
                            Online[index].image!,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  Online[index].id!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.left,
                                ),
                                Text(Online[index].name!)
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(right: 25.0),
                                        child: Icon(
                                          Icons.online_prediction,
                                          size: 20,
                                          color: Colors.green,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.black54,
              backgroundColor: OMNIColors.backgroundColor,
            ));
          }
        });
  }

  Widget _item({required NotificationModel item}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          item.title,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Text(
          item.details,
          style: const TextStyle(color: Colors.black54, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          height: 1,
          color: Colors.black,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget AllUSERS_OMNI() {
    return StreamBuilder<UserModel>(
        stream: FirebaseManager.shared
            .getByuid(uid: FirebaseManager.shared.auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? OMNIID = snapshot.data;
            if (OMNIID!.userType == UserType.MASTAR) {
              return _widgetMASTER(OMNIID);
            } else if (OMNIID.userType == UserType.ADMIN) {
              return _widgetADMIN(OMNIID);
            } else if (OMNIID.userType == UserType.USER) {
              return const UnknownRoute();
            }
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black54,
            backgroundColor: OMNIColors.backgroundColor,
          ));
        });
  }

  Widget _widgetMASTER(OMNIID) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              tooltip: "Dashboard".tr,
              onPressed: () {
                setState(() {
                  userOMNI = Page_OMNI.AllHome;
                });
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: appBarTitle,
          centerTitle: false,
          actions: [
            IconButton(
              icon: actionIcon,
              tooltip: "Search".tr,
              onPressed: () {
                //          searchTextField!.clear();
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.close, color: Colors.black);
                    appBarTitle = TextField(
                      controller: searchTextField,
                      onChanged: (value) {
                        searchTextField!.text = value;
                        searchTextField!.text.isEmpty
                            ? widget.searchMode = false
                            : widget.searchMode = true;
                        searchTextField!.selection = TextSelection.fromPosition(
                            TextPosition(offset: searchTextField!.text.length));
                        setState(() {});
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black54),
                          hintText: "Search".tr),
                    );
                  } else {
                    actionIcon = const Icon(Icons.search);
                    appBarTitle = Text(
                      "Users".tr,
                      style: const TextStyle(color: Colors.black54),
                    );
                  }
                });
              },
            ),
          ],
        ),
        body: StreamBuilder<List<UserModel>>(
            stream: widget.searchMode
                ? FirebaseManager.shared.getUsersBYsearch(
                    Name: searchTextField!.text, fieldType: "id")
                : FirebaseManager.shared.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<UserModel> items = [];
                for (var user in snapshot.data!) {
                  if (user.uid !=
                          FirebaseManager.shared.auth.currentUser!.uid &&
                      user.accountStatus == status &&
                      user.userType == userType) {
                    items.add(user);
                  }
                }
                items.sort((a, b) {
                  return DateTime.parse(b.dateCreated!)
                      .compareTo(DateTime.parse(a.dateCreated!));
                });
                List<UserModel>? searchMode = snapshot.data;
                if (widget.searchMode) {
                  for (int i = 0; i < searchMode!.length; i++) {
                    if (searchMode[i].accountStatus.index !=
                        widget.searchMode) {
                      searchMode.removeAt(i);
                    }
                  }
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount:
                      items.isEmpty ? items.length + 2 : items.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? _header()
                        : (items.isEmpty
                            ? Center(
                                child: Text(
                                  "There are no Users".tr,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              )
                            : item(user: items[index - 1], OMNIID));
                  },
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account Status :-".tr,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Colors.black54,
                  value: Status.ACTIVE,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text("Active".tr),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.black54,
                  value: Status.Disable,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text("Disabled".tr),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.black54,
                  value: Status.Deleted,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text("Deleted".tr),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "User Type:-".tr,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Colors.black54,
                  value: UserType.MASTAR,
                  groupValue: userType,
                  onChanged: (UserType? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                Text(" MASTAR".tr),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.black54,
                  value: UserType.ADMIN,
                  groupValue: userType,
                  onChanged: (UserType? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                Text(" ADMIN".tr),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Colors.black54,
                  value: UserType.USER,
                  groupValue: userType,
                  onChanged: (UserType? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                Text(" USER".tr),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: Colors.black54,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget item(currentUser, {required UserModel user}) {
    return Column(
      children: [
        InkWell(
          onLongPress: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                          'details'.tr,
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
                                      Row(
                                        children: [
                                          Text(
                                            "User ID: ".tr,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: OMNIColors.BlackBolor),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text(user.id!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: OMNIColors
                                                          .BlackBolor))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "User name: ".tr,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: OMNIColors.BlackBolor),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text(user.name!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: OMNIColors
                                                          .BlackBolor))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "Email: ".tr,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: OMNIColors.BlackBolor),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text(user.email!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: OMNIColors
                                                          .BlackBolor))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "Phone: ".tr,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: OMNIColors.BlackBolor),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text(user.phone!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: OMNIColors
                                                          .BlackBolor))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "country: ".tr,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: OMNIColors.BlackBolor),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text(user.city!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: OMNIColors
                                                          .BlackBolor))),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "Date created: ".tr,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: OMNIColors.BlackBolor),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              child: Text(
                                                  user.dateCreated!
                                                      .changeDateFormat(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: OMNIColors
                                                          .BlackBolor))),
                                        ],
                                      ),
                                    ]))))));
          },
          onTap: () {
            setState(() {
              UID_TEAM = user.uid_Team;
              userOMNI = Page_OMNI.Invoice_Mastar;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: "User ID: ".tr,
                        ),
                        TextSpan(
                            text: user.id!,
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    )),
                    InkWell(
                      onTap: () async {
                        SettingsModel test = await FirebaseManager.shared
                            .getsettingsByUid(uid: user.uid_Team);
                        showDialog(
                            context: context,
                            builder: (context) => Edit_VAT(
                                uidTeam: user.uid_Team,
                                updateUser: test,
                                uidUserActive: currentUser.id,
                                id: user.id,
                                Email: user.email));
                      },
                      child: Center(
                          child: Text(
                        "Settings".tr,
                        style: const TextStyle(color: Colors.black, fontSize: 15),
                      )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Image.network(
                        scale: 1,
                        user.image!,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Send notifications'.tr,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline1!
                                                            .color,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30),
                                                  TextFormField(
                                                    onChanged: (val) =>
                                                        setState(
                                                            () => title = val),
                                                    onSaved: (value) =>
                                                        title = value!.trim(),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter title'.tr,
                                                      labelText: 'title'.tr,
                                                      border:
                                                          const OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  TextFormField(
                                                    onChanged: (val) =>
                                                        setState(() =>
                                                            details = val),
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter details'.tr,
                                                      labelText: 'details'.tr,
                                                      border:
                                                          const OutlineInputBorder(),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 50,
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        FirebaseManager.shared
                                                            .addNotifications(
                                                                uidUser:
                                                                    user.uid!,
                                                                title:
                                                                    "From ADMIN : ${currentUser.id}",
                                                                details:
                                                                    "$title\n$details");
                                                        await FirebaseManager
                                                            .shared
                                                            .getAllsystem()
                                                            .first
                                                            .then((omni) {
                                                          for (var system
                                                              in omni) {
                                                            FirebaseManager
                                                                .shared
                                                                .addNotifications(
                                                              uidUser:
                                                                  system.uid,
                                                              title:
                                                                  "${currentUser.id} To ${user.id!}",
                                                              details:
                                                                  "$title\n$details",
                                                            );
                                                          }
                                                        });
                                                        Get.back();
                                                      },
                                                      child: Text("Send".tr),
                                                    ),
                                                  ),
                                                ]))))));
                      },
                      child: Center(
                          child: Text(
                        'Send notifications'.tr,
                        style: const TextStyle(color: Colors.red, fontSize: 15),
                      )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: user.accountStatus == Status.ACTIVE,
                      child: InkWell(
                        onTap: () async {
                          FirebaseManager.shared.changeStatusAccount(
                              userId: user.uid!, status: Status.Disable);
                          await FirebaseManager.shared
                              .getAllsystem()
                              .first
                              .then((omni) {
                            for (var system in omni) {
                              FirebaseManager.shared.addNotifications(
                                  uidUser: system.uid,
                                  title: "${currentUser.id} change ${user.id!}",
                                  details: "To Disable");
                            }
                          });
                        },
                        child: Center(
                            child: Text(
                          "disable".tr,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 15),
                        )),
                      ),
                    ),
                    Visibility(
                      visible: user.userType == UserType.MASTAR,
                      child: InkWell(
                        onTap: () async {
                          FirebaseManager.shared.changeTypeAccount(
                              userId: user.uid!, userType: UserType.USER);
                          await FirebaseManager.shared
                              .getAllsystem()
                              .first
                              .then((omni) {
                            for (var system in omni) {
                              FirebaseManager.shared.addNotifications(
                                  uidUser: system.uid,
                                  title: "${currentUser.id} change ${user.id!}",
                                  details: "To USER");
                            }
                          });
                        },
                        child: Center(
                            child: Text(
                          " USER".tr,
                          style: const TextStyle(color: Colors.red, fontSize: 15),
                        )),
                      ),
                    ),
                    Visibility(
                      visible: user.userType == UserType.ADMIN,
                      child: InkWell(
                        onTap: () async {
                          FirebaseManager.shared.changeTypeAccount(
                              userId: user.uid!, userType: UserType.MASTAR);
                          await FirebaseManager.shared
                              .getAllsystem()
                              .first
                              .then((omni) {
                            for (var system in omni) {
                              FirebaseManager.shared.addNotifications(
                                  uidUser: system.uid,
                                  title: "${currentUser.id} change ${user.id!}",
                                  details: "To MASTAR");
                            }
                          });
                        },
                        child: Center(
                            child: Text(
                          " MASTAR".tr,
                          style: const TextStyle(color: Colors.red, fontSize: 15),
                        )),
                      ),
                    ),
                    Visibility(
                      visible: user.userType == UserType.USER,
                      child: InkWell(
                        onTap: () async {
                          FirebaseManager.shared.changeTypeAccount(
                              userId: user.uid!, userType: UserType.ADMIN);
                          await FirebaseManager.shared
                              .getAllsystem()
                              .first
                              .then((omni) {
                            for (var system in omni) {
                              FirebaseManager.shared.addNotifications(
                                  uidUser: system.uid,
                                  title: "${currentUser.id} change ${user.id!}",
                                  details: "To ADMIN");
                            }
                          });
                        },
                        child: Center(
                            child: Text(
                          " ADMIN".tr,
                          style: const TextStyle(color: Colors.red, fontSize: 15),
                        )),
                      ),
                    ),
                    Visibility(
                      visible: user.accountStatus == Status.Disable,
                      child: InkWell(
                        onTap: () async {
                          FirebaseManager.shared.changeStatusAccount(
                              userId: user.uid!, status: Status.Deleted);
                          await FirebaseManager.shared
                              .getAllsystem()
                              .first
                              .then((omni) {
                            for (var system in omni) {
                              FirebaseManager.shared.addNotifications(
                                uidUser: system.uid,
                                title: "${currentUser.id} change ${user.id!}",
                                details: "To Delete",
                              );
                            }
                          });
                        },
                        child: Center(
                            child: Text(
                          "delete".tr,
                          style: const TextStyle(color: Colors.red, fontSize: 15),
                        )),
                      ),
                    ),
                    Visibility(
                      visible: user.accountStatus == Status.Disable,
                      child: InkWell(
                        onTap: () async {
                          FirebaseManager.shared.changeStatusAccount(
                              userId: user.uid!, status: Status.ACTIVE);
                          await FirebaseManager.shared
                              .getAllsystem()
                              .first
                              .then((omni) {
                            for (var system in omni) {
                              FirebaseManager.shared.addNotifications(
                                  uidUser: system.uid,
                                  title: "${currentUser.id} change ${user.id!}",
                                  details: "To ACTIVE");
                            }
                          });
                        },
                        child: Center(
                            child: Text(
                          "ACTIVE".tr,
                          style: const TextStyle(color: Colors.green, fontSize: 15),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        user.support == true
                            ? FirebaseManager.shared.changeStatusOnline(
                                userId: user.uid!,
                                support: false,
                              )
                            : FirebaseManager.shared.changeStatusOnline(
                                userId: user.uid!,
                                support: true,
                              );
                        await FirebaseManager.shared
                            .getAllsystem()
                            .first
                            .then((omni) {
                          for (var system in omni) {
                            FirebaseManager.shared.addNotifications(
                                uidUser: system.uid,
                                title: "${currentUser.id} change ${user.id!}",
                                details: user.support == true
                                    ? "To OFLINE"
                                    : "To ONLINE");
                          }
                        });
                      },
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black54),
                          children: <TextSpan>[
                            TextSpan(
                                text: user.support == true ? " ONLINE" : null,
                                style: const TextStyle(color: Colors.green)),
                            TextSpan(
                              text: user.support == false ? "OFLINE" : null,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _widgetADMIN(OMNIID) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              tooltip: "Dashboard".tr,
              onPressed: () {
                setState(() {
                  userOMNI = Page_OMNI.AllHome;
                });
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: appBarTitle,
          centerTitle: false,
          actions: [
            IconButton(
              icon: actionIcon,
              tooltip: "Search".tr,
              onPressed: () {
                //          searchTextField!.clear();
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.close, color: Colors.black);
                    appBarTitle = TextField(
                      controller: searchTextField,
                      onChanged: (value) {
                        searchTextField!.text = value;
                        searchTextField!.text.isEmpty
                            ? widget.searchMode = false
                            : widget.searchMode = true;
                        searchTextField!.selection = TextSelection.fromPosition(
                            TextPosition(offset: searchTextField!.text.length));
                        setState(() {});
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black54),
                          hintText: "Search".tr),
                    );
                  } else {
                    actionIcon = const Icon(Icons.search);
                    appBarTitle = Text(
                      "Users".tr,
                      style: const TextStyle(color: Colors.black54),
                    );
                  }
                });
              },
            ),
          ],
        ),
        body: StreamBuilder<List<UserModel>>(
            stream: widget.searchMode
                ? FirebaseManager.shared.getUsersBYsearch(
                    Name: searchTextField!.text, fieldType: "id")
                : FirebaseManager.shared.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<UserModel> items = [];
                for (var user in snapshot.data!) {
                  if (user.uid != OMNIID.uid &&
                      user.accountStatus != Status.Deleted &&
                      user.userType != UserType.MASTAR) {
                    items.add(user);
                  }
                }
                items.sort((a, b) {
                  return DateTime.parse(b.dateCreated!)
                      .compareTo(DateTime.parse(a.dateCreated!));
                });
                List<UserModel>? searchMode = snapshot.data;
                if (widget.searchMode) {
                  for (int i = 0; i < searchMode!.length; i++) {
                    if (searchMode[i].accountStatus.index !=
                        widget.searchMode) {
                      searchMode.removeAt(i);
                    }
                  }
                }
                return ListView.builder(
                  itemCount:
                      items.isEmpty ? items.length + 2 : items.length + 1,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? _headerADMIN()
                        : (items.isEmpty
                            ? Center(
                                child: Text(
                                  "There are no Users".tr,
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                              )
                            : _itemADMIN(user: items[index - 1], OMNIID));
                  },
                );
              } else {
                return Container();
              }
            }));
  }

  Widget _headerADMIN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          height: 1,
          color: Colors.black54,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _itemADMIN(currentUser, {required UserModel user}) {
    return Card(
      child: Row(
        children: <Widget>[
          Row(
            children: [
              InkWell(
                onTap: () async {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Center(
                                              child: Text(
                                                'details'.tr,
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
                                            Row(
                                              children: [
                                                Text(
                                                  "User ID: ".tr,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: OMNIColors
                                                          .BlackBolor),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                    child: Text(user.id!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: OMNIColors
                                                                .BlackBolor))),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "User name: ".tr,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: OMNIColors
                                                          .BlackBolor),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                    child: Text(user.name!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: OMNIColors
                                                                .BlackBolor))),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Email: ".tr,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: OMNIColors
                                                          .BlackBolor),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                    child: Text(user.email!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: OMNIColors
                                                                .BlackBolor))),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Phone: ".tr,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: OMNIColors
                                                          .BlackBolor),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                    child: Text(user.phone!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: OMNIColors
                                                                .BlackBolor))),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "country: ".tr,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: OMNIColors
                                                          .BlackBolor),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                    child: Text(user.city!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: OMNIColors
                                                                .BlackBolor))),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Date created: ".tr,
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: OMNIColors
                                                          .BlackBolor),
                                                ),
                                                const SizedBox(width: 10),
                                                Flexible(
                                                    child: Text(
                                                        user.dateCreated!
                                                            .changeDateFormat(),
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            color: OMNIColors
                                                                .BlackBolor))),
                                              ],
                                            ),
                                          ]))))));
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Image.network(
                    scale: 1,
                    user.image!,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${'User ID: '.tr}${user.id}",
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.left,
                  ),
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      text: "Status:".tr,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 10),
                      children: <TextSpan>[
                        TextSpan(
                            text: user.accountStatus == Status.ACTIVE
                                ? "Active".tr
                                : null,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 10)),
                        TextSpan(
                          text: user.accountStatus == Status.Disable
                              ? "Disabled".tr
                              : null,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.white),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: user.accountStatus == Status.Disable,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              FirebaseManager.shared.changeStatusAccount(
                                  userId: user.uid!, status: Status.ACTIVE);
                              await FirebaseManager.shared
                                  .getAllsystem()
                                  .first
                                  .then((omni) {
                                for (var system in omni) {
                                  FirebaseManager.shared.addNotifications(
                                    uidUser: system.uid,
                                    title:
                                        "${currentUser.id} change ${user.id!}",
                                    details: "To ACTIVE",
                                  );
                                }
                              });
                            },
                            child: const Center(
                                child: Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.green,
                            )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: user.accountStatus == Status.ACTIVE,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              FirebaseManager.shared.changeStatusAccount(
                                  userId: user.uid!, status: Status.Disable);
                              await FirebaseManager.shared
                                  .getAllsystem()
                                  .first
                                  .then((omni) {
                                for (var system in omni) {
                                  FirebaseManager.shared.addNotifications(
                                    uidUser: system.uid,
                                    title:
                                        "${currentUser.id} change ${user.id!}",
                                    details: "To Disable",
                                  );
                                }
                              });
                            },
                            child: Center(
                                child: Text(
                              "disable".tr,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            )),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: user.accountStatus == Status.Disable,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              FirebaseManager.shared.changeStatusAccount(
                                  userId: user.uid!, status: Status.Deleted);
                              await FirebaseManager.shared
                                  .getAllsystem()
                                  .first
                                  .then((omni) {
                                for (var system in omni) {
                                  FirebaseManager.shared.addNotifications(
                                    uidUser: system.uid,
                                    title:
                                        "${currentUser.id} change ${user.id!}",
                                    details: "To Delete",
                                  );
                                }
                              });
                            },
                            child: const Center(
                                child: Icon(
                              Icons.delete,
                              size: 15,
                              color: Colors.red,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Dialog(
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
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          'Send notifications'
                                                              .tr,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline1!
                                                                .color,
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 3,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 30),
                                                      TextFormField(
                                                        onChanged: (val) =>
                                                            setState(() =>
                                                                title = val),
                                                        onSaved: (value) =>
                                                            title =
                                                                value!.trim(),
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Enter title'.tr,
                                                          labelText: 'title'.tr,
                                                          border:
                                                              const OutlineInputBorder(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      TextFormField(
                                                        onChanged: (val) =>
                                                            setState(() =>
                                                                details = val),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Enter details'
                                                                  .tr,
                                                          labelText:
                                                              'details'.tr,
                                                          border:
                                                              const OutlineInputBorder(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 20),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        height: 50,
                                                        child: OutlinedButton(
                                                          onPressed: () async {
                                                            FirebaseManager
                                                                .shared
                                                                .addNotifications(
                                                              uidUser:
                                                                  user.uid!,
                                                              title:
                                                                  "From ADMIN : ${currentUser.id}",
                                                              details:
                                                                  "$title\n$details",
                                                            );
                                                            await FirebaseManager
                                                                .shared
                                                                .getAllsystem()
                                                                .first
                                                                .then((omni) {
                                                              for (var system
                                                                  in omni) {
                                                                FirebaseManager
                                                                    .shared
                                                                    .addNotifications(
                                                                  uidUser:
                                                                      system
                                                                          .uid,
                                                                  title:
                                                                      "${currentUser.id} To ${user.id!}",
                                                                  details:
                                                                      "$title\n$details",
                                                                );
                                                              }
                                                            });
                                                            Get.back();
                                                          },
                                                          child: Text(
                                                            "Send".tr,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ]))))));
                          },
                          child: const Icon(
                            Icons.notifications,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            SettingsModel test =
                                await FirebaseManager.shared.getsettingsByUid(
                              uid: user.uid_Team,
                            );
                            showDialog(
                                context: context,
                                builder: (context) => Edit_VAT(
                                    uidTeam: user.uid_Team,
                                    updateUser: test,
                                    uidUserActive: currentUser.id,
                                    Email: user.email));
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ]),
                  InkWell(
                    onTap: () async {
                      user.support == true
                          ? FirebaseManager.shared.changeStatusOnline(
                              userId: user.uid!,
                              support: false,
                            )
                          : FirebaseManager.shared.changeStatusOnline(
                              userId: user.uid!,
                              support: true,
                            );
                      await FirebaseManager.shared
                          .getAllsystem()
                          .first
                          .then((omni) {
                        for (var system in omni) {
                          FirebaseManager.shared.addNotifications(
                              uidUser: system.uid,
                              title: "${currentUser.id} change ${user.id!}",
                              details: user.support == true
                                  ? "To OFLINE"
                                  : "To ONLINE");
                        }
                      });
                    },
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black54),
                        children: <TextSpan>[
                          TextSpan(
                              text: user.support == true ? " ONLINE" : null,
                              style: const TextStyle(color: Colors.green)),
                          TextSpan(
                            text: user.support == false ? "OFLINE" : null,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget TEAM_LIST_OMNI(UserModel TEWAMLISTOMNI) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              tooltip: "Dashboard".tr,
              onPressed: () {
                setState(() {
                  userOMNI = Page_OMNI.AllHome;
                });
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: Text(
            'Users'.tr,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          centerTitle: true,
          actions: [
            Visibility(
              visible: TEWAMLISTOMNI.uid == TEWAMLISTOMNI.uid_Team,
              child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  tooltip: "ADD Users".tr,
                  onPressed: () {
                    Get.dialog(ADD_TEAM(TEWAMLISTOMNI.uid!));
                  }),
            ),
          ],
        ),
        body: StreamBuilder<List<UserModel>>(
            stream:
                FirebaseManager.shared.getuid_Team(uid: TEWAMLISTOMNI.uid_Team),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<UserModel> items = [];
                for (var user in snapshot.data!) {
                  if (user.uid != TEWAMLISTOMNI.uid &&
                      user.accountStatus == Status.ACTIVE &&
                      user.uid_Team == user.uid_Team) {
                    items.add(user);
                  }
                }
                items.sort((a, b) {
                  return DateTime.parse(b.dateCreated!)
                      .compareTo(DateTime.parse(a.dateCreated!));
                });
                return items.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 100 / 812,
                          ),
                          Center(
                              child: Text(
                            "There are no Users".tr,
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          )),
                        ],
                      )
                    : SizedBox(
                        height: items.length * 300.0,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(20),
                          itemCount: items != null ? items.length : 0,
                          itemBuilder: (context, index) {
                            return Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "User ID: ${items[index].id!}",
                                      ),
                                      IconButton(
                                        iconSize: 15,
                                        onPressed: () {},
                                        icon: const Icon(
                                          size: 18,
                                          Icons.chat,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "User name: ".tr,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(items[index].name!)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Email: ".tr,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                          child: Text(items[index].email!)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        "Phone: ".tr,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                          child: Text(items[index].phone!)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: TEWAMLISTOMNI.uid ==
                                        TEWAMLISTOMNI.uid_Team,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Revenue: '.tr,
                                        ),
                                        StreamBuilder<List<InvoiceModel>>(
                                          stream: FirebaseManager.shared
                                              .invoice(uid: items[index].uid!),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<InvoiceModel> payDone = [];
                                              for (var pay in snapshot.data!) {
                                                if (pay.invoice ==
                                                    Payment.Payment_Done) {
                                                  payDone.add(pay);
                                                }
                                              }
                                              _buildTotalMoney(payDone, []);
                                            }
                                            return Text(
                                              totalMoney,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${'Date created: '.tr}${items[index].dateCreated!.toString().substring(0, 10)}",
                                      ),
                                      Visibility(
                                        visible: TEWAMLISTOMNI.uid ==
                                            TEWAMLISTOMNI.uid_Team,
                                        child: IconButton(
                                          iconSize: 15,
                                          onPressed: () async {
                                            _deleteAccount(
                                                user: items[index].uid!);
                                            await FirebaseManager.shared
                                                .getAllsystem()
                                                .first
                                                .then((omni) {
                                              for (var system in omni) {
                                                FirebaseManager.shared
                                                    .addNotifications(
                                                        uidUser: system.uid,
                                                        title:
                                                            "${TEWAMLISTOMNI.id} Deleted ${items[index].id!}",
                                                        details: "To Deleted");
                                              }
                                            });
                                          },
                                          icon: const Icon(
                                            size: 18,
                                            Icons.delete,
                                            color: OMNIColors.redolor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]));
                          },
                        ),
                      );
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.black54,
                  backgroundColor: OMNIColors.backgroundColor,
                ));
              }
            }));
  }

  Widget Invoice_Mastar() {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.supervised_user_circle_sharp,
                color: Colors.black,
              ),
              tooltip: "Users".tr,
              onPressed: () {
                setState(() {
                  userOMNI = Page_OMNI.AllUser;
                });
              }),
          toolbarHeight: 70.0,
          title: Text("Total: ".tr, style: const TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
                tooltip: "Dashboard".tr,
                onPressed: () {
                  setState(() {
                    userOMNI = Page_OMNI.AllHome;
                  });
                }),
          ],
        ),
        body: StreamBuilder<List<InvoiceModel>>(
          stream: FirebaseManager.shared.invoicebyuid(uid: UID_TEAM!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'.tr),
              );
            } else if (snapshot.hasData) {
              List<InvoiceModel>? searchResult = [];
              searchResult.sort((a, b) {
                return DateTime.parse(b.createdDate.toString())
                    .compareTo(DateTime.parse(a.createdDate.toString()));
              });
              for (var userDetail in snapshot.data!) {
                if (userDetail.id.contains(searchTextField!.text) ||
                    userDetail.id.contains(searchTextField!.text)) {
                  searchResult.add(userDetail);
                }
              }
              List<InvoiceModel> OMNIDone = [];
              for (var pay in snapshot.data!) {
                if (pay.invoice == Payment.Payment_Done) {
                  OMNIDone.add(pay);
                }
              }
              _buildTotalMoney(OMNIDone, []);
              return Column(
                children: <Widget>[
                  Text(totalMoney, style: const TextStyle(color: Colors.black)),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Card(
                        elevation: 0,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          trailing: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          title: TextField(
                            controller: searchTextField,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "Search".tr,
                                border: InputBorder.none),
                            onChanged: (value) {
                              searchResult.clear();
                              if (searchTextField!.text.isEmpty) {
                                setState(() {});
                                return;
                              }
                              setState(() {});
                            },
                          ),
                          leading: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              searchTextField!.clear();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          controller: _contoller,
                          itemCount: searchResult.length,
                          itemBuilder: (item, index) {
                            String statusTitle = "";
                            Widget statusIcon = const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.green,
                            );
                            switch (searchResult[index].invoice) {
                              case Payment.Payment_Done:
                                statusTitle = "Pay Done".tr;
                                statusIcon = const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.green,
                                );
                                break;
                              case Payment.PENDING:
                                statusTitle = "In Review".tr;
                                statusIcon = const Icon(
                                  Icons.access_time,
                                  size: 15,
                                  color: Colors.black54,
                                );
                                break;
                              case Payment.payment_processed:
                                statusTitle = "Unpaid".tr;
                                statusIcon = const Icon(
                                  Icons.report,
                                  size: 15,
                                  color: Colors.blue,
                                );
                                break;
                              case Payment.Ruten:
                                statusTitle = "Return".tr;
                                statusIcon = const Icon(
                                  Icons.remove,
                                  size: 15,
                                  color: Colors.red,
                                );
                                break;
                            }
                            return InkWell(
                              onTap: () {
                                Get.toNamed(
                                    '/Invoice/${searchResult[index].uid}');
                              },
                              child: Card(
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                        color: Colors.black,
                                        iconSize: 26,
                                        icon: const Icon(
                                            Icons.picture_as_pdf_sharp),
                                        onPressed: () async {
                                          if (searchResult[index].VAT == 999) {
                                            await Printing.sharePdf(
                                                bytes: await generateDocument(
                                                    context,
                                                    searchResult[index]),
                                                filename:
                                                    '#${searchResult[index].id}');
                                          } else {
                                            await Printing.sharePdf(
                                                bytes: await generate(
                                                    searchResult[index]),
                                                filename:
                                                    '#${searchResult[index].id}');
                                          }
                                        }),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "${'#Reference Number: '.tr}${searchResult[index].id}",
                                              style:
                                                  const TextStyle(fontSize: 10),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(searchResult[index].name)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              statusIcon,
                                              const SizedBox(width: 5),
                                              Text(
                                                statusTitle,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${Utils.formatPrice(searchResult[index].Total)} \$',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    searchResult[index]
                                                        .createdDate
                                                        .convertToDateStringOnly(),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })),
                ],
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black54,
                backgroundColor: OMNIColors.backgroundColor,
              ));
            }
          },
        ));
  }


  void _buildTotalMoney(List<InvoiceModel> rp, List<InvoiceModel> INV) {
    double sum = 0.0;
    double OMNI = 0.0;

    for (var i = 0; i < rp.length; ++i) {
      sum += rp[i].Total;
    }

    for (var i = 0; i < INV.length; ++i) {
      OMNI += INV[i].Total;
    }

    totalMoney = '${_roundMoney(OMNI)}';
    totalMoneyToday = '${_roundMoney(sum)}';
  }

  _roundMoney(double money) {
    double round = money;
    if (round < 1000) return Utils.formatPrice(round);
    if (round < 1000000) return Utils.formatk((money / 1000));
    if (round < 1000000000) {
      return Utils.formatM((money / 1000000));
    } else {
      return Utils.formatB((money / 1000000000));
    }
  }

  _deleteAccount({required String user}) {
    FirebaseManager.shared
        .changeStatusAccount(userId: user, status: Status.Deleted);
  }
}
