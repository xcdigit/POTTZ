import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../widget/wms_inputbox_widget.dart';
import '../bloc/login_application_bloc.dart';
import '../bloc/login_application_model.dart';

/**
 * 内容：申请-内容-步骤1
 * 作者：赵士淞
 * 时间：2024/12/09
 */
class LoginApplicationContentStep1 extends StatefulWidget {
  const LoginApplicationContentStep1({super.key});

  @override
  State<LoginApplicationContentStep1> createState() =>
      _LoginApplicationContentStep1State();
}

class _LoginApplicationContentStep1State
    extends State<LoginApplicationContentStep1> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 申请内容步骤1文本
        LoginApplicationContentStep1Text(),
        // 申请内容步骤1表单
        LoginApplicationContentStep1Form(),
        // 申请内容步骤1按钮
        LoginApplicationContentStep1Button(),
      ],
    );
  }
}

// 申请内容步骤1文本
class LoginApplicationContentStep1Text extends StatelessWidget {
  const LoginApplicationContentStep1Text({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 40,
      ),
      child: Text(
        WMSLocalizations.i18n(context)!.login_application_enter_form_text,
        style: TextStyle(
          color: Color.fromRGBO(51, 51, 51, 1),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

// 申请内容步骤1表单
class LoginApplicationContentStep1Form extends StatefulWidget {
  const LoginApplicationContentStep1Form({super.key});

  @override
  State<LoginApplicationContentStep1Form> createState() =>
      _LoginApplicationContentStep1FormState();
}

class _LoginApplicationContentStep1FormState
    extends State<LoginApplicationContentStep1Form> {
  // 初始化表单部件列表
  List<Widget> _initFormWidgetList(LoginApplicationModel state) {
    // 表单列表
    List<Map<String, dynamic>> formList = [];
    // 判断页面标识
    if (state.pageFlag == 'once') {
      // 表单列表
      formList = [
        {
          'index': 1,
          'title':
              WMSLocalizations.i18n(context)!.login_application_company_name,
          'isRequire': true,
        },
        {
          'index': 2,
          'title':
              WMSLocalizations.i18n(context)!.login_application_person_charge,
          'isRequire': true,
        },
        {
          'index': 3,
          'title':
              WMSLocalizations.i18n(context)!.login_application_email_address,
          'isRequire': true,
        },
        {
          'index': 4,
          'title':
              WMSLocalizations.i18n(context)!.login_application_phone_number,
          'isRequire': true,
        },
        {
          'index': 5,
          'title':
              WMSLocalizations.i18n(context)!.login_application_campaign_code,
          'isRequire': false,
        },
      ];
    } else if (state.pageFlag == 'again') {
      // 表单列表
      formList = [
        {
          'index': 3,
          'title':
              WMSLocalizations.i18n(context)!.login_application_email_address,
          'isRequire': true,
        },
        {
          'index': 9,
          'title': WMSLocalizations.i18n(context)!.login_application_password,
          'isRequire': true,
        },
      ];
    }
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
                        ? state.companyName
                        : formList[i]['index'] == 2
                            ? state.personCharge
                            : formList[i]['index'] == 3
                                ? state.emailAddress
                                : formList[i]['index'] == 4
                                    ? state.phoneNumber
                                    : formList[i]['index'] == 5
                                        ? state.campaignCode
                                        : formList[i]['index'] == 9
                                            ? state.password
                                            : '',
                    hintText: formList[i]['index'] == 1
                        ? '例）株式会社POTTZ'
                        : formList[i]['index'] == 2
                            ? '例）山田　太郎'
                            : formList[i]['index'] == 3
                                ? '例）POTTZ@mail.com'
                                : formList[i]['index'] == 4
                                    ? '例）0312345678'
                                    : formList[i]['index'] == 5
                                        ? '例）123456789'
                                        : formList[i]['index'] == 9
                                            ? '例）123456'
                                            : '',
                    inputBoxCallBack: (value) {
                      formList[i]['index'] == 1
                          ?
                          // 设置公司名称事件
                          context
                              .read<LoginApplicationBloc>()
                              .add(SetCompanyNameEvent(value))
                          : formList[i]['index'] == 2
                              ?
                              // 设置联系人姓名事件
                              context
                                  .read<LoginApplicationBloc>()
                                  .add(SetPersonChargeEvent(value))
                              : formList[i]['index'] == 3
                                  ?
                                  // 设置电子邮件地址事件
                                  context
                                      .read<LoginApplicationBloc>()
                                      .add(SetEmailAddressEvent(value))
                                  : formList[i]['index'] == 4
                                      ?
                                      // 设置电话号码事件
                                      context
                                          .read<LoginApplicationBloc>()
                                          .add(SetPhoneNumberEvent(value))
                                      : formList[i]['index'] == 5
                                          ?
                                          // 设置活动代码事件
                                          context
                                              .read<LoginApplicationBloc>()
                                              .add(SetCampaignCodeEvent(value))
                                          : formList[i]['index'] == 9
                                              ?
                                              // 设置密码事件
                                              context
                                                  .read<LoginApplicationBloc>()
                                                  .add(SetPasswordEvent(value))
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
        children:
            _initFormWidgetList(context.read<LoginApplicationBloc>().state),
      ),
    );
  }
}

// 申请内容步骤1按钮
class LoginApplicationContentStep1Button extends StatefulWidget {
  const LoginApplicationContentStep1Button({super.key});

  @override
  State<LoginApplicationContentStep1Button> createState() =>
      _LoginApplicationContentStep1ButtonState();
}

class _LoginApplicationContentStep1ButtonState
    extends State<LoginApplicationContentStep1Button> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 步骤1按钮点击事件
        context.read<LoginApplicationBloc>().add(Step1ButtonClickEvent());
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
