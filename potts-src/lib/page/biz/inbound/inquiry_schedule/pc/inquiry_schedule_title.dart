import 'package:flutter/material.dart';

import '../../../../../common/localization/default_localizations.dart';
/**
 * 内容：入荷予定照会-头部
 * 作者：luxy
 * 时间：2023/08/18
 */

class InquiryScheduleTitle extends StatefulWidget {
  const InquiryScheduleTitle({super.key});

  @override
  State<InquiryScheduleTitle> createState() => _InquiryScheduleTitleState();
}

class _InquiryScheduleTitleState extends State<InquiryScheduleTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Text(
        WMSLocalizations.i18n(context)!.menu_content_2_5,
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
