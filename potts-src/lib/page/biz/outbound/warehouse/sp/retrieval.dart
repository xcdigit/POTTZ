import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../warehouse/bloc/warehouse_bloc.dart';
import '../../warehouse/bloc/warehouse_model.dart';

/**
 * 内容：納品書-检索条件
 * 作者：王光顺
 * 时间：2023/11/02
 */
class RetrievalPage extends StatefulWidget {
  // 检索按钮
  final bool buttonPressed;
  final ValueChanged<bool> onbottomChanged;
  final ValueChanged<bool> onValueChanged;
  final Function(List<String>) onBoxChanged;
  const RetrievalPage(
      {super.key,
      required this.buttonPressed,
      required this.onValueChanged,
      required this.onBoxChanged,
      required this.onbottomChanged});

  @override
  State<RetrievalPage> createState() => _RetrievalPageState();
}

class _RetrievalPageState extends State<RetrievalPage> {
  List<bool> _checkValue = [false, false, false];

  // 检索条件
  List<GlobalKey<WMSDropdownWidgetState>> dropdownWidgetKeys = [
    GlobalKey<WMSDropdownWidgetState>(),
    GlobalKey<WMSDropdownWidgetState>(),
    GlobalKey<WMSDropdownWidgetState>(),
    GlobalKey<WMSDropdownWidgetState>(),
  ];
  int number = 0;
// 检索条件 出力状态
  String data1 = '';
// 检索条件 得意先注文番号
  String data2 = '';
// 检索条件 出荷指示番号
  String data3 = '';
  String data4 = '';
// 检索条件 出荷指示日
  String data5_1 = '';
  String data5_2 = '';
  String data6 = '';
// 检索条件 纳入日
  String data7_1 = '';
  String data7_2 = '';
  String data8 = '';
// 检索条件
  List<String> conditionLabelList = [];
// 下拉框value值列表
  List<String> conditionValueList = [];
  List<String> boxFromList = [];
  bool _search = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 是否显示检索条件小框组件
        Visibility(
          visible: _search && !widget.buttonPressed && boxFromList.length > 0,
          child: Container(
            // height: 50,
            margin: EdgeInsets.only(top: 70),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black12,
                width: 1.0,
              ),
            ),
            child: Wrap(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      WMSLocalizations.i18n(context)!.delivery_note_11,
                      style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                for (int i = 0; i < boxFromList.length; i++) SearchCriteria(i)
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.buttonPressed,
          child: Stack(
            children: [
              Container(
                // height: 640,
                margin: EdgeInsets.only(
                    top: (_search && !widget.buttonPressed) ? 20 : 79),
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color.fromRGBO(245, 245, 245, 89),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    // 检索条件小框
                    Container(
                      // height: 50,
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                      child: Wrap(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_11,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 122, 255, 1)),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          for (int i = 0; i < conditionLabelList.length; i++)
                            buildCondition(i)
                        ],
                      ),
                    ),
                    // 检索条件主体内容
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      child: Container(
                        // height: 430,
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: Wrap(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      child: Text(
                                          WMSLocalizations.i18n(context)!
                                              .delivery_note_12),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: 48,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          BuildCheck(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_22,
                                              0),
                                          BuildCheck(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_4,
                                              1),
                                          BuildCheck(
                                              WMSLocalizations.i18n(context)!
                                                  .delivery_note_5,
                                              2),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildInput(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_13,
                                  0),
                            ),

                            //
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildInput(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_14,
                                  1),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildDropdown(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_15,
                                  0),
                            ),
                            //
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Row(
                                children: [
                                  BuildData(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_16,
                                      0),
                                  BuildData(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_16,
                                      1),
                                ],
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildDropdown(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_17,
                                  1),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Row(
                                children: [
                                  BuildData(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_18,
                                      2),
                                  BuildData(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_18,
                                      3),
                                ],
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildDropdown(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_19,
                                  2),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildDropdown(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_20,
                                  3),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: SizedBox(height: 20),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_24,
                                  0),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: SizedBox(height: 20),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_25,
                                  1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 删除检索窗口按钮
              Positioned(
                top: 0,
                right: 0,
                child: Transform.translate(
                  offset:
                      Offset(-10, (_search && !widget.buttonPressed) ? 10 : 79),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.onbottomChanged(false);
                      });
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(44, 167, 176, 1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                      child: Icon(Icons.close, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 复选框
  Expanded BuildCheck(String text, int index) {
    return Expanded(
      flex: 1,
      child: Row(
        children: [
          Transform.scale(
            scale: 1,
            child: Checkbox(
              fillColor: MaterialStateColor.resolveWith(
                (states) => Color.fromRGBO(44, 167, 176, 1),
              ),
              value: _checkValue[index],
              onChanged: (value) {
                if (index == 0) {
                  if (data1 != '') data1 += ",";
                  data1 += "全て";
                } else if (index == 1) {
                  if (data1 != '') data1 += ",";
                  data1 += "未出力";
                } else {
                  if (data1 != '') data1 += ",";
                  data1 += "出力済";
                }

                setState(() {
                  _checkValue[index] = value!;
                });
              },
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  // 下拉框
  Widget BuildDropdown(String text, int index) {
    return BlocBuilder<WarehouseBloc, WarehouseModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        height: 80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(text),
            ),
            Container(
              height: 48,
              child: WMSDropdownWidget(
                dataList1: index == 0
                    ? state.customerList
                    : index == 1
                        ? state.nameList
                        : index == 2
                            ? state.personList
                            : state.productList,
                inputInitialValue: index == 0
                    ? state.customer['name'].toString()
                    : index == 1
                        ? state.name['name'].toString()
                        : index == 2
                            ? state.person['person'].toString()
                            : state.product['name'].toString(),
                inputRadius: 4,
                inputSuffixIcon: Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                key: dropdownWidgetKeys[index],
                inputFontSize: 14,
                dropdownRadius: 4,
                dropdownTitle: index == 2 ? 'person' : 'name',
                dropdownKey: index == 2 ? 'person' : 'name',
                selectedCallBack: (value) {
                  if (index == 2) {
                    context
                        .read<WarehouseBloc>()
                        .add(SetSearchEvent(index, 'person', value["person"]));
                  } else {
                    context
                        .read<WarehouseBloc>()
                        .add(SetSearchEvent(index, 'name', value["name"]));
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  // 输入框
  Widget BuildInput(String text, int index) {
    return BlocBuilder<WarehouseBloc, WarehouseModel>(
        builder: (context, state) {
      return Container(
        height: 80,
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(text),
            ),
            Container(
                margin: EdgeInsets.only(top: 5),
                height: 48,
                child: WMSInputboxWidget(
                  text: index == 0 ? data2 : data3,
                  inputBoxCallBack: (value) {
                    if (index == 0) {
                      data2 = value;
                    } else {
                      data3 = value;
                    }
                  },
                )),
          ],
        ),
      );
    });
  }

  // 日期
  Expanded BuildData(String text, int index) {
    return Expanded(
      child: Container(
        height: 80,
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(text,
                  style: TextStyle(
                      color:
                          index % 2 != 0 ? Colors.transparent : Colors.black)),
            ),
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: WMSDateWidget(
                      text: index == 0
                          ? data5_1
                          : index == 1
                              ? data5_2
                              : index == 2
                                  ? data7_1
                                  : data7_2,
                      dateCallBack: (value) {
                        index == 0
                            ? data5_1 = value
                            : index == 1
                                ? data5_2 = value
                                : index == 2
                                    ? data7_1 = value
                                    : data7_2 = value;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_21),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// 底部检索和解除按钮
  BuildButtom(String text, int number) {
    return BlocBuilder<WarehouseBloc, WarehouseModel>(
        builder: (context, state) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          color: Colors.white,
          height: 48,
          width: 220,
          child: OutlinedButton(
            onPressed: () {
              if (number == 0) {
                widget.onbottomChanged(false);
                widget.onBoxChanged(conditionLabelList);
                setState(() {
                  int removeNumber = 0;
                  int addNumber = 0;
                  //防止外层检索条件重复，在此清空检索条件
                  boxFromList = [];
                  do {
                    removeNumber++;
                    if (removeNumber == 1) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_12));
                    }
                    if (removeNumber == 2) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_13));
                    }
                    if (removeNumber == 3) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_14));
                    }
                    if (removeNumber == 4) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_15));
                    }
                    if (removeNumber == 5) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_16));
                    }
                    if (removeNumber == 6) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_17));
                    }
                    if (removeNumber == 7) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_18));
                    }
                    if (removeNumber == 8) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_19));
                    }
                    if (removeNumber == 9) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_20));
                    }
                  } while (removeNumber < 9);
                  // 检索条件整合追加
                  do {
                    addNumber++;
                    var tempContent = "";
                    if (addNumber == 1) {
                      if (data1 != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_12 +
                                "：" +
                                data1;
                      }
                    } else if (addNumber == 2) {
                      if (data2 != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_13 +
                                "：" +
                                data2;
                      }
                    } else if (addNumber == 3) {
                      if (data3 != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_14 +
                                "：" +
                                data3;
                      }
                    } else if (addNumber == 4) {
                      if (state.customer['name'] != null &&
                          state.customer['name'] != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_15 +
                                "：" +
                                state.customer['name'].toString();
                      }
                    } else if (addNumber == 5) {
                      if (data5_1 != '' ||
                          data5_2 != '' ||
                          (data5_1 != '' && data5_2 != '')) {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_16 +
                                "：";

                        if (data5_1 != '' && data5_2 == '') {
                          tempContent = tempContent + '^' + data5_1;
                        }
                        if (data5_1 != '' && data5_2 != '')
                          tempContent =
                              tempContent + data5_1 + '-' + data5_2; // 1 2

                        if (data5_2 != '' && data5_1 == '')
                          tempContent = tempContent + data5_2;
                      }
                    } else if (addNumber == 6) {
                      if (state.name['name'] != null &&
                          state.name['name'] != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_17 +
                                "：" +
                                state.name['name'].toString();
                      }
                    } else if (addNumber == 7) {
                      if (data7_1 != '' ||
                          data7_2 != '' ||
                          (data7_1 != '' && data7_2 != '')) {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_18 +
                                "：";

                        if (data7_1 != '' && data7_2 == '')
                          tempContent = tempContent + '^' + data7_1; //1

                        if (data7_1 != '' && data7_2 != '')
                          tempContent =
                              tempContent + data7_1 + '-' + data7_2; // 1 2

                        if (data7_2 != '' && data7_1 == '')
                          tempContent = tempContent + data7_2; //2
                      }
                    } else if (addNumber == 8) {
                      if (state.person['person'] != null &&
                          state.person['person'] != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_19 +
                                "：" +
                                state.person['person'].toString();
                      }
                    } else if (addNumber == 9) {
                      if (state.product['name'] != null &&
                          state.product['name'] != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_20 +
                                "：" +
                                state.product['name'].toString();
                      }
                    }

                    if (tempContent != '') {
                      conditionLabelList.add(tempContent);
                      boxFromList.add(tempContent);
                    }
                  } while (addNumber < 10);
                });

                // 检索条件check
                bool checkFlg = context
                    .read<WarehouseBloc>()
                    .selectBeforeCheck(context, data2, data3);
                if (checkFlg) {
                  state.conditionLabelList = conditionLabelList;

                  context
                      .read<WarehouseBloc>()
                      .add(SetShipValueEvent(conditionLabelList));

                  //设置为第二检索
                  //设置当前下标为初始
                  context.read<WarehouseBloc>().add(SetValueEvent(0));
                  context.read<WarehouseBloc>().add(QueryShipEvent(
                      [], conditionLabelList, '', state.keyword));
                  if (boxFromList.length > 0) {
                    setState(() {
                      _search = true;
                    });
                  }
                }
              } else {
                data1 = '';
                data2 = '';
                data3 = '';
                state.customer['name'] = '';
                data5_1 = '';
                data5_2 = '';
                state.name['name'] = '';
                data7_1 = '';
                data7_2 = '';
                state.person['person'] = '';
                state.product['name'] = '';

                state.keyword = '';
                context
                    .read<WarehouseBloc>()
                    .add(QueryShipEvent([], [], '', ''));
                //清空检索条件
                _checkValue = [false, false, false];
                conditionLabelList = [];
                conditionLabelList.clear();
                conditionValueList.clear();
              }
            },
            child: Text(
              text,
              style: TextStyle(
                color: Color.fromRGBO(44, 167, 176, 1),
              ),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              side: MaterialStateProperty.all(
                const BorderSide(
                  width: 1,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  /////检索条件内部数据
  Container buildCondition(int index) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      //筛出无效检索 不予展示
      child: Wrap(
        children: [
          Text(
            conditionLabelList[index],
            style: TextStyle(color: Colors.black12),
          ),
          SizedBox(width: 5),
          InkWell(
            onTap: () {
              setState(() {
                conditionLabelList.removeAt(index);
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'x',
                style: TextStyle(color: Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 检索条件小框组件
  Container SearchCriteria(index) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 10),
      padding: EdgeInsets.all(5),
      // height: 34,
      // width: 122,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Wrap(
        children: [
          Text(
            boxFromList[index],
            style: TextStyle(color: Colors.black12),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              setState(() {
                boxFromList.removeAt(index);
                if (boxFromList.length == 0) {
                  _search = false;
                }
              });
            },
            child: Text(
              'x',
              style: TextStyle(color: Colors.black12),
            ),
          ),
        ],
      ),
    );
  }
}
