import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/utils/supabase_untils.dart';

import '../../../../../model/ship.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'pick_list_model.dart';

/**
 * 内容：ピッキングリスト(シングル)-BLOC
 * 作者：王光顺
 * 时间：2023/09/07
 */
// 事件
abstract class PickListEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends PickListEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始

class updateShipFormEvent extends PickListEvent {
  List<int> data = [];
  // 保存出荷指示表单事件
  updateShipFormEvent(this.data);
}

// 检索事件

// 检索事件
class PickListQueryEvent extends PickListEvent {
  //检索日期
  String date;
  // 数组属性
  List<dynamic> list;
  // 查询出荷指示明细事件
  PickListQueryEvent(this.date, this.list);
}

// 明细事件
class QueryShipEvent extends PickListEvent {
  // 出荷指示明细ID
  int shipDetailId;
  // 查询出荷指示明细事件
  QueryShipEvent(this.shipDetailId);
}

// 设置sort字段
class SetSortEvent extends PickListEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class PickListBloc extends WmsTableBloc<PickListModel> {
  // 刷新补丁
  @override
  PickListModel clone(PickListModel src) {
    return PickListModel.clone(src);
  }

  String date = '';
  List<dynamic> list = [];
  PickListBloc(PickListModel state) : super(state) {
    //印刷操作批量修改状态
    on<updateShipFormEvent>((event, emit) async {
      for (int i = 0; i < event.data.length; i++) {
        await SupabaseUtils.getClient()
            .from('dtb_ship')
            .update({'pick_list_kbn': '1'}).eq('id', event.data[i]);
      }
      // 刷新补丁
      emit(clone(state));
      // 加载标记
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 查询分页数据事件
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

      state.time = date;
      // 查询出荷指示明细
      List<dynamic> shipDetailData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .lte('rcv_sch_date', date)
          .in_('pick_list_kbn', list)
          // 赵士淞 - 测试修复 2023/11/16 - 始
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO)
          // 赵士淞 - 测试修复 2023/11/16 - 终
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1)
          .order(state.sortCol, ascending: state.ascendingFlg);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < shipDetailData.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, shipDetailData[i]));
      }

      //统计记入页码数
      List<dynamic> count = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .lte('rcv_sch_date', date)
          // 赵士淞 - 测试修复 2023/11/16 - 始
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO)
          // 赵士淞 - 测试修复 2023/11/16 - 终
          .in_('pick_list_kbn', list);
      state.total = count.length;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询分页数据事件
    on<PickListQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      date = event.date;
      list = event.list;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 明细数据事件
    on<QueryShipEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      List<dynamic> DetailData = await SupabaseUtils.getClient()
          .rpc('func_query_table_mtb_dtb_product', params: {
        'id': event.shipDetailId,
      }).select('*');

      //查询出荷指示
      List<dynamic> data = await SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .eq('id', event.shipDetailId);

      for (int i = 0; i < data.length; i++) {
        state.shipDetailCustomize.addAll(data[i]);
      }
      //查询

      // 出荷指示
      state.ship = Ship.fromJson(data[0]);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < DetailData.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, DetailData[i]));
        state.shipDetailCustomize.addAll(DetailData[i]);
      }
      // 总页数
      state.total = DetailData.length;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 明细数据事件
    on<InitEvent>((event, emit) async {
      add(PickListQueryEvent(
          DateTime.now()
              .toIso8601String()
              .substring(0, 10)
              .replaceAll('-', '/'),
          ['2']));
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
