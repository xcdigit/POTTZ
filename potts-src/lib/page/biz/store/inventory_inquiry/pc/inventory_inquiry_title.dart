import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';
/**
 * 内容：在庫照会
 * 作者：王光顺
 * 时间：2023/08/24
 */

class InventoryInquiryTitle extends StatefulWidget {
  const InventoryInquiryTitle({super.key});

  @override
  State<InventoryInquiryTitle> createState() => _InventoryInquiryTitleState();
}

class _InventoryInquiryTitleState extends State<InventoryInquiryTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_4_1,
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
