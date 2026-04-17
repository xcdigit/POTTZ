import 'dart:math';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wms/common/utils/barcode_utils.dart';

import '../style/wms_style.dart';

/**
 * 蓝牙打印工具类
 * 作者：muzd
 * 时间：2023-12-07
 */
class PrinterUtils {
  static const double inch = 72.0;
  static const double mm = inch / 25.4;

  // 编码打印
  // data 打印数据：{code 编码；name 名称；}
  static codePrint(Map<String, dynamic> printData) async {
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        // PDF宽度
        final pdfWidth = 55 * mm;
        // PDF高度
        final pdfHeight = 40 * mm;
        // PDF内边距
        final pdfMargin = 2 * mm;
        // 内容宽度
        final contentWidth = pdfWidth - pdfMargin - pdfMargin;
        // 内容宽度
        final contentHeight = pdfHeight - pdfMargin - pdfMargin;

        // 文档
        final doc = pw.Document();
        // 页面样式
        final pageFormat =
            PdfPageFormat(pdfWidth, pdfHeight, marginAll: pdfMargin);
        // TTF
        final ttf = await rootBundle.load('assets/font/stkaiti.ttf');
        // 字体
        final font = pw.Font.ttf(ttf);

        doc.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (pw.Context context) {
              return pw.Container(
                width: contentWidth,
                height: contentHeight,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    // 条形码区域
                    pw.Container(
                      child: pw.Column(
                        children: [
                          // 条形码
                          BarcodeUtils.createPdfBarcode(
                              printData['code'] != null
                                  ? printData['code'].toString()
                                  : '',
                              isQR: true),
                          // 编码
                          pw.Text(
                            printData['code'] != null
                                ? printData['code'].toString()
                                : '',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 内容区域
                    pw.Container(
                      width: contentWidth,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex('#CCCCCC'),
                          width: 1,
                          style: pw.BorderStyle.solid,
                        ),
                      ),
                      child: pw.Text(
                        printData['name'] != null
                            ? printData['name'].toString()
                            : '',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );

        return doc.save();
      },
    );
  }

  // 商品ラベル打印
  // sceneMark 场景标记：1 商品マスタ；2 出庫入力；3 入荷検品；4 返品入力；5 入庫入力
  // data 打印数据：{code 商品编码；name 商品名；number 商品数量；type 商品荷姿；no 指示编码；details_no 指示明细编码；company_name 会社名；limit_date 消费期限}
  static productInfoPrint(int sceneMark, Map<String, dynamic> printData) async {
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        // PDF宽度
        final pdfWidth = 50 * mm;
        // PDF高度
        final pdfHeight = 85 * mm;
        // PDF内边距
        final pdfMargin = 2 * mm;
        // 内容宽度
        final contentWidth = pdfWidth - pdfMargin - pdfMargin;
        // 内容宽度
        final contentHeight = pdfHeight - pdfMargin - pdfMargin;
        // 文本内容宽度
        final textContentWidth = 60 * mm;

        // 文档
        final doc = pw.Document();
        // 页面样式
        final pageFormat =
            PdfPageFormat(pdfWidth, pdfHeight, marginAll: pdfMargin);
        // TTF
        final ttf = await rootBundle.load('assets/font/stkaiti.ttf');
        // 字体
        final font = pw.Font.ttf(ttf);
        // 图片
        final logo = await rootBundle.loadString(WMSICons.PRINT_LOGO);

        doc.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (pw.Context context) {
              return pw.Container(
                width: contentWidth,
                height: contentHeight,
                child: pw.Stack(
                  children: [
                    // 条形码区域
                    pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              // LOGO
                              pw.Container(
                                width: 34,
                                height: 34,
                                margin: pw.EdgeInsets.all(3),
                                child: pw.SvgImage(svg: logo),
                              ),
                              // 条形码
                              BarcodeUtils.createPdfBarcode(
                                  printData['code'] != null
                                      ? printData['code'].toString()
                                      : '',
                                  width: 40,
                                  isQR: true),
                            ],
                          ),
                          // 商品编码
                          pw.Text(
                            printData['code'] != null
                                ? printData['code'].toString()
                                : '',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 内容区域
                    pw.Positioned(
                      bottom: 0,
                      // 位移
                      child: pw.Transform.translate(
                        offset: PdfPoint(0, textContentWidth + 2),
                        // 旋转
                        child: pw.Transform.rotate(
                          angle: 90 * (-pi / 180),
                          origin: PdfPoint(
                              -textContentWidth / 2, -contentWidth / 2),
                          // 文本内容
                          child: pw.Container(
                            width: textContentWidth,
                            height: contentWidth,
                            child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceAround,
                              children: [
                                // 指示编码 + 指示明细编码
                                pw.Container(
                                  child: sceneMark == 2 || sceneMark == 5
                                      ? pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Container(
                                              width:
                                                  (textContentWidth / 4 * 3) -
                                                      2,
                                              height: 13,
                                              margin: pw.EdgeInsets.fromLTRB(
                                                  0, 0, 2, 0),
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                  color: PdfColor.fromHex(
                                                      '#CCCCCC'),
                                                  width: 1,
                                                  style: pw.BorderStyle.solid,
                                                ),
                                              ),
                                              child: pw.Text(
                                                printData['no'] != null
                                                    ? printData['no'].toString()
                                                    : '',
                                                textAlign: pw.TextAlign.center,
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            pw.Container(
                                              width:
                                                  (textContentWidth / 4 * 1) -
                                                      2,
                                              height: 13,
                                              margin: pw.EdgeInsets.fromLTRB(
                                                  2, 0, 0, 0),
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                  color: PdfColor.fromHex(
                                                      '#CCCCCC'),
                                                  width: 1,
                                                  style: pw.BorderStyle.solid,
                                                ),
                                              ),
                                              child: pw.Text(
                                                printData['no'] != null &&
                                                        printData[
                                                                'details_no'] !=
                                                            null
                                                    ? printData['details_no']
                                                        .toString()
                                                        .substring(
                                                            printData['no']
                                                                .toString()
                                                                .length)
                                                    : '',
                                                textAlign: pw.TextAlign.center,
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : sceneMark == 3 || sceneMark == 4
                                          ? pw.Container(
                                              width: textContentWidth,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                  color: PdfColor.fromHex(
                                                      '#CCCCCC'),
                                                  width: 1,
                                                  style: pw.BorderStyle.solid,
                                                ),
                                              ),
                                              child: pw.Text(
                                                printData['no'] != null
                                                    ? printData['no'].toString()
                                                    : '',
                                                textAlign: pw.TextAlign.center,
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )
                                          : pw.Container(),
                                ),
                                // 商品略称
                                pw.Container(
                                  width: textContentWidth,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColor.fromHex('#CCCCCC'),
                                      width: 1,
                                      style: pw.BorderStyle.solid,
                                    ),
                                  ),
                                  child: pw.Text(
                                    printData['name'] != null
                                        ? printData['name'].toString()
                                        : '',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                // 商品数量 + 商品荷姿
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text(''),
                                    pw.Container(
                                      padding:
                                          pw.EdgeInsets.fromLTRB(6, 0, 6, 0),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColor.fromHex('#CCCCCC'),
                                          width: 1,
                                          style: pw.BorderStyle.solid,
                                        ),
                                      ),
                                      child: pw.Text(
                                        (printData['number'] != null
                                                ? printData['number']
                                                        .toString() +
                                                    ' '
                                                : '') +
                                            (printData['type'] != null
                                                ? printData['type'].toString()
                                                : ''),
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          font: font,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 会社名 + 消费期限
                                pw.Container(
                                  child: sceneMark == 2 || sceneMark == 5
                                      ? pw.Row(
                                          children: [
                                            pw.Container(
                                              width:
                                                  (textContentWidth / 3 * 2) -
                                                      2,
                                              margin: pw.EdgeInsets.fromLTRB(
                                                  0, 0, 2, 0),
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                  color: PdfColor.fromHex(
                                                      '#CCCCCC'),
                                                  width: 1,
                                                  style: pw.BorderStyle.solid,
                                                ),
                                              ),
                                              child: pw.Text(
                                                printData['company_name'] !=
                                                        null
                                                    ? printData['company_name']
                                                        .toString()
                                                    : '',
                                                textAlign: pw.TextAlign.center,
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            pw.Container(
                                              width:
                                                  (textContentWidth / 3 * 1) -
                                                      2,
                                              margin: pw.EdgeInsets.fromLTRB(
                                                  2, 0, 0, 0),
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                  color: PdfColor.fromHex(
                                                      '#CCCCCC'),
                                                  width: 1,
                                                  style: pw.BorderStyle.solid,
                                                ),
                                              ),
                                              child: pw.Text(
                                                printData['limit_date'] != null
                                                    ? printData['limit_date']
                                                        .toString()
                                                    : '',
                                                textAlign: pw.TextAlign.center,
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : sceneMark == 3
                                          ? pw.Container(
                                              width: textContentWidth,
                                              decoration: pw.BoxDecoration(
                                                border: pw.Border.all(
                                                  color: PdfColor.fromHex(
                                                      '#CCCCCC'),
                                                  width: 1,
                                                  style: pw.BorderStyle.solid,
                                                ),
                                              ),
                                              child: pw.Text(
                                                printData['company_name'] !=
                                                        null
                                                    ? printData['company_name']
                                                        .toString()
                                                    : '',
                                                textAlign: pw.TextAlign.center,
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            )
                                          : pw.Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );

        return doc.save();
      },
    );
  }

  // 出荷ラベル打印
  // data 打印数据：{code 条形编码；no 文本编码；date 日期；name1 名称1；name2 名称2；company_name 会社名；company_phone 会社电话}
  static kaihoPrint(Map<String, dynamic> printData) async {
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        // PDF宽度
        final pdfWidth = 50 * mm;
        // PDF高度
        final pdfHeight = 85 * mm;
        // PDF内边距
        final pdfMargin = 2 * mm;
        // 内容宽度
        final contentWidth = pdfWidth - pdfMargin - pdfMargin;
        // 内容宽度
        final contentHeight = pdfHeight - pdfMargin - pdfMargin;
        // 文本内容宽度
        final textContentWidth = 60 * mm;

        // 文档
        final doc = pw.Document();
        // 页面样式
        final pageFormat =
            PdfPageFormat(pdfWidth, pdfHeight, marginAll: pdfMargin);
        // TTF
        final ttf = await rootBundle.load('assets/font/stkaiti.ttf');
        // 字体
        final font = pw.Font.ttf(ttf);
        // 图片
        final logo = await rootBundle.loadString(WMSICons.PRINT_LOGO);

        doc.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (pw.Context context) {
              return pw.Container(
                width: contentWidth,
                height: contentHeight,
                child: pw.Stack(
                  children: [
                    // 条形码区域
                    pw.Container(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              // LOGO
                              pw.Container(
                                width: 34,
                                height: 34,
                                margin: pw.EdgeInsets.all(3),
                                child: pw.SvgImage(svg: logo),
                              ),
                              // 条形码
                              BarcodeUtils.createPdfBarcode(
                                  printData['code'] != null
                                      ? printData['code'].toString()
                                      : '',
                                  width: 40,
                                  isQR: true),
                            ],
                          ),
                          // 商品编码
                          pw.Text(
                            printData['code'] != null
                                ? printData['code'].toString()
                                : '',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 内容区域
                    pw.Positioned(
                      bottom: 0,
                      // 位移
                      child: pw.Transform.translate(
                        offset: PdfPoint(0, textContentWidth + 2),
                        // 旋转
                        child: pw.Transform.rotate(
                          angle: 90 * (-pi / 180),
                          origin: PdfPoint(
                              -textContentWidth / 2, -contentWidth / 2),
                          // 文本内容
                          child: pw.Container(
                            width: textContentWidth,
                            height: contentWidth,
                            child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceAround,
                              children: [
                                pw.Container(
                                  width: textContentWidth,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColor.fromHex('#CCCCCC'),
                                      width: 1,
                                      style: pw.BorderStyle.solid,
                                    ),
                                  ),
                                  child: pw.Column(
                                    children: [
                                      pw.Container(
                                        height: 13,
                                        child: pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text(
                                              printData['no'] != null
                                                  ? printData['no'].toString()
                                                  : '',
                                              textAlign: pw.TextAlign.center,
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize: 10,
                                              ),
                                            ),
                                            pw.Text(
                                              '',
                                              textAlign: pw.TextAlign.center,
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      pw.Container(
                                        height: 13,
                                        child: pw.Row(
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.spaceBetween,
                                          children: [
                                            pw.Text(
                                              '',
                                              textAlign: pw.TextAlign.center,
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize: 10,
                                              ),
                                            ),
                                            pw.Text(
                                              printData['date'] != null
                                                  ? printData['date'].toString()
                                                  : '',
                                              textAlign: pw.TextAlign.center,
                                              style: pw.TextStyle(
                                                font: font,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Container(
                                  width: textContentWidth,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColor.fromHex('#CCCCCC'),
                                      width: 1,
                                      style: pw.BorderStyle.solid,
                                    ),
                                  ),
                                  child: pw.Text(
                                    printData['name1'] != null
                                        ? printData['name1'].toString()
                                        : '',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  width: textContentWidth,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColor.fromHex('#CCCCCC'),
                                      width: 1,
                                      style: pw.BorderStyle.solid,
                                    ),
                                  ),
                                  child: pw.Text(
                                    printData['name2'] != null
                                        ? printData['name2'].toString()
                                        : '',
                                    textAlign: pw.TextAlign.center,
                                    style: pw.TextStyle(
                                      font: font,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                pw.Row(
                                  children: [
                                    pw.Container(
                                      width: (textContentWidth / 3 * 2) - 2,
                                      margin:
                                          pw.EdgeInsets.fromLTRB(0, 0, 2, 0),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColor.fromHex('#CCCCCC'),
                                          width: 1,
                                          style: pw.BorderStyle.solid,
                                        ),
                                      ),
                                      child: pw.Text(
                                        printData['company_name'] != null
                                            ? printData['company_name']
                                                .toString()
                                            : '',
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          font: font,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: (textContentWidth / 3 * 1) - 2,
                                      margin:
                                          pw.EdgeInsets.fromLTRB(2, 0, 0, 0),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColor.fromHex('#CCCCCC'),
                                          width: 1,
                                          style: pw.BorderStyle.solid,
                                        ),
                                      ),
                                      child: pw.Text(
                                        printData['company_phone'] != null
                                            ? printData['company_phone']
                                                .toString()
                                            : '',
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                          font: font,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );

        return doc.save();
      },
    );
  }
}
