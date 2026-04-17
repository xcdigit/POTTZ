import 'package:bot_toast/bot_toast.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import 'package:intl/intl.dart';

/**
 * 内容：入荷確定データ出力 -bloc
 * 作者：cuihr
 * 时间：2023/09/07
 */
// 事件
abstract class ConfirmationDataEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ConfirmationDataEvent {
  // 初始化事件
  InitEvent();
}

// 设定入荷确定值事件
class SetReceiveValueEvent extends ConfirmationDataEvent {
  // Key
  String schDate;
  // 设定值事件
  SetReceiveValueEvent(this.schDate);
}

// 查询入荷确定事件
class QueryReceiveEvent extends ConfirmationDataEvent {
  // 入荷确定ID
  int receiveId;
  // 查询入荷确定事件
  QueryReceiveEvent(this.receiveId);
}

// 变更连携标记事件
class UpdateCsvKbnEvent extends ConfirmationDataEvent {
  // 入荷ID列表
  List<int> receiveIdList;
  // 变更连携标记事件
  UpdateCsvKbnEvent(this.receiveIdList);
}

// 设置sort字段
class SetSortEvent extends ConfirmationDataEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class ConfirmationDataBloc extends WmsTableBloc<ConfirmationDataModel> {
  //刷新补丁
  @override
  ConfirmationDataModel clone(ConfirmationDataModel src) {
    return ConfirmationDataModel.clone(src);
  }

  ConfirmationDataBloc(ConfirmationDataModel state) : super(state) {
    //检索条件
    //当前时间
    String rcvSchDate = DateFormat('yyyy-MM-dd').format(state.rcvSchDate);
    // 入荷状态：入荷済み 5
    String receiveKbn = Config.RECEIVE_KBN_RECEIVED;
    //消除区分：未消除  2
    String delKbn = Config.DELETE_NO;
    //連携済 为2:OFF(default)
    String csvKbn = Config.CSV_KBN_2;

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
      // 查询出荷指示
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_receive', params: {
            'rcv_sch_date': rcvSchDate != '' ? rcvSchDate : null,
            'receive_kbn': receiveKbn,
            'del_kbn': delKbn,
            'csv_kbn': csvKbn
          })
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        if (data[i]['rcv_sch_date'] != null && data[i]['rcv_sch_date'] != '') {
          data[i]['rcv_sch_date'] = data[i]['rcv_sch_date'].substring(0, 10);
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 查询出荷指示
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_total_dtb_receive', params: {
        'rcv_sch_date': rcvSchDate != '' ? rcvSchDate : null,
        'receive_kbn': receiveKbn,
        'del_kbn': delKbn,
        'csv_kbn': csvKbn
      });
      // 总页数
      if (count.length > 0) {
        state.total = count[0]['total'];
      } else {
        state.total = 0;
      }

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    on<SetReceiveValueEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        if (event.schDate != '') {
          rcvSchDate = event.schDate.replaceAll("/", "-");
        } else {
          rcvSchDate = '';
        }
        // 加载标记
        state.loadingFlag = false;
        // 刷新补丁
        emit(clone(state));
        add(PageQueryEvent());
      },
    );

    // 变更连携标记事件
    on<UpdateCsvKbnEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 变更连携标记
      await SupabaseUtils.getClient().from('dtb_receive').update({
        'csv_kbn': 1,
      }).in_('id', event.receiveIdList);
      // 关闭加载
      BotToast.closeAllLoading();
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
