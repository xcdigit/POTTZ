// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_bloc.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_model.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../widget/wms_scan_widget.dart';

/**
 * content：出荷検品-details
 * author：张博睿
 * date：2023/11/09
 */
class ShipmentInspectionDetails extends StatefulWidget {
  String shipNo;
  String shipId;
  String index;
  String pageNum;
  ShipmentInspectionDetails({
    super.key,
    required this.shipNo,
    required this.shipId,
    required this.index,
    required this.pageNum,
  });

  @override
  State<ShipmentInspectionDetails> createState() =>
      _ShipmentInspectionDetailsState();
}

class _ShipmentInspectionDetailsState extends State<ShipmentInspectionDetails> {
  bool loadFlag = false;
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

  // 最後の商品検品の場合 弹窗
  _showInspectionOverDialog(int num) {
    ShipmentInspectionBloc bloc = context.read<ShipmentInspectionBloc>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(WMSLocalizations.i18n(context)!
                            .incoming_inspection_all_product),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 80,
                            width: 250,
                            // margin: EdgeInsets.fromLTRB(60, 20, 0, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .shipment_inspection_oricon_barcode,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
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
                                          dataList1:
                                              bloc.state.locationBarCodeList,
                                          inputRadius: 4,
                                          inputWidth: 150,
                                          inputBackgroundColor:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          selectedCallBack: (value) {
                                            bloc.add(SetLocationInfoEvent(
                                                "id",
                                                value['id'].toString(),
                                                Config.NUMBER_TWO.toString()));
                                            bloc.add(SetLocationInfoEvent(
                                                "loc_cd",
                                                value['loc_cd'].toString(),
                                                Config.NUMBER_TWO.toString()));
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
                                                      // 查询
                                                      bloc.add(
                                                          GetLocationIdEvent(
                                                              value
                                                                  .toString()));
                                                      bloc.add(
                                                          SetLocationInfoEvent(
                                                              "loc_cd",
                                                              value.toString(),
                                                              Config.NUMBER_TWO
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
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(
                                            44, 167, 176, 1)), // 设置按钮背景颜色
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // 设置按钮文本颜色
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(100, 40)), // 设置按钮宽度和高度
                              ),
                              child: Text(WMSLocalizations.i18n(context)!
                                  .shipment_inspection_shipping_label),
                              onPressed: () {
                                //校验是否输入
                                if (bloc.state.oriconBarcode.id == null) {
                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                              .i18n(context)!
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
                            Visibility(
                              visible: num == Config.NUMBER_ONE,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(
                                              44, 167, 176, 1)), // 设置按钮背景颜色
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white), // 设置按钮文本颜色
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(100, 40)), // 设置按钮宽度和高度
                                ),
                                child: Text(WMSLocalizations.i18n(context)!
                                    .shipment_inspection_completion),
                                onPressed: () async {
                                  bool flag =
                                      await bloc.executeEndEvent(context);
                                  if (flag) {
                                    bloc.add(ClearInformationEvent());
                                    Navigator.of(context).pop();
                                  }
                                },
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
        );
      },
    );
  }

  QueryShipInformationEvent(BuildContext bloc) async {
    bool flag = await bloc
        .read<ShipmentInspectionBloc>()
        .QueryShipInformationEvent(widget.shipNo, bloc);
    if (flag) {
      _showInspectionOverDialog(Config.NUMBER_TWO);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentInspectionBloc, ShipmentInspectionModel>(
      builder: (bloc, state) {
        if (!loadFlag) {
          QueryShipInformationEvent(bloc);
          loadFlag = true;
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                        .shipment_inspection_ship_no +
                                    '：' +
                                    widget.shipNo,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                        .shipment_inspection_progress +
                                    '：' +
                                    state.index.toString() +
                                    '/' +
                                    state.pageNum.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
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
                widthFactor: 0.9,
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
                          inputBoxCallBack: (value) {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
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
                widthFactor: 0.9,
                child: Container(
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
                          text: state.productName,
                          borderColor: Color.fromRGBO(224, 224, 224, 1),
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
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
              ),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
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
                      Visibility(
                        visible:
                            // ignore: unnecessary_null_comparison
                            state.prpductImage1 == null &&
                                state.prpductImage1 == '',
                        child: Image.asset(WMSICons.NO_IMAGE,
                            width: 136, height: 136),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
              SizedBox(height: 40),
              FractionallySizedBox(
                widthFactor: 0.9,
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
                              .shipment_inspection_product_barcodes,
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
                                      bool flag = await bloc
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
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (builderContext) {
                                        return WMSScanWidget(
                                          scanCallBack: (value) async {
                                            // 查询
                                            if (state.shipmentNote.isNotEmpty) {
                                              bool flag = await bloc
                                                  .read<
                                                      ShipmentInspectionBloc>()
                                                  .CheckProductBarCodeEvent(
                                                      value);
                                              if (!flag) {
                                                // 提示消息：入力の値が正しくありません
                                                WMSCommonBlocUtils.tipTextToast(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .shipment_inspection_toast_3);
                                              }
                                            } else {
                                              // 提示消息：正しい納入書コードの入力をお願いします
                                              WMSCommonBlocUtils.tipTextToast(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .shipment_inspection_toast_1);
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
                widthFactor: 0.9,
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
                              .shipment_inspection_sum,
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
                                    bloc
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
              FractionallySizedBox(
                widthFactor: 0.3,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 150),
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
                        .shipment_inspection_inspection),
                    // 検品
                    onPressed: () async {
                      int num = await bloc
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
                          bloc
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
              ),
              SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}
