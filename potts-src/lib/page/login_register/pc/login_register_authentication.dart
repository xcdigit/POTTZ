import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/login_register/bloc/login_register_bloc.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';

import '../../../common/config/config.dart';
import '../../../widget/wms_inputbox_widget.dart';
import 'login_register_footer.dart';
import 'login_register_header.dart';

/**
 * 内容：两级认证
 * 作者：luxy
 * 时间：2024/06/21
 */
class LoginRegisterAuthentication extends StatefulWidget {
  static const String sName = "LoginRegisterAuthentication";
  const LoginRegisterAuthentication({super.key});

  @override
  State<LoginRegisterAuthentication> createState() =>
      _LoginRegisterAuthenticationState();
}

// bool flag = true;

class _LoginRegisterAuthenticationState
    extends State<LoginRegisterAuthentication> {
  // 输入框操作实例
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  // 输入框焦点控制
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();

  String? _code1 = "";
  String? _code2 = "";
  String? _code3 = "";
  String? _code4 = "";

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
                  // 头部
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
                              // ２段階認証
                              Container(
                                margin: EdgeInsets.only(
                                  top: 100,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      WMSLocalizations.i18n(context)!
                                          .register_user_form_1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 確認コードを入力してください
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      WMSLocalizations.i18n(context)!
                                          .register_choose,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 验证码
                              Container(
                                margin: EdgeInsets.fromLTRB(70, 50, 0, 30),
                                child: Row(
                                  children: [
                                    // 第一个
                                    Container(
                                      height: 56,
                                      width: 47,
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TextField(
                                        controller: _controller1,
                                        onChanged: (String value) {
                                          _code1 = value;
                                        },
                                        style: TextStyle(
                                          color: Color.fromRGBO(6, 14, 15, 1),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        focusNode: _focusNode1,
                                      ),
                                    ),
                                    // 第二个
                                    Container(
                                      height: 56,
                                      width: 47,
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TextField(
                                        controller: _controller2,
                                        onChanged: (String value) {
                                          _code2 = value;
                                        },
                                        style: TextStyle(
                                          color: Color.fromRGBO(6, 14, 15, 1),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        focusNode: _focusNode2,
                                      ),
                                    ),
                                    // 第三个
                                    Container(
                                      height: 56,
                                      width: 47,
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TextField(
                                        controller: _controller3,
                                        onChanged: (String value) {
                                          _code3 = value;
                                        },
                                        style: TextStyle(
                                          color: Color.fromRGBO(6, 14, 15, 1),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        focusNode: _focusNode3,
                                      ),
                                    ),
                                    // 第四个
                                    Container(
                                      height: 56,
                                      width: 47,
                                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(245, 245, 245, 1),
                                        border: Border.all(
                                          width: 0.5,
                                          color: Color.fromRGBO(0, 0, 0, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TextField(
                                        controller: _controller4,
                                        onChanged: (String value) {
                                          _code4 = value;
                                        },
                                        style: TextStyle(
                                          color: Color.fromRGBO(6, 14, 15, 1),
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        focusNode: _focusNode4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //按钮
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
                                          //決済画面へ遷移する
                                          BuildButtom(
                                              WMSLocalizations.i18n(context)!
                                                  .register_btn_2,
                                              state,
                                              context,
                                              _code1 != "" &&
                                                  _code1 != null &&
                                                  _code2 != "" &&
                                                  _code2 != null &&
                                                  _code3 != "" &&
                                                  _code3 != null &&
                                                  _code4 != "" &&
                                                  _code4 != null),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // 確認コードが届かない場合
                              Container(
                                margin: EdgeInsets.fromLTRB(100, 20, 0, 0),
                                child: Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        // 再次发送验证码弹窗
                                        verificationDialog();
                                      },
                                      child: Text(
                                        WMSLocalizations.i18n(context)!
                                            .register_choose_type,
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 39, 72, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        ),
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
                  // footer
                  LoginRegisterFotter(
                    flag: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 未收到验证码，重新发送
  verificationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(1.0),
          contentPadding: EdgeInsets.all(0),
          content: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(0, 39, 72, 0.1),
            ),
            width: 560,
            height: 186,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WMSLocalizations.i18n(context)!.register_choose_status,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 16, 0, 0)),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: WMSInputboxWidget(
                      // text: "state.formInfo['user_email'].toString()",
                      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                      hintText: "電話番号を入力してください",
                      hintFontColor: Color.fromRGBO(156, 156, 156, 1),
                      hintFontSize: 14,
                      hintFontWeight: FontWeight.w400,
                      inputBoxCallBack: (value) {
                        // 设定值
                        context
                            .read<LoginRegisterBLoc>()
                            .add(SetRegisterValueEvent('user_email', value));
                      },
                    ),
                  ),

                  //按钮
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // キャンセル
                        Container(
                          height: 36,
                          width: 144,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); //关闭对话框
                            },
                            child: Text(
                              WMSLocalizations.i18n(context)!.app_cancel,
                              style: TextStyle(
                                color: Color.fromRGBO(0, 39, 72, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        // 送信する
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          height: 36,
                          width: 144,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color.fromRGBO(0, 39, 72, 1),
                          ),
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true); //关闭对话框
                            },
                            child: Text(
                              WMSLocalizations.i18n(context)!.register_btn_4,
                              style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
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
      },
    );
  }
}

// 底部申请确定按钮
Container BuildButtom(
    String text, LoginRegisterModel state, BuildContext context, bool flag) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color:
          flag ? Color.fromRGBO(0, 39, 72, 1) : Color.fromRGBO(0, 39, 72, 0.4),
    ),
    height: 56,
    width: 400,
    child: OutlinedButton(
      onPressed: () async {
        //判断数据为空
        // bool res = await context
        //     .read<LoginRegisterBLoc>()
        //     .selectRegisterCheck(context, state);
        // if (res) {

        // }
        context.go('/LoginRegisterComplete');
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}
