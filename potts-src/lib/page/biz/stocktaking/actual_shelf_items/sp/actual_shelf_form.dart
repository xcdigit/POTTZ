import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/stocktaking/actual_shelf_items/bloc/actual_shelf_bloc.dart';
import 'package:wms/page/biz/stocktaking/actual_shelf_items/bloc/actual_shelf_model.dart';

import 'package:wms/widget/wms_dialog_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_scan_widget.dart';

/**
 * 内容：実棚明細入力
 * 作者：王光顺
 * 时间：2023/08/28
 */

String starttime = '';

String overtime = '';

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List<Widget> currentContent = [];

bool isActualShelfEditable = false;

String input1 = '';
String input2 = '';

class ActualShelfForm extends StatefulWidget {
  const ActualShelfForm({super.key});

  @override
  State<ActualShelfForm> createState() => _ActualShelfFormState();
}

class _ActualShelfFormState extends State<ActualShelfForm> {
  TextEditingController textEditingController = TextEditingController();

  List<Widget> _initFormBasic(BuildContext context, ActualShelfModel state) {
    return [
      Container(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 棚卸日
                  Text(
                    WMSLocalizations.i18n(context)!.start_inventory_date +
                        ':' +
                        state.actualDate.toString().split('T')[0],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: .5,
                      color: Color.fromRGBO(44, 167, 176, 1),
                    ),
                  ),
                  SizedBox(width: 10),
                  // 倉庫
                  Text(
                    WMSLocalizations.i18n(context)!.inventory_output_3 +
                        ':' +
                        state.warehouse.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      height: .5,
                      color: Color.fromRGBO(44, 167, 176, 1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    WMSLocalizations.i18n(context)!.Actual_Shelf_1,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8), // 调整圆角半径
                  child: LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 12,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(state.progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '${(state.logicNum).toString()} / ${(state.HlogicNum).toString()}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 10,
            ),
            Divider(
              color: Colors.black,
            ),
            Align(
              alignment: Alignment.centerRight,
            ),
            SizedBox(
              width: double.infinity,
              height: 10,
            ),

            //ロケーションのバーコード
            Container(
              height: 80,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.Actual_Shelf_2,
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
                            readOnly: state.actualState == 2,
                            text: state.actualInformation['loc_cd'] != null
                                ? state.actualInformation['loc_cd'].toString()
                                : '',
                            borderColor: Colors.transparent,
                            inputBoxCallBack: (value) {
                              if (value != '') {
                                context
                                    .read<ActualShelfBloc>()
                                    .add(ShelfSetInputEvent('location', value));
                              } else {
                                context
                                    .read<ActualShelfBloc>()
                                    .add(ShelfSetInputEvent('location', ''));
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
                                        // 赋值
                                        context.read<ActualShelfBloc>().add(
                                            ShelfSetInputEvent(
                                                'location', value));
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

            //商品ラベルのバーコード
            Container(
              height: 80,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.Actual_Shelf_3,
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
                            text: state.actualInformation['code'] != null
                                ? state.actualInformation['code'].toString()
                                : '',
                            readOnly: state.actualState == 2,
                            borderColor: Colors.transparent,
                            inputBoxCallBack: (value) {
                              if (value != '') {
                                context
                                    .read<ActualShelfBloc>()
                                    .add(ShelfSetInputEvent('product', value));
                              } else {
                                context
                                    .read<ActualShelfBloc>()
                                    .add(ShelfSetInputEvent('product', ''));
                              }
                              ;
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
                                        context.read<ActualShelfBloc>().add(
                                            ShelfSetInputEvent(
                                                'product', value));
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

            SizedBox(width: double.infinity),
            Container(
              width: 450,
              child: Column(
                children: [
                  //商品名
                  FractionallySizedBox(
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!.Actual_Shelf_4,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                          ),
                          WMSInputboxWidget(
                            text: state.delKfn == 0
                                ? state.actualProduct['name'].toString()
                                : '',
                            height: 48,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //消費期限
                  FractionallySizedBox(
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!.Actual_Shelf_6,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                          ),
                          WMSInputboxWidget(
                            text: state.delKfn == 0
                                ? state.actualInformation['limit_date']
                                : ''.toString(),
                            height: 48,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //ロット番号
                  FractionallySizedBox(
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Text(
                              WMSLocalizations.i18n(context)!.Actual_Shelf_7,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                          ),
                          WMSInputboxWidget(
                            text: state.delKfn == 0
                                ? state.actualInformation['lot_no'].toString()
                                : '',
                            height: 48,
                            readOnly: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //图片
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    WMSLocalizations.i18n(context)!.Actual_Shelf_5,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 250, // 设置组件的高度
                    width: 450, // 设置组件的宽度
                    child: state.image1Network != '' && state.delKfn == 0
                        ? Image.network(
                            state.image1Network,
                            width: 136,
                            height: 136,
                          )
                        : Image.asset(
                            WMSICons.NO_IMAGE,
                            width: 136,
                            height: 136,
                          ),
                  )
                ],
              ),
            ),
            SizedBox(width: double.infinity),
            //シリアル
            Container(
              height: 80,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.Actual_Shelf_8,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.delKfn == 0
                        ? state.actualInformation['serial_no'].toString()
                        : '',
                    height: 48,
                    readOnly: true,
                  ),
                ],
              ),
            ),
            //補足情報
            Container(
              height: 80,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.Actual_Shelf_9,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.delKfn == 0
                        ? state.actualInformation['note'].toString()
                        : '',
                    height: 48,
                    readOnly: true,
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 10,
            ),
            Divider(
              color: Colors.black,
            ),
            Align(
              alignment: Alignment.centerRight,
            ),
            SizedBox(
              width: double.infinity,
              height: 10,
            ),
            //在庫数量
            Container(
              height: 72,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.Actual_Shelf_10,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.delKfn == 0
                        ? state.actualInformation['logic_num'].toString()
                        : '',
                    borderRadius: BorderRadius.circular(0),
                    height: 48,
                    readOnly: true,
                  ),
                ],
              ),
            ),
            //棚卸数量
            Container(
              height: 72,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.Actual_Shelf_11,
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
                  WMSInputboxWidget(
                      text: (state.realNum == 0 && state.delKfn == 1)
                          ? ''
                          : state.realNum.toString(),
                      borderRadius: BorderRadius.circular(0),
                      height: 48,
                      readOnly: false,
                      inputBoxCallBack: (value) {
                        // 检查value是否为整数
                        if (int.tryParse(value) != null) {
                          context
                              .read<ActualShelfBloc>()
                              .add(InputRealEvent(value));
                        } else {
                          context
                              .read<ActualShelfBloc>()
                              .add(InputRealEvent(0));
                        }
                      }),
                ],
              ),
            ),
            //差異数量
            Container(
              height: 72,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.Actual_Shelf_12,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: (state.difference == 0)
                        ? ''
                        : state.difference.toString(),
                    borderRadius: BorderRadius.circular(0),
                    height: 48,
                    readOnly: true,
                  ),
                ],
              ),
            ),
            //差異理由
            Container(
              height: 150,
              width: 450,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.Actual_Shelf_13,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                      maxLines: 5,
                      text: state.inputreason != ''
                          ? state.inputreason.toString()
                          : '',
                      borderRadius: BorderRadius.circular(0),
                      height: 126,
                      readOnly: false,
                      inputBoxCallBack: (value) {
                        state.inputreason = value;
                      }),
                ],
              ),
            ),
            //底部站位
            SizedBox(
              width: double.infinity,
              height: 50,
            ),
            //登录/修正按钮
            Center(
              child: Container(
                margin: EdgeInsets.only(),
                child: Column(
                  children: [
                    BuildButtom(
                      state.actualState == 2
                          ? WMSLocalizations.i18n(context)!
                              .instruction_input_tab_button_update
                          : WMSLocalizations.i18n(context)!
                              .instruction_input_tab_button_add,
                    ),
                  ],
                ),
              ),
            ),
            //底部站位
            SizedBox(
              width: double.infinity,
              height: 80,
            ),
          ],
        ),
      ),
    ];
  }

  // 底部登录按钮
  Widget BuildButtom(String text) {
    return BlocBuilder<ActualShelfBloc, ActualShelfModel>(
        builder: (context, state) {
      return Container(
        width: 200,
        height: 40,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 61, 174, 182),
          border: Border.all(
            width: 1,
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
          borderRadius: BorderRadius.circular(5), // 设置边角的半径为5
        ),
        child: OutlinedButton(
          onPressed: () {
            if (state.actualInformation.length > 0) {
              // ロケーションのバーコード为空
              if (state.actualInformation['loc_cd'] == null ||
                  state.actualInformation['loc_cd'] == '') {
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.Actual_Shelf_2 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
                return;
                // 商品ラベルのバーコード为空
              } else if (state.actualInformation['code'] == null ||
                  state.actualInformation['code'] == '') {
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.Actual_Shelf_3 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
                return;
              } else if (CheckUtils.check_Half_Alphanumeric_6_50(
                  state.actualInformation['code'])) {
                //商品コード
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.Actual_Shelf_3 +
                        WMSLocalizations.i18n(context)!
                            .text_must_six_number_letter);
                return;
              } else if (state.realNum != '' &&
                  CheckUtils.check_Half_Number_In_10(state.realNum)) {
                //棚卸数量
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.Actual_Shelf_11 +
                        WMSLocalizations.i18n(context)!.input_int_in_10_check);
                return;
              }
            } else {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.Actual_Shelf_16);
              return;
            }
            if (state.difference.toString() != '0' &&
                (state.inputreason == '' ||
                    state.inputreason.toString() == 'null'))
            //相差数量不为0 并且没有输入相差理由 提示必须输入
            {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.Actual_Shelf_13 +
                      WMSLocalizations.i18n(context)!.can_not_null_text);
            } else if (state.actualInformation.isEmpty) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.Actual_Shelf_2 +
                      WMSLocalizations.i18n(context)!.can_not_null_text);
            }
            // 库存数量为0
            else if (state.realNum == 0) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.Actual_Shelf_11 +
                      WMSLocalizations.i18n(context)!.can_not_null_text);
            } else if (state.inputProduct == 0) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.Actual_Shelf_3 +
                      WMSLocalizations.i18n(context)!.can_not_null_text);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return ExecutionDialog(
                    actualProduct: state.actualProduct,
                    actualState: state.actualState,
                    detailId: state.actualId,
                    realNum: state.realNum,
                    inputreason: state.inputreason,
                  );
                },
              ).then((value) {
                context.read<ActualShelfBloc>().add(InputReasonEvent(
                      context,
                      state.realNum,
                      state.inputreason,
                    ));
              });
            }
          },
          child: Text(
            text,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // 设置边角的半径为5
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide.none,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActualShelfBloc, ActualShelfModel>(
        builder: (bloc, state) {
      // 判断当前下标
      if (currentIndex == Config.NUMBER_ZERO) {
        currentContent = _initFormBasic(context, state);
      }

      return Container(
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: InstructionInputFormTab(
                        initFormBasic: _initFormBasic(context, state),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: InstructionInputFormButton(),
                    ),
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                padding: EdgeInsets.all(24),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: currentContent,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// 表单Tab
// ignore: must_be_immutable
class InstructionInputFormTab extends StatefulWidget {
  // 初始化基本情報入力表单
  List<Widget> initFormBasic;

  InstructionInputFormTab({super.key, required this.initFormBasic});

  @override
  State<InstructionInputFormTab> createState() =>
      _InstructionInputFormTabState();
}

class _InstructionInputFormTabState extends State<InstructionInputFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            // 判断下标
            if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = widget.initFormBasic;
              });
            } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
              // 状态变更
              setState(() {});
            } else {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = [];
              });
            }
            // 状态变更
            setState(() {
              // 当前下标
              currentIndex = tabItemList[i]['index'];
            });
          },
          child: Container(
            height: 46,
            padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: tabItemList[i]['index'] == currentIndex
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.zero,
            ),
            constraints: BoxConstraints(
              minWidth: 160,
            ),
            child: Text(
              tabItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: tabItemList[i]['index'] == currentIndex
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(156, 156, 156, 1),
              ),
            ),
          ),
        ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 表单按钮
class InstructionInputFormButton extends StatefulWidget {
  const InstructionInputFormButton({super.key});

  @override
  State<InstructionInputFormButton> createState() =>
      _InstructionInputFormButtonState();
}

class _InstructionInputFormButtonState
    extends State<InstructionInputFormButton> {
  // 初始化按钮列表

  @override
  Widget build(BuildContext context) {
    // 按钮单个列表
    return Row();
  }
}

// 弹窗
class ExecutionDialog extends StatefulWidget {
  final Map<dynamic, dynamic> actualProduct;
  final int actualState;
  final int detailId;
  final int realNum;
  final String inputreason;

  const ExecutionDialog({
    super.key,
    required this.actualProduct,
    required this.actualState,
    required this.detailId,
    required this.realNum,
    required this.inputreason,
  });

  @override
  State<ExecutionDialog> createState() => _ExecutionDialogState();
}

class _ExecutionDialogState extends State<ExecutionDialog> {
  @override
  Widget build(BuildContext context) {
    return WMSDiaLogWidget(
      titleText: widget.actualState == 2
          ? WMSLocalizations.i18n(context)!.Actual_Shelf_18
          : WMSLocalizations.i18n(context)!.Actual_Shelf_19,
      contentText: widget.actualState == 2
          ? WMSLocalizations.i18n(context)!.Actual_Shelf_4 +
              "${widget.actualProduct['name'].toString()}" +
              WMSLocalizations.i18n(context)!.Actual_Shelf_20
          : WMSLocalizations.i18n(context)!.Actual_Shelf_4 +
              "${widget.actualProduct['name'].toString()}" +
              WMSLocalizations.i18n(context)!.Actual_Shelf_21,
      buttonLeftFlag: false,
      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
      onPressedRight: () {
        // 页面++
        setState(() {});
        // 关闭弹窗
        Navigator.pop(context);
        if (widget.actualState == 2) {
          GoRouter.of(context).pop('refresh return');
        }
      },
    );
  }
}
