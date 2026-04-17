import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/display_instruction_bloc.dart';
import '../bloc/display_instruction_modle.dart';

/**
 * 内容：出荷指示照会-检索
 * 作者：熊草云
 * 时间：2023/08/10
 */
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
// 检索条件 取入状态
String data9 = '';
String data10 = '';
// 检索条件
List<String> conditionLabelList = [];

class displayInstructionRetrieval extends StatefulWidget {
  const displayInstructionRetrieval({super.key});

  @override
  State<displayInstructionRetrieval> createState() =>
      _displayInstructionRetrievalState();
}

class _displayInstructionRetrievalState
    extends State<displayInstructionRetrieval> {
  List<bool> _checkValue1 = [false, false, false];
  List<bool> _checkValue2 = [false, false, false];
  // 检索条件框显隐
  bool _flag = false;
  bool buttonPressed = false; // 用于追踪检索按钮状态
  // 悬停追踪
  bool buttonHovered = false;
  // 检索
  bool valueFromChild = false;
  // 搜索
  bool search = false;
  // 获取输入的值
  FocusNode searchFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  List<String> textList = [];
  void _handleSubmitted(String value) {
    String inputValue = value.trim();
    // _textEditingController.clear(); // 清除TextField中的文本内容
    textList.insert(0, inputValue);
    // 如果 TextList 的大小超过五个值，则删除最后一个值
    if (textList.length > 5) {
      textList.removeLast();
    }
    setState(
      () {
        buttonPressed = false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 48,
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            buttonHovered = true; // 鼠标进入，按钮悬停状态为 true
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            buttonHovered = false; // 鼠标离开，按钮悬停状态为 false
                          });
                        },
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(
                              () {
                                buttonPressed = !buttonPressed; // 更新按钮状态为按下
                                valueFromChild = false;
                                if (buttonPressed) {
                                  _flag = false;
                                } else {
                                  if (conditionLabelList.length > 0) {
                                    _flag = true;
                                  } else {
                                    _flag = false;
                                  }
                                }
                              },
                            );
                          },
                          icon: ColorFiltered(
                            colorFilter: buttonPressed
                                ? ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn)
                                : buttonHovered
                                    ? ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Color.fromRGBO(0, 122, 255, 1),
                                        BlendMode.srcIn),
                            child: Image.asset(WMSICons.WAREHOUSE_MENU_ICON,
                                height: 24),
                          ),
                          label: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_1,
                            style: TextStyle(
                                color: buttonPressed
                                    ? Colors.white
                                    : buttonHovered
                                        ? Colors.white
                                        : Color.fromRGBO(0, 122, 255, 1),
                                fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: buttonPressed
                                ? Color.fromRGBO(0, 122, 255, 1)
                                : buttonHovered
                                    ? Color.fromRGBO(0, 122, 255, .6)
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    Container(
                      width: 320,
                      child: Column(
                        children: [
                          Container(
                            height: 48,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: search
                                    ? Color.fromRGBO(0, 122, 255, 1)
                                    : Colors.black12,
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Image.asset(WMSICons.WAREHOUSE_SEARCH_ICON,
                                    height: 24),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: _textEditingController,
                                    onSubmitted: (value) {
                                      // 在这里处理回车事件
                                      context
                                          .read<DisplayInstructionBloc>()
                                          .add(QueryShipEvent(value));
                                      _handleSubmitted(value);
                                    },
                                    focusNode: searchFocusNode,
                                    onTap: () {
                                      setState(() {
                                        search = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        search = value.isNotEmpty;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: WMSLocalizations.i18n(context)!
                                          .delivery_note_2,
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(0, 122, 255, 1),
                                          fontSize: 15),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _flag,
                child: Container(
                  // height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_11,
                          style:
                              TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                        ),
                      ),
                      SizedBox(width: 10),
                      for (int i = 0; i < conditionLabelList.length; i++)
                        buildCondition(i, true)
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: buttonPressed,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
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
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 30),
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                                Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_11,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 122, 255, 1)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                for (int i = 0;
                                    i < conditionLabelList.length;
                                    i++)
                                  buildCondition(i, false)
                              ],
                            ),
                          ),
                          // 检索条件主体内容
                          DefaultTextStyle(
                            style: TextStyle(fontSize: 14),
                            child: Container(
                              height: 430,
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(WMSLocalizations.i18n(
                                                      context)!
                                                  .delivery_note_12),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
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
                                                    BuildCheck1(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_22,
                                                        0),
                                                    BuildCheck1(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_4,
                                                        1),
                                                    BuildCheck1(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_5,
                                                        2),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Text('')),
                                        BuildInput(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_note_13,
                                            0),
                                      ],
                                    ),
                                  ),
                                  //
                                  Expanded(
                                    child: Row(
                                      children: [
                                        BuildInput(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_note_14,
                                            1),
                                        Expanded(child: Text('')),
                                        BuildDropdown(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_note_15,
                                            0)
                                      ],
                                    ),
                                  ),
                                  //
                                  Expanded(
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
                                        BuildDropdown(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_note_17,
                                            1)
                                      ],
                                    ),
                                  ),
                                  Expanded(
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
                                        BuildDropdown(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_note_19,
                                            2)
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(WMSLocalizations.i18n(
                                                      context)!
                                                  .display_instruction_ingestion_state),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
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
                                                    BuildCheck2(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .delivery_note_22,
                                                        0),
                                                    BuildCheck2(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .importerror_flg_query_1,
                                                        1),
                                                    BuildCheck2(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .importerror_flg_query_2,
                                                        2),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Text('')),
                                        BuildDropdown(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_note_20,
                                            3)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_24,
                                  0),
                              SizedBox(width: 32),
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .delivery_note_25,
                                  1),
                            ],
                          ),
                        ],
                      ),
                    ), // 删除检索窗口按钮
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.translate(
                        offset: Offset(-10, 20),
                        child: InkWell(
                          onTap: () {
                            setState(
                              () {
                                buttonPressed = false;
                                // widget.onbottomChanged(false);
                              },
                            );
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 167, 176, 1),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black12, width: 0.5),
                            ),
                            child: Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int? _index1;
  // 复选框
  Widget BuildCheck1(String text, int index) {
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
              value: _index1 == index ? _checkValue1[index] : false,
              onChanged: (value) {
                setState(
                  () {
                    if (value == true) {
                      _index1 = index;
                      data1 = text; // 勾选时设置为 text 的值
                    } else {
                      _index1 = null;
                      data1 = ''; // 不勾选时设置为空值
                    }
                    _checkValue1[index] = value!;
                  },
                );
              },
            ),
          ),
          Text(text)
        ],
      ),
    );
  }

  int? _index2;
  Widget BuildCheck2(String text, int index) {
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
              value: _index2 == index ? _checkValue2[index] : false,
              onChanged: (value) {
                setState(
                  () {
                    if (value == true) {
                      _index2 = index;
                      data9 = text; // 勾选时设置为 text 的值
                    } else {
                      data9 = ''; // 不勾选时设置为空值
                    }
                    _checkValue2[index] = value!;
                  },
                );
              },
            ),
          ),
          Text(text)
        ],
      ),
    );
  }

  // 输入框
  Widget BuildInput(String text, int index) {
    return BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
        builder: (context, state) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 48,
              child: WMSInputboxWidget(
                text: index == 0 ? data2 : data3,
                inputBoxCallBack: (value) {
                  if (index == 0) {
                    data2 = value.trim();
                  } else {
                    data3 = value.trim();
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  // 下拉框
  Widget BuildDropdown(String text, int index) {
    return BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
        builder: (context, state) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 48,
              child: WMSDropdownWidget(
                saveInput: true,
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
                    if (value is String) {
                      context
                          .read<DisplayInstructionBloc>()
                          .add(SetSearchEvent(index, 'person', value.trim()));
                    } else {
                      context.read<DisplayInstructionBloc>().add(
                          SetSearchEvent(index, 'person', value["person"]));
                    }
                  } else {
                    if (value is String) {
                      context
                          .read<DisplayInstructionBloc>()
                          .add(SetSearchEvent(index, 'name', value.trim()));
                    } else {
                      context
                          .read<DisplayInstructionBloc>()
                          .add(SetSearchEvent(index, 'name', value["name"]));
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  // 日期
  Expanded BuildData(String text, int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: TextStyle(
                  color: index % 2 != 0 ? Colors.transparent : Colors.black)),
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
                    child: Text(index % 2 == 0
                        ? WMSLocalizations.i18n(context)!.delivery_note_21
                        : WMSLocalizations.i18n(context)!
                            .delivery_note_delivery_until),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 底部检索和解除按钮
  BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel> BuildButtom(
      String text, int number) {
    return BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
        builder: (context, state) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          color: Colors.white,
          height: 48,
          width: 220,
          child: OutlinedButton(
            onPressed: () {
              if (number == 0) {
                setState(() {
                  int removeNumber = 0;
                  int addNumber = 0;
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
                              .display_instruction_ingestion_state));
                    }
                    if (removeNumber == 10) {
                      conditionLabelList.removeWhere((element) =>
                          element.contains(WMSLocalizations.i18n(context)!
                              .delivery_note_20));
                    }
                  } while (removeNumber < 10);
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
                      if (data5_1 != '' || data5_2 != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_16 +
                                "：";
                        if (data5_1 != '' && data5_2 != '') {
                          tempContent = tempContent + data5_1 + '-' + data5_2;
                        } else if (data5_1 != '') {
                          tempContent = tempContent + '^' + data5_1;
                        } else {
                          tempContent = tempContent + data5_2;
                        }
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
                      if (data7_1 != '' || data7_2 != '') {
                        tempContent =
                            WMSLocalizations.i18n(context)!.delivery_note_18 +
                                "：";
                        if (data7_1 != '' && data7_2 != '') {
                          tempContent = tempContent + data7_1 + '-' + data7_2;
                        } else if (data5_1 != '') {
                          tempContent = tempContent + '^' + data7_1;
                        } else {
                          tempContent = tempContent + data7_2;
                        }
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
                      if (data9 != '') {
                        tempContent = WMSLocalizations.i18n(context)!
                                .display_instruction_ingestion_state +
                            "：" +
                            data9;
                      }
                    } else if (addNumber == 10) {
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
                    }
                  } while (addNumber < 10);
                  bool checkFlg = context
                      .read<DisplayInstructionBloc>()
                      .selectBeforeCheck(context, data2, data3);
                  if (checkFlg) {
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchShipStateEvent(conditionLabelList));
                    context.read<DisplayInstructionBloc>().add(
                        QuerySearchShipStateEvent(conditionLabelList, context));
                    if (conditionLabelList.length != 0) {
                      _flag = true;
                    }
                    buttonPressed = false;
                    // widget.onValueChanged(true);
                    // widget.onBoxChanged(conditionLabelList);
                  }
                });
              } else {
                setState(
                  () {
                    data1 = '';
                    data2 = '';
                    data3 = '';
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(0, 'name', ''));
                    // state.customer['name'] = null;
                    data5_1 = '';
                    data5_2 = '';
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(1, 'name', ''));
                    // state.name['name'] = null;
                    data7_1 = '';
                    data7_2 = '';
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(2, 'person', ''));
                    // state.person['person'] = null;
                    data9 = '';
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(3, 'name', ''));
                    // state.product['name'] = null;
                    _checkValue1 = [false, false, false];
                    _checkValue2 = [false, false, false];
                    conditionLabelList.clear();
                    context.read<DisplayInstructionBloc>().add(
                        QuerySearchShipStateEvent(conditionLabelList, context));
                    buttonPressed = false;
                  },
                );
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
  Container buildCondition(int index, flag) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 15),
      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
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
            conditionLabelList[index].replaceAll('^', ''),
            style: TextStyle(color: Colors.black12),
          ),
          InkWell(
            onTap: () {
              setState(
                () {
                  if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_12)) {
                    data1 = '';
                    _checkValue1 = [false, false, false];
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_13)) {
                    data2 = '';
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_14)) {
                    data3 = '';
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_15)) {
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(0, 'name', ''));
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_16)) {
                    data5_1 = '';
                    data5_2 = '';
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_17)) {
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(1, 'name', ''));
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_18)) {
                    data7_1 = '';
                    data7_2 = '';
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_19)) {
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(2, 'person', ''));
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!
                          .display_instruction_ingestion_state)) {
                    data9 = '';
                    _checkValue2 = [false, false, false];
                  } else if (conditionLabelList[index].contains(
                      WMSLocalizations.i18n(context)!.delivery_note_20)) {
                    context
                        .read<DisplayInstructionBloc>()
                        .add(SetSearchEvent(3, 'name', ''));
                  }
                  conditionLabelList.removeAt(index);
                  if (flag) {
                    context.read<DisplayInstructionBloc>().add(
                        QuerySearchShipStateEvent(conditionLabelList, context));
                  }
                  if (conditionLabelList.length == 0) {
                    setState(() {
                      _flag = false;
                    });
                  }
                },
              );
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
}
