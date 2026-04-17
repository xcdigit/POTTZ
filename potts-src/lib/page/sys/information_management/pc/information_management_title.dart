import 'package:flutter/material.dart';

import '../../../../common/localization/default_localizations.dart';

/**
 * 内容：運用基本情報管理-标题
 * 作者：王光顺
 * 时间：2023/09/06
 */

class InformationManagementTitle extends StatefulWidget {
  const InformationManagementTitle({super.key});

  @override
  State<InformationManagementTitle> createState() =>
      _InformationManagementTitleState();
}

class _InformationManagementTitleState
    extends State<InformationManagementTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_99_2,
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
