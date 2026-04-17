import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/inquiry_schedule_details_bloc.dart';
import '../bloc/inquiry_schedule_details_model.dart';

/**
 * 内容：入荷予定照会-明细表格
 * 作者：熊草云
 * 时间：2023/10/16
 */
class InquiryScheduleDetailsTable extends StatefulWidget {
  const InquiryScheduleDetailsTable({super.key});

  @override
  State<InquiryScheduleDetailsTable> createState() =>
      _InquiryScheduleDetailsTableState();
}

class _InquiryScheduleDetailsTableState
    extends State<InquiryScheduleDetailsTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InquiryScheduleDetailsBloc, InquiryScheduleDetailsModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(1),
          child: Column(
            children: [
              // 表格标题
              InquiryScheduleDetailsTableTitle(),
              // 表格内容
              InquiryScheduleDetailsTableContent(),
            ],
          ),
        );
      },
    );
  }
}

// 表格标题
class InquiryScheduleDetailsTableTitle extends StatefulWidget {
  const InquiryScheduleDetailsTableTitle({super.key});

  @override
  State<InquiryScheduleDetailsTableTitle> createState() =>
      _InquiryScheduleDetailsTableTitleState();
}

class _InquiryScheduleDetailsTableTitleState
    extends State<InquiryScheduleDetailsTableTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
            child: Text(
              WMSLocalizations.i18n(context)!.menu_content_2_5_12,
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
    );
  }
}

// 表格内容
class InquiryScheduleDetailsTableContent extends StatefulWidget {
  const InquiryScheduleDetailsTableContent({super.key});

  @override
  State<InquiryScheduleDetailsTableContent> createState() =>
      _InquiryScheduleDetailsTableContentState();
}

class _InquiryScheduleDetailsTableContentState
    extends State<InquiryScheduleDetailsTableContent> {
  // 显示明细弹窗
  _showDetailDialog() {
    InquiryScheduleDetailsBloc bloc =
        context.read<InquiryScheduleDetailsBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InquiryScheduleDetailsBloc>.value(
          value: bloc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  WMSLocalizations.i18n(context)!.delivery_note_8,
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
              width: 1072,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
              child: _showDetailDialogContent(),
            ),
          ),
        );
      },
    );
  }

  // 显示明细弹窗详情
  _showDetailDialogContent() {
    return BlocBuilder<InquiryScheduleDetailsBloc, InquiryScheduleDetailsModel>(
      builder: (context, state) {
        return ListView(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 入荷予定明細行No
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .inquiry_schedule_details_row_no),
                  WMSInputboxWidget(
                    text: state.receiveDetailCustomize['receive_line_no']
                        .toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('receive_line_no', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 単価
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_9),
                  WMSInputboxWidget(
                    text: state.receiveDetailCustomize['product_price']
                        .toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('product_price', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 規格
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_6),
                  WMSInputboxWidget(
                    text:
                        state.receiveDetailCustomize['prodect_size'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('prodect_size', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // ロット番号
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_12),
                  WMSInputboxWidget(
                    text: state.receiveDetailCustomize['lot_no'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context
                          .read<InquiryScheduleDetailsBloc>()
                          .add(SetReceiveDetailValueEvent('lot_no', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 仕入先明細備考
                  _detailDialogTitle(
                      WMSLocalizations.i18n(context)!.menu_content_2_5_10),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    text: state.receiveDetailCustomize['note1'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示明细值事件
                      context
                          .read<InquiryScheduleDetailsBloc>()
                          .add(SetReceiveDetailValueEvent('note1', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 商品_社内備考2
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_17),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    text: state.receiveDetailCustomize['company_note2']
                        .toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('company_note2', value));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 24),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商品コード
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_3),
                  WMSInputboxWidget(
                    text:
                        state.receiveDetailCustomize['product_code'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('product_code', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 入荷予定数
                  _detailDialogTitle(
                      WMSLocalizations.i18n(context)!.menu_content_2_5_9),
                  WMSInputboxWidget(
                    text:
                        state.receiveDetailCustomize['product_num'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('product_num', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 消費期限
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_11),
                  WMSDateWidget(
                    text: state.receiveDetailCustomize['limit_date'].toString(),
                    readOnly: true,
                    dateCallBack: (value) {
                      // 设定出荷指示值事件
                      context
                          .read<InquiryScheduleDetailsBloc>()
                          .add(SetReceiveDetailValueEvent('limit_date', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // シリアル
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_13),
                  WMSInputboxWidget(
                    text: state.receiveDetailCustomize['serial_no'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定入荷指示明细值事件
                      context
                          .read<InquiryScheduleDetailsBloc>()
                          .add(SetReceiveDetailValueEvent('serial_no', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 社内明細備考
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .instruction_input_form_detail_12),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    text: state.receiveDetailCustomize['note2'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示明细值事件
                      context
                          .read<InquiryScheduleDetailsBloc>()
                          .add(SetReceiveDetailValueEvent('note2', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 商品_注意備考１
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_18),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    text:
                        state.receiveDetailCustomize['notice_note1'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('notice_note1', value));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 24),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 商品名
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_4),
                  Visibility(
                    visible: true,
                    child: WMSInputboxWidget(
                      text: state.receiveDetailCustomize['product_name']
                          .toString(),
                      readOnly: true,
                      inputBoxCallBack: (value) {
                        // 设定入荷指示明细值事件
                        context.read<InquiryScheduleDetailsBloc>().add(
                            SetReceiveDetailValueEvent('product_name', value));
                      },
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: WMSDropdownWidget(
                      dataList1: state.productList,
                      inputInitialValue: state
                          .receiveDetailCustomize['product_name']
                          .toString(),
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
                      dropdownTitle: 'name',
                      selectedCallBack: (value) {
                        // 判断数值
                        if (value == '') {
                          // 设定入荷指示明细集合事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveDetailMapEvent({
                                'product_id': value,
                                'product_code': value,
                                'product_name': value,
                                'product_size': value,
                                'product_image1': value,
                                'product_image2': value,
                                'company_note1': value,
                                'company_note2': value,
                                'notice_note1': value,
                                'notice_note2': value,
                              }));
                        } else if (value is String) {
                          // 设定入荷指示明细值事件
                          context.read<InquiryScheduleDetailsBloc>().add(
                              SetReceiveDetailValueEvent(
                                  'product_name', value));
                        } else {
                          // 设定入荷指示明细集合事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveDetailMapEvent({
                                'product_id': value['id'],
                                'product_code': value['code'],
                                'product_name': value['name'],
                                'product_size': value['size'],
                                'product_image1': value['image1'],
                                'product_image2': value['image2'],
                                'company_note1': value['company_note1'],
                                'company_note2': value['company_note2'],
                                'notice_note1': value['notice_note1'],
                                'notice_note2': value['notice_note2'],
                              }));
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 商品写真1
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .instruction_input_form_detail_5),
                  Visibility(
                    visible: state.receiveDetailCustomize['product_image1'] ==
                            null ||
                        state.receiveDetailCustomize['product_image1'] == '',
                    child: Image.asset(
                      WMSICons.NO_IMAGE,
                      width: 136,
                      height: 136,
                    ),
                  ),
                  Visibility(
                    visible: state.receiveDetailCustomize['product_image1'] !=
                            null &&
                        state.receiveDetailCustomize['product_image1'] != '',
                    child: Image.network(
                      state.receiveDetailCustomize['product_image1'].toString(),
                      width: 136,
                      height: 136,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 商品写真2
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .instruction_input_form_detail_6),
                  Visibility(
                    visible: state.receiveDetailCustomize['product_image2'] ==
                            null ||
                        state.receiveDetailCustomize['product_image2'] == '',
                    child: Image.asset(
                      WMSICons.NO_IMAGE,
                      width: 136,
                      height: 136,
                    ),
                  ),
                  Visibility(
                    visible: state.receiveDetailCustomize['product_image2'] !=
                            null &&
                        state.receiveDetailCustomize['product_image2'] != '',
                    child: Image.network(
                      state.receiveDetailCustomize['product_image2'].toString(),
                      width: 136,
                      height: 136,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 商品_社内備考１
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_16),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    text: state.receiveDetailCustomize['company_note1']
                        .toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('company_note1', value));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                  ),
                  // 商品_注意備考2
                  _detailDialogTitle(WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_19),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    text:
                        state.receiveDetailCustomize['notice_note2'].toString(),
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示明细值事件
                      context.read<InquiryScheduleDetailsBloc>().add(
                          SetReceiveDetailValueEvent('notice_note2', value));
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 明细弹窗标题
  _detailDialogTitle(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 删除弹窗
  _deleteDialog(int id) {
    InquiryScheduleDetailsBloc bloc =
        context.read<InquiryScheduleDetailsBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InquiryScheduleDetailsBloc>.value(
          value: bloc,
          child: BlocBuilder<InquiryScheduleDetailsBloc,
              InquiryScheduleDetailsModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .menu_content_2_5_11 +
                    '：' +
                    id.toString() +
                    ' ' +
                    WMSLocalizations.i18n(context)!.display_instruction_delete,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 删除入荷指示明细事件
                  context
                      .read<InquiryScheduleDetailsBloc>()
                      .add(DeleteReceiveDetailEvent(id));
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
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.all(24),
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            WMSTableWidget<InquiryScheduleDetailsBloc,
                InquiryScheduleDetailsModel>(
              columns: [
                {
                  'key': 'id',
                  'width': 0.2,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_8,
                },
                {
                  'key': 'receive_line_no',
                  'width': 0.4,
                  'title': WMSLocalizations.i18n(context)!
                      .inquiry_schedule_details_row_no,
                },
                {
                  'key': 'product_code',
                  'width': 0.4,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_3,
                },
                {
                  'key': 'product_name',
                  'width': 0.4,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_4,
                },
                {
                  'key': 'product_price',
                  'width': 0.2,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_9,
                },
                {
                  'key': 'product_num',
                  'width': 0.3,
                  'title': WMSLocalizations.i18n(context)!.menu_content_2_5_9,
                },
                {
                  'key': 'prodect_size',
                  'width': 0.4,
                  'title': WMSLocalizations.i18n(context)!
                      .delivery_note_shipment_details_6,
                },
                {
                  'key': 'importerror_flg_name',
                  'width': 0.8,
                  'title': WMSLocalizations.i18n(context)!
                      .display_instruction_ingestion_state,
                },
              ],
              operatePopupOptions: [
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_details,
                  'callback': (_, value) async {
                    // 查询入荷指示明细事件
                    bool tempBool = await context
                        .read<InquiryScheduleDetailsBloc>()
                        .queryReceiveDetailEvent(value['id'], context);
                    // 判断临时标记
                    if (tempBool) {
                      // 显示明细弹窗
                      _showDetailDialog();
                    }
                  },
                },
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) async {
                    // 检查可操作状态
                    bool checkFlag = await context
                        .read<InquiryScheduleDetailsBloc>()
                        .checkOperationalStatus('2');
                    // 检查结果
                    if (checkFlag) {
                      // 删除弹窗
                      _deleteDialog(value['id']);
                    }
                  },
                }
              ],
              showCheckboxColumn: false,
            ),
          ],
        ),
      ),
    );
  }
}
