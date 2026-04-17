import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_renewal_bloc.dart';
import '../bloc/login_renewal_model.dart';

/**
 * 内容：续费-内容-步骤2
 * 作者：赵士淞
 * 时间：2025/01/13
 */
class LoginRenewalContentStep2 extends StatefulWidget {
  const LoginRenewalContentStep2({super.key});

  @override
  State<LoginRenewalContentStep2> createState() =>
      _LoginRenewalContentStep2State();
}

class _LoginRenewalContentStep2State extends State<LoginRenewalContentStep2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 续费内容步骤2文本
        LoginRenewalContentStep2Text(),
        // 续费内容步骤2标签
        LoginRenewalContentStep2Tab(),
        // 续费内容步骤2内容
        context.read<LoginRenewalBloc>().state.verifyIndex == 1
            ? LoginRenewalContentStep2Content1()
            : context.read<LoginRenewalBloc>().state.verifyIndex == 2
                ? LoginRenewalContentStep2Content2()
                : Container(),
        // 续费内容步骤2代码
        LoginRenewalContentStep2Code(),
        // 续费内容步骤2按钮
        LoginRenewalContentStep2Button(),
      ],
    );
  }
}

// 续费内容步骤2文本
class LoginRenewalContentStep2Text extends StatelessWidget {
  const LoginRenewalContentStep2Text({super.key});

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

// 续费内容步骤2标签
class LoginRenewalContentStep2Tab extends StatefulWidget {
  const LoginRenewalContentStep2Tab({super.key});

  @override
  State<LoginRenewalContentStep2Tab> createState() =>
      _LoginRenewalContentStep2TabState();
}

class _LoginRenewalContentStep2TabState
    extends State<LoginRenewalContentStep2Tab> {
  // 初始化标签部件列表
  List<Widget> _initTabWidgetList(LoginRenewalModel state) {
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
                .read<LoginRenewalBloc>()
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
        children: _initTabWidgetList(context.read<LoginRenewalBloc>().state),
      ),
    );
  }
}

// 续费内容步骤2内容1
class LoginRenewalContentStep2Content1 extends StatefulWidget {
  const LoginRenewalContentStep2Content1({super.key});

  @override
  State<LoginRenewalContentStep2Content1> createState() =>
      _LoginRenewalContentStep2Content1State();
}

class _LoginRenewalContentStep2Content1State
    extends State<LoginRenewalContentStep2Content1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Column(
        children: [
          // QrImageView(
          //   data: 'otpauth://totp/POTTZ:' +
          //       context.read<LoginRenewalBloc>().state.userData['email'] +
          //       '?secret=' +
          //       context
          //           .read<LoginRenewalBloc>()
          //           .state
          //           .userData['authenticator_key'] +
          //       '&issuer=POTTZ',
          //   version: QrVersions.auto,
          //   size: 200.0,
          // ),
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

// 续费内容步骤2内容2
class LoginRenewalContentStep2Content2 extends StatefulWidget {
  const LoginRenewalContentStep2Content2({super.key});

  @override
  State<LoginRenewalContentStep2Content2> createState() =>
      _LoginRenewalContentStep2Content2State();
}

class _LoginRenewalContentStep2Content2State
    extends State<LoginRenewalContentStep2Content2> {
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
            context.read<LoginRenewalBloc>().state.userData['email'],
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
              context.read<LoginRenewalBloc>().add(SendMailClickEvent());
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

// 续费内容步骤2代码
class LoginRenewalContentStep2Code extends StatefulWidget {
  const LoginRenewalContentStep2Code({super.key});

  @override
  State<LoginRenewalContentStep2Code> createState() =>
      _LoginRenewalContentStep2CodeState();
}

class _LoginRenewalContentStep2CodeState
    extends State<LoginRenewalContentStep2Code> {
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
            context.read<LoginRenewalBloc>().add(SetVerifyCodeEvent(value));
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

// 续费内容步骤2按钮
class LoginRenewalContentStep2Button extends StatefulWidget {
  const LoginRenewalContentStep2Button({super.key});

  @override
  State<LoginRenewalContentStep2Button> createState() =>
      _LoginRenewalContentStep2ButtonState();
}

class _LoginRenewalContentStep2ButtonState
    extends State<LoginRenewalContentStep2Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 步骤2按钮点击事件
        context.read<LoginRenewalBloc>().add(Step2ButtonClickEvent());
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
