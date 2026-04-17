import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/login_register/bloc/login_register_bloc.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';

import '../../../common/config/config.dart';
import 'login_register_footer.dart';
import 'login_register_header.dart';

/**
 * 内容：完成
 * 作者：luxy
 * 时间：2024/06/24
 */
class LoginRegisterComplete extends StatefulWidget {
  static const String sName = "LoginRegisterComplete";
  const LoginRegisterComplete({super.key});

  @override
  State<LoginRegisterComplete> createState() => _LoginRegisterCompleteState();
}

bool flag = true;

class _LoginRegisterCompleteState extends State<LoginRegisterComplete> {
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
                  //头部
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
                              // 決済が完了しました。
                              Container(
                                margin: EdgeInsets.only(
                                  top: 100,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      WMSLocalizations.i18n(context)!
                                          .register_company_form_1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // お申し込みいただき、ありがとうございます。
                              Container(
                                margin: EdgeInsets.only(
                                  top: 20,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      WMSLocalizations.i18n(context)!
                                          .register_send_message,
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
                              // 2-3営業日以内に、担当者からアカウント情報をご連絡させていただきます。
                              Container(
                                margin: EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      WMSLocalizations.i18n(context)!
                                          .register_send_message_1,
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
                              //按钮
                              BlocBuilder<LoginRegisterBLoc,
                                  LoginRegisterModel>(
                                builder: (context, state) {
                                  return FractionallySizedBox(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 30,
                                        bottom: 20,
                                      ),
                                      child: Row(
                                        children: [
                                          //TOPに戻る
                                          BuildButtom(
                                            WMSLocalizations.i18n(context)!
                                                .register_btn_3,
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
}

// 底部申请确定按钮
Container BuildButtom(
    String text, LoginRegisterModel state, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Color.fromRGBO(0, 39, 72, 1),
    ),
    height: 53,
    width: 392,
    child: OutlinedButton(
      onPressed: () async {
        //判断数据为空
        bool res = await context
            .read<LoginRegisterBLoc>()
            .selectRegisterCheck(context, state);
        if (res) {
          // _confirmDialog(context);
        }
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
