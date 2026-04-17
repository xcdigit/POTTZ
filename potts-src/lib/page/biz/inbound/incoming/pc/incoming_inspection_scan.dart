import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

/**
 * 内容：出荷検品 - 文件
 * 作者：熊草云
 * 时间：2023/08/21
 */

class IncomingInspectionScan extends StatefulWidget {
  const IncomingInspectionScan({Key? key}) : super(key: key);

  @override
  State<IncomingInspectionScan> createState() => _IncomingInspectionScanState();
}

class _IncomingInspectionScanState extends State<IncomingInspectionScan> {
  late CameraController cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  String qrCode = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );

    await cameraController.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await QRCodeScanner.scan();
      setState(() {
        this.qrCode = qrCode;
      });
    } catch (e) {
      setState(() {
        this.qrCode = '';
      });
      print('扫描出错: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      performBarcodeScanning(pickedFile.path);
    }
  }

  void performBarcodeScanning(String imagePath) async {
    try {
      final qrCode = await QRCodeScanner.scan();
      setState(() {
        this.qrCode = qrCode;
      });
    } catch (e) {
      setState(() {
        this.qrCode = '';
      });
      print('扫描出错: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(cameraController),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => pickImageFromGallery(),
              child: Text('选择照片'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => scanQRCode(),
              child: Text('扫描二维码'),
            ),
            SizedBox(height: 16),
            Text('QR Code: $qrCode'),
          ],
        ),
      ),
    );
  }
}

class QRCodeScanner {
  static Future<String> scan() async {
    // TODO: Implement QR code scanning using qr_code_scanner library
    // You can use the qr_code_scanner library API to scan the QR code
    // and return the scanned result as a String.
    return 'Sample QR Code'; // Replace this with the actual scanned QR code value
  }
}
