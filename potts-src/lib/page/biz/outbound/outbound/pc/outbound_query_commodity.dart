import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/page/biz/outbound/outbound/bloc/outbound_query_bloc.dart';
import 'package:wms/page/biz/outbound/outbound/bloc/outbound_query_model.dart';
import 'package:wms/redux/wms_state.dart';

import 'package:wms/widget/wms_date_widget.dart';

import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../common/config/config.dart';
import './outbound_query_datasheet.dart';

/**
 * 内容：出庫照会
 * 作者：王光顺
 * 时间：2023/08/18
 */
// 全局主键-下拉共通

class OutboundQueryCommodityPage extends StatefulWidget {
  static const String sName = "Commodity";

  const OutboundQueryCommodityPage({super.key});

  @override
  State<OutboundQueryCommodityPage> createState() =>
      _OutboundQueryCommodityPage();
}

class _OutboundQueryCommodityPage extends State<OutboundQueryCommodityPage> {
  List<bool> _checkValue = [false, false, false, false];
  //
  // String _datetime = 'yyyy/mm/dd';

  bool buttonPressed = false; // 用于追踪按钮状态
  // 搜索
  bool search = false;

  String rcvSchDate = '';
  String shipNo = '';

  //检索出库状态条件
  List<dynamic> list = ['2', '3', '4', '5', '6', '7'];

  // 检索
  bool valueFromChild = false;
  void updateValue(bool value) {
    setState(() {
      valueFromChild = value;
      buttonPressed = false;
    });
  }

// 明细
  void upData(bool value) {
    setState(() {
      buttonPressed = false;
      valueFromChild = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<OutboundQueryBloc>(create: (context) {
      return OutboundQueryBloc(
        OutboundQueryModel(companyId: companyId),
      );
    }, child: BlocBuilder<OutboundQueryBloc, OutboundQueryModel>(
        builder: (context, state) {
      return Scrollbar(
        thumbVisibility: true,
        child: ListView(
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(children: [
                // 标题
                Container(
                  child: Row(
                    children: [
                      Container(
                        height: 104,
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                        child: Text(
                          WMSLocalizations.i18n(context)!.menu_content_3_16,
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

                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween, // 设置对齐方式为两端对齐
                    direction: Axis.horizontal, // 设置水平方向排列
                    children: [
                      FractionallySizedBox(
                        widthFactor: .4,
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .instruction_input_form_basic_1,
                                ),
                              ),
                              Container(
                                child: WMSInputboxWidget(
                                  height: 48,
                                  text: shipNo,
                                  inputBoxCallBack: (value) {
                                    state.shipCustomize['ship_no'] =
                                        value.toString();
                                    // 设定出荷指示值事件
                                    context.read<OutboundQueryBloc>().add(
                                        SetShipValueEvent('ship_no', value));
                                    shipNo = value.toString();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: .05,
                      ),
                      FractionallySizedBox(
                        widthFactor: .4,
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(
                                  WMSLocalizations.i18n(context)!
                                      .instruction_input_form_basic_3,
                                ),
                              ),
                              Container(
                                height: 48,
                                child: WMSDateWidget(
                                  text: rcvSchDate,
                                  borderColor: Color.fromRGBO(224, 224, 224, 1),
                                  dateCallBack: (value) {
                                    state.shipCustomize['rcv_sch_date'] =
                                        value.toString();
                                    // 设定出荷指示值事件
                                    context.read<OutboundQueryBloc>().add(
                                        SetShipValueEvent(
                                            'rcv_sch_date', value));
                                    rcvSchDate = value.toString();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: .1,
                      ),
                      FractionallySizedBox(
                        widthFactor: .4,
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 24,
                                child: Text(WMSLocalizations.i18n(context)!
                                    .outbound_notes_2),
                              ),
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 48,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    BuildCheck(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_22,
                                      0,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width <
                                              Config.WEB_MINI_WIDTH_LIMIT
                                          ? 0
                                          : 20,
                                    ),
                                    BuildCheck(
                                      WMSLocalizations.i18n(context)!
                                          .outbound_notes_3,
                                      1,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width <
                                              Config.WEB_MINI_WIDTH_LIMIT
                                          ? 0
                                          : 20,
                                    ),
                                    BuildCheck(
                                      WMSLocalizations.i18n(context)!
                                          .outbound_notes_4,
                                      2,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width <
                                              Config.WEB_MINI_WIDTH_LIMIT
                                          ? 0
                                          : 20,
                                    ),
                                    BuildCheck(
                                      WMSLocalizations.i18n(context)!
                                          .outbound_notes_5,
                                      3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: .05,
                      ),
                      FractionallySizedBox(
                        widthFactor: .4,
                        child: Container(
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 24,
                              ),
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .adjust_inquiry_note_6,
                                  list),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: .1,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20, width: double.infinity),
                Stack(
                  children: [
                    // 一览数据表部分
                    Stack(children: <Widget>[
                      OutboundQueryDataSheetPage(
                          search: valueFromChild, onData: upData),
                    ]),
                  ],
                ),
              ]),
            ),
          ],
        ),
      );
    }));
  }

  // 复选框
  BuildCheck(String text, int index) {
    return Container(
      child: Stack(
        children: [
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              fillColor: MaterialStateColor.resolveWith(
                (states) => Color.fromARGB(255, 61, 174, 182),
              ),
              value: _checkValue[index],
              onChanged: (value) {
                setState(
                  () {
                    list.clear();
                    _checkValue[index] = value ?? false;
                    if (_checkValue[1] == true) list.add('2');
                    if (_checkValue[2] == true) list.add('3');
                    if (_checkValue[3] == true)
                      list.addAll(['4', '5', '6', '7'].toList());

                    if (_checkValue[0] == true ||
                        (_checkValue[1] == true &&
                            _checkValue[2] == true &&
                            _checkValue[3] == true))
                      list.addAll(['2', '3', '4', '5', '6', '7'].toList());
                    if (_checkValue[0] == false &&
                        _checkValue[1] == false &&
                        _checkValue[2] == false &&
                        _checkValue[3] == false)
                      list = ['2', '3', '4', '5', '6', '7'];
                    _checkValue[index] = value!;

                    list = List<String>.from(Set<String>.from(list)); // 去重
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 13, left: 35),
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // 检索按钮
  // 底部检索和解除按钮
  Widget BuildButtom(String text, List<dynamic> list) {
    return BlocBuilder<OutboundQueryBloc, OutboundQueryModel>(
        builder: (context, state) {
      return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            // return
            Container(
              width: 200,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Color.fromARGB(255, 61, 174, 182),
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: OutlinedButton(
                onPressed: () {
                  state.shipCustomize['ship_no'] = shipNo.toString();
                  state.shipCustomize['rcv_sch_date'] = rcvSchDate.toString();
                  if (shipNo.toString() != '' &&
                      CheckUtils.check_Half_Alphanumeric_Symbol(
                          shipNo.toString())) {
                    WMSCommonBlocUtils.errorTextToast(
                        WMSLocalizations.i18n(context)!
                                .instruction_input_form_basic_1 +
                            WMSLocalizations.i18n(context)!
                                .input_letter_and_number_and_symbol_check);
                  } else {
                    //获取当前登录用户会社ID
                    int companyId = StoreProvider.of<WMSState>(context)
                        .state
                        .loginUser!
                        .company_id!;

                    context
                        .read<OutboundQueryBloc>()
                        .add(OutboundPageQueryEvent(list, companyId));
                    currentIndex = 0;
                  }
                },
                child: Text(
                  text,
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 174, 182),
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide.none,
                  ),
                ),
              ),
            )
          ]);
    });
  }
}
