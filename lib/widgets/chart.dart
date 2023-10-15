
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Crack/flutter.dart' as charts;
import 'package:invoice/widgets/pallete.dart';
import '../Model/InvoiceModel.dart';

class Chart extends StatefulWidget {
  dynamic inv;
   Chart({Key? key,this.inv}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  String currentItem = chartDropdownItems[0];

  DateFormat format = DateFormat.Md();
  int currentI = 0;
  static final List<String> chartDropdownItems = [
    'Last 7 days'.tr,
    'Months'.tr,
    'Years'.tr
  ];

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
                            Center(
                              child:DropdownButton(
                                  isDense: true,
                                  value: currentItem,
                                  onChanged: (String? value) => setState(() {
                                    currentItem = value!;
                                    for (var i = 0; i < chartDropdownItems.length; ++i) {
                                      if (value == chartDropdownItems[i]) {
                                        _reloadData(i);
                                        currentI = i;
                                      }
                                    }
                                  }),
                                  items: chartDropdownItems.map((String title) {
                                    return DropdownMenuItem(
                                      value: title,
                                      child: Text(title),
                                    );
                                  }).toList()),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                                height: 250,
                                child: _buildChart(widget.inv!)
                            ),
                          ]),
                    ),
                  )));
  }

  Widget _buildChart(List<InvoiceModel> rp) {
    return charts.BarChart(
      _parseSeries(rp),
      animate: true,
    );
  }
  void _reloadData(int id) {
    switch (id) {
      case 0:
        format = DateFormat.Md();
        break;
      case 1:
        format = DateFormat.yMMM();
        break;
      default:
        format = DateFormat.y();
        break;
    }
  }
  List<charts.Series<InvoiceModel, String>> _parseSeries(List<InvoiceModel> reports) {
    return [
      charts.Series<InvoiceModel, String>(
          id: 'Report',
          colorFn: (_, __) => charts.MaterialPalette.black,
          domainFn: (InvoiceModel rp, index) => format.format(rp.createdDate),
          measureFn: (InvoiceModel rp, index) => rp.Total,
          data: reports),
    ];
  }

}