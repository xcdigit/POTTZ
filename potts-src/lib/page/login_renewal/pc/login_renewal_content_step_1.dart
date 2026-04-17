import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../widget/wms_inputbox_widget.dart';
import '../bloc/login_renewal_bloc.dart';
import '../bloc/login_renewal_model.dart';

/**
 * 内容：续费-内容-步骤1
 * 作者：赵士淞
 * 时间：2025/01/13
 */
class LoginRenewalContentStep1 extends StatefulWidget {
  const LoginRenewalContentStep1({super.key});

  @override
  State<LoginRenewalContentStep1> createState() =>
      _LoginRenewalContentStep1State();
}

class _LoginRenewalContentStep1State extends State<LoginRenewalContentStep1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 续费内容步骤1表单
        LoginRenewalContentStep1Form(),
        // 续费内容步骤1按钮
        LoginRenewalContentStep1Button(),
      ],
    );
  }
}

// 续费内容步骤1表单
class LoginRenewalContentStep1Form extends StatefulWidget {
  const LoginRenewalContentStep1Form({super.key});

  @override
  State<LoginRenewalContentStep1Form> createState() =>
      _LoginRenewalContentStep1FormState();
}

class _LoginRenewalContentStep1FormState
    extends State<LoginRenewalContentStep1Form> {
  // 初始化表单部件列表
  List<Widget> _initFormWidgetList(LoginRenewalModel state) {
    // 表单列表
    List<Map<String, dynamic>> formList = [
      {
        'index': 1,
        'title':
            WMSLocalizations.i18n(context)!.login_application_email_address,
        'isRequire': true,
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!.login_application_password,
        'isRequire': true,
      },
      // {
      //   'index': 3,
      //   'title':
      //       WMSLocalizations.i18n(context)!.login_application_campaign_code,
      //   'isRequire': false,
      // },
    ];
    // 表单部件列表
    List<Widget> formWidgetList = [];
    // 循环表单列表
    for (var i = 0; i < formList.length; i++) {
      // 表单部件列表
      formWidgetList.add(
        Container(
          margin: EdgeInsets.only(
            top: i == 0 ? 0 : 40,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  right: 8,
                ),
                child: Text(
                  formList[i]['title'],
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: formList[i]['isRequire']
                      ? Color.fromRGBO(255, 175, 19, 1)
                      : Color.fromRGBO(151, 151, 151, 1),
                ),
                width: 41,
                height: 25,
                margin: EdgeInsets.only(
                  right: 40,
                ),
                child: Center(
                  child: Text(
                    formList[i]['isRequire']
                        ? WMSLocalizations.i18n(context)!
                            .login_application_required
                        : WMSLocalizations.i18n(context)!
                            .login_application_optional,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              Container(
                width: 416,
                child: Material(
                  child: WMSInputboxWidget(
                    backgroundColor: Color.fromRGBO(245, 245, 245, 1),
                    borderColor: Colors.transparent,
                    text: formList[i]['index'] == 1
                        ? state.emailAddress
                        : formList[i]['index'] == 2
                            ? state.password
                            : formList[i]['index'] == 3
                                ? state.campaignCode
                                : '',
                    hintText: formList[i]['index'] == 1
                        ? '例）POTTZ@mail.com'
                        : formList[i]['index'] == 2
                            ? '例）123456'
                            : formList[i]['index'] == 3
                                ? '例）123456789'
                                : '',
                    inputBoxCallBack: (value) {
                      formList[i]['index'] == 1
                          ?
                          // 设置电子邮件地址事件
                          context
                              .read<LoginRenewalBloc>()
                              .add(SetEmailAddressEvent(value))
                          : formList[i]['index'] == 2
                              ?
                              // 设置密码事件
                              context
                                  .read<LoginRenewalBloc>()
                                  .add(SetPasswordEvent(value))
                              : formList[i]['index'] == 3
                                  ?
                                  // 设置活动代码事件
                                  context
                                      .read<LoginRenewalBloc>()
                                      .add(SetCampaignCodeEvent(value))
                                  : null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return formWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 639,
      margin: EdgeInsets.only(
        top: 80,
        bottom: 80,
      ),
      child: Column(
        children: _initFormWidgetList(context.read<LoginRenewalBloc>().state),
      ),
    );
  }
}

class LoginRenewalContentStep1Button extends StatefulWidget {
  const LoginRenewalContentStep1Button({super.key});

  @override
  State<LoginRenewalContentStep1Button> createState() =>
      _LoginRenewalContentStep1ButtonState();
}

// 续费内容步骤1按钮
class _LoginRenewalContentStep1ButtonState
    extends State<LoginRenewalContentStep1Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 步骤1按钮点击事件
        context.read<LoginRenewalBloc>().add(Step1ButtonClickEvent());
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
          bottom: 80,
        ),
        child: Center(
          child: Text(
            WMSLocalizations.i18n(context)!.login_application_button_1,
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
