import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_postal_code_widget.dart';
import '../bloc/instruction_input_bloc.dart';
import '../bloc/instruction_input_model.dart';

/**
 * 内容：出荷指示入力-表单
 * 作者：赵士淞
 * 时间：2023/08/03
 */
// 当前悬停下标
int currentHoverIndex = Config.NUMBER_NEGATIVE;
// 当前内容
Widget currentContent = Wrap();

// ignore: must_be_immutable
class InstructionInputForm extends StatefulWidget {
  const InstructionInputForm({super.key});

  @override
  State<InstructionInputForm> createState() => _InstructionInputFormState();
}

class _InstructionInputFormState extends State<InstructionInputForm> {
  // 初始化基本情報入力表单
  Widget _initFormBasic(InstructionInputModel state) {
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 0.4,
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
                            .instruction_input_form_basic_1,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      key: Key('ship_no'),
                      text: state.shipCustomize['ship_no'].toString(),
                      readOnly: true,
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('ship_no', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
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
                                .instruction_input_form_basic_3,
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
                    WMSDateWidget(
                      key: Key('rcv_sch_date'),
                      text: state.shipCustomize['rcv_sch_date'].toString(),
                      dateCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('rcv_sch_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.4,
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
                                .instruction_input_form_basic_5,
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
                    WMSDateWidget(
                      key: Key('cus_rev_date'),
                      text: state.shipCustomize['cus_rev_date'].toString(),
                      dateCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('cus_rev_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_basic_12,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      key: Key('note1'),
                      height: 136,
                      maxLines: 5,
                      text: state.shipCustomize['note1'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('note1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
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
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_basic_13,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      key: Key('note2'),
                      height: 136,
                      maxLines: 5,
                      text: state.shipCustomize['note2'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('note2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 初始化出荷先情報入力表单
  Widget _initFormBefore(InstructionInputModel state) {
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 0.3,
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
                            .instruction_input_form_basic_2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      key: Key('order_no'),
                      text: state.shipCustomize['order_no'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('order_no', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                            .instruction_input_form_basic_6,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      key: Key('customer_id'),
                      text: state.shipCustomize['customer_id'].toString(),
                      readOnly: true,
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('customer_id', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_basic_4,
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
                    WMSDropdownWidget(
                      key: Key('customer_name'),
                      saveInput: true,
                      dataList1: state.customerList,
                      inputInitialValue:
                          state.shipCustomize['customer_name'].toString(),
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
                              .read<InstructionInputBloc>()
                              .add(SetShipMapEvent({
                                'customer_id': value,
                                'customer_name': value,
                                'customer_name_kana': value,
                                'customer_postal_cd': value,
                                'customer_addr_1': value,
                                'customer_addr_2': value,
                                'customer_addr_3': value,
                                'customer_tel': value,
                                'customer_fax': value,
                              }));
                        } else if (value is String) {
                          // 设定出荷指示值事件
                          context
                              .read<InstructionInputBloc>()
                              .add(SetShipValueEvent('customer_name', value));
                        } else {
                          // 设定出荷指示集合事件
                          context
                              .read<InstructionInputBloc>()
                              .add(SetShipMapEvent({
                                'customer_id': value['id'],
                                'customer_name': value['name'],
                                'customer_name_kana': value['name_kana'],
                                'customer_postal_cd': value['postal_cd'],
                                'customer_addr_1': value['addr_1'],
                                'customer_addr_2': value['addr_2'],
                                'customer_addr_3': value['addr_3'],
                                'customer_tel': value['tel'],
                                'customer_fax': value['fax'],
                              }));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_detail_21,
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
                      key: Key('customer_name_kana'),
                      text:
                          state.shipCustomize['customer_name_kana'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context.read<InstructionInputBloc>().add(
                            SetShipValueEvent('customer_name_kana', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_detail_22,
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
                    WMSPostalcodeWidget(
                      key: Key('customer_postal_cd'),
                      text:
                          state.shipCustomize['customer_postal_cd'].toString(),
                      country: 'JP',
                      postalCodeCallBack: (value) {
                        context.read<InstructionInputBloc>().add(
                            SetShipValueEvent(
                                'customer_postal_cd', value['postal_code']));
                        if (value['code'] == '0') {
                          //设定都道府县和市町村
                          context.read<InstructionInputBloc>().add(
                              SetShipValueEvent(
                                  'customer_addr_1', value['data']['city']));
                          context.read<InstructionInputBloc>().add(
                              SetShipValueEvent(
                                  'customer_addr_2', value['data']['region']));
                          context.read<InstructionInputBloc>().add(
                              SetShipValueEvent(
                                  'customer_addr_3', value['data']['addr']));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_detail_23,
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
                      key: Key('customer_addr_1'),
                      text: state.shipCustomize['customer_addr_1'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('customer_addr_1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_detail_24,
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
                      key: Key('customer_addr_2'),
                      text: state.shipCustomize['customer_addr_2'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('customer_addr_2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_detail_25,
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
                      key: Key('customer_addr_3'),
                      text: state.shipCustomize['customer_addr_3'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('customer_addr_3', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                                .instruction_input_form_detail_26,
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
                      key: Key('customer_tel'),
                      text: state.shipCustomize['customer_tel'].toString(),
                      numberIME: true,
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('customer_tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
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
                            .instruction_input_form_detail_27,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      numberIME: true,
                      key: Key('customer_fax'),
                      text: state.shipCustomize['customer_fax'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('customer_fax', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1,
                          child: Checkbox(
                              fillColor: MaterialStateColor.resolveWith(
                                (states) => Color.fromARGB(255, 61, 174, 182),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              value:
                                  state.shipCustomize['same_kbn'].toString() ==
                                      Config.WMS_COMPANY_FORCED_1,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    // 设定出荷指示值事件
                                    context.read<InstructionInputBloc>().add(
                                        SetShipValueEvent('same_kbn',
                                            Config.WMS_COMPANY_FORCED_1));
                                  } else {
                                    // 设定出荷指示值事件
                                    context.read<InstructionInputBloc>().add(
                                        SetShipValueEvent('same_kbn',
                                            Config.WMS_COMPANY_FORCED_0));
                                  }
                                });
                              }),
                        ),
                        Text(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_28)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.6,
            ),
            FractionallySizedBox(
              widthFactor: state.shipCustomize['same_kbn'].toString() ==
                      Config.WMS_COMPANY_FORCED_0
                  ? 1
                  : 0,
              child: Visibility(
                visible: state.shipCustomize['same_kbn'].toString() ==
                    Config.WMS_COMPANY_FORCED_0,
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                    .instruction_input_form_basic_11,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              key: Key('customer_addr_id'),
                              text: state.shipCustomize['customer_addr_id']
                                  .toString(),
                              readOnly: true,
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context.read<InstructionInputBloc>().add(
                                    SetShipValueEvent(
                                        'customer_addr_id', value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_basic_8,
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
                            WMSDropdownWidget(
                              key: Key('name'),
                              saveInput: true,
                              dataList1: state.customerAddressList,
                              inputInitialValue:
                                  state.shipCustomize['name'].toString(),
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
                                      .read<InstructionInputBloc>()
                                      .add(SetShipMapEvent({
                                        'customer_addr_id': value,
                                        'name': value,
                                        'name_kana': value,
                                        'postal_cd': value,
                                        'addr_1': value,
                                        'addr_2': value,
                                        'addr_3': value,
                                        'addr_tel': value,
                                        'fax': value,
                                        'person': value,
                                      }));
                                } else if (value is String) {
                                  // 设定出荷指示值事件
                                  context
                                      .read<InstructionInputBloc>()
                                      .add(SetShipValueEvent('name', value));
                                } else {
                                  // 设定出荷指示集合事件
                                  context
                                      .read<InstructionInputBloc>()
                                      .add(SetShipMapEvent({
                                        'customer_addr_id': value['id'],
                                        'name': value['name'],
                                        'name_kana': value['name_kana'],
                                        'postal_cd': value['postal_cd'],
                                        'addr_1': value['addr_1'],
                                        'addr_2': value['addr_2'],
                                        'addr_3': value['addr_3'],
                                        'addr_tel': value['tel'],
                                        'fax': value['fax'],
                                        'person': value['person'],
                                      }));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_before_12,
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
                              key: Key('name_kana'),
                              text: state.shipCustomize['name_kana'].toString(),
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context
                                    .read<InstructionInputBloc>()
                                    .add(SetShipValueEvent('name_kana', value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_before_13,
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
                            WMSPostalcodeWidget(
                              key: Key('postal_cd'),
                              text: state.shipCustomize['postal_cd'].toString(),
                              country: 'JP',
                              postalCodeCallBack: (value) {
                                context.read<InstructionInputBloc>().add(
                                    SetShipValueEvent(
                                        'postal_cd', value['postal_code']));
                                if (value['code'] == '0') {
                                  //设定都道府县和市町村
                                  context.read<InstructionInputBloc>().add(
                                      SetShipValueEvent(
                                          'addr_1', value['data']['city']));
                                  context.read<InstructionInputBloc>().add(
                                      SetShipValueEvent(
                                          'addr_2', value['data']['region']));
                                  context.read<InstructionInputBloc>().add(
                                      SetShipValueEvent(
                                          'addr_3', value['data']['addr']));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_before_14,
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
                              key: Key('addr_1'),
                              text: state.shipCustomize['addr_1'].toString(),
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context
                                    .read<InstructionInputBloc>()
                                    .add(SetShipValueEvent('addr_1', value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_before_15,
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
                              key: Key('addr_2'),
                              text: state.shipCustomize['addr_2'].toString(),
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context
                                    .read<InstructionInputBloc>()
                                    .add(SetShipValueEvent('addr_2', value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_before_16,
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
                              key: Key('addr_3'),
                              text: state.shipCustomize['addr_3'].toString(),
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context
                                    .read<InstructionInputBloc>()
                                    .add(SetShipValueEvent('addr_3', value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                        .instruction_input_form_before_17,
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
                              key: Key('addr_tel'),
                              text: state.shipCustomize['addr_tel'].toString(),
                              numberIME: true,
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context
                                    .read<InstructionInputBloc>()
                                    .add(SetShipValueEvent('addr_tel', value));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 0.3,
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
                                    .instruction_input_form_before_18,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                            WMSInputboxWidget(
                              numberIME: true,
                              key: Key('fax'),
                              text: state.shipCustomize['fax'].toString(),
                              inputBoxCallBack: (value) {
                                // 设定出荷指示值事件
                                context
                                    .read<InstructionInputBloc>()
                                    .add(SetShipValueEvent('fax', value));
                              },
                            ),
                          ],
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
                                .instruction_input_form_before_2,
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
                      key: Key('person'),
                      text: state.shipCustomize['person'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<InstructionInputBloc>()
                            .add(SetShipValueEvent('person', value));
                      },
                    ),
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
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
      builder: (context, state) {
        // 判断当前下标
        if (state.currentIndex == Config.NUMBER_ZERO) {
          // 当前内容
          currentContent = _initFormBasic(state);
        } else if (state.currentIndex == Config.NUMBER_ONE) {
          // 当前内容
          currentContent = _initFormBefore(state);
        } else {
          // 当前内容
          currentContent = Wrap();
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
                          initFormBasic: _initFormBasic,
                          initFormBefore: _initFormBefore,
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
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: currentContent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 出荷指示入力-表单Tab
typedef TabContextBuilder = Widget Function(InstructionInputModel state);

// ignore: must_be_immutable
class InstructionInputFormTab extends StatefulWidget {
  // 初始化基本情報入力表单
  TabContextBuilder initFormBasic;
  // 初始化出荷先情報入力表单
  TabContextBuilder initFormBefore;

  InstructionInputFormTab({
    super.key,
    required this.initFormBasic,
    required this.initFormBefore,
  });

  @override
  State<InstructionInputFormTab> createState() =>
      _InstructionInputFormTabState();
}

class _InstructionInputFormTabState extends State<InstructionInputFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, InstructionInputModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 判断当前下标
    if (state.currentIndex == Config.NUMBER_ZERO) {
      // 当前内容
      currentContent = widget.initFormBasic(state);
    } else if (state.currentIndex == Config.NUMBER_ONE) {
      // 当前内容
      currentContent = widget.initFormBefore(state);
    } else {
      // 当前内容
      currentContent = Wrap();
    }
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 当前下标变更事件
              context
                  .read<InstructionInputBloc>()
                  .add(CurrentIndexChangeEvent(tabItemList[i]['index']));
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: state.currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
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
                  color: state.currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                ),
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
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_basic,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_before,
      },
    ];
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 出荷指示入力-表单按钮
class InstructionInputFormButton extends StatefulWidget {
  const InstructionInputFormButton({super.key});

  @override
  State<InstructionInputFormButton> createState() =>
      _InstructionInputFormButtonState();
}

class _InstructionInputFormButtonState
    extends State<InstructionInputFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 36,
          margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(44, 167, 176, 1),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(120, 36),
              ),
            ),
            onPressed: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 保存出荷指示表单事件
                context.read<InstructionInputBloc>().add(SaveShipFormEvent(
                    context.read<InstructionInputBloc>().state.shipCustomize));
              } else {}
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
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': context.read<InstructionInputBloc>().state.shipId ==
                Config.NUMBER_NEGATIVE
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
