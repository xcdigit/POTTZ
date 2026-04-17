import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/menu_expand_reducer.dart';
import '../../../redux/wms_state.dart';
import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_item.dart';
import '../bloc/home_menu_model.dart';
import '../bloc/menu_dropdown_widget.dart';
import 'home_menu_children.dart';
import 'home_menu_product.dart';

/**
 * 内容：首页框架底部
 * 作者：赵士淞
 * 时间：2023/10/17
 */
class HomeBottomPage extends StatefulWidget {
  const HomeBottomPage({super.key});

  @override
  State<HomeBottomPage> createState() => _HomeBottomPageState();
}

class _HomeBottomPageState extends State<HomeBottomPage> {
  // 初始化底部列表
  List<Widget> _initBottomList(List<MenuItem> menuList) {
    // 作成列表
    List<Widget> creationList = [];
    // 循环菜单列表
    for (var i = 0; i < menuList.length; i++) {
      // 判断菜单是否底部显示
      if (menuList[i].visiable == true && menuList[i].bottomDisplay == true) {
        // 作成列表
        creationList.add(
          GestureDetector(
            onTap: () {
              // 持久化状态更新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshMenuExpandAction(false));
              // 隐藏菜单子级
              HomeMenuChildren.hide();
              // 隐藏菜单商品
              HomeMenuProduct.hide();
              // 触发菜单变更事件
              context.read<HomeMenuBloc>().add(ChangeBottomEvent(menuList[i]));
            },
            child: Container(
              width: 56,
              height: 56,
              padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
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
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      menuList[i].icon,
                      width: 30,
                      height: 30,
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
                  Center(
                    child: Text(
                      context.read<HomeMenuBloc>().menuTitle(menuList[i].index),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                        color: menuList[i].isSelected ||
                                (menuList[i].children != null &&
                                    menuList[i].children!.length > 0 &&
                                    menuList[i]
                                        .children!
                                        .any((element) => element.isSelected))
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    // 作成列表
    creationList.add(
      GestureDetector(
        onTap: () {
          // 持久化状态更新
          StoreProvider.of<WMSState>(context)
              .dispatch(RefreshMenuExpandAction(false));
          // 隐藏菜单子级
          HomeMenuChildren.hide();
          // 隐藏菜单商品
          HomeMenuProduct.hide();
          //
          HomeMenuBloc bloc = context.read<HomeMenuBloc>();
          // 搜索
          showDialog(
            context: context,
            builder: (dialogContext) {
              return BlocProvider<HomeMenuBloc>.value(
                value: bloc,
                child: BlocBuilder<HomeMenuBloc, HomeMenuModel>(
                  builder: (blocContext, state) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(44, 167, 176, 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(35, 34, 35, 34),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                      child: Text(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_search_button,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                      ),
                                    ),
                                    Material(
                                      child: MenuDropdownWidget(
                                        inputBackgroundColor:
                                            Color.fromRGBO(255, 255, 255, 1),
                                        inputWidth:
                                            MediaQuery.of(context).size.width -
                                                35 -
                                                35,
                                        inputPrefixIcon: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 0, 0, 0),
                                          child: Image.asset(
                                            WMSICons.HOME_HEAD_SEARCH,
                                            width: 24,
                                            height: 24,
                                            fit: BoxFit.contain,
                                            repeat: ImageRepeat.noRepeat,
                                          ),
                                        ),
                                        inputHintText:
                                            WMSLocalizations.i18n(context)!
                                                .home_head_search_hint_text,
                                        selectedCallBack: () {
                                          // 关闭弹窗
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 20,
                                top: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    // 关闭弹窗
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
        child: Container(
          width: 56,
          height: 56,
          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  WMSICons.HOME_BOTTOM_SEARCH,
                  width: 30,
                  height: 30,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
              Center(
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .shipment_confirmation_export_query,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // 作成列表
    return creationList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 72,
          padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(218, 218, 218, 0.2),
                blurRadius: 10,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 1),
                blurRadius: 1,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 1),
                blurRadius: 1,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Color.fromRGBO(255, 255, 255, 1),
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _initBottomList(state.menuList),
          ),
        );
      },
    );
  }
}
