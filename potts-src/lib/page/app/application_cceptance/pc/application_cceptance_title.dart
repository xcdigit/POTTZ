import 'package:flutter/material.dart';
import '../../../../common/localization/default_localizations.dart';

/**
 * 内容：申込受付 -标题
 * 作者：cuihr
 * 时间：2023/12/18
 */
class ApplicationCceptanceTitle extends StatefulWidget {
  const ApplicationCceptanceTitle({super.key});

  @override
  State<ApplicationCceptanceTitle> createState() =>
      _ApplicationCceptanceTitleState();
}

class _ApplicationCceptanceTitleState extends State<ApplicationCceptanceTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_98_25,
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
