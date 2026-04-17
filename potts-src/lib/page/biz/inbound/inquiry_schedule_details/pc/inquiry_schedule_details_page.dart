import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inquiry_schedule_details_bloc.dart';
import '../bloc/inquiry_schedule_details_model.dart';
import 'inquiry_schedule_details_form.dart';
import 'inquiry_schedule_details_table.dart';

/**
 * 内容：入荷予定照会-明细
 * 作者：luxy
 * 时间：2023/08/21
 * 作者：赵士淞
 * 时间：2023/09/27
 */
// ignore: must_be_immutable
class InquiryScheduleDetailsPage extends StatefulWidget {
  // 入荷指示ID
  int receiveId;

  InquiryScheduleDetailsPage({super.key, this.receiveId = -1});

  @override
  State<InquiryScheduleDetailsPage> createState() =>
      _InquiryScheduleDetailsPageState();
}

class _InquiryScheduleDetailsPageState
    extends State<InquiryScheduleDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InquiryScheduleDetailsBloc>(
      create: (context) {
        return InquiryScheduleDetailsBloc(
          InquiryScheduleDetailsModel(
            rootContext: context,
            receiveId: widget.receiveId,
          ),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                // 表单
                InquiryScheduleDetailsForm(),
                // 表格
                InquiryScheduleDetailsTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
