import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:invoice/widgets/pallete.dart';
import 'package:invoice/widgets/vilidator.dart';
import '../Model/enum.dart';
import '../Model/SettingsModel.dart';
import '../Model/user-model.dart';
import '../utils/FirebaseManager.dart';
import 'A_Invoice.dart';

class Q_invoice extends StatefulWidget {
  SettingsModel? OMNI;
  UserModel? USER;

   Q_invoice({Key? key, this.OMNI,this.USER}) : super(key: key);

  @override
  State<Q_invoice> createState() => _Q_invoiceState();
}

class _Q_invoiceState extends State<Q_invoice> {
  Validator validator = Validator();
  final GlobalKey<FormState> _formKey = GlobalKey();


  late String vat;
  late String Tax_Number = "";
  late String Price;
  late String Email = "";
  late String name = "";
  late String phone = "";
  @override
  void initState() {
    super.initState();
    if (widget.OMNI != null) {
      vat = widget.OMNI!.vat!.toString();
      Tax_Number = widget.OMNI!.Tax_Number!;
    }
  }
  @override
  Widget build(BuildContext context) {
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
                    color: OMNIColors.backgroundColor,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  iconSize: 24,
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                InkWell(
                                    onTap: () async {
                                      Get.to(StepperDemo(OMNI:widget.OMNI , USER:widget.USER));
                                    },
                                    child: Text( "Advanced invoice".tr)),
                              ]),
                          Center(
                            child: Text(
                              'quick invoice'.tr,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.headline1!.color,
                                fontSize: 24,
                                fontWeight:
                                FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: SafeArea(
                                child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.always,
                                  onChanged: () {
                                    Form.of(primaryFocus!.context!)?.save();
                                  },
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxWidth: 400),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          validator: (Price) {
                                            return validator.validatvalue(Price!);
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                                          ],
                                          onSaved: (value) => Price = value!.trim(),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration:
                                           InputDecoration(
                                            focusedBorder:  UnderlineInputBorder(
                                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your Price'.tr,
                                            labelText: 'Price'.tr,
                                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: (vat) {
                                            return validator.validatvalue(vat!);
                                          },
                                          initialValue: vat.toString(),
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          onSaved: (value) => vat = value!.trim(),
                                          decoration:
                                           InputDecoration(
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your VAT %'.tr,
                                            labelText: 'VAT %'.tr,
                                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          initialValue: Tax_Number,
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) => Tax_Number = value!.trim(),
                                          textInputAction: TextInputAction.next,
                                          decoration:
                                           InputDecoration(
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your Number VAT'.tr,
                                            labelText: 'Number VAT'.tr,
                                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          validator: (name) {
                                            return validator.validatvalue(name!);
                                          },
                                          onSaved: (value) => name = value!.trim(),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your Client name'.tr,
                                            labelText: 'name'.tr,
                                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          onSaved: (value) => Email = value!.trim(),
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          validator: (email) {
                                            return validator
                                                .validateEmail(email!);
                                          },
                                          decoration: InputDecoration(
                                            focusedBorder: const UnderlineInputBorder(
                                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your Client Email'.tr,
                                            labelText: 'Email'.tr,
                                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          onSaved: (value) => phone = value!.trim(),
                                          validator: (phone) {
                                            return validator.validateMobile(phone!);
                                          },
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                             focusedBorder: const UnderlineInputBorder(
                                               borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                                            hintText: 'Enter Your Client phone'.tr,
                                            labelText: 'phone'.tr,
                                             labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                                             border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                double TotelOMNIVAT = ((double.parse(vat)) / 100) * double.parse(Price);
                                double TotelOMNI = double.parse(Price) + TotelOMNIVAT;
                                FirebaseManager.shared.addinvoice(
                                    Server: widget.OMNI!.server!,
                                    payment: Payment.payment_processed,
                                    images: widget.OMNI!.Logo!,
                                    email: Email,
                                    phone: phone,
                                    name: name,
                                    VATTOTAL:  TotelOMNIVAT,
                                    VAT: double.parse(vat),
                                    NameUser: widget.OMNI!.Team_Name,
                                    idUser: widget.USER!.id,
                                    Tax_Number: Tax_Number,
                                    uid_Team: widget.USER!.uid_Team,
                                    uid_owner: widget.USER!.uid,
                                    Total: TotelOMNI
                                );
                                await FirebaseManager.shared.getAllsystem().first.then((users)  {
                                  for (var user in users) {
                                    double add = user.Totel_INVOICE! + 1;
                                    FirebaseManager.shared.systeaddInvoice(add);
                                  }
                                });
                              }},
                              child: Text(
                                "Create Invoice".tr,style: TextStyle(color: OMNIColors.BlackBolor),
                              ),
                            ),
                          )
                        ])
                )
            )
        )
    );
  }
}

