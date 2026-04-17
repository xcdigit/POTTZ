import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/widget/wms_dialog_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';

/**
 * 内容：计划管理-内容（增加）
 * 作者：赵士淞
 * 时间：2024/06/27
 */
class PlanManagementContentAdd extends StatefulWidget {
  const PlanManagementContentAdd({super.key});

  @override
  State<PlanManagementContentAdd> createState() =>
      _PlanManagementContentAddState();
}

class _PlanManagementContentAddState extends State<PlanManagementContentAdd> {
  // 删除弹窗
  _deleteDialog() {
    PlanManagementBloc bloc = context.read<PlanManagementBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<PlanManagementBloc>.value(
          value: bloc,
          child: BlocBuilder<PlanManagementBloc, PlanManagementModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: bloc.state.selectPlanName +
                    WMSLocalizations.i18n(context)!.display_instruction_delete,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 删除计划事件
                  context.read<PlanManagementBloc>().add(DeletePlanEvent());
                  // 关闭弹窗
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  // 初始化计划列表
  List<Widget> _initPlanList(List planItemList) {
    // 计划列表
    List<Widget> planList = [];

    // 循环计划列表
    for (int i = 0; i < planItemList.length; i++) {
      // 计划列表
      planList.add(
        GestureDetector(
          onPanDown: (details) {
            // 设置选中计划下标事件
            context.read<PlanManagementBloc>().add(
                  SetSelectPlanIndexEvent(planItemList[i]['id'],
                      planItemList[i]['plan_name'].toString()),
                );
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click, // 设置鼠标悬停时的光标样式为手形
            child: Container(
              width: 200,
              height: 200,
              padding: EdgeInsets.fromLTRB(34, 34, 34, 0),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 2,
                  color: context
                              .read<PlanManagementBloc>()
                              .state
                              .selectPlanIndex ==
                          planItemList[i]['id']
                      ? Color.fromRGBO(0, 0, 0, 1)
                      : Color.fromRGBO(192, 192, 192, 0.5),
                ),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Text(
                      planItemList[i]['plan_name'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (planItemList[i]['db_capacity'] != null &&
                      planItemList[i]['db_capacity'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_15 +
                          ':' +
                          planItemList[i]['db_capacity'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['storage'] != null &&
                      planItemList[i]['storage'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_16 +
                          ':' +
                          planItemList[i]['storage'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['db_dl'] != null &&
                      planItemList[i]['db_dl'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_17 +
                          ':' +
                          planItemList[i]['db_dl'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['storage_dl'] != null &&
                      planItemList[i]['storage_dl'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_18 +
                          ':' +
                          planItemList[i]['storage_dl'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['plan_amount'] != null &&
                      planItemList[i]['plan_amount'].toString().isNotEmpty)
                    Text(
                      planItemList[i]['plan_amount'].toString() +
                          WMSLocalizations.i18n(context)!.plan_content_text_19,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 计划列表
    planList.add(
      GestureDetector(
        onPanDown: (details) {
          // 详细计划事件
          context.read<PlanManagementBloc>().add(
                DetailPlanEvent(Config.NUMBER_NEGATIVE, {}),
              );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click, // 设置鼠标悬停时的光标样式为手形
          child: Container(
            width: 200,
            height: 200,
            padding: EdgeInsets.fromLTRB(34, 34, 34, 0),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 2,
                color: Color.fromRGBO(192, 192, 192, 0.5),
              ),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                  child: Text(
                    WMSLocalizations.i18n(context)!.plan_button_text_2,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '＋',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return planList;
  }

  // 循环按钮列表
  List<Widget> _initButtonList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];

    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 36,
          margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: buttonItemList[i]['index'] == Config.NUMBER_ZERO
                  ? MaterialStatePropertyAll(
                      Color.fromRGBO(255, 255, 255, 1),
                    )
                  : MaterialStatePropertyAll(
                      Color.fromRGBO(44, 167, 176, 1),
                    ),
              minimumSize: MaterialStatePropertyAll(
                Size(120, 36),
              ),
            ),
            onPressed: () {
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                if (context.read<PlanManagementBloc>().state.selectPlanIndex ==
                    -1) {
                  // 错误提示
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(context)!
                          .Inventory_Confirmed_tip_1);
                } else {
                  // 删除弹窗
                  _deleteDialog();
                }
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 详细计划事件
                context.read<PlanManagementBloc>().add(
                      DetailPlanEvent(Config.NUMBER_NEGATIVE, {}),
                    );
              }
            },
            child: Text(
              buttonItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: buttonItemList[i]['index'] == Config.NUMBER_ZERO
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        ),
      );
    }

    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanManagementBloc, PlanManagementModel>(
      builder: (context, state) {
        // 按钮单个列表
        List _buttonItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.plan_button_text_1,
          },
          {
            'index': Config.NUMBER_ONE,
            'title': WMSLocalizations.i18n(context)!.plan_button_text_2,
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                WMSLocalizations.i18n(context)!.plan_menu_text_1,
                style: TextStyle(
                  color: Color.fromRGBO(44, 167, 176, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 83,
              children: _initPlanList(state.planList),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _initButtonList(_buttonItemList),
            ),
          ],
        );
      },
    );
  }
}
