import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannScreen extends StatefulWidget {
  const QRScannScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<QRScannScreen> createState() => _QRScannScreen();
}

class _QRScannScreen extends State<QRScannScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if(Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        //child: Expanded(child: _buildQrView(context), flex: 4),
        child: _buildQrView(context),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await controller!.flipCamera(),
        child: const Icon(Icons.flip_camera_android),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 5,
        cutOutSize: scanArea
      ),
      onPermissionSet: (ctrl, permission) => _onPermissionSet(context, ctrl, permission),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((qrCode) {
      setState(() {
        result = qrCode;
      });
      if(result != null) {
        print(result!.code!);
        Navigator.pushReplacementNamed(context, "/form", arguments: result!.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool permission) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $permission');
    if(!permission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No Given Permission"))
      );
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
