import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/display_instruction_detail_bloc.dart';
import '../bloc/display_instruction_detail_modle.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：出荷指示照会-明细
 * 作者：熊草云
 * 时间：2023/08/14
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];
// 全局主键-表格共通

class DisplayInstructionPackingslip extends StatefulWidget {
  const DisplayInstructionPackingslip({super.key});

  @override
  State<DisplayInstructionPackingslip> createState() =>
      _DisplayInstructionPackingslipState();
}

class _DisplayInstructionPackingslipState
    extends State<DisplayInstructionPackingslip> {
  // 操作按钮跟踪
  bool _operated = false;
  //定义接受对象
  Map<String, dynamic> currentParam = {};

  @override
  Widget build(BuildContext context) {
    setState(() {
      //接收传过来的参数
      currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
    });
    return BlocProvider<DisplayInstructionDetailBloc>(
      create: (context) {
        return DisplayInstructionDetailBloc(
          DisplayInstructionDetailModel(
              shipId: currentParam['id'], context: context),
        );
      },
      child: BlocBuilder<DisplayInstructionDetailBloc,
          DisplayInstructionDetailModel>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              setState(() {
                // 在这里修改数据
                _operated = false;
              });
            },
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
                  height: 445,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .display_instruction_shipment_detail,
                              style: TextStyle(
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                  fontSize: 24),
                            ),
                          ),
                          // 返回按钮
                          Container(
                            color: Colors.white,
                            height: 37,
                            width: 80,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(
                                  () {
                                    if (state.reFlag == 0) {
                                      Navigator.pop(context, 'return');
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              },
                              child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .menu_content_3_11_11,
                                  style: TextStyle(
                                      color: Color.fromRGBO(44, 167, 176, 1))),
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                side: MaterialStateProperty.all(
                                  const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      DefaultTextStyle(
                        style: TextStyle(fontSize: 14),
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          height: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 40),
                                    height: 290,
                                    child: Row(
                                      children: [
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
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Row(
                                                  children: [
                                                    BuildData(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_18,
                                                        1),
                                                    SizedBox(width: 30),
                                                    BuildText(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_17,
                                                        2)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 100),
                                            child: Column(
                                              children: [
                                                BuildInput(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_27,
                                                    0),
                                                BuildInput(
                                                    WMSLocalizations.i18n(
                                                            context)!
                                                        .delivery_note_28,
                                                    1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${WMSLocalizations.i18n(context)!.delivery_note_14}:${state.shipDetail['ship_no']}",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    44, 167, 176, 1),
                                                fontSize: 16)),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 37,
                                                width: 90,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Color(0xFF2CA7B0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(
                                                      () {
                                                        _operated = !_operated;
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_32,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      ),
                                                      Icon(
                                                          _operated
                                                              ? Icons
                                                                  .keyboard_arrow_up
                                                              : Icons
                                                                  .keyboard_arrow_down,
                                                          color: Colors.white,
                                                          size: 14)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              if (_operated)
                                                Container(
                                                  width: 200,
                                                  height: state.shipDetail[
                                                              'ship_kbn'] ==
                                                          Config
                                                              .SHIP_KBN_WAIT_ASSIGN
                                                      ? 160
                                                      : 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12)),
                                                  child: ListView(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    children: [
                                                      state.shipDetail[
                                                                  'ship_kbn'] ==
                                                              Config
                                                                  .SHIP_KBN_WAIT_ASSIGN
                                                          ? TextButton(
                                                              onPressed: () {
                                                                if (state.shipDetail[
                                                                        'ship_kbn'] ==
                                                                    '1') {
                                                                  context
                                                                      .read<
                                                                          DisplayInstructionDetailBloc>()
                                                                      .add(
                                                                          ReservationShipLineEvent([
                                                                        currentParam[
                                                                            'id'],
                                                                        currentParam[
                                                                            'ship_no']
                                                                      ], context));
                                                                } else {
                                                                  state.reFlag =
                                                                      2;
                                                                  WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(
                                                                              context)!
                                                                          .delivery_note_14 +
                                                                      '：${currentParam['ship_no']}  ' +
                                                                      WMSLocalizations.i18n(
                                                                              context)!
                                                                          .display_instruction_reservation_disappearance);
                                                                }
                                                              },
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  WMSLocalizations
                                                                          .i18n(
                                                                              context)!
                                                                      .menu_content_3_11_1,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            44,
                                                                            167,
                                                                            176,
                                                                            1),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      TextButton(
                                                        onPressed: () {
                                                          // 修正
                                                          context.go(
                                                              '/instructioninput/' +
                                                                  currentParam[
                                                                          'id']
                                                                      .toString());
                                                        },
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            WMSLocalizations
                                                                    .i18n(
                                                                        context)!
                                                                .instruction_input_tab_button_update,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      44,
                                                                      167,
                                                                      176,
                                                                      1),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // 删除
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (state.shipDetail[
                                                                  'ship_kbn'] !=
                                                              Config
                                                                  .SHIP_KBN_WAIT_ASSIGN) {
                                                            WMSCommonBlocUtils.errorTextToast(
                                                                WMSLocalizations
                                                                        .i18n(
                                                                            context)!
                                                                    .display_instruction_tip1);
                                                          } else {
                                                            await _deleteDialog()
                                                                .then((value) {
                                                              if (value) {
                                                                setState(() {});
                                                                context
                                                                    .read<
                                                                        DisplayInstructionDetailBloc>()
                                                                    .add(
                                                                      DeleteShipEvent(
                                                                        currentParam[
                                                                            'id'],
                                                                      ),
                                                                    );
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            WMSLocalizations
                                                                    .i18n(
                                                                        context)!
                                                                .delivery_note_10,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      44,
                                                                      167,
                                                                      176,
                                                                      1),
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 明细一览
                DetailTablePage(bloc: context),
              ],
            ),
          );
        },
      ),
    );
  }

// 删除
  // _deleteDialog() {
  Future<bool> _deleteDialog() async {
    // 创建一个Completer
    Completer<bool> completer = Completer();
    showDialog(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText: WMSLocalizations.i18n(context)!
              .display_instruction_confirm_delete,
          contentText:
              "${WMSLocalizations.i18n(context)!.delivery_note_14}:${currentParam['ship_no']}${WMSLocalizations.i18n(context)!.display_instruction_delete}",
          buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
          buttonRightText: WMSLocalizations.i18n(context)!.delivery_note_10,
          onPressedLeft: () {
            // 关闭弹窗
            Navigator.of(context).pop(false);
            setState(() {
              // 完成Future并传递结果
              completer.complete(false);
            });
          },
          onPressedRight: () {
            // 删除数据
            setState(() {});
            // 关闭弹窗
            Navigator.of(context).pop(true);
            // 完成Future并传递结果
            completer.complete(true);
          },
        );
      },
    );
    // 返回Future对象
    return completer.future;
  }

  // 日期
  Widget BuildData(String text, int index) {
    return BlocBuilder<DisplayInstructionDetailBloc,
        DisplayInstructionDetailModel>(builder: (context, state) {
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
                    ? state.shipDetail['rcv_sch_date']
                    : state.shipDetail['cus_rev_date'],
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 文本框
  Widget BuildText(String text, index) {
    return BlocBuilder<DisplayInstructionDetailBloc,
        DisplayInstructionDetailModel>(builder: (context, state) {
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
                    ? state.shipDetail['customer_name']
                    : state.shipDetail['name'],
                readOnly: true),
          ],
        ),
      );
    });
  }

  // 输入框
  Widget BuildInput(String text, int index) {
    return BlocBuilder<DisplayInstructionDetailBloc,
        DisplayInstructionDetailModel>(builder: (context, state) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: WMSInputboxWidget(
                readOnly: true,
                text: index == 0
                    ? state.shipDetail['note1']
                    : state.shipDetail['note2'],
              ),
            )
          ],
        ),
      );
    });
  }
}

//  明细一览
class DetailTablePage extends StatefulWidget {
  final BuildContext bloc;
  DetailTablePage({
    super.key,
    required this.bloc,
  });

  @override
  State<DetailTablePage> createState() => _DetailTablePageState();
}

class _DetailTablePageState extends State<DetailTablePage> {
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
      margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
      child: Column(
        children: [
          // 明细行
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              height: 40,
              child: Text(
                  WMSLocalizations.i18n(context)!
                      .display_instruction_detail_line,
                  style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1), fontSize: 24)),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  DetailTableButtonContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 出荷指示照会表格内容
class DetailTableButtonContent extends StatefulWidget {
  DetailTableButtonContent({
    super.key,
  });

  @override
  State<DetailTableButtonContent> createState() =>
      _DetailTableButtonContentState();
}

class _DetailTableButtonContentState extends State<DetailTableButtonContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayInstructionDetailBloc,
        DisplayInstructionDetailModel>(builder: (context, state) {
      return WMSTableWidget<DisplayInstructionDetailBloc,
          DisplayInstructionDetailModel>(
        columns: [
          {
            'key': 'id',
            'width': 3,
            'title':
                WMSLocalizations.i18n(context)!.instruction_input_table_title_1,
          },
          {
            'key': 'warehouse_no',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_1,
          },
          {
            'key': 'code',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_2,
          },
          {
            'key': 'name',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_3,
          },
          {
            'key': 'product_price',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_4,
          },
          {
            'key': 'ship_num',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_5,
          },
          {
            'key': 'size',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_6,
          },
          {
            'key': 'importerror_flg',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .display_instruction_ingestion_state,
          },
          {
            'key': 'lock_kbn_name',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_reservation_status,
          },
          {
            'key': 'sum',
            'width': 3,
            'title': WMSLocalizations.i18n(context)!
                .delivery_note_shipment_details_7,
          },
        ],
        operatePopupOptions: [
          {
            'title': WMSLocalizations.i18n(context)!.delivery_note_8,
            'callback': (_, value) async {
              // 赵士淞 - 始
              // 图片处理
              dynamic processedValue = await context
                  .read<DisplayInstructionDetailBloc>()
                  .imageProcessing(value);
              // 赵士淞 - 终
              // 查询出荷指示明细事件
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeliveryDetailDialog(detailValue: processedValue);
                  });
            },
          },
          {
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_table_operate_delete,
            'callback': (_, value) {
              setState(() {
                if (value['importerror_flg'] == null) {
                  value['importerror_flg'] = '0';
                }
                // 引当済が【1：引当済】以外の場合は削除可能
                if (value['lock_kbn'] != '1') {
                  _showDeleteDetailDialog(value['id']);
                } else {
                  WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(state.context)!
                          .display_instruction_tip2);
                }
              });
            },
          },
        ],
        showCheckboxColumn: false,
      );
    });
  }

// 删除明细行弹窗
  _showDeleteDetailDialog(deleteId) {
    DisplayInstructionDetailBloc bloc =
        context.read<DisplayInstructionDetailBloc>();
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<DisplayInstructionDetailBloc>.value(
            value: bloc,
            child: BlocBuilder<DisplayInstructionDetailBloc,
                DisplayInstructionDetailModel>(
              builder: (context, state) {
                return WMSDiaLogWidget(
                  titleText: WMSLocalizations.i18n(context)!
                      .display_instruction_confirm_delete,
                  contentText:
                      "${WMSLocalizations.i18n(context)!.delivery_note_shipment_details_10}:${deleteId}${WMSLocalizations.i18n(context)!.display_instruction_delete}",
                  buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                  buttonRightText:
                      WMSLocalizations.i18n(context)!.delivery_note_10,
                  onPressedLeft: () {
                    // 关闭弹窗
                    Navigator.pop(context);
                  },
                  onPressedRight: () {
                    // 删除数据
                    setState(() {});
                    // 关闭弹窗
                    context
                        .read<DisplayInstructionDetailBloc>()
                        .add(DeleteShipLineEvent(deleteId));
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          );
        });
  }
}

//   納品明細一覧ダイアログ 弹窗
class DeliveryDetailDialog extends StatefulWidget {
  final Map detailValue;
  const DeliveryDetailDialog({super.key, required this.detailValue});

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
            child: OutlinedButton(
              child: Text(
                WMSLocalizations.i18n(context)!.delivery_note_close,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(44, 167, 176, 1),
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
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_10,
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
                                  widget.detailValue['ship_line_no'].toString(),
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
                                  widget.detailValue['warehouse_no'].toString(),
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
                              text: widget.detailValue['code'].toString(),
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
                              // 赵士淞 - 测试修复 2023/11/16 - 始
                              text: widget.detailValue['name'].toString(),
                              // 赵士淞 - 测试修复 2023/11/16 - 终
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
                              text: widget.detailValue['product_price']
                                  .toString(),
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
                                    .delivery_note_shipment_details_5,
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
                              text: widget.detailValue['ship_num'].toString(),
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
                              text: widget.detailValue['size'].toString(),
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
                              text: widget.detailValue['limit_date']
                                  .toString()
                                  .split('T')[0],
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
                              text: widget.detailValue['lot_no'].toString(),
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
                              text: widget.detailValue['serial_no'].toString(),
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
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_14,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        widget.detailValue['image1_real'] != null &&
                                widget.detailValue['image1_real'] != ''
                            ? Image.network(
                                widget.detailValue['image1_real'],
                                height: 180,
                              )
                            : Image.asset(
                                WMSICons.NO_IMAGE,
                                height: 180,
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
                        widget.detailValue['image2_real'] != null &&
                                widget.detailValue['image2_real'] != ''
                            ? Image.network(
                                widget.detailValue['image2_real'],
                                height: 180,
                              )
                            : Image.asset(
                                WMSICons.NO_IMAGE,
                                height: 180,
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
                          height: 180,
                          readOnly: true,
                          text: widget.detailValue['note1'].toString(),
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
                          height: 180,
                          readOnly: true,
                          text: widget.detailValue['note2'].toString(),
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
                          height: 180,
                          readOnly: true,
                          text: widget.detailValue['note2'].toString(),
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
                          height: 180,
                          readOnly: true,
                          text: widget.detailValue['note2'].toString(),
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
                          height: 180,
                          readOnly: true,
                          text: widget.detailValue['note2'].toString(),
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
                          height: 180,
                          readOnly: true,
                          text: widget.detailValue['note2'].toString(),
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
