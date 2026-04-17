import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_detail_bloc.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_detail_model.dart';
import 'package:wms/page/biz/outbound/ship/pc/shipment_determination_page.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';

/**
 * 内容：出荷确定-表格
 * 作者：崔浩然
 * 时间：2023/08/22
 */
// ignore_for_file: must_be_immutable
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];
// 全局主键-表格共通
// GlobalKey<WMSTableWidgetState> _tableWidgetKey = new GlobalKey();

class ShipmentDeterminationPageDetail extends StatefulWidget {
  // 出荷指示ID
  int shipId = 0;
  String shipNo = '';
  ShipmentDeterminationPageDetail(
      {super.key, this.shipId = 0, this.shipNo = ''});

  @override
  State<ShipmentDeterminationPageDetail> createState() =>
      _ShipmentDeterminationPageDetailState();
}

class _ShipmentDeterminationPageDetailState
    extends State<ShipmentDeterminationPageDetail> {
  //定义接受对象
  Map<String, dynamic> currentParam = {};
  // 初始化出荷确定明細表单
  BlocBuilder<ShipmentDeterminationDetailBloc, ShipmentDeterminationDetailModel>
      _initDetails() {
    return BlocBuilder<ShipmentDeterminationDetailBloc,
        ShipmentDeterminationDetailModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 37,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //出荷指示番号
                    Container(
                      height: 37,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                                .instruction_input_form_basic_1 +
                            ':' +
                            widget.shipNo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //出荷指示日
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_basic_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      text: state.shipDetailCustomize['rcv_sch_date'] != '' &&
                              state.shipDetailCustomize['rcv_sch_date'] != null
                          ? state.shipDetailCustomize['rcv_sch_date'].toString()
                          : '',
                    ),
                    new Padding(padding: EdgeInsets.only(top: 16)),
                    //纳入日
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_basic_5,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      text: state.shipDetailCustomize['cus_rev_date'] != '' &&
                              state.shipDetailCustomize['cus_rev_date'] != null
                          ? state.shipDetailCustomize['cus_rev_date']
                          : '',
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //得意先
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_note_15,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      text: state.shipDetailCustomize['customer_name'] != '' &&
                              state.shipDetailCustomize['customer_name'] != null
                          ? state.shipDetailCustomize['customer_name']
                          : '',
                    ),
                    new Padding(padding: EdgeInsets.only(top: 16)),
                    //纳入先
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_note_17,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      text: state.shipDetailCustomize['name'] != '' &&
                              state.shipDetailCustomize['name'] != null
                          ? state.shipDetailCustomize['name']
                          : '',
                    )
                  ],
                ),
              ),
            ),
            //得意先備考
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_note_27,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      height: 136,
                      maxLines: 5,
                      text: state.shipDetailCustomize['note1'] != '' &&
                              state.shipDetailCustomize['note1'] != null
                          ? state.shipDetailCustomize['note1']
                          : '',
                    )
                    // Container(
                    //   height: 136,
                    //   decoration: BoxDecoration(
                    //     color: Color.fromRGBO(255, 255, 255, 1),
                    //     border: Border.all(
                    //       color: Color.fromRGBO(224, 224, 224, 1),
                    //     ),
                    //     borderRadius: BorderRadius.circular(4),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            //社内備考
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_note_28,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      height: 136,
                      maxLines: 5,
                      text: state.shipDetailCustomize['note2'] != '' &&
                              state.shipDetailCustomize['note2'] != null
                          ? state.shipDetailCustomize['note2']
                          : '',
                    )
                    // Container(
                    //   height: 136,
                    //   decoration: BoxDecoration(
                    //     color: Color.fromRGBO(255, 255, 255, 1),
                    //     border: Border.all(
                    //       color: Color.fromRGBO(224, 224, 224, 1),
                    //     ),
                    //     borderRadius: BorderRadius.circular(4),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   //接收传过来的参数
    //   currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
    // });
    return BlocProvider<ShipmentDeterminationDetailBloc>(
      create: (context) {
        return ShipmentDeterminationDetailBloc(
          ShipmentDeterminationDetailModel(shipId: widget.shipId),
        );
      },
      child: BlocBuilder<ShipmentDeterminationDetailBloc,
          ShipmentDeterminationDetailModel>(
        builder: (context, state) {
          return Scrollbar(
            thumbVisibility: true,
            child: ListView(
              //垂直列表
              // scrollDirection: Axis.vertical,
              children: [
                //第一行 出荷确定明細-标题 返回按钮
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //出荷确定明细
                          Container(
                            height: 84,
                            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .menu_content_60_3_26,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                height: 1.0,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                          //返回
                          Container(
                            color: Colors.white,
                            height: 35,
                            width: 80,
                            margin: EdgeInsets.only(top: 10, right: 40),
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ShipmentDeterminationPage(),
                                    ),
                                  );
                                  // 持久化状态更新
                                  // StoreProvider.of<WMSState>(context).dispatch(
                                  //     RefreshCurrentPageAction(
                                  //         Config.PAGE_FLAG_3_26));
                                });
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
                                          color: Color.fromRGBO(
                                              44, 167, 176, 1)))),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                //第三行 出荷明細-内容
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.only(left: 28, right: 28),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _initDetails(),
                  ),
                ),
                //出荷确定 明細一览-标题
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      Container(
                        height: 84,
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .menu_content_60_3_26_1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                            height: 1.0,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //出荷确定 明細一览-内容
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        //表格内容
                        ShipmentDeterminationPageDetailContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

////出荷确定 明細一览-内容
class ShipmentDeterminationPageDetailContent extends StatefulWidget {
  const ShipmentDeterminationPageDetailContent({super.key});

  @override
  State<ShipmentDeterminationPageDetailContent> createState() =>
      _ShipmentDeterminationPageDetailContentState();
}

class _ShipmentDeterminationPageDetailContentState
    extends State<ShipmentDeterminationPageDetailContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDeterminationDetailBloc,
        ShipmentDeterminationDetailModel>(
      builder: (bloc, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 80),
          child: Column(
            children: [
              //表格内容
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      //表格内容
                      ShipmentDeterminationTableDetailContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//出荷确定详细-表格内容
class ShipmentDeterminationTableDetailContent extends StatefulWidget {
  const ShipmentDeterminationTableDetailContent({super.key});

  @override
  State<ShipmentDeterminationTableDetailContent> createState() =>
      _ShipmentDeterminationTableDetailContentState();
}

class _ShipmentDeterminationTableDetailContentState
    extends State<ShipmentDeterminationTableDetailContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDeterminationDetailBloc,
        ShipmentDeterminationDetailModel>(
      builder: (context, state) {
        return Column(
          children: [
            WMSTableWidget<ShipmentDeterminationDetailBloc,
                ShipmentDeterminationDetailModel>(
              //表头
              columns: [
                //NO
                {
                  'key': 'id',
                  'width': 1,
                  'title': 'ID',
                },
                //出荷倉庫
                {
                  'key': 'warehouse_no',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_1,
                },

                //商品コード
                {
                  'key': 'product_code',
                  'width': 2,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_table_title_4,
                },
                //商品名
                {
                  'key': 'product_name',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .outbound_adjust_table_title_4,
                },
                //単価
                {
                  'key': 'product_price',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!.pink_list_51,
                },
                //出荷指示数
                {
                  'key': 'ship_num',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_5,
                },
                //規格
                {
                  'key': 'product_size',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_6,
                },
                //出荷確定状態
                {
                  'key': 'confirm_kbn_msg',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .display_instruction_shipping_detail_status,
                },
                //小計
                {
                  'key': 'subtotal',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_7,
                },
              ],
              showCheckboxColumn: false,

              operatePopupOptions: [
                {
                  //明细
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_details,
                  'callback': (_, value) async {
                    if (value != null) {
                      bool tempBool = await context
                          .read<ShipmentDeterminationDetailBloc>()
                          .queryShipBoolDetailEvent(context, value['id']);
                      if (tempBool) {
                        _showDetailDialog();
                      }
                    }
                  },
                },
                {
                  //取消
                  'title': WMSLocalizations.i18n(context)!.table_tab_cancel,
                  'callback': (_, value) {
                    if (value != null) {
                      //已经取消过不能在进行取消 2:off
                      if (value['confirm_kbn'] != null &&
                          value['confirm_kbn'] != '') {
                        if (value['confirm_kbn'] == '2') {
                          _showTipDialog(
                            WMSLocalizations.i18n(context)!
                                .shipdetail_cancel_error,
                          );
                          return false;
                        }
                      }
                      if (state.shipData.length > 0) {
                        //ship表連携済为1：ON
                        if (state.shipData['csv_kbn'] == '1') {
                          _WarningDialog(value, context);
                        } else {
                          //7:出荷済み
                          if (state.shipData['ship_kbn'] == '7') {
                            context
                                .read<ShipmentDeterminationDetailBloc>()
                                .add(updateShipEvent(context, value));
                          } else {
                            //出荷状态不对，取消失败
                            WMSCommonBlocUtils.errorTextToast(
                                WMSLocalizations.i18n(context)!
                                    .ship_kbn_no_cancel);
                          }
                        }
                      }
                    }
                  },
                },
              ],
            ),
          ],
        );
      },
    );
  }

  // 警告弹窗
  _WarningDialog(dynamic shipDetail, BuildContext parentContext) {
    ShipmentDeterminationDetailBloc bloc =
        context.read<ShipmentDeterminationDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ShipmentDeterminationDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<ShipmentDeterminationDetailBloc,
              ShipmentDeterminationDetailModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText: '【' +
                    WMSLocalizations.i18n(context)!
                        .instruction_input_table_title_8 +
                    '：' +
                    shipDetail['id'].toString() +
                    ' 】' +
                    WMSLocalizations.i18n(context)!.ship_csv_submit,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.table_tab_confirm,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  if (state.shipData['ship_kbn'] == '7') {
                    bloc.add(updateShipEvent(context, shipDetail));
                  } else {
                    WMSCommonBlocUtils.errorTextToast(
                        WMSLocalizations.i18n(context)!.ship_kbn_no_cancel);
                  }
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

  //提示弹框
  _showTipDialog(String text) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return WMSDiaLogWidget(
          titleText:
              WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
          contentText: text,
          buttonLeftFlag: false,
          buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
          onPressedRight: () {
            //关闭对话框并返回true
            Navigator.of(context).pop(true);
          },
        );
      },
    );
  }

  //明细弹窗
  _showDetailDialog() {
    ShipmentDeterminationDetailBloc bloc =
        context.read<ShipmentDeterminationDetailBloc>();
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<ShipmentDeterminationDetailBloc>.value(
            value: bloc,
            child: AlertDialog(
              titlePadding: EdgeInsets.all(1.0),
              contentPadding: EdgeInsets.all(0),
              title: Container(
                margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 标题
                    Container(
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_note_8,
                        style: TextStyle(
                            color: Color.fromRGBO(44, 167, 176, 1),
                            fontSize: 24),
                      ),
                    ),
                    //关闭按钮
                    Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(44, 167, 176, 1)),
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_close,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          // widget.bloc.add(ClearShipDetailAndProductEvent());
                          Navigator.of(context).pop(true); //关闭对话框
                        },
                      ),
                    ),
                  ],
                ),
              ),
              content: Container(
                // height: 756,
                width: 1100,
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                ),
                child: _showDialogContent(),
              ),
            ),
          );
        });
  }

//弹框中间内容
  _showDialogContent() {
    return BlocBuilder<ShipmentDeterminationDetailBloc,
        ShipmentDeterminationDetailModel>(
      builder: (context, state) {
        return ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 出荷指示明細行No
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!.pink_list_47,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['ship_line_no'] != '' &&
                                  state.shipDetailData['ship_line_no'] != null
                              ? state.shipDetailData['ship_line_no']
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //出荷倉庫
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_2,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['warehouse_no'] != '' &&
                                  state.shipDetailData['warehouse_no'] != null
                              ? state.shipDetailData['warehouse_no']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品コード
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_3,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['product_code'] != '' &&
                                  state.shipDetailData['product_code'] != null
                              ? state.shipDetailData['product_code']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        // 商品名
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_4,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['product_name'] != '' &&
                                  state.shipDetailData['product_name'] != null
                              ? state.shipDetailData['product_name']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //单价
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!.menu_content_3_11_4,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['product_price'] != null
                              ? state.shipDetailData['product_price'].toString()
                              : '0',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //出荷指示数
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!.menu_content_3_11_6,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['store_num'] != null
                              ? state.shipDetailData['store_num'].toString()
                              : '0',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //规格
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_5,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['product_size'] != '' &&
                                  state.shipDetailData['product_size'] != null
                              ? state.shipDetailData['product_size']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //消费期限
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!.menu_content_3_11_8,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['limit_date'] != '' &&
                                  state.shipDetailData['limit_date'] != null
                              ? state.shipDetailData['limit_date'].toString()
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        // ロット番号
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!.menu_content_3_11_9,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['lot_no'] != '' &&
                                  state.shipDetailData['lot_no'] != null
                              ? state.shipDetailData['lot_no']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        // シリアル
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .menu_content_3_11_10,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: state.shipDetailData['serial_no'] != '' &&
                                  state.shipDetailData['serial_no'] != null
                              ? state.shipDetailData['serial_no']
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 24)),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //得意先明細備考
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_9,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          readOnly: true,
                          text: state.shipDetailData['note1'] != '' &&
                                  state.shipDetailData['note1'] != null
                              ? state.shipDetailData['note1']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品写真1
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_5,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.shipDetailData['image1'] != null &&
                              state.shipDetailData['image1'] != '',
                          child: state.shipDetailData['image1'] != null &&
                                  state.shipDetailData['image1'] != ''
                              ? Image.network(
                                  state.shipDetailData['image1'],
                                  width: 136,
                                  height: 136,
                                )
                              : Image.asset(
                                  WMSICons.NO_IMAGE,
                                  height: 136,
                                ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品社内備考1
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .instruction_input_form_detail_17,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                readOnly: true,
                                height: 136,
                                text: state.shipDetailData['company_note1'] !=
                                            '' &&
                                        state.shipDetailData['company_note1'] !=
                                            null
                                    ? state.shipDetailData['company_note1']
                                    : '',
                              ),
                            ],
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品社内備考2
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .instruction_input_form_detail_18,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                readOnly: true,
                                height: 136,
                                text: state.shipDetailData['company_note2'] !=
                                            '' &&
                                        state.shipDetailData['company_note2'] !=
                                            null
                                    ? state.shipDetailData['company_note2']
                                    : '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 24)),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //社内明細備考
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_12,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          height: 136,
                          maxLines: 5,
                          text: state.shipDetailData['note2'] != '' &&
                                  state.shipDetailData['note2'] != null
                              ? state.shipDetailData['note2']
                              : '',
                        ),

                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品写真2
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_6,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.shipDetailData['image2'] != null &&
                              state.shipDetailData['image2'] != '',
                          child: state.shipDetailData['image2'] != null &&
                                  state.shipDetailData['image2'] != ''
                              ? Image.network(
                                  state.shipDetailData['image2'],
                                  width: 136,
                                  height: 136,
                                )
                              : Image.asset(
                                  WMSICons.NO_IMAGE,
                                  height: 136,
                                ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品注意備考1
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .instruction_input_form_detail_19,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                readOnly: true,
                                height: 136,
                                text: state.shipDetailData['notice_note1'] !=
                                            '' &&
                                        state.shipDetailData['notice_note1'] !=
                                            null
                                    ? state.shipDetailData['notice_note1']
                                    : '',
                              ),
                            ],
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品注意備考2
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .instruction_input_form_detail_20,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                readOnly: true,
                                height: 136,
                                text: state.shipDetailData['notice_note2'] !=
                                            '' &&
                                        state.shipDetailData['notice_note2'] !=
                                            null
                                    ? state.shipDetailData['notice_note2']
                                    : '',
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
          ],
        );
      },
    );
  }
}
