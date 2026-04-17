import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../bloc/login_application_bloc.dart';
import '../bloc/login_application_model.dart';
import 'login_application_content_step_1.dart';
import 'login_application_content_step_2.dart';
import 'login_application_content_step_3.dart';
import 'login_application_content_step_4.dart';

/**
 * 内容：申请-内容
 * 作者：赵士淞
 * 时间：2024/12/04
 */
class LoginApplicationContent extends StatefulWidget {
  const LoginApplicationContent({super.key});

  @override
  State<LoginApplicationContent> createState() =>
      _LoginApplicationContentState();
}

class _LoginApplicationContentState extends State<LoginApplicationContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginApplicationBloc, LoginApplicationModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 申请内容标题
            LoginApplicationContentTitle(),
            // 申请内容步骤条
            LoginApplicationContentStepper(),
            // 申请内容
            state.selectedStep == 1
                ? LoginApplicationContentStep1()
                : state.selectedStep == 2
                    ? LoginApplicationContentStep2()
                    : state.selectedStep == 3
                        ? LoginApplicationContentStep3()
                        : state.selectedStep == 4
                            ? LoginApplicationContentStep4()
                            : Container(),
          ],
        );
      },
    );
  }
}

// 申请内容标题
class LoginApplicationContentTitle extends StatelessWidget {
  const LoginApplicationContentTitle({super.key});

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
              'APPLICATION',
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
              WMSLocalizations.i18n(context)!.login_application_title,
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

// 申请内容步骤条
class LoginApplicationContentStepper extends StatefulWidget {
  const LoginApplicationContentStepper({super.key});

  @override
  State<LoginApplicationContentStepper> createState() =>
      _LoginApplicationContentStepperState();
}

class _LoginApplicationContentStepperState
    extends State<LoginApplicationContentStepper> {
  // 初始化步骤条部件列表
  List<Widget> _initStepWidgetList(LoginApplicationModel state) {
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
        children:
            _initStepWidgetList(context.read<LoginApplicationBloc>().state),
      ),
    );
  }
}
