import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'shipment_confirmation_export_model.dart';
import 'package:intl/intl.dart';
/**
 * 内容：出荷確定データ出力-BLOC
 * 作者：熊草云
 * 时间：2023/09/20
 */
// 事件

abstract class ShipmentConfirmationExportEvent extends TableListEvent {}

class SetShipPrintingEvent extends ShipmentConfirmationExportEvent {
  // 设定值事件
  SetShipPrintingEvent();
}

// 初始化检索条件
class InitEvent extends ShipmentConfirmationExportEvent {
  // 初始化事件
  InitEvent();
}

class SetSearchEvent extends ShipmentConfirmationExportEvent {
  // 出荷確定データ出力
  String searchDate;

  // 查询出荷確定事件
  SetSearchEvent(this.searchDate);
// 初始化事件
}

class OutputCSVFileEvent extends ShipmentConfirmationExportEvent {
  BuildContext context;
  OutputCSVFileEvent(this.context);
}

// 设置sort字段
class SetSortEvent extends ShipmentConfirmationExportEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class ShipmentConfirmationExportBloc
    extends WmsTableBloc<ShipmentConfirmationExportModel> {
  // 刷新补丁
  @override
  ShipmentConfirmationExportModel clone(ShipmentConfirmationExportModel src) {
    return ShipmentConfirmationExportModel.clone(src);
  }

  ShipmentConfirmationExportBloc(ShipmentConfirmationExportModel state)
      : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      // String date = DateTime.now().toString();
      BotToast.showLoading();
      if (!state.loadingFlag) {
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      List<dynamic> data;
      // ignore: unnecessary_null_comparison
      if (state.searchDate == '' || state.searchDate == null) {
        data = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('ship_kbn', '7')
            .eq('del_kbn', '2')
            .eq('csv_kbn', '2')
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id as int)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
      } else {
        data = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('rcv_real_date', state.searchDate)
            .eq('ship_kbn', '7')
            .eq('del_kbn', '2')
            .eq('csv_kbn', '2')
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id as int)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
      }
      //列表清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 查询出荷总数
      List<dynamic> count;
      // ignore: unnecessary_null_comparison
      if (state.searchDate == '' || state.searchDate == null) {
        count = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('ship_kbn', '7')
            .eq('del_kbn', '2')
            .eq('csv_kbn', '2')
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id as int);
      } else {
        count = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('rcv_real_date', state.searchDate)
            .eq('ship_kbn', '7')
            .eq('del_kbn', '2')
            .eq('csv_kbn', '2')
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id as int);
      }
      // 总页数
      state.total = count.length;
      emit(clone(state));
      BotToast.closeAllLoading();
    });

    // 查询出荷确定检索数据
    on<SetSearchEvent>((event, emit) async {
      state.searchDate = event.searchDate;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 导出csv
    on<OutputCSVFileEvent>((event, emit) async {
      List<String> shipNoList = [];
      state.checkedRecords().forEach((record) {
        String shipNo = record.data['id'].toString();
        shipNoList.add(shipNo);
      });
      List<Map<String, dynamic>> data = [];
      state.checkedRecords().forEach((record) {
        Map<String, dynamic> recordData = record.data;
        data.add(recordData);
      });
      if (data.length == 0) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.Inventory_Confirmed_tip_1);
        return;
      }
      // 将数据导出CSV文件
      WMSCommonFile().exportCSVFile([
        'id',
        'ship_no',
        'rcv_sch_date',
        'rcv_real_date',
        'cus_rev_date',
        'customer_name',
        'name'
      ], data, '出荷確定データ出力');
      // 更新表：dtb_ship(出荷指示) 字段：【連携済】为1:ON
      for (int i = 0; i < shipNoList.length; i++) {
        await SupabaseUtils.getClient().from('dtb_ship').update({
          'csv_kbn': Config.CSV_KBN_1,
        }).eq('id', shipNoList[i]);
      }
      //插入操作履历 sys_log表
      CommonUtils().createLogInfo(
          '出荷確定データCSV' +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT10 +
              Config.OPERATION_TEXT2,
          "OutputCSVFileEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);

      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    on<InitEvent>((event, emit) async {
      DateTime now = DateTime.now();
      state.searchDate = DateFormat('yyyy/MM/dd').format(now);
      add(PageQueryEvent());
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
}
