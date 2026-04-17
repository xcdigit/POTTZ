import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：棚卸データ出力
 * 作者：王光顺
 * 时间：2023/08/30
 */
class InventoryOutputTitle extends StatefulWidget {
  const InventoryOutputTitle({super.key});

  @override
  State<InventoryOutputTitle> createState() => _InventoryOutputTitleState();
}

class _InventoryOutputTitleState extends State<InventoryOutputTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_5_3,
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
