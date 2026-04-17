import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/corporate_management_bloc.dart';
import '../bloc/corporate_management_model.dart';

/**
 * 内容：法人管理-契約内容の確認-Tab
 * 作者：赵士淞
 * 时间：2024/07/01
 */
// 当前Tab悬停下标
int currentTabHoverIndex = Config.NUMBER_NEGATIVE;

class CorporateManagementContentConfirmTab extends StatefulWidget {
  const CorporateManagementContentConfirmTab({super.key});

  @override
  State<CorporateManagementContentConfirmTab> createState() =>
      _CorporateManagementContentConfirmTabState();
}

class _CorporateManagementContentConfirmTabState
    extends State<CorporateManagementContentConfirmTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
      builder: (context, state) {
        return Column(
          children: [
            CorporateManagementContentConfirmTabMenu(),
            CorporateManagementContentConfirmTabContent(),
          ],
        );
      },
    );
  }
}

class CorporateManagementContentConfirmTabMenu extends StatefulWidget {
  const CorporateManagementContentConfirmTabMenu({super.key});

  @override
  State<CorporateManagementContentConfirmTabMenu> createState() =>
      _CorporateManagementContentConfirmTabMenuState();
}

class _CorporateManagementContentConfirmTabMenuState
    extends State<CorporateManagementContentConfirmTabMenu> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前Tab悬停下标
              currentTabHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前Tab悬停下标
              currentTabHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 设置当前标签下标事件
              context
                  .read<CorporateManagementBloc>()
                  .add(SetCurrentTabIndexEvent(tabItemList[i]['index']));
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: context
                            .read<CorporateManagementBloc>()
                            .state
                            .currentTabIndex ==
                        tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentTabHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 160,
              ),
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context
                              .read<CorporateManagementBloc>()
                              .state
                              .currentTabIndex ==
                          tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentTabHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.corporate_management_tab_1,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.corporate_management_tab_2,
      },
    ];
    return BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList),
        );
      },
    );
  }
}

class CorporateManagementContentConfirmTabContent extends StatefulWidget {
  const CorporateManagementContentConfirmTabContent({super.key});

  @override
  State<CorporateManagementContentConfirmTabContent> createState() =>
      _CorporateManagementContentConfirmTabContentState();
}

class _CorporateManagementContentConfirmTabContentState
    extends State<CorporateManagementContentConfirmTabContent> {
  // 初始化用户
  Widget _initUserList0(dynamic user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          WMSICons.PLAN_ICON,
          width: 30,
          height: 30,
        ),
        Text(
          user['company_name'],
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
        Text(
          user['user_email'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
        Text(
          (user['postal_cd'] != null ? ('〒' + user['postal_cd'] + ' ') : '') +
              (user['addr_1'] != null ? user['addr_1'] : '') +
              (user['addr_2'] != null ? user['addr_2'] : '') +
              (user['addr_3'] != null ? user['addr_3'] : ''),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
      ],
    );
  }

  Widget _initUserList1(dynamic applicationTmp) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          WMSICons.PLAN_ICON,
          width: 30,
          height: 30,
        ),
        Text(
          applicationTmp['company_name'],
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
        Text(
          applicationTmp['user_email'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
        Text(
          '',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
      ],
    );
  }

  // 初始化计划
  List<Widget> _initPlanList() {
    // 计划列表
    List<Widget> planList = [];

    planList.add(
      Container(
        width: 232,
        height: 192,
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
        margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 2,
            color: Color.fromRGBO(192, 192, 192, 0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              WMSLocalizations.i18n(context)!.corporate_management_text_3,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                context
                    .read<CorporateManagementBloc>()
                    .state
                    .role2UserNumber
                    .toString(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
            Text(
              WMSLocalizations.i18n(context)!.plan_content_text_9 +
                  ' : ' +
                  WMSLocalizations.i18n(context)!.plan_content_text_7_1 +
                  context
                      .read<CorporateManagementBloc>()
                      .state
                      .role2UserMaxNumber
                      .toString() +
                  WMSLocalizations.i18n(context)!.plan_content_text_7_2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(156, 156, 156, 1),
              ),
            ),
            GestureDetector(
              onPanDown: (details) {
                // 判断是否达到上限
                if (context
                        .read<CorporateManagementBloc>()
                        .state
                        .role2UserNumber >=
                    context
                        .read<CorporateManagementBloc>()
                        .state
                        .role2UserMaxNumber) {
                  // 消息提示
                  WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(context)!.plan_content_text_25);
                  return;
                }
                // 显示变更弹窗
                showChangeDialog({
                  'index': Config.NUMBER_NINE,
                  'title': WMSLocalizations.i18n(context)!.plan_content_text_23
                });
              },
              child: Text(
                WMSLocalizations.i18n(context)!.plan_button_text_4,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 122, 255, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    planList.add(
      Container(
        width: 232,
        height: 192,
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              WMSLocalizations.i18n(context)!.corporate_management_text_4,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                context
                    .read<CorporateManagementBloc>()
                    .state
                    .spaceUsageNumber
                    .toString(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
            Text(
              WMSLocalizations.i18n(context)!.plan_content_text_2 +
                  ' : ' +
                  WMSLocalizations.i18n(context)!.plan_content_text_8_1 +
                  context
                      .read<CorporateManagementBloc>()
                      .state
                      .spaceMaxNumber
                      .toString() +
                  WMSLocalizations.i18n(context)!.plan_content_text_8_2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(156, 156, 156, 1),
              ),
            ),
          ],
        ),
      ),
    );

    planList.add(
      Container(
        width: 232,
        height: 192,
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              WMSLocalizations.i18n(context)!.corporate_management_text_5,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(
                context
                    .read<CorporateManagementBloc>()
                    .state
                    .role3UserNumber
                    .toString(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
            Text(
              WMSLocalizations.i18n(context)!.corporate_management_text_5_1 +
                  ' : ' +
                  WMSLocalizations.i18n(context)!.plan_content_text_7_1 +
                  context
                      .read<CorporateManagementBloc>()
                      .state
                      .role3UserMaxNumber
                      .toString() +
                  WMSLocalizations.i18n(context)!.plan_content_text_7_2,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(156, 156, 156, 1),
              ),
            ),
            GestureDetector(
              onPanDown: (details) {
                // 判断是否达到上限
                if (context
                        .read<CorporateManagementBloc>()
                        .state
                        .role3UserNumber >=
                    context
                        .read<CorporateManagementBloc>()
                        .state
                        .role3UserMaxNumber) {
                  // 消息提示
                  WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(context)!.plan_content_text_25);
                  return;
                }
                // 显示变更弹窗
                showChangeDialog({
                  'index': Config.NUMBER_EIGHT,
                  'title': WMSLocalizations.i18n(context)!.plan_content_text_24
                });
              },
              child: Text(
                WMSLocalizations.i18n(context)!.corporate_management_button_2,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(0, 122, 255, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return planList;
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
                              maxWidth: 197,
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

  // 显示变更弹窗
  void showChangeDialog(detailItem) {
    CorporateManagementBloc bloc = context.read<CorporateManagementBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<CorporateManagementBloc>.value(
          value: bloc,
          child: BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
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
                          detailItem['index'] == Config.NUMBER_ZERO
                              ? dialogIndexZeroContent(state)
                              : detailItem['index'] == Config.NUMBER_ONE
                                  ? dialogIndexOneContent(state)
                                  : detailItem['index'] == Config.NUMBER_NINE ||
                                          detailItem['index'] ==
                                              Config.NUMBER_EIGHT
                                      ? dialogIndexNineContent(state)
                                      : Material(
                                          color:
                                              Color.fromRGBO(240, 250, 250, 1),
                                          child: Container(),
                                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onPanDown: (details) {
                                  // 关闭变更弹窗事件
                                  context
                                      .read<CorporateManagementBloc>()
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
                                    // 变更注册名称事件
                                    context.read<CorporateManagementBloc>().add(
                                          ChangeLoginNameEvent(dialogContext),
                                        );
                                  } else if (detailItem['index'] ==
                                      Config.NUMBER_ONE) {
                                    // 变更地址事件
                                    context.read<CorporateManagementBloc>().add(
                                          ChangeAddressEvent(dialogContext),
                                        );
                                  } else if (detailItem['index'] ==
                                      Config.NUMBER_NINE) {
                                    // 添加用户事件
                                    context
                                        .read<CorporateManagementBloc>()
                                        .add(AddUserEvent(dialogContext));
                                  } else if (detailItem['index'] ==
                                      Config.NUMBER_EIGHT) {
                                    // 添加帐户事件
                                    context
                                        .read<CorporateManagementBloc>()
                                        .add(AddAccountEvent(dialogContext));
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
                                          .account_profile_registration,
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

  Widget dialogIndexZeroContent(CorporateManagementModel state) {
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
          text: state.dialogTempValue1,
          height: 52,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          inputBoxCallBack: (value) {
            // 设置弹窗临时值事件
            context
                .read<CorporateManagementBloc>()
                .add(SetDialogTempValue1Event(value));
          },
        ),
      ),
    );
  }

  Widget dialogIndexOneContent(CorporateManagementModel state) {
    return Material(
      color: Color.fromRGBO(240, 250, 250, 1),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: WMSInputboxWidget(
              text: state.dialogTempValue1,
              height: 52,
              borderColor: Color.fromRGBO(255, 255, 255, 1),
              hintText:
                  WMSLocalizations.i18n(context)!.delivery_form_prefecture,
              hintFontColor: Color.fromRGBO(156, 156, 156, 1),
              inputBoxCallBack: (value) {
                // 设置弹窗临时值事件
                context
                    .read<CorporateManagementBloc>()
                    .add(SetDialogTempValue1Event(value));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: WMSInputboxWidget(
              text: state.dialogTempValue2,
              height: 52,
              borderColor: Color.fromRGBO(255, 255, 255, 1),
              hintText: WMSLocalizations.i18n(context)!.delivery_form_municipal,
              hintFontColor: Color.fromRGBO(156, 156, 156, 1),
              inputBoxCallBack: (value) {
                // 设置弹窗临时值事件
                context
                    .read<CorporateManagementBloc>()
                    .add(SetDialogTempValue2Event(value));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: WMSInputboxWidget(
              text: state.dialogTempValue3,
              height: 52,
              borderColor: Color.fromRGBO(255, 255, 255, 1),
              hintText: WMSLocalizations.i18n(context)!.delivery_form_address,
              hintFontColor: Color.fromRGBO(156, 156, 156, 1),
              inputBoxCallBack: (value) {
                // 设置弹窗临时值事件
                context
                    .read<CorporateManagementBloc>()
                    .add(SetDialogTempValue3Event(value));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dialogIndexNineContent(CorporateManagementModel state) {
    return Material(
      color: Color.fromRGBO(240, 250, 250, 1),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: WMSInputboxWidget(
              text: state.dialogTempValue1,
              height: 52,
              borderColor: Color.fromRGBO(255, 255, 255, 1),
              hintText:
                  WMSLocalizations.i18n(context)!.app_cceptance_user_email,
              hintFontColor: Color.fromRGBO(156, 156, 156, 1),
              inputBoxCallBack: (value) {
                // 设置弹窗临时值事件（电子邮件地址）
                context
                    .read<CorporateManagementBloc>()
                    .add(SetDialogTempValue1EmailAddressEvent(value));
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: WMSInputboxWidget(
              text: state.dialogTempValue2,
              height: 52,
              borderColor: Color.fromRGBO(255, 255, 255, 1),
              hintText: WMSLocalizations.i18n(context)!.account_profile_user,
              hintFontColor: Color.fromRGBO(156, 156, 156, 1),
              inputBoxCallBack: (value) {
                // 设置弹窗临时值事件
                context
                    .read<CorporateManagementBloc>()
                    .add(SetDialogTempValue2Event(value));
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
      builder: (context, state) {
        // 详细单个列表
        List _detailItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.account_profile_user,
            'content': context
                        .read<CorporateManagementBloc>()
                        .state
                        .currentTabIndex ==
                    Config.NUMBER_ZERO
                ? context.read<CorporateManagementBloc>().state.userList[context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['user_name'] !=
                        null
                    ? context.read<CorporateManagementBloc>().state.userList[
                        context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['user_name']
                    : ''
                : context
                            .read<CorporateManagementBloc>()
                            .state
                            .applicationTmpData['user_name'] !=
                        null
                    ? context
                        .read<CorporateManagementBloc>()
                        .state
                        .applicationTmpData['user_name']
                    : '',
            'button':
                context.read<CorporateManagementBloc>().state.currentTabIndex ==
                        Config.NUMBER_ZERO
                    ? true
                    : false,
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_ADDRESS,
            'title': WMSLocalizations.i18n(context)!.delivery_form_address,
            'content': context.read<CorporateManagementBloc>().state.currentTabIndex == Config.NUMBER_ZERO
                ? (context.read<CorporateManagementBloc>().state.userList[context.read<CorporateManagementBloc>().state.selectUserIndex]['addr_1'] != null
                        ? context
                                .read<CorporateManagementBloc>()
                                .state
                                .userList[context.read<CorporateManagementBloc>().state.selectUserIndex]
                            ['addr_1']
                        : '') +
                    (context.read<CorporateManagementBloc>().state.userList[context.read<CorporateManagementBloc>().state.selectUserIndex]['addr_2'] != null
                        ? context
                                .read<CorporateManagementBloc>()
                                .state
                                .userList[context.read<CorporateManagementBloc>().state.selectUserIndex]
                            ['addr_2']
                        : '') +
                    (context
                                    .read<CorporateManagementBloc>()
                                    .state
                                    .userList[context.read<CorporateManagementBloc>().state.selectUserIndex]
                                ['addr_3'] !=
                            null
                        ? context
                            .read<CorporateManagementBloc>()
                            .state
                            .userList[context.read<CorporateManagementBloc>().state.selectUserIndex]['addr_3']
                        : '')
                : '',
            'button':
                context.read<CorporateManagementBloc>().state.currentTabIndex ==
                        Config.NUMBER_ZERO
                    ? true
                    : false,
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_PLAN,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_11,
            'content': context
                        .read<CorporateManagementBloc>()
                        .state
                        .currentTabIndex ==
                    Config.NUMBER_ZERO
                ? context.read<CorporateManagementBloc>().state.userList[context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['plan_name'] !=
                        null
                    ? context.read<CorporateManagementBloc>().state.userList[
                        context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['plan_name']
                    : ''
                : context
                            .read<CorporateManagementBloc>()
                            .state
                            .applicationTmpData['plan_name'] !=
                        null
                    ? context
                        .read<CorporateManagementBloc>()
                        .state
                        .applicationTmpData['plan_name']
                    : '',
            'button': false,
          },
          {
            'index': Config.NUMBER_FOUR,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_DATE,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_13,
            'content': context
                        .read<CorporateManagementBloc>()
                        .state
                        .currentTabIndex ==
                    Config.NUMBER_ZERO
                ? context.read<CorporateManagementBloc>().state.userList[context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['start_date'] !=
                        null
                    ? context
                        .read<CorporateManagementBloc>()
                        .state
                        .userList[context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['start_date']
                        .toString()
                        .substring(0, 10)
                    : ''
                : '',
            'button': false,
          },
          {
            'index': Config.NUMBER_FIVE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_DATE,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_14,
            'content': context
                        .read<CorporateManagementBloc>()
                        .state
                        .currentTabIndex ==
                    Config.NUMBER_ZERO
                ? context.read<CorporateManagementBloc>().state.userList[context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['next_date'] !=
                        null
                    ? context
                        .read<CorporateManagementBloc>()
                        .state
                        .userList[context
                            .read<CorporateManagementBloc>()
                            .state
                            .selectUserIndex]['next_date']
                        .toString()
                        .substring(0, 10)
                    : ''
                : '',
            'button': false,
          },
        ];

        return Container(
          padding: EdgeInsets.all(43),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
            ),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Text(
                  WMSLocalizations.i18n(context)!.corporate_management_text_1,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              context.read<CorporateManagementBloc>().state.currentTabIndex ==
                      Config.NUMBER_ZERO
                  ? _initUserList0(
                      context.read<CorporateManagementBloc>().state.userList[
                          context
                              .read<CorporateManagementBloc>()
                              .state
                              .selectUserIndex])
                  : _initUserList1(context
                      .read<CorporateManagementBloc>()
                      .state
                      .applicationTmpData),
              Container(
                margin: EdgeInsets.fromLTRB(0, 35, 0, 34),
                child: Text(
                  WMSLocalizations.i18n(context)!.corporate_management_text_2,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              context.read<CorporateManagementBloc>().state.currentTabIndex ==
                      Config.NUMBER_ZERO
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _initPlanList(),
                    )
                  : Container(),
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
          ),
        );
      },
    );
  }
}
