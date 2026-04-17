import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_bloc.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

/**
 * 内容：納入先マスタ-检索
 * 作者：张博睿
 * 时间：2023/09/06
 */

class DeliverySearch extends StatefulWidget {
  const DeliverySearch({
    super.key,
  });

  @override
  State<DeliverySearch> createState() => _DeliverySearchState();
}

class _DeliverySearchState extends State<DeliverySearch> {
  // 检索按钮追踪
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryBloc, DeliveryModel>(
      builder: (context, state) {
        return Container(
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
                          //
                          context
                              .read<DeliveryBloc>()
                              .add(SearchButtonHoveredChangeEvent(true));
                        },
                        onExit: (_) {
                          //
                          context
                              .read<DeliveryBloc>()
                              .add(SearchButtonHoveredChangeEvent(false));
                        },
                        child: OutlinedButton.icon(
                          onPressed: () {
                            //
                            context
                                .read<DeliveryBloc>()
                                .add(SearchOutlinedButtonPressedEvent());
                          },
                          icon: ColorFiltered(
                            colorFilter: state.searchFlag
                                ? ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn)
                                : state.searchButtonHovered
                                    ? ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Color.fromRGBO(0, 122, 255, 1),
                                        BlendMode.srcIn),
                            child: Image.asset(WMSICons.WAREHOUSE_MENU_ICON,
                                height: 18),
                          ),
                          label: Text(
                            WMSLocalizations.i18n(context)!
                                .delivery_search_conditions_button,
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
                  ],
                ),
              ),
              //搜索条件
              Visibility(
                visible: state.searchDataFlag,
                child: Container(
                  width: double.infinity,
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
                  child: Wrap(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                          child: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_11,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 122, 255, 1)),
                          ),
                        ),
                      ),
                      for (int i = 0; i < state.conditionList.length; i++)
                        state.conditionList[i]['key'] != 'company_id'
                            ? buildCondition(i, false, state)
                            : Container()
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: state.searchFlag,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.only(left: 31, right: 32, bottom: 30),
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
                            child: Wrap(
                              children: [
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_search_conditions,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(0, 122, 255, 1)),
                                    ),
                                  ),
                                ),
                                for (int i = 0;
                                    i < state.conditionList.length;
                                    i++)
                                  state.conditionList[i]['key'] != 'company_id'
                                      ? buildCondition(i, true, state)
                                      : Container()
                              ],
                            ),
                          ),
                          // 检索条件主体内容
                          FractionallySizedBox(
                            //納入先id
                            widthFactor: 1,
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_search_id,
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
                                      // 设定会社ID
                                      context.read<DeliveryBloc>().add(
                                          SetSearchValueEvent('id', value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            //納入先名称
                            widthFactor: 1,
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_search_name,
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
                                      // 设定会社ID
                                      context.read<DeliveryBloc>().add(
                                          SetSearchValueEvent('name', value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            //納入先略称
                            widthFactor: 1,
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_search_abbreviation,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color.fromRGBO(6, 14, 15, 1),
                                      ),
                                    ),
                                  ),
                                  WMSInputboxWidget(
                                    text: state.searchInfo['name_short']
                                        .toString(),
                                    inputBoxCallBack: (value) {
                                      // 设定略称
                                      context.read<DeliveryBloc>().add(
                                          SetSearchValueEvent(
                                              'name_short', value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            //担当者名
                            widthFactor: 1,
                            child: Container(
                              height: 80,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_search_chargePerson,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color.fromRGBO(6, 14, 15, 1),
                                      ),
                                    ),
                                  ),
                                  WMSInputboxWidget(
                                    text: state.searchInfo['person'].toString(),
                                    inputBoxCallBack: (value) {
                                      // 设定担当者名
                                      context.read<DeliveryBloc>().add(
                                          SetSearchValueEvent('person', value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          state.roleId == 1
                              ? FractionallySizedBox(
                                  //会社名
                                  widthFactor: 1,
                                  child: Container(
                                    height: 80,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .delivery_search_company,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Color.fromRGBO(6, 14, 15, 1),
                                            ),
                                          ),
                                        ),
                                        WMSDropdownWidget(
                                          dataList1: state.companyList,
                                          inputInitialValue:
                                              state.searchInfo['company_name'],
                                          inputRadius: 4,
                                          inputSuffixIcon: Container(
                                            width: 24,
                                            height: 24,
                                            margin: EdgeInsets.fromLTRB(
                                                0, 0, 16, 0),
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                            ),
                                          ),
                                          inputFontSize: 14,
                                          dropdownRadius: 4,
                                          dropdownTitle: 'name',
                                          selectedCallBack: (value) {
                                            // 设定值
                                            context.read<DeliveryBloc>().add(
                                                SetSearchValueEvent(
                                                    'company_id', value['id']));
                                            // 设定值
                                            context.read<DeliveryBloc>().add(
                                                SetSearchValueEvent(
                                                    'company_name',
                                                    value['name']));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : FractionallySizedBox(),
                          //解除全部
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BuildButtom(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_25,
                                      1,
                                      state,
                                      1),
                                ],
                              ),
                            ),
                          ),
                          //检索按钮
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BuildButtom(
                                      WMSLocalizations.i18n(context)!
                                          .delivery_note_24,
                                      0,
                                      state,
                                      0)
                                ],
                              ),
                            ),
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
                            //
                            context
                                .read<DeliveryBloc>()
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

  // 底部检索和解除按钮
  Container BuildButtom(
      String text, int number, DeliveryModel state, int differ) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 220,
      child: OutlinedButton(
        onPressed: () async {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = context
                .read<DeliveryBloc>()
                .selectDeliveryEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['id'] != '' ||
                  state.searchInfo['name'] != '' ||
                  state.searchInfo['name_short'] != '' ||
                  state.searchInfo['person'] != '' ||
                  state.searchInfo['company_id'] != '') {
                //
                context
                    .read<DeliveryBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<DeliveryBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(false, false));
              }
            }
          } else {
            //解除检索条件
            context.read<DeliveryBloc>().add(ClearSelectDeliveryEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: differ == 1 ? Color.fromRGBO(44, 167, 176, 1) : Colors.white,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: differ == 1
              ? MaterialStateProperty.all(Colors.white)
              : MaterialStateProperty.all(Color.fromRGBO(44, 167, 176, 1)),
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

  //检索条件内部数据
  Container buildCondition(int index, bool flg, DeliveryModel state) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, right: 10),
      padding: EdgeInsets.all(6),
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
            _getSearchName(state.conditionList[index]),
            style: TextStyle(color: Colors.black12),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              context.read<DeliveryBloc>().add(DeleteSearchValueEvent(index));
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
      searchName = WMSLocalizations.i18n(context)!.delivery_search_id +
          "：" +
          condition['value'];
    } else if ('name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.delivery_search_name +
          "：" +
          condition['value'];
    } else if ('name_short' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.delivery_search_abbreviation +
              "：" +
              condition['value'];
    } else if ('person' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.delivery_search_chargePerson +
              "：" +
              condition['value'];
    } else if ('company_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.delivery_search_company +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
