import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/mst/location_master/bloc/location_master_bloc.dart';
import 'package:wms/page/mst/location_master/bloc/location_master_model.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';

/**
 * 内容：ロケーションマスタ管理SP-检索条件
 * 作者：luxy
 * 时间：2023/11/22
 */
class LocationMasterSearch extends StatefulWidget {
  const LocationMasterSearch({super.key});

  @override
  State<LocationMasterSearch> createState() => _LocationMasterSearchState();
}

class _LocationMasterSearchState extends State<LocationMasterSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationMasterBloc, LocationMasterModel>(
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
                        .read<LocationMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(true));
                  },
                  onExit: (_) {
                    //
                    context
                        .read<LocationMasterBloc>()
                        .add(SearchButtonHoveredChangeEvent(false));
                  },
                  child: OutlinedButton.icon(
                    onPressed: () {
                      //
                      context
                          .read<LocationMasterBloc>()
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
                            style: TextStyle(
                                color: Color.fromRGBO(0, 122, 255, 1)),
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
                                          color:
                                              Color.fromRGBO(0, 122, 255, 1)),
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
                        //ロケーションコード
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
                                        .start_inventory_location_code,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['data1'].toString(),
                                  inputBoxCallBack: (value) {
                                    if (value != '') {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent('data1', value));
                                    } else {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent('data1', ''));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //倉庫名
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
                                        .location_master_1,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSDropdownWidget(
                                  dataList1: state.warehouseList,
                                  inputInitialValue: state
                                      .searchInfo['warehouse_name']
                                      .toString(),
                                  dropdownTitle: 'name',
                                  inputWidth: double.infinity,
                                  inputBackgroundColor: Colors.white,
                                  inputBorderColor:
                                      Color.fromRGBO(224, 224, 224, 1),
                                  inputRadius: 4,
                                  inputSuffixIcon:
                                      Icon(Icons.keyboard_arrow_down),
                                  selectedCallBack: (value) {
                                    if (value != '') {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent(
                                              'warehouse_name', value['name']));
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent(
                                              'warehouse_id', value['id']));
                                    } else {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent(
                                              'warehouse_name', ''));
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent(
                                              'warehouse_id', null));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //区分
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
                                        .location_master_2,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSDropdownWidget(
                                  dataList1: state.locationKbn,
                                  inputInitialValue:
                                      state.searchInfo['kbn'].toString(),
                                  dropdownTitle: 'kbn',
                                  dropdownKey: 'kbn',
                                  inputWidth: double.infinity,
                                  inputBackgroundColor: Colors.white,
                                  inputBorderColor:
                                      Color.fromRGBO(224, 224, 224, 1),
                                  inputRadius: 4,
                                  inputSuffixIcon:
                                      Icon(Icons.keyboard_arrow_down),
                                  selectedCallBack: (value) {
                                    if (value != '') {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent(
                                              'kbn', value['kbn']));
                                    } else {
                                      context
                                          .read<LocationMasterBloc>()
                                          .add(SetSearchValueEvent('kbn', ''));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //ゾーン
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
                                        .start_inventory_location_zone,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['data2'].toString(),
                                  inputBoxCallBack: (value) {
                                    if (value != '') {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent('data2', value));
                                    } else {
                                      context.read<LocationMasterBloc>().add(
                                          SetSearchValueEvent('data2', ''));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //取消检索条件
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
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //检索
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_24,
                                    0,
                                    state,
                                    0),
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
                              .read<LocationMasterBloc>()
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
      String text, int number, LocationMasterModel state, int differ) {
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
                .read<LocationMasterBloc>()
                .selectLocationEventBeforeCheck(context, state);
            if (res) {
              //缩小检索框，显示检索条件
              if (state.searchInfo['data1'] != '' ||
                  state.searchInfo['warehouse_id'] != '' ||
                  state.searchInfo['kbn'] != '' ||
                  state.searchInfo['data2'] != '') {
                //
                context
                    .read<LocationMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(true, false));
              } else {
                //
                context
                    .read<LocationMasterBloc>()
                    .add(SetSearchDataFlagAndSearchFlagEvent(false, false));
              }
            }
          } else {
            //解除检索条件
            context.read<LocationMasterBloc>().add(ClearSeletLocationEvent());
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

  // 检索条件内部数据
  Container buildCondition(int index, bool flg, LocationMasterModel state) {
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
              context
                  .read<LocationMasterBloc>()
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
    if ('data1' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.start_inventory_location_code +
              "：" +
              condition['value'];
    } else if ('warehouse_name' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.location_master_1 +
          "：" +
          condition['value'];
    } else if ('kbn' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.location_master_2 +
          "：" +
          condition['value'];
    } else if ('data2' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.start_inventory_location_zone +
              "：" +
              condition['value'];
    }
    return searchName;
  }
}
