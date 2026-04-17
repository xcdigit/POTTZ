import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import '../bucket/bucket_provider.dart';
import 'wms_common_file_other.dart'
    if (dart.library.html) 'wms_common_file_web.dart';
import 'wms_common_file_utils.dart';

/**
 * 内容：共通文件
 * 作者：赵士淞
 * 时间：2023/09/11
 */
typedef ImportCSVFileBuilder = void Function(
    List<List<Map<String, dynamic>>> content);
typedef UploadImageBuilder = void Function(String content);

class WMSCommonFile {
  // 大小超出可控范围
  static const String SIZE_EXCEEDS = 'Size exceeds controllable range';

  // 导出CSV文件
  void exportCSVFile(List<String> titleList,
      List<Map<String, dynamic>> contentList, String fileName) async {
    // 行列表
    List<List<dynamic>> rowList = [];
    rowList.add(titleList);
    // 循环内容列表
    for (int i = 0; i < contentList.length; i++) {
      // 行
      List<dynamic> row = [];
      // 内容
      Map<String, dynamic> content = contentList[i];
      // 循环标题列表
      for (int j = 0; j < titleList.length; j++) {
        // 标题
        String title = titleList[j];
        // 判断内容标题
        if (content[title] != null) {
          // 行
          row.add(content[title]);
        } else {
          // 行
          row.add('');
        }
      }
      // 行列表
      rowList.add(row);
    }
    // CSV内容字符串
    String csvString = const ListToCsvConverter().convert(rowList);

    // 完整文件名
    String completeFileName =
        WMSCommonFileUtils.getCompleteFileName(fileName, '.csv');

    // 工具类-文件导出
    WMSCommonFilePlate().fileExport(completeFileName, csvString);
  }

  // 导入CSV文件
  void importCSVFile(ImportCSVFileBuilder contentCallback) {
    // 工具类-文件导入
    WMSCommonFilePlate().fileImport(
        '.csv',
        this.importCSVFileContentSuccessTreat,
        this.importCSVFileContentErrorTreat,
        contentCallback);
  }

  // 导入CSV文件内容成功处理
  void importCSVFileContentSuccessTreat(
      String content, ImportCSVFileBuilder contentCallback) {
    // 回调列表
    List<List<Map<String, dynamic>>> callbackList = [];

    // 内容行列表
    List<dynamic> contentRowList = content.split('\n');
    // 判断内容行列表
    if (contentRowList.length > 1) {
      // 分割下标
      int segmentIndex = -1;
      // 单元列表
      List<Map<String, dynamic>> unitList = [];
      // 标题列表
      List<String> titleList = [];
      // 循环内容行列表
      for (int i = 0; i < contentRowList.length; i++) {
        // 判断是首行/分割行
        if (i == segmentIndex + 1) {
          // 标题列表
          titleList = contentRowList[i].toString().split(',');
        } else if (contentRowList[i].toString() == '\r' ||
            contentRowList[i].toString() == '') {
          // 回调列表
          callbackList.add(unitList);
          // 分割下标
          segmentIndex = i;
          // 单元列表
          unitList = [];
          // 标题列表
          titleList = [];
        } else {
          // 行集合
          Map<String, dynamic> rowMap = {};
          // 行列表
          List<dynamic> rowList = contentRowList[i].toString().split(',');
          // 循环标题列表
          for (int j = 0; j < titleList.length; j++) {
            // 判断标题
            if (titleList[j] != '\r') {
              // 行集合
              rowMap.addAll({titleList[j]: rowList[j]});
            }
          }
          // 单元列表
          unitList.add(rowMap);
        }
      }
    }

    // 内容回调函数
    contentCallback(callbackList);
  }

  // 导入CSV文件内容失败处理
  void importCSVFileContentErrorTreat(ImportCSVFileBuilder contentCallback) {
    // 内容回调函数
    contentCallback([]);
  }

  // 上传图片文件
  void uploadImageFile(String folderName, String selectMode,
      UploadImageBuilder contentCallback) {
    // 判断平台
    if (kIsWeb) {
      // 工具类-图片导入
      WMSCommonFilePlate().fileUpload(
          folderName,
          '.png,.jpg,.jpeg',
          selectMode,
          this.uploadImageFileContentSuccessTreat,
          this.uploadImageFileContentErrorTreat,
          contentCallback);
    } else {
      // 工具类-图片导入
      WMSCommonFilePlate().fileUpload(
          folderName,
          'image',
          selectMode,
          this.uploadImageFileContentSuccessTreat,
          this.uploadImageFileContentErrorTreat,
          contentCallback);
    }
  }

  // 上传图片文件内容成功处理
  void uploadImageFileContentSuccessTreat(String folderName, String fileType,
      Uint8List content, UploadImageBuilder contentCallback) async {
    // 单元数
    final int unit = 1024;
    // 1M
    final int m = unit * unit;
    // 判断内容大小
    if (content.length > 2 * m) {
      // 内容回调函数
      contentCallback(SIZE_EXCEEDS);
    } else {
      // 图片文件名
      String imageFileName = WMSCommonFileUtils.getImageFileName(fileType);
      // 上传到数据桶
      String fileUrl = await BucketProvider().uploadByBinary(
          BucketType.pic, folderName + '/' + imageFileName, content);

      // 内容回调函数
      contentCallback(fileUrl);
    }
  }

  // 上传图片文件内容成功失败处理
  void uploadImageFileContentErrorTreat(
      UploadImageBuilder contentCallback) async {
    // 内容回调函数
    contentCallback('');
  }

  // 预览图片文件
  Future<String> previewImageFile(String fileUrl) async {
    // 有效URL
    String validUrl = fileUrl.substring(fileUrl.indexOf('/') + 1);
    // 预览数据桶文件
    String signedUrl = await BucketProvider().preview(BucketType.pic, validUrl);

    return signedUrl;
  }
}
