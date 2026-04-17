import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/mst/warehouse_master/bloc/warehouse_master_bloc.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../bloc/warehouse_master_model.dart';

/**
 * 内容：倉庫マスタ管理SP-主页
 * 作者：luxy
 * 时间：2023/11/21
 */
class WarehouseMasterSearch extends StatefulWidget {
  const WarehouseMasterSearch({super.key});
  @override
  State<WarehouseMasterSearch> createState() => _WarehouseMasterState();
}

class _WarehouseMasterState extends State<WarehouseMasterSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseMasterBloc, WarehouseMasterModel>(
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
                      .read<WarehouseMasterBloc>()
                      .add(SearchButtonHoveredChangeEvent(true));
                },
                onExit: (_) {
                  //
                  context
                      .read<WarehouseMasterBloc>()
                      .add(SearchButtonHoveredChangeEvent(false));
                },
                child: OutlinedButton.icon(
                  onPressed: () {
                    //
                    context
                        .read<WarehouseMasterBloc>()
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
          //外部检索条件框
          Visibility(
            visible: state.searchDataFlag,
            child: FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(20),
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
                        padding: EdgeInsets.only(bottom: 5),
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
          ),
          //内部检索条件框
          Visibility(
            visible: state.searchFlag,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
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
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          padding: EdgeInsets.all(20),
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
                                  padding: EdgeInsets.only(bottom: 5),
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
                                      .warehouse_master_1,
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
                                  // ID
                                  context
                                      .read<WarehouseMasterBloc>()
                                      .add(SetSearchValueEvent('id', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 赵士淞 - 始
                      Visibility(
                        visible: StoreProvider.of<WMSState>(context)
                                .state
                                .loginUser
                                ?.role_id ==
                            1,
                        child: FractionallySizedBox(
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
                                        .delivery_form_company,
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
                                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
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
                                      context.read<WarehouseMasterBloc>().add(
                                              SetSearchMapEvent({
                                            'company_id': value,
                                            'company_name': value
                                          }));
                                    } else {
                                      // 设定值
                                      context.read<WarehouseMasterBloc>().add(
                                              SetSearchMapEvent({
                                            'company_id': value['id'],
                                            'company_name': value['name']
                                          }));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 赵士淞 - 终
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
                                      .warehouse_master_2,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                text: state.searchInfo['code'].toString(),
                                inputBoxCallBack: (value) {
                                  // CD
                                  context
                                      .read<WarehouseMasterBloc>()
                                      .add(SetSearchValueEvent('code', value));
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
                                      .warehouse_master_3,
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
                                  // CD
                                  context
                                      .read<WarehouseMasterBloc>()
                                      .add(SetSearchValueEvent('name', value));
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
                                      .warehouse_master_4,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color.fromRGBO(6, 14, 15, 1),
                                  ),
                                ),
                              ),
                              WMSInputboxWidget(
                                text: state.searchInfo['kbn'].toString(),
                                inputBoxCallBack: (value) {
                                  // CD
                                  context
                                      .read<WarehouseMasterBloc>()
                                      .add(SetSearchValueEvent('kbn', value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      //解除按钮
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
                                  context),
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
                                  context),
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
                            .read<WarehouseMasterBloc>()
                            .add(SearchInkWellTapEvent());
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
    });
  }

  // 底部检索和解除按钮
  Container BuildButtom(String text, int number, WarehouseMasterModel state,
      BuildContext context) {
    return Container(
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () async {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            bool res = await context
                .read<WarehouseMasterBloc>()
                .seletMenuEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['id'] != '' ||
                  // 赵士淞 - 始
                  state.searchInfo['company_id'] != '' ||
                  state.searchInfo['company_name'] != '' ||
                  // 赵士淞 - 终
                  state.searchInfo['code'] != '' ||
                  state.searchInfo['name'] != '' ||
                  state.searchInfo['kbn'] != '') {
                //
                context
                    .read<WarehouseMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<WarehouseMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(false, false));
              }
            }
          } else {
            //解除检索条件
            context.read<WarehouseMasterBloc>().add(ClearSeletMenuEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: number == 0 ? Colors.white : Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
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

  // 检索条件内部数据
  Container buildCondition(int index, bool flg, WarehouseMasterModel state) {
    return Container(
      margin: index == 0
          ? EdgeInsets.only(left: 5, right: 10)
          : EdgeInsets.only(left: 5, right: 10, top: 5),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
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
          InkWell(
            onTap: () {
              context
                  .read<WarehouseMasterBloc>()
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
      searchName = WMSLocalizations.i18n(context)!.menu_master_form_1 +
          "：" +
          condition['value'];
      // 赵士淞 - 始
    } else if ('company_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.delivery_form_company +
          "：" +
          condition['value'];
      // 赵士淞 - 终
    } else if ('code' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.menu_master_form_2 +
          "：" +
          condition['value'];
    } else if ('name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.menu_master_form_3 +
          "：" +
          condition['value'];
    } else if ('kbn' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.menu_master_form_5 +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
