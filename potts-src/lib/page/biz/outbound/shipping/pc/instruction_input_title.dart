import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：出荷指示入力-头部
 * 作者：赵士淞
 * 时间：2023/08/03
 */
class InstructionInputTitle extends StatefulWidget {
  const InstructionInputTitle({super.key});

  @override
  State<InstructionInputTitle> createState() => _InstructionInputTitleState();
}

class _InstructionInputTitleState extends State<InstructionInputTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_3_1,
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
