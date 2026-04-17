import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/page/biz/outbound/pick/bloc/pick_list_detail_bloc.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';

import '../bloc/pick_list_detail_model.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：ピッキングリスト(シングル)
 * 作者：王光顺
 * 时间：2023/08/17
 */
//定义接受对象
class PickListPackingSlipPage extends StatefulWidget {
  const PickListPackingSlipPage({Key? key}) : super(key: key);

  @override
  State<PickListPackingSlipPage> createState() =>
      _PickListPackingSlipPageState();
}

Map<String, dynamic> currentParam = {};

class _PickListPackingSlipPageState extends State<PickListPackingSlipPage> {
  bool isHovered = false; // 初始化isHovered为false
  @override
  Widget build(BuildContext context) {
    currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocProvider<PickListDetailBloc>(
      create: (context) {
        return PickListDetailBloc(
          PickListDetailModel(shipId: currentParam['id']),
        );
      },
      child: BlocBuilder<PickListDetailBloc, PickListDetailModel>(
        builder: (context, state) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40, right: 30),
                height: 445,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          child: Text(
                            WMSLocalizations.i18n(context)!.pink_list_44,
                            style: TextStyle(
                              color: Color.fromRGBO(44, 167, 176, 1),
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(width: 30),
                                // 返回按钮
                                Container(
                                  color: Colors.white,
                                  height: 35,
                                  width: 80,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // context.go('/page_flag_3_8');
                                      GoRouter.of(context)
                                          .pop(); //.go('/page_flag_3_8');
                                    },
                                    child: Text(
                                        WMSLocalizations.i18n(context)!
                                            .menu_content_3_11_11,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                44, 167, 176, 1))),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      side: MaterialStateProperty.all(
                                        const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                    child: Row(children: [
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
                                                  )),
                                              Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      BuildData(
                                                          WMSLocalizations.i18n(
                                                                  context)!
                                                              .delivery_note_18,
                                                          2),
                                                      SizedBox(width: 30),
                                                      BuildText(
                                                          WMSLocalizations.i18n(
                                                                  context)!
                                                              .delivery_note_17,
                                                          1)
                                                    ],
                                                  )),
                                            ],
                                          )),
                                      SizedBox(width: 30),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.only(right: 100),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  height: 24,
                                                  child: Text(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_27,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Color.fromRGBO(
                                                          6, 14, 15, 1),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                              WMSInputboxWidget(
                                                height: 100,
                                                maxLines: 5,
                                                readOnly: true,
                                                text: state
                                                    .shipCustomize['note1']
                                                    .toString(),
                                                // inputBoxCallBack: (value) {
                                                //   // 设定出荷指示值事件
                                                //   context
                                                //       .read<
                                                //           PickListDetailBloc>()
                                                //       .add(SetShipValueEvent(
                                                //           'note1', value));
                                                // },
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  height: 24,
                                                  child: Text(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .instruction_input_form_basic_13,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Color.fromRGBO(
                                                          6, 14, 15, 1),
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                              WMSInputboxWidget(
                                                height: 100,
                                                maxLines: 5,
                                                readOnly: true,
                                                text: state
                                                    .shipCustomize['note2']
                                                    .toString(),
                                                // inputBoxCallBack: (value) {
                                                //   // 设定出荷指示值事件
                                                //   context
                                                //       .read<
                                                //           PickListDetailBloc>()
                                                //       .add(SetShipValueEvent(
                                                //           'note1', value));
                                                // },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ])),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${WMSLocalizations.i18n(context)!.delivery_note_14}:${currentParam['ship_no']}",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PickListDataSheetPage(),
            ],
          );
        },
      ),
    );
  }

  // 日期
  Widget BuildData(String text, int index) {
    return BlocBuilder<PickListDetailBloc, PickListDetailModel>(
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
                    ? state.shipCustomize['cus_rev_date'].toString()
                    : state.shipCustomize['rcv_sch_date'].toString(),
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 文本框
  Widget BuildText(String text, index) {
    return BlocBuilder<PickListDetailBloc, PickListDetailModel>(
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
                    ? state.shipCustomize['customer_name'].toString()
                    : state.shipCustomize['name'].toString(),
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 输入框
  Expanded BuildInput(String text) {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        child: CupertinoTextField(maxLines: null),
      )
    ]));
  }
}

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];

class PickListDataSheetPage extends StatefulWidget {
  const PickListDataSheetPage({super.key});
  @override
  State<PickListDataSheetPage> createState() => _PickListDataSheetPageState();
}

class _PickListDataSheetPageState extends State<PickListDataSheetPage> {
  // 明细按钮追踪
  bool _detail = false;
//  用于追踪返回按钮状态
  void upReturnButton(bool value) {
    setState(() {
      _detail = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 判断当前下标
    if (currentIndex == Config.NUMBER_ZERO) {
      // 状态变更
      setState(() {
        // 当前内容
        // currentContent = _initTableList();
      });
    }
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 30, 80),
      child: Column(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 40,
                  child: Text(WMSLocalizations.i18n(context)!.pink_list_45,
                      style: TextStyle(
                          color: Color.fromRGBO(44, 167, 176, 1),
                          fontSize: 24)),
                ),
              )
            ],
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(_detail ? 20 : 0),
                  topRight: Radius.circular(_detail ? 20 : 0),
                ),
              ),
              child: Column(
                children: [
                  DeliveryNoteTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeliveryNoteTableContent extends StatefulWidget {
  // 明细按钮点击传数据
  const DeliveryNoteTableContent({super.key});

  @override
  State<DeliveryNoteTableContent> createState() =>
      _DeliveryNoteTableContentState();
}

class _DeliveryNoteTableContentState extends State<DeliveryNoteTableContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<PickListDetailBloc, PickListDetailModel>(
      columns: [
        {
          'key': 'pick_line_no',
          'title': WMSLocalizations.i18n(context)!.pink_list_63,
        },
        {
          'key': 'warehouse_no',
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_1,
        },
        {
          'key': 'loc_cd',
          'title': WMSLocalizations.i18n(context)!.exit_input_table_title_3,
        },
        {
          'key': 'code', //商品Id
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_2,
        },
        {
          'key': 'name', //商品名
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_3,
        },
        {
          'key': 'product_price', //单价
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_4,
        },
        {
          'key': 'lock_num', //出庫数
          'title': WMSLocalizations.i18n(context)!.shipment_inspection_number,
        },
        {
          'key': 'size', //规格
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_6,
        },
        {
          'key': 'subtotal', //小计
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_7,
        },
      ],
      showCheckboxColumn: false,
      operatePopupOptions: [
        {
          'title': WMSLocalizations.i18n(context)!.delivery_note_8,
          'callback': (_, value) async {
            Map<String, dynamic> detailData = await context
                .read<PickListDetailBloc>()
                .SetDetailDataEvent(value);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeliveryDetailDialog(detailData: detailData);
                });
          },
        },
      ],
      operatePopupHeight: 100,
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
                                WMSLocalizations.i18n(context)!.pink_list_63,
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
                              text:
                                  widget.detailData['pick_line_no'].toString(),
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
                              text:
                                  widget.detailData['warehouse_no'].toString(),
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
                                    .exit_input_table_title_3,
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
                              text: widget.detailData['loc_cd'].toString(),
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
                              text: widget.detailData['code'].toString(),
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
                              text: widget.detailData['name'].toString(),
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
                              text:
                                  widget.detailData['product_price'].toString(),
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
                              text: widget.detailData['lock_num'].toString(),
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
                              text: widget.detailData['size'].toString(),
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
                              text: widget.detailData['limit_date'].toString(),
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
                              text: widget.detailData['lot_no'].toString(),
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
                              text: widget.detailData['serial_no'].toString(),
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
                          text: widget.detailData['company_note1'].toString(),
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
                          text: widget.detailData['company_note2'].toString(),
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
                          text: widget.detailData['notice_note1'].toString(),
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
                          text: widget.detailData['notice_note2'].toString(),
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
