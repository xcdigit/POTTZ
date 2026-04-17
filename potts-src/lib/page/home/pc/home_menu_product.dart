import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../widget/wms_dialog_widget.dart';
import '../../../widget/wms_inputbox_concise_widget.dart';
import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_item.dart';
import '../bloc/home_menu_model.dart';

// 菜单商品 OverlayEntry
OverlayEntry? menuProductOverlayEntry;
// 菜单商品显示标记
bool menuProductShowFlag = false;

class HomeMenuProduct {
  // 显示
  static void show({
    required BuildContext context,
    required MenuItem myself,
  }) {
    // 判断菜单商品显示标记
    if (menuProductShowFlag) {
      // 移除 OverlayEntry
      menuProductOverlayEntry!.remove();
    } else {
      // 菜单商品显示标记
      menuProductShowFlag = true;
    }

    HomeMenuBloc bloc = context.read<HomeMenuBloc>();
    // 创建 OverlayEntry
    menuProductOverlayEntry = OverlayEntry(
      builder: (context) {
        return BlocProvider<HomeMenuBloc>.value(
          value: bloc,
          child: HomeMenuProductContent(
            myself: myself,
          ),
        );
      },
    );
    // 插入到 Overlay 中显示 OverlayEntry
    Overlay.of(context).insert(menuProductOverlayEntry!);
  }

  // 隐藏
  static void hide() {
    // 判断菜单商品显示标记
    if (menuProductShowFlag) {
      // 移除 OverlayEntry
      menuProductOverlayEntry!.remove();
      // 菜单商品显示标记
      menuProductShowFlag = false;
    }
  }
}

// 首页框架菜单商品内容
// ignore: must_be_immutable
class HomeMenuProductContent extends StatefulWidget {
  MenuItem myself;
  HomeMenuProductContent({super.key, required this.myself});

  @override
  State<HomeMenuProductContent> createState() => _HomeMenuProductContentState();
}

class _HomeMenuProductContentState extends State<HomeMenuProductContent> {
  @override
  Widget build(BuildContext context) {
    // 初始化商品信息表单
    List<Widget> _initBasicForm() {
      return [
        // 商品コード/JANCD
        FractionallySizedBox(
          widthFactor: 1.0,
          child: Container(
            height: 72,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  child: Text(
                    WMSLocalizations.i18n(context)!
                        .home_menu_product_code_or_jan_cd,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                WMSInputboxConciseWidget(
                  text:
                      context.read<HomeMenuBloc>().state.menuProductCodeOrJanCd,
                  inputBoxCallBack: (value) async {
                    // 设置菜单商品编码/JANCD事件
                    context
                        .read<HomeMenuBloc>()
                        .add(SetMenuProductCodeOrJanCdEvent(value));
                  },
                ),
              ],
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.35,
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            onPressed: () async {
              // 检查菜单商品编码/JANCD
              String result = await context
                  .read<HomeMenuBloc>()
                  .checkMenuProductCodeOrJanCd(context);
              // 判断结果
              if (result == '') {
                // 打开商品信息页面事件
                context
                    .read<HomeMenuBloc>()
                    .add(ChangeMenuProductEvent(widget.myself, context));
                // 移除 OverlayEntry
                menuProductOverlayEntry!.remove();
                // 菜单商品显示标记
                menuProductShowFlag = false;
              } else if (result == 'no-data') {
                // 移除 OverlayEntry
                menuProductOverlayEntry!.remove();
                // 菜单商品显示标记
                menuProductShowFlag = false;
                // 消息提示
                HomeMenuBloc bloc = context.read<HomeMenuBloc>();
                showDialog(
                  context: context,
                  builder: (context) {
                    return BlocProvider<HomeMenuBloc>.value(
                      value: bloc,
                      child: BlocBuilder<HomeMenuBloc, HomeMenuModel>(
                        builder: (context, state) {
                          return WMSDiaLogWidget(
                            titleText: WMSLocalizations.i18n(context)!
                                .login_tip_title_modify_pwd_text,
                            contentText: WMSLocalizations.i18n(context)!
                                .did_you_find_the_item_master,
                            buttonLeftText:
                                WMSLocalizations.i18n(context)!.app_cancel,
                            buttonRightText:
                                WMSLocalizations.i18n(context)!.app_ok,
                            onPressedLeft: () {
                              // 关闭弹窗
                              Navigator.pop(context);
                            },
                            onPressedRight: () {
                              // 关闭弹窗
                              Navigator.pop(context);
                              // 打开新增商品页面事件
                              context
                                  .read<HomeMenuBloc>()
                                  .add(OpenAddProductPageEvent());
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
            child: Text(
              WMSLocalizations.i18n(context)!.app_ok,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(44, 167, 176, 1),
                height: 1.28,
              ),
            ),
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.35,
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
            onPressed: () {
              // 移除 OverlayEntry
              menuProductOverlayEntry!.remove();
              // 菜单商品显示标记
              menuProductShowFlag = false;
            },
            child: Text(
              WMSLocalizations.i18n(context)!.app_crows,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(44, 167, 176, 1),
                height: 1.28,
              ),
            ),
          ),
        ),
      ];
    }

    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) => Container(
        child: Positioned(
          top: 164,
          left: 384,
          child: Container(
            width: 600,
            height: 220,
            padding: EdgeInsets.fromLTRB(55, 40, 55, 40),
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 167, 176, 1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Scaffold(
              backgroundColor: Color.fromRGBO(44, 167, 176, 1),
              body: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: _initBasicForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
