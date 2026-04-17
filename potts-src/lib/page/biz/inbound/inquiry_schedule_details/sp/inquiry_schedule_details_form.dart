import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/widget/wms_date_widget.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/inquiry_schedule_details_bloc.dart';
import '../bloc/inquiry_schedule_details_model.dart';

/**
 * 内容：入荷予定照会-明细表单
 * 作者：熊草云
 * 时间：2023/10/16
 */

class InquiryScheduleDetailsForm extends StatefulWidget {
  const InquiryScheduleDetailsForm({super.key});

  @override
  State<InquiryScheduleDetailsForm> createState() =>
      _InquiryScheduleDetailsFormState();
}

class _InquiryScheduleDetailsFormState
    extends State<InquiryScheduleDetailsForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InquiryScheduleDetailsBloc, InquiryScheduleDetailsModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 表单内容
            InquiryScheduleDetailsFormContent(),
          ],
        );
      },
    );
  }
}

// 表单内容
class InquiryScheduleDetailsFormContent extends StatefulWidget {
  const InquiryScheduleDetailsFormContent({super.key});

  @override
  State<InquiryScheduleDetailsFormContent> createState() =>
      _InquiryScheduleDetailsFormContentState();
}

class _InquiryScheduleDetailsFormContentState
    extends State<InquiryScheduleDetailsFormContent> {
  _deleteDialog() {
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
                        .home_main_page_text6 +
                    '：' +
                    state.receiveId.toString() +
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
                  // 删除入荷指示事件
                  context
                      .read<InquiryScheduleDetailsBloc>()
                      .add(DeleteReceiveEvent());
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

  // 初始化按钮弹窗单条
  List<Widget> _initButtonDialogItem(
      BuildContext context, List buttonDialogOptions) {
    // 按钮弹窗单条列表
    List<Widget> buttonDialogItemList = [];
    // 循环按钮弹窗选项
    for (int i = 0; i < buttonDialogOptions.length; i++) {
      // 按钮弹窗单条列表
      buttonDialogItemList.add(
        GestureDetector(
          onTap: () async {
            // 判断下标
            if (buttonDialogOptions[i]['index'] == Config.NUMBER_ZERO) {
              // 检查可操作状态
              bool checkFlag = await context
                  .read<InquiryScheduleDetailsBloc>()
                  .checkOperationalStatus('1');
              // 检查结果
              if (checkFlag) {
                // 关闭
                Navigator.pop(context);
                // 跳转页面
                GoRouter.of(context).go(
                  '/' +
                      Config.PAGE_FLAG_2_1 +
                      '/' +
                      context
                          .read<InquiryScheduleDetailsBloc>()
                          .state
                          .receiveId
                          .toString(),
                );
              } else {
                // 关闭
                Navigator.pop(context);
              }
            } else if (buttonDialogOptions[i]['index'] == Config.NUMBER_ONE) {
              // 检查可操作状态
              bool checkFlag = await context
                  .read<InquiryScheduleDetailsBloc>()
                  .checkOperationalStatus('2');
              // 检查结果
              if (checkFlag) {
                // 关闭
                Navigator.pop(context);
                // 删除弹窗
                _deleteDialog();
              } else {
                // 关闭
                Navigator.pop(context);
              }
            }
          },
          child: Container(
            width: 148,
            height: 37,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              buttonDialogOptions[i]['title'],
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(44, 167, 176, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }
    // 按钮弹窗单条列表
    return buttonDialogItemList;
  }

  // 初始化按钮弹窗
  _initButtonDialog(List buttonDialogOptions) {
    InquiryScheduleDetailsBloc bloc =
        context.read<InquiryScheduleDetailsBloc>();
    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(255, 255, 255, 0),
      builder: (context) {
        return BlocProvider<InquiryScheduleDetailsBloc>.value(
          value: bloc,
          child: BlocBuilder<InquiryScheduleDetailsBloc,
              InquiryScheduleDetailsModel>(
            builder: (context, state) {
              return Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned(
                      top: 130,
                      right: 21,
                      child: Container(
                        width: 148,
                        height: 134,
                        padding: EdgeInsets.fromLTRB(0, 22, 0, 22),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(156, 156, 156, 0.36),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: _initButtonDialogItem(
                              context, buttonDialogOptions),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 初始化表单
  Widget _initForm(List buttonDialogOptions) {
    return BlocBuilder<InquiryScheduleDetailsBloc, InquiryScheduleDetailsModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(1),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  // height: 37,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 6.5, 0, 6.5),
                          child: Text(
                            "${WMSLocalizations.i18n(context)!.menu_content_2_5_6}： ${state.receiveCustomize['receive_no'] == null ? '' : state.receiveCustomize['receive_no'].toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Color.fromRGBO(44, 167, 176, 1),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // width: 65,
                        height: 37,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(44, 167, 176, 1),
                            ),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.only(left: 10, right: 10)),
                          ),
                          onPressed: () {
                            // 初始化按钮弹窗
                            _initButtonDialog(buttonDialogOptions);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_32,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 14,
                              )
                            ],
                          ),
                        ),
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .Warehouse_Query_Commodity_Search_2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSDateWidget(
                        readOnly: true,
                        text: state.receiveCustomize['rcv_sch_date'].toString(),
                        dateCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('rcv_sch_date', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.menu_content_2_5_7,
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
                        text: state.receiveCustomize['order_no'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('order_no', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.reserve_input_6,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: WMSInputboxWidget(
                          readOnly: true,
                          text: state.receiveCustomize['name'].toString(),
                          inputBoxCallBack: (value) {
                            // 设定入荷指示值事件
                            context
                                .read<InquiryScheduleDetailsBloc>()
                                .add(SetReceiveValueEvent('name', value));
                          },
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: WMSDropdownWidget(
                          saveInput: true,
                          dataList1: state.supplierList,
                          inputInitialValue:
                              state.receiveCustomize['name'].toString(),
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
                            // 判断数值
                            if (value == '') {
                              // 设定入荷指示集合事件
                              context
                                  .read<InquiryScheduleDetailsBloc>()
                                  .add(SetReceiveMapEvent({
                                    'supplier_id': value,
                                    'name': value,
                                    'name_kana': value,
                                    'postal_cd': value,
                                    'addr_1': value,
                                    'addr_2': value,
                                    'addr_3': value,
                                    'addr_tel': value,
                                    'customer_fax': value,
                                  }));
                            } else if (value is String) {
                              // 设定入荷指示值事件
                              context
                                  .read<InquiryScheduleDetailsBloc>()
                                  .add(SetReceiveValueEvent('name', value));
                            } else {
                              // 设定入荷指示集合事件
                              context
                                  .read<InquiryScheduleDetailsBloc>()
                                  .add(SetReceiveMapEvent({
                                    'supplier_id': value['id'],
                                    'name': value['name'],
                                    'name_kana': value['name_kana'],
                                    'postal_cd': value['postal_cd'],
                                    'addr_1': value['addr_1'],
                                    'addr_2': value['addr_2'],
                                    'addr_3': value['addr_3'],
                                    'addr_tel': value['tel'],
                                    'customer_fax': value['fax'],
                                  }));
                            }
                          },
                        ),
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .delivery_form_canaName,
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
                        text: state.receiveCustomize['name_kana'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('name_kana', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .delivery_table_zipCode,
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
                        text: state.receiveCustomize['postal_cd'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('postal_cd', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .delivery_table_prefecture,
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
                        text: state.receiveCustomize['addr_1'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('addr_1', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .delivery_table_municipal,
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
                        text: state.receiveCustomize['addr_2'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('addr_2', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .delivery_table_address,
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
                        text: state.receiveCustomize['addr_3'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('addr_3', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_table_tel,
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
                        text: state.receiveCustomize['addr_tel'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('addr_tel', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_table_fax,
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
                        text: state.receiveCustomize['customer_fax'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('customer_fax', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .display_instruction_ingestion_state,
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
                        height: 136,
                        maxLines: 5,
                        text: state.receiveCustomize['importerror_flg_name']
                            .toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context.read<InquiryScheduleDetailsBloc>().add(
                              SetReceiveValueEvent(
                                  'importerror_flg_name', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.reserve_input_7,
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
                        height: 136,
                        maxLines: 5,
                        text: state.receiveCustomize['note1'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('note1', value));
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
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.reserve_input_8,
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
                        height: 136,
                        maxLines: 5,
                        text: state.receiveCustomize['note2'].toString(),
                        inputBoxCallBack: (value) {
                          // 设定入荷指示值事件
                          context
                              .read<InquiryScheduleDetailsBloc>()
                              .add(SetReceiveValueEvent('note2', value));
                        },
                      ),
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

  @override
  Widget build(BuildContext context) {
    // 删除弹窗
    // 按钮弹窗选项
    List _buttonDialogOptions = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_update
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!
            .instruction_input_table_operate_delete
      },
    ];

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        child: _initForm(_buttonDialogOptions),
      ),
    );
  }
}
