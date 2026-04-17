import 'package:flutter/material.dart';

import '../../../../common/localization/default_localizations.dart';
/**
 * 内容：サービス解約-标题
 * 作者：王光顺
 * 时间：2023/12/07
 */

class ContractTitle extends StatefulWidget {
  const ContractTitle({super.key});

  @override
  State<ContractTitle> createState() => _ContractTitleState();
}

class _ContractTitleState extends State<ContractTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Text(
        WMSLocalizations.i18n(context)!.contract_text_1,
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
