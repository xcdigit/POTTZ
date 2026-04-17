import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/shipping_master_bloc.dart';
import '../bloc/shipping_master_model.dart';

/**
 * 内容：荷主マスタ-检索条件
 * 作者：王光顺
 * 时间：2023/11/29
 */
class ShippingMasterSearch extends StatefulWidget {
  const ShippingMasterSearch({super.key});

  @override
  State<ShippingMasterSearch> createState() => _ShippingMasterSearchState();
}

class _ShippingMasterSearchState extends State<ShippingMasterSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShippingMasterBloc, ShippingMasterModel>(
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
                        .read<ShippingMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(true));
                  },
                  onExit: (_) {
                    //
                    context
                        .read<ShippingMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(false));
                  },
                  child: OutlinedButton.icon(
                    onPressed: () {
                      //
                      context
                          .read<ShippingMasterBloc>()
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
              visible: state.searchDataFlag && state.conditionList.length > 0,
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
                        // 荷主ID
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
                                        .shipping_master_form_1,
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
                                        .read<ShippingMasterBloc>()
                                        .add(SetSearchValueEvent('id', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 荷主名称
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
                                        .shipping_master_form_2,
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
                                    context.read<ShippingMasterBloc>().add(
                                        SetSearchValueEvent('name', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 荷主代表者
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
                                        .shipping_master_form_11,
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
                                    // 荷主代表者
                                    context.read<ShippingMasterBloc>().add(
                                        SetSearchValueEvent(
                                            'owner_name', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 荷主担当者
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
                                        .shipping_master_form_12,
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
                                    // 荷主担当者
                                    context.read<ShippingMasterBloc>().add(
                                        SetSearchValueEvent('contact', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 会社名称
                        state.roleId == 1
                            ? FractionallySizedBox(
                                widthFactor: 0.4,
                                child: Container(
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
                                        saveInput: true,
                                        inputInitialValue:
                                            state.searchInfo['company_name'] ==
                                                    null
                                                ? ''
                                                : state
                                                    .searchInfo['company_name']
                                                    .toString(),
                                        dropdownKey: 'name',
                                        dropdownTitle: 'name',
                                        dataList1: state.salesCompanyInfoList,
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
                                        selectedCallBack: (value) {
                                          // 设定值
                                          if (value is! String) {
                                            context
                                                .read<ShippingMasterBloc>()
                                                .add(SetNowCompanyIDEvent(
                                                    int.parse(value['id']
                                                        .toString())));
                                            context
                                                .read<ShippingMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                    'company_name',
                                                    value['name']));
                                          } else {
                                            context
                                                .read<ShippingMasterBloc>()
                                                .add(SetSearchValueEvent(
                                                    'company_name', ''));
                                            if (value.trim() != '' &&
                                                // ignore: unnecessary_null_comparison
                                                value != null) {
                                              WMSCommonBlocUtils.errorTextToast(
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .organization_master_tip_5);
                                            }
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),

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
                              .read<ShippingMasterBloc>()
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
  Container BuildButtom(String text, int number, ShippingMasterModel state) {
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
                .read<ShippingMasterBloc>()
                .selectMessageEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['id'] != '' ||
                  state.searchInfo['name'] != '' ||
                  state.searchInfo['owner_name'] != '' ||
                  state.searchInfo['contact'] != '' ||
                  state.searchInfo['company_name'] != '') {
                //
                context
                    .read<ShippingMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<ShippingMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(false, false));
              }
            }
          } else {
            //解除检索条件
            context.read<ShippingMasterBloc>().add(ClearSelectMessageEvent());
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
  Container buildCondition(int index, bool flg, ShippingMasterModel state) {
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
                  .read<ShippingMasterBloc>()
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
      searchName = WMSLocalizations.i18n(context)!.shipping_master_form_1 +
          "：" +
          condition['value'];
    } else if ('name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.shipping_master_form_2 +
          "：" +
          condition['value'];
    } else if ('owner_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.shipping_master_form_11 +
          "：" +
          condition['value'];
    } else if ('contact' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.shipping_master_form_12 +
          "：" +
          condition['value'];
    } else if ('company_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_2 +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
