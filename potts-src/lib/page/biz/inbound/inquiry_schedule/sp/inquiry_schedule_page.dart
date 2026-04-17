import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inquiry_schedule_bloc.dart';
import '../bloc/inquiry_schedule_model.dart';
import 'inquiry_schedule_table.dart';

/**
 * 内容：入荷予定照会
 * 作者：熊草云
 * 时间：2023/10/16
 */
class InquirySchedulePage extends StatefulWidget {
  const InquirySchedulePage({super.key});

  @override
  State<InquirySchedulePage> createState() => _InquirySchedulePageState();
}

class _InquirySchedulePageState extends State<InquirySchedulePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InquiryScheduleBloc>(
      create: (context) {
        return InquiryScheduleBloc(
          InquiryScheduleModel(
            rootContext: context,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(19, 0, 19, 0),
        child: ListView(
          children: [
            // 表格
            InquiryScheduleTable(),
          ],
        ),
      ),
    );
  }
}
