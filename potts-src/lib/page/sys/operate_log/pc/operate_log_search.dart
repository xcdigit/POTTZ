import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../bloc/operate_log_bloc.dart';
import '../bloc/operate_log_model.dart';

/**
 * 内容：操作ログ-检索
 * 作者：luxy
 * 时间：2023/11/27
 */
String data1 = '';
List<String> conditionLabelList = [];

class OperateLogSearch extends StatefulWidget {
  const OperateLogSearch({super.key});

  @override
  State<OperateLogSearch> createState() => _OperateLogSearchState();
}

class _OperateLogSearchState extends State<OperateLogSearch> {
  // 点击检索按钮
  bool _search = false;
  bool _searchData = false;
  // 悬停
  bool buttonHovered = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OperateLogBloc, OperateLogModel>(
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
                          Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 24),
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
            //外边检索条件
            Visibility(
              visible: _searchData,
              child: Container(
                height: 50,
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
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.delivery_note_11,
                      style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                    ),
                    SizedBox(width: 10),
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
                    height: StoreProvider.of<WMSState>(state.context)
                                .state
                                .loginUser!
                                .role_id ==
                            Config.NUMBER_ONE
                        ? 412
                        : 312,
                    margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.only(left: 32, right: 32),
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
                                height: 48,
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
                                child: Row(
                                  children: [
                                    Text(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_11,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(0, 122, 255, 1)),
                                    ),
                                    SizedBox(width: 10),
                                    for (int i = 0;
                                        i < state.conditionList.length;
                                        i++)
                                      buildCondition(i)
                                  ],
                                ),
                              ),
                            ),
                            //操作内容
                            FractionallySizedBox(
                              widthFactor: 0.4,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(WMSLocalizations.i18n(context)!
                                        .menu_content_99_6_1),
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
                            //ログレベル
                            FractionallySizedBox(
                              widthFactor: 0.4,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(WMSLocalizations.i18n(context)!
                                        .menu_content_99_6_2),
                                    WMSDropdownWidget(
                                      saveInput: true,
                                      inputWidth: double.infinity,
                                      dataList1: state.searchTypeKbnList,
                                      inputInitialValue:
                                          state.typeKbn['name'].toString(),
                                      inputRadius: 4,
                                      inputSuffixIcon: Container(
                                        width: 24,
                                        height: 24,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 16, 0),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ),
                                      inputFontSize: 14,
                                      dropdownRadius: 4,
                                      dropdownTitle: 'name',
                                      dropdownKey: 'name',
                                      selectedCallBack: (value) {
                                        // 保存查询：ログレベル
                                        context.read<OperateLogBloc>().add(
                                            SetSearchEvent(0, 'name', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //会社
                            Visibility(
                              visible: StoreProvider.of<WMSState>(state.context)
                                      .state
                                      .loginUser!
                                      .role_id ==
                                  Config.NUMBER_ONE,
                              child: FractionallySizedBox(
                                widthFactor: 0.4,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildText(WMSLocalizations.i18n(context)!
                                          .company_information_2),
                                      WMSDropdownWidget(
                                        saveInput: true,
                                        dataList1: state.companyList,
                                        inputInitialValue:
                                            state.company['name'].toString(),
                                        inputRadius: 4,
                                        inputSuffixIcon: Container(
                                          width: 24,
                                          height: 24,
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 16, 0),
                                          child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                          ),
                                        ),
                                        inputFontSize: 14,
                                        dropdownRadius: 4,
                                        dropdownTitle: 'name',
                                        dropdownKey: 'name',
                                        selectedCallBack: (value) {
                                          // 保存查询：会社id事件
                                          context.read<OperateLogBloc>().add(
                                              SetSearchEvent(1, 'name', value));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            //按钮
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Container(
                                margin: EdgeInsets.only(top: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildButtom(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_24,
                                        0),
                                    SizedBox(width: 32),
                                    buildButtom(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_25,
                                        1),
                                  ],
                                ),
                              ),
                            ),
                          ]),
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
  BlocBuilder<OperateLogBloc, OperateLogModel> buildCondition(int index) {
    return BlocBuilder<OperateLogBloc, OperateLogModel>(
      builder: (bloc, state) {
        return Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(90),
            border: Border.all(
              color: Color.fromRGBO(244, 244, 244, 1),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                conditionLabelList[index],
                style: TextStyle(
                  color: Color.fromRGBO(156, 156, 156, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      //操作内容
                      if (conditionLabelList[index].contains(
                          WMSLocalizations.i18n(context)!
                              .menu_content_99_6_1)) {
                        data1 = '';
                      }
                      //ログレベル
                      if (conditionLabelList[index].contains(
                          WMSLocalizations.i18n(context)!
                              .menu_content_99_6_2)) {
                        bloc
                            .read<OperateLogBloc>()
                            .add(SetSearchEvent(0, "name", {}));
                      }
                      //会社检索条件
                      if (conditionLabelList[index].contains(
                          WMSLocalizations.i18n(context)!
                              .company_information_2)) {
                        bloc
                            .read<OperateLogBloc>()
                            .add(SetSearchEvent(1, "name", {}));
                      }
                      conditionLabelList.removeAt(index);
                      context
                          .read<OperateLogBloc>()
                          .add(SetSearchListEvent(conditionLabelList));
                      if (conditionLabelList.length == 0 && _searchData) {
                        context.read<OperateLogBloc>().add(
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
                  )),
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
  BlocBuilder<OperateLogBloc, OperateLogModel> buildButtom(
      String text, int number) {
    return BlocBuilder<OperateLogBloc, OperateLogModel>(builder: (bloc, state) {
      return Container(
        color: Colors.white,
        height: 48,
        width: 220,
        child: OutlinedButton(
          onPressed: () {
            //检索按钮
            if (number == 0) {
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
                            .menu_content_99_6_1));
                    if (data1 != '') {
                      tempContent =
                          WMSLocalizations.i18n(context)!.menu_content_99_6_1 +
                              "：" +
                              data1;
                    }
                    tempValue = data1;
                  }
                  if (Number == 2) {
                    conditionLabelList.removeWhere((element) =>
                        element.contains(WMSLocalizations.i18n(context)!
                            .menu_content_99_6_2));

                    if (state.typeKbn != '' || state.typeKbn['name'] != null) {
                      tempContent =
                          WMSLocalizations.i18n(context)!.menu_content_99_6_2 +
                              "：" +
                              state.typeKbn['name'].toString();
                    }
                    tempValue = state.typeKbn['name'].toString();
                  }
                  if (Number == 3) {
                    conditionLabelList.removeWhere((element) =>
                        element.contains(WMSLocalizations.i18n(context)!
                            .company_information_2));
                    if (state.company != '' || state.company['name'] != null) {
                      tempContent = WMSLocalizations.i18n(context)!
                              .company_information_2 +
                          "：" +
                          state.company['name'].toString();
                    }
                    tempValue = state.company['name'].toString();
                  }

                  if (tempContent != '' &&
                      tempValue != '' &&
                      tempValue != 'null') {
                    conditionLabelList.add(tempContent);
                  }
                  context
                      .read<OperateLogBloc>()
                      .add(SetSearchListEvent(conditionLabelList));
                } while (Number < 4);
                if (conditionLabelList.length != 0) {
                  _searchData = true;
                }
                context.read<OperateLogBloc>().add(
                    QuerySearchShipStateEvent(conditionLabelList, context));
              });
            } else {
              //清空输入框内容
              setState(() {
                data1 = '';
                bloc.read<OperateLogBloc>().add(SetSearchEvent(0, "name", {}));
                bloc.read<OperateLogBloc>().add(SetSearchEvent(1, "name", {}));
                conditionLabelList.clear();
                context.read<OperateLogBloc>().add(SetSearchListEvent([]));
                context
                    .read<OperateLogBloc>()
                    .add(QuerySearchShipStateEvent([], context));
              });
            }
          },
          child: Text(text,
              style: TextStyle(color: Color.fromRGBO(44, 167, 176, 1))),
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
  }
}
