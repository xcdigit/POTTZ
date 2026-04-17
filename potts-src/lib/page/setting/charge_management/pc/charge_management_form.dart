import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/widget/wms_date_widget.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/charge_management_bloc.dart';
import '../bloc/charge_management_model.dart';
import 'charge_management_title.dart';

/**
 * 内容：課金法人管理-表单
 * 作者：熊草云
 * 时间：2023/12/05
 */
// ignore: must_be_immutable
class ChargeManagementForm extends StatefulWidget {
  int chargeId;
  int flag;
  ChargeManagementForm({super.key, this.chargeId = 0, this.flag = 0});

  @override
  State<ChargeManagementForm> createState() => _ChargeManagementFormState();
}

class _ChargeManagementFormState extends State<ChargeManagementForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChargeManagementBloc>(
      create: (context) {
        return ChargeManagementBloc(
          ChargeManagementModel(context: context),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              ChargeManagementTitle(
                flag: 'change',
              ),
              // 表单内容
              ChargeManagementFormContent(
                flag: widget.flag,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ChargeManagementFormContent extends StatefulWidget {
  int flag;
  ChargeManagementFormContent({super.key, this.flag = 0});

  @override
  State<ChargeManagementFormContent> createState() =>
      _ChargeManagementFormContentState();
}

class _ChargeManagementFormContentState
    extends State<ChargeManagementFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<ChargeManagementBloc, ChargeManagementModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context
                .read<ChargeManagementBloc>()
                .add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context
                .read<ChargeManagementBloc>()
                .add(ShowSelectValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }

        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            FractionallySizedBox(
              //1ID
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        "ID",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['id'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //2会社名
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .company_information_2,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    ),
                    state.formInfo['id'] != null &&
                            state.formInfo['id'].toString() != ''
                        ? WMSInputboxWidget(
                            text: state.formInfo['company_name'] == null
                                ? ''
                                : state.formInfo['company_name'].toString(),
                            readOnly: true,
                          )
                        : WMSDropdownWidget(
                            saveInput: true,
                            inputInitialValue:
                                state.formInfo['company_name'] == null
                                    ? ''
                                    : state.formInfo['company_name'].toString(),
                            dropdownKey: 'name',
                            dropdownTitle: 'name',
                            dataList1: state.salesCompanyInfoList,
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
                                context.read<ChargeManagementBloc>().add(
                                    SetCompanyValueEvent(
                                        'company_name', value['name']));
                                context.read<ChargeManagementBloc>().add(
                                    SetNowCompanyIDEvent(
                                        int.parse(value['id'].toString())));
                                context
                                    .read<ChargeManagementBloc>()
                                    .add(SetNowUserListEvent(value['id']));
                              } else {
                                context.read<ChargeManagementBloc>().add(
                                    SetCompanyValueEvent('company_name', null));
                                context
                                    .read<ChargeManagementBloc>()
                                    .add(SetNowUserListEvent(0));
                                // ignore: unnecessary_null_comparison
                                if (value.trim() != '' && value != null) {
                                  WMSCommonBlocUtils.errorTextToast(
                                      WMSLocalizations.i18n(context)!
                                          .organization_master_tip_5);
                                }
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //3運用開始日
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .account_license_start,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    ),
                    WMSDateWidget(
                      text: state.formInfo['start_date'].toString(),
                      readOnly: state.stateFlg == '2',
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<ChargeManagementBloc>()
                            .add(SetCompanyValueEvent('start_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //4運用終了日
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.account_license_end,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    ),
                    WMSDateWidget(
                      text: state.formInfo['end_date'].toString(),
                      readOnly: state.stateFlg == '2',
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<ChargeManagementBloc>()
                            .add(SetCompanyValueEvent('end_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //5管理員
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .charge_management_form_1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
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
                    ),
                    state.stateFlg == '2'
                        ? WMSInputboxWidget(
                            text: state.formInfo['user_name'] == null
                                ? ''
                                : state.formInfo['user_name'].toString(),
                            readOnly: true,
                          )
                        : state.salesUserInfoList.length > 0
                            ? WMSDropdownWidget(
                                saveInput: true,
                                inputInitialValue:
                                    state.formInfo['user_name'] == null
                                        ? ''
                                        : state.formInfo['user_name']
                                            .toString(),
                                dropdownKey: 'name',
                                dropdownTitle: 'name',
                                dataList1: state.salesUserInfoList,
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
                                    context.read<ChargeManagementBloc>().add(
                                        SetCompanyValueEvent(
                                            'user_name', value['name']));
                                    context.read<ChargeManagementBloc>().add(
                                        SetNowUserIDEvent(
                                            int.parse(value['id'].toString())));
                                  } else {
                                    context.read<ChargeManagementBloc>().add(
                                        SetCompanyValueEvent('user_name', ''));
                                    // ignore: unnecessary_null_comparison
                                    if (value.trim() != '' && value != null) {
                                      WMSCommonBlocUtils.errorTextToast(
                                          WMSLocalizations.i18n(context)!
                                              .charge_management_tip_1);
                                    }
                                  }
                                },
                              )
                            : WMSInputboxWidget(
                                text: state.formInfo['user_name'] == null
                                    ? ''
                                    : state.formInfo['user_name'].toString(),
                                readOnly: true,
                              ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //6備考
              widthFactor: 0.4,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .charge_management_form_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      height: 136,
                      maxLines: 5,
                      text: state.formInfo['note'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        context
                            .read<ChargeManagementBloc>()
                            .add(SetCompanyValueEvent('note', value.trim()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        }

        return Container(
          margin: EdgeInsets.only(
            bottom: 40,
          ),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ChargeManagementFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: ChargeManagementFormButton(state: state),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
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
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: _initFormBasic(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 課金法人管理-表单Tab
// ignore: must_be_immutable
class ChargeManagementFormTab extends StatefulWidget {
  ChargeManagementFormTab({super.key});

  @override
  State<ChargeManagementFormTab> createState() =>
      _ChargeManagementFormTabState();
}

class _ChargeManagementFormTabState extends State<ChargeManagementFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 46,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    );
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 課金法人管理-表单按钮
// ignore: must_be_immutable
class ChargeManagementFormButton extends StatefulWidget {
  ChargeManagementModel state;
  ChargeManagementFormButton({super.key, required this.state});

  @override
  State<ChargeManagementFormButton> createState() =>
      _ChargeManagementFormButtonState();
}

class _ChargeManagementFormButtonState
    extends State<ChargeManagementFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          // onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 20),
            height: 37,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonItemList[i]['index'] == Config.NUMBER_ZERO
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : (widget.state.stateFlg == '2'
                          ? Color.fromRGBO(95, 97, 97, 1)
                          : Color.fromRGBO(44, 167, 176, 1)),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {
                // 判断循环下标
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  //清除表单数据
                  context.read<ChargeManagementBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context
                      .read<ChargeManagementBloc>()
                      .add(UpdateFormEvent(context));
                }
              },
              child: Text(
                buttonItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.28,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': context.read<ChargeManagementBloc>().state.formInfo['id'] ==
                    null ||
                context.read<ChargeManagementBloc>().state.formInfo['id'] ==
                    '' ||
                context.read<ChargeManagementBloc>().state.stateFlg == '2'
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
