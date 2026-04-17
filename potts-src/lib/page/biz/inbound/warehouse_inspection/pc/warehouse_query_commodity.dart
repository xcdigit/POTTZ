import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/bloc/warehouse_inspection_bloc.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/bloc/warehouse_inspection_model.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/pc/warehouse_query_datasheet.dart';
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
  // String _datetime = 'yyyy/mm/dd';
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
    return BlocProvider<WarehouseInspectionBloc>(create: (context) {
      return WarehouseInspectionBloc(
        WarehouseInspectionModel(compareId: companyId),
      );
    }, child: BlocBuilder<WarehouseInspectionBloc, WarehouseInspectionModel>(
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
                child: Column(
                  children: [
                    // 标题
                    Visibility(
                      child: Row(
                        children: [
                          Container(
                            height: 104,
                            padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
                            child: Text(
                              WMSLocalizations.i18n(context)!.Warehouse_query_1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                height: 1.0,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          // 入荷予定番号
                          FractionallySizedBox(
                            widthFactor: .45,
                            child: Container(
                              // padding: EdgeInsets.only(left: 20),
                              height: 80,
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
                                            .add(
                                                SetWarehouseEvent('no', value));
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
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          FractionallySizedBox(
                            //入荷予定日
                            widthFactor: 0.45,
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
                                  ),
                                )
                              ],
                            ),
                          ),
                          // 入库状态
                          FractionallySizedBox(
                            widthFactor: .45,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    child: Text(WMSLocalizations.i18n(context)!
                                        .warehousing_status),
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
                                    child: Row(
                                      children: [
                                        BuildCheck(
                                          WMSLocalizations.i18n(context)!
                                              .delivery_note_22,
                                          0,
                                        ),
                                        BuildCheck(
                                          WMSLocalizations.i18n(context)!
                                              .Warehouse_query_3,
                                          1,
                                        ),
                                        BuildCheck(
                                          WMSLocalizations.i18n(context)!
                                              .Warehouse_query_4,
                                          2,
                                        ),
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
                          Column(
                            children: [
                              SizedBox(height: 15),
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .adjust_inquiry_note_6,
                                  list),
                            ],
                          ),
                          // Expanded(child: Container()),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20, width: double.infinity),
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
          ),
        );
      },
    ));
  }

  // 复选框
  Expanded BuildCheck(String text, int index) {
    return Expanded(
        flex: 1,
        child: Row(children: [
          Transform.scale(
              scale: 0.8,
              child: Checkbox(
                  fillColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromARGB(255, 61, 174, 182),
                  ),
                  value: _checkValue[index],
                  onChanged: (value) {
                    setState(() {
                      list.clear();
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
                    });
                  })),
          Text(text)
        ]));
  }

  // 底部检索和解除按钮
  Widget BuildButtom(String text, List<dynamic> list) {
    return BlocBuilder<WarehouseInspectionBloc, WarehouseInspectionModel>(
      builder: (context, state) {
        return Container(
          width: 200,
          height: 50,
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
