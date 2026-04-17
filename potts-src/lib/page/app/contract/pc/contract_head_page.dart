import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/app/contract/bloc/contract_bloc.dart';
import 'package:wms/page/app/contract/bloc/contract_model.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/wms_state.dart';

/**
 * 内容：解约首页框架头部
 * 作者：穆政道
 * 时间：2023/12/15
 */
class ContractHeadPage extends StatefulWidget {
  ContractHeadPage({super.key});

  @override
  State<ContractHeadPage> createState() => _ContractHeadPageState();
}

class _ContractHeadPageState extends State<ContractHeadPage> {
  @override
  Widget build(BuildContext context) {
    // 整体
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(44, 167, 176, 1),
      ),
      child: Stack(
        children: [
          // LOGO
          Positioned(
            left: 40,
            top: 5,
            bottom: 5,
            child: HomeHeadLogo(),
          ),
          // 下拉选择区域
          Positioned(
            right: 40,
            top: 33,
            bottom: 33,
            child: Row(
              children: [
                // 多语言区域
                ContractHeadLanguage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 首页框架头部LOGO
class HomeHeadLogo extends StatelessWidget {
  const HomeHeadLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      WMSICons.HOME_HEAD_LOGO,
      width: 284,
      height: 90,
      fit: BoxFit.contain,
      repeat: ImageRepeat.noRepeat,
    );
  }
}

// 首页框架头部多语言
class ContractHeadLanguage extends StatefulWidget {
  ContractHeadLanguage({super.key});

  @override
  State<ContractHeadLanguage> createState() => _ContractHeadLanguageState();
}

class _ContractHeadLanguageState extends State<ContractHeadLanguage> {
  // 显示自定义多语言弹窗
  _showCustomLanguageDialog(ContractModel state) {
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
              context.read<ContractBloc>().add(
                  SelectedLanguageChangeEvent(state.languageList[i]['id']));
            },
            child: Container(
              width: 138,
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
    return BlocBuilder<ContractBloc, ContractModel>(
      builder: (context, state) {
        return GestureDetector(
          onPanDown: (details) {
            // 显示自定义多语言弹窗
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
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Image.asset(
                    WMSICons.HOME_HEAD_LANGUAGE,
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                  child: Text(
                    WMSLocalizations.i18n(context)!.home_head_language,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                  child: Image.asset(
                    WMSICons.HOME_HEAD_MORE,
                    width: 20,
                    height: 32,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
