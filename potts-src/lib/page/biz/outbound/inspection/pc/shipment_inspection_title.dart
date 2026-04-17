import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：出荷検品-文件
 * 作者：熊草云
 * 时间：2023/08/17
 */
class ShipmentInspectionTitle extends StatefulWidget {
  const ShipmentInspectionTitle({super.key});

  @override
  State<ShipmentInspectionTitle> createState() =>
      _ShipmentInspectionTitleState();
}

class _ShipmentInspectionTitleState extends State<ShipmentInspectionTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_3_13,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          height: 1.0,
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
      ),
    );
  }
}
