import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_bloc.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';

/**
 * 内容：得意先マスタ管理-主页
 * 作者：王光顺
 * 时间：2023/09/05
 */
class CustomerMasterSearch extends StatefulWidget {
  const CustomerMasterSearch({super.key});

  @override
  State<CustomerMasterSearch> createState() => _CustomerMasterSearchState();
}

class _CustomerMasterSearchState extends State<CustomerMasterSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerMasterBloc, CustomerMasterModel>(
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
                        .read<CustomerMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(true));
                  },
                  onExit: (_) {
                    //
                    context
                        .read<CustomerMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(false));
                  },
                  child: OutlinedButton.icon(
                    onPressed: () {
                      //
                      context
                          .read<CustomerMasterBloc>()
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
                          Image.asset(WMSICons.WAREHOUSE_MENU_ICON, height: 18),
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
                          style:
                              TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                        ),
                      ),
                    ),
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
                                        .delivery_note_11,
                                    style: TextStyle(
                                        color: Color.fromRGBO(0, 122, 255, 1)),
                                  ),
                                ),
                              ),
                              for (int i = 0;
                                  i < state.conditionList.length;
                                  i++)
                                buildCondition(i, true, state)
                            ],
                          ),
                        ),
                        // 检索条件主体内容
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .customer_master_1,
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
                                    context
                                        .read<CustomerMasterBloc>()
                                        .add(SetSearchValueEvent('id', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .customer_master_2,
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
                                    // 设定会社名称
                                    context.read<CustomerMasterBloc>().add(
                                        SetSearchValueEvent('name', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .customer_master_11,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text:
                                      state.searchInfo['owner_name'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定会社名称
                                    context.read<CustomerMasterBloc>().add(
                                        SetSearchValueEvent(
                                            'owner_name', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        .customer_master_12,
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
                                    context.read<CustomerMasterBloc>().add(
                                        SetSearchValueEvent('contact', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //会社名
                        FractionallySizedBox(
                          widthFactor: 1,
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
                                        dataList1: state.salesCompanyInfoList,
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
                                                .read<CustomerMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                    'company_id', ''));
                                            context
                                                .read<CustomerMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                    'company_name', ''));
                                          } else {
                                            // 设定值
                                            context
                                                .read<CustomerMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                  'company_id',
                                                  int.parse(value['id']),
                                                ));
                                            context
                                                .read<CustomerMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                  'company_name',
                                                  value['name'],
                                                ));
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
                              .read<CustomerMasterBloc>()
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
      String text, int number, CustomerMasterModel state, int differ) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () async {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = context
                .read<CustomerMasterBloc>()
                .selectCustomerEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['id'] != '' ||
                  state.searchInfo['name'] != '' ||
                  state.searchInfo['owner_name'] != '' ||
                  state.searchInfo['contact'] != '' ||
                  state.searchInfo['company_id'] != '') {
                //
                context
                    .read<CustomerMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<CustomerMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(false, false));
              }
            }
          } else {
            //解除检索条件
            context.read<CustomerMasterBloc>().add(ClearSelectCustomerEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
              color:
                  differ == 1 ? Color.fromRGBO(44, 167, 176, 1) : Colors.white),
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

  // 检索条件内部数据
  Container buildCondition(int index, bool flg, CustomerMasterModel state) {
    return Container(
      margin: EdgeInsets.only(right: 10, bottom: 16),
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
              context
                  .read<CustomerMasterBloc>()
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
      searchName = WMSLocalizations.i18n(context)!.customer_master_1 +
          "：" +
          condition['value'];
    } else if ('name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.customer_master_2 +
          "：" +
          condition['value'];
    } else if ('owner_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.customer_master_11 +
          "：" +
          condition['value'];
    } else if ('contact' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.customer_master_12 +
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
