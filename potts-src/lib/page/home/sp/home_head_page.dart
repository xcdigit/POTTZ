import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../common/config/config.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/current_flag_reducer.dart';
import '../../../redux/menu_expand_reducer.dart';
import '../../../redux/wms_state.dart';
import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_model.dart';
import 'home_menu_children.dart';
import 'home_menu_product.dart';

/**
 * 内容：首页框架头部
 * 作者：赵士淞
 * 时间：2023/10/16
 */
class HomeHeadPage extends StatefulWidget {
  const HomeHeadPage({super.key});

  @override
  State<HomeHeadPage> createState() => _HomeHeadPageState();
}

class _HomeHeadPageState extends State<HomeHeadPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 88,
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
          child: Stack(
            children: [
              Visibility(
                visible: GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .last
                        .matchedLocation ==
                    '/',
                child: Positioned(
                  left: 0,
                  bottom: 0,
                  child: HomeHeadMenu(),
                ),
              ),
              Visibility(
                visible: GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .last
                        .matchedLocation !=
                    '/',
                child: Positioned(
                  left: 0,
                  bottom: 0,
                  child: HomeHeadReturn(),
                ),
              ),
              Visibility(
                visible: GoRouter.of(context)
                        .routerDelegate
                        .currentConfiguration
                        .last
                        .matchedLocation !=
                    '/',
                child: Positioned(
                  right: (MediaQuery.of(context).size.width - 150) / 2,
                  bottom: 0,
                  child: HomeHeadTitle(),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  child: Row(
                    children: [
                      Visibility(
                        visible: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .last
                                .matchedLocation ==
                            '/',
                        child: HomeHeadNotice(),
                      ),
                      HomeHeadUser(),
                      Visibility(
                        visible: GoRouter.of(context)
                                .routerDelegate
                                .currentConfiguration
                                .last
                                .matchedLocation ==
                            '/',
                        child: HomeHeadLanguage(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 首页框架头部菜单
class HomeHeadMenu extends StatefulWidget {
  const HomeHeadMenu({super.key});

  @override
  State<HomeHeadMenu> createState() => _HomeHeadMenuState();
}

class _HomeHeadMenuState extends State<HomeHeadMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 持久化状态更新
        StoreProvider.of<WMSState>(context).dispatch(RefreshMenuExpandAction(
            !StoreProvider.of<WMSState>(context).state.menuExpand));
        // 隐藏菜单子级
        HomeMenuChildren.hide();
        // 隐藏菜单商品
        HomeMenuProduct.hide();
      },
      child: Container(
        height: 56,
        padding: EdgeInsets.fromLTRB(18, 8, 0, 8),
        child: Image.asset(
          StoreProvider.of<WMSState>(context).state.menuExpand
              ? WMSICons.HOME_MENU_CLOSE
              : WMSICons.HOME_MENU_OPEN,
          color: Color.fromRGBO(255, 255, 255, 1),
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          repeat: ImageRepeat.noRepeat,
        ),
      ),
    );
  }
}

// 首页框架头部标题
class HomeHeadTitle extends StatefulWidget {
  const HomeHeadTitle({super.key});

  @override
  State<HomeHeadTitle> createState() => _HomeHeadTitleState();
}

class _HomeHeadTitleState extends State<HomeHeadTitle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return Container(
          width: 150,
          height: 56,
          child: Center(
            child: Text(
              context
                  .read<HomeMenuBloc>()
                  .menuTitle(state.realPositionMenu!.index),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        );
      },
    );
  }
}

// 首页框架头部返回
class HomeHeadReturn extends StatefulWidget {
  const HomeHeadReturn({super.key});

  @override
  State<HomeHeadReturn> createState() => _HomeHeadReturnState();
}

class _HomeHeadReturnState extends State<HomeHeadReturn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (menuContext, menuState) {
        return GestureDetector(
          onTap: () {
            //返回棚卸照会 刷新画面
            if (GoRouter.of(context)
                .routerDelegate
                .currentConfiguration
                .last
                .matchedLocation
                .contains('/' + Config.PAGE_FLAG_5_9 + '/details/')) {
              GoRouter.of(context).pop('refresh return');
            } else {
              // 返回
              GoRouter.of(context).pop();
              if (GoRouter.of(context)
                      .routerDelegate
                      .currentConfiguration
                      .last
                      .matchedLocation ==
                  '/') {
                // 持久化状态更新
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshMenuExpandAction(false));
                // 隐藏菜单子级
                HomeMenuChildren.hide();
                // 隐藏菜单商品
                HomeMenuProduct.hide();
                //更新底部显示状态
                menuContext
                    .read<HomeMenuBloc>()
                    .add(FootChangeState(menuState.menuList[0], context));
              }
            }
          },
          child: Container(
            height: 56,
            padding: EdgeInsets.fromLTRB(18, 8, 0, 8),
            child: Icon(
              Icons.arrow_back_ios_new,
              weight: 40,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        );
      },
    );
  }
}

// 首页框架头部提示
class HomeHeadNotice extends StatefulWidget {
  const HomeHeadNotice({super.key});

  @override
  State<HomeHeadNotice> createState() => _HomeHeadNoticeState();
}

class _HomeHeadNoticeState extends State<HomeHeadNotice> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (menuContext, menuState) {
        bool? currentNoticeFlag =
            StoreProvider.of<WMSState>(context).state.currentNoticeFlag;
        return GestureDetector(
          onPanDown: (details) {
            // 持久化状态更新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshMenuExpandAction(false));
            // 隐藏菜单子级
            HomeMenuChildren.hide();
            // 隐藏菜单商品
            HomeMenuProduct.hide();
            //传入参数，控制消息页面刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(true));
            // 跳转页面
            menuContext
                .read<HomeMenuBloc>()
                .add(PageJumpEvent('/' + Config.PAGE_FLAG_50_2 + '/notice/-1'));
          },
          child: Container(
            height: 56,
            padding: EdgeInsets.fromLTRB(0, 17, 18, 17),
            child: Stack(
              children: [
                Container(
                  child: Image.asset(
                    WMSICons.HOME_HEAD_NOTICE,
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
                Visibility(
                  visible: currentNoticeFlag,
                  child: Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: Color.fromRGBO(255, 51, 51, 1),
                      ),
                    ),
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

// 首页框架头部用户
class HomeHeadUser extends StatefulWidget {
  const HomeHeadUser({super.key});

  @override
  State<HomeHeadUser> createState() => _HomeHeadUserState();
}

class _HomeHeadUserState extends State<HomeHeadUser> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (menuContext, menuState) {
        return GestureDetector(
          onPanDown: (details) {
            // 持久化状态更新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshMenuExpandAction(false));
            // 隐藏菜单子级
            HomeMenuChildren.hide();
            // 隐藏菜单商品
            HomeMenuProduct.hide();
            // 跳转页面
            menuContext
                .read<HomeMenuBloc>()
                .add(PageJumpEvent('/' + Config.PAGE_FLAG_50_1));
          },
          child: Container(
            height: 56,
            padding: EdgeInsets.fromLTRB(0, 12, 10, 12),
            child: Image.asset(
              WMSICons.HOME_HEAD_USER,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
        );
      },
    );
  }
}

// 首页框架头部多语言
class HomeHeadLanguage extends StatefulWidget {
  const HomeHeadLanguage({super.key});

  @override
  State<HomeHeadLanguage> createState() => _HomeHeadLanguageState();
}

class _HomeHeadLanguageState extends State<HomeHeadLanguage> {
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
              // 持久化状态更新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshMenuExpandAction(false));
              // 隐藏菜单子级
              HomeMenuChildren.hide();
              // 隐藏菜单商品
              HomeMenuProduct.hide();
              // 选中语言变更事件
              context.read<HomeMenuBloc>().add(
                  SelectedLanguageChangeEvent(state.languageList[i]['id']));
            },
            child: Container(
              width: 100,
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
                top: 64,
                right: 10,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return GestureDetector(
          onPanDown: (details) {
            // 显示自定义多语言弹窗
            _showCustomLanguageDialog(state);
          },
          child: Container(
            height: 56,
            padding: EdgeInsets.fromLTRB(0, 8, 15, 8),
            child: Row(
              children: [
                Container(
                  child: Image.asset(
                    WMSICons.HOME_HEAD_LANGUAGE,
                    width: 40,
                    height: 40,
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
