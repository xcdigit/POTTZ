import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_model.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../bloc/shipment_inspection_bloc.dart';
/**
 * 内容：出荷検品-文件
 * 作者：熊草云
 * author：张博睿
 * 时间：2023/08/17
 */

class ShipmentInspectionForm extends StatefulWidget {
  const ShipmentInspectionForm({super.key});

  @override
  State<ShipmentInspectionForm> createState() => _ShipmentInspectionFormState();
}

class _ShipmentInspectionFormState extends State<ShipmentInspectionForm> {
  // 检品弹窗
  _showInspectionDialog(String name) {
    ShipmentInspectionBloc bloc = context.read<ShipmentInspectionBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ShipmentInspectionBloc>.value(
          value: bloc,
          child: BlocBuilder<ShipmentInspectionBloc, ShipmentInspectionModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .shipment_inspection_confirmation,
                contentText: WMSLocalizations.i18n(context)!
                        .incoming_inspection_product +
                    name +
                    WMSLocalizations.i18n(context)!
                        .incoming_inspection_product_inspected,
                buttonLeftFlag: false,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedRight: () async {
                  // 关闭弹窗
                  Navigator.pop(context);
                  if (state.index == state.pageNum) {
                    _showInspectionOverDialog(Config.NUMBER_ONE);
                  } else {
                    // 出荷検品弹窗-该商品检品已完成，自动跳转下一条
                    bool flag = await context
                        .read<ShipmentInspectionBloc>()
                        .SetNextMessageEvent();
                    if (flag) {
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                              .shipment_inspection_toast_5);
                    }
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
  // bool shipStart, int id, int locationId,
  //     String shipNo, int companyId, int productId

  // 最後の商品検品の場合 弹窗
  _showInspectionOverDialog(int num) {
    ShipmentInspectionBloc bloc = context.read<ShipmentInspectionBloc>();
    showDialog(
      context: context,
      builder: (contextDialog) {
        return BlocProvider<ShipmentInspectionBloc>.value(
          value: bloc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.zero, // 设置为零边距
            content: Container(
              height: 400,
              width: 700,
              child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 40),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(44, 167, 176, 1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .shipment_inspection_completion_title,
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(60, 0, 0, 40),
                      child: Text(WMSLocalizations.i18n(context)!
                          .incoming_inspection_all_product),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 400,
                        margin: EdgeInsets.fromLTRB(60, 20, 0, 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 24,
                              child: Row(
                                children: [
                                  Text(
                                    WMSLocalizations.i18n(context)!
                                        .shipment_inspection_oricon_barcode,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
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
                                      inputInitialValue: bloc
                                          .state.oriconBarcode.loc_cd
                                          .toString(),
                                      dataList1: bloc.state.locationBarCodeList,
                                      inputRadius: 4,
                                      inputBackgroundColor:
                                          Color.fromRGBO(255, 255, 255, 1),
                                      selectedCallBack: (value) async {
                                        String locCd =
                                            (value is String || value == '')
                                                ? value
                                                : value['loc_cd'].toString();
                                        // 半角英数記号 check
                                        bool checkFlag = await context
                                            .read<ShipmentInspectionBloc>()
                                            .inputCheck(
                                                contextDialog, locCd, '3');
                                        if (checkFlag) {
                                          bloc.add(SetLocationInfoEvent(
                                              "id",
                                              value['id'].toString(),
                                              Config.NUMBER_TWO.toString()));
                                          bloc.add(SetLocationInfoEvent(
                                              "loc_cd",
                                              value['loc_cd'].toString(),
                                              Config.NUMBER_TWO.toString()));
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
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // 设置按钮文本颜色
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(120, 40)), // 设置按钮宽度和高度
                          ),
                          child: Text(WMSLocalizations.i18n(context)!
                              .shipment_inspection_shipping_label),
                          onPressed: () {
                            //校验是否输入
                            if (bloc.state.oriconBarcode.id == null) {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                          .shipment_inspection_oricon_barcode +
                                      WMSLocalizations.i18n(context)!
                                          .can_not_null_text);
                            } else {
                              // 赵士淞 - 始
                              bloc.add(PrinterEvent(context));
                              // 赵士淞 - 终
                            }
                          },
                        ),
                        SizedBox(width: 40),
                        Visibility(
                          visible: num == Config.NUMBER_ONE,
                          child: OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white), // 设置按钮文本颜色
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(120, 40)), // 设置按钮宽度和高度
                            ),
                            child: Text(WMSLocalizations.i18n(context)!
                                .shipment_inspection_completion),
                            onPressed: () async {
                              bool flag = await bloc.executeEndEvent(context);
                              if (flag) {
                                bloc.add(ClearInformationEvent());
                                Navigator.of(contextDialog).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentInspectionBloc, ShipmentInspectionModel>(
        builder: (context, state) {
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
                                    .shipment_inspection_delivery_note_barcode,
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
                          )),
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
                                text: state.shipmentNote,
                                borderColor: Colors.transparent,
                                inputBoxCallBack: (value) async {
                                  //納品書バーコード 半角英数記号 check
                                  bool checkFlag = await context
                                      .read<ShipmentInspectionBloc>()
                                      .inputCheck(context, value, '1');
                                  if (checkFlag) {
                                    bool flag = await context
                                        .read<ShipmentInspectionBloc>()
                                        .QueryShipInformationEvent(
                                            value, context);
                                    if (flag) {
                                      _showInspectionOverDialog(
                                          Config.NUMBER_TWO);
                                    }
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
                          WMSLocalizations.i18n(context)!.delivery_note_14,
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
                          text: state.shipNo,
                          borderColor: Color.fromRGBO(224, 224, 224, 1),
                          readOnly: true,
                        ),
                      )
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
                          WMSLocalizations.i18n(context)!.delivery_note_15,
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
                          text: state.customer,
                          borderColor: Color.fromRGBO(224, 224, 224, 1),
                          readOnly: true,
                        ),
                      )
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
                          WMSLocalizations.i18n(context)!.delivery_note_17,
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
                          text: state.delivery,
                          borderColor: Color.fromRGBO(224, 224, 224, 1),
                          readOnly: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(),
              Align(
                alignment: Alignment.centerRight,
                child: Text("${state.index}/${state.pageNum}"),
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
                              .shipment_inspection_location,
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
                          // ignore: unnecessary_null_comparison
                          text: state.location != null
                              ? state.location.loc_cd
                              : '',
                          borderColor: Color.fromRGBO(224, 224, 224, 1),
                          readOnly: true,
                        ),
                      )
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
                              .transfer_inquiry_note_2,
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
                                      .delivery_note_20,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ))),
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
                                    text: state.storeOutCount,
                                    readOnly: true,
                                    borderColor: Colors.transparent,
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
                          )
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
                      Visibility(
                        visible:
                            // ignore: unnecessary_null_comparison
                            state.prpductImage1 != null &&
                                state.prpductImage1 != '',
                        child: Image.network(
                          state.prpductImage1,
                          width: 136,
                          height: 136,
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
                          )),
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
                                text: state.productBarCode,
                                borderColor: Colors.transparent,
                                inputBoxCallBack: (value) async {
                                  if (state.shipmentNote.isNotEmpty) {
                                    // 半角英数記号 check
                                    bool checkFlag = await context
                                        .read<ShipmentInspectionBloc>()
                                        .inputCheck(context, value, '2');
                                    if (checkFlag) {
                                      bool flag = await context
                                          .read<ShipmentInspectionBloc>()
                                          .CheckProductBarCodeEvent(value);
                                      if (!flag) {
                                        // 提示消息：入力の値が正しくありません
                                        WMSCommonBlocUtils.tipTextToast(
                                            WMSLocalizations.i18n(context)!
                                                .shipment_inspection_toast_3);
                                      }
                                    }
                                  } else {
                                    // 提示消息：正しい納入書コードの入力をお願いします
                                    WMSCommonBlocUtils.tipTextToast(
                                        WMSLocalizations.i18n(context)!
                                            .shipment_inspection_toast_1);
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .shipment_inspection_sum,
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
                                  text: state.numCount,
                                  borderColor: Colors.transparent,
                                  inputBoxCallBack: (value) {
                                    context
                                        .read<ShipmentInspectionBloc>()
                                        .add(SetNumCountEvent(value, context));
                                  }),
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
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(44, 167, 176, 1),
                    ),
                  ),
                  child: Text(WMSLocalizations.i18n(context)!
                      .shipment_inspection_inspection),
                  onPressed: () async {
                    int num = await context
                        .read<ShipmentInspectionBloc>()
                        .executeEvent();
                    if (num == 1) {
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                                  .shipment_inspection_delivery_note_barcode +
                              WMSLocalizations.i18n(context)!
                                  .can_not_null_text);
                    } else if (num == 2) {
                      _showInspectionOverDialog(Config.NUMBER_TWO);
                    } else if (num == 3) {
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                              .shipment_inspection_toast_2);
                    } else if (num == 4) {
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                                  .shipment_inspection_product_barcodes +
                              WMSLocalizations.i18n(context)!
                                  .can_not_null_text);
                    } else if (num == 5) {
                      //商品ラベルのバーコード  合計数 为空报错
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                                  .shipment_inspection_sum +
                              WMSLocalizations.i18n(context)!
                                  .can_not_null_text);
                    } else if (num == 6) {
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                              .shipment_inspection_toast_4);
                    } else if (num == 7) {
                      if (state.index == state.pageNum) {
                        _showInspectionOverDialog(Config.NUMBER_ONE);
                      } else {
                        // 出荷検品弹窗-该商品检品已完成，自动跳转下一条
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .shipment_inspection_toast_5);
                        context
                            .read<ShipmentInspectionBloc>()
                            .SetNextMessageEvent();
                      }
                    } else if (num == 8) {
                      _showInspectionDialog(state
                          .productformation[state.index - 1]['product_name']);
                    } else {
                      print('执行失败');
                    }
                  },
                ),
              ),
            ]),
      );
    });
  }
}
