import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_renewal_bloc.dart';
import '../bloc/login_renewal_model.dart';
import 'login_renewal_content_step_1.dart';
import 'login_renewal_content_step_2.dart';
import 'login_renewal_content_step_3.dart';
import 'login_renewal_content_step_4.dart';

/**
 * 内容：续费-内容
 * 作者：赵士淞
 * 时间：2025/01/13
 */
class LoginRenewalContent extends StatefulWidget {
  const LoginRenewalContent({super.key});

  @override
  State<LoginRenewalContent> createState() => _LoginRenewalContentState();
}

class _LoginRenewalContentState extends State<LoginRenewalContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRenewalBloc, LoginRenewalModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 续费内容标题
            LoginRenewalContentTitle(),
            // 续费内容步骤条
            LoginRenewalContentStepper(),
            // 申请内容
            state.selectedStep == 1
                ? LoginRenewalContentStep1()
                : state.selectedStep == 2
                    ? LoginRenewalContentStep2()
                    : state.selectedStep == 3
                        ? LoginRenewalContentStep3()
                        : state.selectedStep == 4
                            ? LoginRenewalContentStep4()
                            : Container(),
          ],
        );
      },
    );
  }
}

// 续费内容标题
class LoginRenewalContentTitle extends StatelessWidget {
  const LoginRenewalContentTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
      ),
      child: Column(
        children: [
          Container(
            child: Text(
              'RENEWAL',
              style: TextStyle(
                color: Color.fromRGBO(44, 167, 176, 1),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              WMSLocalizations.i18n(context)!.login_renewal_title,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 32,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 续费内容步骤条
class LoginRenewalContentStepper extends StatefulWidget {
  const LoginRenewalContentStepper({super.key});

  @override
  State<LoginRenewalContentStepper> createState() =>
      _LoginRenewalContentStepperState();
}

class _LoginRenewalContentStepperState
    extends State<LoginRenewalContentStepper> {
  // 初始化步骤条部件列表
  List<Widget> _initStepWidgetList(LoginRenewalModel state) {
    // 步骤条列表
    List<Map<String, dynamic>> stepList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!.login_application_step_1
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!.login_application_step_2
      },
      {
        'index': 3,
        'title': WMSLocalizations.i18n(context)!.login_application_step_3
      },
      {
        'index': 4,
        'title': WMSLocalizations.i18n(context)!.login_application_step_4
      },
    ];
    // 步骤条部件列表
    List<Widget> stepWidgetList = [];
    // 循环步骤条列表
    for (var i = 0; i < stepList.length; i++) {
      // 判断是否是第一个
      if (i != 0) {
        // 步骤条部件列表
        stepWidgetList.add(
          Container(
            margin: EdgeInsets.only(
              top: 27,
            ),
            color: Color.fromRGBO(217, 217, 217, 1),
            width: 80,
            height: 1,
          ),
        );
      }
      // 步骤条部件列表
      stepWidgetList.add(
        Container(
          width: 80,
          child: Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: state.selectedStep >= stepList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : Color.fromRGBO(217, 217, 217, 1),
                  borderRadius: BorderRadius.circular(54),
                ),
                child: Center(
                  child: Text(
                    stepList[i]['index'].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  stepList[i]['title'].toString(),
                  style: TextStyle(
                    color: state.selectedStep >= stepList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 1)
                        : Color.fromRGBO(217, 217, 217, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return stepWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _initStepWidgetList(context.read<LoginRenewalBloc>().state),
      ),
    );
  }
}
