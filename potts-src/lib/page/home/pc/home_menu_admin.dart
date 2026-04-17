import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_item.dart';
import '../bloc/home_menu_model.dart';

class HomeMenuAdmin extends StatefulWidget {
  final MenuType menuType;

  HomeMenuAdmin(this.menuType, {super.key});

  @override
  State<HomeMenuAdmin> createState() => _HomeMenuAdminState();
}

class _HomeMenuAdminState extends State<HomeMenuAdmin> {
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
        creationList.add(_initMenuItem(menuList[i], 1));
        // 判断菜单是否选中
        if (menuList[i].children != null &&
            menuList[i].children!.length > 0 &&
            (menuList[i].isSelected ||
                menuList[i].children!.any((element) => element.isSelected))) {
          for (var j = 0; j < menuList[i].children!.length; j++) {
            // 作成列表
            creationList.add(_initMenuItem(menuList[i].children![j], 2));
          }
        }
      }
    }
    // 作成列表
    return creationList;
  }

  Widget _initMenuItem(MenuItem menuItem, int index) {
    return GestureDetector(
      onTap: () {
        // 触发菜单变更事件
        context
            .read<HomeMenuBloc>()
            .add(ChangeAdminMenuEvent(menuItem, context));
      },
      child: Container(
        height: 56,
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
        decoration: BoxDecoration(
          color: menuItem.isSelected ? Color.fromRGBO(44, 167, 176, 1) : null,
          borderRadius: menuItem.isSelected ? BorderRadius.circular(50) : null,
        ),
        child: Stack(
          children: [
            index == 1
                ? Image.asset(
                    menuItem.icon,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    repeat: ImageRepeat.noRepeat,
                    color: menuItem.isSelected
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : null,
                  )
                : Container(
                    width: 40,
                    height: 40,
                  ),
            Positioned(
              left: 40,
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Text(
                  context.read<HomeMenuBloc>().menuTitle(menuItem.index),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: menuItem.isSelected
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
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text(
                  menuItem.isSelected ||
                          (menuItem.children != null &&
                              menuItem.children!.length > 0 &&
                              menuItem.children!
                                  .any((element) => element.isSelected))
                      ? "－"
                      : "＋",
                  style: TextStyle(
                    fontSize: menuItem.children != null ? 16 : 0,
                    fontWeight: FontWeight.w500,
                    color: menuItem.isSelected
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(44, 167, 176, 1),
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) => Container(
        child: ListView(
          children: _initMenuList(state.menuList),
        ),
      ),
    );
  }
}
