import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../common/style/wms_style.dart';
import '../common/utils/forbidden_utils.dart';
import '../redux/wms_state.dart';

/**
 * 内容：输入框共通
 * 作者：赵士淞
 * 时间：2023/08/25
 */
// ignore: must_be_immutable
class WMSInputboxWidget extends StatefulWidget {
  // 高度
  double? height;
  // 背景颜色
  Color? backgroundColor;
  // 边框颜色
  Color? borderColor;
  // 边框圆角
  BorderRadius? borderRadius;
  // 最大行数
  int? maxLines;
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
  // 前缀图标
  Widget? prefixIcon;
  // 后缀图标
  Widget? suffixIcon;
  // 只读
  bool? readOnly;
  // 模糊文本
  bool? obscureText;
  // 数字IME
  bool? numberIME;
  // 输入框回调函数
  final inputBoxCallBack;

  WMSInputboxWidget({
    super.key,
    this.height = 48,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.maxLines = 1,
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
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.numberIME = false,
    this.inputBoxCallBack,
  });

  @override
  State<WMSInputboxWidget> createState() => _WMSInputboxWidgetState();
}

class _WMSInputboxWidgetState extends State<WMSInputboxWidget> {
  // 输入框操作实例
  TextEditingController _controller = TextEditingController();
  // 输入框焦点控制
  FocusNode _focusNode = FocusNode();
  // 控制密码图标切换
  bool _eyeHidden = true;
  // 模糊文本内容
  String _obscureTextContent = '';
  // 模糊文本标记
  bool _obscureTextFlag = true;

  // 初次加载
  bool _firstLoading = true;
  // 内部初次加载
  bool _InfirstLoading = true;
  // 当前其他容器操作菜单子级
  bool _currentOtherWidgetOperateMenuChild = false;

  //输入前的值
  String previousValue = '';

  @override
  void initState() {
    super.initState();
    // 输入框焦点控制
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.inputBoxCallBack != null) {
        // 检查文本
        _controller.text = ForbiddenUtils.checkText(_controller.text);
        previousValue = _controller.text;
        // 输入框回调函数
        widget.inputBoxCallBack(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 判断初次加载
    if (_firstLoading) {
      // 初次加载
      _firstLoading = false;
      // 当前其他容器操作菜单子级
      _currentOtherWidgetOperateMenuChild =
          StoreProvider.of<WMSState>(context).state.otherWidgetOperateMenuChild;
      // 判断文本
      if (widget.text != null && widget.text != 'null') {
        // 输入框操作实例
        _controller.text = widget.text!;
        previousValue = _controller.text;
      }
    } else {
      // 判断其他容器操作菜单子级与当前其他容器操作菜单子级是否一致
      if (StoreProvider.of<WMSState>(context)
              .state
              .otherWidgetOperateMenuChild !=
          _currentOtherWidgetOperateMenuChild) {
        // 当前其他容器操作菜单子级
        _currentOtherWidgetOperateMenuChild =
            StoreProvider.of<WMSState>(context)
                .state
                .otherWidgetOperateMenuChild;
        // 关闭输入框
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        if (kIsWeb) {
          // 判断文本
          if (widget.obscureText == true && _obscureTextFlag != _eyeHidden) {
            // 模糊文本标记
            _obscureTextFlag = _eyeHidden;
            // 输入框操作实例
            _controller.text = _obscureTextContent;
            previousValue = _controller.text;
          } else if (widget.text != null && widget.text != 'null') {
            // 输入框操作实例
            _controller.text = widget.text!;
            previousValue = _controller.text;
          }
        } else {
          if (_InfirstLoading ||
              ((_controller.text == "" || _controller.text == '0') &&
                  _controller.text != widget.text) ||
              ((widget.text == '' || widget.text == '0') &&
                  _controller.text == previousValue)) {
            _InfirstLoading = false;

            if (widget.text != null && widget.text != 'null') {
              // 输入框操作实例
              _controller.text = widget.text!;
              previousValue = _controller.text;
            }
          }
        }
      }
    }

    return Container(
      height: widget.height,
      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
      decoration: BoxDecoration(
        color: widget.readOnly!
            ? Color.fromRGBO(240, 240, 240, 1)
            : widget.backgroundColor != null
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
        keyboardType: widget.numberIME == true
            ? TextInputType.phone
            : TextInputType.multiline,
        controller: _controller,
        maxLines: widget.maxLines,
        readOnly: widget.readOnly!,
        obscureText:
            widget.obscureText == true ? _eyeHidden : widget.obscureText!,
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
          prefixIcon: widget.prefixIcon != null ? widget.prefixIcon : null,
          prefixIconConstraints: BoxConstraints(),
          suffixIcon: widget.obscureText == true
              ? IconButton(
                  onPressed: () {
                    // 赋值
                    setState(() {
                      // 模糊文本内容
                      _obscureTextContent = _controller.text;
                      // 控制密码图标切换
                      _eyeHidden = !_eyeHidden;
                    });
                  },
                  icon: new Image(
                    image: new AssetImage(
                      _eyeHidden
                          ? WMSICons.DEFAULT_EYE_CLOSE_ICON
                          : WMSICons.DEFAULT_EYE_OPEN_ICON,
                    ),
                    width: 24.0,
                    height: 24.0,
                  ),
                )
              : widget.suffixIcon != null
                  ? widget.suffixIcon
                  : null,
          suffixIconConstraints: BoxConstraints(),
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
