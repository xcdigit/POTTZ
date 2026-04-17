import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../bloc/login_application_bloc.dart';
import '../bloc/login_application_model.dart';

/**
 * 内容：申请-头部
 * 作者：赵士淞
 * 时间：2024/12/04
 */
class LoginApplicationHead extends StatefulWidget {
  const LoginApplicationHead({super.key});

  @override
  State<LoginApplicationHead> createState() => _LoginApplicationHeadState();
}

class _LoginApplicationHeadState extends State<LoginApplicationHead> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginApplicationBloc, LoginApplicationModel>(
      builder: (context, state) {
        return Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 申请头部LOGO
              LoginApplicationHeadLogo(),
              // 申请头部多语言
              LoginApplicationHeadLanguage(),
            ],
          ),
        );
      },
    );
  }
}

// 申请头部LOGO
class LoginApplicationHeadLogo extends StatelessWidget {
  const LoginApplicationHeadLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      WMSICons.HOME_HEAD_LOGO,
      width: 284,
      height: 90,
      color: Color.fromRGBO(44, 167, 176, 1),
      fit: BoxFit.contain,
      repeat: ImageRepeat.noRepeat,
    );
  }
}

// 申请头部多语言
class LoginApplicationHeadLanguage extends StatefulWidget {
  const LoginApplicationHeadLanguage({super.key});

  @override
  State<LoginApplicationHeadLanguage> createState() =>
      _LoginApplicationHeadLanguageState();
}

class _LoginApplicationHeadLanguageState
    extends State<LoginApplicationHeadLanguage> {
  // 显示自定义多语言弹窗
  void _showCustomLanguageDialog(LoginApplicationModel state) {
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
              context.read<LoginApplicationBloc>().add(
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
        _showCustomLanguageDialog(context.read<LoginApplicationBloc>().state);
      },
      child: Container(
        height: 90,
        margin: EdgeInsets.only(
          right: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              WMSLocalizations.i18n(context)!.home_head_language,
              style: TextStyle(
                color: Color.fromRGBO(51, 51, 51, 1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            Image.asset(
              WMSICons.HOME_HEAD_MORE,
              width: 20,
              color: Color.fromRGBO(51, 51, 51, 1),
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
            ),
          ],
        ),
      ),
    );
  }
}
