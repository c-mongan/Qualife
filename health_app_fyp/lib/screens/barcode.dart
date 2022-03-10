import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



class Barcode extends StatefulWidget {
  const Barcode({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Barcode> createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  String? scanResult;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Barcode Scanner'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      onPrimary: Colors.black,
                    ),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Scan items'),
                    onPressed: scanBarcode,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    scanResult == null
                        ? 'Scan a barcode'
                        : 'Scan Result : $scanResult',
                    style: const TextStyle(fontSize: 18),
                  )
                ]),
          ),
        ),
      );

  Future scanBarcode() async {
    String scanResult;

    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);
  }
}
