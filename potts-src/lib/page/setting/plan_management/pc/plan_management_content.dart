import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/setting/plan_management/pc/plan_management_content_detail.dart';

import '../../../../common/config/config.dart';
import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';
import 'plan_management_content_add.dart';
import 'plan_management_content_detail_add.dart';
import 'plan_management_content_edit.dart';

/**
 * 内容：计划管理-内容
 * 作者：赵士淞
 * 时间：2024/06/27
 */
class PlanManagementContent extends StatefulWidget {
  const PlanManagementContent({super.key});

  @override
  State<PlanManagementContent> createState() => _PlanManagementContentState();
}

class _PlanManagementContentState extends State<PlanManagementContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanManagementBloc, PlanManagementModel>(
      builder: (context, state) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(40, 80, 0, 80),
              padding: EdgeInsets.fromLTRB(60, 60, 60, 60),
              decoration: BoxDecoration(
                color: Color.fromRGBO(102, 199, 206, 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: context.read<PlanManagementBloc>().state.detailPageSign ==
                      Config.NUMBER_ZERO
                  ? PlanManagementContentDetailAdd()
                  : context.read<PlanManagementBloc>().state.detailPageSign ==
                          Config.NUMBER_ONE
                      ? PlanManagementContentDetail()
                      : context
                                  .read<PlanManagementBloc>()
                                  .state
                                  .currentMenuIndex ==
                              Config.NUMBER_ZERO
                          ? PlanManagementContentAdd()
                          : context
                                      .read<PlanManagementBloc>()
                                      .state
                                      .currentMenuIndex ==
                                  Config.NUMBER_ONE
                              ? PlanManagementContentEdit()
                              : Container(),
            ),
          ],
        );
      },
    );
  }
}
