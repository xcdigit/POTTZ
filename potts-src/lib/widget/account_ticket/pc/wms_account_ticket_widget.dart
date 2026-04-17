import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../common/utils/barcode_utils.dart';
import '../../../file/wms_common_file.dart';
import '../../../redux/wms_state.dart';
import '../bloc/wms_account_ticket_bloc.dart';
import '../bloc/wms_account_ticket_model.dart';

/**
 * 内容：账票组件
 * 作者：赵士淞
 * 时间：2023/12/26
 */
// ignore: must_be_immutable
class WMSAccountTicketWidget extends StatefulWidget {
  // 账票区分
  String formKbn;
  // ID列表
  List<int> idList;

  WMSAccountTicketWidget({
    super.key,
    required this.formKbn,
    required this.idList,
  });

  @override
  State<WMSAccountTicketWidget> createState() => _WMSAccountTicketWidgetState();
}

class _WMSAccountTicketWidgetState extends State<WMSAccountTicketWidget> {
  @override
  Widget build(BuildContext context) {
    // 会社ID
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;

    return BlocProvider<WMSAccountticketBloc>(
      create: (context) {
        return WMSAccountticketBloc(
          WMSAccountTicketModel(
            rootContext: context,
            companyId: companyId,
            formKbn: widget.formKbn,
            idList: widget.idList,
          ),
        );
      },
      child: WMSAccountTicketDetail(),
    );
  }
}

// 账票组件详情
class WMSAccountTicketDetail extends StatefulWidget {
  const WMSAccountTicketDetail({super.key});

  @override
  State<WMSAccountTicketDetail> createState() => _WMSAccountTicketDetailState();
}

class _WMSAccountTicketDetailState extends State<WMSAccountTicketDetail> {
  // TTF
  var ttf;
  // 字体
  var font;
  // 图片
  var headerLogo;
  var contentTableImage;
  // 文本
  var headerText;
  var reprintText;
  var printTimeText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WMSAccountticketBloc, WMSAccountTicketModel>(
      builder: (context, state) {
        // 判断账票数据长度
        if (state.formData.length != 0) {
          return Stack(
            children: [
              PdfPreview(
                maxPageWidth: state.formData['form_direction'] ==
                        Config.NUMBER_ONE.toString()
                    ? 1200
                    : 700,
                canChangePageFormat: false,
                // canChangeOrientation: state.formData['form_direction'] ==
                //         Config.NUMBER_ONE.toString()
                //     ? true
                //     : false,
                canChangeOrientation: false,
                canDebug: false,
                initialPageFormat: state.formData['form_direction'] ==
                        Config.NUMBER_ONE.toString()
                    ? PdfPageFormat(841.8897637795275, 595.275590551181,
                        marginAll: 56.69291338582677)
                    : PdfPageFormat(595.275590551181, 841.8897637795275,
                        marginAll: 56.69291338582677),
                build: (format) {
                  print(format.toString());
                  return _buildPdf(format, state);
                },
              ),
              Positioned(
                right: 20,
                top: 20,
                child: Container(
                  color: Colors.white,
                  height: 35,
                  width: 80,
                  child: OutlinedButton(
                    onPressed: () {
                      GoRouter.of(context).pop('refresh return');
                    },
                    child: Text(
                      WMSLocalizations.i18n(context)!.menu_content_3_11_11,
                      style: TextStyle(
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      side: MaterialStateProperty.all(
                        const BorderSide(
                          width: 1,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  // 构建PDF
  Future<Uint8List> _buildPdf(
      PdfPageFormat format, WMSAccountTicketModel state) async {
    // TTF
    ttf = await rootBundle.load(WMSICons.PRINT_FONT);
    // 字体
    font = pw.Font.ttf(ttf);
    // 图片
    var _imageUrl =
        await WMSCommonFile().previewImageFile(state.formData['form_picture']);
    var _imageBytes = await _downloadImage(Uri.parse(_imageUrl));
    headerLogo = pw.MemoryImage(_imageBytes);
    contentTableImage =
        await rootBundle.loadString(WMSICons.PRINT_TABLE_HEADER_BACKGROUND);
    // 文本
    headerText = state.formData['form_kbn'] == Config.NUMBER_ONE.toString()
        ? WMSLocalizations.i18n(context)!.menu_content_3_21
        : state.formData['form_kbn'] == Config.NUMBER_TWO.toString()
            ? WMSLocalizations.i18n(context)!.menu_content_3_8
            : state.formData['form_kbn'] == Config.NUMBER_THREE.toString()
                ? WMSLocalizations.i18n(context)!
                    .inquiry_schedule_print_receivelist
                : '';
    reprintText = WMSLocalizations.i18n(state.rootContext)!.delivery_note_35;
    printTimeText = WMSLocalizations.i18n(context)!.printing_time;

    // 文档
    final doc = pw.Document();

    // 循环表二列表
    for (int i = 0; i < state.tableTwoList.length; i++) {
      // 文档添加页面
      doc.addPage(
        pw.MultiPage(
          pageTheme: _buildTheme(
            format,
            state.formData['form_direction'],
          ),
          header: (context) {
            return _buildHeader(context, state, i);
          },
          footer: _buildFooter,
          build: (context) {
            return [
              _contentHeader(context, state, i),
              _contentTable(context, state, i),
            ];
          },
        ),
      );
    }

    // 文档保存
    return doc.save();
  }

  // 构建样式
  pw.PageTheme _buildTheme(PdfPageFormat format, String formDirection) {
    return pw.PageTheme(
      pageFormat: format,
      margin: pw.EdgeInsets.all(0),
      // orientation: formDirection == Config.NUMBER_ONE.toString()
      //     ? pw.PageOrientation.landscape
      //     : formDirection == Config.NUMBER_TWO.toString()
      //         ? pw.PageOrientation.natural
      //         : pw.PageOrientation.portrait,
    );
  }

  // 构建头部
  pw.Widget _buildHeader(
      pw.Context context, WMSAccountTicketModel state, int index) {
    return pw.Container(
      padding: pw.EdgeInsets.fromLTRB(60, 40, 60, 33),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#2CA7B0'),
      ),
      child: pw.DefaultTextStyle(
        style: pw.TextStyle(
          font: font,
          color: PdfColor.fromHex('#FFFFFF'),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // LOGO（左）
            pw.Image(
              headerLogo,
              height: 48,
            ),
            // 标题（右）
            state.tableTwoList[index]['pdf_kbn'] ==
                    Config.NUMBER_THREE.toString()
                ? pw.Column(
                    children: [
                      pw.Text(
                        headerText,
                        style: pw.TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      pw.Text(
                        reprintText,
                        style: pw.TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                : pw.Text(
                    headerText,
                    style: pw.TextStyle(
                      fontSize: 24,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // 构建底部
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      height: 32,
      padding: pw.EdgeInsets.fromLTRB(60, 0, 60, 0),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#2CA7B0'),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            context.pageNumber.toString() +
                ' / ' +
                context.pagesCount.toString(),
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColor.fromHex('#FFFFFF'),
            ),
          ),
        ],
      ),
    );
  }

  // 绘制头部
  pw.Widget _contentHeader(
      pw.Context context, WMSAccountTicketModel state, int index) {
    return pw.Container(
      padding: pw.EdgeInsets.fromLTRB(60, 0, 60, 20),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#2CA7B0'),
      ),
      child: pw.DefaultTextStyle(
        style: pw.TextStyle(
          font: font,
          color: PdfColor.fromHex('#FFFFFF'),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: _contentHeaderDetail(state, index),
        ),
      ),
    );
  }

  // 绘制表格
  pw.Widget _contentTable(
      pw.Context context, WMSAccountTicketModel state, int index) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        image: pw.DecorationSvgImage(
          svg: contentTableImage,
          fit: pw.BoxFit.fitWidth,
          alignment: pw.Alignment.topCenter,
        ),
      ),
      child: pw.Container(
        margin: pw.EdgeInsets.fromLTRB(24, 0, 24, 0),
        padding: pw.EdgeInsets.all(16),
        child: pw.TableHelper.fromTextArray(
          border: null,
          columnWidths: state.columnWidthsList,
          headerHeight: 32,
          headerStyle: pw.TextStyle(
            font: font,
            fontSize: 10,
            color: PdfColor.fromHex('#2CA7B0'),
          ),
          headerDecoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                color: PdfColor.fromHex('#2CA7B0'),
              ),
            ),
          ),
          headers: List<String>.generate(
            state.tableHeadersList.length,
            (num) {
              return state.tableHeadersTextList[num];
            },
          ),
          cellHeight: 48,
          cellStyle: pw.TextStyle(
            font: font,
            fontSize: 12,
            color: PdfColor.fromHex('#060E0F'),
          ),
          cellAlignment: pw.Alignment.center,
          data: List<List<dynamic>>.generate(
            state
                .contentSummaryList[index]
                    [state.contentSummaryList[index].length - 1]
                .length,
            (row) {
              return List<dynamic>.generate(
                state.tableHeadersList.length,
                (col) {
                  return _getTableDataText(
                      state.contentSummaryList[index]
                          [state.contentSummaryList[index].length - 1][row],
                      state.tableHeadersList[col]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // 下载图片
  Future<Uint8List> _downloadImage(Uri uri) async {
    // 获取图片
    final response = await http.get(uri);
    // 返回
    return response.bodyBytes;
  }

  // 绘制头部详情
  List<pw.Widget> _contentHeaderDetail(WMSAccountTicketModel state, int index) {
    // 头部详情
    List<pw.Widget> headerDetail = [];

    // 判断账单区分
    if (state.formKbn == Config.NUMBER_ONE.toString()) {
      // 头部详情
      headerDetail.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children:
                  _contentHeaderDetailItem(Config.NUMBER_ONE, state, index),
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children:
                  _contentHeaderDetailItem(Config.NUMBER_TWO, state, index),
            ),
          ],
        ),
      );
      // 头部详情
      headerDetail.add(
        pw.SizedBox(
          height: 16,
        ),
      );
      // 头部详情
      headerDetail.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children:
                  _contentHeaderDetailItem(Config.NUMBER_THREE, state, index),
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children:
                  _contentHeaderDetailItem(Config.NUMBER_FOUR, state, index),
            ),
          ],
        ),
      );
    } else if (state.formKbn == Config.NUMBER_TWO.toString() ||
        state.formKbn == Config.NUMBER_THREE.toString()) {
      // 头部详情
      headerDetail.add(
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children:
                  _contentHeaderDetailItem(Config.NUMBER_ONE, state, index),
            ),
            pw.Column(
              children: [
                pw.Text(
                  printTimeText +
                      '：' +
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children:
                  _contentHeaderDetailItem(Config.NUMBER_TWO, state, index),
            ),
          ],
        ),
      );
    }

    // 返回
    return headerDetail;
  }

  // 绘制头部详情单项
  List<pw.Widget> _contentHeaderDetailItem(
      int location, WMSAccountTicketModel state, int index) {
    // 头部详情单项
    List<pw.Widget> headerDetailItem = [];
    // 位置下标
    int locationIndex = location - 1;
    // 内容列表
    List<dynamic> contentList = state.contentSummaryList[index][locationIndex];

    // 循环内容列表
    for (int i = 0; i < contentList.length; i++) {
      // 当前内容
      Map<String, dynamic> currentContent = contentList[i];
      // 判断内容分类
      if (currentContent['assort'] == Config.NUMBER_ONE.toString() ||
          currentContent['assort'] == Config.NUMBER_THREE.toString()) {
        // 头部详情单项
        headerDetailItem.add(
          pw.Text(
            currentContent['show_field_name'] == Config.NUMBER_ONE.toString()
                ? currentContent['title'] + '：' + currentContent['value']
                : currentContent['value'],
            style: pw.TextStyle(
              fontSize: currentContent['word_size'],
            ),
          ),
        );
      } else if (currentContent['assort'] == Config.NUMBER_TWO.toString()) {
        // 头部详情单项
        headerDetailItem.add(
          BarcodeUtils.createPdfBarcode(currentContent['value'],
              width: 60, height: 60, isQR: true),
        );
      }
    }

    // 返回
    return headerDetailItem;
  }

  // 获取表格数据文本
  dynamic _getTableDataText(List<dynamic> row, String col) {
    // 值
    dynamic value = '';
    // 循环行
    for (int i = 0; i < row.length; i++) {
      // 判断key是否相等
      if (row[i]['key'] == col) {
        // 判断分类
        if (row[i]['assort'] == Config.NUMBER_ONE.toString() ||
            row[i]['assort'] == Config.NUMBER_THREE.toString()) {
          // 值
          value = row[i]['value'];
        } else if (row[i]['assort'] == Config.NUMBER_TWO.toString()) {
          // 值
          value = row[i]['value'] != null && row[i]['value'] != ''
              ? BarcodeUtils.createPdfBarcode(row[i]['value'].toString(),
                  isQR: true)
              : '';
        } else {
          // 值
          value = '';
        }
      }
    }
    // 返回
    return value;
  }
}
