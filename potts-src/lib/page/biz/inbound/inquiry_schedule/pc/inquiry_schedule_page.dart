import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inquiry_schedule_bloc.dart';
import '../bloc/inquiry_schedule_model.dart';
import 'inquiry_schedule_table.dart';
import 'inquiry_schedule_title.dart';

/**
 * 内容：入荷予定照会
 * 作者：luxy
 * 时间：2023/08/18
 */
class InquirySchedulePage extends StatefulWidget {
  const InquirySchedulePage({super.key});

  @override
  State<InquirySchedulePage> createState() => _InquirySchedulePageState();
}

class _InquirySchedulePageState extends State<InquirySchedulePage> {
  @override
  Widget build(BuildContext context) {
    // 赵士淞 - 始
    return BlocProvider<InquiryScheduleBloc>(
      create: (context) {
        return InquiryScheduleBloc(
          InquiryScheduleModel(
            rootContext: context,
          ),
        );
      },
      // 赵士淞 - 终
      child: Scrollbar(
        thumbVisibility: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              InquiryScheduleTitle(),
              // 表格
              InquiryScheduleTable(),
            ],
          ),
        ),
      ),
      // 赵士淞 - 始
    );
    // 赵士淞 - 终
  }
}
