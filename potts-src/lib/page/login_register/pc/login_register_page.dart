import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/login_register/bloc/login_register_bloc.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';
import 'package:wms/page/login_register/pc/Login_register_user_form.dart';
import 'package:wms/redux/wms_state.dart';

import 'login_register_footer.dart';
import 'login_register_header.dart';

/**
 * 内容：申込
 * 作者：cuihr
 * 时间：2023/12/06
 */
class LoginRegisterPage extends StatefulWidget {
  static const String sName = "LoginRegister";
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

bool flag = true;

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  int _selectedRadioValue1 = 0;
  int _selectedRadioValue2 = 0;

  @override
  Widget build(BuildContext context) {
    // 整体
    return Material(
      child: BlocProvider<LoginRegisterBLoc>(
        create: (context) => LoginRegisterBLoc(
          LoginRegisterModel(
            context,
            languageList: [],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width <
                      Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                  ? Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                  : MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width <
                        Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                    ? Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                    : MediaQuery.of(context).size.width,
              ),
              child: ListView(
                children: [
                  // 头部内容
                  Container(
                    height: 400,
                    child: LoginRegisterHeader(),
                  ),
                  // 中间内容
                  Container(
                    padding: EdgeInsets.only(
                      left: 60,
                      right: 60,
                    ),
                    child: Column(
                      children: [
                        // 申込标题
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 104,
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .register_title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Color.fromRGBO(64, 64, 64, 1),
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 700,
                          child: Column(
                            children: [
                              // 步骤条
                              Container(
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "01",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            height: 1.0,
                                            color: Color.fromRGBO(0, 39, 72, 1),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(0, 39, 72, 1),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 15),
                                          height: 41,
                                          width: 41,
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_company_1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Color.fromRGBO(0, 39, 72, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      width: 164.0, // 线的宽度
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color:
                                                Color.fromRGBO(0, 39, 72, 0.4),
                                          ), // 下边框作为线
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "02",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            height: 1.0,
                                            color:
                                                Color.fromRGBO(0, 39, 72, 0.4),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(0, 39, 72, 0.4),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 15),
                                          height: 41,
                                          width: 41,
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_company_2,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Color.fromRGBO(0, 39, 72, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      width: 164.0, // 线的宽度
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color:
                                                Color.fromRGBO(0, 39, 72, 0.4),
                                          ), // 下边框作为线
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "03",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            height: 1.0,
                                            color:
                                                Color.fromRGBO(0, 39, 72, 0.4),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(0, 39, 72, 0.4),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 15),
                                          height: 41,
                                          width: 41,
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_company_3,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Color.fromRGBO(0, 39, 72, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .register_text_1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.28,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 60,
                                ),
                              ),
                              // 用户信息表单
                              LoginRegisterUserForm(),
                              // プランを選ぶ
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            WMSLocalizations.i18n(context)!
                                                .register_table_1,
                                            style: TextStyle(
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.72,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            width: 32.71,
                                            height: 20.39,
                                            decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(0, 39, 72, 1),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .register_text_2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // プランを選ぶ列表
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: _selectedRadioValue1,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRadioValue1 = value!;
                                            });
                                          },
                                        ),
                                        Text('Option 1'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 2,
                                          groupValue: _selectedRadioValue1,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRadioValue1 = value!;
                                            });
                                          },
                                        ),
                                        Text('Option 2'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 3,
                                          groupValue: _selectedRadioValue1,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRadioValue1 = value!;
                                            });
                                          },
                                        ),
                                        Text('Option 3'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 50,
                                ),
                              ),
                              // 特定商取引
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: _selectedRadioValue2,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRadioValue2 = value!;
                                            });
                                          },
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_table_2,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            height: 1.0,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 80,
                                          ),
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_table_4,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            height: 1.0,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 2,
                                          groupValue: _selectedRadioValue2,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedRadioValue2 = value!;
                                            });
                                          },
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_table_3,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            height: 1.0,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                        Text(
                                          WMSLocalizations.i18n(context)!
                                              .register_table_4,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            height: 1.0,
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // 按钮
                              BlocBuilder<LoginRegisterBLoc,
                                  LoginRegisterModel>(
                                builder: (context, state) {
                                  return FractionallySizedBox(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                      ),
                                      child: Row(
                                        children: [
                                          //この内容で送信する
                                          BuildButtom(
                                            WMSLocalizations.i18n(context)!
                                                .register_btn_1,
                                            state,
                                            context,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // footer
                  LoginRegisterFotter(
                    flag: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 底部申请确定按钮
Container BuildButtom(
    String text, LoginRegisterModel state, BuildContext context) {
  return Container(
    color: Color.fromRGBO(0, 39, 72, 1),
    height: 53,
    width: 502,
    child: OutlinedButton(
      onPressed: () async {
        //判断数据为空
        // bool res = await context
        //     .read<LoginRegisterBLoc>()
        //     .selectRegisterCheck(context, state);
        // if (res) {
        //   context.go('/loginNextRegister');
        // }
        context.go('/loginRegisterAuthentication');
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Color.fromRGBO(0, 39, 72, 1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        side: MaterialStateProperty.all(
          const BorderSide(
            width: 1,
            color: Color.fromRGBO(0, 39, 72, 1),
          ),
        ),
      ),
    ),
  );
}

// 首页框架头部多语言
// ignore: must_be_immutable
class RegisterHeadLanguage extends StatefulWidget {
  RegisterHeadLanguage({super.key});

  @override
  State<RegisterHeadLanguage> createState() => _RegisterHeadLanguageState();
}

class _RegisterHeadLanguageState extends State<RegisterHeadLanguage> {
  // 显示自定义多语言弹窗
  _showCustomLanguageDialog(LoginRegisterModel state) {
    // 语言组件列表
    List<Widget> _languageWidgetList() {
      // 组件列表
      List<Widget> widgetList = [];
      // 循环语言列表
      for (int i = 0; i < state.languageList.length; i++) {
        // 组件列表新增
        widgetList.add(
          GestureDetector(
            onTap: () {
              // 选中语言变更事件
              context.read<LoginRegisterBLoc>().add(
                  SelectedLanguageChangeEvent(state.languageList[i]['id']));
            },
            child: Container(
              width: 138,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: i == state.languageList.length - 1
                      ? Radius.circular(5)
                      : Radius.circular(0),
                  bottomRight: i == state.languageList.length - 1
                      ? Radius.circular(5)
                      : Radius.circular(0),
                ),
                border: Border.all(
                  width: 0.5,
                  color: Color.fromRGBO(102, 199, 206, 1),
                ),
                color: state.languageList[i]['id'] == state.selectedLanguage
                    ? Color.fromRGBO(102, 199, 206, 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  state.languageList[i]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: state.languageList[i]['id'] == state.selectedLanguage
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(102, 199, 206, 1),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return widgetList;
    }

    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(255, 255, 255, 0),
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: 68,
                right: 44,
                child: Container(
                  width: 138,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                      width: 0.5,
                      color: Color.fromRGBO(102, 199, 206, 1),
                    ),
                  ),
                  child: Column(
                    children: _languageWidgetList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBLoc, LoginRegisterModel>(
      builder: (context, state) {
        return GestureDetector(
          onPanDown: (details) {
            // 显示自定义多语言弹窗
            _showCustomLanguageDialog(state);
          },
          child: Container(
            width: StoreProvider.of<WMSState>(context).state.login!
                ? (MediaQuery.of(context).size.width <
                        Config.WEB_MINI_WIDTH_LIMIT
                    ? 0
                    : null)
                : null,
            height: 34,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Image.asset(
                    WMSICons.HOME_HEAD_LANGUAGE,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                  child: Text(
                    WMSLocalizations.i18n(context)!.home_head_language,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                  child: Image.asset(
                    WMSICons.HOME_HEAD_MORE,
                    width: 20,
                    height: 32,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
