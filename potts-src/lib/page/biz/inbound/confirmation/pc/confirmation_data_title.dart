import 'package:flutter/cupertino.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：入荷確定データ出力 -头部
 * 作者：cuihr
 * 时间：2023/08/24
 */
class ConfirmationDataTitle extends StatefulWidget {
  const ConfirmationDataTitle({super.key});

  @override
  State<ConfirmationDataTitle> createState() => _ConfirmationDataTitleState();
}

class _ConfirmationDataTitleState extends State<ConfirmationDataTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //入荷確定データ出力-标题
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_2_16,
        style: TextStyle(
          height: 1.0,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
      ),
    );
  }
}
