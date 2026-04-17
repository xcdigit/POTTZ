import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'wms_common_file.dart';

/**
 * 内容：共通文件平台类（网络端）
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
  void fileExport(String completeFileName, String contentString) {
    // 内容二进制
    var contentBlob = Blob([contentString], 'text/plain;charset=utf-8');
    // 文件点击下载
    AnchorElement(
      href: Url.createObjectUrlFromBlob(contentBlob).toString(),
    )
      ..setAttribute('download', completeFileName)
      ..click();
  }

  // 文件导入
  void fileImport(
      String fileTypeAccept,
      FileImportSuccessBuilder contentSuccessTreat,
      FileImportErrorBuilder contentErrorTreat,
      ImportCSVFileBuilder contentCallback) {
    // 上传标记
    var changeFlag = false;

    // 文件上传事件
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.accept = fileTypeAccept;
    uploadInput.click();
    // 文件上传事件监听
    uploadInput.onChange.listen((e) {
      // 判断上传标记
      if (changeFlag) {
        return;
      }
      // 上传标记
      changeFlag = true;

      // 上传文件列表
      List<File>? fileList = uploadInput.files;
      // 判断上传文件列表
      if (fileList!.length == 1) {
        // 上传文件
        File file = fileList[0];
        // 文件读取
        FileReader reader = FileReader();
        // 文件读取完成
        reader.onLoadEnd.listen((e) {
          // 内容处理
          contentSuccessTreat(reader.result.toString(), contentCallback);
        });
        // 文件读取失败
        reader.onError.listen((fileEvent) {
          print('onError');
          print(fileEvent.toString());
        });
        // 文件读取成文本
        reader.readAsText(file);
      }
    });

    // 焦点事件监听
    void focusEventListener(Event e) {
      // 移除焦点事件
      window.removeEventListener('focus', focusEventListener);

      // 延迟执行
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        // 判断上传标记
        if (!changeFlag) {
          // 上传标记
          changeFlag = true;
          // 内容处理
          contentErrorTreat(contentCallback);
        }
      });
    }

    // 添加焦点事件
    window.addEventListener('focus', focusEventListener);
  }

  // 文件上传
  void fileUpload(
      String folderName,
      String fileTypeAccept,
      String selectMode,
      ImageUploadSuccessBuilder contentSuccessTreat,
      ImageUploadErrorBuilder contentErrorTreat,
      UploadImageBuilder contentCallback) async {
    // 上传标记
    var changeFlag = false;

    // 文件上传事件
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.accept = fileTypeAccept;
    uploadInput.click();
    // 文件上传事件监听
    uploadInput.onChange.listen((e) {
      // 判断上传标记
      if (changeFlag) {
        return;
      }
      // 上传标记
      changeFlag = true;

      // 上传文件列表
      List<File>? fileList = uploadInput.files;
      // 判断上传文件列表
      if (fileList!.length == 1) {
        // 上传文件
        File file = fileList[0];
        // 文件类型
        String fileType = file.name.substring(file.name.lastIndexOf('.'));
        // 文件读取
        FileReader reader = FileReader();
        // 文件读取完成
        reader.onLoadEnd.listen((e) {
          // 内容处理
          contentSuccessTreat(folderName, fileType, reader.result as Uint8List,
              contentCallback);
        });
        // 文件读取失败
        reader.onError.listen((fileEvent) {
          print('onError');
          print(fileEvent.toString());
        });
        // 文件读取成文本
        reader.readAsArrayBuffer(file);
      }
    });

    // 焦点事件监听
    void focusEventListener(Event e) {
      // 移除焦点事件
      window.removeEventListener('focus', focusEventListener);

      // 延迟执行
      Future.delayed(Duration(milliseconds: 500)).then((value) {
        // 判断上传标记
        if (!changeFlag) {
          // 上传标记
          changeFlag = true;
          // 内容处理
          contentErrorTreat(contentCallback);
        }
      });
    }

    // 添加焦点事件
    window.addEventListener('focus', focusEventListener);
  }
}
