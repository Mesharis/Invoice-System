import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:invoice/widgets/extensions.dart';
import '../Model/enum.dart';
import '../Model/InvoiceModel.dart';
import '../main.dart';
import '../utils/FirebaseManager.dart';
import '../utils/utils.dart';
import 'pallete.dart';

class PayInvoice extends StatefulWidget {
  const PayInvoice({
    Key? key,
  }) : super(key: key);

  @override
  State<PayInvoice> createState() => _PayInvoiceState();
}

class _PayInvoiceState extends State<PayInvoice> {

   bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    String? id = Get.parameters['InvoiceId'];
    return Scaffold(
      body: StreamBuilder<InvoiceModel>(
          stream: FirebaseManager.shared.getinvoiceyId(id: id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              InvoiceModel Economie = snapshot.data!;
              String myString = Utils.formatPrice(Economie.Total);
              myString = myString.replaceAll(".", "");
              print(myString);
              setPageTitle(Economie.NameUser, context);
              return Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: double.infinity,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: OMNIColors.BlackBolor,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: OMNIColors.backgroundColor,
                              radius: 50,
                              child: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: OMNIColors.BlackBolor,
                                    ),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  padding: const EdgeInsets.all(1),
                                  child: Image.network(
                                      scale: 1,
                                      Economie.images)),
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('#Reference Number: '.tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Flexible(
                                    child: Text(Economie.id,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Merchent Name".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Flexible(
                                    child: Text(Economie.NameUser,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Invoice To :".tr,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Flexible(
                                    child: Text(Economie.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ],
                            ), // name
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Total: ".tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text('${Utils.formatPrice(Economie.Total)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ), // total
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "invoice date :".tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                      '${Economie.createdDate
                                          .convertToDateStringOnly()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ), // da
                            const SizedBox(height: 30),
                            Visibility(
                                visible: Economie.invoice ==
                                    Payment.payment_processed,
                                child: PAY(Economie: Economie, myString: myString)
                            ),
                            Visibility(
                                visible: Economie.invoice !=
                                    Payment.payment_processed,
                                child: Text("Payment Done!".tr,
                                  style: TextStyle(color: OMNIColors.greanBolor),)
                            ),
                          ])));
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: OMNIColors.BlackBolor,
                ),
              );
            }
          }),
    );
  }

  PAY({required Economie,required myString}) {
    return Container(
      child: ElevatedButton(
        onPressed: isProcessing
            ? null
            : () async{  },
        child: isProcessing
            ? const CircularProgressIndicator
            .adaptive()
            : Text("Pay".tr,style: TextStyle(color: Colors.white),
      ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            OMNIColors.BlackBolor,
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
