import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_bloc.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_model.dart';
import 'package:wms/widget/table/sp/wms_table_widget.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../widget/wms_scan_widget.dart';

/**
 * 内容：入庫入力-表单-sp
 * 作者：張博睿
 * 时间：2023/10/16
 */

// ignore: must_be_immutable
class GoodsReceiptInputDetails extends StatefulWidget {
  // 入荷指示ID
  String incomingNumber;
  String receiveId;
  GoodsReceiptInputDetails(
      {super.key, required this.incomingNumber, required this.receiveId});

  @override
  State<GoodsReceiptInputDetails> createState() =>
      _GoodsReceiptInputDetailsState();
}

class _GoodsReceiptInputDetailsState extends State<GoodsReceiptInputDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoodsInputBloc, GoodsInputModel>(
      builder: (bloc, state) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              //入荷予定番号 lable
              Container(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                        .goods_receipt_input_incoming_number +
                                    '：' +
                                    widget.incomingNumber,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //form表单
              Container(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    //商品ラベルのバーコード
                    FractionallySizedBox(
                      widthFactor: 1.1,
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
                                      text: state.goodsBarCode.toString(),
                                      borderColor: Colors.transparent,
                                      inputBoxCallBack: (value) {
                                        if (value.toString().isNotEmpty) {
                                          state.goodsBarCode = value;
                                          bloc.read<GoodsInputBloc>().add(
                                              QueryDtbReceiveDetailDataEvent(
                                                  value, context));
                                        } else {
                                          state.goodsBarCode = '';
                                          bloc
                                              .read<GoodsInputBloc>()
                                              .add(ClearProductInfoEvent());
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
                                                  if (value
                                                      .toString()
                                                      .isNotEmpty) {
                                                    state.goodsBarCode = value;
                                                    bloc.read<GoodsInputBloc>().add(
                                                        QueryDtbReceiveDetailDataEvent(
                                                            value, context));
                                                  } else {
                                                    state.goodsBarCode = '';
                                                    bloc.read<GoodsInputBloc>().add(
                                                        ClearProductInfoEvent());
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                        icon: Image.asset(
                                          WMSICons
                                              .SHIPMENT_INSPECTION_SCAN_ICON,
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
                    //商品コード
                    FractionallySizedBox(
                      widthFactor: 1.1,
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
                                    .goods_receipt_input_table_title_2,
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
                                text: state.goodsCode.toString(),
                                readOnly: true,
                                borderColor: Color.fromRGBO(224, 224, 224, 1),
                                backgroundColor: Colors.white,
                                inputBoxCallBack: (value) {
                                  state.goodsCode = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //商品名
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
                                    text: state.goodsName.toString(),
                                    readOnly: true,
                                    borderColor:
                                        Color.fromRGBO(224, 224, 224, 1),
                                    backgroundColor: Colors.white,
                                    inputBoxCallBack: (value) {
                                      state.goodsName = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //入库数
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
                                        .goods_receipt_input_number,
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
                                          text: state.stock.toString(),
                                          readOnly: true,
                                          borderColor: Colors.transparent,
                                          inputBoxCallBack: (value) {
                                            // bloc
                                            //     .read<GoodsInputBloc>()
                                            //     .add(SetInputNumerEvent(value));
                                          },
                                        ),
                                      ),
                                      Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                            ),
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              WMSLocalizations.i18n(context)!
                                                  .shipment_inspection_item),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //商品写真
                          Container(
                            height: 240,
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
                                  alignment: Alignment.center, //居中显示
                                  // ignore: unnecessary_null_comparison
                                  child: state.goodsImage1 != null &&
                                          state.goodsImage1 != ''
                                      ? Image.network(
                                          state.goodsImage1,
                                          height: 216,
                                        )
                                      : Image.asset(
                                          WMSICons.NO_IMAGE,
                                          height: 216,
                                        ), //无图片时，显示默认图片
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child:
                          //消费期限
                          Container(
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
                                        .pink_list_54,
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
                              child: WMSDateWidget(
                                text: state.expirationDate.toString(),
                                borderColor: Color.fromRGBO(224, 224, 224, 1),
                                backgroundColor: Colors.white,
                                dateCallBack: (value) {
                                  bloc
                                      .read<GoodsInputBloc>()
                                      .add(SetExpirationDateEvent(value));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Column(
                        children: [
                          //ロット番号
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
                                  child: WMSInputboxWidget(
                                    text: state.lotNo.toString(),
                                    borderColor:
                                        Color.fromRGBO(224, 224, 224, 1),
                                    backgroundColor: Colors.white,
                                    inputBoxCallBack: (value) {
                                      bloc
                                          .read<GoodsInputBloc>()
                                          .add(SetLotNoEvent(value));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //シリアル番号
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
                                  child: WMSInputboxWidget(
                                    text: state.serialNo.toString(),
                                    borderColor:
                                        Color.fromRGBO(224, 224, 224, 1),
                                    backgroundColor: Colors.white,
                                    inputBoxCallBack: (value) {
                                      state.serialNo = value;
                                      bloc
                                          .read<GoodsInputBloc>()
                                          .add(SetSerialNoEvent(value));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //補足情報
                          Container(
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
                                  child: WMSInputboxWidget(
                                    maxLines: 5,
                                    height: 116,
                                    text: state.supplementaryInformation
                                        .toString(),
                                    borderColor:
                                        Color.fromRGBO(224, 224, 224, 1),
                                    backgroundColor: Colors.white,
                                    inputBoxCallBack: (value) {
                                      bloc
                                          .read<GoodsInputBloc>()
                                          .add(SetNoteEvent(value));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
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
                                        .exit_input_form_title_11,
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
                                    child: WMSDropdownWidget(
                                      dropdownTitle: 'loc_cd',
                                      inputInitialValue:
                                          state.location.loc_cd.toString(),
                                      dataList1: state.locationBarCodeList,
                                      inputRadius: 4,
                                      inputBackgroundColor:
                                          Color.fromRGBO(255, 255, 255, 1),
                                      selectedCallBack: (value) {
                                        bloc.read<GoodsInputBloc>().add(
                                            SetLocationInfoEvent(
                                                "id", value['id'].toString()));
                                        bloc.read<GoodsInputBloc>().add(
                                            SetLocationInfoEvent("loc_cd",
                                                value['loc_cd'].toString()));
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
                                                  bloc
                                                      .read<GoodsInputBloc>()
                                                      .add(SetLocationInfoEvent(
                                                          "id",
                                                          value['id']
                                                              .toString()));
                                                  bloc
                                                      .read<GoodsInputBloc>()
                                                      .add(SetLocationInfoEvent(
                                                          "loc_cd",
                                                          value['loc_cd']
                                                              .toString()));
                                                },
                                              );
                                            },
                                          );
                                        },
                                        icon: Image.asset(
                                          WMSICons
                                              .SHIPMENT_INSPECTION_SCAN_ICON,
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
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.3,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // 设置按钮文本颜色
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(120, 48)), // 设置按钮宽度和高度
                      ),
                      child: Text(WMSLocalizations.i18n(context)!
                          .exit_input_form_button_execute),
                      onPressed: () async {
                        bool flag = await bloc
                            .read<GoodsInputBloc>()
                            .ExecuteButtonEvent(context);
                        if (flag) {
                          GoodsInputBloc bloc = context.read<GoodsInputBloc>();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return BlocProvider<GoodsInputBloc>.value(
                                value: bloc,
                                child: BlocBuilder<GoodsInputBloc,
                                    GoodsInputModel>(
                                  builder: (context, state) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.zero, // 设置为零边距
                                      content: Container(
                                        // 赵士淞 - 始
                                        height: 300,
                                        // 赵士淞 - 终
                                        width: 600,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.center,
                                          children: [
                                            FractionallySizedBox(
                                              widthFactor: 1,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 40),
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        44, 167, 176, 1),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      WMSLocalizations.i18n(
                                                              context)!
                                                          .goods_receipt_input_completed_title_1,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )),
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              // 赵士淞 - 始
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 0, 10, 30),
                                                child: Text(
                                                    "${WMSLocalizations.i18n(context)!.goods_receipt_input_completed_context_1} ${state.goodsName} ${WMSLocalizations.i18n(context)!.goods_receipt_input_completed_context_2}"),
                                              ),
                                              // 赵士淞 - 终
                                            ),
                                            // 赵士淞 - 始
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () async {
                                                    // 赵士淞 - 始
                                                    context
                                                        .read<GoodsInputBloc>()
                                                        .add(FormPrinterEvent(
                                                            context));
                                                    // 赵士淞 - 终
                                                  },
                                                  child: Text(WMSLocalizations
                                                          .i18n(context)!
                                                      .goods_receipt_input_label_publishing),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<
                                                                Color>(
                                                            Color.fromRGBO(
                                                                44,
                                                                167,
                                                                176,
                                                                1)), // 设置按钮背景颜色
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .white), // 设置按钮文本颜色 // 设置按钮宽度和高度
                                                  ),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () async {
                                                    await context
                                                        .read<GoodsInputBloc>()
                                                        .ConfirmButtonEvent(
                                                            context);
                                                    Navigator.of(context)
                                                        .pop(); //
                                                  },
                                                  child: Text(
                                                      WMSLocalizations.i18n(
                                                              context)!
                                                          .app_ok),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<
                                                                Color>(
                                                            Color.fromRGBO(
                                                                44,
                                                                167,
                                                                176,
                                                                1)), // 设置按钮背景颜色
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .white), // 设置按钮文本颜色 // 设置按钮宽度和高度
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // 赵士淞 - 终
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                          // 実行
                        }
                      }),
                ),
              ),
              // 表格
              // GoodsReceiptInputTable(),
              Container(
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
              Container(
                child: Column(
                  children: [
                    WMSTableWidget<GoodsInputBloc, GoodsInputModel>(
                      operatePopupHeight: 170,
                      headTitle: 'id',
                      columns: [
                        {
                          'key': 'id',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_1,
                        },
                        {
                          'key': 'product_code',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_2,
                        },
                        {
                          'key': 'product_name',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_3,
                        },
                        {
                          'key': 'product_price',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_4,
                        },
                        {
                          'key': 'store_num',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_5,
                        },
                        {
                          'key': 'size',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_6,
                        },
                        {
                          'key': 'loc_cd',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_7,
                        },
                        {
                          'key': 'count',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .goods_receipt_input_table_title_8,
                        },
                      ],
                      operatePopupOptions: [
                        {
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_form_issuance,
                          'callback': (_, value) async {
                            // 赵士淞 - 始
                            context
                                .read<GoodsInputBloc>()
                                .add(TablePrinterEvent(context, value['id']));
                            // 赵士淞 - 终
                          },
                        },
                        {
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_update,
                          'callback': (_, value) {
                            bloc
                                .read<GoodsInputBloc>()
                                .add(QueryTableDetailsEvent(context, value));
                          },
                        },
                        {
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_delete,
                          'callback': (_, value) async {
                            bool flag = await bloc
                                .read<GoodsInputBloc>()
                                .DeleteTableDetailsEvent(context, value);
                            if (flag) {
                              bloc.read<GoodsInputBloc>().add(
                                  QueryDtbReceiveDataEvent(
                                      bloc
                                          .read<GoodsInputBloc>()
                                          .state
                                          .incomingBarCode,
                                      context));
                            }
                          },
                        },
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
