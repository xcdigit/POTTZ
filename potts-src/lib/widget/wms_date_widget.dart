import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/**
 * 内容：日期共通
 * 作者：赵士淞
 * 时间：2023/08/25
 */
// ignore: must_be_immutable
class WMSDateWidget extends StatefulWidget {
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
  // 格式文本
  String? formatText;
  // 只读
  bool? readOnly;
  // 日期回调函数
  final dateCallBack;

  WMSDateWidget({
    super.key,
    this.height = 48,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontColor,
    this.fontHeight = 2.5,
    this.text = '',
    this.hintFontSize = 14,
    this.hintFontWeight = FontWeight.w400,
    this.hintFontColor,
    this.hintFontHeight = 2.5,
    this.hintText = 'yyyy/mm/dd',
    this.formatText = 'yyyy/MM/dd',
    this.readOnly = false,
    this.dateCallBack,
  });

  @override
  State<WMSDateWidget> createState() => _WMSDateWidgetState();
}

class _WMSDateWidgetState extends State<WMSDateWidget> {
  @override
  Widget build(BuildContext context) {
    // 判断文本
    if (widget.text == null || widget.text == 'null') {
      // 文本
      widget.text = '';
    }

    return GestureDetector(
      onTap: () async {
        // 判断只读
        if (!widget.readOnly!) {
          // 日期选择器
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2999),
          );
          // 判断选中日期是否为空
          if (selectedDate != null) {
            // 格式日期
            String formatDate =
                DateFormat(widget.formatText).format(selectedDate);
            // 状态变更
            setState(() {
              // 文本
              widget.text = formatDate;
            });
            // 日期回调函数
            widget.dateCallBack(formatDate);
          }
        }
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          height: widget.height,
          padding: kIsWeb == true
              ? EdgeInsets.fromLTRB(14, 0, 14, 0)
              : EdgeInsets.fromLTRB(14, 0, 2, 0),
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
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.text != '',
                    child: Text(
                      widget.text!,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: widget.fontWeight,
                        color: widget.fontColor != null
                            ? widget.fontColor
                            : Color.fromRGBO(6, 14, 15, 1),
                        height: widget.fontHeight,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.text == '' && widget.hintText != '',
                    child: Text(
                      widget.hintText!,
                      style: TextStyle(
                        fontSize: widget.hintFontSize,
                        fontWeight: widget.hintFontWeight,
                        color: widget.hintFontColor != null
                            ? widget.hintFontColor
                            : Color.fromRGBO(146, 146, 146, 1),
                        height: widget.hintFontHeight,
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: !widget.readOnly!,
                child: Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // 状态变更
                      setState(() {
                        // 文本
                        widget.text = '';
                      });
                      // 日期回调函数
                      widget.dateCallBack('');
                    },
                    child: Container(
                      width: 30,
                      height: widget.height,
                      child: Icon(
                        Icons.close,
                        color: Color.fromRGBO(146, 146, 146, 1),
                      ),
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
}
