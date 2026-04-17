import 'package:bot_toast/bot_toast.dart';
import 'package:wms/page/biz/inbound/warehouse_inspection/bloc/warehouse_inspection_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';

/**
 * 内容：入库照会-BLOC
 * 作者：cuihr
 * 时间：2023/09/25
 */
// 事件
abstract class WarehouseInspectionEvent extends TableListEvent {}

//初始化事件
class InitEvent extends WarehouseInspectionEvent {
  // 初始化事件
  InitEvent();
}

// 检索条件传值
class SetWarehouseEvent extends WarehouseInspectionEvent {
  String key;
  dynamic value;
  SetWarehouseEvent(this.key, this.value);
}

// 点击tab状态传入
class QueryReceiveEvent extends WarehouseInspectionEvent {
  String key;
  List<dynamic> list;
  QueryReceiveEvent(this.key, this.list);
}

// 设置sort字段
class SetSortEvent extends WarehouseInspectionEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class WarehouseInspectionBloc extends WmsTableBloc<WarehouseInspectionModel> {
  // 刷新补丁
  @override
  WarehouseInspectionModel clone(WarehouseInspectionModel src) {
    return WarehouseInspectionModel.clone(src);
  }

  WarehouseInspectionBloc(WarehouseInspectionModel state) : super(state) {
    // 检索条件
    //消除区分：未消除  2
    String delKbn = Config.DELETE_NO;

    List<dynamic> list = ['2', '3', '4', '5'];

    on<InitEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        // 加载标记
        state.loadingFlag = false;
        // // 查询分页数据事件
        add(PageQueryEvent());
        // 更新
        emit(clone(state));
      },
    );
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
        // 查询入库指示
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_table_dtb_receive_kbn', params: {
              'company_id': state.compareId,
              'del_kbn': delKbn,
              'rcv_sch_date':
                  state.rcv_sch_date != '' ? state.rcv_sch_date : null,
              'receive_no': state.receive_no != '' ? state.receive_no : null,
              'receive_kbn': list
            })
            .select('*')
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
        // 列表数据清空
        state.records.clear();
        // 循环出荷指示数据
        for (int i = 0; i < data.length; i++) {
          Map<String, dynamic> receive_name;
          if (data[i]['receive_kbn'] != null && data[i]['receive_kbn'] != '') {
            receive_name = data[i]['receive_kbn'] == '2'
                ? {'receive_name': '入庫待ち'}
                : data[i]['receive_kbn'] == '3'
                    ? {'receive_name': '入庫中'}
                    : data[i]['receive_kbn'] == '4'
                        ? {'receive_name': '入荷確定待ち'}
                        : {'receive_name': '入荷済み'};
            data[i].addAll(receive_name);
          }
          // 列表数据增加
          state.records.add(WmsRecordModel(i, data[i]));
        }
        state.count = data.length;
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );

    on<SetWarehouseEvent>(
      (event, emit) {
        if (event.key == 'schDate') {
          state.rcv_sch_date = event.value;
        }
        if (event.key == 'no') {
          state.receive_no = event.value;
        }
        if (event.key == 'receive_kbn_text') {
          state.receiveKbn_state = event.value;
        }
        // 更新
        emit(clone(state));
      },
    );

    on<QueryReceiveEvent>(
      (event, emit) {
        //选中检索按钮，表格tab显示在一览并加入检索条件
        if (event.key == 'list') {
          list = event.list;
          state.currentIndex = 0;
        } else {
          //tab选中
          list = event.list;
          state.currentIndex = int.tryParse(event.key)!;
        }
        // 加载标记
        state.loadingFlag = false;
        // 打开加载状态
        BotToast.showLoading();
        add(PageQueryEvent());
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
}
