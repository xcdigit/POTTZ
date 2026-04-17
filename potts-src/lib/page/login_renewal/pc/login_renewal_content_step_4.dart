import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_renewal_bloc.dart';

/**
 * 内容：续费-内容-步骤4
 * 作者：赵士淞
 * 时间：2025/01/14
 */
class LoginRenewalContentStep4 extends StatefulWidget {
  const LoginRenewalContentStep4({super.key});

  @override
  State<LoginRenewalContentStep4> createState() =>
      _LoginRenewalContentStep4State();
}

class _LoginRenewalContentStep4State extends State<LoginRenewalContentStep4> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 续费内容步骤4文本
        LoginRenewalContentStep4Text(),
        // 续费内容步骤4按钮
        LoginRenewalContentStep4Button(),
      ],
    );
  }
}

// 续费内容步骤4文本
class LoginRenewalContentStep4Text extends StatelessWidget {
  const LoginRenewalContentStep4Text({super.key});

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
        ],
      ),
    );
  }
}

// 续费内容步骤4按钮
class LoginRenewalContentStep4Button extends StatefulWidget {
  const LoginRenewalContentStep4Button({super.key});

  @override
  State<LoginRenewalContentStep4Button> createState() =>
      _LoginRenewalContentStep4ButtonState();
}

class _LoginRenewalContentStep4ButtonState
    extends State<LoginRenewalContentStep4Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 步骤4按钮点击事件
        context.read<LoginRenewalBloc>().add(Step4ButtonClickEvent());
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
