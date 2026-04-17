import 'package:flutter/material.dart';

/// 带图标的输入框
class WMSInputWidget extends StatefulWidget {
  final bool obscureText;

  final bool filled;

  final Color? fillColor;

  final InputBorder? border;

  final Widget? suffixIcon;

  final String? hintText;

  final IconData? iconData;

  final ValueChanged<String>? onChanged;

  final TextStyle? textStyle;

  final TextEditingController? controller;

  final ValueChanged<String>? onSubmitted;

  WMSInputWidget({
    Key? super.key,
    this.hintText,
    this.iconData,
    this.onChanged,
    this.textStyle,
    this.controller,
    this.filled = false,
    this.fillColor,
    this.border,
    this.suffixIcon,
    this.obscureText = false,
    this.onSubmitted,
  });

  @override
  _WMSInputWidgetState createState() => new _WMSInputWidgetState();
}

/// State for [GSYInputWidget] widgets.
class _WMSInputWidgetState extends State<WMSInputWidget> {
  @override
  Widget build(BuildContext context) {
    return new TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        onSubmitted: widget.onSubmitted,
        decoration: new InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 14),
          icon: widget.iconData == null ? null : new Icon(widget.iconData),
          filled: widget.filled,
          fillColor: widget.fillColor,
          border: widget.border,
          suffixIcon: widget.suffixIcon,
        ),
        magnifierConfiguration: TextMagnifierConfiguration(magnifierBuilder: (
          BuildContext context,
          MagnifierController controller,
          ValueNotifier<MagnifierInfo> magnifierInfo,
        ) {
          return null;
        }));
  }
}
