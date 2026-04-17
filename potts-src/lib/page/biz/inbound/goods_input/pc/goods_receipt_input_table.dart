import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_bloc.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_model.dart';
import 'package:wms/widget/table/pc/wms_table_widget.dart';
import 'package:wms/widget/wms_dialog_widget.dart';

/**
 * 内容：入庫入力-文件
 * 作者：熊草云
 * 时间：2023/08/23
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 全局主键-表格共通

// 通信数据
List<Map<String, dynamic>> commData = [];
// 表格数据
// List<ShipDetail> tableData = [];

class GoodsReceiptInputTable extends StatefulWidget {
  const GoodsReceiptInputTable({super.key});

  @override
  State<GoodsReceiptInputTable> createState() => _GoodsReceiptInputTableState();
}

class _GoodsReceiptInputTableState extends State<GoodsReceiptInputTable> {
  // 复选框勾选的数据表
  // ignore: unused_field
  List<dynamic> _dataList = [];
  void upDataList(List<dynamic> value) {
    setState(() {
      _dataList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoodsInputBloc, GoodsInputModel>(builder: (bloc, state) {
      return Container(
        margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(20, 40, 10, 10),
                child: Text(
                  WMSLocalizations.i18n(context)!.goods_receipt_input_list,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    height: 1.0,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                      child: Container(),
                    ),
                    GoodsReceiptInputTableContent(dataListChange: upDataList),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// 入庫入力-表格内容
class GoodsReceiptInputTableContent extends StatefulWidget {
  final ValueChanged<List<dynamic>> dataListChange;
  const GoodsReceiptInputTableContent(
      {super.key, required this.dataListChange});

  @override
  State<GoodsReceiptInputTableContent> createState() =>
      _GoodsReceiptInputTableContentState();
}

class _GoodsReceiptInputTableContentState
    extends State<GoodsReceiptInputTableContent> {
  @override
  Widget build(BuildContext context) {
    // 删除弹窗
    _deleteDialog(value) {
      GoodsInputBloc bloc = context.read<GoodsInputBloc>();
      showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<GoodsInputBloc>.value(
            value: bloc,
            child: BlocBuilder<GoodsInputBloc, GoodsInputModel>(
              builder: (context, state) {
                return WMSDiaLogWidget(
                  titleText: WMSLocalizations.i18n(context)!
                      .display_instruction_confirm_delete,
                  contentText:
                      WMSLocalizations.i18n(context)!.home_main_page_text6 +
                          '：' +
                          value['id'].toString() +
                          ' ' +
                          WMSLocalizations.i18n(context)!
                              .display_instruction_delete,
                  buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                  buttonRightText:
                      WMSLocalizations.i18n(context)!.delivery_note_10,
                  onPressedLeft: () {
                    // 关闭弹窗
                    Navigator.pop(context);
                  },
                  onPressedRight: () async {
                    bool flag = await context
                        .read<GoodsInputBloc>()
                        .DeleteTableDetailsEvent(context, value);
                    if (flag) {
                      context.read<GoodsInputBloc>().add(
                          QueryDtbReceiveDataEvent(
                              context
                                  .read<GoodsInputBloc>()
                                  .state
                                  .incomingBarCode,
                              context));
                    }
                    // 关闭弹窗
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        },
      );
    }

    return Column(
      children: [
        WMSTableWidget<GoodsInputBloc, GoodsInputModel>(
          columns: [
            {
              'key': 'id',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_1,
            },
            {
              'key': 'product_code',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_2,
            },
            {
              'key': 'product_name',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_3,
            },
            {
              'key': 'product_price',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_4,
            },
            {
              'key': 'store_num',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_5,
            },
            {
              'key': 'size',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_6,
            },
            {
              'key': 'loc_cd',
              'width': 4,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_7,
            },
            {
              'key': 'count',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .goods_receipt_input_table_title_8,
            },
          ],
          operatePopupHeight: 170,
          operatePopupOptions: [
            {
              'title': WMSLocalizations.i18n(context)!.exit_input_form_issuance,
              'callback': (_, value) async {
                // 赵士淞 - 始
                context
                    .read<GoodsInputBloc>()
                    .add(TablePrinterEvent(context, value['id']));
                // 赵士淞 - 终
              },
            },
            {
              'title': WMSLocalizations.i18n(context)!.exit_input_table_update,
              'callback': (_, value) {
                context
                    .read<GoodsInputBloc>()
                    .add(QueryTableDetailsEvent(context, value));
              },
            },
            {
              'title': WMSLocalizations.i18n(context)!.exit_input_table_delete,
              'callback': (_, value) async {
                _deleteDialog(value);
              },
            },
          ],
        ),
      ],
    );
  }
}
