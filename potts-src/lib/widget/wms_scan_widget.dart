import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

import '../common/localization/default_localizations.dart';

/**
 * 内容：扫描共通
 * 作者：赵士淞
 * 时间：2023/11/13
 */
// ignore: must_be_immutable
class WMSScanWidget extends StatefulWidget {
  // 扫描线条颜色
  Color scanLineColor;
  // 扫描回调函数
  final scanCallBack;

  WMSScanWidget({
    super.key,
    this.scanLineColor = Colors.green,
    this.scanCallBack,
  });

  @override
  State<WMSScanWidget> createState() => _WMSScanWidgetState();
}

class _WMSScanWidgetState extends State<WMSScanWidget> {
  // 扫描控制器
  ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ScanView(
            controller: controller,
            onCapture: (data) {
              // 扫描回调函数
              widget.scanCallBack(data);
              // 关闭弹窗
              Navigator.pop(context);
            },
            scanAreaScale: 0.7,
            scanLineColor: widget.scanLineColor,
          ),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: Container(
            color: Colors.white,
            height: 35,
            width: 80,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                WMSLocalizations.i18n(context)!.menu_content_3_11_11,
                style: TextStyle(
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                side: MaterialStateProperty.all(
                  const BorderSide(
                    width: 1,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
