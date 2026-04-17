import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/style/wms_style.dart';

import '../bloc/login_verification_code_bloc.dart';
import '../bloc/login_verification_code_model.dart';
import 'login_verification_code_content.dart';
import 'login_verification_code_head_language.dart';

/**
 * 内容：登录验证码
 * 作者：赵士淞
 * 时间：2024/12/13
 */
class LoginVerificationCodePage extends StatefulWidget {
  static const String sName = "LoginVerificationCode";
  const LoginVerificationCodePage({super.key});

  @override
  State<LoginVerificationCodePage> createState() =>
      _LoginVerificationCodePageState();
}

class _LoginVerificationCodePageState extends State<LoginVerificationCodePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginVerificationCodeBloc>(
      create: (context) {
        return LoginVerificationCodeBloc(
          LoginVerificationCodeModel(
            rootContext: context,
          ),
        );
      },
      child:

          /// 触摸收起键盘
          new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: new Container(
            color: Theme.of(context).primaryColor,
            child: Stack(children: <Widget>[
              new Center(
                ///防止overFlow的现象
                child: SafeArea(
                  ///同时弹出键盘不遮挡
                  child: new Container(
                    height: MediaQuery.of(context).size.height, //宽度自适应
                    width: MediaQuery.of(context).size.width, //高度自适应
                    color: WMSColors.cardWhite,
                    child: SingleChildScrollView(
                      child: new Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // 顶部内容
                          Container(
                            height: 100,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: LoginVerificationCodeHeadLanguage(),
                            ), // false
                          ),
                          new Padding(padding: new EdgeInsets.all(15.0)),
                          LoginVerificationCodeContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
