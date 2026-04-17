import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';

/**
 * 内容：计划管理-内容（详情）
 * 作者：赵士淞
 * 时间：2024/06/28
 */
class PlanManagementContentDetail extends StatefulWidget {
  const PlanManagementContentDetail({super.key});

  @override
  State<PlanManagementContentDetail> createState() =>
      _PlanManagementContentDetailState();
}

class _PlanManagementContentDetailState
    extends State<PlanManagementContentDetail> {
  // 显示变更弹窗
  void showChangeDialog(detailItem) {
    PlanManagementBloc bloc = context.read<PlanManagementBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<PlanManagementBloc>.value(
          value: bloc,
          child: BlocBuilder<PlanManagementBloc, PlanManagementModel>(
            builder: (blocContext, state) {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      width: 560,
                      margin: EdgeInsets.only(
                        top: 100,
                      ),
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(240, 250, 250, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailItem['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          dialogIndexZeroContent(state),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onPanDown: (details) {
                                  // 关闭变更弹窗事件
                                  context
                                      .read<PlanManagementBloc>()
                                      .add(CloseChangeDialogEvent(blocContext));
                                },
                                child: Container(
                                  height: 36,
                                  constraints: BoxConstraints(
                                    minWidth: 144,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  child: Center(
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .account_profile_cancel,
                                      style: TextStyle(
                                        color: Color.fromRGBO(44, 167, 176, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (detailItem['index'] ==
                                      Config.NUMBER_ZERO) {
                                    // 变更方案名称事件
                                    context.read<PlanManagementBloc>().add(
                                          ChangePlanEvent(dialogContext,
                                              detailItem['itemName']),
                                        );
                                  } else {
                                    // 半角数字check
                                    if (context
                                                .read<PlanManagementBloc>()
                                                .state
                                                .dialogTempValue !=
                                            '' &&
                                        CheckUtils.check_Half_Number(context
                                            .read<PlanManagementBloc>()
                                            .state
                                            .dialogTempValue)) {
                                      // 消息提示
                                      WMSCommonBlocUtils.tipTextToast(
                                          detailItem['title'] +
                                              WMSLocalizations.i18n(context)!
                                                  .check_half_width_numbers);
                                    } else {
                                      // 变更其他字段事件
                                      context.read<PlanManagementBloc>().add(
                                            ChangePlanEvent(dialogContext,
                                                detailItem['itemName']),
                                          );
                                    }
                                  }
                                },
                                child: Container(
                                  height: 36,
                                  constraints: BoxConstraints(
                                    minWidth: 144,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                  margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                  child: Center(
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .instruction_input_tab_button_update,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget dialogIndexZeroContent(PlanManagementModel state) {
    return Material(
      color: Color.fromRGBO(240, 250, 250, 1),
      child: Container(
        margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: WMSInputboxWidget(
          text: state.dialogTempValue,
          height: 52,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          inputBoxCallBack: (value) {
            // 设置弹窗临时值事件
            context
                .read<PlanManagementBloc>()
                .add(SetDialogTempValueEvent(value));
          },
        ),
      ),
    );
  }

  // 初始化详细列表
  List<Widget> _initDetailList(List detailItemList) {
    // 详细列表
    List<Widget> detailList = [];

    // 循环详细列表
    for (int i = 0; i < detailItemList.length; i++) {
      // 详细列表
      detailList.add(
        Container(
          margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      detailItemList[i]['icon'],
                      width: 44,
                      height: 44,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailItemList[i]['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(6, 14, 15, 1),
                              height: 1.12,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            constraints: BoxConstraints(
                              maxWidth: 300,
                            ),
                            child: Text(
                              detailItemList[i]['content'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(6, 14, 15, 1),
                                height: 1.28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 0,
                  child: Visibility(
                    visible: detailItemList[i]['button'],
                    maintainState: true,
                    child: GestureDetector(
                      onPanDown: (details) {
                        // 显示变更弹窗
                        showChangeDialog(detailItemList[i]);
                      },
                      child: Text(
                        WMSLocalizations.i18n(context)!.account_profile_edit,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 122, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return detailList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanManagementBloc, PlanManagementModel>(
      builder: (context, state) {
        // 详细单个列表
        List _detailItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_PLAN,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_21,
            'content':
                context.read<PlanManagementBloc>().state.selectPlanIndex == -1
                    ? ''
                    : context
                        .read<PlanManagementBloc>()
                        .state
                        .selectPlan['plan_name']
                        .toString(),
            'button': true,
            'itemName': 'plan_name'
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_15 + "（G）",
            'content':
                context.read<PlanManagementBloc>().state.selectPlanIndex == -1
                    ? ''
                    : context
                                .read<PlanManagementBloc>()
                                .state
                                .selectPlan['db_capacity'] ==
                            null
                        ? ''
                        : context
                            .read<PlanManagementBloc>()
                            .state
                            .selectPlan['db_capacity']
                            .toString(),
            'button': true,
            'itemName': 'db_capacity'
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_16 + "（G）",
            'content':
                context.read<PlanManagementBloc>().state.selectPlanIndex == -1
                    ? ''
                    : context
                                .read<PlanManagementBloc>()
                                .state
                                .selectPlan['storage'] ==
                            null
                        ? ''
                        : context
                            .read<PlanManagementBloc>()
                            .state
                            .selectPlan['storage']
                            .toString(),
            'button': true,
            'itemName': 'storage'
          },
          {
            'index': Config.NUMBER_THREE,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_17 + "（G）",
            'content':
                context.read<PlanManagementBloc>().state.selectPlanIndex == -1
                    ? ''
                    : context
                                .read<PlanManagementBloc>()
                                .state
                                .selectPlan['db_dl'] ==
                            null
                        ? ''
                        : context
                            .read<PlanManagementBloc>()
                            .state
                            .selectPlan['db_dl']
                            .toString(),
            'button': true,
            'itemName': 'db_dl'
          },
          {
            'index': Config.NUMBER_FOUR,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_18 + "（G）",
            'content':
                context.read<PlanManagementBloc>().state.selectPlanIndex == -1
                    ? ''
                    : context
                                .read<PlanManagementBloc>()
                                .state
                                .selectPlan['storage_dl'] ==
                            null
                        ? ''
                        : context
                            .read<PlanManagementBloc>()
                            .state
                            .selectPlan['storage_dl']
                            .toString(),
            'button': true,
            'itemName': 'storage_dl'
          },
          {
            'index': Config.NUMBER_FIVE,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_22 + "（円）",
            'content':
                context.read<PlanManagementBloc>().state.selectPlanIndex == -1
                    ? ''
                    : context
                        .read<PlanManagementBloc>()
                        .state
                        .selectPlan['plan_amount']
                        .toString(),
            'button': true,
            'itemName': 'plan_amount'
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                WMSLocalizations.i18n(context)!.plan_menu_text_2,
                style: TextStyle(
                  color: Color.fromRGBO(44, 167, 176, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 560,
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(102, 199, 206, 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: _initDetailList(_detailItemList),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
