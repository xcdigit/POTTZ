import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class GoodsTransferEntryScan extends StatefulWidget {
  const GoodsTransferEntryScan({super.key});

  @override
  State<GoodsTransferEntryScan> createState() => _GoodsTransferEntryScanState();
}

class _GoodsTransferEntryScanState extends State<GoodsTransferEntryScan> {
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  String qrCode = '';

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );

    await cameraController!.initialize();
    setState(() {
      isCameraInitialized = true;
    });
  }

  Future<void> scanQRCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // 扫描页面上的线条颜色
      '取消',
      true,
      ScanMode.DEFAULT,
    );

    setState(() {
      qrCode = barcodeScanRes;
    });
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
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // 扫描页面上的线条颜色
        '取消',
        true,
        ScanMode.DEFAULT,
      );

      setState(() {
        qrCode = barcodeScanRes;
      });
    } catch (e) {
      setState(() {
        qrCode = '';
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
              child: CameraPreview(cameraController!),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => pickImageFromGallery(),
              child: Text('选择照片'),
            ),
          ],
        ),
      ),
    );
  }
}
