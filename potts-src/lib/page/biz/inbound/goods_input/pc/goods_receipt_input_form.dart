import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_bloc.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_model.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

/**
 * 内容：入庫入力-文件
 * 作者：熊草云
 * 时间：2023/08/23
 */

// 全局主键-下拉共通
GlobalKey<WMSDropdownWidgetState> _dropdownWidgetKey1 = new GlobalKey();

class GoodsReceiptInputForm extends StatefulWidget {
  const GoodsReceiptInputForm({super.key});

  @override
  State<GoodsReceiptInputForm> createState() => _GoodsReceiptInputFormState();
}

class _GoodsReceiptInputFormState extends State<GoodsReceiptInputForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoodsInputBloc, GoodsInputModel>(builder: (bloc, state) {
      return Container(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 0.4,
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
                                .goods_receipt_input_list_bar_code,
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
                              text: state.incomingBarCode.toString(),
                              borderColor: Colors.transparent,
                              inputBoxCallBack: (value) {
                                bloc.read<GoodsInputBloc>().add(
                                    QueryDtbReceiveDataEvent(value, context));
                              },
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 48,
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: () {},
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
              widthFactor: 0.4,
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
                            .goods_receipt_input_incoming_number,
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
                        text: state.incomingNumber.toString(),
                        readOnly: true,
                        borderColor: Color.fromRGBO(224, 224, 224, 1),
                        backgroundColor: Colors.white,
                        inputBoxCallBack: (value) {
                          state.incomingNumber = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
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
                            .goods_receipt_input_supplier,
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
                        text: state.supplier.toString(),
                        readOnly: true,
                        borderColor: Color.fromRGBO(224, 224, 224, 1),
                        backgroundColor: Colors.white,
                        inputBoxCallBack: (value) {
                          state.supplier = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 40),
            FractionallySizedBox(
              widthFactor: 0.4,
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
                                onPressed: () {},
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
              widthFactor: 0.4,
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
              widthFactor: 0.4,
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
                            WMSLocalizations.i18n(context)!.delivery_note_20,
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
                            borderColor: Color.fromRGBO(224, 224, 224, 1),
                            backgroundColor: Colors.white,
                            inputBoxCallBack: (value) {
                              state.goodsName = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                    context
                                        .read<GoodsInputBloc>()
                                        .add(SetInputNumerEvent(value));
                                  },
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
                                WMSLocalizations.i18n(context)!.pink_list_54,
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
                              context
                                  .read<GoodsInputBloc>()
                                  .add(SetExpirationDateEvent(value));
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
              widthFactor: 0.4,
              child: Container(
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
                      height: 216,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // ignore: unnecessary_null_comparison
                        children: (state.goodsImage1 != null &&
                                    state.goodsImage1 != '') ||
                                // ignore: unnecessary_null_comparison
                                (state.goodsImage2 != null &&
                                    state.goodsImage2 != '')
                            ? [
                                Visibility(
                                  visible:
                                      // ignore: unnecessary_null_comparison
                                      state.goodsImage1 != null &&
                                          state.goodsImage1 != '',
                                  child: Image.network(
                                    state.goodsImage1,
                                    height: 216,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      // ignore: unnecessary_null_comparison
                                      state.goodsImage2 != null &&
                                          state.goodsImage2 != '',
                                  child: Image.network(
                                    state.goodsImage2,
                                    height: 216,
                                  ),
                                ),
                              ]
                            : [
                                Image.asset(
                                  WMSICons.NO_IMAGE,
                                  height: 216,
                                )
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
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
                            borderColor: Color.fromRGBO(224, 224, 224, 1),
                            backgroundColor: Colors.white,
                            inputBoxCallBack: (value) {
                              context
                                  .read<GoodsInputBloc>()
                                  .add(SetLotNoEvent(value));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            text: state.supplementaryInformation.toString(),
                            borderColor: Color.fromRGBO(224, 224, 224, 1),
                            backgroundColor: Colors.white,
                            maxLines: 5,
                            height: 136,
                            inputBoxCallBack: (value) {
                              context
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
              widthFactor: 0.4,
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
                            borderColor: Color.fromRGBO(224, 224, 224, 1),
                            backgroundColor: Colors.white,
                            inputBoxCallBack: (value) {
                              state.serialNo = value;
                              context
                                  .read<GoodsInputBloc>()
                                  .add(SetSerialNoEvent(value));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(height: 40),
            FractionallySizedBox(
              widthFactor: 0.4,
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
                              key: _dropdownWidgetKey1,
                              inputRadius: 4,
                              inputBackgroundColor:
                                  Color.fromRGBO(255, 255, 255, 1),
                              selectedCallBack: (value) {
                                context.read<GoodsInputBloc>().add(
                                    SetLocationInfoEvent(
                                        "id", value['id'].toString()));
                                context.read<GoodsInputBloc>().add(
                                    SetLocationInfoEvent(
                                        "loc_cd", value['loc_cd'].toString()));
                              },
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 48,
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: () {},
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
              widthFactor: 0.4,
              child: Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Column(
                      children: [
                        SizedBox(height: 24),
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
                              .exit_input_form_button_execute),
                          onPressed: () async {
                            bool flag = await context
                                .read<GoodsInputBloc>()
                                .ExecuteButtonEvent(context);
                            if (flag) {
                              GoodsInputBloc bloc =
                                  context.read<GoodsInputBloc>();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BlocProvider<GoodsInputBloc>.value(
                                    value: bloc,
                                    child: BlocBuilder<GoodsInputBloc,
                                        GoodsInputModel>(
                                      builder: (context, state) {
                                        return AlertDialog(
                                          contentPadding:
                                              EdgeInsets.zero, // 设置为零边距
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
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          WMSLocalizations.i18n(
                                                                  context)!
                                                              .goods_receipt_input_completed_title_1,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      "${WMSLocalizations.i18n(context)!.goods_receipt_input_completed_context_1} ${state.goodsName} ${WMSLocalizations.i18n(context)!.goods_receipt_input_completed_context_2}"),
                                                ),
                                                SizedBox(height: 60),
                                                // 赵士淞 - 始
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    OutlinedButton(
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
                                                                    .white), // 设置按钮文本颜色
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all<Size>(Size(
                                                                    120,
                                                                    48)), // 设置按钮宽度和高度
                                                      ),
                                                      child: Text(WMSLocalizations
                                                              .i18n(context)!
                                                          .goods_receipt_input_label_publishing),
                                                      onPressed: () {
                                                        // 赵士淞 - 始
                                                        context
                                                            .read<
                                                                GoodsInputBloc>()
                                                            .add(
                                                                FormPrinterEvent(
                                                                    context));
                                                        // 赵士淞 - 终
                                                      },
                                                    ),
                                                    OutlinedButton(
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
                                                                    .white), // 设置按钮文本颜色
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all<Size>(Size(
                                                                    120,
                                                                    48)), // 设置按钮宽度和高度
                                                      ),
                                                      child: Text(
                                                          WMSLocalizations.i18n(
                                                                  context)!
                                                              .app_ok),
                                                      onPressed: () async {
                                                        await context
                                                            .read<
                                                                GoodsInputBloc>()
                                                            .ConfirmButtonEvent(
                                                                context);
                                                        Navigator.of(context)
                                                            .pop(); //
                                                      },
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
                          },
                        ),
                      ],
                    )
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
