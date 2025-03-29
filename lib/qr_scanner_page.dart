import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner QR Code"),
      ),
      body: MobileScanner(
        // ✅ Le paramètre attendu ici est SEULEMENT (BarcodeCapture capture)
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              // ignore: avoid_print
              print('QR Code détecté: $code');


              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}