import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：欠品伝票照会-头部
 * 作者：luxy
 * 时间：2023/08/15
 */

class LackGoodsInvoiceTitle extends StatefulWidget {
  const LackGoodsInvoiceTitle({super.key});

  @override
  State<LackGoodsInvoiceTitle> createState() => _LackGoodsInvoiceTitleState();
}

class _LackGoodsInvoiceTitleState extends State<LackGoodsInvoiceTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_3_11,
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
