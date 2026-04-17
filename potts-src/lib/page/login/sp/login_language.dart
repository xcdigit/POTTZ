import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/home/bloc/home_menu_bloc.dart';
import 'package:wms/page/home/bloc/home_menu_model.dart';
import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/wms_state.dart';

class LoginLanguage extends StatefulWidget {
  LoginLanguage({super.key});

  @override
  State<LoginLanguage> createState() => _LoginLanguageState();
}

class _LoginLanguageState extends State<LoginLanguage> {
  // 语言显示
  bool _langFlag = false;
  // 繁体选中
  bool _twhFlag = false;
  // 显示自定义多语言弹窗
  _showCustomLanguageDialog(HomeMenuModel state) {
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
              context.read<HomeMenuBloc>().add(
                  SelectedLanguageChangeEvent(state.languageList[i]['id']));

              _twhFlag = i == 3 ? true : false;
              // 隐藏语言
              _langFlag = false;
            },
            child: Container(
              width: 100,
              height: 28,
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
                    : null,
              ),
              child: Center(
                child: Text(
                  state.languageList[i]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: state.languageList[i]['id'] == state.selectedLanguage
                        ? Color.fromRGBO(255, 255, 255, 1)
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
                top: 50,
                right: 20,
                child: Container(
                  width: 100,
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
    ).then((value) {
      setState(() {
        _langFlag = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return GestureDetector(
          onPanDown: (details) {
            // 显示自定义多语言弹窗
            _langFlag = true;
            _showCustomLanguageDialog(state);
          },
          child: Container(
            width: StoreProvider.of<WMSState>(context).state.login!
                ? (MediaQuery.of(context).size.width <
                        Config.WEB_MINI_WIDTH_LIMIT
                    ? 0
                    : null)
                : null,
            height: 34,
            margin: EdgeInsets.only(top: 10, right: _twhFlag ? 20 : 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Image.asset(
                    WMSICons.HOME_HEAD_LANGUAGE,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                    color: Color.fromRGBO(102, 199, 206, 1),
                  ),
                ),
                _langFlag
                    ? Container(
                        padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                        child: Text(
                          WMSLocalizations.i18n(context)!.home_head_language,
                          style: TextStyle(
                            color: Color.fromRGBO(102, 199, 206, 1),
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
