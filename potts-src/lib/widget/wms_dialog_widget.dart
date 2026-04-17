// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

/**
 * 内容：弹框共通
 * 作者：luxy
 * 时间：2023/08/15
 */
class WMSDiaLogWidget extends StatefulWidget {
  //标题文本
  String? titleText;
  //标题背景色
  Color titleBackgroundColor;
  //内容文本
  String? contentText;
  //左边按钮文本
  String? buttonLeftText;
  //左边按钮是否显示
  bool buttonLeftFlag;
  //左边按钮背景色
  Color buttonLeftBackgroundColor;
  //左边按钮文本颜色
  Color buttonLeftTextColor;
  //右边按钮是否显示
  bool buttonRightFlag;
  //右边按钮文本
  String? buttonRightText;
  //右边按钮背景色
  Color? buttonRightBackgroundColor;
  //右边按钮文本颜色
  Color buttonRightTextColor;
  //左边按钮方法
  Function()? onPressedLeft;
  //右边按钮方法
  Function()? onPressedRight;

  WMSDiaLogWidget({
    Key? super.key,
    required this.titleText,
    this.titleBackgroundColor = const Color.fromRGBO(44, 167, 176, 1),
    required this.contentText,
    this.buttonLeftText,
    this.buttonRightText,
    this.buttonLeftFlag = true,
    this.buttonRightFlag = true,
    this.buttonLeftBackgroundColor = Colors.white,
    this.buttonRightBackgroundColor = const Color.fromRGBO(44, 167, 176, 1),
    this.buttonLeftTextColor = Colors.black,
    this.buttonRightTextColor = Colors.white,
    this.onPressedLeft,
    this.onPressedRight,
  });

  @override
  State<WMSDiaLogWidget> createState() => _WMSDiaLogWidgetState();
}

class _WMSDiaLogWidgetState extends State<WMSDiaLogWidget> {
  //控制按钮背景色和字体颜色
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //圆角设置
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //标题
      title: PhysicalModel(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.titleBackgroundColor,
          ),
          margin: EdgeInsets.only(
              left: 0,
              top: 0,
              right: 0,
              bottom: 8), // margin 的四边如果设置了大于0的值，会影响圆角的显示
          child: Text(
            widget.titleText.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.all(0.0),
      contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      //内容
      content: Container(
        width: 365,
        height: 120,
        alignment: Alignment.center,
        child: Text(
          widget.contentText.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(6, 14, 15, 1),
          ),
        ),
      ),
      buttonPadding: widget.buttonRightFlag
          ? EdgeInsets.all(16)
          : EdgeInsets.fromLTRB(16, 16, 0, 16),
      actions: <Widget>[
        //左边按钮 默认显示
        Visibility(
          visible: widget.buttonLeftFlag,
          child: Container(
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: flag
                    ? widget.buttonLeftBackgroundColor
                    : widget.buttonRightBackgroundColor,
              ),
              child: Text(
                widget.buttonLeftText.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: flag
                      ? widget.buttonLeftTextColor
                      : widget.buttonRightTextColor,
                ),
              ),
              onHover: (value) {
                setState(() {
                  flag = !flag;
                });
              },
              onPressed: widget.onPressedLeft,
            ),
          ),
        ),
        //右边按钮 默认显示
        Visibility(
          visible: widget.buttonRightFlag,
          child: Container(
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: flag
                    ? widget.buttonRightBackgroundColor
                    : widget.buttonLeftBackgroundColor,
              ),
              child: Text(
                widget.buttonRightText.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: flag
                      ? widget.buttonRightTextColor
                      : widget.buttonLeftTextColor,
                ),
              ),
              onPressed: widget.onPressedRight,
            ),
          ),
        ),
      ],
    );
  }
}
