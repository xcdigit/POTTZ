// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/current_flag_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/reserve_input_bloc.dart';
import '../bloc/reserve_input_model.dart';

/**
 * 内容：入荷予定入力明细详细-sp
 * 作者：luxy
 * 时间：2023/10/16
 */

class ReserveInputDetails extends StatefulWidget {
  int flag;
  int receiveId;
  ReserveInputDetails({super.key, required this.flag, required this.receiveId});

  @override
  State<ReserveInputDetails> createState() => _ReserveInputDetailsState();
}

class _ReserveInputDetailsState extends State<ReserveInputDetails> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    //入荷予定明细数据取出
    Map<String, dynamic> detailsData =
        StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocProvider<ReserveInputBloc>(
      create: (context) {
        return ReserveInputBloc(
          ReserveInputModel(
            rootContext: context,
            receiveId: widget.receiveId,
            companyId: companyId,
            customer: detailsData,
          ),
        );
      },
      child: BlocBuilder<ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
          return Material(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .reserve_input_17),
                              WMSInputboxWidget(
                                text: state.customer['receive_line_no']
                                    .toString(),
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'receive_line_no', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitleMust(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_3),
                              //商品名
                              WMSDropdownWidget(
                                saveInput: true,
                                dataList1: state.productList,
                                inputInitialValue: state.customer['name'],
                                inputRadius: 4,
                                inputSuffixIcon: Container(
                                  width: 24,
                                  height: 24,
                                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                ),
                                dropdownRadius: 4,
                                dropdownTitle: 'name',
                                selectedCallBack: (value) {
                                  if (value == '') {
                                    //其余相关商品信息赋值
                                    context
                                        .read<ReserveInputBloc>()
                                        .add(SaveOtherProductEvent({}));
                                  } else {
                                    //其余相关商品信息赋值
                                    context
                                        .read<ReserveInputBloc>()
                                        .add(SaveOtherProductEvent(value));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_2),
                              //商品コード
                              WMSInputboxWidget(
                                text: state.customer['code'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context
                                      .read<ReserveInputBloc>()
                                      .add(SetReceiveValueEvent('code', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitleMust(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_4),
                              //単価
                              WMSInputboxWidget(
                                text:
                                    state.customer['product_price'].toString(),
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'product_price', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitleMust(WMSLocalizations.i18n(context)!
                                  .reserve_input_13),
                              //入荷数量
                              WMSInputboxWidget(
                                text: state.customer['product_num'].toString(),
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'product_num', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_6),
                              //規格
                              WMSInputboxWidget(
                                text: state.customer['size'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context
                                      .read<ReserveInputBloc>()
                                      .add(SetReceiveValueEvent('size', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_11),
                              //消費期限
                              WMSInputboxWidget(
                                text: state.customer['limit_date'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'limit_date', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_12),
                              //ロット番号
                              WMSInputboxWidget(
                                text: state.customer['lot_no'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent('lot_no', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 72,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_13),
                              //シリアル
                              WMSInputboxWidget(
                                text: state.customer['serial_no'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent('serial_no', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 204,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .menu_content_2_5_10),
                              //仕入先明細備考
                              WMSInputboxWidget(
                                height: 136,
                                maxLines: 5,
                                text: state.customer['note1'].toString(),
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent('note1', value));
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 204,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .instruction_input_form_detail_12),
                              //社内明細備考
                              WMSInputboxWidget(
                                height: 136,
                                maxLines: 5,
                                text: state.customer['note2'].toString(),
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent('note2', value));
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 204,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_14),
                              //商品_写真１
                              Visibility(
                                visible: state.customer['image1'] == null ||
                                    state.customer['image1'] == '',
                                child: Image.asset(
                                  WMSICons.NO_IMAGE,
                                  width: 136,
                                  height: 136,
                                ),
                              ),
                              Visibility(
                                visible: state.customer['image1'] != null &&
                                    state.customer['image1'] != '' &&
                                    state.customer['image1']
                                        .toString()
                                        .contains('https'),
                                child: Image.network(
                                  state.customer['image1'].toString(),
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
                          height: 204,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_15),
                              //商品_写真2
                              Visibility(
                                visible: state.customer['image2'] == null ||
                                    state.customer['image2'] == '',
                                child: Image.asset(
                                  WMSICons.NO_IMAGE,
                                  width: 136,
                                  height: 136,
                                ),
                              ),
                              Visibility(
                                visible: state.customer['image2'] != null &&
                                    state.customer['image2'] != '' &&
                                    state.customer['image2']
                                        .toString()
                                        .contains('https'),
                                child: Image.network(
                                  state.customer['image2'].toString(),
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
                          height: 160,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_16),
                              //商品_社内備考１
                              WMSInputboxWidget(
                                height: 136,
                                maxLines: 5,
                                text:
                                    state.customer['company_note1'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'company_note1', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 160,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_18),
                              //商品_社内備考2
                              WMSInputboxWidget(
                                height: 136,
                                maxLines: 5,
                                text:
                                    state.customer['company_note2'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'company_note2', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 160,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_19),
                              //商品_注意備考1
                              WMSInputboxWidget(
                                height: 136,
                                maxLines: 5,
                                text: state.customer['notice_note1'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'notice_note1', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          height: 160,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _detailsTitle(WMSLocalizations.i18n(context)!
                                  .delivery_note_shipment_details_17),
                              //商品_注意備考2
                              WMSInputboxWidget(
                                height: 136,
                                maxLines: 5,
                                text: state.customer['notice_note2'].toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SetReceiveValueEvent(
                                          'notice_note2', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 36,
                      width: 80,
                      child: OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(44, 167, 176, 1),
                        ),
                        child: Text(
                          widget.flag == 1
                              ? WMSLocalizations.i18n(context)!
                                  .account_profile_registration
                              : WMSLocalizations.i18n(context)!
                                  .instruction_input_tab_button_update,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          //是否刷新
                          StoreProvider.of<WMSState>(context)
                              .dispatch(RefreshCurrentFlagAction(true));

                          if (widget.flag == 1) {
                            // 登录出荷指示值事件
                            context.read<ReserveInputBloc>().add(
                                registrationReceiveDetailFormEvent(
                                    context, state.customer, state.receiveId));
                          } else {
                            // 修正设定出荷指示值事件
                            context.read<ReserveInputBloc>().add(
                                SaveReceiveDetailFormEvent(
                                    context, state.customer));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                //占位
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // 明细标题
  _detailsTitle(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 明细标题-必须入力
  _detailsTitleMust(String title) {
    return Container(
      height: 24,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
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
    );
  }
}
