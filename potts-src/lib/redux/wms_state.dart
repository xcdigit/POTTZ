import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wms/redux/contract_flag_reducer.dart';
import 'package:wms/redux/contract_param_reducer.dart';
import '../common/config/config.dart';
import '../model/user.dart';
import '/model/login.dart';
import '/redux/login_redux.dart';
import '/redux/user_redux.dart';
import '/redux/theme_redux.dart';
import '/redux/locale_redux.dart';
import 'package:redux/redux.dart';

import 'current_account_menu_reducer.dart';
import 'current_corporate_menu_reducer.dart';
import 'current_flag_reducer.dart';
import 'current_index_reducer.dart';
import 'current_menu_reducer.dart';
import 'current_notice_flag_reducer.dart';
import 'current_page_reducer.dart';
import 'current_param_reducer.dart';
import 'first_enter_home_reducer.dart';
import 'login_authority_reducer.dart';
import 'login_user_reducer.dart';
import 'menu_expand_reducer.dart';
import 'middleware/epic_middleware.dart';
import 'other_widget_operate_menu_child_reducer.dart';

///全局Redux store 的对象，保存State数据
class WMSState {
  ///用户信息
  Login? userInfo;

  ///主题数据
  ThemeData? themeData;

  ///语言
  Locale? locale;

  ///当前手机平台默认语言
  Locale? platformLocale;

  ///是否登录
  bool? login;

  ///是否变灰色
  bool grey;

  // 赵士淞 - 始
  // 当前页面
  String currentPage;
  // 菜单展开
  bool menuExpand;
  // 当前菜单
  int currentMenu;
  // 其他容器操作菜单子级
  bool otherWidgetOperateMenuChild;
  // 当前账户菜单
  int currentAccountMenu;
  // 登录用户
  User? loginUser;
  // 登录权限
  List<dynamic> loginAuthority;
  // 赵士淞 - 终

  //luxy -satrt
  dynamic currentParam;
  bool currentFlag;
  int currentIndex;
  bool currentNoticeFlag;
  //luxy -end
  //解约画面跳转状态
  bool contractFlag;
  //解约画面参数
  dynamic contractParam;
  // 首次进入首页标记
  bool firstEnterHomeFlag;

  // muzd start
  // 当前法人管理菜单
  int currentCorporateMenu;
  // muzd end

  ///构造方法
  WMSState({
    this.userInfo,
    this.themeData,
    this.locale,
    this.login,
    this.grey = false,
    // 赵士淞 - 始
    // 当前页面
    this.currentPage = Config.PAGE_FLAG_1,
    // 菜单展开
    this.menuExpand = kIsWeb ? true : false,
    // 当前菜单
    this.currentMenu = Config.MENU_FLAG_1,
    // 其他容器操作菜单子级
    this.otherWidgetOperateMenuChild = false,
    // 当前账户菜单
    this.currentAccountMenu = 0,
    // 登录用户
    this.loginUser,
    // 登录权限
    this.loginAuthority = const [],
    // 赵士淞 - 终
    //luxy -satrt
    this.currentParam,
    this.currentFlag = false,
    this.currentIndex = -1,
    this.currentNoticeFlag = false,
    //luxy -end
    //解约画面跳转状态
    this.contractFlag = false,
    //解约画面参数
    this.contractParam,

    // muzd start
    // 当前法人管理菜单
    this.currentCorporateMenu = 0,
    // muzd end

    // 首次进入首页标记
    this.firstEnterHomeFlag = true,
  });
}

///创建 Reducer
///源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
///我们自定义了 appReducer 用于创建 store
WMSState appReducer(WMSState state, action) {
  return WMSState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),

    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),

    ///通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
    login: LoginReducer(state.login, action),

    // 赵士淞 - 始
    // 当前页面
    currentPage: CurrentPageReducer(state.currentPage, action),
    // 菜单展开
    menuExpand: MenuExpandReducer(state.menuExpand, action),
    // 当前菜单
    currentMenu: CurrentMenuReducer(state.currentMenu, action),
    // 其他容器操作菜单子级
    otherWidgetOperateMenuChild: OtherWidgetOperateMenuChildReducer(
        state.otherWidgetOperateMenuChild, action),
    // 当前账户菜单
    currentAccountMenu:
        CurrentAccountMenuReducer(state.currentAccountMenu, action),
    // 登录用户
    loginUser: LoginUserReducer(state.loginUser, action),
    // 登录权限
    loginAuthority: LoginAuthorityReducer(state.loginAuthority, action),
    // 赵士淞 - 终
    //luxy -satrt
    //页面参数
    currentParam: CurrentParamReducer(state.currentParam, action),
    //参数：true或false
    currentFlag: CurrentFlagReducer(state.currentFlag, action),
    //参数：消息列表的下标
    currentIndex: CurrentIndexReducer(state.currentIndex, action),
    //参数：true或false
    currentNoticeFlag:
        CurrentNoticeFlagReducer(state.currentNoticeFlag, action),
    //luxy -end
    //解约画面跳转状态
    contractFlag: ContractFlagReducer(state.contractFlag, action),
    //解约画面参数
    contractParam: ContractParamReducer(state.contractParam, action),

    // muzd start
    // 当前法人管理菜单
    currentCorporateMenu:
        CurrentCorporateMenuReducer(state.currentCorporateMenu, action),
    // muzd end

    // 首次进入首页标记
    firstEnterHomeFlag: FirstEnterHomeReducer(state.firstEnterHomeFlag, action),
  );
}

final List<Middleware<WMSState>> middleware = [
  EpicMiddleware<WMSState>(loginEpic),
  EpicMiddleware<WMSState>(userInfoEpic),
  UserInfoMiddleware(),
  LoginMiddleware(),
];
