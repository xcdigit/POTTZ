import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：棚卸照会 -文件
 * 作者：熊草云
 * 时间：2023/08/29
 */
class InventoryQueryTitle extends StatefulWidget {
  const InventoryQueryTitle({super.key});

  @override
  State<InventoryQueryTitle> createState() => _InventoryQueryTitleState();
}

class _InventoryQueryTitleState extends State<InventoryQueryTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_5_9,
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
