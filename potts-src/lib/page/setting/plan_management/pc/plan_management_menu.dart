import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';

/**
 * 内容：计划管理-菜单
 * 作者：赵士淞
 * 时间：2024/06/27
 */
class PlanManagementMenu extends StatefulWidget {
  const PlanManagementMenu({super.key});

  @override
  State<PlanManagementMenu> createState() => _PlanManagementMenuState();
}

class _PlanManagementMenuState extends State<PlanManagementMenu> {
  // 初始化菜单列表
  List<Widget> _initMenuList(List menuItemList, PlanManagementModel state) {
    // 菜单列表
    List<Widget> menuList = [];

    // 标题
    menuList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 61, 0, 40),
        child: Text(
          WMSLocalizations.i18n(context)!.plan_title_text,
          style: TextStyle(
            color: Color.fromRGBO(44, 167, 176, 1),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    // 循环菜单单个列表
    for (int i = 0; i < menuItemList.length; i++) {
      // 菜单列表
      menuList.add(
        GestureDetector(
          onPanDown: (details) {
            // 设置当前菜单下标事件
            context.read<PlanManagementBloc>().add(
                  SetCurrentMenuIndexEvent(
                    menuItemList[i]['index'],
                  ),
                );
          },
          child: Container(
            height: 44,
            padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            decoration: BoxDecoration(
              color:
                  context.read<PlanManagementBloc>().state.currentMenuIndex ==
                          menuItemList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                menuItemList[i]['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: context
                              .read<PlanManagementBloc>()
                              .state
                              .currentMenuIndex ==
                          menuItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return menuList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanManagementBloc, PlanManagementModel>(
      builder: (context, state) {
        // 菜单单个列表
        List _menuItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.plan_menu_text_1,
          },
          {
            'index': Config.NUMBER_ONE,
            'title': WMSLocalizations.i18n(context)!.plan_menu_text_2,
          },
        ];

        return ListView(
          scrollDirection: Axis.vertical,
          children: _initMenuList(_menuItemList, state),
        );
      },
    );
  }
}
