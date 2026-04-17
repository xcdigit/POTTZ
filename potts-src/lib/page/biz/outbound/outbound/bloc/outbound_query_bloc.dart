import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';

import '../../../../../common/utils/supabase_untils.dart';

import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'outbound_query_model.dart';

/**
 * 内容：出庫照会-BLOC
 * 作者：王光顺
 * 时间：2023/09/12
 */
// 事件
abstract class OutboundQueryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends OutboundQueryEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定出荷指示值事件
class SetShipValueEvent extends OutboundQueryEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipValueEvent(this.key, this.value);
}

// 保存出荷指示表单事件
class SaveShipFormEvent extends OutboundQueryEvent {
  // 结构树
  BuildContext context;
  // 保存出荷指示表单事件
  SaveShipFormEvent(this.context);
}

//   检索事件

class OutboundPageQueryEvent extends OutboundQueryEvent {
  // 查询出荷指示明细事件
  List<dynamic> list;
  int companyId;
  OutboundPageQueryEvent(this.list, this.companyId);
}

// 明细事件
class QueryShipEvent extends OutboundQueryEvent {
  // 出荷指示明细ID
  int shipDetailId;
  // 查询出荷指示明细事件
  QueryShipEvent(this.shipDetailId);
}

// 设定出荷指示明细值事件
class SetShipDetailValueEvent extends OutboundQueryEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipDetailValueEvent(this.key, this.value);
}

// 出库入力
class ckEvent extends OutboundQueryEvent {
  // 保存出荷指示明细表单事件
  ckEvent();
}

// 保存出荷指示明细表单事件
class SaveShipDetailFormEvent extends OutboundQueryEvent {
  // 保存出荷指示明细表单事件
  SaveShipDetailFormEvent();
}

// 设置sort字段
class SetSortEvent extends OutboundQueryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}
// 自定义事件 - 终

class OutboundQueryBloc extends WmsTableBloc<OutboundQueryModel> {
  // 刷新补丁
  @override
  OutboundQueryModel clone(OutboundQueryModel src) {
    return OutboundQueryModel.clone(
      src,
    );
  }

  List<dynamic> list = [];
  int companyId = 0;

  OutboundQueryBloc(OutboundQueryModel state) : super(state) {
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
      // 查询出荷指示
      List<dynamic> data = [];

      //出荷指示日期为空 出荷指示番号为空
      if ((state.shipCustomize['rcv_sch_date'] == null ||
              state.shipCustomize['rcv_sch_date'] == '') &&
          (state.shipCustomize['ship_no'] == null ||
              state.shipCustomize['ship_no'] == '')) {
        data = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);

        List<dynamic> count = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list);
        state.count = count.length;
      }
      //出荷指示日期为空 出荷指示番号不为空
      else if ((state.shipCustomize['rcv_sch_date'] == null ||
              state.shipCustomize['rcv_sch_date'] == '') &&
          (state.shipCustomize['ship_no'] != null &&
              state.shipCustomize['ship_no'] != '')) {
        data = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('ship_no', state.shipCustomize['ship_no'])
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);

        List<dynamic> count = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('ship_no', state.shipCustomize['ship_no'])
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list);
        state.count = count.length;
      } //出荷指示日期不为空 出荷指示番号为空
      else if ((state.shipCustomize['rcv_sch_date'] != null &&
              state.shipCustomize['rcv_sch_date'] != '') &&
          (state.shipCustomize['ship_no'] == null ||
              state.shipCustomize['ship_no'] == '')) {
        data = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('rcv_sch_date', state.shipCustomize['rcv_sch_date'])
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);

        List<dynamic> count = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('rcv_sch_date', state.shipCustomize['rcv_sch_date'])
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list);
        state.count = count.length;
      } //出荷指示日期不为空 出荷指示番号不为空
      else if ((state.shipCustomize['rcv_sch_date'] != null &&
              state.shipCustomize['rcv_sch_date'] != '') &&
          (state.shipCustomize['ship_no'] != null &&
              state.shipCustomize['ship_no'] != '')) {
        state.rcvSchDate = DateTime.parse(
            state.shipCustomize['rcv_sch_date'].replaceAll('/', '-'));
        data = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('ship_no', state.shipCustomize['ship_no'])
            .eq('rcv_sch_date', state.shipCustomize['rcv_sch_date'])
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);

        List<dynamic> count = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('ship_no', state.shipCustomize['ship_no'])
            .eq('rcv_sch_date', state.shipCustomize['rcv_sch_date'])
            .eq('del_kbn', '2')
            .eq('company_id', state.companyId)
            .in_('ship_kbn', list);
        state.count = count.length;
      }

      state.shipCustomize = {'rcv_sch_date': '', 'ship_no': ''};

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
// 0:引当失敗1:引当待ち 2:出庫待ち 3:出庫中 4:検品待ち 5:梱包待ち 6:出荷確定待ち 7:出荷済み
        if (data[i]['ship_kbn'] != null && data[i]['ship_kbn'] != '') {
          if (data[i]['ship_kbn'] == '0') data[i]['ship_kbn_name'] = '引当失敗';
          if (data[i]['ship_kbn'] == '1') data[i]['ship_kbn_name'] = '引当待ち';
          if (data[i]['ship_kbn'] == '2') data[i]['ship_kbn_name'] = '出庫待ち';
          if (data[i]['ship_kbn'] == '3') data[i]['ship_kbn_name'] = '出庫中';
          if (data[i]['ship_kbn'] == '4') data[i]['ship_kbn_name'] = '検品待ち';
          if (data[i]['ship_kbn'] == '5') data[i]['ship_kbn_name'] = '梱包待ち';
          if (data[i]['ship_kbn'] == '6') data[i]['ship_kbn_name'] = '出荷確定待ち';
          if (data[i]['ship_kbn'] == '7') data[i]['ship_kbn_name'] = '出荷済み';
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 总页数
      state.total = state.count;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<OutboundPageQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      list = event.list;
      companyId = event.companyId;
      // 加载标记
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 出库入力
    on<ckEvent>((event, emit) async {
      List<int> shipNoList = [];
      state.checkedRecords().forEach((record) {
        int shipNo = record.data['id'];
        shipNoList.add(shipNo);
      });
      state.ckIdList = shipNoList;
      state.ckId = shipNoList[0];

      emit(clone(state));
    });

    // 设定出荷指示值事件
    on<SetShipValueEvent>((event, emit) async {
      // 出荷指示-临时
      Map<String, dynamic> shipTemp = Map<String, dynamic>();
      shipTemp.addAll(state.shipCustomize);

      // 判断key
      if (shipTemp[event.key] != null) {
        // 出荷指示-临时
        shipTemp[event.key] = event.value;
      } else {
        // 出荷指示-临时
        shipTemp.addAll({event.key: event.value});
      }
      // 出荷指示-定制
      state.shipCustomize = shipTemp;
      // 更新
      emit(clone(state));
    });
    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(OutboundPageQueryEvent(
        ['2', '3', '4', '5', '6', '7'], state.companyId));
  }
}
