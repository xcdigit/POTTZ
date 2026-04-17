import 'package:bot_toast/bot_toast.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_model.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';

/**
 * content：在庫移動照会-参数
 * author：张博睿
 * date：2023/09/07
 */

abstract class InventoryTransferInquiryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InventoryTransferInquiryEvent {
  //初始化事件
  InitEvent();
}

class SetTransferInquiryEvent extends InventoryTransferInquiryEvent {
// Key
  String key;
  // flag
  String flag;
  // Value
  dynamic value;
  // 设定值事件
  SetTransferInquiryEvent(this.key, this.value, this.flag);
}

class SetLoadingFlagEvent extends InventoryTransferInquiryEvent {
  SetLoadingFlagEvent();
}

class SetProductCodeEvent extends InventoryTransferInquiryEvent {
  String value;
  //商品code赋值
  SetProductCodeEvent(this.value);
}

class SetProductNameEvent extends InventoryTransferInquiryEvent {
  String value;
  //商品名赋值
  SetProductNameEvent(this.value);
}

class SetMoveDateEvent extends InventoryTransferInquiryEvent {
  String value;
  //移动日期赋值
  SetMoveDateEvent(this.value);
}

class SetConditionListEvent extends InventoryTransferInquiryEvent {
  List<String> value;
  //移动日期赋值
  SetConditionListEvent(this.value);
}

// 设置sort字段
class SetSortEvent extends InventoryTransferInquiryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class InventoryTransferInquiryBloc
    extends WmsTableBloc<InventoryTransferInquiryModel> {
  @override
  InventoryTransferInquiryModel clone(InventoryTransferInquiryModel src) {
    return InventoryTransferInquiryModel.clone(src);
  }

  InventoryTransferInquiryBloc(InventoryTransferInquiryModel state)
      : super(state) {
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
            'from_location_id': state.locationBefore.id != null
                ? state.locationBefore.id
                : null,
            'to_location_id':
                state.locationAfter.id != null ? state.locationAfter.id : null,
            'product_adjust_date':
                state.adjustDate != '' ? state.adjustDate : null,
            'move_kbn': Config.NUMBER_ONE.toString(),
            'company_id': state.companyId,
          })
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        //移動日付时间转换
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
        'from_location_id':
            state.locationBefore.id != null ? state.locationBefore.id : null,
        'to_location_id':
            state.locationAfter.id != null ? state.locationAfter.id : null,
        'product_adjust_date': state.adjustDate != '' ? state.adjustDate : null,
        'move_kbn': Config.NUMBER_ONE.toString(),
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
      // 移動先ロケーション列表
      state.moveAfterLocationList = [];
      // 循环出荷指示数据
      for (int i = 0; i < locationData.length; i++) {
        // 列表数据增加
        state.moveBeforeLocationList.add(locationData[i]);
        state.moveAfterLocationList.add(locationData[i]);
      }
      state.productCode = '';
      state.productName = '';
      state.queryFromLocCode = '';
      state.queryToLocCode = '';
      state.adjustDate = '';
      state.conditionList = [];
      SetTransferInquiryEvent("id", '', "Before");
      SetTransferInquiryEvent("loc_cd", '', "Before");
      SetTransferInquiryEvent("id", '', "After");
      SetTransferInquiryEvent("loc_cd", '', "After");

      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 设定出荷指示值事件
    on<SetTransferInquiryEvent>((event, emit) async {
      if (event.flag == "Before") {
        // 移动前位置
        state.locationBefore = event.key == 'id'
            ? state.locationBefore.set(event.key, int.tryParse(event.value))
            : state.locationBefore.set(event.key, event.value);
        state.queryFromLocCode = event.key == 'loc_cd' ? event.value : '';
      } else {
        // 移动后位置
        state.locationAfter = event.key == 'id'
            ? state.locationAfter.set(event.key, int.tryParse(event.value))
            : state.locationAfter.set(event.key, event.value);
        state.queryToLocCode = event.key == 'loc_cd' ? event.value : '';
      }

      // 更新
      emit(clone(state));
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
