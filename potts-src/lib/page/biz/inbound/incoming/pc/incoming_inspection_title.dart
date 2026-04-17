import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：入荷検品-文件
 * 作者：熊草云
 * 时间：2023/08/21
 */
class IncomingInspectionTitle extends StatefulWidget {
  const IncomingInspectionTitle({super.key});

  @override
  State<IncomingInspectionTitle> createState() =>
      _IncomingInspectionTitleState();
}

class _IncomingInspectionTitleState extends State<IncomingInspectionTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_2_4,
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
