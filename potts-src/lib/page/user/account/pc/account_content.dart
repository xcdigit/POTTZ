import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../model/user.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../../../login/sp/login_page.dart'
    if (dart.library.html) '../../../login/pc/login_page.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';
import 'account_content_code.dart';
import 'account_content_plan.dart';
import 'account_content_profile.dart';
import 'account_content_security.dart';

/**
 * 内容：账户-内容
 * 作者：赵士淞
 * 时间：2023/08/14
 */
// 当前内容
Widget currentContent = Container();

class AccountContent extends StatefulWidget {
  const AccountContent({super.key});

  @override
  State<AccountContent> createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  // 初始化账户内容简介
  Widget _initAccountContentProfile() {
    // 账户-内容简介
    return Container(
      width: 560,
      margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Color.fromRGBO(102, 199, 206, 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AccountContentProfile(),
    );
  }

  // 初始化账户内容安全
  Widget _initAccountContentSecurity() {
    // 账户-内容安全
    return Container(
      width: 560,
      margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Color.fromRGBO(102, 199, 206, 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AccountContentSecurity(),
    );
  }

  // 初始化账户许可证
  Widget _initAccountContentLicense() {
    // 账户-许可证
    return AccountContentPlan();
  }

  // 初始化账户扫码
  Widget _initAccountContentCode() {
    // 账户-许可证
    return Container(
      width: 560,
      margin: EdgeInsets.fromLTRB(100, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Color.fromRGBO(102, 199, 206, 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AccountContentCode(),
    );
  }

  // 初始化账户退出
  Widget _initAccountContentLogout() {
    // 账户-退出
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 判断当前下标
        if (StoreProvider.of<WMSState>(context).state.currentAccountMenu ==
            Config.NUMBER_ZERO) {
          // 当前内容
          currentContent = _initAccountContentProfile();
        } else if (StoreProvider.of<WMSState>(context)
                .state
                .currentAccountMenu ==
            Config.NUMBER_ONE) {
          // 当前内容
          currentContent = _initAccountContentSecurity();
        } else if (StoreProvider.of<WMSState>(context)
                .state
                .currentAccountMenu ==
            Config.NUMBER_TWO) {
          // 当前内容
          currentContent = _initAccountContentLicense();
        } else if (StoreProvider.of<WMSState>(context)
                .state
                .currentAccountMenu ==
            Config.NUMBER_THREE) {
          // 当前内容
          currentContent = _initAccountContentCode();
        } else if (StoreProvider.of<WMSState>(context)
                .state
                .currentAccountMenu ==
            Config.NUMBER_FOUR) {
          // 当前内容
          currentContent = _initAccountContentLogout();
        }

        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 252,
                child: Column(
                  children: [
                    // 账户-内容用户
                    AccountContentUser(),
                    // 账户-内容菜单
                    AccountContentMent(
                      initAccountContentProfile: _initAccountContentProfile(),
                      initAccountContentSecurity: _initAccountContentSecurity(),
                      initAccountContentLicense: _initAccountContentLicense(),
                      initAccountContentCode: _initAccountContentCode(),
                      initAccountContentLogout: _initAccountContentLogout(),
                    ),
                  ],
                ),
              ),
              currentContent,
            ],
          ),
        );
      },
    );
  }
}

// 账户-内容用户
class AccountContentUser extends StatefulWidget {
  const AccountContentUser({super.key});

  @override
  State<AccountContentUser> createState() => _AccountContentUserState();
}

class _AccountContentUserState extends State<AccountContentUser> {
  // 上传图片文件回调函数
  void _uploadImageFileCallBack(String content) {
    // 判断内容信息
    if (content == WMSCommonFile.SIZE_EXCEEDS) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.image_size_need_within_2m);
    } else {
      // 保存账户事件
      context.read<AccountBloc>().add(SaveUserEvent({'avatar': content}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // 设置头像提示文本显示事件
                      context
                          .read<AccountBloc>()
                          .add(SetAvatarTooltipShowEvent(true));
                    },
                    onDoubleTap: () {
                      // 打开加载状态
                      BotToast.showLoading();
                      // 上传图片
                      WMSCommonFile().uploadImageFile(
                          'avatar/' +
                              StoreProvider.of<WMSState>(context)
                                  .state
                                  .loginUser!
                                  .company_id
                                  .toString(),
                          '',
                          _uploadImageFileCallBack);
                    },
                    child: state.avatarNetwork == ''
                        ? Image.asset(
                            WMSICons.ACCOUNT_CONTENT_USER_DEFAULT,
                            width: 88,
                            height: 88,
                          )
                        : Image.network(
                            state.avatarNetwork,
                            width: 88,
                            height: 88,
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Center(
                      child: Text(
                        state.userCustomize['name'] ?? '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: state.avatarTooltipShow,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Text(WMSLocalizations.i18n(context)!
                      .account_double_click_any_image_to_change_image),
                ),
              ),
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
  // 初始化账户内容简介
  Widget initAccountContentProfile;
  // 初始化账户内容安全
  Widget initAccountContentSecurity;
  // 初始化账户许可证
  Widget initAccountContentLicense;
  // 初始化账户扫码
  Widget initAccountContentCode;
  // 初始化账户退出
  Widget initAccountContentLogout;

  AccountContentMent({
    super.key,
    required this.initAccountContentProfile,
    required this.initAccountContentSecurity,
    required this.initAccountContentLicense,
    required this.initAccountContentCode,
    required this.initAccountContentLogout,
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
            // 持久化状态更新
            StoreProvider.of<WMSState>(context).state.login = false;
            // 持久化状态更新
            StoreProvider.of<WMSState>(context).state.userInfo = null;
            // 持久化状态
            StoreProvider.of<WMSState>(context).state.loginUser = User.empty();
            // 持久化状态
            StoreProvider.of<WMSState>(context).state.loginAuthority = [];
            // 跳转页面
            GoRouter.of(context).replaceNamed(LoginPage.sName);
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
        GestureDetector(
          onPanDown: (details) {
            // 持久化状态更新
            StoreProvider.of<WMSState>(context).state.currentAccountMenu =
                menuItemList[i]['index'];
            // 判断当前菜单
            if (menuItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 切换标记
              state.switchFlag = true;
              // 当前内容
              currentContent = widget.initAccountContentProfile;
            } else if (menuItemList[i]['index'] == Config.NUMBER_ONE) {
              // 切换标记
              state.switchFlag = true;
              // 当前内容
              currentContent = widget.initAccountContentSecurity;
            } else if (menuItemList[i]['index'] == Config.NUMBER_TWO) {
              // 切换标记
              state.switchFlag = true;
              // 当前内容
              currentContent = widget.initAccountContentLicense;
            } else if (menuItemList[i]['index'] == Config.NUMBER_THREE) {
              // 切换标记
              state.switchFlag = true;
              // 当前内容
              currentContent = widget.initAccountContentCode;
            } else if (menuItemList[i]['index'] == Config.NUMBER_FOUR) {
              // 显示退出弹窗
              _showLogoutDialog();
              // 当前内容
              currentContent = widget.initAccountContentLogout;
            }
          },
          child: Container(
            height: 44,
            padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            decoration: BoxDecoration(
              color: StoreProvider.of<WMSState>(context)
                          .state
                          .currentAccountMenu ==
                      menuItemList[i]['index']
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                menuItemList[i]['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: StoreProvider.of<WMSState>(context)
                              .state
                              .currentAccountMenu ==
                          menuItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(6, 14, 15, 1),
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
                Config.ROLE_ID_1
            ? [
                {
                  'index': Config.NUMBER_ZERO,
                  'title': WMSLocalizations.i18n(context)!.account_menu_1,
                },
                {
                  'index': Config.NUMBER_ONE,
                  'title': WMSLocalizations.i18n(context)!.account_menu_3,
                },
                {
                  'index': Config.NUMBER_THREE,
                  'title': WMSLocalizations.i18n(context)!.account_menu_7,
                },
                {
                  'index': Config.NUMBER_FOUR,
                  'title': WMSLocalizations.i18n(context)!.account_menu_6,
                },
              ]
            : StoreProvider.of<WMSState>(context).state.loginUser?.role_id ==
                    Config.ROLE_ID_2
                ? [
                    {
                      'index': Config.NUMBER_ZERO,
                      'title': WMSLocalizations.i18n(context)!.account_menu_1,
                    },
                    {
                      'index': Config.NUMBER_ONE,
                      'title': WMSLocalizations.i18n(context)!.account_menu_3,
                    },
                    {
                      'index': Config.NUMBER_TWO,
                      'title': WMSLocalizations.i18n(context)!.account_menu_4,
                    },
                    {
                      'index': Config.NUMBER_THREE,
                      'title': WMSLocalizations.i18n(context)!.account_menu_7,
                    },
                    {
                      'index': Config.NUMBER_FOUR,
                      'title': WMSLocalizations.i18n(context)!.account_menu_6,
                    },
                  ]
                : StoreProvider.of<WMSState>(context)
                            .state
                            .loginUser
                            ?.role_id ==
                        Config.ROLE_ID_3
                    ? [
                        {
                          'index': Config.NUMBER_ZERO,
                          'title':
                              WMSLocalizations.i18n(context)!.account_menu_1,
                        },
                        {
                          'index': Config.NUMBER_ONE,
                          'title':
                              WMSLocalizations.i18n(context)!.account_menu_3,
                        },
                        {
                          'index': Config.NUMBER_FOUR,
                          'title':
                              WMSLocalizations.i18n(context)!.account_menu_6,
                        },
                      ]
                    : [];

        return Container(
          margin: EdgeInsets.fromLTRB(0, 43, 0, 0),
          child: Column(
            children: _initMenuList(_menuItemList, state),
          ),
        );
      },
    );
  }
}
