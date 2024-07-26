import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../models/attendance_model.dart';
import '../viewmodels/attendance_viewmodel.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan Barcode')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (barcode != null)
                  ? Text('Barcode: $barcode')
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        barcode = scanData.code;
      });
      // Parse the barcode and submit attendance
      _submitAttendance(barcode!);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _submitAttendance(String barcode) {
    final data = barcode.split(',');
    if (data.length == 3) {
      final attendance = Attendance(
        name: data[0],
        className: data[1],
        time: data[2],
      );

      context
          .read<AttendanceViewModel>()
          .submitAttendance(attendance)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance submitted successfully!')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit attendance: $error')));
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid barcode format')));
    }
  }
}
