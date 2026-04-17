import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

/**
 * 内容：生成条形码共通
 * 作者：赵士淞
 * 时间：2023/11/13
 */
// ignore: must_be_immutable
class WMSBarcodeWidget extends StatefulWidget {
  // 数据
  String data;
  // 码标记（true：条码；false：二维码）
  bool codeFlag;
  // 码颜色
  Color codeColor;
  // 外边距
  EdgeInsets? margin;
  // 内边距
  EdgeInsets? padding;
  // 宽度
  double? width;
  // 高度
  double? height;
  // 显示文本
  bool drawText;
  // 文本颜色
  Color? textColor;
  // 文本大小
  double? fontSize;
  // 文本粗细
  FontWeight? fontWeight;
  // 文本间距
  double? letterSpacing;
  // 文本边距
  double textPadding;

  WMSBarcodeWidget({
    super.key,
    required this.data,
    this.codeFlag = true,
    this.codeColor = Colors.black,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.width = 200,
    this.height = 100,
    this.drawText = true,
    this.textColor = Colors.black,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.letterSpacing = 0,
    this.textPadding = 5,
  });

  @override
  State<WMSBarcodeWidget> createState() => _WMSQrCodeWidgetState();
}

class _WMSQrCodeWidgetState extends State<WMSBarcodeWidget> {
  @override
  Widget build(BuildContext context) {
    return BarcodeWidget(
      data: widget.data,
      barcode: widget.codeFlag
          ? Barcode.code128()
          : Barcode.qrCode(
              errorCorrectLevel: BarcodeQRCorrectionLevel.high,
            ),
      color: widget.codeColor,
      margin: widget.margin,
      padding: widget.padding,
      width: widget.width,
      height: widget.height,
      drawText: widget.drawText,
      style: TextStyle(
        color: widget.textColor,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        letterSpacing: widget.letterSpacing,
      ),
      textPadding: widget.textPadding,
    );
  }
}
