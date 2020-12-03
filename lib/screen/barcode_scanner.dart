import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/models/user_infor_model.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/barcode_result_screen.dart';

class BarcodeScanScreen extends StatefulWidget {
  final Bus bus;
  BarcodeScanScreen({this.bus});
  @override
  _BarcodeScanScreenState createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes != '-1') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BarcodeResultScreen(
                    barcode: barcodeScanRes.toString(),
                    bus: widget.bus,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              scanBarcodeNormal();
            },
            child: Align(
              child: Container(
                width: 200,
                height: 200,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(200),
                ),
                child: SvgPicture.asset('assets/icons/scan-barcode.svg'),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'Scan Customers\' barcode to\n check in or check out',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
