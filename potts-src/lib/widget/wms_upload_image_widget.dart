import 'package:flutter/material.dart';

import '../common/localization/default_localizations.dart';
import '../file/wms_common_file.dart';

/**
 * 内容：图片上传共通（手机端）
 * 作者：赵士淞
 * 时间：2023/11/28
 */
// ignore: must_be_immutable
class WMSUploadImageWidget extends StatefulWidget {
  // 文件夹名称
  String folderName;
  // 图片上传回调函数
  final uploadImageCallBack;

  WMSUploadImageWidget({
    super.key,
    required this.folderName,
    this.uploadImageCallBack,
  });

  @override
  State<WMSUploadImageWidget> createState() => _WMSUploadImageWidgetState();
}

class _WMSUploadImageWidgetState extends State<WMSUploadImageWidget> {
  // 初始化列表
  List<Widget> _initList(List contentList) {
    // 组件列表
    List<Widget> widgetList = [];
    // 循环内容列表
    for (int i = 0; i < contentList.length; i++) {
      // 组件列表
      widgetList.add(
        GestureDetector(
          onTap: () {
            // 上传图片文件
            WMSCommonFile().uploadImageFile(widget.folderName,
                contentList[i]['value'], widget.uploadImageCallBack);
            // 关闭弹窗
            Navigator.pop(context);
          },
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Align(
                child: Text(contentList[i]['label']),
              ),
            ),
          ),
        ),
      );
    }
    // 返回
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    // 内容列表
    List _contentList = [
      {
        'label': WMSLocalizations.i18n(context)!.selection_mode_camera,
        'value': 'camera',
      },
      {
        'label': WMSLocalizations.i18n(context)!.selection_mode_album,
        'value': 'gallery',
      },
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        WMSLocalizations.i18n(context)!.confirm_selection_mode,
      ),
      content: Container(
        height: 120,
        child: Column(
          children: _initList(_contentList),
        ),
      ),
    );
  }
}
