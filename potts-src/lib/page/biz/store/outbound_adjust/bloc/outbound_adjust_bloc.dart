import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/store_history.dart';
import 'package:wms/model/store_move.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_model.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

/**
 * content：在庫調整入力-逻辑
 * author：张博睿
 * date：2023/09/25
 */

abstract class OutboundAdjustEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends OutboundAdjustEvent {
  //初始化事件
  InitEvent();
}

class SetAdjustInquiryEvent extends OutboundAdjustEvent {
// Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetAdjustInquiryEvent(this.key, this.value);
}

class SetLoadingFlagEvent extends OutboundAdjustEvent {
  SetLoadingFlagEvent();
}

class SetDataToDialogEvent extends OutboundAdjustEvent {
  BuildContext context;
  dynamic value;
  SetDataToDialogEvent(this.value, this.context);
}

class SetProductCodeEvent extends OutboundAdjustEvent {
  String value;
  //商品code赋值
  SetProductCodeEvent(this.value);
}

class SetProductNameEvent extends OutboundAdjustEvent {
  String value;
  //商品名赋值
  SetProductNameEvent(this.value);
}

class InsertStoreMoveData extends OutboundAdjustEvent {
  InsertStoreMoveData();
}

class UpdateDtbStoreDataEvent extends OutboundAdjustEvent {
  UpdateDtbStoreDataEvent();
}

class UpdateDtbProductLocationDataEvent extends OutboundAdjustEvent {
  UpdateDtbProductLocationDataEvent();
}

class InsertDtbStoreHistoryDataEvent extends OutboundAdjustEvent {
  InsertDtbStoreHistoryDataEvent();
}

class SetAfterAdjustNumberEvent extends OutboundAdjustEvent {
  String value;
  BuildContext context;
  SetAfterAdjustNumberEvent(this.value, this.context);
}

class SetAfterReasonEvent extends OutboundAdjustEvent {
  String value;
  SetAfterReasonEvent(this.value);
}

class SetMessageEvent extends OutboundAdjustEvent {
  SetMessageEvent();
}

// 设置sort字段
class SetSortEvent extends OutboundAdjustEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class OutboundAdjustBloc extends WmsTableBloc<OutboundAdjustModel> {
  @override
  OutboundAdjustModel clone(OutboundAdjustModel src) {
    return OutboundAdjustModel.clone(src);
  }

  // table表dtb_store_move追加数据
  Future<bool> InsertStoreMoveData() async {
    // 打开加载状态
    BotToast.showLoading();
    StoreMove storeMove = StoreMove.empty();
    // 赋值-调整：2
    storeMove.move_kbn = Config.NUMBER_TWO.toString();
    // 赋值-ロケーションid
    storeMove.to_location_id = state.locationId;
    // 赋值-商品Id
    storeMove.product_id = state.productId;
    // 赋值-在库数
    storeMove.before_ad_num = state.stock;
    // 赋值-调整后数量
    storeMove.after_ad_num = int.parse(state.afterAdjustNumber);
    storeMove.move_num = state.stock - int.parse(state.afterAdjustNumber);
    // 赋值-移動調整日付
    storeMove.adjust_date = DateTime.now().toString();
    // 赋值-移動調整理由
    storeMove.adjust_reason = state.afterReason;
    // 赋值-会社ID
    storeMove.company_id = state.companyId;
    // 赋值-创建者ID
    storeMove.create_id = state.userId;
    // 赋值-创建时间
    storeMove.create_time = DateTime.now().toString();
    // 赋值-更新者ID
    storeMove.update_id = state.userId;
    // 赋值-更新时间
    storeMove.update_time = DateTime.now().toString();

    // 新增在库调整数据
    List<dynamic> data = await SupabaseUtils.getClient()
        .from('dtb_store_move')
        .insert([storeMove.toJson()]).select('*');
    if (data.length > 0) {
      return UpdateDtbStoreDataEvent();
    } else {
      // 关闭加载
      BotToast.closeAllLoading();
      return false;
    }
  }

  // 更新table表dtb_store数据
  Future<bool> UpdateDtbStoreDataEvent() async {
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month < 10
        ? DateTime.now().month.toString().padLeft(2, '0')
        : DateTime.now().month.toString();
    // 变更table表dtb_store的在库数减少
    List<dynamic> data = await SupabaseUtils.getClient()
        .from('dtb_store')
        .update({
          'stock': state.stockStore +
              (int.parse(state.afterAdjustNumber) - state.stock),
          'adjust_stock': state.adjustStock +
              (int.parse(state.afterAdjustNumber) - state.stock).abs(),
        })
        .eq('product_id', state.productId)
        .eq('year_month', year + month)
        .select('*');
    if (data.length > 0) {
      return UpdateDtbProductLocationDataEvent();
    } else {
      // 关闭加载
      BotToast.closeAllLoading();
      return false;
    }
  }

  // 更新table表dtb_product_location数据
  Future<bool> UpdateDtbProductLocationDataEvent() async {
    // 变更table表dtb_product_location的移動元ロケーション在库数减少
    List<dynamic> data = await SupabaseUtils.getClient()
        .from('dtb_product_location')
        .update({
          'stock':
              state.stock + (int.parse(state.afterAdjustNumber) - state.stock),
        })
        .eq('product_id', state.productId)
        .eq('location_id', state.locationId)
        .select('*');
    if (data.length > 0) {
      return InsertDtbStoreHistoryDataEvent();
    } else {
      // 关闭加载
      BotToast.closeAllLoading();
      return false;
    }
  }

  // table表dtb_store_history追加数据
  Future<bool> InsertDtbStoreHistoryDataEvent() async {
    StoreHistory storeHistory = StoreHistory.empty();
    // 赋值-入/出库数；
    // eg：【入/出庫数】=（【調整後数量】-【調整前数量】）的绝对值
    storeHistory.num = (int.parse(state.afterAdjustNumber) - state.stock).abs();
    // 赋值-入出庫区分；
    // eg：【調整後数量】-【調整前数量】>0；【入出庫区分】=【1:入庫】
    // eg：【調整後数量】-【調整前数量】<0；【入出庫区分】=【2:出庫】
    storeHistory.store_kbn =
        (int.parse(state.afterAdjustNumber) - state.stock) > 0
            ? Config.NUMBER_ONE.toString()
            : Config.NUMBER_TWO.toString();
    // 赋值-アクション区分；
    // eg：在庫調整编号：12
    storeHistory.action_id = 12;
    // 赋值-会社ID
    storeHistory.company_id = state.companyId;
    // 赋值-登録日時
    storeHistory.create_time = DateTime.now().toString();
    // 赋值-登録者
    storeHistory.create_id = state.userId;
    // 新增在库调整数据
    List<dynamic> data = await SupabaseUtils.getClient()
        .from('dtb_store_history')
        .insert([storeHistory.toJson()]).select('*');
    if (data.length > 0) {
      return true;
    } else {
      // 关闭加载
      BotToast.closeAllLoading();
      return false;
    }
  }

  OutboundAdjustBloc(OutboundAdjustModel state) : super(state) {
    // 设定检索下拉框值事件
    on<SetAdjustInquiryEvent>((event, emit) async {
      // 移动前位置
      state.location = event.key == 'id'
          ? state.location.set(event.key, int.tryParse(event.value))
          : state.location.set(event.key, event.value);

      // 更新
      emit(clone(state));
    });

    on<SetLoadingFlagEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      state.loadingFlag = false;
      emit(state);
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
      // 当前日期时间
      DateTime now = DateTime.now();
      // 当前年月
      String yearMonth = now.year.toString() +
          (now.month < 10 ? '0' + now.month.toString() : now.month.toString());
      // 查询出荷总数
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_dtb_store_table', params: {
            'p_product_code': state.data1 != '' ? state.data1 : null,
            'p_product_name': state.data2 != '' ? state.data2 : null,
            'p_location_id':
                state.location.id != null ? state.location.id : null,
            'p_company_id': state.companyId,
            'p_year_month': yearMonth,
          })
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询出荷总数
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_total_dtb_store_table', params: {
        'p_product_code': state.data1 != '' ? state.data1 : null,
        'p_product_name': state.data2 != '' ? state.data2 : null,
        'p_location_id': state.location.id != null ? state.location.id : null,
        'p_company_id': state.companyId,
        'p_year_month': yearMonth,
      });
      // 总页数
      state.total = count[0]['count'];

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询位置集合
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq("company_id", state.companyId)
          .eq("del_kbn", Config.NUMBER_TWO.toString());
      // 列表数据清空
      // ロケーション列表
      state.locationList = [];
      state.locationList = locationData;
      state.loadingFlag = false;

      if (!kIsWeb) {
        if (state.pageFlag == 1) {
          // 赋值-在库数（商品在库位置表）
          state.stock = state.data['stock'] != null ? state.data['stock'] : 0;
          // 赋值-lock数（商品在库位置表）
          state.lockStock =
              state.data['lock_stock'] != null ? state.data['lock_stock'] : 0;
          // 赋值-在库数（在库表）
          state.stockStore =
              state.data['stock_store'] != null ? state.data['stock_store'] : 0;
          // 赋值-lock数（在库表）
          state.lockStockStore = state.data['lock_stock_store'] != null
              ? state.data['lock_stock_store']
              : 0;
          // 赋值-调整数（在库表）
          state.adjustStock = state.data['adjust_stock'] != null
              ? state.data['adjust_stock']
              : 0;
          // 赋值-ロケーションid
          state.locationId = state.data['location_id'];
          // 赋值-商品Id
          state.productId = state.data['product_id'];
        }
      }

      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 调整弹窗赋值
    on<SetDataToDialogEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 赋值-在库数（商品在库位置表）
      state.stock = event.value['stock'] != null ? event.value['stock'] : 0;
      // 赋值-lock数（商品在库位置表）
      state.lockStock =
          event.value['lock_stock'] != null ? event.value['lock_stock'] : 0;
      // 赋值-在库数（在库表）
      state.stockStore =
          event.value['stock_store'] != null ? event.value['stock_store'] : 0;
      // 赋值-lock数（在库表）
      state.lockStockStore = event.value['lock_stock_store'] != null
          ? event.value['lock_stock_store']
          : 0;
      // 赋值-调整数（在库表）
      state.adjustStock =
          event.value['adjust_stock'] != null ? event.value['adjust_stock'] : 0;
      // 赋值-ロケーションid
      state.locationId = event.value['location_id'];
      // 赋值-商品Id
      state.productId = event.value['product_id'];
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<SetProductCodeEvent>((event, emit) async {
      if (event.value.isNotEmpty) {
        state.data1 = event.value;
      } else {
        state.data1 = '';
      }
      // 更新
      emit(clone(state));
    });

    on<SetProductNameEvent>((event, emit) async {
      if (event.value.isNotEmpty) {
        state.data2 = event.value;
      } else {
        state.data2 = '';
      }
      // 更新
      emit(clone(state));
    });

    on<SetAfterAdjustNumberEvent>((event, emit) async {
      if (event.value != '') {
        // 验证是否全数字
        final reg = RegExp('^[0-9]*\$');
        bool res = reg.hasMatch(event.value);
        if (!res) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!
                      .outbound_adjust_table_btn_3 +
                  WMSLocalizations.i18n(event.context)!.input_int_check);
          state.afterAdjustNumber = '0';
        } else {
          state.afterAdjustNumber = event.value;
        }
      } else {
        state.afterAdjustNumber = '';
      }
      // 更新
      emit(clone(state));
    });

    on<SetAfterReasonEvent>((event, emit) async {
      state.afterReason = event.value;
      // 更新
      emit(clone(state));
    });

    on<SetMessageEvent>((event, emit) async {
      state.stock = int.parse(state.afterAdjustNumber);
      state.afterAdjustNumber = '';
      state.afterReason = '';
      emit(clone(state));
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
