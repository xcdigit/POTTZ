import 'package:flutter/material.dart';

/**
 * 内容：工具提示共通
 * 作者：赵士淞
 * 时间：2025/01/15
 */
class WMSTooltipWidget extends StatefulWidget {
  // 提示文言
  final String message;
  // 子级（目前只有Text）
  final Text child;

  const WMSTooltipWidget({
    super.key,
    required this.message,
    required this.child,
  });

  @override
  State<WMSTooltipWidget> createState() => _WMSTooltipWidgetState();
}

class _WMSTooltipWidgetState extends State<WMSTooltipWidget> {
  // 是否提示
  late bool _isOverflowing;

  // 文本计算
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  @override
  void initState() {
    super.initState();
    // 是否提示：初始化为不提示
    _isOverflowing = false;
  }

  @override
  Widget build(BuildContext context) {
    // 文本计算：将子级文本和子级字号作为参数计算长度
    textPainter.text = TextSpan(
      text: widget.child.data,
      style: TextStyle(
        fontSize: widget.child.style!.fontSize,
      ),
    );
    textPainter.layout();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 判断子级是否设置最大行数
        if (widget.child.maxLines != null) {
          // 是否提示：文本计算结果是否大于外层盒子宽度
          _isOverflowing = textPainter.width > constraints.maxWidth;
        }
        return _isOverflowing
            ? Tooltip(
                message: widget.message,
                child: widget.child,
              )
            : widget.child;
      },
    );
  }
}
