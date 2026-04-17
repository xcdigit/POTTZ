import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/style/wms_style.dart';
import '../bloc/login_company_complete_bloc.dart';
import '../bloc/login_company_complete_model.dart';
import 'login_company_complete_button.dart';
import 'login_company_complete_content.dart';
import 'login_company_complete_head_language.dart';

/**
 * 内容：登录公司完整性
 * 作者：赵士淞
 * 时间：2025/01/23
 */
class LoginCompanyCompletePage extends StatefulWidget {
  static const String sName = "LoginCompanyComplete";
  const LoginCompanyCompletePage({super.key});

  @override
  State<LoginCompanyCompletePage> createState() =>
      _LoginCompanyCompletePageState();
}

class _LoginCompanyCompletePageState extends State<LoginCompanyCompletePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCompanyCompleteBloc>(
      create: (context) {
        return LoginCompanyCompleteBloc(
          LoginCompanyCompleteModel(
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
                            height: 60,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: LoginCompanyCompleteHeadLanguage(),
                            ), // false
                          ),
                          LoginCompanyCompleteContent(),
                          LoginCompanyCompleteButton(),
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
