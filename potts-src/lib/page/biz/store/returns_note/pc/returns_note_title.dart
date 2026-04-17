import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';

/**
 * 内容：返品照会
 * 作者：王光顺
 * 时间：2023/09/05
 */

class ReturnsNoteTitle extends StatefulWidget {
  const ReturnsNoteTitle({super.key});

  @override
  State<ReturnsNoteTitle> createState() => _ReturnsNoteTitleState();
}

class _ReturnsNoteTitleState extends State<ReturnsNoteTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_4_8,
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
