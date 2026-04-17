import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/setting/plan_management/pc/plan_management_content.dart';
import 'package:wms/page/setting/plan_management/pc/plan_management_menu.dart';

import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';

/**
 * 内容：计划管理
 * 作者：赵士淞
 * 时间：2024/06/27
 */
// ignore: must_be_immutable
class PlanManagementPage extends StatefulWidget {
  int currentMenuIndex;
  PlanManagementPage({super.key, required this.currentMenuIndex});

  @override
  State<PlanManagementPage> createState() => _PlanManagementPageState();
}

class _PlanManagementPageState extends State<PlanManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlanManagementBloc>(
      create: (context) {
        return PlanManagementBloc(
          PlanManagementModel(
              rootContext: context, currentMenuIndex: widget.currentMenuIndex),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 183,
                  child: PlanManagementMenu(),
                ),
                Container(
                  width: 926,
                  child: PlanManagementContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
