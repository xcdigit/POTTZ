import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_scan_widget.dart';
import '../bloc/incoming_inspection_bloc.dart';
import '../bloc/incoming_inspection_model.dart';

/**
 * 内容：入荷検品-文件
 * 作者：熊草云
 * 时间：2023/10/13
 */
class IncomingInspectionDetail extends StatefulWidget {
  final int receiveId;
  final String receiveNo;
  const IncomingInspectionDetail({
    super.key,
    required this.receiveId,
    required this.receiveNo,
  });

  @override
  State<IncomingInspectionDetail> createState() =>
      _IncomingInspectionDetailState();
}

class _IncomingInspectionDetailState extends State<IncomingInspectionDetail> {
  // 检品弹窗
  // 检品弹窗
  bool flag = false;
  showInspectionDialog(int maxSum, String name, bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<IncomingInspectionBloc>.value(
          value: bloc,
          child: BlocBuilder<IncomingInspectionBloc, IncomingInspectionModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .incoming_inspection_confirmation,
                contentText:
                    "${WMSLocalizations.i18n(context)!.incoming_inspection_product} $name  ${WMSLocalizations.i18n(context)!.incoming_inspection_product_inspected}",
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 页面++
                  setState(() {
                    context
                        .read<IncomingInspectionBloc>()
                        .add(UpdataGoodsEvent());
                    Navigator.pop(context);
                    if (state.number + 1 == maxSum) {
                      _showInspectionOverDialog(bloc);
                    }
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  // 警告
  showWarnDialog(int maxSum, String name, bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText:
              WMSLocalizations.i18n(context)!.incoming_inspection_confirmation,
          contentText: WMSLocalizations.i18n(context)!.incoming_inspection_4,
          buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
          buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
          onPressedLeft: () {
            // 关闭弹窗
            Navigator.pop(context);
          },
          onPressedRight: () {
            // 页面++
            setState(() {
              Navigator.pop(context);
              showInspectionDialog(maxSum, name, bloc);
            });
            // 关闭弹窗
          },
        );
      },
    );
  }

// 检品完成
  _showInspectionOverDialog(bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<IncomingInspectionBloc>.value(
          value: bloc,
          child: BlocBuilder<IncomingInspectionBloc, IncomingInspectionModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .incoming_inspection_confirmation,
                contentText: WMSLocalizations.i18n(context)!
                    .incoming_inspection_all_product,
                buttonLeftFlag: false,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedRight: () {
                  // 页面++
                  setState(() {
                    context
                        .read<IncomingInspectionBloc>()
                        .add((SetGoodsDetailNullEvent()));
                  });
                  // 关闭弹窗
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IncomingInspectionBloc>(
      create: (context) {
        return IncomingInspectionBloc(
          IncomingInspectionModel(
              context: context, receiveNo: widget.receiveNo),
        );
      },
      child: BlocBuilder<IncomingInspectionBloc, IncomingInspectionModel>(
        builder: (context, state) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(40, 10, 40, 40),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                          // ignore: unnecessary_null_comparison
                          "${state.number}/${state.receive['datalength'] == null ? 0 : state.receive['datalength']}"),
                    ),
                    SizedBox(height: 20),
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
                                        .incoming_inspection_receipt_barcode,
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
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                      text: state.qrCode2,
                                      inputBoxCallBack: (value) {
                                        if (state.receive['datalength'] != 0 &&
                                            value.trim() != '' &&
                                            value != null)
                                          context
                                              .read<IncomingInspectionBloc>()
                                              .add(QueryArrivalDetailEvent(
                                                  context, value.trim()));
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
                                                  if (state.receive[
                                                              'datalength'] !=
                                                          0 &&
                                                      value.trim() != '' &&
                                                      value != null)
                                                    context
                                                        .read<
                                                            IncomingInspectionBloc>()
                                                        .add(
                                                            QueryArrivalDetailEvent(
                                                                context,
                                                                value.trim()));
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
                        height: 80,
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .instruction_input_table_title_3,
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
                                text: state.detail_code.toString(),
                                readOnly: true,
                              ),
                            )
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
                                    text: state.detail_name.toString(),
                                    readOnly: true,
                                  ),
                                )
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
                                        .incoming_inspection_expected_number,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                Container(
                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                          readOnly: true,
                                          text: state.detail_product_num
                                              .toString(),
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
                                            .incoming_inspection_num,
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
                                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                          text:
                                              state.detail_check_num.toString(),
                                          inputBoxCallBack: (value) {
                                            if (int.tryParse(value.trim()) ==
                                                    null &&
                                                value != '' &&
                                                value != null) {
                                              WMSCommonBlocUtils.tipTextToast(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .incoming_inspection_tip_2);
                                              context
                                                  .read<
                                                      IncomingInspectionBloc>()
                                                  .add(UpdataChecknumEvent(''));
                                            } else {
                                              context
                                                  .read<
                                                      IncomingInspectionBloc>()
                                                  .add(UpdataChecknumEvent(
                                                      value.trim()));
                                            }
                                          },
                                          // readOnly: true,
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
                        ],
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
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
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12)),
                              // ignore: unnecessary_null_comparison
                              child: state.detail_image != null &&
                                      state.detail_image != ''
                                  ? Image.network(
                                      state.detail_image,
                                      height: 216,
                                    )
                                  : Image.asset(
                                      WMSICons.NO_IMAGE,
                                      height: 216,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: SizedBox(height: 40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              .incoming_inspection_product_label),
                          onPressed: () {
                            // 赵士淞 - 始
                            // 判断参数
                            if (state.receiveDetail.length != 0) {
                              // 打印事件
                              context
                                  .read<IncomingInspectionBloc>()
                                  .add(PrinterEvent());
                            } else {
                              // 消息提示
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                      .miss_param_unable_print);
                            }
                            // 赵士淞 - 终
                          },
                        ),
                        SizedBox(width: 40),
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
                              .shipment_inspection_inspection),
                          onPressed: () {
                            if (state.qrCode1 == '' || state.qrCode1 == null) {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                      .incoming_inspection_1);
                            } else if (CheckUtils
                                .check_Half_Alphanumeric_Symbol(
                                    state.qrCode1)) {
                              WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                          .i18n(context)!
                                      .incoming_inspection_expected_barcode +
                                  WMSLocalizations.i18n(context)!
                                      .check_half_width_alphanumeric_with_symbol);
                            } else if (state.qrCode2 == null ||
                                state.qrCode2 == '' ||
                                state.qrCode2 == 'null') {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                          .incoming_inspection_receipt_barcode +
                                      WMSLocalizations.i18n(context)!
                                          .can_not_null_text);
                            } else if (CheckUtils
                                .check_Half_Alphanumeric_Symbol(
                                    state.qrCode2)) {
                              WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                          .i18n(context)!
                                      .incoming_inspection_receipt_barcode +
                                  WMSLocalizations.i18n(context)!
                                      .check_half_width_alphanumeric_with_symbol);
                            }
                            // 1check 【入荷予定数】或者【検品数】为空，提示【请确认检品数】
                            else if (state.detail_check_num == 'null' ||
                                // ignore: unnecessary_null_comparison
                                state.detail_check_num == null ||
                                state.detail_check_num == '' ||
                                state.detail_product_num == 'null' ||
                                // ignore: unnecessary_null_comparison
                                state.detail_product_num == null ||
                                state.detail_product_num == '') {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                      .incoming_inspection_3);
                            } else if (CheckUtils.check_Half_Number_In_10(
                                state.detail_check_num)) {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                          .incoming_inspection_num +
                                      WMSLocalizations.i18n(context)!
                                          .check_half_width_numbers_in_10);
                            }
                            // 重复检品时提示
                            else if (state.receiveDetail['check_kbn'] != '2') {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                      .incoming_inspection_tip_3);
                              context
                                  .read<IncomingInspectionBloc>()
                                  .add(SetGoodsDetailNullEvent());
                            }
                            // 2check 【入荷予定数】和【検品数】是否相等 不等的场合，提示警告【当前検品数与入荷予定数不一致是否继续检品】
                            else if (state.detail_check_num !=
                                state.detail_product_num) {
                              IncomingInspectionBloc bloc =
                                  context.read<IncomingInspectionBloc>();
                              showWarnDialog(state.receive['datalength'],
                                  state.receiveDetail['name'], bloc);
                            } else {
                              setState(
                                () {
                                  IncomingInspectionBloc bloc =
                                      context.read<IncomingInspectionBloc>();
                                  showInspectionDialog(
                                      state.receive['datalength'],
                                      state.receiveDetail['name'],
                                      bloc); // 检品
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
