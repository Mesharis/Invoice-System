import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:invoice/widgets/extensions.dart';
import 'package:invoice/widgets/pallete.dart';
import '../Model/SettingsModel.dart';
import '../Model/enum.dart';
import '../Model/invoice1model.dart';
import '../Model/user-model.dart';
import '../utils/FirebaseManager.dart';

class StepperDemo extends StatefulWidget {
  SettingsModel? OMNI;
  UserModel? USER;

  StepperDemo({Key? key, this.OMNI, this.USER}) : super(key: key);

  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> {
  final Clear = TextEditingController();
  final Clear1 = TextEditingController();
  final Clear2 = TextEditingController();
  final Clear3 = TextEditingController();

  List productList = [];
  List<Meshari> _inventoryEntries = [];
  String _productName = '';
  String _Qty = '';
  String _productPrice = "0.00";
  double _totalAmount = 0;
  String vat = "";
  String Dis = "";
  late String Tax_Number = "";
  String? Email;
  String? name;
  String? phone;

  @override
  void initState() {
    super.initState();
    if (widget.OMNI != null) {
      vat = widget.OMNI!.vat.toString();
      Tax_Number = widget.OMNI!.Tax_Number!;
    }
  }

  int _currentStep = 0;

  StepperType stepperType = StepperType.vertical;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${"Total: ".tr} ${_totalAmount}',
              style: TextStyle(color: OMNIColors.BlackBolor)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: OMNIColors.BlackBolor,
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
                visible: _currentStep > 0,
                child: FloatingActionButton(
                  heroTag: 'a',
                  backgroundColor: OMNIColors.BlackBolor,
                  child: const Icon(Icons.keyboard_arrow_up,color: Colors.white),
                  mini: true,
                  onPressed: _currentStep > 0 ? cancel : null,
                )),
            Visibility(
              visible: _currentStep < 2,
              child: FloatingActionButton(
                heroTag: 'b',
                backgroundColor: OMNIColors.BlackBolor,
                child: const Icon(Icons.keyboard_arrow_down,color: Colors.white),
                mini: true,
                onPressed: _currentStep < 2 ? continued : null,
              ),
            ),
            Visibility(
                visible: _currentStep > 1,
                child: FloatingActionButton(
                  heroTag: 'c',
                  backgroundColor: OMNIColors.BlackBolor,
                  child: const Icon(Icons.send,color: Colors.white),
                  mini: true,
                  onPressed: () async {
                    if (Email == "" || phone == "" || name == "" || _totalAmount == 0) {
                      Get.customSnackbar(
                        title: "Error",
                        message: "Please enter all fields",
                        isError: true,
                      );
                      return;
                    }
                    String? task = await FirebaseManager.shared.addinvoice(
                        payment: Payment.payment_processed,
                        images: widget.OMNI!.Logo!,
                        email: Email!,
                        phone: phone!,
                        name: name!,
                        VATTOTAL: 999,
                        NameUser: widget.OMNI!.Team_Name,
                        idUser: widget.USER!.id,
                        Tax_Number: Tax_Number,
                        uid_Team: widget.USER!.uid_Team,
                        uid_owner: widget.USER!.uid,
                        Total: _totalAmount,
                        VAT: 999,
                        Server: widget.OMNI!.server!);
                    for (var i = 0; i < _inventoryEntries.length; i++) {
                      await FirebaseManager.shared.addinvoiceDitiles(
                        uid: task,
                        billedQty: _inventoryEntries[i].billedQty,
                        rate: _inventoryEntries[i].rate,
                        stockItemName: _inventoryEntries[i].stockItemName,
                        taxAmount: _inventoryEntries[i].taxAmount,
                        vat: _inventoryEntries[i].vat,
                        dis: _inventoryEntries[i].dis,
                        discount: _inventoryEntries[i].discount,
                      );
                    }
                    await FirebaseManager.shared
                        .getAllsystem()
                        .first
                        .then((users) {
                      for (var user in users) {
                        double add = user.Totel_INVOICE! + 1;
                        print(add);
                        FirebaseManager.shared.systeaddInvoice(add);
                      }
                    });
                  },
                )),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stepper(
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Container();
                },
                type: stepperType,
                physics: const ScrollPhysics(),
                currentStep: _currentStep,
                onStepTapped: (step) => tapped(step),
                onStepContinue: continued,
                onStepCancel: cancel,
                steps: <Step>[
                  Step(
                    title: Text('ADD Details'.tr),
                    content: Column(children: [
                      titleservice(),
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  controller: Clear,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                    ),
                                    labelText: 'description'.tr,
                                    labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                    // AT: This should be a dropdown
                                  ),
                                  onChanged: (val) => setState(() => _productName = val),
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  initialValue: vat,
                                  onChanged: (val) => setState(() => vat = val),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                    ),
                                    labelText: 'VAT %'.tr,
                                    labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                    // AT: This should be a dropdown
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    controller: Clear1,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                      ),
                                      icon: Icon(
                                        Icons.attach_money, color:OMNIColors.BlackBolor
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      labelText: 'Price'.tr,
                                      labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                    ),
                                    onChanged: (val) =>
                                        setState(() => _productPrice = val),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(
                                          '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: Clear2,
                                    onChanged: (val) =>
                                        setState(() => _Qty = val),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(
                                          '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                      ),
                                      icon: Icon(
                                        Icons.shopping_cart,color:OMNIColors.BlackBolor
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      labelText: 'Qty'.tr,
                                      labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: Clear3,
                                    onChanged: (val) => setState(() => Dis = val),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(
                                          '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: OMNIColors.BlackBolor)
                                      ),
                                      icon: Icon(
                                        Icons.discount,color:OMNIColors.BlackBolor
                                      ),
                                      contentPadding: EdgeInsets.all(8),
                                      labelText: 'discount %'.tr,
                                      labelStyle: TextStyle(color: OMNIColors.BlackBolor),

                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ]),
                    ]),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: Text('Confirm Details'.tr),
                    content: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        margin: const EdgeInsets.only(top: 15),
                        height: 340,
                        color: Colors.transparent,
                        child: productList.isEmpty
                            ? Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No Details List To Display".tr,
                                      style: TextStyle(
                                          color: OMNIColors.BlackBolor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Click on Plus Icon (+) to add new Details"
                                          .tr,
                                      style: TextStyle(
                                          color: OMNIColors.BlackBolor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: productList.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        addService(
                                  index,
                                  productList[index][0],
                                  productList[index][1],
                                  productList[index][2],
                                  productList[index][3],
                                  productList[index][4],
                                ),
                              ),
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: Text('Create Invoice'.tr),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: Tax_Number,
                          keyboardType: TextInputType.number,
                          onChanged: (val) => setState(() => Tax_Number = val),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                            hintText: 'Enter Your Number VAT'.tr,
                            labelText: 'Number VAT'.tr,
                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          onChanged: (val) => setState(() => name = val),
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
                        const SizedBox(height: 10),
                        TextFormField(
                          onChanged: (val) => setState(() => Email = val),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: OMNIColors.BlackBolor)),
                            hintText: 'Enter Your Client Email'.tr,
                            labelText: 'Email'.tr,
                            labelStyle: TextStyle(color: OMNIColors.BlackBolor),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          onChanged: (val) => setState(() => phone = val),
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
                    isActive: _currentStep >= 0,
                    state: _currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget addService(int index, final String _title1, final String info1, final String info2, final String info3, final String info4,) {
    return Dismissible(
        key: Key(productList.toString()),
        onDismissed: (direction) {
          setState(() {
            productList.removeAt(index);
            _inventoryEntries.removeAt(index);
            for (var i = 0; i < _inventoryEntries.length; i++) {
              _totalAmount = double.parse(_inventoryEntries[i].rate) +
                  double.parse(_inventoryEntries[i].taxAmount) -
                  double.parse(_inventoryEntries[i].discount);
            }
            ;
            if (_inventoryEntries.length == 0) {
              _totalAmount = 0;
            }
          });
        },
        child: Row(
          children: [
            Container(
                child: Text((index + 1).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: OMNIColors.BlackBolor))),
            Expanded(
              child: Text(
                _title1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            Expanded(
              child: Text(info1, style: Theme.of(context).textTheme.bodyText1),
            ),
            Expanded(
              child: Text(
                info2,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Expanded(
              child: Text(info3),
            ),
            Expanded(
                child:
                    Text(info4, style: Theme.of(context).textTheme.bodyText1)),
          ],
        ));
  }

  Row titleservice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5, top: 5),
          child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.add),
              color: OMNIColors.BlackBolor,
              tooltip: 'Add New',
              onPressed: () {
                setState(() {
                  addServiceIntoList();
                });
              }),
        ),
      ],
    );
  }

  addServiceIntoList() {
    if (_productName == '' || _productPrice == '' ||_productPrice == 0 || _Qty == '' || vat == '' || Dis == '') {
      Get.customSnackbar(
        title: "Error",
        message: "Please enter all fields",
        isError: true,
      );
      return;
    }

    double amount = double.parse(_Qty) * double.parse(_productPrice);
    double gstAmount;
    double Discount;
    List tempList;
    gstAmount = ((double.parse(vat)) / 100) * amount;
    Discount = ((double.parse(Dis)) / 100) * amount;
    double Total =
        double.parse(_Qty) * double.parse(_productPrice) + gstAmount - Discount;
    tempList = [
      _productName,
      '${"Total: ".tr} $Total',
      '${'Qty'.tr} ${_Qty} ${'Price'.tr} ${_productPrice}',
      '${'VAT %'.tr}  ${vat}  $gstAmount',
      '${'discount %'.tr} ${Dis} $Discount',
    ];
    setState(() {
      _inventoryEntries.add(Meshari(
        billedQty: double.parse(_Qty),
        discount: Dis,
        rate: _productPrice,
        stockItemName: _productName,
        taxAmount: gstAmount.toString(),
        vat: double.parse(vat),
        dis: Discount,
      ));
      productList.add(tempList);
      _totalAmount += Total;
      Clear.clear();
      Clear1.clear();
      Clear2.clear();
      Clear3.clear();
    });
  }
}
