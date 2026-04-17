import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/stripe_utils.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/user_license_management_detail_bloc.dart';
import '../bloc/user_license_management_detail_model.dart';

/**
 * 内容：ユーザーライセンス管理明细-表格
 * 作者：熊草云
 * 时间：2023/12/07
 */
class UserLicenseManagementDetailTable extends StatefulWidget {
  const UserLicenseManagementDetailTable({super.key});

  @override
  State<UserLicenseManagementDetailTable> createState() =>
      _UserLicenseManagementDetailTableState();
}

class _UserLicenseManagementDetailTableState
    extends State<UserLicenseManagementDetailTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLicenseManagementDetailBloc,
        UserLicenseManagementDetailModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 表格标题
            UserLicenseManagementDetailTableTitle(),
            // 表格内容
            UserLicenseManagementDetailTableContent(),
          ],
        );
      },
    );
  }
}

// 表格标题
class UserLicenseManagementDetailTableTitle extends StatefulWidget {
  const UserLicenseManagementDetailTableTitle({super.key});

  @override
  State<UserLicenseManagementDetailTableTitle> createState() =>
      _UserLicenseManagementDetailTableTitleState();
}

class _UserLicenseManagementDetailTableTitleState
    extends State<UserLicenseManagementDetailTableTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            child: Text(
              WMSLocalizations.i18n(context)!.account_menu_5,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                height: 1.0,
                color: Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 表格内容
class UserLicenseManagementDetailTableContent extends StatefulWidget {
  const UserLicenseManagementDetailTableContent({super.key});

  @override
  State<UserLicenseManagementDetailTableContent> createState() =>
      _UserLicenseManagementDetailTableContentState();
}

class _UserLicenseManagementDetailTableContentState
    extends State<UserLicenseManagementDetailTableContent> {
  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 37,
          margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: OutlinedButton(
            onPressed: () async {
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                context
                    .read<UserLicenseManagementDetailBloc>()
                    .add(InitEvent());
              } else {
                context
                    .read<UserLicenseManagementDetailBloc>()
                    .add(SetDetailManageFormEvent({}, false));
                context
                    .read<UserLicenseManagementDetailBloc>()
                    .add(SetDetailTypeFormEvent({}, false));

                _showDetailDialog(false);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  buttonItemList[i]['icon'],
                  color: Color.fromRGBO(0, 122, 255, 1),
                ),
                if (buttonItemList[i]['index'] == Config.NUMBER_ONE)
                  Padding(padding: EdgeInsets.only(left: 10)),
                Text(
                  buttonItemList[i]['index'] == Config.NUMBER_ZERO
                      ? ''
                      : buttonItemList[i]['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 122, 255, 1),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  // 修正/登录弹窗
  _showUpdataDetailDialog(detailSatutes) {
    UserLicenseManagementDetailBloc bloc =
        context.read<UserLicenseManagementDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<UserLicenseManagementDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<UserLicenseManagementDetailBloc,
              UserLicenseManagementDetailModel>(builder: (context, state) {
            return WMSDiaLogWidget(
              titleText:
                  WMSLocalizations.i18n(context)!.user_license_management_tip_4,
              contentText: state.roleId == 1
                  ? WMSLocalizations.i18n(context)!
                      .user_license_management_tip_5
                  : WMSLocalizations.i18n(context)!
                      .user_license_management_tip_6,
              buttonLeftFlag: false,
              buttonRightText: 'ok',
              onPressedRight: () {
                // 更新/插入数据
                // 关闭弹窗
                Navigator.pop(context);
              },
            );
          }),
        );
      },
    );
  }

  // 显示明细弹窗
  _showDetailDialog(detailSatutes) {
    UserLicenseManagementDetailBloc bloc =
        context.read<UserLicenseManagementDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<UserLicenseManagementDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<UserLicenseManagementDetailBloc,
              UserLicenseManagementDetailModel>(
            builder: (context, state) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!
                          .user_license_management_tip_4,
                      style: TextStyle(
                        color: Color.fromRGBO(44, 167, 176, 1),
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      height: 36,
                      child: Row(
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(44, 167, 176, 1),
                              ),
                              minimumSize: MaterialStatePropertyAll(
                                Size(90, 36),
                              ),
                            ),
                            onPressed: () async {
                              if (state.detailFormTypeInfo['type'] == null ||
                                  state.detailFormTypeInfo['type'] == '') {
                                WMSCommonBlocUtils.tipTextToast(
                                    WMSLocalizations.i18n(context)!
                                        .user_license_management_tip_7);
                                return;
                              }
                              if (state.roleId == 1) {
                                if (state.detailFormManageInfo[
                                            'pay_status_name'] ==
                                        '' ||
                                    state.detailFormManageInfo[
                                            'pay_status_name'] ==
                                        null) {
                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                              .i18n(context)!
                                          .user_license_management_detail_table_2 +
                                      WMSLocalizations.i18n(context)!
                                          .can_not_null_text);
                                  return;
                                } else if (state
                                            .detailFormManageInfo['pay_no'] ==
                                        '' ||
                                    state.detailFormManageInfo['pay_no'] ==
                                        null) {
                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                              .i18n(context)!
                                          .user_license_management_detail_table_2 +
                                      WMSLocalizations.i18n(context)!
                                          .can_not_null_text);
                                  return;
                                }
                              }
                              // 赵士淞 - 始
                              if (StoreProvider.of<WMSState>(context)
                                      .state
                                      .loginUser
                                      ?.role_id !=
                                  1) {
                                // 赵士淞 - 终
                                String? _payNo =
                                    await StripeUtils.createCheckoutSessions(
                                        context,
                                        state.detailFormTypeInfo['use_type_id'],
                                        2);
                                // ignore: unnecessary_null_comparison
                                if (_payNo == null || _payNo == '') {
                                  return;
                                }
                                bloc.add(SetDetailPayNotEvent(_payNo));
                                // 赵士淞 - 始
                              } else {
                                // 判断付款状态
                                if (state.detailFormManageInfo['pay_status'] ==
                                    Config.NUMBER_ONE.toString()) {
                                  // 免费支付事件
                                  bloc.add(FreeOfPaymentEvent());
                                }
                              }
                              // 赵士淞 - 终
                              // 关闭弹窗
                              Navigator.pop(context);
                              bloc.add(UpdataDetailListEvent(detailSatutes));
                              _showUpdataDetailDialog(detailSatutes);
                            },
                            child: Text(
                              detailSatutes
                                  ? WMSLocalizations.i18n(context)!
                                      .instruction_input_tab_button_update
                                  : WMSLocalizations.i18n(context)!
                                      .instruction_input_tab_button_add,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromRGBO(255, 255, 255, 1),
                              ),
                              minimumSize: MaterialStatePropertyAll(
                                Size(90, 36),
                              ),
                            ),
                            onPressed: () {
                              // 关闭弹窗
                              Navigator.pop(context);
                            },
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .delivery_note_close,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                content: Container(
                  width: 1072,
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                  ),
                  child: _showDetailDialogContent(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 显示明细弹窗详情
  _showDetailDialogContent() {
    return BlocBuilder<UserLicenseManagementDetailBloc,
        UserLicenseManagementDetailModel>(
      builder: (context, state) {
        return ListView(
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ライセンスの種類
                        _detailDialogTitleMust(WMSLocalizations.i18n(context)!
                            .account_license_type),
                        WMSDropdownWidget(
                          saveInput: true,
                          inputInitialValue:
                              state.detailFormTypeInfo['type'] == null
                                  ? ''
                                  : state.detailFormTypeInfo['type'].toString(),
                          dropdownKey: 'type',
                          dropdownTitle: 'type',
                          dataList1: state.salesTypeInfoList,
                          inputRadius: 4,
                          inputSuffixIcon: Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                          ),
                          selectedCallBack: (value) {
                            // 设定ライセンスの種類
                            if (value is! String) {
                              context
                                  .read<UserLicenseManagementDetailBloc>()
                                  .add(SetDetailTypeFormEvent(value, true));
                            } else {
                              context
                                  .read<UserLicenseManagementDetailBloc>()
                                  .add(SetUserFormValueEvent('use_type', null));
                              context
                                  .read<UserLicenseManagementDetailBloc>()
                                  .add(SetDetailTypeFormEvent({}, false));
                              // ignore: unnecessary_null_comparison
                              if (value.trim() != '' && value != null) {
                                WMSCommonBlocUtils.errorTextToast(
                                    WMSLocalizations.i18n(context)!
                                        .organization_master_tip_5);
                              }
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 有効期間(年)
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .user_license_management_detail_table_3),
                        WMSInputboxWidget(
                          text: state.detailFormTypeInfo['expiration_year']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定有効期間(年)
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 金額
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!.delivery_note_43),
                        WMSInputboxWidget(
                          text: state.detailFormTypeInfo['amount'].toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定金額
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 有効期間(月)
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .user_license_management_detail_table_4),
                        WMSInputboxWidget(
                          text: state.detailFormTypeInfo['expiration_month']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定有効期間(月)
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // サポート内容
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .user_license_management_detail_table_6),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state.detailFormTypeInfo['support_cotent']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定サポート内容
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 有効期間(日)
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .user_license_management_detail_table_5),
                        WMSInputboxWidget(
                          text: state.detailFormTypeInfo['expiration_day']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {},
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 運用開始日
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .account_license_start),
                        WMSInputboxWidget(
                          text: state.detailFormManageInfo['start_date']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定運用開始日
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 運用終了日
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .account_license_end),
                        WMSInputboxWidget(
                          text:
                              state.detailFormManageInfo['end_date'].toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定運用終了日
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 支払状態
                        _detailDialogTitleMust(WMSLocalizations.i18n(context)!
                            .account_license_payment),
                        state.roleId != 1
                            ? WMSInputboxWidget(
                                text: state
                                    .detailFormManageInfo['pay_status_name']
                                    .toString(),
                                readOnly: true,
                              )
                            : WMSDropdownWidget(
                                saveInput: true,
                                inputInitialValue: state.detailFormManageInfo[
                                            'pay_status_name'] ==
                                        null
                                    ? ''
                                    : state
                                        .detailFormManageInfo['pay_status_name']
                                        .toString(),
                                dropdownKey: 'pay_status_name',
                                dropdownTitle: 'pay_status_name',
                                dataList1: state.salesPaymentStatusInfoList,
                                inputRadius: 4,
                                inputSuffixIcon: Container(
                                  width: 24,
                                  height: 24,
                                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                ),
                                selectedCallBack: (value) {
                                  // 设定值
                                  if (value is! String) {
                                    context
                                        .read<UserLicenseManagementDetailBloc>()
                                        .add(SetDetailValueEvent(
                                            'pay_status_name',
                                            value['pay_status_name']));
                                    context
                                        .read<UserLicenseManagementDetailBloc>()
                                        .add(SetDetailFormIDEvent(
                                            'pay_status', value['id']));
                                  } else {
                                    context
                                        .read<UserLicenseManagementDetailBloc>()
                                        .add(SetDetailValueEvent(
                                            'pay_status_name', ''));
                                    context
                                        .read<UserLicenseManagementDetailBloc>()
                                        .add(SetDetailFormIDEvent(
                                            'pay_status', '-1'));
                                  }
                                },
                              ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // オーダー番号
                        _detailDialogTitleMust(WMSLocalizations.i18n(context)!
                            .user_license_management_detail_table_2),
                        WMSInputboxWidget(
                          text: state.detailFormManageInfo['pay_no'].toString(),
                          readOnly: state.roleId != 1,
                          inputBoxCallBack: (value) {
                            // 设定オーダー番号
                            context
                                .read<UserLicenseManagementDetailBloc>()
                                .add(SetDetailValueEvent('pay_no', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                // 合计
                FractionallySizedBox(
                  widthFactor: .3,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: .8,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .exit_input_table_title_9,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: .2,
                              child: Text(
                                state.detailFormTypeInfo['amount'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: .8,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .user_license_management_detail_table_7,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: .2,
                              child: Text(
                                (state.detailFormTypeInfo['amount'] == '' ||
                                        state.detailFormTypeInfo['amount'] ==
                                            null)
                                    ? ''
                                    : (double.parse(state
                                                .detailFormTypeInfo['amount']
                                                .toString()) *
                                            .1)
                                        .toInt()
                                        .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: .8,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_46,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: .2,
                              child: Text(
                                (state.detailFormTypeInfo['amount'] == '' ||
                                        state.detailFormTypeInfo['amount'] ==
                                            null)
                                    ? ''
                                    : (state.detailFormTypeInfo['amount'] +
                                            state.detailFormTypeInfo['amount'] *
                                                .1)
                                        .toInt()
                                        .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 明细弹窗标题
  _detailDialogTitle(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 明细弹窗标题
  _detailDialogTitleMust(String title) {
    return Container(
      height: 24,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color.fromRGBO(6, 14, 15, 1),
            ),
          ),
          Text(
            "*",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(255, 0, 0, 1.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 右侧按钮单个列表
    List _buttonRightItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'icon': Icons.cached,
      },
      {
        'index': Config.NUMBER_ONE,
        'icon': Icons.add,
        'title': WMSLocalizations.i18n(context)!
            .user_license_management_detail_table_8,
      },
    ];
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 37,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    child: Container(
                      child: Row(
                        children: _initButtonRightList(_buttonRightItemList),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WMSTableWidget<UserLicenseManagementDetailBloc,
                UserLicenseManagementDetailModel>(
              showCheckboxColumn: false,
              columns: [
                {
                  'key': 'id',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_8,
                },
                {
                  'key': 'type',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.account_license_type,
                },
                {
                  'key': 'start_date',
                  'width': 4,
                  'title':
                      WMSLocalizations.i18n(context)!.account_license_start,
                },
                {
                  'key': 'end_date',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.account_license_end,
                },
                {
                  'key': 'pay_total',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .user_license_management_detail_table_1,
                },
                {
                  'key': 'pay_status_name',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.account_license_payment,
                },
                {
                  'key': 'pay_no',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!
                      .user_license_management_detail_table_2,
                },
              ],
              operatePopupHeight: 100,
              operatePopupOptions: [
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) async {
                    // 查询明细事件
                    // 1check 「支払状態」＝「0：未支払」の場合、修正可能
                    if (value['pay_status'] == '0') {
                      context
                          .read<UserLicenseManagementDetailBloc>()
                          .add(SetDetailManageFormEvent(value, true));
                      context
                          .read<UserLicenseManagementDetailBloc>()
                          .add(SetDetailTypeFormEvent(value, true));
                      _showDetailDialog(true);
                    } else {
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                                  .account_license_payment +
                              '：' +
                              WMSLocalizations.i18n(context)!
                                  .manage_pay_status_text_1 +
                              WMSLocalizations.i18n(context)!
                                  .user_license_management_tip_3);
                      return;
                    }
                  },
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
