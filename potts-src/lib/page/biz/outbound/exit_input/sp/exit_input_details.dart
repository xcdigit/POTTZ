import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_bloc.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/widget/table/sp/wms_table_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../common/config/config.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_scan_widget.dart';

/**
 * 内容：入庫入力-表单-sp
 * 作者：張博睿
 * 时间：2023/10/16
 */

// ignore: must_be_immutable
class ExitInputDetails extends StatefulWidget {
  // 入荷指示ID
  String shipCodeValue;
  String shipId;
  ExitInputDetails(
      {super.key, required this.shipCodeValue, required this.shipId});

  @override
  State<ExitInputDetails> createState() => _ExitInputDetailsState();
}

class _ExitInputDetailsState extends State<ExitInputDetails> {
  @override
  Widget build(BuildContext context) {
    // 赵士淞 - 始
    // 显示打印弹窗
    _showPrinterDialog(buttonItemList) {
      // 选中下标
      int chooseIndex = Config.NUMBER_NEGATIVE;

      ExitInputBloc bloc = context.read<ExitInputBloc>();
      showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<ExitInputBloc>.value(
            value: bloc,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 24,
                    ),
                  ),
                  Container(
                    height: 36,
                    child: Row(
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(44, 167, 176, 1),
                            ),
                            minimumSize: MaterialStatePropertyAll(
                              Size(90, 36),
                            ),
                          ),
                          onPressed: () {
                            // 打印事件
                            bloc.add(PrinterEvent(context, chooseIndex));
                          },
                          child: Text(
                            WMSLocalizations.i18n(context)!.app_ok,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(255, 255, 255, 1),
                            ),
                            minimumSize: MaterialStatePropertyAll(
                              Size(90, 36),
                            ),
                          ),
                          onPressed: () {
                            // 关闭弹窗
                            Navigator.pop(context);
                          },
                          child: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_close,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(44, 167, 176, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: Container(
                width: 500,
                child: WMSDropdownWidget(
                  dataList1: buttonItemList,
                  inputRadius: 4,
                  inputSuffixIcon: Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  inputFontSize: 14,
                  dropdownRadius: 4,
                  dropdownKey: 'index',
                  dropdownTitle: 'title',
                  selectedCallBack: (value) {
                    // 判断数值
                    if (value == '') {
                      // 参数赋值
                      this.setState(() {
                        // 选中下标
                        chooseIndex = Config.NUMBER_NEGATIVE;
                      });
                    } else {
                      // 参数赋值
                      this.setState(() {
                        // 选中下标
                        chooseIndex = value['index'];
                      });
                    }
                  },
                ),
              ),
            ),
          );
        },
      );
    }
    // 赵士淞 - 终

    return BlocBuilder<ExitInputBloc, ExitInputModel>(
      builder: (bloc, state) {
        // bloc
        //     .read<ExitInputBloc>()
        //     .add(SetSpDataEvent(widget.receiveId, widget.total));
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              // GoodsReceiptInputTitle(),
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
                                        .exit_input_form_title_2 +
                                    '：' +
                                    widget.shipCodeValue,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
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
              Container(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
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
                                        .exit_input_form_title_5,
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
                                      text: state.detailsCodeValue.toString(),
                                      borderColor: Colors.transparent,
                                      inputBoxCallBack: (value) {
                                        state.detailsCodeValue =
                                            value.toString();
                                        bloc.read<ExitInputBloc>().add(
                                              QueryDetailsinformation(
                                                context,
                                                state.detailsCodeValue,
                                              ),
                                            );
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
                                                  // 赋值
                                                  state.detailsCodeValue =
                                                      value.toString();
                                                  // 查询
                                                  bloc
                                                      .read<ExitInputBloc>()
                                                      .add(
                                                        QueryDetailsinformation(
                                                          context,
                                                          state
                                                              .detailsCodeValue,
                                                        ),
                                                      );
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
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .exit_input_form_title_6,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              text: state.detailLocationCode.toString(),
                              readOnly: true,
                              inputBoxCallBack: (value) {
                                state.detailLocationCode = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .exit_input_form_title_7,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              text: state.productCodeValue.toString(),
                              readOnly: true,
                              inputBoxCallBack: (value) {
                                state.productCodeValue = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .exit_input_form_title_8,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              text: state.productNameValue.toString(),
                              readOnly: true,
                              inputBoxCallBack: (value) {
                                state.productNameValue = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .exit_input_form_title_9,
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
                                      text: state.allocationNumberValue
                                          .toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        state.allocationNumberValue = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
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
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
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
                                    .exit_input_form_title_10,
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
                                    state.productImage1 != null &&
                                        state.productImage1 != '',
                                child: Image.network(
                                  state.productImage1,
                                  width: 136,
                                  height: 136,
                                )),
                            Visibility(
                              visible:
                                  // ignore: unnecessary_null_comparison
                                  state.productImage2 != null &&
                                      state.productImage2 != '',
                              child: Image.network(
                                state.productImage2,
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
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Divider(
                          height: 1.0,
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
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
                                      text: state.locationBarCode.toString(),
                                      borderColor:
                                          const Color.fromRGBO(0, 0, 0, 0),
                                      inputBoxCallBack: (value) {
                                        // state.locationBarCode =
                                        //     value.toString();
                                        bloc.read<ExitInputBloc>().add(
                                            SetShopBarcodeEvent(
                                                value.toString(), '1'));
                                        // 半角英数記号
                                        if (CheckUtils
                                            .check_Half_Alphanumeric_Symbol(
                                                value)) {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                      .exit_input_form_title_11 +
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .check_half_width_alphanumeric_with_symbol);
                                        } else if (state.locationBarCode !=
                                            state.detailLocationCode) {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                  .exit_input_form_Toast_5);
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
                                                  // 位置码事件（扫描用）
                                                  bloc
                                                      .read<ExitInputBloc>()
                                                      .add(LocationBarCodeEvent(
                                                          context, value));
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
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
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
                                        .exit_input_form_title_12,
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
                                      text: state.productBarCode.toString(),
                                      borderColor: Colors.transparent,
                                      inputBoxCallBack: (value) {
                                        state.productBarCode = value.toString();
                                        bloc.read<ExitInputBloc>().add(
                                            SetShopBarcodeEvent(
                                                value.toString(), '2'));
                                        //半角英数記号
                                        if (CheckUtils
                                            .check_Half_Alphanumeric_Symbol(
                                                value)) {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                      .exit_input_form_title_12 +
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .check_half_width_alphanumeric_with_symbol);
                                        } else if (state.locationBarCode ==
                                                state.detailLocationCode &&
                                            state.locationBarCode != '') {
                                          if (state.productBarCode !=
                                                  state.productCodeValue ||
                                              state.productBarCode == '') {
                                            // 消息提示
                                            WMSCommonBlocUtils.tipTextToast(
                                                WMSLocalizations.i18n(context)!
                                                        .exit_input_form_title_12 +
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .exit_input_form_Toast_3);
                                          } else {
                                            if (state.productCount <
                                                state.allocationNumberValue) {
                                              bloc.read<ExitInputBloc>().add(
                                                  SetShopBarcodeEvent(
                                                      (state.productCount + 1)
                                                          .toString(),
                                                      '3'));
                                            } else {
                                              bloc.read<ExitInputBloc>().add(
                                                  SetShopBarcodeEvent(
                                                      state
                                                          .allocationNumberValue
                                                          .toString(),
                                                      '3'));
                                            }
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
                                                scanCallBack: (value) {
                                                  // 商品码事件（扫描用）
                                                  bloc
                                                      .read<ExitInputBloc>()
                                                      .add(ProductBarCodeEvent(
                                                          context, value));
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
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
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
                                        .exit_input_form_title_13,
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
                                    child: WMSInputboxWidget(
                                      borderColor: Colors.transparent,
                                      text: state.productCount.toString(),
                                      inputBoxCallBack: (value) {
                                        state.productCount =
                                            int.tryParse(value)!;
                                        bloc.read<ExitInputBloc>().add(
                                            SetShopBarcodeEvent(value, '3'));
                                        // 半角数字 9位
                                        if (CheckUtils.check_Half_Number_In_10(
                                            value)) {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                      .exit_input_form_title_13 +
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .check_half_width_numbers_in_10);
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
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
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Divider(
                          height: 1.0,
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1.1,
                      child: Container(
                        height: 72,
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
                                        .exit_input_form_title_14,
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
                                      borderColor: Colors.transparent,
                                      text: state.shopBarcode.toString(),
                                      inputBoxCallBack: (value) {
                                        bloc.read<ExitInputBloc>().add(
                                            SetShopBarcodeEvent(value, '4'));
                                        //半角英数記号
                                        if (CheckUtils
                                            .check_Half_Alphanumeric_Symbol(
                                                value)) {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                      .exit_input_form_title_14 +
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .check_half_width_alphanumeric_with_symbol);
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
                                                  // 商铺码事件（扫描用）
                                                  bloc
                                                      .read<ExitInputBloc>()
                                                      .add(ShopBarCodeEvent(
                                                          context, value));
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
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Divider(
                          height: 1.0,
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // 设置按钮文本颜色
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(100, 48)), // 设置按钮宽度和高度
                        ),
                        child: Text(WMSLocalizations.i18n(context)!
                            .exit_input_form_button_issue), // ラベル発行
                        onPressed: () async {
                          // 赵士淞 - 始
                          // 判断参数
                          if (state.locationCodeValue != '' &&
                              state.detailsCodeValue != '' &&
                              state.locationBarCode != '' &&
                              state.productId != 0 &&
                              state.productCount != 0) {
                            // 按钮单个列表
                            List _buttonItemList = [
                              {
                                'index': Config.NUMBER_ZERO,
                                'title': WMSLocalizations.i18n(context)!
                                    .shelves_product_label,
                              },
                              {
                                'index': Config.NUMBER_ONE,
                                'title': WMSLocalizations.i18n(context)!
                                    .baskets_product_label,
                              },
                            ];
                            // 显示打印弹窗
                            _showPrinterDialog(_buttonItemList);
                          } else {
                            // 消息提示
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(context)!
                                    .miss_param_unable_print);
                          }
                          // 赵士淞 - 终
                        },
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // 设置按钮文本颜色
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(100, 48)), // 设置按钮宽度和高度
                        ),
                        child: Text(WMSLocalizations.i18n(context)!
                            .exit_input_form_button_clear), // クリア
                        onPressed: () async {
                          bloc.read<ExitInputBloc>().add(ClearInformation());
                        },
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // 设置按钮文本颜色
                          minimumSize: MaterialStateProperty.all<Size>(
                              Size(100, 48)), // 设置按钮宽度和高度
                        ),
                        child: Text(WMSLocalizations.i18n(context)!
                            .exit_input_form_button_execute),
                        onPressed: () async {
                          bool flag = true;
                          if (state.locationInformation[0]['ship_kbn'] != '2' &&
                              state.locationInformation[0]['ship_kbn'] != '3') {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast('状态不对');
                          } else if (state.detailsCodeValue.isEmpty) {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(context)!
                                        .exit_input_form_title_5 +
                                    WMSLocalizations.i18n(context)!
                                        .can_not_null_text);
                          } else if (state.locationBarCode.isEmpty) {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(context)!
                                        .exit_input_form_title_11 +
                                    WMSLocalizations.i18n(context)!
                                        .can_not_null_text);
                          } else if (state.productBarCode.isEmpty) {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(context)!
                                        .exit_input_form_title_12 +
                                    WMSLocalizations.i18n(context)!
                                        .can_not_null_text);
                          } else if (state.productCount == 0) {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(context)!
                                        .exit_input_form_title_13 +
                                    WMSLocalizations.i18n(context)!
                                        .can_not_null_text);
                          } else if (state.shopBarcode.isEmpty) {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(context)!
                                        .exit_input_form_title_14 +
                                    WMSLocalizations.i18n(context)!
                                        .can_not_null_text);
                          } else if (state.allocationNumberValue !=
                                  state.productCount &&
                              state.allocationNumberValue != 0 &&
                              state.productCount != 0) {
                            flag = false;
                            WMSCommonBlocUtils.tipTextToast('合計数与引当数一致なし');
                          }
                          if (flag) {
                            bloc.read<ExitInputBloc>().add(updateTableDetails(
                                bloc, state.shopBarcode, state.dtbPickListId));
                          }
                          //   // 実行
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // 表格
              // GoodsReceiptInputTable(),
              Container(
                height: 80,
                padding: EdgeInsets.fromLTRB(20, 40, 10, 10),
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_overview,
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
                    WMSTableWidget<ExitInputBloc, ExitInputModel>(
                      operatePopupHeight: 135,
                      headTitle: 'id',
                      columns: [
                        {
                          'key': 'id',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_1,
                        },
                        {
                          'key': 'warehouse_no',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_2,
                        },
                        {
                          'key': 'loc_cd',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_3,
                        },
                        {
                          'key': 'code',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_4,
                        },
                        {
                          'key': 'name',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_5,
                        },
                        {
                          'key': 'product_price',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_6,
                        },
                        {
                          'key': 'lock_num',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_7,
                        },
                        {
                          'key': 'size',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_8,
                        },
                        {
                          'key': 'count',
                          'width': 0.5,
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_title_9,
                        },
                      ],
                      operatePopupOptions: [
                        {
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_update,
                          'callback': (_, value) {
                            bloc.read<ExitInputBloc>().add(QueryTableDetails(
                                context, value['pick_line_no']));
                          },
                        },
                        {
                          'title': WMSLocalizations.i18n(context)!
                              .exit_input_table_delete,
                          'callback': (_, value) {
                            bloc
                                .read<ExitInputBloc>()
                                .add(QueryTableDetailShipKbn(value, context));
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
