import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../home/bloc/home_menu_bloc.dart';
import '../../../home/bloc/home_menu_model.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-内容计划-表单
 * 作者：赵士淞
 * 时间：2025/01/10
 */
class AccountContentPlanForm extends StatefulWidget {
  const AccountContentPlanForm({super.key});

  @override
  State<AccountContentPlanForm> createState() => _AccountContentPlanFormState();
}

class _AccountContentPlanFormState extends State<AccountContentPlanForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) {
        return AccountBloc(
          AccountModel(
            rootContext: context,
          ),
        );
      },
      child: BlocBuilder<AccountBloc, AccountModel>(
        builder: (context, state) {
          // 判断切换标记
          if (state.switchFlag) {
            // 切换标记
            state.switchFlag = false;
            // 保存位置标记和位置下标
            context.read<AccountBloc>().add(
                SaveLocationFlagAndLocationIndexEvent(
                    false, Config.NUMBER_ZERO));
          }

          return Scaffold(
            backgroundColor: Color.fromRGBO(102, 199, 206, 0.1),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: AccountContentPlanFormContent(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AccountContentPlanFormContent extends StatefulWidget {
  const AccountContentPlanFormContent({super.key});

  @override
  State<AccountContentPlanFormContent> createState() =>
      _AccountContentPlanFormContentState();
}

class _AccountContentPlanFormContentState
    extends State<AccountContentPlanFormContent> {
  // 初始化计划
  List<Widget> _initPlanList() {
    // 计划列表
    List<Widget> planList = [];

    planList.add(
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                  context.read<AccountBloc>().state.role2UserNumber.toString(),
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
                        .read<AccountBloc>()
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
                  if (context.read<AccountBloc>().state.role2UserNumber >=
                      context.read<AccountBloc>().state.role2UserMaxNumber) {
                    // 消息提示
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!.plan_content_text_25);
                    return;
                  }
                  // 显示变更弹窗
                  showChangeDialog({
                    'index': Config.NUMBER_NINE,
                    'title':
                        WMSLocalizations.i18n(context)!.plan_content_text_23
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
      ),
    );

    planList.add(
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                  context.read<AccountBloc>().state.spaceUsageNumber.toString(),
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
                        .read<AccountBloc>()
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
      ),
    );

    planList.add(
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                  context.read<AccountBloc>().state.role3UserNumber.toString(),
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
                        .read<AccountBloc>()
                        .state
                        .planData['account_num']
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
                  if (context.read<AccountBloc>().state.role3UserNumber >=
                      context
                          .read<AccountBloc>()
                          .state
                          .planData['account_num']) {
                    // 消息提示
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!.plan_content_text_25);
                    return;
                  }
                  // 显示变更弹窗
                  showChangeDialog({
                    'index': Config.NUMBER_EIGHT,
                    'title':
                        WMSLocalizations.i18n(context)!.plan_content_text_24
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
      ),
    );

    return planList;
  }

  // 显示变更弹窗
  void showChangeDialog(detailItem) {
    AccountBloc bloc = context.read<AccountBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<AccountBloc>.value(
          value: bloc,
          child: BlocBuilder<AccountBloc, AccountModel>(
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
                                      .read<AccountBloc>()
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
                                    context.read<AccountBloc>().add(
                                          ChangeLoginNameEvent(dialogContext),
                                        );
                                  } else if (detailItem['index'] ==
                                      Config.NUMBER_ONE) {
                                    // 变更地址事件
                                    context.read<AccountBloc>().add(
                                          ChangeAddressEvent(dialogContext),
                                        );
                                  } else if (detailItem['index'] ==
                                      Config.NUMBER_NINE) {
                                    // 添加用户事件
                                    context
                                        .read<AccountBloc>()
                                        .add(AddUserEvent(dialogContext));
                                  } else if (detailItem['index'] ==
                                      Config.NUMBER_EIGHT) {
                                    // 添加帐户事件
                                    context
                                        .read<AccountBloc>()
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

  Widget dialogIndexZeroContent(AccountModel state) {
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
            context.read<AccountBloc>().add(SetDialogTempValue1Event(value));
          },
        ),
      ),
    );
  }

  Widget dialogIndexOneContent(AccountModel state) {
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
                    .read<AccountBloc>()
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
                    .read<AccountBloc>()
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
                    .read<AccountBloc>()
                    .add(SetDialogTempValue3Event(value));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dialogIndexNineContent(AccountModel state) {
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
                    .read<AccountBloc>()
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
                    .read<AccountBloc>()
                    .add(SetDialogTempValue2Event(value));
              },
            ),
          ),
        ],
      ),
    );
  }

  // 初始化详细列表
  List<Widget> _initDetailList(AccountModel state, List detailItemList) {
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

    // 详细列表
    detailList.add(
      Visibility(
        visible: state.userCustomize['id'] == state.planData['user_id'],
        child: Container(
          margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onPanDown: (details) {
              // 跳转页面
              context.read<HomeMenuBloc>().add(PageJumpEvent(
                  '/' + Config.PAGE_FLAG_50_1 + '/plan/cancelDetail'));
            },
            child: Text(
              WMSLocalizations.i18n(context)!.account_cancel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 122, 255, 1),
              ),
            ),
          ),
        ),
      ),
    );

    return detailList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 详细单个列表
        List _detailItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.account_profile_user,
            'content': state.userCustomize['name'] != null
                ? state.userCustomize['name']
                : '',
            'button': true,
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_ADDRESS,
            'title': WMSLocalizations.i18n(context)!.delivery_form_address,
            'content': (state.planData['addr_1'] != null
                    ? state.planData['addr_1']
                    : '') +
                (state.planData['addr_2'] != null
                    ? state.planData['addr_2']
                    : '') +
                (state.planData['addr_3'] != null
                    ? state.planData['addr_3']
                    : ''),
            'button': true,
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_PLAN,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_11,
            'content': state.planData['plan_name'] != null
                ? state.planData['plan_name']
                : '',
            'button': false,
          },
          {
            'index': Config.NUMBER_FOUR,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_DATE,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_13,
            'content': state.planData['start_date'] != null
                ? state.planData['start_date'].toString().substring(0, 10)
                : '',
            'button': false,
          },
          {
            'index': Config.NUMBER_FIVE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_DATE,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_14,
            'content': state.planData['next_date'] != null
                ? state.planData['next_date'].toString().substring(0, 10)
                : '',
            'button': false,
          },
        ];

        return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
          builder: (menuBloc, menuState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: _initPlanList(),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Column(
                    children: _initDetailList(state, _detailItemList),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
