import 'package:flutter/material.dart';

/**
 * 内容：首页菜单商品输入框
 * 作者：赵士淞
 * 时间：2024/11/19
 */
// ignore: must_be_immutable
class WMSInputboxConciseWidget extends StatefulWidget {
  // 高度
  double? height;
  // 背景颜色
  Color? backgroundColor;
  // 边框颜色
  Color? borderColor;
  // 边框圆角
  BorderRadius? borderRadius;
  // 字体大小
  double? fontSize;
  // 字体粗细
  FontWeight? fontWeight;
  // 字体颜色
  Color? fontColor;
  // 字体行高
  double? fontHeight;
  // 文本
  String? text;
  // 提示字体大小
  double? hintFontSize;
  // 提示字体粗细
  FontWeight? hintFontWeight;
  // 提示字体颜色
  Color? hintFontColor;
  // 提示字体行高
  double? hintFontHeight;
  // 提示文本
  String? hintText;
  // 输入框回调函数
  final inputBoxCallBack;

  WMSInputboxConciseWidget({
    super.key,
    this.height = 48,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontColor,
    this.fontHeight = 1.5,
    this.text = '',
    this.hintFontSize = 14,
    this.hintFontWeight = FontWeight.w400,
    this.hintFontColor,
    this.hintFontHeight = 1.5,
    this.hintText = '',
    this.inputBoxCallBack,
  });

  @override
  State<WMSInputboxConciseWidget> createState() =>
      _WMSInputboxConciseWidgetState();
}

class _WMSInputboxConciseWidgetState extends State<WMSInputboxConciseWidget> {
  // 输入框操作实例
  TextEditingController _controller = TextEditingController();
  // 输入框焦点控制
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 输入框焦点控制
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.inputBoxCallBack != null) {
        // 输入框回调函数
        widget.inputBoxCallBack(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 判断文本
    if (_controller.text == '' && widget.text != '') {
      if (widget.inputBoxCallBack != null) {
        // 输入框回调函数
        widget.inputBoxCallBack(_controller.text);
      }
    }

    return Container(
      height: widget.height,
      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
      decoration: BoxDecoration(
        color: widget.backgroundColor != null
            ? widget.backgroundColor
            : Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: widget.borderColor != null
              ? widget.borderColor!
              : Color.fromRGBO(224, 224, 224, 1),
        ),
        borderRadius: widget.borderRadius != null
            ? widget.borderRadius
            : BorderRadius.circular(4),
      ),
      child: TextField(
        controller: _controller,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.fontColor != null
              ? widget.fontColor
              : Color.fromRGBO(6, 14, 15, 1),
          height: widget.fontHeight,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: widget.hintFontSize,
            fontWeight: widget.hintFontWeight,
            color: widget.hintFontColor != null
                ? widget.hintFontColor
                : Color.fromRGBO(146, 146, 146, 1),
            height: widget.hintFontHeight,
          ),
          hintText: widget.hintText,
        ),
        focusNode: _focusNode,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 输入框焦点控制
    _focusNode.dispose();
  }
}
