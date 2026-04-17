import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：入荷予定入力
 * 作者：王光顺
 * 时间：2023/08/18
 */
class ReserveInputTitle extends StatefulWidget {
  const ReserveInputTitle({super.key});

  @override
  State<ReserveInputTitle> createState() => _ReserveInputTitleState();
}

class _ReserveInputTitleState extends State<ReserveInputTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.reserve_input_1,
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
