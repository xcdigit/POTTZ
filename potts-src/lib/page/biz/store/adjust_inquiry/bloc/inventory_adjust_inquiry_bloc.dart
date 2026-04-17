import 'package:bot_toast/bot_toast.dart';
import 'package:wms/common/config/config.dart';

import 'package:wms/common/utils/supabase_untils.dart';

import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_model.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';

/**
 * content：在庫调整照会-参数
 * author：张博睿
 * date：2023/09/07
 */

abstract class InventoryAdjustInquiryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InventoryAdjustInquiryEvent {
  // 初始化事件
  InitEvent();
}

class SetAdjustInquiryEvent extends InventoryAdjustInquiryEvent {
// Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetAdjustInquiryEvent(this.key, this.value);
}

class AAAAEvent extends InventoryAdjustInquiryEvent {
  Map<String, dynamic> searchValueMap;
  AAAAEvent(this.searchValueMap);
}

class SetLoadingFlagEvent extends InventoryAdjustInquiryEvent {
  SetLoadingFlagEvent();
}

class SetProductCodeEvent extends InventoryAdjustInquiryEvent {
  String value;
  //商品code赋值
  SetProductCodeEvent(this.value);
}

class SetProductNameEvent extends InventoryAdjustInquiryEvent {
  String value;
  //商品名赋值
  SetProductNameEvent(this.value);
}

class SetMoveDateEvent extends InventoryAdjustInquiryEvent {
  String value;
  //移动日期赋值
  SetMoveDateEvent(this.value);
}

class SetConditionListEvent extends InventoryAdjustInquiryEvent {
  List<String> value;
  //移动日期赋值
  SetConditionListEvent(this.value);
}

// 设置sort字段
class SetSortEvent extends InventoryAdjustInquiryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class InventoryAdjustInquiryBloc
    extends WmsTableBloc<InventoryAdjustInquiryModel> {
  @override
  InventoryAdjustInquiryModel clone(InventoryAdjustInquiryModel src) {
    return InventoryAdjustInquiryModel.clone(src);
  }

  InventoryAdjustInquiryBloc(InventoryAdjustInquiryModel state) : super(state) {
    on<AAAAEvent>((event, emit) async {
      state.searchValueMap = event.searchValueMap;
      state.loadingFlag = false;
      emit(state);
      add(PageQueryEvent());
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
      // 查询出荷总数
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_inventory_transfer_inquiry', params: {
            'product_code': state.productCode != '' ? state.productCode : null,
            'product_name': state.productName != '' ? state.productName : null,
            'from_location_id': null,
            'to_location_id': state.locationBefore.id != null
                ? state.locationBefore.id
                : null,
            'product_adjust_date':
                state.adjustDate != '' ? state.adjustDate : null,
            'move_kbn': Config.NUMBER_TWO.toString(),
            'company_id': state.companyId,
          })
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        //调整日付时间转换
        DateTime date = DateTime.parse(data[i]['adjust_date']);
        String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
        data[i]['adjust_date'] = time;
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询出荷总数
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_total_dtb_store_move', params: {
        'product_code': state.productCode != '' ? state.productCode : null,
        'product_name': state.productName != '' ? state.productName : null,
        'from_location_id': null,
        'to_location_id':
            state.locationBefore.id != null ? state.locationBefore.id : null,
        'product_adjust_date': state.adjustDate != '' ? state.adjustDate : null,
        'move_kbn': Config.NUMBER_TWO.toString(),
        'company_id': state.companyId,
      });
      // 总页数
      state.total = count[0]['total'];

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
          .eq("del_kbn", "2");
      // 列表数据清空
      // 移動元ロケーション列表
      state.moveBeforeLocationList = [];
      // 循环出荷指示数据
      for (int i = 0; i < locationData.length; i++) {
        // 列表数据增加
        state.moveBeforeLocationList.add(locationData[i]);
      }
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 设定出荷指示值事件
    on<SetAdjustInquiryEvent>((event, emit) async {
      // 移动前位置
      state.locationBefore = event.key == 'id'
          ? state.locationBefore.set(event.key, int.tryParse(event.value))
          : state.locationBefore.set(event.key, event.value);
      state.queryLocCode = event.key == 'loc_cd' ? event.value : '';
      // 更新
      emit(state);
    });

    on<SetProductCodeEvent>((event, emit) async {
      if (event.value.isNotEmpty) {
        state.productCode = event.value;
      } else {
        state.productCode = '';
      }
      // 更新
      emit(clone(state));
    });

    on<SetProductNameEvent>((event, emit) async {
      if (event.value.isNotEmpty) {
        state.productName = event.value;
      } else {
        state.productName = '';
      }
      // 更新
      emit(clone(state));
    });

    on<SetMoveDateEvent>((event, emit) async {
      if (event.value.isNotEmpty) {
        state.adjustDate = event.value;
      } else {
        state.adjustDate = '';
      }
      // 更新
      emit(clone(state));
    });

    on<SetConditionListEvent>((event, emit) async {
      if (event.value.isNotEmpty) {
        state.conditionList = event.value;
      } else {
        state.conditionList = [];
      }
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

    add(InitEvent());
  }
}
