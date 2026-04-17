import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/redux/menu_expand_reducer.dart';

import '../../../bloc/wms_common_bloc_utils.dart';
import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/storage/local_storage.dart';
import '../../../common/utils/common_utils.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../model/user.dart';
import '../../../redux/current_notice_flag_reducer.dart';
import '../../../redux/current_param_reducer.dart';
import '../../../redux/first_enter_home_reducer.dart';
import '../../../redux/wms_state.dart';
import 'home_menu_item.dart';
import 'home_menu_model.dart';

abstract class MenuEvent {}

// 赵士淞 - 始
// 初始化事件
class InitEvent extends MenuEvent {
  // 初始化事件
  InitEvent();
}

// 底部变更事件
class ChangeBottomEvent extends MenuEvent {
  MenuItem menu;
  ChangeBottomEvent(this.menu);
}

// 页面跳转事件
class PageJumpEvent extends MenuEvent {
  String pageRoute;
  PageJumpEvent(this.pageRoute);
}

// 页面跳转标题设定
class SPPageJumpEvent extends MenuEvent {
  String pageRoute;
  SPPageJumpEvent(this.pageRoute);
}

// 选中语言变更事件
class SelectedLanguageChangeEvent extends MenuEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 设置目标路径事件
class SetTargetPathEvent extends MenuEvent {
  // 目标路径
  String targetPath;
  // 设置目标路径事件
  SetTargetPathEvent(this.targetPath);
}

// 设置悬停菜单下标事件
class SetHoverMenuIndexEvent extends MenuEvent {
  // 悬停菜单下标
  int hoverMenuIndex;
  // 设置悬停菜单下标事件
  SetHoverMenuIndexEvent(this.hoverMenuIndex);
}
// 赵士淞 - 终

class HoverMenuEvent extends MenuEvent {
  // 结构树
  BuildContext context;
  MenuItem menu;
  HoverMenuEvent(this.menu, this.context);
}

class ChangeMenuEvent extends MenuEvent {
  // 结构树
  BuildContext context;
  MenuItem menu;
  ChangeMenuEvent(this.menu, this.context);
}

class ChangeAdminMenuEvent extends MenuEvent {
  // 结构树
  BuildContext context;
  MenuItem menu;
  ChangeAdminMenuEvent(this.menu, this.context);
}

class ChangeToSpecialMenuEvent extends MenuEvent {
  // 结构树
  BuildContext context;
  int menuId;
  ChangeToSpecialMenuEvent(this.menuId, this.context);
}

class FootChangeState extends MenuEvent {
  // 结构树
  BuildContext context;
  MenuItem menu;
  FootChangeState(this.menu, this.context);
}

// 设置菜单商品编码/JANCD事件
class SetMenuProductCodeOrJanCdEvent extends MenuEvent {
  // 值
  String value;
  // 菜单商品编码/JANCD
  SetMenuProductCodeOrJanCdEvent(this.value);
}

// 改变菜单商品事件
class ChangeMenuProductEvent extends MenuEvent {
  // 结构树
  BuildContext context;
  // 菜单
  MenuItem menu;
  // 改变菜单商品事件
  ChangeMenuProductEvent(this.menu, this.context);
}

// 打开新增商品页面事件
class OpenAddProductPageEvent extends MenuEvent {
  // 打开新增商品页面事件
  OpenAddProductPageEvent();
}

class HomeMenuBloc extends Bloc<MenuEvent, HomeMenuModel> {
  HomeMenuBloc(HomeMenuModel state) : super(state) {
    // 赵士淞 - 始
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 登录用户
      User? loginUser =
          StoreProvider.of<WMSState>(state.context).state.loginUser;

      // 判断是否首次进入首页
      if (StoreProvider.of<WMSState>(state.context).state.firstEnterHomeFlag) {
        // 判断语言ID
        if (loginUser?.language_id != null && loginUser?.language_id != '') {
          // 切换语言
          CommonUtils.changeLocale(StoreProvider.of<WMSState>(state.context),
              loginUser?.language_id ?? 2);
          // 本地存储
          LocalStorage.save(
              Config.LOCALE, loginUser?.language_id.toString() ?? '2');
          // 选中语言
          state.selectedLanguage = loginUser?.language_id ?? 2;
        }
        // 持久化状态更新
        StoreProvider.of<WMSState>(state.context)
            .dispatch(RefreshFirstEnterHomeAction(false));
      }

      // 菜单列表
      List<MenuItem> menuList = state.menuList;
      // 初始化菜单列表处理
      menuList = initMenuListHandle(menuList);
      // 菜单列表
      state.menuList = menuList;

      // 查询多语言信息
      List<Map<String, dynamic>> languageData =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageData;

      //luxy - 始
      //查询消息列表
      List<dynamic> noticeData = await SupabaseUtils.getClient().rpc(
          'func_query_dialog_notice_message',
          params: {'user_id': loginUser?.id}).select('*');
      StoreProvider.of<WMSState>(state.context)
          .dispatch(RefreshCurrentParamAction(noticeData));
      //判断是否存在未读消息
      List<dynamic> list =
          noticeData.where((element) => element["read_status"] == '2').toList();
      if (list.length != 0) {
        //存在未读信息
        StoreProvider.of<WMSState>(state.context)
            .dispatch(RefreshCurrentNoticeFlagAction(true));
      } else {
        //不存在未读信息
        StoreProvider.of<WMSState>(state.context)
            .dispatch(RefreshCurrentNoticeFlagAction(false));
      }
      //luxy - 终

      // 更新
      emit(HomeMenuModel.copy(state));
    });

    // 底部变更事件
    on<ChangeBottomEvent>((event, emit) async {
      state.currentMenu!.isSelected = false;
      event.menu.isSelected = true;
      state.currentMenu = event.menu;
      state.realPositionMenu = event.menu;
      emit(HomeMenuModel.copy(state));

      if (event.menu.index == Config.MENU_FLAG_2) {
        GoRouter.of(state.context).go('/' + Config.PAGE_FLAG_2_5);
      } else if (event.menu.index == Config.MENU_FLAG_3) {
        GoRouter.of(state.context).go('/' + Config.PAGE_FLAG_3_5);
      } else if (event.menu.index == Config.MENU_FLAG_4) {
        GoRouter.of(state.context).go('/' + Config.PAGE_FLAG_4_1);
      } else {
        if (event.menu.route != null) {
          GoRouter.of(state.context).go('/' + event.menu.route!);
        }
      }
    });

    // 页面跳转事件
    on<PageJumpEvent>((event, emit) async {
      // 主路径
      String mainRoute = event.pageRoute.substring(1, event.pageRoute.length);
      // 判断主路径
      if (mainRoute.indexOf('/') != -1) {
        // 主路径
        mainRoute = mainRoute.substring(0, mainRoute.indexOf('/'));
      }

      // 页面跳转循环
      MenuItem menuItem = pageJumpForeach(state.menuList, mainRoute);

      // 判断菜单下标
      if (menuItem.index != Config.NUMBER_NEGATIVE && menuItem.route != null) {
        state.currentMenu!.isSelected = false;
        menuItem.isSelected = true;
        state.currentMenu = menuItem;
        state.realPositionMenu = menuItem;
        emit(HomeMenuModel.copy(state));

        GoRouter.of(state.context).go(event.pageRoute);
      }
    });
    // SP页面跳转标题设定
    on<SPPageJumpEvent>((event, emit) async {
      // 主路径
      String mainRoute = event.pageRoute.substring(1, event.pageRoute.length);
      // 判断主路径
      if (mainRoute.indexOf('/') != -1) {
        // 主路径
        mainRoute = mainRoute.substring(0, mainRoute.indexOf('/'));
      }

      // 页面跳转循环
      MenuItem menuItem = pageJumpForeach(state.menuList, mainRoute);

      // 判断菜单下标
      if (menuItem.index != Config.NUMBER_NEGATIVE && menuItem.route != null) {
        state.currentMenu!.isSelected = false;
        menuItem.isSelected = true;
        state.currentMenu = menuItem;
        state.realPositionMenu = menuItem;
        emit(HomeMenuModel.copy(state));
      }
    });

    // 选中语言变更事件
    on<SelectedLanguageChangeEvent>((event, emit) async {
      // 切换语言
      CommonUtils.changeLocale(
          StoreProvider.of<WMSState>(state.context), event.selectedLanguageId);
      // 本地存储
      LocalStorage.save(Config.LOCALE, event.selectedLanguageId.toString());
      // 选中语言
      state.selectedLanguage = event.selectedLanguageId;
      // 刷新
      emit(HomeMenuModel.copy(state));
      // 关闭弹窗
      Navigator.pop(state.context);
    });

    // 设置目标路径事件
    on<SetTargetPathEvent>((event, emit) async {
      // 目标路径
      state.targetPath = event.targetPath;
      // 刷新
      emit(HomeMenuModel.copy(state));
    });

    // 设置悬停菜单下标事件
    on<SetHoverMenuIndexEvent>((event, emit) async {
      // 悬停菜单下标
      state.hoverMenuIndex = event.hoverMenuIndex;
      // 刷新
      emit(HomeMenuModel.copy(state));
    });
    // 赵士淞 - 终

    on<HoverMenuEvent>((event, emit) async {
      state.currentMenu!.isSelected = false;
      event.menu.isSelected = true;
      state.currentMenu = event.menu;

      emit(HomeMenuModel.copy(state));
    });

    on<ChangeMenuEvent>((event, emit) async {
      state.currentMenu!.isSelected = false;
      event.menu.isSelected = true;
      state.currentMenu = event.menu;
      if (event.menu.route != null && event.menu.route != Config.PAGE_FLAG_9) {
        // 赵士淞 - 始
        // 真实位置菜单
        state.realPositionMenu = event.menu;
        // 赵士淞 - 终
        GoRouter.of(state.context).go('/' + event.menu.route!);

        //sp端隐藏menu
        if (!kIsWeb) {
          //隐藏侧边menu
          // 持久化状态更新
          StoreProvider.of<WMSState>(event.context)
              .dispatch(RefreshMenuExpandAction(false));
        }
      }

      emit(HomeMenuModel.copy(state));
    });

    on<ChangeAdminMenuEvent>((event, emit) async {
      if (state.currentMenu?.index == event.menu.index &&
          state.currentMenu?.children != null) {
        state.currentMenu!.isSelected = !state.currentMenu!.isSelected;
      } else {
        state.currentMenu!.isSelected = false;
        event.menu.isSelected = true;
        state.currentMenu = event.menu;
        if (event.menu.route != null &&
            event.menu.route != Config.PAGE_FLAG_9) {
          // 赵士淞 - 始
          // 真实位置菜单
          state.realPositionMenu = event.menu;
          // 赵士淞 - 终
          GoRouter.of(state.context).go('/' + event.menu.route!);

          //sp端隐藏menu
          if (!kIsWeb) {
            //隐藏侧边menu
            // 持久化状态更新
            StoreProvider.of<WMSState>(event.context)
                .dispatch(RefreshMenuExpandAction(false));
          }
        }
      }

      emit(HomeMenuModel.copy(state));
    });

    on<ChangeToSpecialMenuEvent>((event, emit) async {
      int parentId = ((event.menuId ~/ 100)) * 100;
      if (parentId == event.menuId) {
        MenuItem currentMenu =
            state.menuList.firstWhere((element) => element.index == parentId);
        add(ChangeMenuEvent(currentMenu, event.context));
      } else {
        MenuItem parentMenu =
            state.menuList.firstWhere((element) => element.index == parentId);
        MenuItem currentMenu = parentMenu.children!
            .firstWhere((element) => element.index == event.menuId);
        add(ChangeMenuEvent(currentMenu, event.context));
      }
    });

    //返回同时改变底部导航栏显示状态
    on<FootChangeState>((event, emit) async {
      state.currentMenu!.isSelected = false;
      event.menu.isSelected = true;
      state.currentMenu = event.menu;
    });

    // 设置菜单商品编码/JANCD事件
    on<SetMenuProductCodeOrJanCdEvent>((event, emit) async {
      // 菜单商品编码/JANCD
      state.menuProductCodeOrJanCd = event.value;
      emit(HomeMenuModel.copy(state));
    });

    // 改变菜单商品事件
    on<ChangeMenuProductEvent>((event, emit) async {
      state.currentMenu!.isSelected = false;
      event.menu.isSelected = true;
      state.currentMenu = event.menu;
      if (event.menu.route == Config.PAGE_FLAG_9) {
        // 赵士淞 - 始
        // 真实位置菜单
        state.realPositionMenu = event.menu;
        // 赵士淞 - 终
        GoRouter.of(state.context).go('/' +
            event.menu.route! +
            '/' +
            state.menuProductCodeOrJanCd +
            '/' +
            Random().nextInt(100).toString());

        //sp端隐藏menu
        if (!kIsWeb) {
          //隐藏侧边menu
          // 持久化状态更新
          StoreProvider.of<WMSState>(event.context)
              .dispatch(RefreshMenuExpandAction(false));
        }
      }

      emit(HomeMenuModel.copy(state));
    });

    // 打开新增商品页面事件
    on<OpenAddProductPageEvent>((event, emit) async {
      // 跳转页面
      GoRouter.of(state.context).push('/productMaster');
      // 触发菜单变更事件
      add(ChangeMenuEvent(state.menuList[5], state.context));
      //sp端隐藏menu
      if (!kIsWeb) {
        //隐藏侧边menu
        // 持久化状态更新
        StoreProvider.of<WMSState>(state.context)
            .dispatch(RefreshMenuExpandAction(false));
      }
    });

    // 赵士淞 - 始
    add(InitEvent());
    // 赵士淞 - 终
  }

  // 赵士淞 - 始
  // 检查菜单商品编码/JANCD
  Future<String> checkMenuProductCodeOrJanCd(BuildContext context) async {
    if (state.menuProductCodeOrJanCd == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.home_menu_product_code_or_jan_cd +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return 'no-input';
    }

    int count = await searchProductInformation('code', context);
    if (count == 0) {
      count = await searchProductInformation('jan_cd', context);
      if (count == 0) {
        return 'no-data';
      }
    }

    return '';
  }

  Future<int> searchProductInformation(
      String flag, BuildContext context) async {
    // 查询商品マスタ
    var query = SupabaseUtils.getClient().from('mtb_product').select('*');
    // 判断标记
    if (flag == 'code') {
      query = query.eq('code', state.menuProductCodeOrJanCd);
    } else if (flag == 'jan_cd') {
      query = query.eq('jan_cd', state.menuProductCodeOrJanCd);
    }
    // 登录角色不是超级管理员
    if (Config.ROLE_ID_1 !=
        StoreProvider.of<WMSState>(context).state.loginUser!.role_id as int) {
      query = query.eq(
          'company_id',
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id
              as int);
    }
    List<dynamic> data = await query.order('id', ascending: false);

    return data.length;
  }

  // 初始化菜单列表处理
  List<MenuItem> initMenuListHandle(List<MenuItem>? menuList) {
    // 登录权限
    List<dynamic> loginAuthority =
        StoreProvider.of<WMSState>(state.context).state.loginAuthority;

    // 循环菜单列表
    for (int i = 0; i < menuList!.length; i++) {
      // 菜单
      MenuItem menuItem = menuList[i];

      // 判断菜单路径是否为空
      if (menuItem.route != null && menuItem.route != '') {
        // 菜单有效路径
        String menuItemValidRoute = menuRouteHandle(menuItem.route);

        // 循环登录权限
        for (int j = 0; j < loginAuthority.length; j++) {
          // 权限菜单
          dynamic authorityMenu = loginAuthority[j];

          // 判断权限菜单路径
          if (authorityMenu['menu_path'] != null &&
              authorityMenu['menu_path'] != '') {
            // 权限菜单有效路径
            String authorityMenuValidPath =
                menuRouteHandle(authorityMenu['menu_path'] as String);

            // 判断菜单有效路径与权限菜单有效路径是否相等
            if (menuItemValidRoute == authorityMenuValidPath) {
              // 中止循环
              break;
            }
          }

          // 判断循环是否结束
          if (j == loginAuthority.length - 1) {
            // 菜单列表移除
            menuList.remove(menuItem);
            // 下标回滚
            i--;
          }
        }
      }

      // 判断菜单子级是否为空
      if (menuItem.children != null && menuItem.children?.length != 0) {
        // 菜单子级
        menuItem.children = initMenuListHandle(menuItem.children);

        // 判断菜单子级是否有值
        if (menuItem.children?.length == 0) {
          // 菜单列表移除
          menuList.remove(menuItem);
          // 下标回滚
          i--;
        }
      }
    }

    // 返回
    return menuList;
  }

  // 菜单路径处理
  String menuRouteHandle(String? menuRoute) {
    // 有效路径
    String validRoute = '';

    // 判断指定文本位置
    if (menuRoute?.indexOf('/') == -1) {
      // 有效路径
      validRoute = menuRoute!;
    } else if (menuRoute?.indexOf('/') == 0) {
      // 有效路径
      validRoute = menuRoute!.substring(1, menuRoute.length);
      // 判断指定文本位置
      if (validRoute.indexOf('/') != -1) {
        // 有效路径
        validRoute = validRoute.substring(0, validRoute.indexOf('/'));
      }
    } else {
      // 有效路径
      validRoute = menuRoute!.substring(0, menuRoute.indexOf('/'));
    }

    // 返回
    return validRoute;
  }

  // 页面跳转循环
  MenuItem pageJumpForeach(List<MenuItem> menuList, String targetRoute) {
    // 循环菜单列表
    for (int i = 0; i < menuList.length; i++) {
      // 当前菜单
      MenuItem currentMenu = menuList[i];

      // 处理后菜单路径
      String postMenuRoute = '';
      // 判断当前菜单路径
      if (currentMenu.route != null) {
        // 处理后菜单路径
        postMenuRoute = currentMenu.route.toString();
        // 判断当前菜单路径
        if (postMenuRoute.indexOf('/') != -1) {
          // 处理后菜单路径
          postMenuRoute =
              postMenuRoute.substring(0, postMenuRoute.indexOf('/'));
        }
      }

      // 判断目标路径与处理后菜单路径是否一致
      if (targetRoute == postMenuRoute) {
        // 当前菜单
        return currentMenu;
      }

      // 判断当前菜单是否有子级
      if (currentMenu.children != null && currentMenu.children?.length != 0) {
        // 页面跳转循环
        MenuItem childMenu =
            pageJumpForeach(currentMenu.children!, targetRoute);
        // 判断结果
        if (childMenu.index != Config.NUMBER_NEGATIVE) {
          return childMenu;
        }
      }
    }
    // 返回
    return MenuItem(
      index: Config.NUMBER_NEGATIVE,
      icon: Config.NUMBER_NEGATIVE.toString(),
      title: Config.NUMBER_NEGATIVE.toString(),
    );
  }

  // 菜单标题
  String menuTitle(int menuIndex) {
    if (menuIndex == Config.MENU_FLAG_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_1;
    } else if (menuIndex == Config.MENU_FLAG_2) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2;
    } else if (menuIndex == Config.MENU_FLAG_2_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_1;
    } else if (menuIndex == Config.MENU_FLAG_2_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_5;
    } else if (menuIndex == Config.MENU_FLAG_2_4) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_4;
    } else if (menuIndex == Config.MENU_FLAG_2_3) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_3;
    } else if (menuIndex == Config.MENU_FLAG_2_7) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_7;
    } else if (menuIndex == Config.MENU_FLAG_2_12) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_12;
    } else if (menuIndex == Config.MENU_FLAG_2_16) {
      return WMSLocalizations.i18n(state.context)!.menu_content_2_16;
    } else if (menuIndex == Config.MENU_FLAG_3) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3;
    } else if (menuIndex == Config.MENU_FLAG_3_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_1;
    } else if (menuIndex == Config.MENU_FLAG_3_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_5;
    } else if (menuIndex == Config.MENU_FLAG_3_11) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_11;
    } else if (menuIndex == Config.MENU_FLAG_3_8) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_8;
    } else if (menuIndex == Config.MENU_FLAG_3_12) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_12;
    } else if (menuIndex == Config.MENU_FLAG_3_16) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_16;
    } else if (menuIndex == Config.MENU_FLAG_3_21) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_21;
    } else if (menuIndex == Config.MENU_FLAG_3_13) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_13;
    } else if (menuIndex == Config.MENU_FLAG_3_26) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_26;
    } else if (menuIndex == Config.MENU_FLAG_3_28) {
      return WMSLocalizations.i18n(state.context)!.menu_content_3_28;
    } else if (menuIndex == Config.MENU_FLAG_4) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4;
    } else if (menuIndex == Config.MENU_FLAG_4_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_1;
    } else if (menuIndex == Config.MENU_FLAG_4_10) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_10;
    } else if (menuIndex == Config.MENU_FLAG_4_4) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_4;
    } else if (menuIndex == Config.MENU_FLAG_4_8) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_8;
    } else if (menuIndex == Config.MENU_FLAG_4_13) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_13;
    } else if (menuIndex == Config.MENU_FLAG_4_16) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_16;
    } else if (menuIndex == Config.MENU_FLAG_4_17) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_17;
    } else if (menuIndex == Config.MENU_FLAG_4_18) {
      return WMSLocalizations.i18n(state.context)!.menu_content_4_18;
    } else if (menuIndex == Config.MENU_FLAG_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_5;
    } else if (menuIndex == Config.MENU_FLAG_5_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_5_1;
    } else if (menuIndex == Config.MENU_FLAG_60_5_2) {
      return WMSLocalizations.i18n(state.context)!.menu_content_5_2;
    } else if (menuIndex == Config.MENU_FLAG_5_9) {
      return WMSLocalizations.i18n(state.context)!.menu_content_5_9;
    } else if (menuIndex == Config.MENU_FLAG_5_11) {
      return WMSLocalizations.i18n(state.context)!.menu_content_5_11;
    } else if (menuIndex == Config.MENU_FLAG_5_3) {
      return WMSLocalizations.i18n(state.context)!.menu_content_5_3;
    } else if (menuIndex == Config.MENU_FLAG_6) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6;
    } else if (menuIndex == Config.MENU_FLAG_6_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_1;
    } else if (menuIndex == Config.MENU_FLAG_6_2) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_2;
    } else if (menuIndex == Config.MENU_FLAG_6_3) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_3;
    } else if (menuIndex == Config.MENU_FLAG_6_4) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_4;
    } else if (menuIndex == Config.MENU_FLAG_6_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_5;
    } else if (menuIndex == Config.MENU_FLAG_6_6) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_6;
    } else if (menuIndex == Config.MENU_FLAG_6_7) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_7;
    } else if (menuIndex == Config.MENU_FLAG_6_8) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_8;
    } else if (menuIndex == Config.MENU_FLAG_6_9) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_9;
    } else if (menuIndex == Config.MENU_FLAG_6_10) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_10;
    } else if (menuIndex == Config.MENU_FLAG_6_11) {
      return WMSLocalizations.i18n(state.context)!.menu_content_6_11;
    } else if (menuIndex == Config.MENU_FLAG_7) {
      return WMSLocalizations.i18n(state.context)!.menu_content_7;
    } else if (menuIndex == Config.MENU_FLAG_7_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_7_1;
    } else if (menuIndex == Config.MENU_FLAG_7_2) {
      return WMSLocalizations.i18n(state.context)!.menu_content_7_2;
    } else if (menuIndex == Config.MENU_FLAG_7_3) {
      return WMSLocalizations.i18n(state.context)!.menu_content_7_3;
    } else if (menuIndex == Config.MENU_FLAG_8) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8;
    } else if (menuIndex == Config.MENU_FLAG_8_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_1;
    } else if (menuIndex == Config.MENU_FLAG_8_3) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_3;
    } else if (menuIndex == Config.MENU_FLAG_8_4) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_4;
    } else if (menuIndex == Config.MENU_FLAG_8_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_5;
    } else if (menuIndex == Config.MENU_FLAG_8_6) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_6;
    } else if (menuIndex == Config.MENU_FLAG_8_10) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_10;
    } else if (menuIndex == Config.MENU_FLAG_8_16) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_16;
    } else if (menuIndex == Config.MENU_FLAG_8_19) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_19;
    } else if (menuIndex == Config.MENU_FLAG_8_21) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_21;
    } else if (menuIndex == Config.MENU_FLAG_8_22) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_22;
    } else if (menuIndex == Config.MENU_FLAG_8_23) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_23;
    } else if (menuIndex == Config.MENU_FLAG_8_24) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_24;
    } else if (menuIndex == Config.MENU_FLAG_9) {
      if (kIsWeb) {
        return WMSLocalizations.i18n(state.context)!.menu_content_9;
      } else {
        return WMSLocalizations.i18n(state.context)!.menu_content_9_s;
      }
    } else if (menuIndex == Config.MENU_FLAG_50) {
      return WMSLocalizations.i18n(state.context)!.menu_content_50;
    } else if (menuIndex == Config.MENU_FLAG_50_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_50_1;
    } else if (menuIndex == Config.MENU_FLAG_50_2) {
      return WMSLocalizations.i18n(state.context)!.home_head_notice_text2;
    } else if (menuIndex == Config.MENU_FLAG_60) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60;
    } else if (menuIndex == Config.MENU_FLAG_60_2_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_2_5;
    } else if (menuIndex == Config.MENU_FLAG_60_3_11) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_3_11;
    } else if (menuIndex == Config.MENU_FLAG_60_3_26) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_3_26;
    } else if (menuIndex == Config.MENU_FLAG_60_2_12_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_2_12_1;
    } else if (menuIndex == Config.MENU_FLAG_60_2_12_2) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_2_12_2;
    } else if (menuIndex == Config.MENU_FLAG_60_3_21) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_3_21;
    } else if (menuIndex == Config.MENU_FLAG_60_5_9) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_5_9;
    } else if (menuIndex == Config.MENU_FLAG_60_3_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_3_5;
    } else if (menuIndex == Config.MENU_FLAG_98) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98;
    } else if (menuIndex == Config.MENU_FLAG_98_5) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_5;
    } else if (menuIndex == Config.MENU_FLAG_98_8) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_8;
    } else if (menuIndex == Config.MENU_FLAG_98_11) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_11;
    } else if (menuIndex == Config.MENU_FLAG_98_22) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_22;
    } else if (menuIndex == Config.MENU_FLAG_98_23) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_23;
    } else if (menuIndex == Config.MENU_FLAG_98_24) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_24;
    } else if (menuIndex == Config.MENU_FLAG_98_25) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_25;
    } else if (menuIndex == Config.MENU_FLAG_98_26) {
      return WMSLocalizations.i18n(state.context)!.menu_content_98_26;
    } else if (menuIndex == Config.MENU_FLAG_60_98_25) {
      return WMSLocalizations.i18n(state.context)!.menu_content_60_98_25;
    } else if (menuIndex == Config.MENU_FLAG_99) {
      return WMSLocalizations.i18n(state.context)!.menu_content_99;
    } else if (menuIndex == Config.MENU_FLAG_99_2) {
      return WMSLocalizations.i18n(state.context)!.menu_content_99_2;
    } else if (menuIndex == Config.MENU_FLAG_99_6) {
      return WMSLocalizations.i18n(state.context)!.menu_content_99_6;
    } else if (menuIndex == Config.MENU_FLAG_8_7) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_7;
    } else if (menuIndex == Config.MENU_FLAG_8_8) {
      return WMSLocalizations.i18n(state.context)!.menu_content_8_8;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_1) {
      return WMSLocalizations.i18n(state.context)!.menu_content_1;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_2) {
      return WMSLocalizations.i18n(state.context)!.corporate_management_title;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_2_1) {
      return WMSLocalizations.i18n(state.context)!.corporate_management_menu_1;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_2_2) {
      return WMSLocalizations.i18n(state.context)!.corporate_management_menu_2;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_2_3) {
      return WMSLocalizations.i18n(state.context)!.corporate_management_menu_3;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_3) {
      return WMSLocalizations.i18n(state.context)!.plan_title_text;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_3_1) {
      return WMSLocalizations.i18n(state.context)!.plan_menu_text_1;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_3_2) {
      return WMSLocalizations.i18n(state.context)!.plan_menu_text_2;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_4) {
      return WMSLocalizations.i18n(state.context)!.message_master_base_title;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_4_1) {
      return WMSLocalizations.i18n(state.context)!.message_master_menu_1;
    } else if (menuIndex == Config.MENU_FLAG_ADMIN_4_2) {
      return WMSLocalizations.i18n(state.context)!.message_master_title;
    } else {
      return '';
    }
  }
  // 赵士淞 - 终
}
