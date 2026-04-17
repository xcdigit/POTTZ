import 'package:barcode_widget/barcode_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/**
 * Barcode工具类
 * 作者：赵士淞
 * 时间：2023-12-13
 */
class BarcodeUtils {
  // 创建PDF Barcode
  static pw.BarcodeWidget createPdfBarcode(String data,
      {double? width, double? height, bool? isQR}) {
    // 码颜色
    PdfColor codeColor = PdfColor.fromHex('#000000');
    // 外边距
    pw.EdgeInsets margin = const pw.EdgeInsets.all(0);
    // 内边距
    pw.EdgeInsets padding = const pw.EdgeInsets.all(3);
    // 宽度
    double? codeWidth = width == null ? 160 : width;
    // 高度
    double? codeHeight = height == null ? 40 : height;
    // 显示文本
    bool drawText = false;
    // 是否二维码
    bool qrCode = isQR == null || isQR == false ? false : true;

    return pw.BarcodeWidget(
      data: data,
      barcode: qrCode ? Barcode.qrCode() : Barcode.code128(),
      color: codeColor,
      backgroundColor: PdfColor.fromHex('#FFFFFF'),
      margin: margin,
      padding: padding,
      width: codeWidth,
      height: codeHeight,
      drawText: drawText,
    );
  }
}
