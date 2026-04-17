import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/login_application/bloc/login_application_bloc.dart';

import '../../../common/localization/default_localizations.dart';

/**
 * 内容：申请-内容-步骤4
 * 作者：穆政道
 * 时间：2024/12/11
 */
class LoginApplicationContentStep4 extends StatefulWidget {
  const LoginApplicationContentStep4({super.key});

  @override
  State<LoginApplicationContentStep4> createState() =>
      _LoginApplicationContentStep4State();
}

class _LoginApplicationContentStep4State
    extends State<LoginApplicationContentStep4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 申请内容步骤4文本
        LoginApplicationContentStep4Text(),
        // 申请内容步骤4按钮
        LoginApplicationContentStep4Button(),
      ],
    );
  }
}

// 申请内容步骤4文本
class LoginApplicationContentStep4Text extends StatelessWidget {
  const LoginApplicationContentStep4Text({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
      ),
      child: Column(
        children: [
          Text(
            WMSLocalizations.i18n(context)!.login_application_step_4_text_1,
            style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              fontSize: 24,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 34,
            ),
            child: Text(
              WMSLocalizations.i18n(context)!.login_application_step_4_text_2,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Text(
            WMSLocalizations.i18n(context)!.login_application_step_4_text_3,
            style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

// 申请内容步骤4按钮
class LoginApplicationContentStep4Button extends StatefulWidget {
  const LoginApplicationContentStep4Button({super.key});

  @override
  State<LoginApplicationContentStep4Button> createState() =>
      _LoginApplicationContentStep4ButtonState();
}

class _LoginApplicationContentStep4ButtonState
    extends State<LoginApplicationContentStep4Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 步骤4按钮点击事件
        context.read<LoginApplicationBloc>().add(Step4ButtonClickEvent());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(44, 167, 176, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        width: 320,
        height: 56,
        margin: EdgeInsets.only(
          top: 40,
          bottom: 80,
        ),
        child: Center(
          child: Text(
            WMSLocalizations.i18n(context)!.login_application_button_4,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
