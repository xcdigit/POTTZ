import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/location_master/bloc/location_master_bloc.dart';
import 'package:wms/page/mst/location_master/bloc/location_master_model.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import 'location_master_title.dart';

/**
 * 内容：ロケーションマスタ管理-表单
 * 作者：熊草云
 * 时间：2023/09/06
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
//表单下拉框内容状态
bool kbnflag = true;
//表单按钮状态
bool btnFlag = true;

// ignore: must_be_immutable
class LocationMasterForm extends StatefulWidget {
  int locationId;
  int flag;
  LocationMasterForm({super.key, this.locationId = 0, this.flag = 0});

  @override
  State<LocationMasterForm> createState() => _LocationMasterFormState();
}

class _LocationMasterFormState extends State<LocationMasterForm> {
  @override
  Widget build(BuildContext context) {
    int roldId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    int companyId = 0;
    if (roldId != 1) {
      //获取当前登录用户会社ID
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }

    return BlocProvider<LocationMasterBloc>(
      create: (context) {
        return LocationMasterBloc(
          LocationMasterModel(companyId: companyId, roleId: roldId),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              LocationMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              LocationMasterFormContent(
                flag: widget.flag,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class LocationMasterFormContent extends StatefulWidget {
  int flag;
  LocationMasterFormContent({super.key, this.flag = 0});

  @override
  State<LocationMasterFormContent> createState() =>
      _LocationMasterFormContentState();
}

class _LocationMasterFormContentState extends State<LocationMasterFormContent> {
  bool flag = true;
  // 初始化基本情報入力表单
  BlocBuilder<LocationMasterBloc, LocationMasterModel> _initFormBasic() {
    return BlocBuilder<LocationMasterBloc, LocationMasterModel>(
        builder: (context, state) {
      return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: [
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      "ID",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: true,
                    text: state.detailsMap['id'] != '' &&
                            state.detailsMap['id'] != null
                        ? state.detailsMap['id'].toString()
                        : '',
                  ),
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.location_master_1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(255, 0, 0, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  btnFlag
                      ? WMSDropdownWidget(
                          dataList1: state.warehouseList,
                          inputInitialValue:
                              state.detailsMap['warehouse_name'].toString(),
                          dropdownTitle: 'name',
                          inputWidth: double.infinity,
                          inputBackgroundColor: Colors.white,
                          inputBorderColor: Color.fromRGBO(224, 224, 224, 1),
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
                          selectedCallBack: (value) {
                            if (value != '') {
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent(
                                      'warehouse_name', value['name']));
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent('warehouse_name_short',
                                      value['name_short']));
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent(
                                      'warehouse_id', value['id']));
                              // 赵士淞 - 始
                              if (state.roleId == 1) {
                                // 赵士淞 - 终
                                context.read<LocationMasterBloc>().add(
                                    SetFormWareAndKbnEvent(
                                        'company_id', value['company_id']));
                              }
                            } else {
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent('warehouse_name', ''));
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent(
                                      'warehouse_name_short', ''));
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent('warehouse_id', ''));
                            }
                          },
                        )
                      : WMSInputboxWidget(
                          readOnly: true,
                          text: state.detailsMap['warehouse_name'].toString(),
                        ),
                ],
              ),
            ),
          ),
          // ロケーションコード
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!
                          .start_inventory_location_code,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: true,
                    text: state.detailsMap['kbn'] == Config.LOCATION_KBN_S
                        ? ((state.detailsMap['warehouse_name'] != null &&
                                    state.detailsMap['warehouse_name'] != '') &&
                                (state.detailsMap['kbn'] != '' &&
                                    state.detailsMap['kbn'] != null) &&
                                (state.detailsMap['zone_cd'] != null &&
                                    state.detailsMap['zone_cd'] != '') &&
                                (state.detailsMap['row_cd'] != '' &&
                                    state.detailsMap['row_cd'] != null) &&
                                (state.detailsMap['shelve_cd'] != '' &&
                                    state.detailsMap['shelve_cd'] != null) &&
                                (state.detailsMap['step_cd'] != '' &&
                                    state.detailsMap['step_cd'] != null)
                            ? state.detailsMap['warehouse_name_short']
                                    .toString() +
                                '-' +
                                state.detailsMap['kbn'].toString() +
                                '-' +
                                state.detailsMap['zone_cd'].toString() +
                                '-' +
                                state.detailsMap['row_cd'].toString() +
                                '-' +
                                state.detailsMap['shelve_cd'].toString() +
                                '-' +
                                state.detailsMap['step_cd'].toString()
                            : '')
                        : ((state.detailsMap['warehouse_name'] != null &&
                                    state.detailsMap['warehouse_name'] != '') &&
                                (state.detailsMap['kbn'] != '' &&
                                    state.detailsMap['kbn'] != null) &&
                                (state.detailsMap['floor_cd'] != null &&
                                    state.detailsMap['floor_cd'] != '')
                            ? state.detailsMap['warehouse_name_short']
                                    .toString() +
                                '-' +
                                state.detailsMap['kbn'].toString() +
                                '-' +
                                state.detailsMap['floor_cd'].toString()
                            : ''),
                    // inputBoxCallBack: (value) {
                    //   // state.detailsMap['loc_cd'] = value;
                    // },
                  ),
                ],
              ),
            ),
          ),
          // 区分
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.location_master_2,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(255, 0, 0, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  btnFlag
                      ? WMSDropdownWidget(
                          dataList1: state.locationKbn,
                          inputInitialValue: state.detailsMap['kbn'].toString(),
                          inputWidth: double.infinity,
                          inputBackgroundColor: Colors.white,
                          inputBorderColor: Color.fromRGBO(224, 224, 224, 1),
                          inputRadius: 4,
                          inputSuffixIcon: Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                          ),
                          dropdownTitle: 'kbn',
                          dropdownKey: 'kbn',
                          inputFontSize: 14,
                          dropdownRadius: 4,
                          selectedCallBack: (value) {
                            if (value != '') {
                              context.read<LocationMasterBloc>().add(
                                  SetFormWareAndKbnEvent('kbn', value['kbn']));
                              // 判断区分
                              if (state.detailsMap['kbn'] !=
                                  Config.LOCATION_KBN_S) {
                                state.detailsMap['room_cd'] = '';
                                state.detailsMap['zone_cd'] = '';
                                state.detailsMap['row_cd'] = '';
                                state.detailsMap['shelve_cd'] = '';
                                state.detailsMap['step_cd'] = '';
                                state.detailsMap['range_cd'] = '';
                                state.detailsMap['keeping_volume'] = '';
                                state.detailsMap['area'] = '';
                              }
                            } else {
                              context
                                  .read<LocationMasterBloc>()
                                  .add(SetFormWareAndKbnEvent('kbn', ''));
                            }
                          },
                        )
                      : WMSInputboxWidget(
                          readOnly: true,
                          text: state.detailsMap['kbn'].toString(),
                        ),
                ],
              ),
            ),
          ),
          // フロア
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          state.detailsMap['kbn'] == null ||
                                  state.detailsMap['kbn'] == '' ||
                                  state.detailsMap['kbn'] ==
                                      Config.LOCATION_KBN_S
                              ? WMSLocalizations.i18n(context)!
                                  .start_inventory_location_floor
                              : WMSLocalizations.i18n(context)!
                                  .confirmation_data_table_title_1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(255, 0, 0, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly: flag,
                    text: state.detailsMap['floor_cd'] != '' &&
                            state.detailsMap['floor_cd'] != null
                        ? state.detailsMap['floor_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('floor_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 部屋
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .start_inventory_location_room,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['room_cd'] != '' &&
                            state.detailsMap['room_cd'] != null
                        ? state.detailsMap['room_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('room_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // ゾーン
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .start_inventory_location_zone,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['zone_cd'] != '' &&
                            state.detailsMap['zone_cd'] != null
                        ? state.detailsMap['zone_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('zone_cd', value));
                      // state.detailsMap['zone_cd'] = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          // 列
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .start_inventory_location_column,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['row_cd'] != '' &&
                            state.detailsMap['row_cd'] != null
                        ? state.detailsMap['row_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('row_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 棚
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .start_inventory_location_shelf,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['shelve_cd'] != '' &&
                            state.detailsMap['shelve_cd'] != null
                        ? state.detailsMap['shelve_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('shelve_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 段
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!
                              .start_inventory_location_stage,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['step_cd'] != '' &&
                            state.detailsMap['step_cd'] != null
                        ? state.detailsMap['step_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('step_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 間口
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.location_master_3,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['range_cd'] != '' &&
                            state.detailsMap['range_cd'] != null
                        ? state.detailsMap['range_cd']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('range_cd', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 保管容量
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.location_master_4,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['keeping_volume'] != '' &&
                            state.detailsMap['keeping_volume'] != null
                        ? state.detailsMap['keeping_volume'].toString()
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('keeping_volume', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // エリア
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 72,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Row(
                      children: [
                        Text(
                          WMSLocalizations.i18n(context)!.location_master_5,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        Visibility(
                          visible: state.detailsMap['kbn'] == 'S',
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WMSInputboxWidget(
                    readOnly:
                        state.detailsMap['kbn'] != Config.LOCATION_KBN_S ||
                            flag,
                    text: state.detailsMap['area'] != '' &&
                            state.detailsMap['area'] != null
                        ? state.detailsMap['area']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('area', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 社内備考1
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 160,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.customer_master_16,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    readOnly: flag,
                    text: state.detailsMap['note1'] != '' &&
                            state.detailsMap['note1'] != null
                        ? state.detailsMap['note1']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('note1', value));
                    },
                  ),
                ],
              ),
            ),
          ),
          // 社内備考2
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Container(
              height: 160,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.customer_master_17,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  ),
                  WMSInputboxWidget(
                    height: 136,
                    maxLines: 5,
                    readOnly: flag,
                    text: state.detailsMap['note2'] != '' &&
                            state.detailsMap['note2'] != null
                        ? state.detailsMap['note2']
                        : '',
                    inputBoxCallBack: (value) {
                      context
                          .read<LocationMasterBloc>()
                          .add(SetFormWareAndKbnEvent('note2', value));
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //仓库数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocBuilder<LocationMasterBloc, LocationMasterModel>(
      builder: (context, state) {
        if (currentFlag) {
          //明细按钮输入框不可输入
          if (widget.flag == 0) {
            flag = true;
            btnFlag = false;
            context
                .read<LocationMasterBloc>()
                .add(SetLocationValueEvent(data, "2"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          } else {
            //登录和修正按钮，输入框可以输入
            flag = false;
            btnFlag = true;
            context
                .read<LocationMasterBloc>()
                .add(SetLocationValueEvent(data, "1"));
            //控制刷新
            StoreProvider.of<WMSState>(context)
                .dispatch(RefreshCurrentFlagAction(false));
          }
          kbnflag = true;
        }
        return Container(
          margin: EdgeInsets.only(
            bottom: 40,
          ),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: LocationMasterFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: LocationMasterFormButton(),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: _initFormBasic(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 出荷指示入力-表单Tab
// ignore: must_be_immutable
class LocationMasterFormTab extends StatefulWidget {
  LocationMasterFormTab({super.key});

  @override
  State<LocationMasterFormTab> createState() => _LocationMasterFormTabState();
}

class _LocationMasterFormTabState extends State<LocationMasterFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 46,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    );
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 出荷指示入力-表单按钮
class LocationMasterFormButton extends StatefulWidget {
  const LocationMasterFormButton({super.key});

  @override
  State<LocationMasterFormButton> createState() =>
      _LocationMasterFormButtonState();
}

class _LocationMasterFormButtonState extends State<LocationMasterFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          child: Container(
            margin: EdgeInsets.only(left: 20),
            height: 37,
            child: OutlinedButton(
              onPressed: () {
                // 判断循环下标
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  kbnflag = false;
                  //清除表单数据
                  context
                      .read<LocationMasterBloc>()
                      .add(ClearLocationValueEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE &&
                    btnFlag) {
                  // 修改表单表单事件
                  context
                      .read<LocationMasterBloc>()
                      .add(UpdateLocationValueEvent(context));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonItemList[i]['index'] == Config.NUMBER_ZERO
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : (!btnFlag
                          ? Color.fromRGBO(95, 97, 97, 1)
                          : Color.fromRGBO(44, 167, 176, 1)),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              child: Text(
                buttonItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.28,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': context.read<LocationMasterBloc>().state.detailsMap['id'] ==
                    null ||
                context.read<LocationMasterBloc>().state.detailsMap['id'] ==
                    '' ||
                context.read<LocationMasterBloc>().state.formFlag == '1'
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
