import 'package:flutter/material.dart';

import '../../../../common/localization/default_localizations.dart';

/**
 * 内容：账户-标题
 * 作者：赵士淞
 * 时间：2023/08/14
 */
class AccountTitle extends StatefulWidget {
  const AccountTitle({super.key});

  @override
  State<AccountTitle> createState() => _AccountTitleState();
}

class _AccountTitleState extends State<AccountTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 21),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_50_1,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.0,
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
      ),
    );
  }
}
