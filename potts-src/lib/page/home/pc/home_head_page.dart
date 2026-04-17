import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/page/home/bloc/home_menu_bloc.dart';
import 'package:wms/page/home/bloc/home_menu_model.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../model/user.dart';
import '../../../redux/current_account_menu_reducer.dart';
import '../../../redux/current_flag_reducer.dart';
import '../../../redux/current_index_reducer.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/wms_dialog_widget.dart';
import '../../login/pc/login_page.dart';
import '../bloc/menu_dropdown_widget.dart';

/**
 * 内容：首页框架头部
 * 作者：赵士淞
 * 时间：2023/07/25
 */
class HomeHeadPage extends StatefulWidget {
  HomeHeadPage({super.key});

  @override
  State<HomeHeadPage> createState() => _HomeHeadPageState();
}

class _HomeHeadPageState extends State<HomeHeadPage> {
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
          // 搜索区域
          Positioned(
            left: 340,
            top: 27,
            bottom: 27,
            child: HomeHeadSearch(),
          ),
          // 下拉选择区域
          Positioned(
            right: 40,
            top: 33,
            bottom: 33,
            child: Row(
              children: [
                // 通知区域
                HomeHeadNotice(),
                // 间隔区域
                SizedBox(
                  width: 20,
                ),
                // 用户区域
                HomeHeadUser(),
                // 间隔区域
                SizedBox(
                  width: 20,
                ),
                // 多语言区域
                HomeHeadLanguage(),
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

// 首页框架头部搜索
class HomeHeadSearch extends StatelessWidget {
  HomeHeadSearch({super.key});

  @override
  Widget build(BuildContext context) {
    if (StoreProvider.of<WMSState>(context).state.login! == false) {
      return Container();
    }
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return MenuDropdownWidget(
          inputBackgroundColor: Color.fromRGBO(251, 251, 251, 1),
          inputWidth:
              MediaQuery.of(context).size.width < Config.WEB_MINI_WIDTH_LIMIT
                  ? 0
                  : MediaQuery.of(context).size.width / 4,
          inputPrefixIcon: Container(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Image.asset(
              WMSICons.HOME_HEAD_SEARCH,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
          inputHintText:
              WMSLocalizations.i18n(context)!.home_head_search_hint_text,
        );
      },
    );
  }
}

// 首页框架头部提示
// ignore: must_be_immutable
class HomeHeadNotice extends StatefulWidget {
  HomeHeadNotice({super.key});

  @override
  State<HomeHeadNotice> createState() => _HomeHeadNoticeState();
}

class _HomeHeadNoticeState extends State<HomeHeadNotice> {
  @override
  Widget build(BuildContext context) {
    // 一个补丁
    BuildContext _context = context;
    HomeMenuBloc bloc = context.read<HomeMenuBloc>();
    //luxy 消息弹窗 start
    _showCustomNoticeDialog(double dx) {
      showDialog(
        context: context,
        barrierColor: Color.fromRGBO(255, 255, 255, 0),
        builder: (context) {
          return BlocProvider<HomeMenuBloc>.value(
            value: bloc,
            child: BlocBuilder<HomeMenuBloc, HomeMenuModel>(
              builder: (context, state) {
                return Material(
                  type: MaterialType.transparency,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 92,
                        left: dx - 160,
                        child: new Container(
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3), // 阴影的颜色
                                offset: Offset(0, 0), // 阴影与容器的距离
                                blurRadius: 20.0,
                              ),
                            ],
                          ),
                          child: new Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 0)),
                              Container(
                                width: 60,
                                height: 0,
                                decoration: new BoxDecoration(
                                  border: Border(
                                    // 四个值 top right bottom left
                                    bottom: BorderSide(
                                        color: Colors.white,
                                        width: 20,
                                        style: BorderStyle.solid),
                                    right: BorderSide(
                                        color: Colors.transparent,
                                        width: 30,
                                        style: BorderStyle.solid),
                                    left: BorderSide(
                                        color: Colors.transparent,
                                        width: 30,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                              ),
                              new Container(
                                width: 320,
                                height: 440,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                child: new Container(
                                  width: 300,
                                  height: 420,
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(102, 199, 206, 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                    ),
                                  ),
                                  child: new Column(
                                    children: [
                                      new Container(
                                        width: 256,
                                        height: 40,
                                        margin:
                                            EdgeInsets.fromLTRB(15, 20, 15, 0),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width: 1.0,
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                          ),
                                        ),
                                        child: new Text(
                                          WMSLocalizations.i18n(context)!
                                              .home_head_notice_text2,
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Container(
                                        height: 250,
                                        child: new Column(
                                          children: _noticeList(state),
                                        ),
                                      ),
                                      new Container(
                                        width: 152,
                                        height: 34,
                                        margin: EdgeInsets.only(top: 30),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromRGBO(44, 167, 176, 1),
                                          ),
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .home_head_notice_text3,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onPressed: () {
                                            // 跳转页面
                                            GoRouter.of(_context).go(
                                              '/' +
                                                  Config.PAGE_FLAG_50_2 +
                                                  '/notice/-1',
                                            );
                                            //传入参数，控制消息页面刷新
                                            StoreProvider.of<WMSState>(context)
                                                .dispatch(
                                                    RefreshCurrentFlagAction(
                                                        true));
                                            //传入参数：消息下标
                                            StoreProvider.of<WMSState>(context)
                                                .dispatch(
                                                    RefreshCurrentIndexAction(
                                                        -1));
                                            //取消左侧菜单选中
                                            state.currentMenu!.isSelected =
                                                false;
                                            // 关闭弹窗
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    }
    //luxy 消息弹窗 end

    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(builder: (context, state) {
      //消息红点显示判断
      bool? currentNoticeFlag =
          StoreProvider.of<WMSState>(context).state.currentNoticeFlag;

      return GestureDetector(
        onPanDown: (details) {
          // 显示自定义消息弹窗-luxy
          _showCustomNoticeDialog(details.globalPosition.dx);
        },
        child: Container(
          width: StoreProvider.of<WMSState>(context).state.login! ? null : 0,
          height: 34,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                child: Image.asset(
                  WMSICons.HOME_HEAD_NOTICE,
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
              Visibility(
                visible: currentNoticeFlag,
                child: Positioned(
                  top: 2,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
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
    });
  }

  //luxy 消息列表 start
  _noticeList(HomeMenuModel state) {
    List<Widget> _list = [];
    //获取消息列表内容
    List<dynamic> noticeList =
        StoreProvider.of<WMSState>(context).state.currentParam;
    // 列表内容
    if (noticeList.length > 0) {
      for (var i = 0; i < noticeList.length; i++) {
        if (i < 3) {
          _list.add(
            new Container(
              height: 80,
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                ),
                color: Color.fromRGBO(255, 255, 255, 0),
              ),
              child: new ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(-10), // content 内间距
                leading: noticeList[i]['message_kbn'] == 'ytb'
                    ? new Image(
                        image:
                            new AssetImage(WMSICons.HOME_head_NOTICE_PAGE_IMG2),
                        width: 25.0,
                        height: 25.0,
                      )
                    : new Image(
                        image:
                            new AssetImage(WMSICons.HOME_head_NOTICE_PAGE_IMG1),
                        width: 25.0,
                        height: 25.0,
                      ),
                title: Transform.translate(
                  offset: Offset(-15, 0), // 控制水平偏移量
                  child: Stack(
                    children: [
                      Container(
                        width: 180,
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: new Text(
                          noticeList[i]['title'].toString(),
                          style: TextStyle(
                            color: Color.fromRGBO(6, 14, 15, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Visibility(
                        visible: noticeList[i]['read_status'] == '2',
                        child: Positioned(
                          top: 3,
                          right: 5,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromRGBO(255, 51, 51, 1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Transform.translate(
                  offset: Offset(-15, 0), // 控制水平偏移量
                  child: new Text(
                    noticeList[i]['message'].toString(),
                    style: TextStyle(
                      color: Color.fromRGBO(156, 156, 156, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                onTap: () {
                  //传入参数，控制消息页面刷新
                  StoreProvider.of<WMSState>(context)
                      .dispatch(RefreshCurrentFlagAction(true));
                  //传入参数：消息下标
                  StoreProvider.of<WMSState>(context)
                      .dispatch(RefreshCurrentIndexAction(i));
                  // 跳转页面
                  GoRouter.of(context).go(
                    '/' + Config.PAGE_FLAG_50_2 + '/notice/' + i.toString(),
                  );
                  // 关闭弹窗
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          );
        }
      }
    } else {
      _list.add(Container(
        height: 180,
        alignment: Alignment.center,
        child: Text(
          WMSLocalizations.i18n(context)!.no_items_found,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ));
    }
    return _list;
  }
  //luxy 消息列表 end
}

// 首页框架头部用户
// ignore: must_be_immutable
class HomeHeadUser extends StatefulWidget {
  HomeHeadUser({super.key});

  @override
  State<HomeHeadUser> createState() => _HomeHeadUserState();
}

class _HomeHeadUserState extends State<HomeHeadUser> {
  // 显示账户弹窗
  _showAccountDialog() {
    // 账户列表
    List _accountList = StoreProvider.of<WMSState>(context)
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
            : StoreProvider.of<WMSState>(context).state.loginUser?.role_id ==
                    Config.ROLE_ID_3
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
                      'index': Config.NUMBER_FOUR,
                      'title': WMSLocalizations.i18n(context)!.account_menu_6,
                    },
                  ]
                : [];

    // 账户组件列表
    List<Widget> _accountWidgetList() {
      // 组件列表
      List<Widget> widgetList = [];
      // 组件列表
      widgetList.add(
        Container(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Text(
            WMSLocalizations.i18n(context)!.menu_content_50_1,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(44, 167, 176, 1),
              height: 2.4,
            ),
          ),
        ),
      );
      // 组件列表
      widgetList.add(
        Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Divider(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
      );
      // 循环账户列表
      for (int i = 0; i < _accountList.length; i++) {
        // 组件列表
        widgetList.add(
          GestureDetector(
            onTap: () {
              // 关闭弹窗
              Navigator.pop(context);
              // 判断下标
              if (_accountList[i]['index'] == Config.NUMBER_FOUR) {
                // 显示退出弹窗
                showDialog(
                  context: context,
                  builder: (context) {
                    return WMSDiaLogWidget(
                      titleText: WMSLocalizations.i18n(context)!.account_menu_6,
                      contentText:
                          WMSLocalizations.i18n(context)!.account_logout_text,
                      buttonLeftText:
                          WMSLocalizations.i18n(context)!.app_cancel,
                      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                      onPressedLeft: () {
                        // 关闭弹窗
                        Navigator.pop(context);
                      },
                      onPressedRight: () {
                        // 持久化状态更新
                        StoreProvider.of<WMSState>(context).state.login = false;
                        // 持久化状态更新
                        StoreProvider.of<WMSState>(context).state.userInfo =
                            null;
                        // 持久化状态
                        StoreProvider.of<WMSState>(context).state.loginUser =
                            User.empty();
                        // 持久化状态
                        StoreProvider.of<WMSState>(context)
                            .state
                            .loginAuthority = [];
                        // 跳转页面
                        GoRouter.of(context).replaceNamed(LoginPage.sName);
                        // 关闭弹窗
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              } else {
                // 持久化状态更新
                StoreProvider.of<WMSState>(context).dispatch(
                    RefreshCurrentAccountMenuAction(_accountList[i]['index']));
                //
                context.read<HomeMenuBloc>().add(
                    ChangeToSpecialMenuEvent(Config.MENU_FLAG_50_1, context));
                // // 持久化状态更新
                // StoreProvider.of<WMSState>(context)
                //     .dispatch(RefreshCurrentPageAction(Config.PAGE_FLAG_50_1));
                // // 持久化状态更新
                // StoreProvider.of<WMSState>(context)
                //     .dispatch(RefreshCurrentMenuAction(Config.MENU_FLAG_50_1));
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                _accountList[i]['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                  height: 2.4,
                ),
              ),
            ),
          ),
        );
      }
      // 组件列表
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
                top: 86,
                right: MediaQuery.of(context).size.width <
                        Config.WEB_MINI_WIDTH_LIMIT
                    ? 0
                    : 102,
                child: Stack(
                  children: [
                    Container(
                      width: 236,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 14, 10, 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                          color: Color.fromRGBO(102, 199, 206, 0.1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _accountWidgetList(),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 96,
                      child: Container(
                        width: 44,
                        height: 0,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 18,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            left: BorderSide(
                              width: 22,
                              color: Colors.transparent,
                            ),
                            right: BorderSide(
                              width: 22,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        // 显示账户弹窗
        _showAccountDialog();
      },
      child: Container(
        width: StoreProvider.of<WMSState>(context).state.login! ? null : 0,
        height: 34,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              child: Image.asset(
                WMSICons.HOME_HEAD_USER,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
                repeat: ImageRepeat.noRepeat,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
              child: Text(
                StoreProvider.of<WMSState>(context).state.loginUser?.name ?? '',
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
  }
}

// 首页框架头部多语言
// ignore: must_be_immutable
class HomeHeadLanguage extends StatefulWidget {
  HomeHeadLanguage({super.key});

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
              // 选中语言变更事件
              context.read<HomeMenuBloc>().add(
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
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return GestureDetector(
          onPanDown: (details) {
            // 显示自定义多语言弹窗
            _showCustomLanguageDialog(state);
          },
          child: Container(
            // width: StoreProvider.of<WMSState>(context).state.login! ? null : 0,
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
