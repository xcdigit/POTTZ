import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'wms_common_file.dart';

/**
 * 内容：共通文件平台类（其他端）
 * 作者：赵士淞
 * 时间：2023/09/12
 */
typedef FileImportSuccessBuilder = void Function(
    String content, ImportCSVFileBuilder contentCallback);
typedef FileImportErrorBuilder = void Function(
    ImportCSVFileBuilder contentCallback);
typedef ImageUploadSuccessBuilder = void Function(String folderName,
    String fileType, Uint8List content, UploadImageBuilder contentCallback);
typedef ImageUploadErrorBuilder = void Function(
    UploadImageBuilder contentCallback);

class WMSCommonFilePlate {
  // 文件导出
  void fileExport(String completeFileName, String contentString) async {
    // 临时目录文件
    Directory dir = await getTemporaryDirectory();
    // 路径
    String path = dir.path;
    // 创建文件
    File file = File(path + '/' + completeFileName);
    // 文件写入
    file.writeAsString(contentString);
  }

  // 文件导入
  void fileImport(
      String fileTypeAccept,
      FileImportSuccessBuilder contentSuccessTreat,
      FileImportErrorBuilder contentErrorTreat,
      ImportCSVFileBuilder contentCallback) {}

  // 文件上传
  void fileUpload(
      String folderName,
      String fileTypeAccept,
      String selectMode,
      ImageUploadSuccessBuilder contentSuccessTreat,
      ImageUploadErrorBuilder contentErrorTreat,
      UploadImageBuilder contentCallback) async {
    // 判断文件类型
    if (fileTypeAccept == 'image') {
      // 选中图片
      final pickedImage;
      // 判断选择模式
      if (selectMode == 'gallery') {
        // 选中图片-相册
        pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else if (selectMode == 'camera') {
        // 选中图片-相机
        pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        // 选中图片
        pickedImage = null;
      }

      // 判断选中图片
      if (pickedImage != null) {
        // 上传文件
        File file = File(pickedImage.path);
        // 文件类型
        String fileType = file.path.substring(file.path.lastIndexOf('.'));
        // 图片质量
        int quality = imageQuality(file.readAsBytesSync().length);
        // 图片压缩
        Uint8List? result = await FlutterImageCompress.compressWithFile(
          file.path,
          minWidth: 1080,
          minHeight: 1920,
          quality: quality,
        );
        // 判断结果是否为空
        if (result != null) {
          // 内容处理
          contentSuccessTreat(folderName, fileType, result, contentCallback);
        } else {
          // 内容处理
          contentErrorTreat(contentCallback);
        }
      } else {
        // 内容处理
        contentErrorTreat(contentCallback);
      }
    }
  }

  // 根据传入的图片字节长度，返回指定的图片质量
  static int imageQuality(int length) {
    // 图片质量指数
    int quality = 100;
    // 1 兆
    int m = 1024 * 1024;
    // 判断图片字节长度
    if (length < 0.5 * m) {
      // 图片质量指数-图片小于 0.5 兆，质量设置为 70
      quality = 70;
    } else if (length >= 0.5 * m && length < 1 * m) {
      // 图片质量指数-图片大于 0.5 兆小于 1 兆，质量设置为 60
      quality = 60;
    } else if (length >= 1 * m && length < 2 * m) {
      // 图片质量指数-图片大于 1 兆小于 2 兆，质量设置为 50
      quality = 50;
    } else if (length >= 2 * m && length < 3 * m) {
      // 图片质量指数-图片大于 2 兆小于 3 兆，质量设置为 40
      quality = 40;
    } else if (length >= 3 * m && length < 4 * m) {
      // 图片质量指数-图片大于 3 兆小于 4 兆，质量设置为 30
      quality = 30;
    } else {
      // 图片质量指数-图片大于 4 兆，质量设置为 20
      quality = 20;
    }
    return quality;
  }
}
