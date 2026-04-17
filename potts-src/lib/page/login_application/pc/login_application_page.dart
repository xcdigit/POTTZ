import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_application_bloc.dart';
import '../bloc/login_application_model.dart';
import 'login_application_bottom.dart';
import 'login_application_content.dart';
import 'login_application_head.dart';

/**
 * 内容：申请
 * 作者：赵士淞
 * 时间：2024/12/04
 */
// ignore: must_be_immutable
class LoginApplicationPage extends StatefulWidget {
  static const String sName = "LoginApplication";
  // 通道ID
  String channelId = '';
  // 页面标识
  String pageFlag = '';

  LoginApplicationPage({
    super.key,
    this.channelId = '',
    this.pageFlag = '',
  });

  @override
  State<LoginApplicationPage> createState() => _LoginApplicationPageState();
}

class _LoginApplicationPageState extends State<LoginApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginApplicationBloc>(
      create: (context) {
        return LoginApplicationBloc(
          LoginApplicationModel(
            rootContext: context,
            channelId: widget.channelId,
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
              LoginApplicationHead(),
              // 内容
              LoginApplicationContent(),
              // 底部
              LoginApplicationBottom(),
            ],
          ),
        ),
      ),
    );
  }
}
