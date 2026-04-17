import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/model/inventory.dart';
import 'package:wms/model/inventory_detail.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import 'start_inventory_model.dart';

/**
 * 内容：棚卸開始-BLOC
 * 作者：熊草云
 * 时间：2023/09/25
 */
// 事件
abstract class StartInventoryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends StartInventoryEvent {
  // 初始化事件
  InitEvent();
}

// 检索下拉事件
class SearchDropEvent extends StartInventoryEvent {
  String value;
  int id;
  // 检索下拉事件
  SearchDropEvent(this.value, this.id);
}

// 检索时间事件
class SearchDateEvent extends StartInventoryEvent {
  String value;
  // 检索时间事件
  SearchDateEvent(this.value);
}

// 登录事件
class RegistrationEvent extends StartInventoryEvent {
  BuildContext context;
  // 登录事件
  RegistrationEvent(this.context);
}

// 设置sort字段
class SetSortEvent extends StartInventoryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class StartInventoryBloc extends WmsTableBloc<StartInventoryModel> {
  // 刷新补丁
  @override
  StartInventoryModel clone(StartInventoryModel src) {
    return StartInventoryModel.clone(src);
  }

  StartInventoryBloc(StartInventoryModel state) : super(state) {
    // 查询分页事件
    on<PageQueryEvent>((event, emit) async {
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

      // 查询位置
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('warehouse_id', state.queryWarehouseId)
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('del_kbn', Config.DELETE_NO)
          .order(state.sortCol, ascending: state.ascendingFlg);
      // 列表数据清空
      state.records.clear();
      // 循环位置数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 总数
      state.total = data.length;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载状态
      BotToast.closeAllLoading();

      // 全选
      // add(RecordCheckAllEvent(true));
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询仓库
      List<dynamic> warehouseData = await SupabaseUtils.getClient()
          .from('mtb_warehouse')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int);
      // 仓库列表
      state.warehouseList = warehouseData;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载状态
      BotToast.closeAllLoading();
    });

    // 检索下拉事件
    on<SearchDropEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索仓库值
      state.queryWarehouseValue = event.value;
      // 检索仓库ID
      state.queryWarehouseId = event.id;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页事件
      add(PageQueryEvent());
    });

    // 检索时间事件
    on<SearchDateEvent>((event, emit) async {
      // 检索时间
      state.queryDateTime = event.value;
      // 刷新补丁
      emit(clone(state));
    });

    // 登录事件
    on<RegistrationEvent>((event, emit) async {
      // 选中数据列表
      List<Map<String, dynamic>> checkDataList = registrationPreCheck();
      // 判断选中数据列表
      if (checkDataList.length == 0) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 查询棚卸
      List<dynamic> inventoryList1 = await SupabaseUtils.getClient()
          .from('dtb_inventory')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('del_kbn', Config.DELETE_NO)
          .eq('confirm_flg', Config.CONFIRM_KBN_2)
          .eq('warehouse_id', state.queryWarehouseId)
          .neq('start_date', state.queryDateTime);
      // 判断棚卸数量
      if (inventoryList1.length != 0) {
        // 消息提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.start_inventory_text_1);
        // 关闭加载状态
        BotToast.closeAllLoading();
        return;
      }

      // 查询棚卸
      List<dynamic> inventoryList2 = await SupabaseUtils.getClient()
          .from('dtb_inventory')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('del_kbn', Config.DELETE_NO)
          .eq('warehouse_id', state.queryWarehouseId)
          .eq('start_date', state.queryDateTime);
      // 判断棚卸数量
      if (inventoryList2.length != 0) {
        // 关闭加载状态
        BotToast.closeAllLoading();
        // 判断确认状态
        if (inventoryList2[0]['confirm_flg'] == Config.CONFIRM_KBN_1) {
          // 消息提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.start_inventory_text_2);
          return;
        } else {
          // 弹窗
          showDialog(
            context: event.context,
            builder: (context) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(state.context)!.menu_content_5,
                contentText: WMSLocalizations.i18n(state.context)!
                    .start_inventory_text_3,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () async {
                  // 关闭弹窗
                  Navigator.pop(context);

                  // 打开加载状态
                  BotToast.showLoading();

                  try {
                    bool dataFlg = false;
                    // 循环选中数据列表
                    for (int i = 0; i < checkDataList.length; i++) {
                      // 查询商品位置
                      List<dynamic> productLocationList =
                          await SupabaseUtils.getClient()
                              .from('dtb_product_location')
                              .select('*')
                              .eq('location_id', checkDataList[i]['id']);
                      // 循环商品位置
                      for (int j = 0; j < productLocationList.length; j++) {
                        // 临时数据
                        Map<String, dynamic> inventoryDetailTemp = {
                          'location_id': checkDataList[i]['id'],
                          'inventory_id': inventoryList2[0]['id'],
                          'product_id': productLocationList[j]['product_id'],
                          'logic_num': productLocationList[j]['stock'] != null
                              ? productLocationList[j]['stock']
                              : 0,
                          'limit_date': productLocationList[j]['limit_date'],
                          'lot_no': productLocationList[j]['lot_no'],
                          'serial_no': productLocationList[j]['serial_no'],
                          'diff_kbn': Config.DIFF_KBN_2,
                          'end_kbn': Config.END_KBN_2,
                        };
                        // 集合处理
                        inventoryDetailTemp = mapHandle(inventoryDetailTemp);
                        // 棚卸明細实体类
                        InventoryDetail inventoryDetail =
                            InventoryDetail.fromJson(inventoryDetailTemp);
                        // 新增棚卸明細
                        await SupabaseUtils.getClient()
                            .from('dtb_inventory_detail')
                            .insert(inventoryDetail);
                        dataFlg = true;
                      }
                    }
                    if (!dataFlg) {
                      // 消息提示
                      WMSCommonBlocUtils.errorTextToast(
                          WMSLocalizations.i18n(state.context)!
                              .start_inventory_text_5);
                      // 关闭加载状态
                      BotToast.closeAllLoading();
                    } else {
                      // 更新棚卸明細
                      await SupabaseUtils.getClient()
                          .from('dtb_inventory_detail')
                          .update({'del_kbn': Config.DELETE_YES}).eq(
                              'inventory_id', inventoryList2[0]['id']);
                      // 消息提示
                      WMSCommonBlocUtils.successTextToast(
                          WMSLocalizations.i18n(state.context)!
                                  .menu_content_5_1 +
                              WMSLocalizations.i18n(state.context)!
                                  .update_success);
                      // 关闭加载状态
                      BotToast.closeAllLoading();
                    }
                  } catch (e) {
                    // 消息提示
                    WMSCommonBlocUtils.errorTextToast(
                        WMSLocalizations.i18n(state.context)!.menu_content_5_1 +
                            WMSLocalizations.i18n(state.context)!.update_error);
                    // 关闭加载状态
                    BotToast.closeAllLoading();
                    return;
                  }
                },
              );
            },
          );
        }
      } else {
        try {
          //check 选择的货架是否商品有库存
          bool dataFlg = false;
          for (int i = 0; i < checkDataList.length; i++) {
            // 查询商品位置
            List<dynamic> checkResult = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('location_id', checkDataList[i]['id']);
            if (checkResult.length > 0) {
              dataFlg = true;
            }
          }

          if (!dataFlg) {
            // 消息提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!.start_inventory_text_5);
            // 关闭加载状态
            BotToast.closeAllLoading();
            return;
          }

          // 临时数据
          Map<String, dynamic> inventoryTemp = {
            'warehouse_id': state.queryWarehouseId,
            'start_date': state.queryDateTime,
            'csv_kbn': Config.CSV_KBN_2,
            'confirm_flg': Config.CONFIRM_KBN_2,
            'company_id': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id as int,
          };
          // 集合处理
          inventoryTemp = mapHandle(inventoryTemp);
          // 棚卸实体类
          Inventory inventory = Inventory.fromJson(inventoryTemp);
          // 新增棚卸
          List<dynamic> inventoryList = await SupabaseUtils.getClient()
              .from('dtb_inventory')
              .insert(inventory)
              .select('*');

          // 循环选中数据列表
          for (int i = 0; i < checkDataList.length; i++) {
            // 查询商品位置
            List<dynamic> productLocationList = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('location_id', checkDataList[i]['id']);
            // 循环商品位置
            for (int j = 0; j < productLocationList.length; j++) {
              // 临时数据
              Map<String, dynamic> inventoryDetailTemp = {
                'inventory_id': inventoryList[0]['id'],
                'location_id': checkDataList[i]['id'],
                'product_id': productLocationList[j]['product_id'],
                'logic_num': productLocationList[j]['stock'] != null
                    ? productLocationList[j]['stock']
                    : 0,
                'limit_date': productLocationList[j]['limit_date'],
                'lot_no': productLocationList[j]['lot_no'],
                'serial_no': productLocationList[j]['serial_no'],
                'diff_kbn': Config.DIFF_KBN_2,
                'end_kbn': Config.END_KBN_2,
              };
              // 集合处理
              inventoryDetailTemp = mapHandle(inventoryDetailTemp);
              // 棚卸明細实体类
              InventoryDetail inventoryDetail =
                  InventoryDetail.fromJson(inventoryDetailTemp);
              // 新增棚卸明細
              await SupabaseUtils.getClient()
                  .from('dtb_inventory_detail')
                  .insert(inventoryDetail);
            }
          }
        } catch (e) {
          // 消息提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.menu_content_5_1 +
                  WMSLocalizations.i18n(state.context)!.create_error);
          // 关闭加载状态
          BotToast.closeAllLoading();
          return;
        }

        // 刷新补丁
        emit(clone(state));

        // 插入操作履历 sys_log表
        CommonUtils().createLogInfo(
            '棚卸開始' +
                Config.OPERATION_TEXT1 +
                Config.OPERATION_BUTTON_TEXT1 +
                Config.OPERATION_TEXT2,
            "RegistrationEvent()",
            StoreProvider.of<WMSState>(event.context)
                .state
                .loginUser!
                .company_id,
            StoreProvider.of<WMSState>(event.context).state.loginUser!.id);
        // 消息提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_5_1 +
                WMSLocalizations.i18n(state.context)!.create_success);
        // 关闭加载状态
        BotToast.closeAllLoading();
      }
    });

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

  // 登录前检查
  List<Map<String, dynamic>> registrationPreCheck() {
    // 选中数据列表
    List<Map<String, dynamic>> checkDataList = [];
    // 循环表格选中内容
    state.checkedRecords().forEach((record) {
      // 选中数据
      Map<String, dynamic> checkData = record.data;
      // 选中数据列表
      checkDataList.add(checkData);
    });

    // 判断必填项
    if (state.queryWarehouseId == '' ||
        state.queryDateTime == '' ||
        checkDataList.length == 0) {
      // 消息提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.context)!.start_inventory_text_4);
      // 返回
      return [];
    } else {
      // 返回
      return checkDataList;
    }
  }

  // 集合处理
  Map<String, dynamic> mapHandle(Map<String, dynamic> map) {
    // 集合
    map.addAll({
      'del_kbn': Config.DELETE_NO,
      'create_id':
          StoreProvider.of<WMSState>(state.context).state.loginUser?.id as int,
      'create_time': DateTime.now().toString(),
      'update_id':
          StoreProvider.of<WMSState>(state.context).state.loginUser?.id as int,
      'update_time': DateTime.now().toString(),
    });

    return map;
  }
}
