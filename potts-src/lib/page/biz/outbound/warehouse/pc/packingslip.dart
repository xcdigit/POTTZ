import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/account_ticket/pc/wms_account_ticket_widget.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';

import '../bloc/warehouse_detail_bloc.dart';
import '../bloc/warehouse_detail_model.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：納品書-文件
 * 作者：熊草云
 * 时间：2023/08/03
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
              margin: EdgeInsets.fromLTRB(40, 40, 40, 10),
              height: 445,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        child: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_26,
                            style: TextStyle(
                                color: Color.fromRGBO(44, 167, 176, 1),
                                fontSize: 24)),
                      ),
                      // 返回按钮
                      Container(
                        color: Colors.white,
                        height: 35,
                        width: 80,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                              WMSLocalizations.i18n(context)!
                                  .menu_content_3_11_11,
                              style: TextStyle(
                                  color: Color.fromRGBO(44, 167, 176, 1))),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  DefaultTextStyle(
                    style: TextStyle(fontSize: 14),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      height: 360,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black12,
                            width: 1.0,
                          )),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 40),
                                height: 290,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                BuildData(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_16,
                                                    0),
                                                SizedBox(width: 30),
                                                BuildText(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_15,
                                                    0)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                BuildData(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_18,
                                                    1),
                                                SizedBox(width: 30),
                                                BuildText(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_17,
                                                    1)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.only(right: 100),
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
                                    Text(
                                      "${WMSLocalizations.i18n(context)!.delivery_note_14}：${currentParam['ship_no']}",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                          fontSize: 14),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 90,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 61, 174, 182),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        (WMSAccountTicketWidget(
                                                      formKbn: Config.NUMBER_ONE
                                                          .toString(),
                                                      idList: [state.shipId],
                                                    )),
                                                  ),
                                                );
                                              },
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .delivery_note_9,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
      return Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text),
              ],
            ),
            SizedBox(height: 5),
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
      return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text),
              ],
            ),
            SizedBox(height: 5),
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
      return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text),
              ],
            ),
            SizedBox(height: 5),
            WMSInputboxWidget(
                height: 100,
                text: index == 0
                    ? state.shipDetailCustomize['note1'].toString()
                    : state.shipDetailCustomize['note2'].toString(),
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 输入框
  Expanded BuildInput(String text) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: WMSInputboxWidget(
              borderColor: Color.fromRGBO(224, 224, 224, 1),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
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
      margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
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
                      color: Color.fromRGBO(44, 167, 176, 1), fontSize: 24)),
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
            'title':
                WMSLocalizations.i18n(context)!.instruction_input_table_title_1,
          },
          {
            'key': 'warehouse_no',
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_1,
          },
          {
            'key': 'code',
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_2,
          },
          {
            'key': 'name',
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_3,
          },
          {
            'key': 'product_price',
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_4,
          },
          {
            'key': 'ship_num',
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_5,
          },
          {
            'key': 'size',
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_6,
          },
          {
            'key': 'subtotal',
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
          child: ListView(children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['ship_line_no'] != null
                                  ? widget.detailData['ship_line_no'].toString()
                                  : '',
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['warehouse_no'] != null
                                  ? widget.detailData['warehouse_no'].toString()
                                  : '',
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
                                    .delivery_note_shipment_details_2,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['code'] != null
                                  ? widget.detailData['code'].toString()
                                  : '',
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
                                    .delivery_note_shipment_details_3,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['name'] != null
                                  ? widget.detailData['name'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['product_price'] != null
                                  ? widget.detailData['product_price']
                                      .toString()
                                  : '',
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['ship_num'] != null
                                  ? widget.detailData['ship_num'].toString()
                                  : '',
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['size'] != null
                                  ? widget.detailData['size'].toString()
                                  : '',
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['limit_date'] != null
                                  ? widget.detailData['limit_date'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['lot_no'] != null
                                  ? widget.detailData['lot_no'].toString()
                                  : '',
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
                            WMSInputboxWidget(
                              readOnly: true,
                              text: widget.detailData['serial_no'] != null
                                  ? widget.detailData['serial_no'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: Container(
                    height: 204,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //商品写真1
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_5,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),

                        widget.detailData['image1_effective'] != null &&
                                widget.detailData['image1_effective'] != ''
                            ? Image.network(
                                widget.detailData['image1_effective'],
                                height: 136,
                              )
                            : Image.asset(
                                WMSICons.NO_IMAGE,
                                height: 136,
                              ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                        //防止报错 测试期间注释
                        widget.detailData['image2_effective'] != null &&
                                widget.detailData['image2_effective'] != ''
                            ? Image.network(
                                widget.detailData['image2_effective'],
                                height: 136,
                              )
                            : Image.asset(
                                WMSICons.NO_IMAGE,
                                height: 136,
                              ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                        WMSInputboxWidget(
                          height: 136,
                          readOnly: true,
                          text: widget.detailData['company_note1'] != null
                              ? widget.detailData['company_note1'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                        WMSInputboxWidget(
                          height: 136,
                          readOnly: true,
                          text: widget.detailData['company_note2'] != null
                              ? widget.detailData['company_note2'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                        WMSInputboxWidget(
                          height: 136,
                          readOnly: true,
                          text: widget.detailData['notice_note1'] != null
                              ? widget.detailData['notice_note1'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
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
                        WMSInputboxWidget(
                          height: 136,
                          readOnly: true,
                          text: widget.detailData['notice_note2'] != null
                              ? widget.detailData['notice_note2'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
