import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/income_confirmation_detail_bloc.dart';
import '../bloc/income_confirmation_detail_model.dart';
import 'income_confirmation_page.dart';

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
                height: 37,
                // margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //入荷予定番号
                    Container(
                      height: 37,
                      child: Text(
                        WMSLocalizations.i18n(context)!.menu_content_2_5_6 +
                            ':' +
                            widget.receiveNo,
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
              widthFactor: 0.4,
              child: Container(
                height: 120,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
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
              widthFactor: 0.4,
              child: Container(
                height: 120,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
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
              widthFactor: 0.4,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                      height: 136,
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
              widthFactor: 0.4,
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
                      text: state.receiveDetailCustomize['note2'] != '' &&
                              state.receiveDetailCustomize['note2'] != null
                          ? state.receiveDetailCustomize['note2']
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
              // 入确定明細-标题
              FractionallySizedBox(
                widthFactor: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 84,
                      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: Text(
                        WMSLocalizations.i18n(context)!.menu_content_60_2_12_1,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          height: 1.0,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                    // 返回按钮
                    Container(
                      color: Colors.white,
                      height: 35,
                      width: 80,
                      margin: EdgeInsets.only(top: 10, right: 20),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IncomeConfirmationPage(),
                                ),
                              );
                              // // 持久化状态更新
                              // StoreProvider.of<WMSState>(context).dispatch(
                              //     RefreshCurrentPageAction(Config.PAGE_FLAG_2_12));
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
              ),
              // 入荷明細-内容
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                          fontSize: 24,
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
                      IncomeConfirmationDetailContent(),
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

class IncomeConfirmationDetailContent extends StatefulWidget {
  const IncomeConfirmationDetailContent({super.key});

  @override
  State<IncomeConfirmationDetailContent> createState() =>
      _IncomeConfirmationDetailContentState();
}

class _IncomeConfirmationDetailContentState
    extends State<IncomeConfirmationDetailContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeConfirmationDetailBloc,
        IncomeConfirmationDetailModel>(builder: (context, state) {
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
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    IncomeConfirmationTableDetailContent(),
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
          columns: [
            //NO
            {
              'key': 'id',
              'width': 1,
              'title': 'ID',
            },
            //商品コード
            {
              'key': 'product_code',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_2,
            },
            //商品名
            {
              'key': 'product_name',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_3,
            },
            //単価
            {
              'key': 'product_price',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_4,
            },
            //入庫数
            {
              'key': 'store_num',
              'width': 2,
              'title':
                  WMSLocalizations.i18n(context)!.goods_receipt_input_number,
            },
            //規格
            {
              'key': 'product_size',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_6,
            },
            //入荷确定状态
            {
              'key': 'confirm_kbn_msg',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .display_instruction_receive_detail_status,
            },
            // 小計
            {
              'key': 'subtotal',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_7,
            },
          ],
          showCheckboxColumn: true,
          operatePopupOptions: [
            {
              //明细
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_tab_button_details,
              'callback': (_, value) async {
                if (value != null) {
                  bool tempBool = await context
                      .read<IncomeConfirmationDetailBloc>()
                      .QueryIncomeDetailEvent(context, value['id']);
                  if (tempBool) {
                    _showDetailDialog();
                  }
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
                    //连携济 警告弹窗
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
                  bloc.add(
                      updateReceiveEvent(receiveData, detailId, parentContext));
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
    IncomeConfirmationDetailBloc bloc =
        context.read<IncomeConfirmationDetailBloc>();
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<IncomeConfirmationDetailBloc>.value(
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
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                ),
                width: 1100,
                child: _showDialogContent(),
              ),
            ),
          );
        });
  }

  //弹框中间内容
  _showDialogContent() {
    return BlocBuilder<IncomeConfirmationDetailBloc,
        IncomeConfirmationDetailModel>(
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
                        //入荷予定明細行No
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
                          text: state.receiveDetailData['receive_line_no'] !=
                                      '' &&
                                  state.receiveDetailData['receive_line_no'] !=
                                      null
                              ? state.receiveDetailData['receive_line_no']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品コード
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
                          text: state.receiveDetailData['product_code'] != '' &&
                                  state.receiveDetailData['product_code'] !=
                                      null
                              ? state.receiveDetailData['product_code']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品名

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
                          text: state.receiveDetailData['product_name'] != '' &&
                                  state.receiveDetailData['product_name'] !=
                                      null
                              ? state.receiveDetailData['product_name']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
//单价

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
                          text: state.receiveDetailData['product_price'] !=
                                      '' &&
                                  state.receiveDetailData['product_price'] !=
                                      null
                              ? state.receiveDetailData['product_price']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //入库数

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
                          text: state.receiveDetailData['store_num'] != '' &&
                                  state.receiveDetailData['store_num'] != null
                              ? state.receiveDetailData['store_num'].toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        // 规格

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
                          text: state.receiveDetailData['product_size'] != '' &&
                                  state.receiveDetailData['product_size'] !=
                                      null
                              ? state.receiveDetailData['product_size']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //消费期限

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
                          text: state.receiveDetailData['limit_date'] != '' &&
                                  state.receiveDetailData['limit_date'] != null
                              ? state.receiveDetailData['limit_date'].toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //ロット番号

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
                          text: state.receiveDetailData['lot_no'] != '' &&
                                  state.receiveDetailData['lot_no'] != null
                              ? state.receiveDetailData['lot_no'].toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //シリアル

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
                          text: state.receiveDetailData['serial_no'] != '' &&
                                  state.receiveDetailData['serial_no'] != null
                              ? state.receiveDetailData['serial_no'].toString()
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
                        //仕入先明細備考
                        Container(
                          height: 24,
                          child: Text(
                            WMSLocalizations.i18n(context)!.menu_content_2_5_10,
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
                          text: state.receiveDetailData['note1'] != '' &&
                                  state.receiveDetailData['note1'] != null
                              ? state.receiveDetailData['note1'].toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
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
                          height: 136,
                          maxLines: 5,
                          readOnly: true,
                          text: state.receiveDetailData['note2'] != '' &&
                                  state.receiveDetailData['note2'] != null
                              ? state.receiveDetailData['note2'].toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品_写真１
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
                          visible: state.receiveDetailData['image1'] != null &&
                              state.receiveDetailData['image1'] != '',
                          child: state.receiveDetailData['image1'] != null &&
                                  state.receiveDetailData['image1'] != ''
                              ? Image.network(
                                  state.receiveDetailData['image1'],
                                  width: 136,
                                  height: 136,
                                )
                              : Image.asset(
                                  WMSICons.NO_IMAGE,
                                  height: 136,
                                ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
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
                          visible: state.receiveDetailData['image2'] != null &&
                              state.receiveDetailData['image2'] != '',
                          child: state.receiveDetailData['image2'] != null &&
                                  state.receiveDetailData['image2'] != ''
                              ? Image.network(
                                  state.receiveDetailData['image2'],
                                  width: 136,
                                  height: 136,
                                )
                              : Image.asset(WMSICons.NO_IMAGE, height: 136),
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
//商品_社内備考１
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
                          text: state.receiveDetailData['company_note1'] !=
                                      '' &&
                                  state.receiveDetailData['company_note1'] !=
                                      null
                              ? state.receiveDetailData['company_note1']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
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
                          text: state.receiveDetailData['company_note2'] !=
                                      '' &&
                                  state.receiveDetailData['company_note2'] !=
                                      null
                              ? state.receiveDetailData['company_note2']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
                        //商品_注意備考１
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
                          text: state.receiveDetailData['notice_note1'] != '' &&
                                  state.receiveDetailData['notice_note1'] !=
                                      null
                              ? state.receiveDetailData['notice_note1']
                                  .toString()
                              : '',
                        ),
                        new Padding(padding: EdgeInsets.only(top: 16)),
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
                          text: state.receiveDetailData['notice_note2'] != '' &&
                                  state.receiveDetailData['notice_note2'] !=
                                      null
                              ? state.receiveDetailData['notice_note2']
                                  .toString()
                              : '',
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

// 商品合计
class Subtotal extends StatefulWidget {
  const Subtotal({Key? key}) : super(key: key);

  @override
  State<Subtotal> createState() => _SubtotalState();
}

class _SubtotalState extends State<Subtotal> {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 16),
      child: Column(
        children: [
          Divider(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(flex: 4, child: Container()),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(WMSLocalizations.i18n(context)!
                        .delivery_note_shipment_details_8),
                    Text("40"),
                    Text(WMSLocalizations.i18n(context)!
                        .delivery_note_shipment_details_9),
                    Text("2000")
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
