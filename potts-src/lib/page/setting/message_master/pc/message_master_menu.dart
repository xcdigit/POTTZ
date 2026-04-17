import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';

/**
 * 内容：消息管理-菜单
 * 作者：赵士淞
 * 时间：2024/07/11
 */
class MessageMasterMenu extends StatefulWidget {
  const MessageMasterMenu({super.key});

  @override
  State<MessageMasterMenu> createState() => _MessageMasterMenuState();
}

class _MessageMasterMenuState extends State<MessageMasterMenu> {
  // 初始化菜单列表
  List<Widget> _initMenuList(List menuItemList) {
    // 菜单列表
    List<Widget> menuList = [];

    // 标题
    menuList.add(
      Container(
        padding: EdgeInsets.fromLTRB(0, 61, 0, 60),
        child: Text(
          WMSLocalizations.i18n(context)!.message_master_title,
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
            context.read<MessageMasterBloc>().add(
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
              color: context.read<MessageMasterBloc>().state.currentMenuIndex ==
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
                              .read<MessageMasterBloc>()
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
    return BlocBuilder<MessageMasterBloc, MessageMasterModel>(
      builder: (context, state) {
        // 菜单单个列表
        List _menuItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.message_master_menu_1,
          },
          {
            'index': Config.NUMBER_ONE,
            'title': WMSLocalizations.i18n(context)!.message_master_menu_2,
          },
          {
            'index': Config.NUMBER_TWO,
            'title': WMSLocalizations.i18n(context)!.message_master_menu_3,
          },
        ];

        return ListView(
          scrollDirection: Axis.vertical,
          children: _initMenuList(_menuItemList),
        );
      },
    );
  }
}
