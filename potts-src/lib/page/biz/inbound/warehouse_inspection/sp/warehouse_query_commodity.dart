import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/bloc/warehouse_inspection_bloc.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/bloc/warehouse_inspection_model.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/sp/warehouse_query_datasheet.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../redux/wms_state.dart';
import '/common/localization/default_localizations.dart';

/**
 * 内容：入庫照会
 * 作者：王光顺
 * 时间：2023/08/24
 */
class WarehouseQueryCommodityPage extends StatefulWidget {
  const WarehouseQueryCommodityPage({super.key});

  @override
  State<WarehouseQueryCommodityPage> createState() =>
      _WarehouseQueryCommodityPage();
}

class _WarehouseQueryCommodityPage extends State<WarehouseQueryCommodityPage> {
  List<bool> _checkValue = [false, false, false, false];
  //
  String _datetime = 'yyyy/mm/dd';
  bool buttonPressed = false; // 用于追踪按钮状态
  //检索出库状态条件
  List<dynamic> list = ['2', '3', '4', '5'];
  // 搜索
  bool search = false;
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
    return Material(
      child: BlocProvider<WarehouseInspectionBloc>(create: (context) {
        return WarehouseInspectionBloc(
          WarehouseInspectionModel(compareId: companyId),
        );
      }, child: BlocBuilder<WarehouseInspectionBloc, WarehouseInspectionModel>(
        builder: (context, state) {
          return ListView(
            children: [
              SizedBox(height: 20),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          //入荷予定日
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .confirmation_data_table_title_4,
                                  ),
                                ),
                                // 时间组件
                                Container(
                                  height: 48,
                                  child: WMSDateWidget(
                                    //进入页面日期设置为当前日期
                                    text: state.rcv_sch_date,
                                    //返回日期
                                    dateCallBack: (value) {
                                      if (value != '') {
                                        context
                                            .read<WarehouseInspectionBloc>()
                                            .add(SetWarehouseEvent(
                                                'schDate', value));
                                      } else {
                                        context
                                            .read<WarehouseInspectionBloc>()
                                            .add(SetWarehouseEvent(
                                                'schDate', ''));
                                      }
                                    },
                                    // borderColor: Color.fromRGBO(224, 224, 224, 1),
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 入荷予定番号
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .confirmation_data_table_title_3,
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.receive_no,
                                  inputBoxCallBack: (value) {
                                    if (value != '') {
                                      context
                                          .read<WarehouseInspectionBloc>()
                                          .add(SetWarehouseEvent('no', value));
                                    } else {
                                      context
                                          .read<WarehouseInspectionBloc>()
                                          .add(SetWarehouseEvent('no', ''));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          // 入库状态
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Container(
                                    height: 264,
                                    constraints: BoxConstraints(), // 设置容器的最大宽度
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .warehousing_status,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          constraints: BoxConstraints(
                                            maxHeight: 48,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            children: [
                                              BuildCheck(
                                                WMSLocalizations.i18n(context)!
                                                    .delivery_note_22,
                                                0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          constraints: BoxConstraints(
                                            maxHeight: 48,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            children: [
                                              BuildCheck(
                                                WMSLocalizations.i18n(context)!
                                                    .Warehouse_query_3,
                                                1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 16),
                                          constraints: BoxConstraints(
                                            maxHeight: 48,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              BuildCheck(
                                                WMSLocalizations.i18n(context)!
                                                    .Warehouse_query_4,
                                                2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxHeight: 48,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              BuildCheck(
                                                WMSLocalizations.i18n(context)!
                                                    .Warehouse_query_5,
                                                3,
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
                          ),
                          SizedBox(width: 400),
                          Column(
                            children: [
                              SizedBox(height: 15),
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .adjust_inquiry_note_6,
                                  list),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20, width: double.infinity),
                    Stack(
                      children: [
                        // 一览数据表部分
                        Stack(children: <Widget>[
                          WarehouseQueryDataSheetPage(
                              search: valueFromChild, onData: upData),
                        ]),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }

  // 复选框
  BuildCheck(String text, int index) {
    return Container(
      child: Row(
        children: [
          Transform.scale(
            scale: 1,
            child: Checkbox(
              fillColor: MaterialStateColor.resolveWith(
                (states) => Color.fromARGB(255, 61, 174, 182),
              ),
              value: _checkValue[index],
              onChanged: (value) {
                setState(
                  () {
                    list.clear();
                    // _checkValue[index] = value!;
                    _checkValue[index] = value ?? false;
                    if (_checkValue[1] == true) list.add('2');
                    if (_checkValue[2] == true) list.add('3');
                    if (_checkValue[3] == true)
                      list.addAll(['4', '5'].toList());

                    if (_checkValue[0] == true ||
                        (_checkValue[1] == true &&
                            _checkValue[2] == true &&
                            _checkValue[3] == true))
                      list.addAll(['2', '3', '4', '5'].toList());
                    if (_checkValue[0] == false &&
                        _checkValue[1] == false &&
                        _checkValue[2] == false &&
                        _checkValue[3] == false) list = ['2', '3', '4', '5'];
                    _checkValue[index] = value!;

                    list = List<String>.from(Set<String>.from(list)); // 去重
                  },
                );
              },
            ),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 日期
  Expanded BuildData() {
    return Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(WMSLocalizations.i18n(context)!.delivery_note_16),
      Container(
          constraints: BoxConstraints(maxHeight: 30),
          child: Row(children: [
            Expanded(
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.black12, width: 1.0),
                      ),
                    ),
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2050),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _datetime =
                              DateFormat('yyyy/MM/dd').format(selectedDate);
                        });
                      }
                    },
                    child: Row(children: [
                      Text(
                        _datetime,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]))),
            SizedBox(width: 10),
          ]))
    ]));
  }

  // 底部检索和解除按钮
  Widget BuildButtom(String text, List<dynamic> list) {
    return BlocBuilder<WarehouseInspectionBloc, WarehouseInspectionModel>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
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
              context
                  .read<WarehouseInspectionBloc>()
                  .add(QueryReceiveEvent('list', list));
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
        );
      },
    );
  }
}
