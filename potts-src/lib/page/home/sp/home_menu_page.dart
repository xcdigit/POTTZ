import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../redux/wms_state.dart';
import '../bloc/home_menu_item.dart';
import 'home_menu_children.dart';
import 'home_menu_content.dart';
import 'home_menu_product.dart';

/**
 * 内容：首页框架菜单
 * 作者：赵士淞
 * 时间：2023/10/16
 */
class HomeMenuPage extends StatefulWidget {
  const HomeMenuPage({super.key});

  @override
  State<HomeMenuPage> createState() => _HomeMenuPageState();
}

class _HomeMenuPageState extends State<HomeMenuPage> {
  // 当前其他容器操作菜单子级
  bool _currentOtherWidgetOperateMenuChild = false;

  @override
  Widget build(BuildContext context) {
    // 判断其他容器操作菜单子级与当前其他容器操作菜单子级是否一致
    if (StoreProvider.of<WMSState>(context).state.otherWidgetOperateMenuChild !=
        _currentOtherWidgetOperateMenuChild) {
      // 当前其他容器操作菜单子级
      _currentOtherWidgetOperateMenuChild =
          StoreProvider.of<WMSState>(context).state.otherWidgetOperateMenuChild;
      // 隐藏菜单子级
      HomeMenuChildren.hide();
      // 隐藏菜单商品
      HomeMenuProduct.hide();
    }
    return Container(
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(102, 199, 206, 0.1),
        border: Border.all(
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            width: 40,
            height: MediaQuery.of(context).size.height - 340,
            child: HomeMenuContent(MenuType.Menu),
          ),
          Positioned(
            bottom: 0,
            width: 40,
            height: 116,
            child: HomeMenuContent(MenuType.Setting),
          ),
        ],
      ),
    );
  }
}
