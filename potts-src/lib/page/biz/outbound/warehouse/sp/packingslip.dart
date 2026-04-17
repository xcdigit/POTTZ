import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';

import '../../warehouse/bloc/warehouse_detail_bloc.dart';
import '../../warehouse/bloc/warehouse_detail_model.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：納品書-明细
 * 作者：王光顺
 * 时间：2023/11/02
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];

// 全局主键-表格共通
// GlobalKey<WMSTableWidgetState> _deliveryNoteTable = new GlobalKey();
Map currentParam = {};

// ignore: must_be_immutable
class PackingSlipPage extends StatefulWidget {
  // 出荷指示ID
  int shipId = 0;
  PackingSlipPage({super.key, this.shipId = 0});
  @override
  State<PackingSlipPage> createState() => _PackingSlipPageState();
}

class _PackingSlipPageState extends State<PackingSlipPage> {
  //定义接受对象

  @override
  Widget build(BuildContext context) {
    setState(() {
      //接收传过来的参数
      currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
    });

    return BlocProvider<WarehouseDetailBloc>(create: (context) {
      return WarehouseDetailBloc(
        WarehouseDetailModel(shipId: widget.shipId),
      );
    }, child: BlocBuilder<WarehouseDetailBloc, WarehouseDetailModel>(
        builder: (context, state) {
      return ListView(
        children: [
          Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  DefaultTextStyle(
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 50),
                                child: Wrap(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Column(
                                        children: [
                                          BuildData(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_16,
                                              0),
                                          BuildText(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_15,
                                              0),
                                          BuildData(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_18,
                                              1),
                                          BuildText(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_17,
                                              1)
                                        ],
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            BuildBigText(
                                                WMSLocalizations.i18n(context)!
                                                    .delivery_note_27,
                                                0),
                                            BuildBigText(
                                                WMSLocalizations.i18n(context)!
                                                    .delivery_note_28,
                                                1)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "${WMSLocalizations.i18n(context)!.delivery_note_14}：${currentParam['ship_no']}",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(44, 167, 176, 1),
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          DetailTablePage(),
        ],
      );
    }));
  }

  // 日期
  Widget BuildData(String text, int index) {
    return BlocBuilder<WarehouseDetailBloc, WarehouseDetailModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(text),
            ),
            WMSInputboxWidget(
                text: index == 0
                    ? state.shipDetailCustomize['rcv_sch_date'].toString()
                    : state.shipDetailCustomize['cus_rev_date'].toString(),
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 文本框
  Widget BuildText(String text, index) {
    return BlocBuilder<WarehouseDetailBloc, WarehouseDetailModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(text),
            ),
            WMSInputboxWidget(
                text: index == 0
                    ? state.shipDetailCustomize['customer_name'].toString()
                    : state.shipDetailCustomize['name'].toString(),
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 文本框
  Widget BuildBigText(String text, index) {
    return BlocBuilder<WarehouseDetailBloc, WarehouseDetailModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 132,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(text),
            ),
            WMSInputboxWidget(
              height: 100,
              text: index == 0
                  ? state.shipDetailCustomize['note1'].toString()
                  : state.shipDetailCustomize['note2'].toString(),
              readOnly: true,
            ),
          ],
        ),
      );
    });
  }
}

//  明细一览
class DetailTablePage extends StatefulWidget {
  const DetailTablePage({super.key});

  @override
  State<DetailTablePage> createState() => _DetailTablePageState();
}

class _DetailTablePageState extends State<DetailTablePage> {
  // 初始化一覧表格

  @override
  Widget build(BuildContext context) {
    // 判断当前下标

    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        children: [
          // 纳品行
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              height: 40,
              child: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_delivery_line,
                  style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1), fontSize: 18)),
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
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                  //   child: DetailTableButton(),
                  // ),
                  DetailTableButtonContent(),
                  // Subtotal()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailTableButtonContent extends StatefulWidget {
  const DetailTableButtonContent({super.key});

  @override
  State<DetailTableButtonContent> createState() =>
      _DetailTableButtonContentState();
}

class _DetailTableButtonContentState extends State<DetailTableButtonContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseDetailBloc, WarehouseDetailModel>(
        builder: (context, state) {
      return WMSTableWidget<WarehouseDetailBloc, WarehouseDetailModel>(
        columns: [
          {
            'key': 'id',
            'width': .5,
            'title':
                WMSLocalizations.i18n(context)!.instruction_input_table_title_1,
          },
          {
            'key': 'warehouse_no',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_1,
          },
          {
            'key': 'code',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_2,
          },
          {
            'key': 'name',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_3,
          },
          {
            'key': 'product_price',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_4,
          },
          {
            'key': 'ship_num',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_5,
          },
          {
            'key': 'size',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_6,
          },
          {
            'key': 'subtotal',
            'width': .5,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_7,
          },
        ],
        showCheckboxColumn: false,
        operatePopupHeight: 100,
        operatePopupOptions: [
          {
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_details,
            'callback': (_, value) async {
              Map<String, dynamic> detailData = await context
                  .read<WarehouseDetailBloc>()
                  .SetDetailDataEvent(value);
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeliveryDetailDialog(detailData: detailData);
                  });
            },
          },
        ],
      );
    });
  }
}

// 明细数据查询提示
class DetailDialog extends StatefulWidget {
  const DetailDialog({super.key});

  @override
  State<DetailDialog> createState() => _DetailDialogState();
}

class _DetailDialogState extends State<DetailDialog> {
  @override
  Widget build(BuildContext context) {
    return WMSDiaLogWidget(
      titleText: "提示",
      contentText: "一次只能查询一条",
      buttonLeftFlag: false,
      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
      onPressedRight: () {
        // 页面++
        setState(() {});
        // 关闭弹窗
        Navigator.pop(context);
      },
    );
  }
}

//   納品明細一覧ダイアログ 弹窗
class DeliveryDetailDialog extends StatefulWidget {
  final Map detailData;
  const DeliveryDetailDialog({super.key, required this.detailData});

  @override
  State<DeliveryDetailDialog> createState() => _DeliveryDetailDialogState();
}

class _DeliveryDetailDialogState extends State<DeliveryDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // 弹窗圆角
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            WMSLocalizations.i18n(context)!.delivery_note_8,
            style:
                TextStyle(color: Color.fromRGBO(44, 167, 176, 1), fontSize: 24),
          ),
          Container(
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(44, 167, 176, 1)),
              child: Text(
                WMSLocalizations.i18n(context)!.delivery_note_close,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //关闭对话框
              },
            ),
          ),
        ],
      ),

      content: Container(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
        width: MediaQuery.of(context).size.width * .8,
        child: ListView(
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!.pink_list_47,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['ship_line_no'] != null
                                        ? widget.detailData['ship_line_no']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_1,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['warehouse_no'] != null
                                        ? widget.detailData['warehouse_no']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 72,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_2,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 48,
                              ),
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['code'] != null
                                        ? widget.detailData['code'].toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 72,
                        ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_3,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                minHeight: 48,
                              ),
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['name'] != null
                                        ? widget.detailData['name'].toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_4,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['product_price'] != null
                                        ? widget.detailData['product_price']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .shipment_inspection_number,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['ship_num'] != null
                                        ? widget.detailData['ship_num']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_6,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['size'] != null
                                        ? widget.detailData['size'].toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_11,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['limit_date'] != null
                                        ? widget.detailData['limit_date']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_12,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['lot_no'] != null
                                        ? widget.detailData['lot_no'].toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_13,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              height: 48,
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 251, 251, 1),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.detailData['serial_no'] != null
                                        ? widget.detailData['serial_no']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 204,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_14,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        widget.detailData['image1_effective'] == '' ||
                                widget.detailData['image1_effective'] == null
                            ? Image.asset(
                                WMSICons.NO_IMAGE,
                                width: 136,
                                height: 180,
                              )
                            : Image.network(
                                (widget.detailData['image1_effective']),
                                width: 136,
                                height: 180,
                              ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 204,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_15,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        widget.detailData['image2_effective'] == '' ||
                                widget.detailData['image2_effective'] == null
                            ? Image.asset(
                                WMSICons.NO_IMAGE,
                                width: 136,
                                height: 180,
                              )
                            : Image.network(
                                (widget.detailData['image2_effective']),
                                width: 136,
                                height: 180,
                              ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 160,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_16,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: 136,
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(251, 251, 251, 1),
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.detailData['company_note1'] != null
                                  ? widget.detailData['company_note1']
                                      .toString()
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 160,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_18,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: 136,
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(251, 251, 251, 1),
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.detailData['company_note2'] != null
                                  ? widget.detailData['company_note2']
                                      .toString()
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 160,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_19,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: 136,
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(251, 251, 251, 1),
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.detailData['notice_note1'] != null
                                  ? widget.detailData['notice_note1'].toString()
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 160,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_17,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        Container(
                          height: 136,
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(251, 251, 251, 1),
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.detailData['notice_note2'] != null
                                  ? widget.detailData['notice_note2'].toString()
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
