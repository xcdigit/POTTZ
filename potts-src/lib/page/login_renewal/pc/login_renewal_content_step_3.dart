import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../common/utils/format_utils.dart';
import '../../../widget/wms_inputbox_widget.dart';
import '../bloc/login_renewal_bloc.dart';
import '../bloc/login_renewal_model.dart';

/**
 * 内容：续费-内容-步骤3
 * 作者：赵士淞
 * 时间：2025/01/13
 */
class LoginRenewalContentStep3 extends StatefulWidget {
  const LoginRenewalContentStep3({super.key});

  @override
  State<LoginRenewalContentStep3> createState() =>
      _LoginRenewalContentStep3State();
}

class _LoginRenewalContentStep3State extends State<LoginRenewalContentStep3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 续费内容步骤3表单
        LoginRenewalContentStep3Form(),
        // 续费内容步骤3文本
        LoginRenewalContentStep3Text(),
      ],
    );
  }
}

// 续费内容步骤3表单
class LoginRenewalContentStep3Form extends StatefulWidget {
  const LoginRenewalContentStep3Form({super.key});

  @override
  State<LoginRenewalContentStep3Form> createState() =>
      _LoginRenewalContentStep3FormState();
}

class _LoginRenewalContentStep3FormState
    extends State<LoginRenewalContentStep3Form> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(231, 244, 246, 1),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Column(
        children: [
          // 续费内容步骤3表单标题
          LoginRenewalContentStep3FormTitle(),
          // 续费内容步骤3表单内容1
          LoginRenewalContentStep3FormContent1(),
          // 续费内容步骤3表单内容2
          LoginRenewalContentStep3FormContent2(),
          // 续费内容步骤3表单金额
          LoginRenewalContentStep3FormAmount(),
          // 续费内容步骤3表单按钮
          LoginRenewalContentStep3FormButton(),
        ],
      ),
    );
  }
}

// 续费内容步骤3表单标题
class LoginRenewalContentStep3FormTitle extends StatelessWidget {
  const LoginRenewalContentStep3FormTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              'STEPS',
              style: TextStyle(
                color: Color.fromRGBO(44, 167, 176, 1),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              WMSLocalizations.i18n(context)!.login_application_choose_plan,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 32,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 续费内容步骤3表单内容1
class LoginRenewalContentStep3FormContent1 extends StatefulWidget {
  const LoginRenewalContentStep3FormContent1({super.key});

  @override
  State<LoginRenewalContentStep3FormContent1> createState() =>
      _LoginRenewalContentStep3FormContent1State();
}

class _LoginRenewalContentStep3FormContent1State
    extends State<LoginRenewalContentStep3FormContent1> {
  // 初始化按钮部件列表
  List<Widget> _initButtonWidgetList() {
    // 按钮列表
    List<Map<String, dynamic>> buttonList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_required_button_1,
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_required_button_2,
      },
      {
        'index': 3,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_required_button_3,
      },
    ];
    // 按钮部件列表
    List<Widget> buttonWidgetList = [];
    // 循环按钮列表
    for (var i = 0; i < buttonList.length; i++) {
      // 按钮部件列表
      buttonWidgetList.add(
        GestureDetector(
          onTap: () {
            buttonList[i]['index'] == 1
                ? context
                    .read<LoginRenewalBloc>()
                    .add(SelectedShippingChangeEvent())
                : buttonList[i]['index'] == 2
                    ? context
                        .read<LoginRenewalBloc>()
                        .add(SelectedEntryChangeEvent())
                    : buttonList[i]['index'] == 3
                        ? context
                            .read<LoginRenewalBloc>()
                            .add(SelectedInventoryChangeEvent())
                        : null;
          },
          child: Container(
            decoration: BoxDecoration(
              color: (buttonList[i]['index'] == 1 &&
                          context
                              .read<LoginRenewalBloc>()
                              .state
                              .selectedShipping) ||
                      (buttonList[i]['index'] == 2 &&
                          context
                              .read<LoginRenewalBloc>()
                              .state
                              .selectedEntry) ||
                      (buttonList[i]['index'] == 3 &&
                          context
                              .read<LoginRenewalBloc>()
                              .state
                              .selectedInventory)
                  ? Color.fromRGBO(255, 175, 19, 1)
                  : Color.fromRGBO(125, 125, 125, 0.1),
              border: Border.all(
                color: (buttonList[i]['index'] == 1 &&
                            context
                                .read<LoginRenewalBloc>()
                                .state
                                .selectedShipping) ||
                        (buttonList[i]['index'] == 2 &&
                            context
                                .read<LoginRenewalBloc>()
                                .state
                                .selectedEntry) ||
                        (buttonList[i]['index'] == 3 &&
                            context
                                .read<LoginRenewalBloc>()
                                .state
                                .selectedInventory)
                    ? Colors.transparent
                    : Color.fromRGBO(125, 125, 125, 1),
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            width: 125,
            height: 42,
            margin: EdgeInsets.only(
              left: i == 0 ? 0 : 30,
            ),
            child: Center(
              child: Text(
                buttonList[i]['title'],
                style: TextStyle(
                  color: (buttonList[i]['index'] == 1 &&
                              context
                                  .read<LoginRenewalBloc>()
                                  .state
                                  .selectedShipping) ||
                          (buttonList[i]['index'] == 2 &&
                              context
                                  .read<LoginRenewalBloc>()
                                  .state
                                  .selectedEntry) ||
                          (buttonList[i]['index'] == 3 &&
                              context
                                  .read<LoginRenewalBloc>()
                                  .state
                                  .selectedInventory)
                      ? Color.fromRGBO(251, 251, 251, 1)
                      : Color.fromRGBO(125, 125, 125, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return buttonWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 840,
      padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(
        top: 56,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 167, 176, 1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: Center(
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Container(
            width: 712,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_choose_required_text,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_required_text_1,
                    style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_required_text_2,
                    style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 24,
                  ),
                  child: Row(
                    children: _initButtonWidgetList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 续费内容步骤3表单内容2
class LoginRenewalContentStep3FormContent2 extends StatefulWidget {
  const LoginRenewalContentStep3FormContent2({super.key});

  @override
  State<LoginRenewalContentStep3FormContent2> createState() =>
      _LoginRenewalContentStep3FormContent2State();
}

class _LoginRenewalContentStep3FormContent2State
    extends State<LoginRenewalContentStep3FormContent2> {
  // 初始化计划部件列表
  List<Widget> _initPlanWidgetList(LoginRenewalModel state) {
    // 计划部件列表
    List<Widget> planWidgetList = [];
    // 循环计划列表
    for (var i = 0; i < state.planList.length; i++) {
      // 计划部件列表
      planWidgetList.add(
        GestureDetector(
          onTap: () {
            // 选中计划变更事件
            context.read<LoginRenewalBloc>().add(SelectedPlanChangeEvent(
                state.planList[i]['id'], state.planList[i]['plan_amount']));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(174, 174, 174, 1),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            width: 380,
            margin: EdgeInsets.only(
              top: i == 0 ? 0 : 4,
            ),
            child: Column(
              children: [
                Container(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Material(
                              child: Checkbox(
                                value: state.selectedPlanId ==
                                    state.planList[i]['id'],
                                onChanged: (value) {
                                  // 选中计划变更事件
                                  context.read<LoginRenewalBloc>().add(
                                      SelectedPlanChangeEvent(
                                          state.planList[i]['id'],
                                          state.planList[i]['plan_amount']));
                                },
                                activeColor: Color.fromRGBO(255, 175, 19, 1),
                              ),
                            ),
                          ),
                          Text(
                            state.planList[i]['plan_name'].toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        FormatUtils.amountFormat(
                                state.planList[i]['plan_amount']) +
                            '円/月',
                        style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: state.planList[i]['db_capacity'] != null &&
                      state.planList[i]['db_capacity'] != '' &&
                      state.planList[i]['db_dl'] != null &&
                      state.planList[i]['db_dl'] != '' &&
                      state.planList[i]['storage'] != null &&
                      state.planList[i]['storage'] != '' &&
                      state.planList[i]['storage_dl'] != null &&
                      state.planList[i]['storage_dl'] != '',
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color.fromRGBO(239, 239, 239, 1),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '【' +
                              WMSLocalizations.i18n(context)!
                                  .login_application_choose_plan_upper_limit +
                              '】',
                          style: TextStyle(
                            color: Color.fromRGBO(102, 102, 102, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                        .login_application_choose_plan_db_capacity +
                                    '：' +
                                    state.planList[i]['db_capacity']
                                        .toString() +
                                    'G',
                                style: TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                WMSLocalizations.i18n(context)!
                                        .login_application_choose_plan_db_dl +
                                    '：' +
                                    state.planList[i]['db_dl'].toString() +
                                    'G',
                                style: TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                        .login_application_choose_plan_storage +
                                    '：' +
                                    state.planList[i]['storage'].toString() +
                                    'G',
                                style: TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                WMSLocalizations.i18n(context)!
                                        .login_application_choose_plan_storage_dl +
                                    '：' +
                                    state.planList[i]['storage_dl'].toString() +
                                    'G',
                                style: TextStyle(
                                  color: Color.fromRGBO(102, 102, 102, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return planWidgetList;
  }

  // 初始化账户部件列表
  List<Widget> _initAccountWidgetList(LoginRenewalModel state) {
    // 账户列表
    List<Map<String, dynamic>> accountList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_account_option_title_1,
        'amount': 0,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_account_option_text_1,
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_account_option_title_2,
        'amount': 1000,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_account_option_text_2,
      },
    ];
    // 账户部件列表
    List<Widget> accountWidgetList = [];
    // 循环账户列表
    for (var i = 0; i < accountList.length; i++) {
      // 账户部件列表
      accountWidgetList.add(
        GestureDetector(
          onTap: () {
            // 选中账户变更事件
            context.read<LoginRenewalBloc>().add(SelectedAccountChangeEvent(
                accountList[i]['index'], accountList[i]['amount']));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(174, 174, 174, 1),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            width: 380,
            margin: EdgeInsets.only(
              top: i == 0 ? 0 : 4,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(239, 239, 239, 1),
                      ),
                    ),
                  ),
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            padding: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Material(
                              child: Checkbox(
                                value: state.selectedAccountIndex ==
                                    accountList[i]['index'],
                                onChanged: (value) {
                                  // 选中账户变更事件
                                  context.read<LoginRenewalBloc>().add(
                                      SelectedAccountChangeEvent(
                                          accountList[i]['index'],
                                          accountList[i]['amount']));
                                },
                                activeColor: Color.fromRGBO(255, 175, 19, 1),
                              ),
                            ),
                          ),
                          Text(
                            accountList[i]['title'].toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        FormatUtils.amountFormat(accountList[i]['amount']) +
                            '円/月',
                        style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(
                    top: 8,
                  ),
                  child: Text(
                    accountList[i]['text'].toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return accountWidgetList;
  }

  // 初始化补充部件列表
  List<Widget> _initSupplyWidgetList(LoginRenewalModel state) {
    // 补充列表
    List<Map<String, dynamic>> supplyList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_title_1,
        'amount': 0,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_text_1,
        'canChoose': true,
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_title_2,
        'amount': 19800,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_text_2,
        'canChoose': false,
      },
      {
        'index': 3,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_title_3,
        'amount': 29800,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_text_3,
        'canChoose': false,
      },
      {
        'index': 4,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_title_4,
        'amount': 19800,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_supply_option_text_4,
        'canChoose': false,
      },
    ];
    // 补充部件列表
    List<Widget> supplyWidgetList = [];
    // 循环补充列表
    for (var i = 0; i < supplyList.length; i++) {
      // 补充部件列表
      supplyWidgetList.add(
        GestureDetector(
          onTap: () {
            // 判断能否选择
            if (supplyList[i]['canChoose']) {
              // 选中补充变更事件
              context.read<LoginRenewalBloc>().add(SelectedSupplyChangeEvent(
                  supplyList[i]['index'], supplyList[i]['amount']));
            }
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(174, 174, 174, 1),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            width: 380,
            margin: EdgeInsets.only(
              top: i == 0 ? 0 : 4,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(239, 239, 239, 1),
                      ),
                    ),
                  ),
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: supplyList[i]['canChoose'],
                            child: Container(
                              width: 22,
                              height: 22,
                              padding: EdgeInsets.only(
                                right: 10,
                              ),
                              child: Material(
                                child: Checkbox(
                                  value: state.selectedSupplyIndex ==
                                      supplyList[i]['index'],
                                  onChanged: (value) {
                                    // 判断能否选择
                                    if (supplyList[i]['canChoose']) {
                                      // 选中补充变更事件
                                      context.read<LoginRenewalBloc>().add(
                                          SelectedSupplyChangeEvent(
                                              supplyList[i]['index'],
                                              supplyList[i]['amount']));
                                    }
                                  },
                                  activeColor: Color.fromRGBO(255, 175, 19, 1),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            supplyList[i]['title'].toString(),
                            style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        FormatUtils.amountFormat(supplyList[i]['amount']) +
                            '円/月',
                        style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(
                    top: 8,
                  ),
                  child: Text(
                    supplyList[i]['text'].toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color.fromRGBO(102, 102, 102, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return supplyWidgetList;
  }

  // 初始化周期部件列表
  List<Widget> _initCycleWidgetList(LoginRenewalModel state) {
    // 周期列表
    List<Map<String, dynamic>> cycleList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_cycle_month,
        'text': '',
      },
      {
        'index': 2,
        'title':
            WMSLocalizations.i18n(context)!.login_application_choose_cycle_year,
        'text': WMSLocalizations.i18n(context)!
            .login_application_choose_cycle_year_text,
      },
    ];
    // 周期部件列表
    List<Widget> cycleWidgetList = [];
    // 循环周期列表
    for (var i = 0; i < cycleList.length; i++) {
      // 周期部件列表
      cycleWidgetList.add(
        GestureDetector(
          onTap: () {
            // 选中周期变更事件
            context
                .read<LoginRenewalBloc>()
                .add(SelectedCycleChangeEvent(cycleList[i]['index']));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 11, 16, 11),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(174, 174, 174, 1),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            width: 380,
            margin: EdgeInsets.only(
              top: i == 0 ? 0 : 4,
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromRGBO(239, 239, 239, 1),
                      ),
                    ),
                  ),
                  height: 36,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        padding: EdgeInsets.only(
                          right: 10,
                        ),
                        child: Material(
                          child: Checkbox(
                            value: state.selectedCycleIndex ==
                                cycleList[i]['index'],
                            onChanged: (value) {
                              // 选中周期变更事件
                              context.read<LoginRenewalBloc>().add(
                                  SelectedCycleChangeEvent(
                                      cycleList[i]['index']));
                            },
                            activeColor: Color.fromRGBO(255, 175, 19, 1),
                          ),
                        ),
                      ),
                      Text(
                        cycleList[i]['title'].toString(),
                        style: TextStyle(
                          color: Color.fromRGBO(51, 51, 51, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: cycleList[i]['text'] != '',
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(
                      cycleList[i]['text'].toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color.fromRGBO(102, 102, 102, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
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
    return cycleWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 840,
      padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 167, 176, 1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: Center(
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Container(
            width: 712,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_choose_number_accounts,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 24,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_plan_title,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 4,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_plan_text,
                    style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Column(
                    children: _initPlanWidgetList(
                        context.read<LoginRenewalBloc>().state),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 24,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_account_title,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Column(
                    children: _initAccountWidgetList(
                        context.read<LoginRenewalBloc>().state),
                  ),
                ),
                Visibility(
                  visible: context
                          .read<LoginRenewalBloc>()
                          .state
                          .selectedAccountIndex ==
                      2,
                  child: Container(
                    width: 380,
                    margin: EdgeInsets.only(
                      top: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          child: Material(
                            child: WMSInputboxWidget(
                              backgroundColor: Color.fromRGBO(245, 245, 245, 1),
                              borderColor: Colors.transparent,
                              text: context
                                  .read<LoginRenewalBloc>()
                                  .state
                                  .addAccountNumber
                                  .toString(),
                              readOnly: !context
                                  .read<LoginRenewalBloc>()
                                  .state
                                  .canRenewal,
                              inputBoxCallBack: (value) {
                                // 设置添加账户数量事件
                                context
                                    .read<LoginRenewalBloc>()
                                    .add(SetAddAccountNumber(value));
                              },
                            ),
                          ),
                        ),
                        Text(
                          WMSLocalizations.i18n(context)!
                              .login_application_choose_account_input_text,
                          style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 24,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_supply_title,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Column(
                    children: _initSupplyWidgetList(
                        context.read<LoginRenewalBloc>().state),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 24,
                  ),
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_choose_cycle_title,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 16,
                  ),
                  child: Column(
                    children: _initCycleWidgetList(
                        context.read<LoginRenewalBloc>().state),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 续费内容步骤3表单金额
class LoginRenewalContentStep3FormAmount extends StatefulWidget {
  const LoginRenewalContentStep3FormAmount({super.key});

  @override
  State<LoginRenewalContentStep3FormAmount> createState() =>
      _LoginRenewalContentStep3FormAmountState();
}

class _LoginRenewalContentStep3FormAmountState
    extends State<LoginRenewalContentStep3FormAmount> {
  // 初始化金额部件列表
  List<Widget> _initAmountWidgetList(LoginRenewalModel state) {
    // 金额列表
    List<Map<String, dynamic>> amountList = [
      // {
      //   'index': 1,
      //   'title': WMSLocalizations.i18n(context)!
      //       .login_application_choose_amount_initial,
      //   'unit':
      //       WMSLocalizations.i18n(context)!.login_application_choose_amount_tax,
      // },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_module,
        'unit': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_tax_month,
      },
      {
        'index': 3,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_plan,
        'unit': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_tax_month,
      },
      {
        'index': 4,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_account,
        'unit': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_tax_month,
      },
      {
        'index': 5,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_option,
        'unit': WMSLocalizations.i18n(context)!
            .login_application_choose_amount_tax_month,
      },
      {
        'index': 6,
        'title':
            WMSLocalizations.i18n(context)!.login_application_choose_amount_sum,
        'unit':
            WMSLocalizations.i18n(context)!.login_application_choose_amount_tax,
      },
    ];
    // 金额部件列表
    List<Widget> amountWidgetList = [];
    // 循环金额列表
    for (var i = 0; i < amountList.length; i++) {
      // 判断是否是最后一个
      if (i == amountList.length - 1) {
        // 金额部件列表
        amountWidgetList.add(
          FractionallySizedBox(
            widthFactor: .05,
            child: Container(
              margin: EdgeInsets.only(
                top: 32,
              ),
              child: Center(
                child: Text(
                  '=',
                  style: TextStyle(
                    color: Color.fromRGBO(93, 93, 93, 1),
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        );
      }
      // 金额部件列表
      amountWidgetList.add(
        FractionallySizedBox(
          widthFactor: .28,
          child: Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            decoration: BoxDecoration(
              color: amountList[i]['index'] == 6
                  ? context
                              .read<LoginRenewalBloc>()
                              .state
                              .campaignData['promotion_type'] ==
                          '1'
                      ? Color.fromRGBO(102, 102, 102, 1)
                      : Color.fromRGBO(44, 167, 176, 1)
                  : Colors.white,
              border: Border.all(
                color: context
                            .read<LoginRenewalBloc>()
                            .state
                            .campaignData['promotion_type'] ==
                        '1'
                    ? Color.fromRGBO(102, 102, 102, 1)
                    : Color.fromRGBO(44, 167, 176, 1),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(
              top: 32,
            ),
            child: Column(
              children: [
                Text(
                  amountList[i]['title'],
                  style: TextStyle(
                    color: amountList[i]['index'] == 6
                        ? Colors.white
                        : context
                                    .read<LoginRenewalBloc>()
                                    .state
                                    .campaignData['promotion_type'] ==
                                '1'
                            ? Color.fromRGBO(102, 102, 102, 1)
                            : Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            FormatUtils.amountFormat(amountList[i]['index'] == 1
                                ? context
                                    .read<LoginRenewalBloc>()
                                    .state
                                    .totalInitialAmount
                                : amountList[i]['index'] == 2
                                    ? context
                                        .read<LoginRenewalBloc>()
                                        .state
                                        .totalModuleAmount
                                    : amountList[i]['index'] == 3
                                        ? context
                                            .read<LoginRenewalBloc>()
                                            .state
                                            .selectedPlanAmount
                                        : amountList[i]['index'] == 4
                                            ? context
                                                .read<LoginRenewalBloc>()
                                                .state
                                                .totalAccountAmount
                                            : amountList[i]['index'] == 5
                                                ? context
                                                    .read<LoginRenewalBloc>()
                                                    .state
                                                    .selectedSupplyAmount
                                                : amountList[i]['index'] == 6
                                                    ? context
                                                        .read<
                                                            LoginRenewalBloc>()
                                                        .state
                                                        .totalSumAmount
                                                    : 0),
                            style: TextStyle(
                              color: amountList[i]['index'] == 6
                                  ? Colors.white
                                  : context
                                              .read<LoginRenewalBloc>()
                                              .state
                                              .campaignData['promotion_type'] ==
                                          '1'
                                      ? Color.fromRGBO(102, 102, 102, 1)
                                      : Color.fromRGBO(44, 167, 176, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              decoration: context
                                              .read<LoginRenewalBloc>()
                                              .state
                                              .campaignData['promotion_type'] ==
                                          '1' ||
                                      context
                                              .read<LoginRenewalBloc>()
                                              .state
                                              .campaignData['promotion_type'] ==
                                          '0'
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.red,
                              decorationThickness: 3,
                            ),
                          ),
                          Visibility(
                            visible: context
                                    .read<LoginRenewalBloc>()
                                    .state
                                    .campaignData['promotion_type'] ==
                                '0',
                            child: Text(
                              FormatUtils.amountFormat(amountList[i]['index'] ==
                                      1
                                  ? context
                                      .read<LoginRenewalBloc>()
                                      .state
                                      .discountInitialAmount
                                  : amountList[i]['index'] == 2
                                      ? context
                                          .read<LoginRenewalBloc>()
                                          .state
                                          .discountModuleAmount
                                      : amountList[i]['index'] == 3
                                          ? context
                                              .read<LoginRenewalBloc>()
                                              .state
                                              .discountPlanAmount
                                          : amountList[i]['index'] == 4
                                              ? context
                                                  .read<LoginRenewalBloc>()
                                                  .state
                                                  .discountAccountAmount
                                              : amountList[i]['index'] == 5
                                                  ? context
                                                      .read<LoginRenewalBloc>()
                                                      .state
                                                      .discountSupplyAmount
                                                  : amountList[i]['index'] == 6
                                                      ? context
                                                          .read<
                                                              LoginRenewalBloc>()
                                                          .state
                                                          .discountSumAmount
                                                      : 0),
                              style: TextStyle(
                                color: amountList[i]['index'] == 6
                                    ? Colors.white
                                    : context
                                                    .read<LoginRenewalBloc>()
                                                    .state
                                                    .campaignData[
                                                'promotion_type'] ==
                                            '1'
                                        ? Color.fromRGBO(102, 102, 102, 1)
                                        : Color.fromRGBO(44, 167, 176, 1),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        amountList[i]['unit'],
                        style: TextStyle(
                          color: amountList[i]['index'] == 6
                              ? Colors.white
                              : context
                                          .read<LoginRenewalBloc>()
                                          .state
                                          .campaignData['promotion_type'] ==
                                      '1'
                                  ? Color.fromRGBO(102, 102, 102, 1)
                                  : Color.fromRGBO(44, 167, 176, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Visibility(
                        visible: (amountList[i]['index'] == 2 ||
                                amountList[i]['index'] == 5) &&
                            context
                                    .read<LoginRenewalBloc>()
                                    .state
                                    .selectedCycleIndex ==
                                2,
                        child: Text(
                          ' * 12',
                          style: TextStyle(
                            color: context
                                        .read<LoginRenewalBloc>()
                                        .state
                                        .campaignData['promotion_type'] ==
                                    '1'
                                ? Color.fromRGBO(102, 102, 102, 1)
                                : Color.fromRGBO(44, 167, 176, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      // 判断是否是最后一个
      if (i < amountList.length - 2) {
        // 金额部件列表
        amountWidgetList.add(
          FractionallySizedBox(
            widthFactor: .05,
            child: Container(
              margin: EdgeInsets.only(
                top: 32,
              ),
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    color: Color.fromRGBO(93, 93, 93, 1),
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return amountWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 840,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(
        top: 56,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 32,
              left: 24,
              right: 24,
            ),
            child: Text(
              WMSLocalizations.i18n(context)!
                  .login_application_choose_amount_text,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children:
                  _initAmountWidgetList(context.read<LoginRenewalBloc>().state),
            ),
          ),
          Visibility(
            visible: context
                    .read<LoginRenewalBloc>()
                    .state
                    .campaignData['promotion_type'] ==
                '1',
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 175, 19, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              height: 60,
              child: Center(
                child: Text(
                  context
                          .read<LoginRenewalBloc>()
                          .state
                          .campaignData['expiration_day']
                          .toString() +
                      WMSLocalizations.i18n(context)!
                          .login_application_choose_amount_free,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 续费内容步骤3表单按钮
class LoginRenewalContentStep3FormButton extends StatefulWidget {
  const LoginRenewalContentStep3FormButton({super.key});

  @override
  State<LoginRenewalContentStep3FormButton> createState() =>
      _LoginRenewalContentStep3FormButtonState();
}

class _LoginRenewalContentStep3FormButtonState
    extends State<LoginRenewalContentStep3FormButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: EdgeInsets.only(
        top: 56,
        bottom: 80,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // 步骤3按钮点击事件
              context.read<LoginRenewalBloc>().add(Step3ButtonClickEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 56,
              child: Center(
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_step_button_1,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // 选中交易法变更事件
              context
                  .read<LoginRenewalBloc>()
                  .add(SelectedExchangeActChangeEvent());
            },
            child: Container(
              margin: EdgeInsets.only(
                top: 37,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: EdgeInsets.only(
                      right: 8,
                    ),
                    child: Material(
                      child: Checkbox(
                        value: context
                            .read<LoginRenewalBloc>()
                            .state
                            .selectedExchangeAct,
                        onChanged: (value) {
                          // 选中交易法变更事件
                          context
                              .read<LoginRenewalBloc>()
                              .add(SelectedExchangeActChangeEvent());
                        },
                        activeColor: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_step_confirm_item_1,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decorationColor: Colors.blue,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_step_confirm_item_text,
                    style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // 选中隐私协议变更事件
              context
                  .read<LoginRenewalBloc>()
                  .add(SelectedPrivacyPolicyChangeEvent());
            },
            child: Container(
              margin: EdgeInsets.only(
                top: 26,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: EdgeInsets.only(
                      right: 8,
                    ),
                    child: Material(
                      child: Checkbox(
                        value: context
                            .read<LoginRenewalBloc>()
                            .state
                            .selectedPrivacyPolicy,
                        onChanged: (value) {
                          // 选中隐私协议变更事件
                          context
                              .read<LoginRenewalBloc>()
                              .add(SelectedPrivacyPolicyChangeEvent());
                        },
                        activeColor: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_step_confirm_item_2,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decorationColor: Colors.blue,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!
                        .login_application_step_confirm_item_text,
                    style: TextStyle(
                      color: Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 续费内容步骤3文本
class LoginRenewalContentStep3Text extends StatelessWidget {
  const LoginRenewalContentStep3Text({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 40,
        bottom: 40,
      ),
      color: Color.fromRGBO(249, 249, 249, 1),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          width: 840,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                WMSLocalizations.i18n(context)!
                    .login_application_pure_text_title,
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.56),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.login_application_pure_text_1,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.login_application_pure_text_2,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_pure_text_2_1,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_pure_text_2_2,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_pure_text_2_3,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.login_application_pure_text_3,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.56),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
