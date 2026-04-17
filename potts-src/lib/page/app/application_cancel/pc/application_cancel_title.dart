import 'package:flutter/material.dart';

import '../../../../common/localization/default_localizations.dart';

/**
 * 内容：解约受付-头部
 * 作者：赵士淞
 * 时间：2025/01/08
 */
class ApplicationCancelTitle extends StatefulWidget {
  const ApplicationCancelTitle({super.key});

  @override
  State<ApplicationCancelTitle> createState() => _ApplicationCancelTitleState();
}

class _ApplicationCancelTitleState extends State<ApplicationCancelTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_98_26,
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
