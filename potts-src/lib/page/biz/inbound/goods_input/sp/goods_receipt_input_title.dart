import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：入庫入力-标题-sp
 * 作者：張博睿
 * 时间：2023/10/16
 */

class GoodsReceiptInputTitle extends StatefulWidget {
  const GoodsReceiptInputTitle({super.key});

  @override
  State<GoodsReceiptInputTitle> createState() => _GoodsReceiptInputTitleState();
}

class _GoodsReceiptInputTitleState extends State<GoodsReceiptInputTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_2_3,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          height: 1.0,
          color: Color.fromRGBO(44, 167, 176, 1),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
