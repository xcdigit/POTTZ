import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../bloc/returns_note_bloc.dart';

/**
 * 内容：返品照会-检索-sp
 * 作者：熊草云
 * 时间：2023/11/22
 */
// 返品区分
String data1 = '';
// 商品コード
String data2 = '';
// 商品名
String data3 = '';
// 入荷予定番号/出荷指示番号
String data4 = '';
// 返品区分列表
List<Map<String, dynamic>> data1List = [
  {'name': '売上返品'},
  {'name': '仕入返品'}
];
// 检索条件内容列表
List<String> conditionLabelList = [];

class ReturnsNoteearch extends StatefulWidget {
  // 检索按钮
  const ReturnsNoteearch({super.key});

  @override
  State<ReturnsNoteearch> createState() => _ReturnsNoteearchState();
}

class _ReturnsNoteearchState extends State<ReturnsNoteearch> {
  // 初始化检索条件
  List<Widget> _initSearch() {
    return [
      FractionallySizedBox(
        // 1、返品区分
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(WMSLocalizations.i18n(context)!.returns_note_1),
              WMSDropdownWidget(
                dataList1: data1List,
                inputInitialValue: data1,
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
                dropdownKey: 'name',
                selectedCallBack: (value) {
                  setState(() {
                    data1 = value['name'];
                  });
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // 2、商品コード
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(WMSLocalizations.i18n(context)!.pink_list_49),
              WMSInputboxWidget(
                text: data2,
                inputBoxCallBack: (value) {
                  setState(() {
                    data2 = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // 3、商品名
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(
                  WMSLocalizations.i18n(context)!.outbound_adjust_query_name),
              WMSInputboxWidget(
                text: data3,
                inputBoxCallBack: (value) {
                  setState(() {
                    data3 = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // 4、入荷予定番号/出荷指示番号
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText(WMSLocalizations.i18n(context)!.returns_note_2),
              WMSInputboxWidget(
                text: data4,
                inputBoxCallBack: (value) {
                  setState(() {
                    data4 = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 解除
              buildButtom(WMSLocalizations.i18n(context)!.delivery_note_25, 1),
              SizedBox(height: 20),
              // 检索
              buildButtom(WMSLocalizations.i18n(context)!.delivery_note_24, 0),
            ],
          ),
        ),
      ),
    ];
  }

  // 检索条件按钮判定
  bool _search = false;
  // 检索条件框显示判定
  bool _searchData = false;
  // 悬停状态
  bool buttonHovered = false;
//检索按钮
  searchButton() {
    return Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
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
                      _search = !_search; // 更新按钮状态为按下
                      _searchData = false;
                    },
                  );
                },
                icon: ColorFiltered(
                  colorFilter: _search
                      ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : buttonHovered
                          ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : ColorFilter.mode(
                              Color.fromRGBO(0, 122, 255, 1), BlendMode.srcIn),
                  child: Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 18),
                ),
                label: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_1,
                  style: TextStyle(
                      color: _search
                          ? Colors.white
                          : buttonHovered
                              ? Colors.white
                              : Color.fromRGBO(0, 122, 255, 1),
                      fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _search
                      ? Color.fromRGBO(0, 122, 255, 1)
                      : buttonHovered
                          ? Color.fromRGBO(0, 122, 255, .6)
                          : Colors.white,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //检索按钮
        searchButton(),
        Visibility(
          visible: _searchData,
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.only(left: 16),
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
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Text(
                      WMSLocalizations.i18n(context)!.delivery_note_11,
                      style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                    ),
                  ),
                ),
                for (int i = 0; i < conditionLabelList.length; i++)
                  buildCondition(i)
              ],
            ),
          ),
        ),
        Visibility(
          visible: _search,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(245, 245, 245, 1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Color.fromRGBO(245, 245, 245, 89),
                    width: 1.0,
                  ),
                ),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    // 检索条件小框
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 16),
                      padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
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
                              padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_11,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 122, 255, 1)),
                              ),
                            ),
                          ),
                          for (int i = 0; i < conditionLabelList.length; i++)
                            buildCondition(i)
                        ],
                      ),
                    ),
                    // 检索条件主体内容
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: _initSearch(),
                    )
                  ],
                ),
              ),
              // 删除检索窗口按钮
              Positioned(
                top: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(-10, -10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _search = false;
                        _searchData = false;
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
        )
      ],
    );
  }

  //检索条件内部数据
  Container buildCondition(int index) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        children: [
          Text(
            conditionLabelList[index],
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              setState(() {
                // 返品区分
                if (conditionLabelList[index]
                    .contains(WMSLocalizations.i18n(context)!.returns_note_1)) {
                  data1 = '';
                }
                // 商品コード
                if (conditionLabelList[index]
                    .contains(WMSLocalizations.i18n(context)!.pink_list_49)) {
                  data2 = '';
                }
                // 商品名
                if (conditionLabelList[index].contains(
                    WMSLocalizations.i18n(context)!
                        .outbound_adjust_query_name)) {
                  data3 = '';
                }
                // 入荷予定番号/出荷指示番号
                if (conditionLabelList[index]
                    .contains(WMSLocalizations.i18n(context)!.returns_note_2)) {
                  data4 = '';
                }
                conditionLabelList.removeAt(index);
                if (conditionLabelList.length == 0 && _searchData) {
                  context
                      .read<ReturnNoteBloc>()
                      .add(QuerySearchEvent(conditionLabelList));
                  _searchData = false;
                }
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'x',
                style: TextStyle(
                  color: Color.fromRGBO(156, 156, 156, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //输入框上方的文本
  buildText(String _text) {
    return Container(
      height: 24,
      child: Text(
        _text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 底部检索和解除按钮
  Container buildButtom(String text, int number) {
    return Container(
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () {
          //检索按钮
          if (number == 0) {
            if (data2 != '' && CheckUtils.check_Half_Alphanumeric_6_50(data2)) {
              WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
                      .pink_list_49 +
                  WMSLocalizations.i18n(context)!.input_must_six_number_check);
              return;
            } else if (data4 != '' &&
                CheckUtils.check_Half_Alphanumeric_Symbol(data4)) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.returns_note_2 +
                      WMSLocalizations.i18n(context)!
                          .input_letter_and_number_and_symbol_check);
              return;
            }
            //需要重新检索数据（带条件）
            setState(() {
              _search = false;
              int Number = 0;
              // 检索条件整合删除
              do {
                String tempContent = "";
                String tempValue = '';
                Number++;
                // 返品区分
                if (Number == 1) {
                  conditionLabelList.removeWhere((element) => element.contains(
                      WMSLocalizations.i18n(context)!.returns_note_1));
                  if (data1 != '') {
                    tempContent =
                        WMSLocalizations.i18n(context)!.returns_note_1 +
                            "：" +
                            data1;
                  }
                  tempValue = data1;
                }
                // 商品コード
                if (Number == 2) {
                  conditionLabelList.removeWhere((element) => element
                      .contains(WMSLocalizations.i18n(context)!.pink_list_49));
                  if (data2 != '') {
                    tempContent = WMSLocalizations.i18n(context)!.pink_list_49 +
                        "：" +
                        data2;
                  }
                  tempValue = data2;
                }
                // 商品名
                if (Number == 3) {
                  conditionLabelList.removeWhere((element) => element.contains(
                      WMSLocalizations.i18n(context)!
                          .outbound_adjust_query_name));
                  if (data3 != '') {
                    tempContent = WMSLocalizations.i18n(context)!
                            .outbound_adjust_query_name +
                        "：" +
                        data3;
                  }
                  tempValue = data3;
                }
                // 入荷予定番号/出荷指示番号
                if (Number == 4) {
                  conditionLabelList.removeWhere((element) => element.contains(
                      WMSLocalizations.i18n(context)!.returns_note_2));
                  if (data4 != '') {
                    tempContent =
                        WMSLocalizations.i18n(context)!.returns_note_2 +
                            "：" +
                            data4.toString();
                  }
                  tempValue = data4.toString();
                }
                if (tempContent != '' &&
                    tempValue != '' &&
                    tempValue != 'null') {
                  conditionLabelList.add(tempContent);
                }
              } while (Number < 5);
              if (conditionLabelList.length != 0) {
                _searchData = true;
              }
              context
                  .read<ReturnNoteBloc>()
                  .add(QuerySearchEvent(conditionLabelList));
            });
          } else {
            //清空多选框内容
            setState(() {
              data1 = '';
              data2 = '';
              data3 = '';
              data4 = '';
              conditionLabelList.clear();
            });
            //清空输入框内容
          }
        },
        child: Text(text,
            style: TextStyle(
                color: number == 0
                    ? Colors.white
                    : Color.fromRGBO(44, 167, 176, 1))),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          backgroundColor: MaterialStateProperty.all<Color>(number == 0
              ? Color.fromRGBO(44, 167, 176, 1)
              : Colors.white), // 设置背景颜色
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 1,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }
}
