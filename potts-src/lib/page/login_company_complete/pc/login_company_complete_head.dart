import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../bloc/login_company_complete_bloc.dart';
import '../bloc/login_company_complete_model.dart';

/**
 * 内容：登录公司完整性-头部
 * 作者：赵士淞
 * 时间：2024/12/16
 */
class LoginCompanyCompleteHead extends StatefulWidget {
  const LoginCompanyCompleteHead({super.key});

  @override
  State<LoginCompanyCompleteHead> createState() =>
      _LoginCompanyCompleteHeadState();
}

class _LoginCompanyCompleteHeadState extends State<LoginCompanyCompleteHead> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCompanyCompleteBloc, LoginCompanyCompleteModel>(
      builder: (context, state) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 登录公司完整性头部LOGO
              LoginCompanyCompleteHeadLogo(),
              // 登录公司完整性头部多语言
              LoginCompanyCompleteHeadLanguage(),
            ],
          ),
        );
      },
    );
  }
}

// 登录公司完整性头部LOGO
class LoginCompanyCompleteHeadLogo extends StatelessWidget {
  const LoginCompanyCompleteHeadLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 40,
      ),
      child: Image.asset(
        WMSICons.HOME_HEAD_LOGO,
        width: 284,
        height: 90,
        color: Colors.white,
        fit: BoxFit.contain,
        repeat: ImageRepeat.noRepeat,
      ),
    );
  }
}

// 登录公司完整性头部多语言
class LoginCompanyCompleteHeadLanguage extends StatefulWidget {
  const LoginCompanyCompleteHeadLanguage({super.key});

  @override
  State<LoginCompanyCompleteHeadLanguage> createState() =>
      _LoginCompanyCompleteHeadLanguageState();
}

class _LoginCompanyCompleteHeadLanguageState
    extends State<LoginCompanyCompleteHeadLanguage> {
  // 显示自定义多语言弹窗
  void _showCustomLanguageDialog(LoginCompanyCompleteModel state) {
    // 语言组件列表
    List<Widget> _languageWidgetList() {
      // 组件列表
      List<Widget> widgetList = [];
      // 循环语言列表
      for (int i = 0; i < state.languageList.length; i++) {
        // 组件列表新增
        widgetList.add(
          GestureDetector(
            onTap: () {
              // 选中语言变更事件
              context.read<LoginCompanyCompleteBloc>().add(
                  SelectedLanguageChangeEvent(state.languageList[i]['id']));
            },
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: i == state.languageList.length - 1
                      ? Radius.circular(5)
                      : Radius.circular(0),
                  bottomRight: i == state.languageList.length - 1
                      ? Radius.circular(5)
                      : Radius.circular(0),
                ),
                border: Border.all(
                  width: 0.5,
                  color: Color.fromRGBO(102, 199, 206, 1),
                ),
                color: state.languageList[i]['id'] == state.selectedLanguage
                    ? Color.fromRGBO(102, 199, 206, 1)
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  state.languageList[i]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: state.languageList[i]['id'] == state.selectedLanguage
                        ? Colors.white
                        : Color.fromRGBO(102, 199, 206, 1),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return widgetList;
    }

    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(255, 255, 255, 0),
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: 68,
                right: 44,
                child: Container(
                  width: 138,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                      width: 0.5,
                      color: Color.fromRGBO(102, 199, 206, 1),
                    ),
                  ),
                  child: Column(
                    children: _languageWidgetList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        // 显示自定义多语言弹窗
        _showCustomLanguageDialog(
            context.read<LoginCompanyCompleteBloc>().state);
      },
      child: Container(
        height: 34,
        margin: EdgeInsets.only(
          right: 40,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              WMSICons.HOME_HEAD_LANGUAGE,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
            ),
            Text(
              WMSLocalizations.i18n(context)!.home_head_language,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            Image.asset(
              WMSICons.HOME_HEAD_MORE,
              width: 20,
              color: Colors.white,
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
            ),
          ],
        ),
      ),
    );
  }
}
