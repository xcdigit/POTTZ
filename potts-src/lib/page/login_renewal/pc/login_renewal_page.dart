import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_renewal_bloc.dart';
import '../bloc/login_renewal_model.dart';
import 'login_renewal_bottom.dart';
import 'login_renewal_content.dart';
import 'login_renewal_head.dart';

/**
 * 内容：续费
 * 作者：赵士淞
 * 时间：2025/01/10
 */
// ignore: must_be_immutable
class LoginRenewalPage extends StatefulWidget {
  static const String sName = "LoginRenewal";
  // 页面标识
  String pageFlag = '';

  LoginRenewalPage({
    super.key,
    this.pageFlag = '',
  });

  @override
  State<LoginRenewalPage> createState() => _LoginRenewalPageState();
}

class _LoginRenewalPageState extends State<LoginRenewalPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginRenewalBloc>(
      create: (context) {
        return LoginRenewalBloc(
          LoginRenewalModel(
            rootContext: context,
            pageFlag: widget.pageFlag,
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
              LoginRenewalHead(),
              // 内容
              LoginRenewalContent(),
              // 底部
              LoginRenewalBottom(),
            ],
          ),
        ),
      ),
    );
  }
}
