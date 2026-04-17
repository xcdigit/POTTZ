import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_application_bloc.dart';
import '../bloc/login_application_model.dart';

/**
 * 内容：申请-内容-步骤2
 * 作者：赵士淞
 * 时间：2024/12/10
 */
class LoginApplicationContentStep2 extends StatefulWidget {
  const LoginApplicationContentStep2({super.key});

  @override
  State<LoginApplicationContentStep2> createState() =>
      _LoginApplicationContentStep2State();
}

class _LoginApplicationContentStep2State
    extends State<LoginApplicationContentStep2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 申请内容步骤2文本
        LoginApplicationContentStep2Text(),
        // 申请内容步骤2标签
        LoginApplicationContentStep2Tab(),
        // 申请内容步骤2内容
        context.read<LoginApplicationBloc>().state.verifyIndex == 1
            ? LoginApplicationContentStep2Content1()
            : context.read<LoginApplicationBloc>().state.verifyIndex == 2
                ? LoginApplicationContentStep2Content2()
                : Container(),
        // 申请内容步骤2代码
        LoginApplicationContentStep2Code(),
        // 申请内容步骤2按钮
        LoginApplicationContentStep2Button(),
      ],
    );
  }
}

// 申请内容步骤2文本
class LoginApplicationContentStep2Text extends StatelessWidget {
  const LoginApplicationContentStep2Text({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
      ),
      child: Column(
        children: [
          Text(
            WMSLocalizations.i18n(context)!
                .login_application_authentication_title,
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
              WMSLocalizations.i18n(context)!
                  .login_application_authentication_text_1,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Text(
            WMSLocalizations.i18n(context)!
                .login_application_authentication_text_2,
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

// 申请内容步骤2标签
class LoginApplicationContentStep2Tab extends StatefulWidget {
  const LoginApplicationContentStep2Tab({super.key});

  @override
  State<LoginApplicationContentStep2Tab> createState() =>
      _LoginApplicationContentStep2TabState();
}

class _LoginApplicationContentStep2TabState
    extends State<LoginApplicationContentStep2Tab> {
  // 初始化标签部件列表
  List<Widget> _initTabWidgetList(LoginApplicationModel state) {
    // 标签列表
    List<Map<String, dynamic>> tabList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!.login_application_verify_tab_1,
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!.login_application_verify_tab_2,
      },
    ];
    // 标签部件列表
    List<Widget> tabWidgetList = [];
    // 循环标签列表
    for (var i = 0; i < tabList.length; i++) {
      // 标签部件列表
      tabWidgetList.add(
        GestureDetector(
          onTap: () {
            // 设置验证指数事件
            context
                .read<LoginApplicationBloc>()
                .add(SetVerifyIndexEvent(tabList[i]['index']));
          },
          child: Container(
            padding: EdgeInsets.only(
              bottom: 3,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: state.verifyIndex == tabList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Text(
              tabList[i]['title'],
              style: TextStyle(
                color: state.verifyIndex == tabList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : Color.fromRGBO(217, 217, 217, 1),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }
    return tabWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
            _initTabWidgetList(context.read<LoginApplicationBloc>().state),
      ),
    );
  }
}

// 申请内容步骤2内容1
class LoginApplicationContentStep2Content1 extends StatefulWidget {
  const LoginApplicationContentStep2Content1({super.key});

  @override
  State<LoginApplicationContentStep2Content1> createState() =>
      _LoginApplicationContentStep2Content1State();
}

class _LoginApplicationContentStep2Content1State
    extends State<LoginApplicationContentStep2Content1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Column(
        children: [
          QrImageView(
            data: 'otpauth://totp/POTTZ:' +
                context
                    .read<LoginApplicationBloc>()
                    .state
                    .applicationTmpData['user_email'] +
                '?secret=' +
                context
                    .read<LoginApplicationBloc>()
                    .state
                    .applicationTmpData['authenticator_key'] +
                '&issuer=POTTZ',
            version: QrVersions.auto,
            size: 200.0,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: Text(
              WMSLocalizations.i18n(context)!
                  .login_application_verify_tab_1_text,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 申请内容步骤2内容2
class LoginApplicationContentStep2Content2 extends StatefulWidget {
  const LoginApplicationContentStep2Content2({super.key});

  @override
  State<LoginApplicationContentStep2Content2> createState() =>
      _LoginApplicationContentStep2Content2State();
}

class _LoginApplicationContentStep2Content2State
    extends State<LoginApplicationContentStep2Content2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context
                .read<LoginApplicationBloc>()
                .state
                .applicationTmpData['user_email'],
            style: TextStyle(
              color: Color.fromRGBO(51, 51, 51, 1),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
            ),
          ),
          GestureDetector(
            onTap: () {
              // 发送邮件点击事件
              context.read<LoginApplicationBloc>().add(SendMailClickEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(125, 125, 125, 0.1),
                border: Border.all(
                  color: Color.fromRGBO(125, 125, 125, 1),
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              width: 125,
              height: 42,
              margin: EdgeInsets.only(
                left: 30,
              ),
              child: Center(
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .login_application_verify_tab_2_button,
                  style: TextStyle(
                    color: Color.fromRGBO(125, 125, 125, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 申请内容步骤2代码
class LoginApplicationContentStep2Code extends StatefulWidget {
  const LoginApplicationContentStep2Code({super.key});

  @override
  State<LoginApplicationContentStep2Code> createState() =>
      _LoginApplicationContentStep2CodeState();
}

class _LoginApplicationContentStep2CodeState
    extends State<LoginApplicationContentStep2Code> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Material(
        color: Colors.white,
        child: VerificationCode(
          length: 6,
          fullBorder: true,
          fillColor: Colors.white,
          digitsOnly: true,
          margin: EdgeInsets.only(
            right: 16,
            left: 16,
          ),
          onCompleted: (String value) {
            // 设置验证码事件
            context.read<LoginApplicationBloc>().add(SetVerifyCodeEvent(value));
          },
          onEditing: (bool value) {
            if (!value) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
    );
  }
}

// 申请内容步骤2按钮
class LoginApplicationContentStep2Button extends StatefulWidget {
  const LoginApplicationContentStep2Button({super.key});

  @override
  State<LoginApplicationContentStep2Button> createState() =>
      _LoginApplicationContentStep2ButtonState();
}

class _LoginApplicationContentStep2ButtonState
    extends State<LoginApplicationContentStep2Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 步骤2按钮点击事件
        context.read<LoginApplicationBloc>().add(Step2ButtonClickEvent());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
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
            WMSLocalizations.i18n(context)!.login_application_button_2,
            style: TextStyle(
              color: Color.fromRGBO(44, 167, 176, 1),
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
