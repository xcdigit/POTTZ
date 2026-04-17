import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/pick_list_detail_bloc.dart';
import '../bloc/pick_list_detail_model.dart';

/**
 * 内容：ピッキングリスト(シングル)
 * 作者：王光顺
 * 时间：2023/08/17
 * 作者：赵士淞
 * 时间：2023/11/09
 */

// 定义接受对象
class PickListPackingSlipPage extends StatefulWidget {
  const PickListPackingSlipPage({Key? key}) : super(key: key);

  @override
  State<PickListPackingSlipPage> createState() =>
      _PickListPackingSlipPageState();
}

Map<String, dynamic> currentParam = {};

class _PickListPackingSlipPageState extends State<PickListPackingSlipPage> {
  // 初始化isHovered为false
  bool isHovered = false;

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
          return Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              child: ListView(
                children: [
                  Text(
                    "${WMSLocalizations.i18n(context)!.delivery_note_14}:${currentParam['ship_no']}",
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BuildData(
                    WMSLocalizations.i18n(context)!.delivery_note_16,
                    0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BuildData(
                    WMSLocalizations.i18n(context)!.delivery_note_18,
                    2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BuildText(
                    WMSLocalizations.i18n(context)!.delivery_note_15,
                    0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BuildText(
                    WMSLocalizations.i18n(context)!.delivery_note_17,
                    1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(WMSLocalizations.i18n(context)!.delivery_note_27),
                  SizedBox(
                    height: 5,
                  ),
                  WMSInputboxWidget(
                    height: 100,
                    maxLines: 5,
                    readOnly: true,
                    text: state.shipCustomize['note1'].toString(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_13),
                  SizedBox(
                    height: 5,
                  ),
                  WMSInputboxWidget(
                    height: 100,
                    maxLines: 5,
                    readOnly: true,
                    text: state.shipCustomize['note2'].toString(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    WMSLocalizations.i18n(context)!
                        .display_instruction_detail_line,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  PickListDataSheetPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // 日期
  Widget BuildData(String text, int index) {
    return BlocBuilder<PickListDetailBloc, PickListDetailModel>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            SizedBox(
              height: 5,
            ),
            WMSInputboxWidget(
              text: index == 0
                  ? state.shipCustomize['cus_rev_date'].toString()
                  : state.shipCustomize['rcv_sch_date'].toString(),
              readOnly: true,
            ),
          ],
        );
      },
    );
  }

  // 文本框
  Widget BuildText(String text, index) {
    return BlocBuilder<PickListDetailBloc, PickListDetailModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              WMSInputboxWidget(
                text: index == 0
                    ? state.shipCustomize['customer_name'].toString()
                    : state.shipCustomize['name'].toString(),
                readOnly: true,
              ),
            ],
          ),
        );
      },
    );
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
  // 用于追踪返回按钮状态
  void upReturnButton(bool value) {
    setState(() {
      _detail = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: [
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
          'width': 1.0,
          'title': WMSLocalizations.i18n(context)!.pink_list_63,
        },
        {
          'key': 'warehouse_no',
          'width': 1.0,
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_1,
        },
        {
          'key': 'loc_cd',
          'width': 1.0,
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_1,
        },
        {
          'key': 'code',
          'width': 1.0,
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_2,
        },
        {
          'key': 'name',
          'width': 1.0,
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_3,
        },
        {
          'key': 'product_price',
          'width': 0.5,
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_4,
        },
        {
          'key': 'lock_num',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.shipment_inspection_number,
        },
        {
          'key': 'size',
          'width': 0.5,
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_shipment_details_6,
        },
        {
          'key': 'subtotal',
          'width': 0.5,
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
              },
            );
          },
        },
      ],
      operatePopupHeight: 100,
    );
  }
}

// 納品明細一覧ダイアログ 弹窗
class DeliveryDetailDialog extends StatefulWidget {
  //
  final Map detailData;

  const DeliveryDetailDialog({super.key, required this.detailData});

  @override
  State<DeliveryDetailDialog> createState() => _DeliveryDetailDialogState();
}

class _DeliveryDetailDialogState extends State<DeliveryDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            WMSLocalizations.i18n(context)!.delivery_note_8,
            style: TextStyle(
              color: Color.fromRGBO(44, 167, 176, 1),
              fontSize: 24,
            ),
          ),
          Container(
            height: 36,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(44, 167, 176, 1),
              ),
              child: Text(
                WMSLocalizations.i18n(context)!.delivery_note_close,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                // 关闭对话框
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * .8,
        child: ListView(
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
            Container(
              height: 48,
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['pick_line_no'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['warehouse_no'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              height: 48,
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['loc_cd'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              height: 48,
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['code'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              height: 48,
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['name'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['product_price'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
            Container(
              height: 24,
              child: Text(
                WMSLocalizations.i18n(context)!.shipment_inspection_number,
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['lock_num'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['size'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['limit_date'] == null
                      ? ''
                      : widget.detailData['limit_date'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['lot_no'] == null
                      ? ''
                      : widget.detailData['lot_no'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['serial_no'] == null
                      ? ''
                      : widget.detailData['serial_no'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
            ),
            Container(
              height: 24,
              child: Text(
                WMSLocalizations.i18n(context)!.instruction_input_form_detail_5,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: widget.detailData['image1_effective'] != null &&
                      widget.detailData['image1_effective'] != ''
                  ? Image.network(
                      widget.detailData['image1_effective'],
                      width: 136,
                      height: 180,
                    )
                  : Image.asset(
                      WMSICons.NO_IMAGE,
                      width: 136,
                      height: 180,
                    ),
            ),
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
            Container(
              margin: EdgeInsets.only(
                bottom: 10,
              ),
              child: widget.detailData['image2_effective'].toString() == '' ||
                      widget.detailData['image2_effective'] == null
                  ? Image.asset(
                      WMSICons.NO_IMAGE,
                      width: 136,
                      height: 180,
                    )
                  : Image.network(
                      (widget.detailData['image2_effective'].toString()),
                      width: 136,
                      height: 180,
                    ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['company_note1'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['company_note2'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['notice_note1'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
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
              padding: EdgeInsets.only(
                left: 14,
                right: 14,
              ),
              margin: EdgeInsets.only(
                bottom: 10,
              ),
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
                  widget.detailData['notice_note2'].toString(),
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
    );
  }
}
