import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_bloc.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

/**
 * 内容：配送業者マスタ管理PC-检索条件
 * 作者：cuihr
 * 时间：2023/12/01
 */

class DeliveryOperatorsMasterSearch extends StatefulWidget {
  const DeliveryOperatorsMasterSearch({super.key});

  @override
  State<DeliveryOperatorsMasterSearch> createState() =>
      _DeliveryOperatorsMasterSearchState();
}

class _DeliveryOperatorsMasterSearchState
    extends State<DeliveryOperatorsMasterSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryOperatorsMasterBloc,
        DeliveryOperatorsMasterModel>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 48,
                child: MouseRegion(
                  onEnter: (_) {
                    //
                    context
                        .read<DeliveryOperatorsMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(true));
                  },
                  onExit: (_) {
                    //
                    context
                        .read<DeliveryOperatorsMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(false));
                  },
                  child: OutlinedButton.icon(
                    onPressed: () {
                      //
                      context
                          .read<DeliveryOperatorsMasterBloc>()
                          .add(SearchOutlinedButtonPressedEvent());
                    },
                    icon: ColorFiltered(
                      colorFilter: state.searchFlag
                          ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : state.searchButtonHovered
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                              : ColorFilter.mode(Color.fromRGBO(0, 122, 255, 1),
                                  BlendMode.srcIn),
                      child:
                          Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 24),
                    ),
                    label: Text(
                      WMSLocalizations.i18n(context)!.delivery_note_1,
                      style: TextStyle(
                          color: state.searchFlag
                              ? Colors.white
                              : state.searchButtonHovered
                                  ? Colors.white
                                  : Color.fromRGBO(0, 122, 255, 1),
                          fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: state.searchFlag
                          ? Color.fromRGBO(0, 122, 255, 1)
                          : state.searchButtonHovered
                              ? Color.fromRGBO(0, 122, 255, .6)
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: state.searchDataFlag,
              child: Container(
                height: 50,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                      buildCondition(i, false, state)
                  ],
                ),
              ),
            ),
            Visibility(
              visible: state.searchFlag,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      borderRadius: BorderRadius.circular(8),
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
                          height: 50,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_11,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 122, 255, 1)),
                              ),
                              SizedBox(width: 10),
                              for (int i = 0;
                                  i < state.conditionList.length;
                                  i++)
                                buildCondition(i, true, state)
                            ],
                          ),
                        ),
                        // 检索条件主体内容
                        //運送会社ID
                        FractionallySizedBox(
                          widthFactor: 0.4,
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .operator_text_1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['id'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定ID
                                    context
                                        .read<DeliveryOperatorsMasterBloc>()
                                        .add(SetSearchValueEvent(
                                            'id', value, ''));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //運送会社名称
                        FractionallySizedBox(
                          widthFactor: 0.4,
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .operator_text_2,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['name'].toString(),
                                  inputBoxCallBack: (value) {
                                    context
                                        .read<DeliveryOperatorsMasterBloc>()
                                        .add(SetSearchValueEvent(
                                            'name', value, ''));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //担当者名
                        FractionallySizedBox(
                          widthFactor: 0.4,
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_table_chargePerson,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['contact'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定会社名称
                                    context
                                        .read<DeliveryOperatorsMasterBloc>()
                                        .add(SetSearchValueEvent(
                                            'contact', value, ''));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 会社名
                        FractionallySizedBox(
                          widthFactor: 0.4,
                          child: state.roleId == 1
                              ? Container(
                                  height: 80,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 24,
                                        child: Text(
                                          WMSLocalizations.i18n(context)!
                                              .company_information_2,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Color.fromRGBO(6, 14, 15, 1),
                                          ),
                                        ),
                                      ),
                                      WMSDropdownWidget(
                                        dataList1: state.companyList,
                                        inputInitialValue: state
                                            .searchInfo['company_name']
                                            .toString(),
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
                                        selectedCallBack: (value) {
                                          // 判断数值
                                          if (value == '') {
                                            // 设定值
                                            context
                                                .read<
                                                    DeliveryOperatorsMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                    'company_id', '', ''));
                                          } else {
                                            // 设定值
                                            context
                                                .read<
                                                    DeliveryOperatorsMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                    'company_id',
                                                    int.parse(value['id']),
                                                    value['name']));
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_24,
                                    0,
                                    state),
                                SizedBox(width: 32),
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_25,
                                    1,
                                    state),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // 删除检索窗口按钮
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(-10, 10),
                      child: InkWell(
                        onTap: () {
                          //
                          context
                              .read<DeliveryOperatorsMasterBloc>()
                              .add(SearchInkWellTapEvent());
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
                          child:
                              Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // 底部检索和解除按钮
  Container BuildButtom(
      String text, int number, DeliveryOperatorsMasterModel state) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = context
                .read<DeliveryOperatorsMasterBloc>()
                .selectOperatorsEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['id'] != '' ||
                  state.searchInfo['name'] != '' ||
                  state.searchInfo['contact'] != '' ||
                  state.searchInfo['company_id'] != '') {
                //
                context
                    .read<DeliveryOperatorsMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<DeliveryOperatorsMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(false, false));
              }
            }
          } else {
            //解除检索条件
            context
                .read<DeliveryOperatorsMasterBloc>()
                .add(ClearSelectOperatorsEvent());
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
  }

  // 检索条件内部数据
  Container buildCondition(
      int index, bool flg, DeliveryOperatorsMasterModel state) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getSearchName(state.conditionList[index]),
            style: TextStyle(color: Colors.black12),
          ),
          InkWell(
            onTap: () {
              context
                  .read<DeliveryOperatorsMasterBloc>()
                  .add(DeleteSearchValueEvent(index));
            },
            child: Text(
              flg ? 'x' : '',
              style: TextStyle(color: Colors.black12),
            ),
          ),
        ],
      ),
    );
  }

  //取得检索条件名称
  String _getSearchName(dynamic condition) {
    String searchName = "";
    if (condition['key'] == null || condition['value'] == null) {
      return searchName;
    }
    if ('id' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.operator_text_1 +
          "：" +
          condition['value'];
    } else if ('name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.operator_text_2 +
          "：" +
          condition['value'];
    } else if ('contact' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.delivery_table_chargePerson +
          "：" +
          condition['value'];
    } else if ('company_id' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_2 +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
