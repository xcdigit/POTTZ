import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：返品入力
 * 作者：王光顺
 * 时间：2023/08/25
 */
class ReturnProductTitle extends StatefulWidget {
  const ReturnProductTitle({super.key});

  @override
  State<ReturnProductTitle> createState() => _ReturnProductTitleState();
}

class _ReturnProductTitleState extends State<ReturnProductTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_4_4,
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
