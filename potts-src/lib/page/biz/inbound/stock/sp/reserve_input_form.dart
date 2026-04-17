import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/page/biz/inbound/stock/bloc/reserve_input_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../redux/current_flag_reducer.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart'
    if (dart.library.html) '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_postal_code_widget.dart';
import '../../../../home/bloc/home_menu_bloc.dart';
import '../../../../home/bloc/home_menu_model.dart';
import '../bloc/reserve_input_bloc.dart' as reserve_input_bloc;

/**
 * 内容：入荷予定入力-sp
 * 作者：luxy
 * 时间：2023/10/13
 */

class ReserveInputForm extends StatefulWidget {
  const ReserveInputForm({super.key});

  @override
  State<ReserveInputForm> createState() => _ReserveInputFormState();
}

class _ReserveInputFormState extends State<ReserveInputForm> {
  // 初始化基本情報入力表单
  Widget _initFormBasic(ReserveInputModel state) {
    return BlocBuilder<reserve_input_bloc.ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
      if (state.customerList['receive_no'] != '' &&
          state.customerList['receive_no'] != null) {
        state.isOk = true;
        //入荷予定id赋值
        state.receiveId = state.customerList['id'];
      }

      return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SizedBox(
              height: 5,
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              WMSLocalizations.i18n(context)!.incoming_inspection_expected_id +
                  "：${state.customerList['receive_no'] ?? ''}",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 1,
            child: SizedBox(
              height: 20,
            ),
          ),
          // 入荷予定日
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .home_main_page_table_text1, //1
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
                  ),
                  WMSDateWidget(
                    text: state.customerList['rcv_sch_date'],
                    dateCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'rcv_sch_date', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 仕入先注文番号
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .menu_content_2_5_7, //2
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
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['order_no'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                            reserve_input_bloc.SetReserveValueEvent(
                                'order_no', value),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
          // 仕入先名
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.reserve_input_6, //3
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
                  ),
                  WMSDropdownWidget(
                    saveInput: true,
                    dataList1: state.supplierList,
                    inputInitialValue: state.customerList['name'].toString(),
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
                        // 设定出荷指示集合事件
                        context
                            .read<reserve_input_bloc.ReserveInputBloc>()
                            .add(reserve_input_bloc.SetReserveMapEvent({
                              'supplier_id': value,
                              'name': value,
                              'name_kana': value,
                              'postal_cd': value,
                              'addr_1': value,
                              'addr_2': value,
                              'addr_3': value,
                              'addr_tel': value,
                              'customer_fax': value,
                              'note1': value,
                            }));
                      } else if (value is String) {
                        // 设定出荷指示值事件
                        context.read<reserve_input_bloc.ReserveInputBloc>().add(
                            reserve_input_bloc.SetReserveValueEvent(
                                'name', value));
                      } else {
                        // 设定出荷指示集合事件
                        context
                            .read<reserve_input_bloc.ReserveInputBloc>()
                            .add(reserve_input_bloc.SetReserveMapEvent({
                              'supplier_id': value['id'],
                              'name': value['name'],
                              'name_kana': value['name_kana'],
                              'postal_cd': value['postal_cd'],
                              'addr_1': value['addr_1'],
                              'addr_2': value['addr_2'],
                              'addr_3': value['addr_3'],
                              'addr_tel': value['tel'],
                              'customer_fax': value['fax'],
                              'note1': value['company_note1'],
                            }));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          // カナ名称
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .supplier_basic_kana, //3
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
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['name_kana'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'name_kana', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 郵便番号
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .supplier_basic_zip_code, //3
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
                  ),
                  WMSPostalcodeWidget(
                    text: state.customerList['postal_cd'].toString(),
                    country: 'JP',
                    postalCodeCallBack: (value) {
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'postal_cd', value['postal_code']));
                      if (value['code'] == '0') {
                        //设定都道府县和市町村
                        context.read<reserve_input_bloc.ReserveInputBloc>().add(
                            reserve_input_bloc.SetReserveValueEvent(
                                'addr_1', value['data']['city']));
                        context.read<reserve_input_bloc.ReserveInputBloc>().add(
                            reserve_input_bloc.SetReserveValueEvent(
                                'addr_2', value['data']['region']));
                        context.read<reserve_input_bloc.ReserveInputBloc>().add(
                            reserve_input_bloc.SetReserveValueEvent(
                                'addr_3', value['data']['addr']));
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          // 都道府県
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.supplier_province, //3
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
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['addr_1'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'addr_1', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 市区町村
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.supplier_villages, //3
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
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['addr_2'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'addr_2', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 住所
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.supplier_address, //3
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
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['addr_3'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'addr_3', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 電話番号
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
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .supplier_contact_telephone_number, //3
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
                  ),
                  WMSInputboxWidget(
                    numberIME: true,
                    text: state.customerList['addr_tel'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'addr_tel', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // FAX番号
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
                          .supplier_contact_fax_number, //3
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['customer_fax'],
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'customer_fax', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 取込状態
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
                          .display_instruction_ingestion_state, //3
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['importerror_flg'],
                    readOnly: true,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'importerror_flg', value));
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
                      WMSLocalizations.i18n(context)!.reserve_input_7, //4
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    text: state.customerList['note1'],
                    height: 136,
                    maxLines: 5,
                    inputBoxCallBack: (value) {
                      // 设定出荷指示值事件
                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.SetReserveValueEvent(
                              'note1', value));
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
                      WMSLocalizations.i18n(context)!.reserve_input_8, //5
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: WMSInputboxWidget(
                      text: state.customerList['note2'],
                      height: 136,
                      maxLines: 5,
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context.read<reserve_input_bloc.ReserveInputBloc>().add(
                            reserve_input_bloc.SetReserveValueEvent(
                                'note2', value));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  // 初始化明細情報
  Widget _initTableBasic(ReserveInputModel state) {
    return BlocBuilder<reserve_input_bloc.ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
      return Container(
        child: Column(
          children: [
            //table一览
            getTable(state),
          ],
        ),
      );
    });
  }

  getTable(ReserveInputModel state) {
    return WMSTableWidget<reserve_input_bloc.ReserveInputBloc,
        ReserveInputModel>(
      needPageInfo: false,
      headTitle: 'id',
      columns: [
        {
          'key': 'id',
          'width': 0.5,
          'title': 'ID',
        },
        {
          'key': 'receive_line_no',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.reserve_input_17,
        },
        {
          'key': 'code',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.reserve_input_10,
        },
        {
          'key': 'name',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.reserve_input_11,
        },
        {
          'key': 'product_price',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.reserve_input_12,
        },
        {
          'key': 'product_num',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.reserve_input_13,
        },
        {
          'key': 'size',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.reserve_input_14,
        },
        {
          'key': 'importerror_flg',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!
              .display_instruction_ingestion_state,
        },
      ],
      operatePopupOptions: [
        {
          'title': WMSLocalizations.i18n(context)!.menu_content_2_5_11,
          'callback': (_, value) async {
            //入荷予定明细存入
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentParamAction(value));
            // 跳转页面
            context.read<HomeMenuBloc>().add(PageJumpEvent('/' +
                Config.PAGE_FLAG_2_1 +
                '/' +
                state.receiveId.toString() +
                '/details/0'));
          },
        },
        {
          'title': WMSLocalizations.i18n(context)!
              .instruction_input_table_operate_delete,
          'callback': (_, value) {
            // 删除弹窗
            _showDelDialog(value['receive_line_no'], context);
          },
        }
      ],
    );
  }

  //删除弹框
  _showDelDialog(String _text, BuildContext parentContext) {
    reserve_input_bloc.ReserveInputBloc bloc =
        context.read<reserve_input_bloc.ReserveInputBloc>();
    showDialog<bool>(
        context: context,
        builder: (context) {
          return BlocProvider<reserve_input_bloc.ReserveInputBloc>.value(
              value: bloc,
              child: BlocBuilder<reserve_input_bloc.ReserveInputBloc,
                  ReserveInputModel>(
                builder: (context, state) {
                  return WMSDiaLogWidget(
                    titleText: WMSLocalizations.i18n(context)!
                        .display_instruction_confirm_delete,
                    contentText:
                        WMSLocalizations.i18n(context)!.menu_content_2_5_6 +
                            _text +
                            WMSLocalizations.i18n(context)!
                                .display_instruction_delete,
                    buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                    buttonRightText:
                        WMSLocalizations.i18n(context)!.delivery_note_10,
                    onPressedLeft: () {
                      //关闭对话框并返回true
                      Navigator.of(context).pop(true);
                    },
                    onPressedRight: () async {
                      //关闭对话框并返回true
                      Navigator.of(context).pop(true);

                      context.read<reserve_input_bloc.ReserveInputBloc>().add(
                          reserve_input_bloc.delectEvent(parentContext, _text));
                    },
                  );
                },
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
        builder: (menuContext, menuState) {
      return BlocBuilder<reserve_input_bloc.ReserveInputBloc,
          ReserveInputModel>(builder: (context, state) {
        bool currentFlag =
            StoreProvider.of<WMSState>(context).state.currentFlag;
        if (currentFlag) {
          context
              //重新加载页面
              .read<reserve_input_bloc.ReserveInputBloc>()
              .add(reserve_input_bloc.InitEvent());
          StoreProvider.of<WMSState>(context)
              .dispatch(RefreshCurrentFlagAction(false));
        }
        // 判断当前下标
        if (state.currentIndex == Config.NUMBER_ZERO) {
          // 当前内容
          state.currentContent = _initFormBasic(state);
        } else if (state.currentIndex == Config.NUMBER_ONE) {
          // 当前内容
          state.currentContent = _initTableBasic(state);
        }
        return Material(
          color: Colors.white,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20)),
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: InstructionInputFormTab(
                          initFormBasic: _initFormBasic,
                          initTableBasic: _initTableBasic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      //表格内容
                      state.currentContent,
                      //明细行追加按钮
                      Visibility(
                        visible: state.currentIndex == Config.NUMBER_ONE,
                        child: GestureDetector(
                          onTap: () {
                            Map<String, dynamic> value = {};
                            //入荷予定明细存入
                            StoreProvider.of<WMSState>(context)
                                .dispatch(RefreshCurrentParamAction(value));
                            //跳转页面
                            context.read<HomeMenuBloc>().add(PageJumpEvent('/' +
                                Config.PAGE_FLAG_2_1 +
                                '/' +
                                state.receiveId.toString() +
                                '/details/1'));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 40),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add, // 使用自带的加号图标
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .reserve_input_15,
                                  style: TextStyle(
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: state.currentIndex == Config.NUMBER_ZERO,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: InstructionInputFormButton(
                      state: state,
                    ),
                  ),
                ),
              ),
              //占位
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      });
    });
  }
}

// 入荷予定入力-表单Tab
typedef TabContextBuilder = Widget Function(ReserveInputModel state);

// 入荷予定入力-表单Tab
// ignore: must_be_immutable
class InstructionInputFormTab extends StatefulWidget {
  // 初始化基本情報入力表单
  TabContextBuilder initFormBasic;
  TabContextBuilder initTableBasic;
  InstructionInputFormTab({
    super.key,
    required this.initFormBasic,
    required this.initTableBasic,
  });

  @override
  State<InstructionInputFormTab> createState() =>
      _InstructionInputFormTabState();
}

class _InstructionInputFormTabState extends State<InstructionInputFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, ReserveInputModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            if (state.isOk) {
              // 当前下标
              context.read<reserve_input_bloc.ReserveInputBloc>().add(
                  reserve_input_bloc.CurrentIndexChangeEvent(
                      tabItemList[i]['index']));
              // 判断下标
              if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 状态变更
                setState(() {
                  // 当前内容
                  state.currentContent = widget.initFormBasic(state);
                });
              } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
                // 状态变更
                setState(() {
                  // 当前内容
                  state.currentContent = widget.initTableBasic(state);
                });
              } else {
                // 状态变更
                setState(() {
                  // 当前内容
                  state.currentContent = Wrap();
                });
              }
            } else {
              WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(context)!.reserve_input_2 +
                    WMSLocalizations.i18n(context)!.input_text,
              );
            }
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: tabItemList[i]['index'] == state.currentIndex
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            constraints: BoxConstraints(
              minWidth: 108,
            ),
            child: Text(
              tabItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: tabItemList[i]['index'] == state.currentIndex
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
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.reserve_input_18,
      },
    ];

    return BlocBuilder<reserve_input_bloc.ReserveInputBloc, ReserveInputModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 入荷予定入力-表单按钮
class InstructionInputFormButton extends StatefulWidget {
  final ReserveInputModel state;
  const InstructionInputFormButton({super.key, required this.state});

  @override
  State<InstructionInputFormButton> createState() =>
      _InstructionInputFormButtonState();
}

class _InstructionInputFormButtonState
    extends State<InstructionInputFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList, ReserveInputModel state) {
    // 按钮列表
    List<Widget> buttonList = [];

    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          width: MediaQuery.of(context).size.width - 60,
          height: 40,
          alignment: Alignment.center,
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(44, 167, 176, 1),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(88, 40),
              ),
            ), //
            onPressed: () {
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 保存出荷指示表单事件
                context.read<reserve_input_bloc.ReserveInputBloc>().add(
                    reserve_input_bloc.SaveReceiveFormEvent(
                        context,
                        context
                            .read<reserve_input_bloc.ReserveInputBloc>()
                            .state
                            .customerList));
              }
            },
            child: Text(
              buttonItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: buttonItemList[i]['index'] == Config.NUMBER_ZERO
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(44, 167, 176, 1),
                height: 1.28,
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    ReserveInputModel state = widget.state;
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': !state.isOk
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList, widget.state),
    );
  }
}
