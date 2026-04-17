import 'package:flutter/material.dart';

import 'home_menu_item.dart';

class HomeMenuModel {
  // 赵士淞 - 始
  // 选中语言
  int selectedLanguage = 2;
  // 多语言列表
  List<Map<String, dynamic>> languageList = [];
  // 真实位置菜单
  MenuItem? realPositionMenu = null;
  // 目标路径
  String targetPath = '/';
  // 悬停菜单下标
  int hoverMenuIndex = 0;
  // 菜单商品编码/JANCD
  String menuProductCodeOrJanCd = '';

  // 赵士淞 - 终
  MenuItem? currentMenu = null;
  List<MenuItem> menuList = <MenuItem>[];
  BuildContext context;

  HomeMenuModel(
    this.context, {
    // 赵士淞 - 始
    this.selectedLanguage = 2,
    this.languageList = const [],
    this.targetPath = '/',
    this.hoverMenuIndex = 0,
    this.menuProductCodeOrJanCd = '',
    // 赵士淞 - 终
    List<Map<String, dynamic>> menuInfoList = const [],
  }) {
    menuInfoList.forEach((element) {
      menuList.add(MenuItem.fromJson(element));
    });
    if (menuInfoList.length > 0) {
      menuList[0].isSelected = true;
      // 赵士淞 - 始
      // 真实位置菜单
      realPositionMenu = menuList[0];
      // 赵士淞 - 终
      currentMenu = menuList[0];
    }
  }

  factory HomeMenuModel.copy(HomeMenuModel src) {
    HomeMenuModel dest = HomeMenuModel(src.context);
    // 赵士淞 - 始
    dest.selectedLanguage = src.selectedLanguage;
    dest.languageList = src.languageList;
    dest.realPositionMenu = src.realPositionMenu;
    dest.targetPath = src.targetPath;
    dest.hoverMenuIndex = src.hoverMenuIndex;
    dest.menuProductCodeOrJanCd = src.menuProductCodeOrJanCd;
    // 赵士淞 - 终
    dest.menuList = src.menuList;
    dest.currentMenu = src.currentMenu;
    return dest;
  }
}
