import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../bloc/revenue_and_expenditure_bloc.dart';
import '../bloc/revenue_and_expenditure_model.dart';

/**
 * 内容：受払照会-检索-sp
 * 作者：熊草云
 * 时间：2023/11/21
 */
// 商品名
String data1 = '';
// 年月
String data2 = '';
// 检索条件内容显示
List<String> conditionLabelList = [];

class RevenueAndExpenditureSearch extends StatefulWidget {
  const RevenueAndExpenditureSearch({super.key});

  @override
  State<RevenueAndExpenditureSearch> createState() =>
      _RevenueAndExpenditureSearchState();
}

class _RevenueAndExpenditureSearchState
    extends State<RevenueAndExpenditureSearch> {
  // 点击检索按钮
  bool _search = false;
  bool _searchData = false;
  // 悬停
  bool buttonHovered = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
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
                          _search = !_search;
                          if (_search) {
                            _searchData = false;
                          } else {
                            if (conditionLabelList.length > 0) {
                              _searchData = true;
                            } else {
                              _searchData = false;
                            }
                          }
                        },
                      );
                    },
                    icon: ColorFiltered(
                      colorFilter: _search
                          ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : buttonHovered
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                              : ColorFilter.mode(Color.fromRGBO(0, 122, 255, 1),
                                  BlendMode.srcIn),
                      child:
                          Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 18),
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
            ),
            Visibility(
              visible: _searchData,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 20),
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
                          WMSLocalizations.i18n(context)!.delivery_note_11,
                          style:
                              TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                        ),
                      ),
                    ),
                    for (int i = 0; i < state.conditionList.length; i++)
                      buildCondition(i)
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Visibility(
                  visible: _search,
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        width: 1.0,
                      ),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 30),
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                  width: 1.0,
                                ),
                              ),
                              child: Wrap(
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: 1,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 16, 0, 16),
                                      child: Text(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_11,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 122, 255, 1)),
                                      ),
                                    ),
                                  ),
                                  for (int i = 0;
                                      i < state.conditionList.length;
                                      i++)
                                    buildCondition(i)
                                ],
                              ),
                            ),
                          ),
                          //倉庫名称
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildText(WMSLocalizations.i18n(context)!
                                      .warehouse_master_3),
                                  WMSDropdownWidget(
                                    saveInput: true,
                                    dataList1: state.warehouseList,
                                    inputInitialValue:
                                        state.warehouse['name'].toString(),
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
                                      if (value is String) {
                                        // 保存查询：商品名事件
                                        context
                                            .read<RevenueAndExpenditureBloc>()
                                            .add(SetSearchEvent(
                                                0, 'name', value.trim()));
                                      } else {
                                        context
                                            .read<RevenueAndExpenditureBloc>()
                                            .add(SetSearchEvent(0, 'name',
                                                value["name"].toString()));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //アクション
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildText(WMSLocalizations.i18n(context)!
                                      .menu_content_4_10_1),
                                  WMSDropdownWidget(
                                    saveInput: true,
                                    inputWidth: double.infinity,
                                    dataList1: state.actionList,
                                    inputInitialValue:
                                        state.action['name'].toString(),
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
                                      if (value is String) {
                                        // 保存查询：商品名事件
                                        context
                                            .read<RevenueAndExpenditureBloc>()
                                            .add(SetSearchEvent(
                                                1, 'name', value.trim()));
                                      } else {
                                        context
                                            .read<RevenueAndExpenditureBloc>()
                                            .add(SetSearchEvent(1, 'name',
                                                value["name"].toString()));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //商品名
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildText(WMSLocalizations.i18n(context)!
                                      .delivery_note_20),
                                  WMSInputboxWidget(
                                    text: data1,
                                    inputBoxCallBack: (value) {
                                      data1 = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //年月
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildText(WMSLocalizations.i18n(context)!
                                      .menu_content_4_10_11),
                                  WMSInputboxWidget(
                                    text: data2,
                                    inputBoxCallBack: (value) {
                                      data2 = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 解除按钮
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              width: 224,
                              margin: EdgeInsets.only(top: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildButtom(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_25,
                                      1),
                                ],
                              ),
                            ),
                          ),
                          //检索按钮
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              width: 224,
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildButtom(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_24,
                                      0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 删除检索窗口按钮
                Positioned(
                  top: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(-10, 20),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _search = false;
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
          ],
        );
      },
    );
  }

  //检索条件内部数据
  BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>
      buildCondition(int index) {
    return BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>(
      builder: (bloc, state) {
        return Container(
          margin: EdgeInsets.only(right: 10, bottom: 16),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
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
                    // 商品名
                    if (conditionLabelList[index].contains(
                        WMSLocalizations.i18n(context)!.delivery_note_20)) {
                      data1 = '';
                    }
                    // 年月
                    if (conditionLabelList[index].contains(
                        WMSLocalizations.i18n(context)!.menu_content_4_10_11)) {
                      data2 = '';
                    }
                    // 倉庫名称
                    if (conditionLabelList[index].contains(
                        WMSLocalizations.i18n(context)!.warehouse_master_3)) {
                      bloc
                          .read<RevenueAndExpenditureBloc>()
                          .add(SetSearchEvent(0, "name", ''));
                    }
                    // アクション
                    if (conditionLabelList[index].contains(
                        WMSLocalizations.i18n(context)!.menu_content_4_10_1)) {
                      bloc
                          .read<RevenueAndExpenditureBloc>()
                          .add(SetSearchEvent(1, "name", ''));
                    }
                    conditionLabelList.removeAt(index);
                    // 设置检索条件
                    context
                        .read<RevenueAndExpenditureBloc>()
                        .add(SetSearchListEvent(conditionLabelList));
                    if (conditionLabelList.length == 0 && _searchData) {
                      context.read<RevenueAndExpenditureBloc>().add(
                          QuerySearchShipStateEvent(
                              conditionLabelList, context));

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
      },
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
  BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>
      buildButtom(String text, int number) {
    return BlocBuilder<RevenueAndExpenditureBloc, RevenueAndExpenditureModel>(
        builder: (bloc, state) {
      return Container(
        color: Colors.white,
        height: 48,
        width: 224,
        child: OutlinedButton(
          onPressed: () {
            //检索按钮
            if (number == 0) {
              if (data2 != '' && CheckUtils.check_Half_Number_6(data2)) {
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.menu_content_4_10_11 +
                        WMSLocalizations.i18n(context)!.input_int_6_check);
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
                  if (Number == 1) {
                    conditionLabelList.removeWhere((element) =>
                        element.contains(WMSLocalizations.i18n(context)!
                            .warehouse_master_3));
                    if (state.warehouse != '' ||
                        state.warehouse['name'] != null) {
                      tempContent =
                          WMSLocalizations.i18n(context)!.warehouse_master_3 +
                              "：" +
                              state.warehouse['name'].toString();
                    }
                    tempValue = state.warehouse['name'].toString();
                  }
                  if (Number == 2) {
                    conditionLabelList.removeWhere((element) =>
                        element.contains(WMSLocalizations.i18n(context)!
                            .menu_content_4_10_1));
                    if (state.action['name'] != null || state.action != '') {
                      tempContent =
                          WMSLocalizations.i18n(context)!.menu_content_4_10_1 +
                              "：" +
                              state.action['name'].toString();
                    }
                    tempValue = state.action['name'].toString();
                  }
                  if (Number == 3) {
                    conditionLabelList.removeWhere((element) =>
                        element.contains(
                            WMSLocalizations.i18n(context)!.delivery_note_20));
                    if (data1 != '') {
                      tempContent =
                          WMSLocalizations.i18n(context)!.delivery_note_20 +
                              "：" +
                              data1;
                    }
                    tempValue = data1;
                  }
                  if (Number == 4) {
                    conditionLabelList.removeWhere((element) =>
                        element.contains(WMSLocalizations.i18n(context)!
                            .menu_content_4_10_11));
                    if (data2 != '') {
                      tempContent =
                          WMSLocalizations.i18n(context)!.menu_content_4_10_11 +
                              "：" +
                              data2;
                    }
                    tempValue = data2;
                  }

                  if (tempContent != '' &&
                      tempValue != '' &&
                      tempValue != 'null') {
                    conditionLabelList.add(tempContent);
                  }
                  context
                      .read<RevenueAndExpenditureBloc>()
                      .add(SetSearchListEvent(conditionLabelList));
                } while (Number < 5);
                if (conditionLabelList.length != 0) {
                  _searchData = true;
                }
                context.read<RevenueAndExpenditureBloc>().add(
                    QuerySearchShipStateEvent(conditionLabelList, context));
              });
            } else {
              //清空输入框内容
              setState(() {
                data1 = '';
                data2 = '';
                bloc
                    .read<RevenueAndExpenditureBloc>()
                    .add(SetSearchEvent(0, "name", ''));
                bloc
                    .read<RevenueAndExpenditureBloc>()
                    .add(SetSearchEvent(1, "name", ''));
                conditionLabelList.clear();
                context
                    .read<RevenueAndExpenditureBloc>()
                    .add(SetSearchListEvent([]));
                context
                    .read<RevenueAndExpenditureBloc>()
                    .add(QuerySearchShipStateEvent([], context));
              });
              //清除日期内容
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
    });
  }
}
