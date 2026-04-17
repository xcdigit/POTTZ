import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/setting/auth/bloc/auth_master_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/auth_master_bloc.dart';
import 'auth_title.dart';

/**
 * 内容：権限マスタ-表单
 * 作者：张博睿
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  int authId; //id
  int flag; //按钮跳转判断
  AuthForm({super.key, this.authId = 0, this.flag = 0});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthMasterBloc>(
      create: (context) {
        return AuthMasterBloc(
          AuthMasterModel(context: context),
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
              AuthTitle(
                flag: 'change',
              ),
              // 表单内容
              AuthFormContent(
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
class AuthFormContent extends StatefulWidget {
  int flag; //按钮跳转判断
  AuthFormContent({super.key, this.flag = 0});

  @override
  State<AuthFormContent> createState() => _AuthFormContentState();
}

class _AuthFormContentState extends State<AuthFormContent> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<AuthMasterBloc, AuthMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            context.read<AuthMasterBloc>().add(ShowSelectValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            context.read<AuthMasterBloc>().add(ShowSelectValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
        }

        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
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
                        WMSLocalizations.i18n(context)!.auth_Form_1,
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
            FractionallySizedBox(widthFactor: 0.2),
            //ロール名称
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
                            WMSLocalizations.i18n(context)!.auth_Form_2,
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
                            dataList1: state.roleList,
                            inputInitialValue:
                                state.formInfo['role_name'].toString(),
                            inputRadius: 4,
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            inputFontSize: 14,
                            dropdownRadius: 4,
                            dropdownTitle: 'name',
                            selectedCallBack: (value) {
                              // 判断数值
                              if (value == '') {
                                // 设定值
                                context
                                    .read<AuthMasterBloc>()
                                    .add(SetDropdownValueEvent('role_id', ''));
                                context.read<AuthMasterBloc>().add(
                                    SetDropdownValueEvent('role_name', ''));
                              } else {
                                // 设定值
                                context.read<AuthMasterBloc>().add(
                                    SetDropdownValueEvent(
                                        'role_id', value['id']));
                                context.read<AuthMasterBloc>().add(
                                    SetDropdownValueEvent(
                                        'role_name', value['name']));
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            text: state.formInfo['role_name'].toString(),
                            readOnly: true,
                          ),
                  ],
                ),
              ),
            ),
            //メニュー名称
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
                            WMSLocalizations.i18n(context)!.auth_Form_3,
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
                            dataList1: state.menuList,
                            inputInitialValue:
                                state.formInfo['menu_name'].toString(),
                            inputRadius: 4,
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            inputFontSize: 14,
                            dropdownRadius: 4,
                            dropdownTitle: 'name',
                            selectedCallBack: (value) {
                              // 判断数值
                              if (value == '') {
                                // 设定值
                                context
                                    .read<AuthMasterBloc>()
                                    .add(SetDropdownValueEvent('menu_id', ''));
                                context.read<AuthMasterBloc>().add(
                                    SetDropdownValueEvent('menu_name', ''));
                              } else {
                                // 设定值
                                context.read<AuthMasterBloc>().add(
                                    SetDropdownValueEvent(
                                        'menu_id', value['id']));
                                context.read<AuthMasterBloc>().add(
                                    SetDropdownValueEvent(
                                        'menu_name', value['name']));
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            text: state.formInfo['menu_name'].toString(),
                            readOnly: true,
                          ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(widthFactor: 0.2),
            //権限
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
                            WMSLocalizations.i18n(context)!.auth_Form_4,
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
                      text: state.formInfo['auth'].toString(),
                      readOnly: state.stateFlg == '2',
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<AuthMasterBloc>()
                            .add(SetAuthValueEvent('auth', value));
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
                        child: AuthFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: AuthFormButton(state: state),
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

class AuthFormTab extends StatefulWidget {
  const AuthFormTab({super.key});

  @override
  State<AuthFormTab> createState() => _AuthFormTabState();
}

class _AuthFormTabState extends State<AuthFormTab> {
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

//权限-表单按钮
// ignore: must_be_immutable
class AuthFormButton extends StatefulWidget {
  AuthMasterModel state;
  AuthFormButton({super.key, required this.state});

  @override
  State<AuthFormButton> createState() => _AuthFormButtonState();
}

class _AuthFormButtonState extends State<AuthFormButton> {
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
                  context.read<AuthMasterBloc>().add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    widget.state.stateFlg == '1') {
                  //新增/修改数据
                  context.read<AuthMasterBloc>().add(UpdateFormEvent(context));
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
        'title': context.read<AuthMasterBloc>().state.formInfo['id'] == '' ||
                context.read<AuthMasterBloc>().state.formInfo['id'] == null ||
                context.read<AuthMasterBloc>().state.stateFlg == '2'
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
