import 'package:flutter/material.dart';

import '../../../../common/localization/default_localizations.dart';

/**
 * 内容：操作ログ-头部
 * 作者：luxy
 * 时间：2023/11/27
 */

class OperateLogTitle extends StatefulWidget {
  const OperateLogTitle({super.key});

  @override
  State<OperateLogTitle> createState() => _OperateLogTitleState();
}

class _OperateLogTitleState extends State<OperateLogTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_99_6,
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
