import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/config/config.dart';
import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_item.dart';
import '../bloc/home_menu_model.dart';
import 'home_menu_children.dart';
import 'home_menu_product.dart';

/**
 * 内容：首页框架菜单内容
 * 作者：赵士淞
 * 时间：2023/10/16
 */
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
          GestureDetector(
            onTap: () {
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
                  title:
                      context.read<HomeMenuBloc>().menuTitle(menuList[i].index),
                  children: menuList[i].children!,
                );
              } else {
                // 隐藏菜单子级
                HomeMenuChildren.hide();
              }
              // 触发菜单变更事件
              context
                  .read<HomeMenuBloc>()
                  .add(ChangeMenuEvent(menuList[i], context));
            },
            child: Container(
              height: 40,
              // margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
              padding: EdgeInsets.all(6),
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
                    ? BorderRadius.circular(6)
                    : null,
              ),
              child: Image.asset(
                menuList[i].icon,
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                repeat: ImageRepeat.noRepeat,
                color: menuList[i].isSelected ||
                        (menuList[i].children != null &&
                            menuList[i].children!.length > 0 &&
                            menuList[i]
                                .children!
                                .any((element) => element.isSelected))
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : null,
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
          children: _initMenuList(state.menuList),
        ),
      ),
    );
  }
}
