import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_company_complete_bloc.dart';
import '../bloc/login_company_complete_model.dart';
import 'login_company_complete_button.dart';
import 'login_company_complete_content.dart';
import 'login_company_complete_head.dart';

/**
 * 内容：登录公司完整性
 * 作者：赵士淞
 * 时间：2024/12/16
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
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          child: ListView(
            children: [
              // 头部
              LoginCompanyCompleteHead(),
              // 内容
              LoginCompanyCompleteContent(),
              // 按钮
              LoginCompanyCompleteButton(),
            ],
          ),
        ),
      ),
    );
  }
}
