import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/localization/default_localizations.dart';

import '../../../../common/config/config.dart';

/**
* 内容：ロールマスタ管理 -头部
 * 作者：cuihr
 * 时间：2023/09/05
 */
// ignore: must_be_immutable
class RoleMasterTitle extends StatefulWidget {
  // 标记
  String flag;

  RoleMasterTitle({super.key, this.flag = ''});

  @override
  State<RoleMasterTitle> createState() => _RoleMasterTitleState();
}

class _RoleMasterTitleState extends State<RoleMasterTitle> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = buttonItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 返回上一页
                GoRouter.of(context).pop();
              }
            },
            child: Container(
              height: 34,
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              decoration: BoxDecoration(
                color: _currentHoverIndex == buttonItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, .6)
                    : Colors.white,
                border: Border.all(
                  color: _currentHoverIndex == buttonItemList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, .6)
                      : Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                buttonItemList[i]['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _currentHoverIndex == buttonItemList[i]['index']
                      ? Colors.white
                      : Color.fromRGBO(44, 167, 176, 1),
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 右侧按钮单个列表
    List _buttonRightItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.menu_content_3_11_11,
      },
    ];

    return Container(
      //ロールマスタ管理 -标题
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            child: Text(
              WMSLocalizations.i18n(context)!.menu_content_8_22,
              style: TextStyle(
                height: 1.0,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
          ),
          Visibility(
            visible: widget.flag == 'change',
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
              child: Row(
                children: _initButtonRightList(_buttonRightItemList),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
