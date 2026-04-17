// 首页框架菜单内容
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/config/config.dart';
import '../../../redux/wms_state.dart';
import '../bloc/home_menu_bloc.dart';
import 'home_menu_children.dart';
import '../bloc/home_menu_item.dart';
import '../bloc/home_menu_model.dart';
import 'home_menu_product.dart';

class HomeMenuContent extends StatefulWidget {
  final MenuType menuType;
  HomeMenuContent(this.menuType, {super.key});
  @override
  State<HomeMenuContent> createState() => _HomeMenuContentState();
}

class _HomeMenuContentState extends State<HomeMenuContent> {
  // 初始化菜单列表
  List<Widget> _initMenuList(List<MenuItem> menuList) {
    // 作成列表
    List<Widget> creationList = [];
    // 循环菜单列表
    for (var i = 0; i < menuList.length; i++) {
      // 判断菜单是否是50/60系
      if (menuList[i].visiable == true &&
          (menuList[i].type == widget.menuType ||
              widget.menuType == MenuType.All)) {
        // 作成列表
        creationList.add(
          MouseRegion(
            onEnter: (event) {
              // 设置悬停菜单下标事件
              context
                  .read<HomeMenuBloc>()
                  .add(SetHoverMenuIndexEvent(menuList[i].index));
              // 定时器
              Timer(Duration(milliseconds: 500), () {
                if (context
                        .read<HomeMenuBloc>()
                        .state
                        .hoverMenuIndex
                        .toString() ==
                    menuList[i].index.toString()) {
                  // 判断是否是商品一览画面
                  if (menuList[i].route == Config.PAGE_FLAG_9) {
                    // 显示菜单商品
                    HomeMenuProduct.show(
                      context: context,
                      myself: menuList[i],
                    );
                  } else {
                    // 显示菜单商品
                    HomeMenuProduct.hide();
                  }
                  // 判断子级是否为空
                  if (menuList[i].children != null &&
                      menuList[i].children!.length != 0) {
                    // 显示菜单子级
                    HomeMenuChildren.show(
                      context: context,
                      title: context
                          .read<HomeMenuBloc>()
                          .menuTitle(menuList[i].index),
                      children: menuList[i].children!,
                    );
                  } else {
                    // 隐藏菜单子级
                    HomeMenuChildren.hide();
                  }
                  // 触发菜单变更事件
                  context
                      .read<HomeMenuBloc>()
                      .add(HoverMenuEvent(menuList[i], context));
                }
              });
            },
            child: GestureDetector(
              onTap: () {
                // 触发菜单变更事件
                context
                    .read<HomeMenuBloc>()
                    .add(ChangeMenuEvent(menuList[i], context));
              },
              child: Container(
                height: 56,
                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                decoration: BoxDecoration(
                  color: menuList[i].isSelected ||
                          (menuList[i].children != null &&
                              menuList[i].children!.length > 0 &&
                              menuList[i]
                                  .children!
                                  .any((element) => element.isSelected))
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : null,
                  borderRadius: menuList[i].isSelected ||
                          (menuList[i].children != null &&
                              menuList[i].children!.length > 0 &&
                              menuList[i]
                                  .children!
                                  .any((element) => element.isSelected))
                      ? BorderRadius.circular(50)
                      : null,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: StoreProvider.of<WMSState>(context, listen: false)
                              .state
                              .menuExpand
                          ? 198
                          : 0,
                      child: Stack(
                        children: [
                          Image.asset(
                            menuList[i].icon,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                            repeat: ImageRepeat.noRepeat,
                            color: menuList[i].isSelected ||
                                    (menuList[i].children != null &&
                                        menuList[i].children!.length > 0 &&
                                        menuList[i].children!.any(
                                            (element) => element.isSelected))
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : null,
                          ),
                          Positioned(
                            left: 40,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                              child: Text(
                                context
                                    .read<HomeMenuBloc>()
                                    .menuTitle(menuList[i].index),
                                style: TextStyle(
                                  fontSize:
                                      menuList[i].route == Config.PAGE_FLAG_9
                                          ? 15
                                          : 16,
                                  fontWeight: FontWeight.w500,
                                  color: menuList[i].isSelected ||
                                          (menuList[i].children != null &&
                                              menuList[i].children!.length >
                                                  0 &&
                                              menuList[i].children!.any(
                                                  (element) =>
                                                      element.isSelected))
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(44, 167, 176, 1),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: menuList[i].children != null ? 10 : 0,
                              height: 10,
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                              decoration: BoxDecoration(
                                color: menuList[i].isSelected ||
                                        (menuList[i].children != null &&
                                            menuList[i].children!.length > 0 &&
                                            menuList[i].children!.any(
                                                (element) =>
                                                    element.isSelected))
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(44, 167, 176, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: menuList[i].isSelected ? -62 : 0,
                      right: menuList[i].isSelected ? -100 : 0,
                      child: Container(
                        width: menuList[i].isSelected &&
                                StoreProvider.of<WMSState>(context,
                                        listen: false)
                                    .state
                                    .menuExpand &&
                                HomeMenuChildren.showFlag() &&
                                menuList[i].children != null &&
                                menuList[i].children!.length > 0
                            ? 100
                            : 0,
                        height: menuList[i].isSelected &&
                                StoreProvider.of<WMSState>(context,
                                        listen: false)
                                    .state
                                    .menuExpand &&
                                HomeMenuChildren.showFlag() &&
                                menuList[i].children != null &&
                                menuList[i].children!.length > 0
                            ? 164
                            : 0,
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 56,
                              margin: EdgeInsets.fromLTRB(0, 54, 0, 54),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                            Container(
                              width: 56,
                              height: 164,
                              child: Transform(
                                transform: Matrix4.identity()
                                  ..scale(1.2, 1.0, 1.0),
                                alignment: Alignment.centerLeft,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 164,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(240, 250, 250, 1),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 54,
                                            child: Container(
                                              width: 28,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    44, 167, 176, 1),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(28),
                                                  bottomRight:
                                                      Radius.circular(28),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      child: Container(
                                        width: 28,
                                        height: 32.8,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          border: Border(
                                            top: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                            right: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                            bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                            left: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft:
                                                Radius.elliptical(28, 32.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 32.8,
                                      left: 28,
                                      child: Container(
                                        width: 28,
                                        height: 49.2,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(240, 250, 250, 1),
                                          border: Border(
                                            top: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                            right: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                            bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                            left: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topRight:
                                                Radius.elliptical(28, 49.2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: 28,
                                        height: 32.8,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          border: Border(
                                            top: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                            right: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                            bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                            left: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.elliptical(28, 32.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 32.8,
                                      left: 28,
                                      child: Container(
                                        width: 28,
                                        height: 49.2,
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(240, 250, 250, 1),
                                          border: Border(
                                            top: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                            right: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                            bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                            ),
                                            left: BorderSide(
                                              color: Color.fromRGBO(
                                                  44, 167, 176, 1),
                                              width: 0,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.only(
                                            bottomRight:
                                                Radius.elliptical(28, 49.2),
                                          ),
                                        ),
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
              ),
            ),
          ),
        );
      }
    }
    // 作成列表
    return creationList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) => Container(
        child: ListView(
          clipBehavior: Clip.none,
          children: _initMenuList(state.menuList),
        ),
      ),
    );
  }
}
