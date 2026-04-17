import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wms/page/home/bloc/home_menu_bloc.dart';
import 'package:wms/page/home/bloc/home_menu_model.dart';

import 'home_menu_item.dart';

/**
 * 内容：下拉共通
 * 作者：赵士淞
 * 时间：2023/08/23
 */
class MenuDropdownWidget extends StatefulWidget {
  // 输入框-初始值
  final String? inputInitialValue;
  // 输入框-宽度
  final double? inputWidth;
  // 输入框-高度
  final double? inputHeight;
  // 输入框-圆角
  final double? inputRadius;
  // 输入框-背景颜色
  final Color? inputBackgroundColor;
  // 输入框-边框颜色
  final Color? inputBorderColor;
  // 输入框-前缀图标
  final Widget? inputPrefixIcon;
  // 输入框-提示文本
  final String? inputHintText;
  // 输入框-后缀图标
  final Widget? inputSuffixIcon;
  // 输入框-字体大小
  final double? inputFontSize;
  // 输入框-字体粗细
  final FontWeight? inputFontWeight;
  // 下拉框-圆角
  final double? dropdownRadius;
  // 下拉框-整体高度
  final double? dropdownWholeHeight;
  // 下拉框-高度
  final double? dropdownHeight;
  // 下拉框-大字体大小
  final double? dropdownBigFontSize;
  // 下拉框-大字体粗细
  final FontWeight? dropdownBigFontWeight;
  // 下拉框-小字体大小
  final double? dropdownSmallFontSize;
  // 下拉框-小字体粗细
  final FontWeight? dropdownSmallFontWeight;
  // 选中回调函数
  final selectedCallBack;

  MenuDropdownWidget({
    super.key,
    this.inputInitialValue,
    this.inputWidth = 200,
    this.inputHeight = 46,
    this.inputRadius = 10,
    this.inputBackgroundColor,
    this.inputBorderColor,
    this.inputPrefixIcon,
    this.inputHintText = '',
    this.inputSuffixIcon,
    this.inputFontSize = 12,
    this.inputFontWeight = FontWeight.w400,
    this.dropdownRadius = 10,
    this.dropdownWholeHeight = 300,
    this.dropdownHeight = 48,
    this.dropdownBigFontSize = 12,
    this.dropdownBigFontWeight = FontWeight.w400,
    this.dropdownSmallFontSize = 10,
    this.dropdownSmallFontWeight = FontWeight.w400,
    this.selectedCallBack,
  });

  @override
  State<MenuDropdownWidget> createState() =>
      MenuDropdownWidgetState(this.inputInitialValue);
}

class MenuDropdownWidgetState extends State<MenuDropdownWidget> {
  // 文本编辑控制器
  final TextEditingController typeAheadController;

  MenuDropdownWidgetState(String? initialValue)
      : this.typeAheadController = TextEditingController(text: initialValue);

  // 菜单搜索限制
  List<MenuItem> _menuSearchRestrict(List<MenuItem> menuList, pattern) {
    // 限制列表
    List<MenuItem> restrictList = [];
    // 循环数据列表
    for (int i = 0; i < menuList.length; i++) {
      // 菜单
      MenuItem menuItem = menuList[i];
      // 判断菜单是否是60系
      if (menuItem.visiable == true) {
        // 菜单标题
        String menuTitle =
            context.read<HomeMenuBloc>().menuTitle(menuItem.index);
        // 判断页面是否为空 && 数据是否包含搜索内容
        if (menuItem.route != null && menuTitle.indexOf(pattern) != -1) {
          // 菜单属性赋值
          menuItem.title = menuTitle;
          // 判断菜单父级
          if (menuItem.parent != null) {
            // 父级菜单
            MenuItem? parentMenuItem = menuItem.parent;
            // 父级菜单标题
            String parentMenuTitle =
                context.read<HomeMenuBloc>().menuTitle(parentMenuItem!.index);
            // 父级菜单属性赋值
            menuItem.parent?.title = parentMenuTitle;
          }
          // 限制列表
          restrictList.add(menuItem);
        }
        // 判断数据是否包含子级
        if (menuItem.children != null) {
          // 菜单搜索限制（递归）
          restrictList.addAll(_menuSearchRestrict(menuItem.children!, pattern));
        }
      }
    }
    return restrictList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(builder: (context, state) {
      return Container(
        width: widget.inputWidth,
        height: widget.inputHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.inputBorderColor != null
                ? widget.inputBorderColor!
                : Colors.transparent,
          ),
          color: widget.inputBackgroundColor != null
              ? widget.inputBackgroundColor!
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.inputRadius!),
        ),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: typeAheadController,
            decoration: InputDecoration(
              prefixIcon: widget.inputPrefixIcon != null
                  ? widget.inputPrefixIcon
                  : Container(
                      width: 16,
                      height: 24,
                    ),
              prefixIconConstraints: BoxConstraints(),
              hintText: widget.inputHintText,
              suffixIcon: widget.inputSuffixIcon != null
                  ? widget.inputSuffixIcon
                  : Container(
                      width: 16,
                      height: 24,
                    ),
              suffixIconConstraints: BoxConstraints(),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: widget.inputFontSize,
              fontWeight: widget.inputFontWeight,
            ),
          ),
          suggestionsCallback: (pattern) {
            // 限制列表
            return _menuSearchRestrict(state.menuList, pattern);
          },
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(widget.dropdownRadius!),
            constraints: BoxConstraints(
              maxHeight: widget.dropdownWholeHeight!,
            ),
          ),
          itemBuilder: (context, menuItem) {
            // 单项组件列表
            _itemWidgetList() {
              // 组件列表
              List<Widget> widgetList = [];
              // 大标题
              widgetList.add(
                Text(
                  menuItem.title.toString(),
                  style: TextStyle(
                    fontSize: widget.dropdownBigFontSize,
                    fontWeight: widget.dropdownBigFontWeight,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              );
              // 小标题
              if (menuItem.parent != null) {
                // 组件列表添加
                widgetList.add(
                  Text(
                    menuItem.parent!.title.toString(),
                    style: TextStyle(
                      fontSize: widget.dropdownSmallFontSize,
                      fontWeight: widget.dropdownSmallFontWeight,
                      color: Color.fromRGBO(156, 156, 156, 1),
                    ),
                  ),
                );
              }
              return widgetList;
            }

            return Container(
              height: widget.dropdownHeight,
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(196, 196, 196, 1),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _itemWidgetList(),
                ),
              ),
            );
          },
          onSuggestionSelected: (menuItem) {
            context
                .read<HomeMenuBloc>()
                .add(ChangeMenuEvent(menuItem, context));
            // 文本编辑控制器
            typeAheadController.text = menuItem.title.toString();
            // 选中回调函数
            widget.selectedCallBack();
          },
        ),
      );
    });
  }
}
