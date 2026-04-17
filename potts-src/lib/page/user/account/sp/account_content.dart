import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../model/user.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../../../home/bloc/home_menu_bloc.dart';
import '../../../home/bloc/home_menu_model.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-内容-SP
 * 作者：熊草云
 * 时间：2023/11/01
 */
class AccountContent extends StatefulWidget {
  const AccountContent({super.key});

  @override
  State<AccountContent> createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              AccountContentMent(),
            ],
          ),
        );
      },
    );
  }
}

// 账户-内容菜单
// ignore: must_be_immutable
class AccountContentMent extends StatefulWidget {
  AccountContentMent({
    super.key,
  });

  @override
  State<AccountContentMent> createState() => _AccountContentMentState();
}

class _AccountContentMentState extends State<AccountContentMent> {
  // 显示退出弹窗
  _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText: WMSLocalizations.i18n(context)!.account_menu_6,
          contentText: WMSLocalizations.i18n(context)!.account_logout_text,
          buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
          buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
          onPressedLeft: () {
            // 关闭弹窗
            Navigator.pop(context);
          },
          onPressedRight: () {
            // 赵士淞 - 始
            // 持久化状态更新
            StoreProvider.of<WMSState>(context).state.login = false;
            // 持久化状态更新
            StoreProvider.of<WMSState>(context).state.userInfo = null;
            // 持久化状态
            StoreProvider.of<WMSState>(context).state.loginUser = User.empty();
            // 持久化状态
            StoreProvider.of<WMSState>(context).state.loginAuthority = [];
            // 赵士淞 - 终
            // 跳转页面
            GoRouter.of(context).go('/login');
            // 关闭弹窗
            Navigator.pop(context);
          },
        );
      },
    );
  }

  // 初始化菜单列表
  List<Widget> _initMenuList(List menuItemList, AccountModel state) {
    // 菜单列表
    List<Widget> menuList = [];
    // 循环菜单单个列表
    for (int i = 0; i < menuItemList.length; i++) {
      // 菜单列表
      menuList.add(
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: GestureDetector(
              onPanDown: (details) {
                // 持久化状态更新
                StoreProvider.of<WMSState>(context).state.currentAccountMenu =
                    menuItemList[i]['index'];
                // 判断当前菜单
                if (menuItemList[i]['index'] == Config.NUMBER_ZERO) {
                  // 切换标记
                  state.switchFlag = true;
                  // 当前内容
                  context.read<HomeMenuBloc>().add(
                        PageJumpEvent('/' + Config.PAGE_FLAG_50_1 + '/profile'),
                      );
                } else if (menuItemList[i]['index'] == Config.NUMBER_ONE) {
                  // 切换标记
                  state.switchFlag = true;
                  // 当前内容
                  context.read<HomeMenuBloc>().add(
                        PageJumpEvent(
                            '/' + Config.PAGE_FLAG_50_1 + '/security'),
                      );
                } else if (menuItemList[i]['index'] == Config.NUMBER_TWO) {
                  // 切换标记
                  state.switchFlag = true;
                  // 当前内容
                  context.read<HomeMenuBloc>().add(
                        PageJumpEvent('/' + Config.PAGE_FLAG_50_1 + '/plan'),
                      );
                } else if (menuItemList[i]['index'] == Config.NUMBER_THREE) {
                  // 切换标记
                  state.switchFlag = true;
                  // 当前内容
                  context.read<HomeMenuBloc>().add(
                        PageJumpEvent('/' + Config.PAGE_FLAG_50_1 + '/code'),
                      );
                } else if (menuItemList[i]['index'] == Config.NUMBER_FOUR) {
                  // 显示退出弹窗
                  _showLogoutDialog();
                  // 当前内容
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                menuItemList[i]['icon'],
                                width: 44,
                                height: 44,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menuItemList[i]['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(6, 14, 15, 1),
                                        height: 1.12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 菜单列表
    return menuList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 菜单单个列表
        List _menuItemList = StoreProvider.of<WMSState>(context)
                    .state
                    .loginUser
                    ?.role_id ==
                Config.ROLE_ID_2
            ? [
                {
                  'index': Config.NUMBER_ZERO,
                  'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
                  'title': WMSLocalizations.i18n(context)!.account_menu_1,
                },
                {
                  'index': Config.NUMBER_ONE,
                  'icon': WMSICons.ACCOUNT_CONTENT_SECURITY_PASSWORD,
                  'title': WMSLocalizations.i18n(context)!.account_menu_3,
                },
                {
                  'index': Config.NUMBER_TWO,
                  'icon': WMSICons.ACCOUNT_CONTENT_PERMIT_ICON,
                  'title': WMSLocalizations.i18n(context)!.account_menu_4,
                },
                {
                  'index': Config.NUMBER_THREE,
                  'icon': WMSICons.ACCOUNT_CONTENT_PERMIT_ICON,
                  'title': WMSLocalizations.i18n(context)!.account_menu_7,
                },
                {
                  'index': Config.NUMBER_FOUR,
                  'icon': WMSICons.ACCOUNT_CONTENT_QUIT_ICON,
                  'title': WMSLocalizations.i18n(context)!.account_menu_6,
                },
              ]
            : StoreProvider.of<WMSState>(context).state.loginUser?.role_id ==
                    Config.ROLE_ID_3
                ? [
                    {
                      'index': Config.NUMBER_ZERO,
                      'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
                      'title': WMSLocalizations.i18n(context)!.account_menu_1,
                    },
                    {
                      'index': Config.NUMBER_ONE,
                      'icon': WMSICons.ACCOUNT_CONTENT_SECURITY_PASSWORD,
                      'title': WMSLocalizations.i18n(context)!.account_menu_3,
                    },
                    {
                      'index': Config.NUMBER_FOUR,
                      'icon': WMSICons.ACCOUNT_CONTENT_QUIT_ICON,
                      'title': WMSLocalizations.i18n(context)!.account_menu_6,
                    },
                  ]
                : [];

        return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
          builder: (menuBloc, menuState) {
            return Container(
              child: Column(
                children: _initMenuList(_menuItemList, state),
              ),
            );
          },
        );
      },
    );
  }
}
