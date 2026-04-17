import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_verification_code_bloc.dart';
import '../bloc/login_verification_code_model.dart';
import 'login_verification_code_content.dart';
import 'login_verification_code_head.dart';

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
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          child: ListView(
            children: [
              // 头部
              LoginVerificationCodeHead(),
              // 内容
              LoginVerificationCodeContent(),
            ],
          ),
        ),
      ),
    );
  }
}
