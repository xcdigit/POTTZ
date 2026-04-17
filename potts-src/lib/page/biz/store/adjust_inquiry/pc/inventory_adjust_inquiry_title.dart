import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * content：在庫調整照会-标题
 * author：张博睿
 * date：2023/08/28
 */
class InventoryAdjustInquiryTitle extends StatefulWidget {
  const InventoryAdjustInquiryTitle({super.key});

  @override
  State<InventoryAdjustInquiryTitle> createState() =>
      _InventoryAdjustInquiryTitleState();
}

class _InventoryAdjustInquiryTitleState
    extends State<InventoryAdjustInquiryTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_4_18,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            height: 1.0,
            color: Color.fromRGBO(44, 167, 176, 1)),
      ),
    );
  }
}
