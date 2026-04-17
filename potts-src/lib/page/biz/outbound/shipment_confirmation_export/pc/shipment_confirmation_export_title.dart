import 'package:flutter/widgets.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：出荷確定データ出力-Title
 * 作者：张博睿
 * 时间：2023/08/22
 */

class ShipmentConfirmationExportTitle extends StatefulWidget {
  const ShipmentConfirmationExportTitle({super.key});

  @override
  State<ShipmentConfirmationExportTitle> createState() =>
      _ShipmentConfirmationExportTitleState();
}

class _ShipmentConfirmationExportTitleState
    extends State<ShipmentConfirmationExportTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_3_28,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            height: 1.0,
            color: Color.fromRGBO(44, 167, 176, 1)),
      ),
    );
  }
}
