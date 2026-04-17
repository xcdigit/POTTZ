import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/income_confirmation_detail_bloc.dart';
import '../bloc/income_confirmation_detail_model.dart';

/**
 * 内容：入荷確定 -文件
 * 作者：熊草云
 * 时间：2023/08/24
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];
// ignore_for_file: must_be_immutable

class IncomeConfirmationDetail extends StatefulWidget {
  //入荷予定id
  int receiveId = 0;
  String receiveNo = '';
  IncomeConfirmationDetail(
      {super.key, this.receiveId = 0, this.receiveNo = ''});

  @override
  State<IncomeConfirmationDetail> createState() =>
      _IncomeConfirmationDetailState();
}

class _IncomeConfirmationDetailState extends State<IncomeConfirmationDetail> {
  //定义接受对象
  Map<String, dynamic> currentParam = {};
  // 初始化出荷确定明細

  BlocBuilder<IncomeConfirmationDetailBloc, IncomeConfirmationDetailModel>
      _initDetails() {
    return BlocBuilder<IncomeConfirmationDetailBloc,
        IncomeConfirmationDetailModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //入荷予定番号
                    Container(
                      height: 37,
                      child: Text(
                        WMSLocalizations.i18n(context)!.menu_content_2_5_6 +
                            ':',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                    Container(
                      height: 37,
                      child: Text(
                        widget.receiveNo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //入荷予定日
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .Warehouse_Query_Commodity_Search_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      text: state.receiveDetailCustomize['rcv_sch_date'] !=
                                  '' &&
                              state.receiveDetailCustomize['rcv_sch_date'] !=
                                  null
                          ? state.receiveDetailCustomize['rcv_sch_date']
                          : '',
                    )
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //仕入先
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
                      text: state.receiveDetailCustomize['name'] != '' &&
                              state.receiveDetailCustomize['name'] != null
                          ? state.receiveDetailCustomize['name']
                          : '',
                    )
                  ],
                ),
              ),
            ),
            //仕入先備考
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.reserve_input_7,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      readOnly: true,
                      height: 116,
                      maxLines: 5,
                      text: state.receiveDetailCustomize['note1'] != '' &&
                              state.receiveDetailCustomize['note1'] != null
                          ? state.receiveDetailCustomize['note1']
                          : '',
                    )
                  ],
                ),
              ),
            ),
            //社内備考
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 140,
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
                      height: 116,
                      maxLines: 5,
                      text: state.receiveDetailCustomize['note2'] != '' &&
                              state.receiveDetailCustomize['note2'] != null
                          ? state.receiveDetailCustomize['note2']
                          : '',
                    )
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
    return BlocProvider<IncomeConfirmationDetailBloc>(
      create: (context) {
        return IncomeConfirmationDetailBloc(
          IncomeConfirmationDetailModel(
              rootBuildContext: context, receiveId: widget.receiveId),
        );
      },
      child: BlocBuilder<IncomeConfirmationDetailBloc,
          IncomeConfirmationDetailModel>(
        builder: (context, state) {
          return ListView(
            //垂直列表
            scrollDirection: Axis.vertical,
            children: [
              // 入荷明細-内容
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: _initDetails(),
                ),
              ),
              // 入荷确定 明細一览-标题
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    Container(
                      height: 30,
                      margin: EdgeInsets.fromLTRB(20, 60, 0, 0),
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .income_confirmation_list,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.0,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 入荷确定 明細一览-内容
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    children: [
                      //表格内容
                      IncomeConfirmationTableDetailContent(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// 入荷确定详细-表格内容
class IncomeConfirmationTableDetailContent extends StatefulWidget {
  const IncomeConfirmationTableDetailContent({super.key});

  @override
  State<IncomeConfirmationTableDetailContent> createState() =>
      _IncomeConfirmationTableDetailContentState();
}

class _IncomeConfirmationTableDetailContentState
    extends State<IncomeConfirmationTableDetailContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeConfirmationDetailBloc,
        IncomeConfirmationDetailModel>(
      builder: (context, state) {
        return WMSTableWidget<IncomeConfirmationDetailBloc,
            IncomeConfirmationDetailModel>(
          operatePopupHeight: 140,
          headTitle: 'id',
          columns: [
            //NO
            {
              'key': 'id',
              'width': 0.5,
              'title': 'ID',
            },
            //商品コード
            {
              'key': 'product_code',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_2,
            },
            //商品名
            {
              'key': 'product_name',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_3,
            },
            //単価
            {
              'key': 'product_price',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_4,
            },
            //入庫数
            {
              'key': 'store_num',
              'width': 0.5,
              'title':
                  WMSLocalizations.i18n(context)!.goods_receipt_input_number,
            },
            //規格
            {
              'key': 'product_size',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_6,
            },
            //入荷确定状态
            {
              'key': 'confirm_kbn_msg',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .display_instruction_receive_detail_status,
            },
            // 小計
            {
              'key': 'subtotal',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_7,
            },
          ],
          operatePopupOptions: [
            {
              //明细
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_tab_button_details,
              'callback': (_, value) async {
                if (value != null) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ReceiveDetailDialog(detailData: value);
                      });
                }
              }
            },
            {
              //取消
              'title': WMSLocalizations.i18n(context)!.table_tab_cancel,
              'callback': (_, value) {
                if (value != null) {
                  //1、已经取消过不能在进行取消
                  if (value['confirm_kbn'] != null &&
                      value['confirm_kbn'] != '') {
                    if (value['confirm_kbn'] == '2') {
                      _showTipDialog(WMSLocalizations.i18n(context)!
                          .income_confirmation_text_1);
                      return false;
                    }
                  }
                  if (state.receiveData.length > 0) {
                    if (state.receiveData['csv_kbn'] == '1') {
                      _WarningDialog(
                          WMSLocalizations.i18n(context)!.income_cancel_error,
                          state.receiveData,
                          value['id'],
                          context);
                    } else {
                      context.read<IncomeConfirmationDetailBloc>().add(
                          updateReceiveEvent(
                              state.receiveData, value['id'], context));
                    }
                  }
                }
              },
            },
          ],
        );
      },
    );
  }

// 警告弹窗
  _WarningDialog(String text, Map<String, dynamic> receiveData, int detailId,
      BuildContext parentContext) {
    IncomeConfirmationDetailBloc bloc =
        context.read<IncomeConfirmationDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<IncomeConfirmationDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<IncomeConfirmationDetailBloc,
              IncomeConfirmationDetailModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText: text,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.table_tab_confirm,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  bloc.add(updateReceiveEvent(receiveData, detailId, context));
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
}

//详细弹窗
class ReceiveDetailDialog extends StatefulWidget {
  final Map detailData;

  const ReceiveDetailDialog({super.key, required this.detailData});

  @override
  State<ReceiveDetailDialog> createState() => _ReceiveDetailDialogState();
}

class _ReceiveDetailDialogState extends State<ReceiveDetailDialog> {
  //弹框中间内容
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
                Navigator.of(context).pop(); //关闭对话框
              },
            ),
          ),
        ],
      ),
      content: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   border: Border.all(
        //     color: Color.fromRGBO(224, 224, 224, 1),
        //   ),
        // ),
        width: MediaQuery.of(context).size.width * .8,
        child: ListView(
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: [
                //入荷予定明細行No
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .menu_content_60_2_12_1_1,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['receive_line_no'] != '' &&
                                  widget.detailData['receive_line_no'] != null
                              ? widget.detailData['receive_line_no'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //商品コード
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_2,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['product_code'] != '' &&
                                  widget.detailData['product_code'] != null
                              ? widget.detailData['product_code'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //商品名
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_3,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['product_name'] != '' &&
                                  widget.detailData['product_name'] != null
                              ? widget.detailData['product_name'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //单价
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_4,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['product_price'] != '' &&
                                  widget.detailData['product_price'] != null
                              ? widget.detailData['product_price'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //入库数
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .goods_receipt_input_number,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['store_num'] != '' &&
                                  widget.detailData['store_num'] != null
                              ? widget.detailData['store_num'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                // 规格
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          text: widget.detailData['product_size'] != '' &&
                                  widget.detailData['product_size'] != null
                              ? widget.detailData['product_size'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //消费期限
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_11,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['limit_date'] != '' &&
                                  widget.detailData['limit_date'] != null
                              ? widget.detailData['limit_date'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //ロット番号
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_12,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['lot_no'] != '' &&
                                  widget.detailData['lot_no'] != null
                              ? widget.detailData['lot_no'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                //シリアル
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_13,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                        ),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: widget.detailData['serial_no'] != '' &&
                                  widget.detailData['serial_no'] != null
                              ? widget.detailData['serial_no'].toString()
                              : '',
                        ),
                      ],
                    ),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 162,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //仕入先明細備考
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .menu_content_2_5_10,
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
                              text: widget.detailData['note1'] != '' &&
                                      widget.detailData['note1'] != null
                                  ? widget.detailData['note1'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                      //商品_社内備考１
                      Container(
                        height: 162,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_16,
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
                              text: widget.detailData['company_note1'] != '' &&
                                      widget.detailData['company_note1'] != null
                                  ? widget.detailData['company_note1']
                                      .toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                      //商品_注意備考１
                      Container(
                        height: 162,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_18,
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
                              text: widget.detailData['notice_note1'] != '' &&
                                      widget.detailData['notice_note1'] != null
                                  ? widget.detailData['notice_note1'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    children: [
                      //社内明細備考
                      Container(
                        height: 162,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              height: 136,
                              maxLines: 5,
                              readOnly: true,
                              text: widget.detailData['note2'] != '' &&
                                      widget.detailData['note2'] != null
                                  ? widget.detailData['note2'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 162,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //商品_社内備考2
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_17,
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
                              text: widget.detailData['company_note2'] != '' &&
                                      widget.detailData['company_note2'] != null
                                  ? widget.detailData['company_note2']
                                      .toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 162,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //商品_注意備考2
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_19,
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
                              text: widget.detailData['notice_note2'] != '' &&
                                      widget.detailData['notice_note2'] != null
                                  ? widget.detailData['notice_note2'].toString()
                                  : '',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Column(
                    children: [
                      //商品_写真１
                      Container(
                        height: 243,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_14,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.detailData['image1'] != null &&
                                  widget.detailData['image1'] != '',
                              child: widget.detailData['image1'] != null &&
                                      widget.detailData['image1'] != ''
                                  ? Image.network(
                                      widget.detailData['image1'],
                                      width: 136,
                                      height: 136,
                                    )
                                  : Image.asset(
                                      WMSICons.NO_IMAGE,
                                      height: 136,
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 243,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //商品_写真2
                            Container(
                              height: 24,
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_shipment_details_15,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.detailData['image2'] != null &&
                                  widget.detailData['image2'] != '',
                              child: widget.detailData['image2'] != null &&
                                      widget.detailData['image2'] != ''
                                  ? Image.network(
                                      widget.detailData['image2'],
                                      width: 136,
                                      height: 136,
                                    )
                                  : Image.asset(
                                      WMSICons.NO_IMAGE,
                                      height: 136,
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
    );
  }
}
