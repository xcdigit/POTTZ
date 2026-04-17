import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/config/config.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/menu_expand_reducer.dart';
import '../../../redux/wms_state.dart';
import 'home_menu_admin.dart';
import 'home_menu_children.dart';
import 'home_menu_content.dart';
import '../bloc/home_menu_item.dart';
import 'home_menu_product.dart';

/**
 * 内容：首页框架菜单
 * 作者：赵士淞
 * 时间：2023/07/25
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
    // 整体
    return Container(
      padding: StoreProvider.of<WMSState>(context).state.menuExpand
          ? EdgeInsets.all(14)
          : null,
      margin: StoreProvider.of<WMSState>(context).state.menuExpand
          ? EdgeInsets.all(20)
          : EdgeInsets.fromLTRB(54, 44, 54, 44),
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 250, 250, 1),
        border: Border.all(
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
        borderRadius: StoreProvider.of<WMSState>(context).state.menuExpand
            ? BorderRadius.circular(30)
            : BorderRadius.circular(10),
      ),
      // 菜单内容
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 打开/关闭按钮
          HomeMenuButton(),
          // 菜单明细
          Positioned(
            top: 76,
            height: MediaQuery.of(context).size.height - 500,
            width: StoreProvider.of<WMSState>(context, listen: false)
                    .state
                    .menuExpand
                ? 258
                : 0,
            child:
                StoreProvider.of<WMSState>(context).state.loginUser?.role_id ==
                        Config.ROLE_ID_1
                    ? HomeMenuAdmin(MenuType.Menu)
                    : HomeMenuContent(MenuType.Menu),
          ),
          // 系统设置
          Positioned(
            bottom: 0,
            height: 192,
            width: StoreProvider.of<WMSState>(context, listen: false)
                    .state
                    .menuExpand
                ? 258
                : 0,
            child:
                StoreProvider.of<WMSState>(context).state.loginUser?.role_id ==
                        Config.ROLE_ID_1
                    ? HomeMenuAdmin(MenuType.Setting)
                    : HomeMenuContent(MenuType.Setting),
          ),
        ],
      ),
    );
  }
}

// 首页框架菜单按钮
class HomeMenuButton extends StatefulWidget {
  const HomeMenuButton({super.key});

  @override
  State<HomeMenuButton> createState() => _HomeMenuButtonState();
}

class _HomeMenuButtonState extends State<HomeMenuButton> {
  // 目前整体宽度
  double currentOverallWidth = 0;

  @override
  Widget build(BuildContext context) {
    // 判断容器宽度与目前整体宽度是否一致
    if (currentOverallWidth != MediaQuery.of(context).size.width) {
      // 目前整体宽度
      currentOverallWidth = MediaQuery.of(context).size.width;
      // 判断目前整体宽度与网页最小宽度限定
      if (currentOverallWidth < Config.WEB_MINI_WIDTH_LIMIT) {
        // 持久化状态更新
        StoreProvider.of<WMSState>(context)
            .dispatch(RefreshMenuExpandAction(false));
      } else {
        // 持久化状态更新
        StoreProvider.of<WMSState>(context)
            .dispatch(RefreshMenuExpandAction(true));
      }
      // 隐藏菜单子级
      HomeMenuChildren.hide();
      // 隐藏菜单商品
      HomeMenuProduct.hide();
    }
    return GestureDetector(
      onTap: () {
        // 持久化状态更新
        StoreProvider.of<WMSState>(context).dispatch(RefreshMenuExpandAction(
            !StoreProvider.of<WMSState>(context).state.menuExpand));
        // 隐藏菜单子级
        HomeMenuChildren.hide();
        // 隐藏菜单商品
        HomeMenuProduct.hide();
      },
      child: Container(
        height: StoreProvider.of<WMSState>(context).state.menuExpand ? 76 : 60,
        padding: StoreProvider.of<WMSState>(context).state.menuExpand
            ? EdgeInsets.fromLTRB(15, 18, 15, 18)
            : EdgeInsets.all(10),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: Image.asset(
                StoreProvider.of<WMSState>(context).state.menuExpand
                    ? WMSICons.HOME_MENU_CLOSE
                    : WMSICons.HOME_MENU_OPEN,
                width: 40,
                height: 40,
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
