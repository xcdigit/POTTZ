import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_item.dart';

// 菜单子级 OverlayEntry
OverlayEntry? menuChildrenOverlayEntry;
// 菜单子级显示标记
bool menuChildrenShowFlag = false;

/**
 * 内容：首页框架菜单子级
 * 作者：赵士淞
 * 时间：2023/10/16
 */
class HomeMenuChildren {
  // 显示
  static void show({
    required BuildContext context,
    required String title,
    required List<MenuItem> children,
  }) {
    // 判断菜单子级显示标记
    if (menuChildrenShowFlag) {
      // 移除 OverlayEntry
      menuChildrenOverlayEntry!.remove();
    } else {
      // 菜单子级显示标记
      menuChildrenShowFlag = true;
    }

    HomeMenuBloc bloc = context.read<HomeMenuBloc>();
    // 创建 OverlayEntry
    menuChildrenOverlayEntry = OverlayEntry(
      builder: (context) {
        return BlocProvider<HomeMenuBloc>.value(
          value: bloc,
          child: HomeMenuChildrenContent(title: title, children: children),
        );
      },
    );
    // 插入到 Overlay 中显示 OverlayEntry
    Overlay.of(context).insert(menuChildrenOverlayEntry!);
  }

  // 隐藏
  static void hide() {
    // 判断菜单子级显示标记
    if (menuChildrenShowFlag) {
      // 移除 OverlayEntry
      menuChildrenOverlayEntry!.remove();
      // 菜单子级显示标记
      menuChildrenShowFlag = false;
    }
  }
}

class HomeMenuChildrenContent extends StatefulWidget {
  // 标题
  final String title;
  // 子级
  final List<MenuItem> children;

  HomeMenuChildrenContent({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<HomeMenuChildrenContent> createState() =>
      _HomeMenuChildrenContentState();
}

class _HomeMenuChildrenContentState extends State<HomeMenuChildrenContent> {
  // 当前位置
  int _currentLocation = 0;

  // 初始化子级
  _initChildren() {
    // 初始化滚动视图
    _initPageView() {
      // 滚动视图列表
      List<Widget> pageViewList = [];
      // 横向数量
      int horizontalQuantity =
          (MediaQuery.of(context).size.width / 1.28 - 28 - 28) ~/ 108;
      // 纵向数量
      int verticalQuantity =
          (MediaQuery.of(context).size.height / 1.43 - 24 - 40 - 48 - 24) ~/
              112;
      // 分页数量
      int pageViewQuantity =
          (widget.children.length / (horizontalQuantity * verticalQuantity))
              .ceil();

      // 循环分页数量
      for (int i = 0; i < pageViewQuantity; i++) {
        // 初始化滚动元素
        _initPageItem() {
          // 滚动元素列表
          List<Widget> pageItemList = [];
          // 开始下标
          int startIndex = i * (horizontalQuantity * verticalQuantity);
          // 结束下标
          int endIndex;
          // 判断是否是最后一页
          if (i == pageViewQuantity - 1) {
            // 结束下标
            endIndex = widget.children.length;
          } else {
            // 结束下标
            endIndex = (i + 1) * (horizontalQuantity * verticalQuantity);
          }
          // 循环可用下标
          for (int tempIndex = startIndex; tempIndex < endIndex; tempIndex++) {
            // 滚动元素列表
            pageItemList.add(
              GestureDetector(
                onTap: () {
                  // 判断页面是否为空
                  if (widget.children[tempIndex].route != null) {
                    context.read<HomeMenuBloc>().add(
                        ChangeMenuEvent(widget.children[tempIndex], context));
                    // 隐藏菜单子级
                    HomeMenuChildren.hide();
                  }
                },
                child: Container(
                  width: 96,
                  height: 96,
                  margin: EdgeInsets.fromLTRB(6, 8, 6, 8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.fromLTRB(24, 14, 24, 0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 167, 176, 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Image.asset(
                            widget.children[tempIndex].icon,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      Container(
                        width: 96,
                        height: 34,
                        child: Center(
                          child: Text(
                            context
                                .read<HomeMenuBloc>()
                                .menuTitle(widget.children[tempIndex].index),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(6, 14, 15, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          // 滚动元素列表
          return pageItemList;
        }

        // 滚动视图列表
        pageViewList.add(
          Container(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: _initPageItem(),
            ),
          ),
        );
      }
      // 滚动视图列表
      return pageViewList;
    }

    return PageView(
      onPageChanged: (value) {
        // 状态变更
        setState(() {
          // 当前位置
          _currentLocation = value;
        });
      },
      children: _initPageView(),
    );
  }

  // 初始化提示点
  _initHints() {
    // 容器列表
    List<Widget> widgetList = [];
    // 横向数量
    int horizontalQuantity =
        (MediaQuery.of(context).size.width / 1.28 - 28 - 28) ~/ 108;
    // 纵向数量
    int verticalQuantity =
        (MediaQuery.of(context).size.height / 1.43 - 24 - 40 - 48 - 24) ~/ 112;
    // 分页数量
    int pageViewQuantity =
        (widget.children.length / (horizontalQuantity * verticalQuantity))
            .ceil();

    // 循环分页数量
    for (int i = 0; i < pageViewQuantity; i++) {
      // 判断是否是当前位置
      if (i == _currentLocation) {
        // 容器列表
        widgetList.add(
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      } else {
        // 容器列表
        widgetList.add(
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 108,
      left: 72,
      child: Container(
        width: MediaQuery.of(context).size.width / 1.28,
        height: MediaQuery.of(context).size.height / 1.43,
        padding: EdgeInsets.fromLTRB(28, 24, 28, 24),
        decoration: BoxDecoration(
          color: Color.fromRGBO(44, 167, 176, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(252, 255, 255, 1),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Container(
              height:
                  MediaQuery.of(context).size.height / 1.43 - 24 - 40 - 48 - 24,
              child: _initChildren(),
            ),
            Container(
              height: 48,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _initHints(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
