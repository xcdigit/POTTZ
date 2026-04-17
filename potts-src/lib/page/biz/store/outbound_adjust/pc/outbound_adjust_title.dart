import 'package:flutter/cupertino.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：在库调整入力 -头部
 * 作者：cuihr
 * 时间：2023/08/28
 */
class OutboundAdjustTitle extends StatefulWidget {
  const OutboundAdjustTitle({super.key});

  @override
  State<OutboundAdjustTitle> createState() => _OutboundAdjustTitleState();
}

class _OutboundAdjustTitleState extends State<OutboundAdjustTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //在库调整入力 -标题
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_4_17,
        style: TextStyle(
            height: 1.0,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(44, 167, 176, 1)),
      ),
    );
  }
}
