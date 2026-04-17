import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：出荷确定-头部
 * 作者：cuihr
 * 时间：2023/08/18
 */
class ShipmentDeterminationTitle extends StatefulWidget {
  const ShipmentDeterminationTitle({super.key});

  @override
  State<ShipmentDeterminationTitle> createState() =>
      _ShipmentDeterminationTitleState();
}

class _ShipmentDeterminationTitleState
    extends State<ShipmentDeterminationTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 出荷确定标题
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_3_26,
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
