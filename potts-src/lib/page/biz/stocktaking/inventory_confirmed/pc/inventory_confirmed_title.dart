import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * content：棚卸確定-标题
 * author：张博睿
 * date：2023/08/30
 */

class InventoryConfirmedTitle extends StatefulWidget {
  const InventoryConfirmedTitle({super.key});

  @override
  State<InventoryConfirmedTitle> createState() =>
      _InventoryConfirmedTitleState();
}

class _InventoryConfirmedTitleState extends State<InventoryConfirmedTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_5_11,
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
