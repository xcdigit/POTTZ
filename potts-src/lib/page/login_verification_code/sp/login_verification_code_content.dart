import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_verification_code_bloc.dart';
import '../bloc/login_verification_code_model.dart';

/**
 * 内容：登录验证码-内容
 * 作者：赵士淞
 * 时间：2024/12/13
 */
class LoginVerificationCodeContent extends StatefulWidget {
  const LoginVerificationCodeContent({super.key});

  @override
  State<LoginVerificationCodeContent> createState() =>
      _LoginVerificationCodeContentState();
}

class _LoginVerificationCodeContentState
    extends State<LoginVerificationCodeContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginVerificationCodeBloc, LoginVerificationCodeModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              // 登录验证码内容文本
              LoginVerificationCodeContentText(),
              // 登录验证码内容标签
              LoginVerificationCodeContentTab(),
              // 登录验证码内容内容
              context.read<LoginVerificationCodeBloc>().state.verifyIndex == 1
                  ? LoginVerificationCodeContentContent1()
                  : context
                              .read<LoginVerificationCodeBloc>()
                              .state
                              .verifyIndex ==
                          2
                      ? LoginVerificationCodeContentContent2()
                      : Container(),
              // 登录验证码内容代码
              LoginVerificationCodeContentCode(),
              // 登录验证码内容按钮
              LoginVerificationCodeContentButton(),
            ],
          ),
        );
      },
    );
  }
}

// 登录验证码内容文本
class LoginVerificationCodeContentText extends StatelessWidget {
  const LoginVerificationCodeContentText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
      ),
      child: Column(
        children: [
          Text(
            WMSLocalizations.i18n(context)!.login_verification_code_text_title,
            style: TextStyle(
              color: Color.fromRGBO(6, 14, 15, 1),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.none,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            child: Text(
              WMSLocalizations.i18n(context)!
                  .login_verification_code_text_content,
              style: TextStyle(
                color: Color.fromRGBO(156, 156, 156, 1),
                fontSize: 12,
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

// 登录验证码内容标签
class LoginVerificationCodeContentTab extends StatefulWidget {
  const LoginVerificationCodeContentTab({super.key});

  @override
  State<LoginVerificationCodeContentTab> createState() =>
      _LoginVerificationCodeContentTabState();
}

class _LoginVerificationCodeContentTabState
    extends State<LoginVerificationCodeContentTab> {
  // 初始化标签部件列表
  List<Widget> _initTabWidgetList(LoginVerificationCodeModel state) {
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
                .read<LoginVerificationCodeBloc>()
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
                fontSize: 14,
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
            _initTabWidgetList(context.read<LoginVerificationCodeBloc>().state),
      ),
    );
  }
}

// 登录验证码内容内容1
class LoginVerificationCodeContentContent1 extends StatefulWidget {
  const LoginVerificationCodeContentContent1({super.key});

  @override
  State<LoginVerificationCodeContentContent1> createState() =>
      _LoginVerificationCodeContentContent1State();
}

class _LoginVerificationCodeContentContent1State
    extends State<LoginVerificationCodeContentContent1> {
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
          //       context
          //           .read<LoginVerificationCodeBloc>()
          //           .state
          //           .userData['email'] +
          //       '?secret=' +
          //       context
          //           .read<LoginVerificationCodeBloc>()
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

// 登录验证码内容内容2
class LoginVerificationCodeContentContent2 extends StatefulWidget {
  const LoginVerificationCodeContentContent2({super.key});

  @override
  State<LoginVerificationCodeContentContent2> createState() =>
      _LoginVerificationCodeContentContent2State();
}

class _LoginVerificationCodeContentContent2State
    extends State<LoginVerificationCodeContentContent2> {
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
            context.read<LoginVerificationCodeBloc>().state.userData['email'],
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
              context
                  .read<LoginVerificationCodeBloc>()
                  .add(SendMailClickEvent());
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

// 登录验证码内容代码
class LoginVerificationCodeContentCode extends StatefulWidget {
  const LoginVerificationCodeContentCode({super.key});

  @override
  State<LoginVerificationCodeContentCode> createState() =>
      _LoginVerificationCodeContentCodeState();
}

class _LoginVerificationCodeContentCodeState
    extends State<LoginVerificationCodeContentCode> {
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
            right: 1,
            left: 1,
          ),
          onCompleted: (String value) {
            // 设置验证码事件
            context
                .read<LoginVerificationCodeBloc>()
                .add(SetVerifyCodeEvent(value));
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

// 登录验证码内容按钮
class LoginVerificationCodeContentButton extends StatefulWidget {
  const LoginVerificationCodeContentButton({super.key});

  @override
  State<LoginVerificationCodeContentButton> createState() =>
      _LoginVerificationCodeContentButtonState();
}

class _LoginVerificationCodeContentButtonState
    extends State<LoginVerificationCodeContentButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 发送按钮点击事件
        context.read<LoginVerificationCodeBloc>().add(SendButtonClickEvent());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        width: 300,
        height: 56,
        margin: EdgeInsets.only(
          top: 40,
          bottom: 80,
        ),
        child: Center(
          child: Text(
            WMSLocalizations.i18n(context)!.login_verification_code_button,
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
