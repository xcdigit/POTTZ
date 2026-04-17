import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/location.dart';
import 'package:wms/redux/wms_state.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/printer_utils.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'location_master_model.dart';

/**
 * 内容：ロケーションマスタ管理 -BLOC
 * 作者：cuihr
 * 时间：2023/09/11
 */
// 事件
abstract class LocationMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends LocationMasterEvent {
  // 初始化事件
  InitEvent();
}

//
class SetFormWareAndKbnEvent extends LocationMasterEvent {
  String key;
  dynamic value;
  SetFormWareAndKbnEvent(this.key, this.value);
}

//清除表单
class ClearLocationValueEvent extends LocationMasterEvent {
  // 设定值事件
  ClearLocationValueEvent();
}

//修改表单
class UpdateLocationValueEvent extends LocationMasterEvent {
  // 结构树
  BuildContext context;
  UpdateLocationValueEvent(this.context);
}

// 赵士淞 - 始
// 打印事件
class PrinterEvent extends LocationMasterEvent {
  // 上下文
  BuildContext context;

  // 打印事件
  PrinterEvent(this.context);
}
// 赵士淞 - 终

//删除数据
class DeleteLocationMasterEvent extends LocationMasterEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteLocationMasterEvent(this.context, this.Id);
}

// 设定出荷指示值事件
class SetLocationValueEvent extends LocationMasterEvent {
  // Value
  dynamic value;
  String formFlag;
  // 设定值事件
  SetLocationValueEvent(this.value, this.formFlag);
}

//
class SearchButtonHoveredChangeEvent extends LocationMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends LocationMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends LocationMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends LocationMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设定检索条件值事件
class SetSearchValueEvent extends LocationMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

//检索处理
class SeletLocationEvent extends LocationMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletLocationEvent(this.context);
}

//清除检索条件
class ClearSeletLocationEvent extends LocationMasterEvent {
  //检索处理
  ClearSeletLocationEvent();
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends LocationMasterEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设置sort字段
class SetSortEvent extends LocationMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class LocationMasterBloc extends WmsTableBloc<LocationMasterModel> {
  //刷新补丁
  @override
  LocationMasterModel clone(LocationMasterModel src) {
    return LocationMasterModel.clone(src);
  }

  //表格数据
  LocationMasterBloc(LocationMasterModel state) : super(state) {
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 自定义事件 - 始
      // 初期化表单
      initForm(state);

      // 查询仓库
      List<dynamic> warehouseData = [];
      if (state.companyId != 0) {
        warehouseData = await SupabaseUtils.getClient()
            .from('mtb_warehouse')
            .select('*')
            .eq('company_id', state.companyId);
      } else {
        warehouseData =
            await SupabaseUtils.getClient().from('mtb_warehouse').select('*');
      }
      state.warehouseList = warehouseData;

      // 更新
      // emit(clone(state));
      // 加载标记
      state.loadingFlag = false;
      // 自定义事件 - 终
      add(PageQueryEvent());
    });

    //
    on<SetFormWareAndKbnEvent>(
      (event, emit) {
        if (event.key == 'company_id') {
          state.companyId = event.value;
        }
        Map<String, dynamic> formTemp = Map<String, dynamic>();
        formTemp.addAll(state.detailsMap);
        // 判断key
        if (formTemp[event.key] != null) {
          // 供应商情报-临时
          formTemp[event.key] = event.value;
        } else {
          // 供应商情报-临时
          formTemp.addAll({event.key: event.value});
        }
        // 供应商情报-定制
        state.detailsMap = formTemp;

        emit(clone(state));
      },
    );

    //表单清除
    on<ClearLocationValueEvent>(
      (event, emit) {
        // 初期化表单
        initForm(state);
        // 更新
        emit(clone(state));
      },
    );

    // 修改
    on<UpdateLocationValueEvent>(
      (event, emit) async {
        //倉庫名为空
        if (state.detailsMap['warehouse_name'] == null ||
            state.detailsMap['warehouse_name'] == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.location_master_1 +
                  WMSLocalizations.i18n(event.context)!.can_not_null_text);
          return;
        }
        //区分
        if (state.detailsMap['kbn'] == null || state.detailsMap['kbn'] == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.location_master_2 +
                  WMSLocalizations.i18n(event.context)!.can_not_null_text);
          return;
        }
        //フロア
        if (state.detailsMap['floor_cd'] == null ||
            state.detailsMap['floor_cd'] == '') {
          //
          if (state.detailsMap['kbn'] == null ||
              state.detailsMap['kbn'] == '' ||
              state.detailsMap['kbn'] == Config.LOCATION_KBN_S) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_floor +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
          } else {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .confirmation_data_table_title_1 +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
          }
          return;
        } else if (CheckUtils.check_Half_Alphanumeric(
            state.detailsMap['floor_cd'])) {
          //
          if (state.detailsMap['kbn'] == null ||
              state.detailsMap['kbn'] == '' ||
              state.detailsMap['kbn'] == Config.LOCATION_KBN_S) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_floor +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
          } else {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .confirmation_data_table_title_1 +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
          }
          return;
        }
        // 判断区分
        if (state.detailsMap['kbn'] == Config.LOCATION_KBN_S) {
          //部屋
          if (state.detailsMap['room_cd'] == null ||
              state.detailsMap['room_cd'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_room +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          } else if (CheckUtils.check_Half_Alphanumeric(
              state.detailsMap['room_cd'])) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_room +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
            return;
          }
          //ゾーン
          if (state.detailsMap['zone_cd'] == null ||
              state.detailsMap['zone_cd'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_zone +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          } else if (CheckUtils.check_Half_Alphanumeric(
              state.detailsMap['zone_cd'])) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_zone +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
            return;
          }
          //列
          if (state.detailsMap['row_cd'] == null ||
              state.detailsMap['row_cd'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_column +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          } else if (CheckUtils.check_Half_Alphanumeric(
              state.detailsMap['row_cd'])) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_column +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
            return;
          }
          // 棚
          if (state.detailsMap['shelve_cd'] == null ||
              state.detailsMap['shelve_cd'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_shelf +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          } else if (CheckUtils.check_Half_Alphanumeric(
              state.detailsMap['shelve_cd'])) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_shelf +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
            return;
          }
          //段
          if (state.detailsMap['step_cd'] == null ||
              state.detailsMap['step_cd'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_stage +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          } else if (CheckUtils.check_Half_Alphanumeric(
              state.detailsMap['step_cd'])) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                        .start_inventory_location_stage +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric);
            return;
          }
          // 間口
          if (state.detailsMap['range_cd'] == null ||
              state.detailsMap['range_cd'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.location_master_3 +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          }
          //保管容量
          if (state.detailsMap['keeping_volume'] == null ||
              state.detailsMap['keeping_volume'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.location_master_4 +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          } else if (CheckUtils.check_Half_Number_In_10(
              state.detailsMap['keeping_volume'])) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.location_master_4 +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_numbers_in_10);
            return;
          }
          //エリア
          if (state.detailsMap['area'] == null ||
              state.detailsMap['area'] == '') {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.location_master_5 +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          }
        }
        // 赵士淞 - 测试修复 2023/11/16 - 始
        if (state.detailsMap['id'] == null || state.detailsMap['id'] == '') {
          state.detailsMap.remove('id');
        } else {
          state.detailsMap['id'] = int.parse(state.detailsMap['id'].toString());
        }
        if (state.detailsMap['keeping_volume'] == null ||
            state.detailsMap['keeping_volume'] == '') {
          state.detailsMap.remove('keeping_volume');
        } else {
          state.detailsMap['keeping_volume'] =
              double.parse(state.detailsMap['keeping_volume'].toString());
        }
        // ロケーションコード
        String loc_value = '';
        // 判断区分
        if (state.detailsMap['kbn'] == Config.LOCATION_KBN_S) {
          loc_value = state.detailsMap['warehouse_name_short'].toString() +
              '-' +
              state.detailsMap['kbn'].toString() +
              '-' +
              state.detailsMap['zone_cd'].toString() +
              '-' +
              state.detailsMap['row_cd'].toString() +
              '-' +
              state.detailsMap['shelve_cd'].toString() +
              '-' +
              state.detailsMap['step_cd'].toString();
        } else {
          loc_value = state.detailsMap['warehouse_name_short'].toString() +
              '-' +
              state.detailsMap['kbn'].toString() +
              '-' +
              state.detailsMap['floor_cd'].toString();
        }
        // 赵士淞 - 测试修复 2023/11/16 - 终
        state.detailsMap.addAll({'loc_cd': loc_value});

        //location数据
        List<Map<String, dynamic>> locationData;
        //location
        Location loc = Location.fromJson(state.detailsMap);

        // 打开加载状态
        BotToast.showLoading();
        // 判断位置id
        if (loc.id == null) {
          //判断code是否重复
          bool check = await checkLocCode(state.detailsMap['loc_cd'], -1);
          if (!check) {
            //重复报错
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!
                    .location_master_locCode_check);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          // loc.kbn = Config.LOCATION_KBN_S;
          loc.company_id = state.companyId;
          loc.del_kbn = Config.DELETE_NO;
          loc.loc_cd = state.detailsMap['loc_cd'];
          loc.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          loc.create_time = DateTime.now().toString();
          loc.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          loc.update_time = DateTime.now().toString();
          try {
            // 新增mtb_location
            locationData = await SupabaseUtils.getClient()
                .from('mtb_location')
                .insert([loc.toJson()]).select('*');
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_16 +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_16 +
                    WMSLocalizations.i18n(event.context)!.create_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } else {
          //判断code是否重复
          bool check = await checkLocCode(state.detailsMap['loc_cd'], loc.id);
          if (!check) {
            //重复报错
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!
                    .location_master_locCode_check);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          // location修改时间
          loc.update_time = DateTime.now().toString();
          //location修改人
          loc.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          try {
            // 修改mtb_location
            locationData = await SupabaseUtils.getClient()
                .from('mtb_location')
                .update(loc.toJson())
                .eq('id', loc.id)
                .select('*');
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_16 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_16 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        }
        state.detailsMap = locationData[0];
        //更新
        // emit(clone(state));
        // 返回上一页
        GoRouter.of(event.context).pop('refresh return');
        initForm(state);
        //初期化检索条件
        initSearch(state);
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );

    // 赵士淞 - 始
    // 打印事件
    on<PrinterEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 表格选中数据
      Map<String, dynamic> wmsRecordModelData = state.checkedRecords()[0].data;
      // 查询位置管理
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('id', wmsRecordModelData['id']);
      // 查询倉庫マスタ
      List<dynamic> warehouseData = [];
      // 判断位置数量
      if (locationData.length != 0) {
        // 查询倉庫マスタ
        warehouseData = await SupabaseUtils.getClient()
            .from('mtb_warehouse')
            .select('*')
            .eq('id', locationData[0]['warehouse_id']);
      }
      // 判断仓库数量
      if (warehouseData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {
          'code': locationData[0]['loc_cd'],
          'name': warehouseData[0]['name_short'],
        };
        // 编码打印
        PrinterUtils.codePrint(printData);
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.miss_param_unable_print);
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 赵士淞 - 终

    // 删除
    on<DeleteLocationMasterEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        try {
          // 修改location
          await SupabaseUtils.getClient()
              .from('mtb_location')
              .update({'del_kbn': Config.DELETE_YES}).eq('id', event.Id);
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_16 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_16 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );

    //
    on<SetLocationValueEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        //初期化表单
        initForm(state);

        state.detailsMap = event.value;

        state.formFlag = event.formFlag;
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );

    //
    on<SearchButtonHoveredChangeEvent>((event, emit) async {
      //
      state.searchButtonHovered = event.flag;
      // 更新
      emit(clone(state));
    });

    //
    on<SearchOutlinedButtonPressedEvent>((event, emit) async {
      state.searchFlag = !state.searchFlag;
      if (state.searchFlag) {
        state.searchDataFlag = false;
      } else if (state.conditionList.length > 0) {
        state.searchDataFlag = true;
      } else {
        state.searchDataFlag = false;
      }
      // 更新
      emit(clone(state));
    });

    //
    on<SearchInkWellTapEvent>((event, emit) async {
      state.searchFlag = !state.searchFlag;
      if (state.conditionList.length > 0) {
        state.searchDataFlag = true;
      } else {
        state.searchDataFlag = false;
      }
      // 更新
      emit(clone(state));
    });

    //
    on<SetSearchDataFlagAndSearchFlagEvent>((event, emit) async {
      state.searchDataFlag = event.searchDataFlag;
      state.searchFlag = event.searchFlag;
      // 更新
      emit(clone(state));
    });

    // 设定检索条件值事件
    on<SetSearchValueEvent>((event, emit) async {
      // 检索情报-临时
      Map<String, dynamic> searchTemp = Map<String, dynamic>();
      searchTemp.addAll(state.searchInfo);
      // 判断key
      if (searchTemp[event.key] != null) {
        // 检索情报-临时
        searchTemp[event.key] = event.value;
      } else {
        // 检索情报-临时
        searchTemp.addAll({event.key: event.value});
      }
      // 检索情报-定制
      state.searchInfo = searchTemp;

      // 更新
      emit(clone(state));
    });

    // 检索处理
    on<SeletLocationEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['data1'] != '' &&
          state.searchInfo['data1'] != null) {
        state.conditionList
            .add({'key': 'data1', 'value': state.searchInfo['data1']});
      }
      if (state.searchInfo['warehouse_name'] != '' &&
          state.searchInfo['warehouse_name'] != null) {
        state.conditionList.add({
          'key': 'warehouse_name',
          'value': state.searchInfo['warehouse_name']
        });
      }
      if (state.searchInfo['kbn'] != '' && state.searchInfo['kbn'] != null) {
        state.conditionList
            .add({'key': 'kbn', 'value': state.searchInfo['kbn']});
      }
      if (state.searchInfo['data2'] != '' &&
          state.searchInfo['data2'] != null) {
        state.conditionList
            .add({'key': 'data2', 'value': state.searchInfo['data2']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletLocationEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除检索条件值事件
    on<DeleteSearchValueEvent>((event, emit) {
      //判断删除检索条件
      dynamic deleteColumn = state.conditionList[event.index];

      if (deleteColumn['key'] == null || deleteColumn['value'] == null) {
        return;
      }
      //清空检索条件
      if ('data1' == deleteColumn['key']) {
        state.searchInfo['data1'] = '';
      } else if ('warehouse_id' == deleteColumn['key']) {
        state.searchInfo['warehouse_id'] = '';
      } else if ('warehouse_name' == deleteColumn['key']) {
        state.searchInfo['warehouse_name'] = '';
      } else if ('kbn' == deleteColumn['key']) {
        state.searchInfo['kbn'] = '';
      } else if ('data2' == deleteColumn['key']) {
        state.searchInfo['data2'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 查询分页数据事件
    on<PageQueryEvent>(
      (event, emit) async {
        // 判断加载标记
        if (state.loadingFlag) {
          // 打开加载状态
          BotToast.showLoading();
        } else {
          // 页数
          state.pageNum = 0;
          // 加载标记
          state.loadingFlag = true;
        }
        List<dynamic> data = [];
        print(state.searchInfo.toString());
        if (state.roleId != 1) {
          data = await SupabaseUtils.getClient()
              .rpc('func_query_table_dtb_location', params: {
                'del_kbn': Config.DELETE_NO,
                'company_id': state.companyId,
                'loc_cd': state.searchInfo['data1'] == null ||
                        state.searchInfo['data1'].toString() == ''
                    ? null
                    : state.searchInfo['data1'].toString(),
                'warehouse_id': state.searchInfo['warehouse_id'] == null ||
                        state.searchInfo['warehouse_id'].toString() == ''
                    ? null
                    : state.searchInfo['warehouse_id'].toString(),
                'kbn': state.searchInfo['kbn'] == null ||
                        state.searchInfo['kbn'].toString() == ''
                    ? null
                    : state.searchInfo['kbn'].toString(),
                'zone_cd': state.searchInfo['data2'] == null ||
                        state.searchInfo['data2'].toString() == ''
                    ? null
                    : state.searchInfo['data2'].toString(),
              })
              .select('*')
              .order(state.sortCol, ascending: state.ascendingFlg)
              .range(state.pageNum * state.pageSize,
                  (state.pageNum + 1) * state.pageSize - 1);
        } else {
          data = await SupabaseUtils.getClient()
              .rpc('func_query_table_dtb_location', params: {
                'del_kbn': Config.DELETE_NO,
                'company_id': null,
                'loc_cd': state.searchInfo['data1'] == null ||
                        state.searchInfo['data1'].toString() == ''
                    ? null
                    : state.searchInfo['data1'].toString(),
                'warehouse_id': state.searchInfo['warehouse_id'] == null ||
                        state.searchInfo['warehouse_id'].toString() == ''
                    ? null
                    : state.searchInfo['warehouse_id'].toString(),
                'kbn': state.searchInfo['kbn'] == null ||
                        state.searchInfo['kbn'].toString() == ''
                    ? null
                    : state.searchInfo['kbn'].toString(),
                'zone_cd': state.searchInfo['data2'] == null ||
                        state.searchInfo['data2'].toString() == ''
                    ? null
                    : state.searchInfo['data2'].toString(),
              })
              .select('*')
              .order(state.sortCol, ascending: state.ascendingFlg)
              .range(state.pageNum * state.pageSize,
                  (state.pageNum + 1) * state.pageSize - 1);
        }
        // 列表数据清空
        state.records.clear();
        // 循环出荷指示数据
        for (int i = 0; i < data.length; i++) {
          // 列表数据增加
          state.records.add(WmsRecordModel(i, data[i]));
        }
        //一览总个数
        List<dynamic> locationCount = [];
        if (state.roleId != 1) {
          locationCount = await SupabaseUtils.getClient()
              .rpc('func_query_table_dtb_location_count', params: {
            'del_kbn': Config.DELETE_NO,
            'company_id': state.companyId,
            'loc_cd': state.searchInfo['data1'] == null ||
                    state.searchInfo['data1'].toString() == ''
                ? null
                : state.searchInfo['data1'].toString(),
            'warehouse_id': state.searchInfo['warehouse_id'] == null ||
                    state.searchInfo['warehouse_id'].toString() == ''
                ? null
                : state.searchInfo['warehouse_id'].toString(),
            'kbn': state.searchInfo['kbn'] == null ||
                    state.searchInfo['kbn'].toString() == ''
                ? null
                : state.searchInfo['kbn'].toString(),
            'zone_cd': state.searchInfo['data2'] == null ||
                    state.searchInfo['data2'].toString() == ''
                ? null
                : state.searchInfo['data2'].toString(),
          });
        } else {
          locationCount = await SupabaseUtils.getClient()
              .rpc('func_query_table_dtb_location_count', params: {
            'del_kbn': Config.DELETE_NO,
            'company_id': null,
            'loc_cd': state.searchInfo['data1'] == null ||
                    state.searchInfo['data1'].toString() == ''
                ? null
                : state.searchInfo['data1'].toString(),
            'warehouse_id': state.searchInfo['warehouse_id'] == null ||
                    state.searchInfo['warehouse_id'].toString() == ''
                ? null
                : state.searchInfo['warehouse_id'].toString(),
            'kbn': state.searchInfo['kbn'] == null ||
                    state.searchInfo['kbn'].toString() == ''
                ? null
                : state.searchInfo['kbn'].toString(),
            'zone_cd': state.searchInfo['data2'] == null ||
                    state.searchInfo['data2'].toString() == ''
                ? null
                : state.searchInfo['data2'].toString(),
          });
        }
        //总个数
        state.total = locationCount[0]['total'];
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );

    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(InitEvent());
  }

  //初期化表单
  void initForm(LocationMasterModel state) {
    //会社情报初期化
    state.detailsMap = {
      'id': '',
      'warehouse_id': '',
      'warehouse_name': '',
      'warehouse_name_short': '',
      'loc_cd': '',
      'kbn': '',
      'floor_cd': '',
      'room_cd': '',
      'zone_cd': '',
      'row_cd': '',
      'shelve_cd': '',
      'step_cd': '',
      'range_cd': '',
      'keeping_volume': '',
      'area': '',
      'note1': '',
      'note2': ''
    };
    //状态初期化
    state.formFlag = '2';
  }

  //判断code是否重复
  Future<bool> checkLocCode(String locCode, int? id) async {
    //code值检索
    List<dynamic> data = await SupabaseUtils.getClient()
        .from('mtb_location')
        .select('*')
        .eq('company_id', state.companyId)
        .eq("del_kbn", "2")
        .eq("loc_cd", locCode);
    if (id == -1) {
      //登录的场合
      if (data.length == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      //更新的场合
      if (data.length == 0) {
        return true;
      } else if (data.length == 1) {
        if (id == data[0]['id']) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  //检索前check处理
  bool selectLocationEventBeforeCheck(
      BuildContext context, LocationMasterModel state) {
    //检索条件check
    if (state.searchInfo['data2'] != '' &&
        state.searchInfo['data2'] != null &&
        CheckUtils.check_Half_Alphanumeric(state.searchInfo['data2'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.start_inventory_location_zone +
              WMSLocalizations.i18n(context)!.input_letter_and_number_check);
      return false;
    }
    add(SeletLocationEvent(context));
    return true;
  }

  //初期化检索条件
  void initSearch(LocationMasterModel state) {
    state.searchInfo = {
      'data1': '',
      'warehouse_id': '',
      'warehouse_name': '',
      'kbn': '',
      'data2': ''
    };
    state.conditionList = [];
  }
}
