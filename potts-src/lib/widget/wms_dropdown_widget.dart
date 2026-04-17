import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../common/localization/default_localizations.dart';

/**
 * 内容：下拉共通
 * 作者：赵士淞
 * 时间：2023/08/23
 */
// ignore: must_be_immutable
class WMSDropdownWidget extends StatefulWidget {
  // 菜单搜索
  bool? menuSearch;
  // 保存输入
  bool? saveInput;
  // 数据列表1
  List? dataList1;
  // 数据列表2
  List? dataList2;
  // 输入框-初始值
  String? inputInitialValue;
  // 输入框-宽度
  double? inputWidth;
  // 输入框-高度
  double? inputHeight;
  // 输入框-圆角
  double? inputRadius;
  // 输入框-背景颜色
  Color? inputBackgroundColor;
  // 输入框-边框颜色
  Color? inputBorderColor;
  // 输入框-前缀图标
  Widget? inputPrefixIcon;
  // 输入框-提示文本
  String? inputHintText;
  // 输入框-提示字体大小
  double? inputHintFontSize;
  // 输入框-提示字体粗细
  FontWeight? inputHintFontWeight;
  // 输入框-提示字体颜色
  Color? inputHintFontColor;
  // 输入框-提示字体行高
  double? inputHintFontHeight;
  // 输入框-后缀图标
  Widget? inputSuffixIcon;
  // 输入框-字体大小
  double? inputFontSize;
  // 输入框-字体粗细
  FontWeight? inputFontWeight;
  // 输入框-字体颜色
  Color? inputFontColor;
  // 输入框-字体行高
  double? inputFontHeight;
  // 下拉框-圆角
  double? dropdownRadius;
  // 下拉框-整体高度
  double? dropdownWholeHeight;
  // 下拉框-高度
  double? dropdownHeight;
  // 下拉框-主键
  String? dropdownKey;
  // 下拉框-标题
  String dropdownTitle;
  // 下拉框-大字体大小
  double? dropdownBigFontSize;
  // 下拉框-大字体粗细
  FontWeight? dropdownBigFontWeight;
  // 下拉框-小字体大小
  double? dropdownSmallFontSize;
  // 下拉框-小字体粗细
  FontWeight? dropdownSmallFontWeight;
  // 选中回调函数
  final selectedCallBack;

  WMSDropdownWidget({
    super.key,
    this.menuSearch = false,
    this.saveInput = false,
    this.dataList1,
    this.dataList2,
    this.inputInitialValue = '',
    this.inputWidth,
    this.inputHeight = 48,
    this.inputRadius = 10,
    this.inputBackgroundColor,
    this.inputBorderColor,
    this.inputPrefixIcon,
    this.inputHintText = '',
    this.inputHintFontSize = 14,
    this.inputHintFontWeight = FontWeight.w400,
    this.inputHintFontColor,
    this.inputHintFontHeight = 1.5,
    this.inputSuffixIcon,
    this.inputFontSize = 14,
    this.inputFontWeight = FontWeight.w400,
    this.inputFontColor,
    this.inputFontHeight = 1.5,
    this.dropdownRadius = 10,
    this.dropdownWholeHeight = 300,
    this.dropdownHeight = 48,
    this.dropdownKey = 'id',
    required this.dropdownTitle,
    this.dropdownBigFontSize = 12,
    this.dropdownBigFontWeight = FontWeight.w400,
    this.dropdownSmallFontSize = 10,
    this.dropdownSmallFontWeight = FontWeight.w400,
    this.selectedCallBack,
  });

  @override
  State<WMSDropdownWidget> createState() => WMSDropdownWidgetState();
}

class WMSDropdownWidgetState extends State<WMSDropdownWidget> {
  // 临时文本
  String tempValue = '';

  // 文本编辑控制器
  final TextEditingController typeAheadController = TextEditingController();
  // 文本焦点控制器
  final FocusNode typeAheadFocusNode = FocusNode();

  // 限制列表
  List restrictList = [];

  // 搜索限制
  _searchRestrict(dataList, parentTitle, pattern) {
    // 判断数据列表
    if (dataList != null) {
      // 循环数据列表
      for (int i = 0; i < dataList.length; i++) {
        // 判断数据是否包含搜索内容
        if (dataList[i][widget.dropdownTitle].toString().indexOf(pattern) !=
            -1) {
          // 判断父标题是否为空
          if (parentTitle != '') {
            // 限制列表新增
            restrictList.add({
              'index': dataList[i][widget.dropdownKey],
              'title': dataList[i][widget.dropdownTitle],
              'subtitle': parentTitle,
            });
          } else {
            // 限制列表新增
            restrictList.add({
              'index': dataList[i][widget.dropdownKey],
              'title': dataList[i][widget.dropdownTitle],
            });
          }
        }
        // 判断数据是否包含子级
        if (dataList[i]['children'] != null) {
          // 搜索限制（递归）
          _searchRestrict(dataList[i]['children'],
              dataList[i][widget.dropdownTitle], pattern);
        }
      }
    }
  }

  // 菜单搜索限制
  _menuSearchRestrict(dataList, parentTitle, pattern) {
    // 判断数据列表
    if (dataList != null) {
      // 循环数据列表
      for (int i = 0; i < dataList.length; i++) {
        // 判断菜单是否是60系
        if (dataList[i]['index'] < 6000 || dataList[i]['index'] >= 7000) {
          // 判断页面是否为空
          if (dataList[i]['page'] != null) {
            // 判断数据是否包含搜索内容
            if (dataList[i][widget.dropdownTitle].indexOf(pattern) != -1) {
              // 判断父标题是否为空
              if (parentTitle != "") {
                // 限制列表新增
                restrictList.add({
                  'index': dataList[i][widget.dropdownKey],
                  'title': dataList[i][widget.dropdownTitle],
                  'subtitle': parentTitle,
                  'page': dataList[i]['page'],
                });
              } else {
                // 限制列表新增
                restrictList.add({
                  'index': dataList[i][widget.dropdownKey],
                  'title': dataList[i][widget.dropdownTitle],
                  'page': dataList[i]['page'],
                });
              }
            }
          }
          // 判断数据是否包含子级
          if (dataList[i]['children'] != null) {
            // 菜单搜索限制（递归）
            _menuSearchRestrict(dataList[i]['children'],
                dataList[i][widget.dropdownTitle], pattern);
          }
        }
      }
    }
  }

  // 搜索选择
  _searchSelected(dataList, suggestion) {
    // 判断数据列表
    if (dataList != null) {
      // 循环数据列表
      for (int i = 0; i < dataList.length; i++) {
        // 判断主键值是否一致
        if (dataList[i][widget.dropdownKey] == suggestion['index']) {
          // 选中回调函数
          widget.selectedCallBack(dataList[i]);
        }
        // 判断数据是否包含子级
        if (dataList[i]['children'] != null) {
          // 搜索选择（递归）
          _searchSelected(dataList[i]['children'], suggestion);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 判断文本编辑控制器
    if (widget.inputInitialValue != null &&
        widget.inputInitialValue != 'null') {
      // 临时文本
      tempValue = widget.inputInitialValue!;
      // 文本编辑控制器
      typeAheadController.text = widget.inputInitialValue!;
    }

    return Container(
      width: widget.inputWidth,
      height: widget.inputHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.inputBorderColor != null
              ? widget.inputBorderColor!
              : Color.fromRGBO(224, 224, 224, 1),
        ),
        color: widget.inputBackgroundColor != null
            ? widget.inputBackgroundColor!
            : Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(widget.inputRadius!),
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: typeAheadController,
          focusNode: typeAheadFocusNode,
          style: TextStyle(
            fontSize: widget.inputFontSize,
            fontWeight: widget.inputFontWeight,
            color: widget.inputFontColor != null
                ? widget.inputFontColor
                : Color.fromRGBO(6, 14, 15, 1),
            height: widget.inputFontHeight,
          ),
          decoration: InputDecoration(
            prefixIcon: widget.inputPrefixIcon != null
                ? widget.inputPrefixIcon
                : Container(
                    width: 16,
                    height: 24,
                  ),
            prefixIconConstraints: BoxConstraints(),
            hintText: widget.inputHintText,
            hintStyle: TextStyle(
              fontSize: widget.inputHintFontSize,
              fontWeight: widget.inputHintFontWeight,
              color: widget.inputHintFontColor != null
                  ? widget.inputHintFontColor
                  : Color.fromRGBO(146, 146, 146, 1),
              height: widget.inputHintFontHeight,
            ),
            suffixIcon: widget.inputSuffixIcon != null
                ? widget.inputSuffixIcon
                : Container(
                    width: 16,
                    height: 24,
                  ),
            suffixIconConstraints: BoxConstraints(),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // 临时文本
            tempValue = value;
            // 判断数值
            if (value == '') {
              // 文本编辑控制器
              typeAheadController.text = value;
              // 选中回调函数
              widget.selectedCallBack(value);
            }
          },
          onTapOutside: (event) {
            // 判断焦点状态
            if (typeAheadFocusNode.hasFocus) {
              // 文本焦点控制器
              typeAheadFocusNode.unfocus();
              // 判断保存输入
              if (widget.saveInput == true) {
                // 文本编辑控制器
                typeAheadController.text = tempValue;
                // 选中回调函数
                widget.selectedCallBack(tempValue);
              }
            }
          },
          onSubmitted: (value) {
            // 判断焦点状态
            if (typeAheadFocusNode.hasFocus) {
              // 文本焦点控制器
              typeAheadFocusNode.unfocus();
              // 判断保存输入
              if (widget.saveInput == true) {
                // 文本编辑控制器
                typeAheadController.text = tempValue;
                // 选中回调函数
                widget.selectedCallBack(tempValue);
              }
            }
          },
        ),
        suggestionsCallback: (pattern) {
          // 限制列表
          restrictList = [];
          // 判断菜单搜索
          if (widget.menuSearch!) {
            // 菜单搜索限制
            _menuSearchRestrict(widget.dataList1, '', pattern);
            // 菜单搜索限制
            _menuSearchRestrict(widget.dataList2, '', pattern);
          } else {
            // 搜索限制
            _searchRestrict(widget.dataList1, '', pattern);
            // 搜索限制
            _searchRestrict(widget.dataList2, '', pattern);
          }
          // 限制列表
          return restrictList;
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(widget.dropdownRadius!),
          constraints: BoxConstraints(
            maxHeight: widget.dropdownWholeHeight!,
          ),
        ),
        itemBuilder: (context, itemData) {
          // 单项组件列表
          _itemWidgetList() {
            // 组件列表
            List<Widget> widgetList = [];
            // 判断单项是否存在大标题
            if (itemData['title'] != null) {
              // 组件列表添加
              widgetList.add(
                Text(
                  itemData['title'].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: widget.dropdownBigFontSize,
                    fontWeight: widget.dropdownBigFontWeight,
                    color: Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              );
            }
            // 判断单项是否存在小标题
            if (itemData['subtitle'] != null) {
              // 组件列表添加
              widgetList.add(
                Text(
                  itemData['subtitle'],
                  overflow: TextOverflow.ellipsis,
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
        onSuggestionSelected: (suggestion) {
          // 搜索选择
          _searchSelected(widget.dataList1, suggestion);
          // 搜索选择
          _searchSelected(widget.dataList2, suggestion);
          // 文本编辑控制器
          typeAheadController.text = suggestion['title'].toString();
        },
        noItemsFoundBuilder: (context) {
          return Container(
            height: widget.dropdownHeight,
            padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  WMSLocalizations.i18n(context)!.no_items_found,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
