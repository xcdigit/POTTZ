import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/license_management_bloc.dart';
import '../bloc/license_management_model.dart';
import 'license_management_title.dart';

/**
 * 内容：ライセンス管理-表单
 * 作者：王光顺
 * 时间：2023/12/05
 */
// ignore: must_be_immutable
class LicenseManagementForm extends StatefulWidget {
  int licenseId;
  int flag;
  LicenseManagementForm({super.key, this.licenseId = 0, this.flag = 0});

  @override
  State<LicenseManagementForm> createState() => _LicenseManagementFormState();
}

class _LicenseManagementFormState extends State<LicenseManagementForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicenseManagementBloc>(
      create: (context) {
        return LicenseManagementBloc(
          LicenseManagementModel(context: context),
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
              LicenseManagementTitle(
                flag: 'change',
              ),
              // 表单内容
              LicenseManagementFormContent(
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
class LicenseManagementFormContent extends StatefulWidget {
  int flag;
  LicenseManagementFormContent({super.key, this.flag = 0});

  @override
  State<LicenseManagementFormContent> createState() =>
      _LicenseManagementFormContentState();
}

//日期标识
int stateDate = 0;

class _LicenseManagementFormContentState
    extends State<LicenseManagementFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<LicenseManagementBloc, LicenseManagementModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context
                .read<LicenseManagementBloc>()
                .add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context
                .read<LicenseManagementBloc>()
                .add(ShowSelectValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }

        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            // ID
            FractionallySizedBox(
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
                        'ID',
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
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LicenseManagementBloc>()
                            .add(SetMessageValueEvent('id', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // ロール
            FractionallySizedBox(
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
                                .account_profile_roll,
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
                    state.stateFlg != '2'
                        ? WMSDropdownWidget(
                            saveInput: true,
                            inputInitialValue: state.formInfo['role'] == null
                                ? ''
                                : state.formInfo['role'].toString(),
                            dropdownKey: 'name',
                            dropdownTitle: 'name',
                            dataList1: state.salesRoleInfoList,
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
                                context.read<LicenseManagementBloc>().add(
                                    SetNowRoleDEvent(
                                        int.parse(value['id'].toString())));
                                context.read<LicenseManagementBloc>().add(
                                    SetMessageValueEvent(
                                        'role', value['name']));
                              } else if (value.isEmpty) {
                                context
                                    .read<LicenseManagementBloc>()
                                    .add(SetMessageValueEvent('role', ''));
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            readOnly: true,
                            text: state.formInfo['role'] == null
                                ? ''
                                : state.formInfo['role'].toString(),
                          ),
                  ],
                ),
              ),
            ),

            FractionallySizedBox(
              widthFactor: 0.4,
              child: Column(
                children: [
                  // ライセンスの種類
                  Container(
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
                                    .account_license_type,
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
                        WMSInputboxWidget(
                          text: state.formInfo['type'].toString(),
                          readOnly: state.stateFlg == '2',
                          inputBoxCallBack: (value) {
                            // 设定值
                            context
                                .read<LicenseManagementBloc>()
                                .add(SetMessageValueEvent('type', value));
                          },
                        ),
                      ],
                    ),
                  ),
                  //金額
                  Container(
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
                                    .delivery_note_43,
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
                        WMSInputboxWidget(
                          text: state.formInfo['amount'].toString(),
                          readOnly: state.stateFlg == '2',
                          inputBoxCallBack: (value) {
                            // 设定值
                            context
                                .read<LicenseManagementBloc>()
                                .add(SetMessageValueEvent('amount', value));
                          },
                        ),
                      ],
                    ),
                  ),
                  //有効期間(年)
                  Container(
                    height: 72,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .license_management_2,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          text: state.formInfo['expiration_year'].toString(),
                          readOnly: state.stateFlg == '2',
                          inputBoxCallBack: (value) {
                            // 设定值
                            context.read<LicenseManagementBloc>().add(
                                SetMessageValueEvent('expiration_year', value));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //サポート内容
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Container(
                height: 248,
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
                                .license_management_1,
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
                    WMSInputboxWidget(
                      height: 224,
                      maxLines: 9,
                      text: state.formInfo['support_cotent'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LicenseManagementBloc>()
                            .add(SetMessageValueEvent('support_cotent', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 有効期間(月)
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.license_management_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['expiration_month'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context.read<LicenseManagementBloc>().add(
                            SetMessageValueEvent('expiration_month', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 有効期間(日)
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.license_management_4,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['expiration_day'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LicenseManagementBloc>()
                            .add(SetMessageValueEvent('expiration_day', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 開始日
            FractionallySizedBox(
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
                            WMSLocalizations.i18n(context)!.menu_content_4_10_3,
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
                            .read<LicenseManagementBloc>()
                            .add(SetMessageValueEvent('start_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 終了日
            FractionallySizedBox(
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
                            WMSLocalizations.i18n(context)!.menu_content_4_10_4,
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
                            .read<LicenseManagementBloc>()
                            .add(SetMessageValueEvent('end_date', value));
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
                        child: LicenseManagementFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: LicenseManagementFormButton(state: state),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
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

// ライセンス管理-表单Tab
// ignore: must_be_immutable
class LicenseManagementFormTab extends StatefulWidget {
  LicenseManagementFormTab({super.key});

  @override
  State<LicenseManagementFormTab> createState() =>
      _LicenseManagementFormTabState();
}

class _LicenseManagementFormTabState extends State<LicenseManagementFormTab> {
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

// ライセンス管理-表单按钮
// ignore: must_be_immutable
class LicenseManagementFormButton extends StatefulWidget {
  LicenseManagementModel state;
  LicenseManagementFormButton({super.key, required this.state});

  @override
  State<LicenseManagementFormButton> createState() =>
      _LicenseManagementFormButtonState();
}

class _LicenseManagementFormButtonState
    extends State<LicenseManagementFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
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
                  context.read<LicenseManagementBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context
                      .read<LicenseManagementBloc>()
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
        'title': context.read<LicenseManagementBloc>().state.formInfo['id'] ==
                    '' ||
                context.read<LicenseManagementBloc>().state.formInfo['id'] ==
                    null ||
                context.read<LicenseManagementBloc>().state.stateFlg == '2'
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
