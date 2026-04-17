import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/home/bloc/home_menu_bloc.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_bloc.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../widget/wms_scan_widget.dart';

/**
 * content：出荷検品-form表单
 * author：张博睿
 * date：2023/11/03
 */
class ShipmentInspectionForm extends StatefulWidget {
  const ShipmentInspectionForm({super.key});

  @override
  State<ShipmentInspectionForm> createState() => _ShipmentInspectionFormState();
}

class _ShipmentInspectionFormState extends State<ShipmentInspectionForm> {
  // 最後の商品検品の場合 弹窗
  _showInspectionOverDialog(int num) {
    ShipmentInspectionBloc bloc = context.read<ShipmentInspectionBloc>();
    showDialog(
      context: context,
      builder: (BuildContext contextDialog) {
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
                        // 赵士淞 - 始
                        width: MediaQuery.of(context).size.width * 0.5,
                        // 赵士淞 - 终
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
                                )),
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
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (builderContext) {
                                              return WMSScanWidget(
                                                scanCallBack: (value) {
                                                  // 查询
                                                  bloc.add(GetLocationIdEvent(
                                                      value.toString()));
                                                  bloc.add(SetLocationInfoEvent(
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
                              // Navigator.of(context).pop(); // 出荷ラベル（样式未确认 暂定） 退出
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
        builder: (bloc, state) {
      return Container(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: [
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
                            .shipment_inspection_delivery_note_barcode,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
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
                              text: state.shipmentNote,
                              // text: state.incomingBarCode.toString(),
                              borderColor: Colors.transparent,
                              inputBoxCallBack: (value) async {
                                //納品書バーコード 半角英数記号 check
                                bool checkFlag = await context
                                    .read<ShipmentInspectionBloc>()
                                    .inputCheck(context, value, '1');
                                if (checkFlag) {
                                  bool flag = await bloc
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (builderContext) {
                                      return WMSScanWidget(
                                        scanCallBack: (value) async {
                                          // 查询
                                          bool flag = await bloc
                                              .read<ShipmentInspectionBloc>()
                                              .QueryShipInformationEvent(
                                                  value, context);
                                          if (flag) {
                                            _showInspectionOverDialog(
                                                Config.NUMBER_TWO);
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
                            .shipment_inspection_ship_no,
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
                        // text: state.incomingNumber.toString(),
                        readOnly: true,
                        borderColor: Color.fromRGBO(224, 224, 224, 1),
                        backgroundColor: Colors.white,
                        inputBoxCallBack: (value) {
                          // state.shipNO = value;
                        },
                      ),
                    ),
                  ],
                ),
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
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .shipment_inspection_customer,
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
                        // text: state.supplier.toString(),
                        readOnly: true,
                        borderColor: Color.fromRGBO(224, 224, 224, 1),
                        backgroundColor: Colors.white,
                        inputBoxCallBack: (value) {
                          // state.supplier = value;
                        },
                      ),
                    ),
                  ],
                ),
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
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .shipment_inspection_delivery,
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
                        // text: state.supplier.toString(),
                        readOnly: true,
                        borderColor: Color.fromRGBO(224, 224, 224, 1),
                        backgroundColor: Colors.white,
                        inputBoxCallBack: (value) {
                          // state.supplier = value;
                        },
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
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                      .shipment_inspection_inspect),
                  // 検品
                  onPressed: () async {
                    if (state.shipNo.isNotEmpty && state.shipId.isNotEmpty) {
                      context.read<HomeMenuBloc>().add(
                            PageJumpEvent(
                              '/' +
                                  Config.PAGE_FLAG_3_13 +
                                  '/details/' +
                                  state.shipNo +
                                  '/' +
                                  state.shipId +
                                  '/' +
                                  state.index.toString() +
                                  '/' +
                                  state.pageNum.toString(),
                            ),
                          );
                    } else {
                      // 提示消息：正しいバーコードを入力をお願いします。
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!
                              .shipment_inspection_toast_1);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
