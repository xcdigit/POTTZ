// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_bloc.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_model.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import 'package:wms/widget/wms_scan_widget.dart';

import '../../../../../common/utils/check_utils.dart';

/**
 * 内容：在庫移動入力 -文件
 * 作者：張博睿
 * 时间：2023/11/23
 */

class GoodsTransferEntryForm extends StatefulWidget {
  const GoodsTransferEntryForm({super.key});

  @override
  State<GoodsTransferEntryForm> createState() => _GoodsTransferEntryFormState();
}

class _GoodsTransferEntryFormState extends State<GoodsTransferEntryForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoodsTransferEntryBloc, GoodsTransferEntryModel>(
        builder: (bloc, state) {
      return Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .goods_transfer_entry_location_barcode,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(255, 0, 0, 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(224, 224, 224, 1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: WMSInputboxWidget(
                                    text: state.locationCodeFrom.toString(),
                                    borderColor: Colors.transparent,
                                    inputBoxCallBack: (value) {
                                      state.locationCodeFrom = value;
                                      if (value != '') {
                                        bloc.read<GoodsTransferEntryBloc>().add(
                                            QueryProductLocationMessageEvent(
                                                bloc,
                                                value,
                                                Config.NUMBER_ONE));
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  width: 48,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (builderContext) {
                                            return WMSScanWidget(
                                              scanCallBack: (value) {
                                                if (value != '') {
                                                  state.locationCodeFrom =
                                                      value;
                                                  bloc
                                                      .read<
                                                          GoodsTransferEntryBloc>()
                                                      .add(
                                                          QueryProductLocationMessageEvent(
                                                              bloc,
                                                              value,
                                                              Config
                                                                  .NUMBER_ONE));
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Image.asset(
                                        WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                                        height: 44,
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
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .shipment_inspection_product_barcodes,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(255, 0, 0, 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(224, 224, 224, 1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: WMSInputboxWidget(
                                    text: state.productCode.toString(),
                                    borderColor: Colors.transparent,
                                    inputBoxCallBack: (value) {
                                      state.productCode = value;
                                      if (value != '') {
                                        bloc.read<GoodsTransferEntryBloc>().add(
                                            QueryProductLocationGoodsMessageEvent(
                                                bloc,
                                                value,
                                                Config.NUMBER_ZERO));
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  width: 48,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (builderContext) {
                                            return WMSScanWidget(
                                              scanCallBack: (value) {
                                                if (value != '') {
                                                  state.productCode = value;
                                                  bloc
                                                      .read<
                                                          GoodsTransferEntryBloc>()
                                                      .add(QueryProductLocationGoodsMessageEvent(
                                                          bloc,
                                                          value,
                                                          Config.NUMBER_ZERO));
                                                }
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Image.asset(
                                        WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                                        height: 44,
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
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_20,
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
                                child: WMSInputboxWidget(
                                  text: state.productName,
                                  borderColor: Color.fromRGBO(224, 224, 224, 1),
                                  readOnly: true,
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
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .shipment_inspection_product_id,
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
                            child: WMSInputboxWidget(
                              text: state.productCode,
                              borderColor: Color.fromRGBO(224, 224, 224, 1),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 250,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .shipment_inspection_product_photos,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            width: 450,
                            child:
                                state.goodImage != null && state.goodImage != ''
                                    ? Image.network(
                                        state.goodImage,
                                        width: 136,
                                        height: 136,
                                      )
                                    : Image.asset(
                                        WMSICons.NO_IMAGE,
                                        width: 136,
                                        height: 136,
                                      ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
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
                            child: WMSDateWidget(
                              text: state.expirationDate,
                              borderColor: Color.fromRGBO(224, 224, 224, 1),
                              readOnly: true,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .goods_receipt_input_lot_no,
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
                            child: WMSInputboxWidget(
                              text: state.lotNo,
                              borderColor: Color.fromRGBO(224, 224, 224, 1),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .goods_receipt_input_serial_no,
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
                            child: WMSInputboxWidget(
                              text: state.serialNo,
                              borderColor: Color.fromRGBO(224, 224, 224, 1),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .goods_receipt_input_information,
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
                            child: WMSInputboxWidget(
                              text: state.supplementaryInformation,
                              borderColor: Color.fromRGBO(224, 224, 224, 1),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .goods_transfer_entry_stock_count,
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
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(251, 251, 251, 1),
                              border: Border.all(
                                color: Color.fromRGBO(224, 224, 224, 1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: WMSInputboxWidget(
                                    text: state.stockCount.toString(),
                                    borderColor: Colors.transparent,
                                    readOnly: true,
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1),
                                      ),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(WMSLocalizations.i18n(context)!
                                        .shipment_inspection_item),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .goods_transfer_entry_locke_number,
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
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(251, 251, 251, 1),
                              border: Border.all(
                                color: Color.fromRGBO(224, 224, 224, 1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: WMSInputboxWidget(
                                    text: state.lockCount.toString(),
                                    borderColor: Colors.transparent,
                                    readOnly: true,
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Color.fromRGBO(224, 224, 224, 1),
                                      ),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(WMSLocalizations.i18n(context)!
                                        .shipment_inspection_item),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: SizedBox(height: 20),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(44, 167, 176, 1),
                              ), // 设置按钮背景颜色
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white), // 设置按钮文本颜色
                              minimumSize: MaterialStateProperty.all<Size>(
                                Size(120, 48),
                              ), // 设置按钮宽度和高度
                            ),
                            child: Text(WMSLocalizations.i18n(context)!
                                .goods_transfer_entry_button_move),
                            onPressed: () {
                              if (state.locationCodeFrom != '' &&
                                  state.locationCodeFrom != null &&
                                  state.productCode != '' &&
                                  state.productCode != null) {
                                if (CheckUtils.check_Half_Alphanumeric_6_50(
                                    state.productCode)) {
                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                              .i18n(context)!
                                          .shipment_inspection_product_barcodes +
                                      WMSLocalizations.i18n(context)!
                                          .text_must_six_number_letter);
                                  return;
                                }
                                GoRouter.of(context)
                                    .push(
                                  '/' +
                                      Config.PAGE_FLAG_4_13 +
                                      '/detail/' +
                                      state.locationIdFrom.toString() +
                                      '/' +
                                      state.locationCodeFrom.toString() +
                                      '/' +
                                      state.productId.toString() +
                                      '/' +
                                      state.productCode.toString(),
                                )
                                    .then((value) {
                                  if (value == 'refresh return') {
                                    // 初始化事件
                                    context
                                        .read<GoodsTransferEntryBloc>()
                                        .add(ClearFormDataEvent());
                                  }
                                });
                              } else {
                                if (state.locationCodeFrom == '' ||
                                    state.locationCodeFrom == null) {
                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                              .i18n(context)!
                                          .goods_transfer_entry_location_barcode +
                                      WMSLocalizations.i18n(context)!
                                          .can_not_null_text);
                                }
                                if (state.productCode == '' ||
                                    state.productCode == null) {
                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                              .i18n(context)!
                                          .goods_transfer_entry_location_barcode +
                                      WMSLocalizations.i18n(context)!
                                          .can_not_null_text);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: SizedBox(height: 60),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
