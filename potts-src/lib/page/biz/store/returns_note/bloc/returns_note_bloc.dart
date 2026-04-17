import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/returns_note/bloc/returns_note_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import 'package:intl/intl.dart';
/**
 * content：返品照会-bloc
 * author：熊草云
 * date：2023/10/10
 */

abstract class ReturnNoteEvent extends TableListEvent {}

// 查询检索条件事件
class QuerySearchEvent extends ReturnNoteEvent {
  List<String> shipList;
  // 查询事件
  QuerySearchEvent(this.shipList);
}

// 返品删除
class DeleteReturnEvent extends ReturnNoteEvent {
  Map<String, dynamic> deteleData;
  DeleteReturnEvent(this.deteleData);
}

// 更新表
class UpdateReturnEvent extends ReturnNoteEvent {
  bool flag;
  Map<String, dynamic> deteleData;
  UpdateReturnEvent(this.flag, this.deteleData);
}

// 设置sort字段
class SetSortEvent extends ReturnNoteEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class ReturnNoteBloc extends WmsTableBloc<ReturnNoteModel> {
  @override
  ReturnNoteModel clone(ReturnNoteModel src) {
    return ReturnNoteModel.clone(src);
  }

  ReturnNoteBloc(ReturnNoteModel state) : super(state) {
    on<PageQueryEvent>((event, emit) async {
      if (state.deteleFlag) {
        BotToast.showLoading();
      }
      if (!state.loadingFlag) {
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      state.deteleFlag = true;
      List<dynamic> Searchdata = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_return_returns_note_search', params: {
            'p_return_kbn': state.returnKbn,
            'p_product_code': state.productCode,
            'p_product_name': state.productName,
            'p_rev_ship_line_no': state.revShipNo,
            'p_user': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id as int
          })
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1)
          .order(state.sortCol, ascending: state.ascendingFlg);
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < Searchdata.length; i++) {
        // 列表数据增加
        if (Searchdata[i]['return_kbn'] == '1')
          Searchdata[i]['return_kbn_name'] = '売上返品';
        if (Searchdata[i]['return_kbn'] == '2')
          Searchdata[i]['return_kbn_name'] = '仕入返品';
        state.records.add(WmsRecordModel(i, Searchdata[i]));
      }
      // 总页数
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_return_returns_note_search', params: {
        'p_return_kbn': state.returnKbn,
        'p_product_code': state.productCode,
        'p_product_name': state.productName,
        'p_rev_ship_line_no': state.revShipNo,
        'p_user': StoreProvider.of<WMSState>(state.context)
            .state
            .loginUser
            ?.company_id as int
      }).select('*');
      state.total = count.length;
      emit(clone(state));
      BotToast.closeAllLoading();
    });
    // 检索条件
    on<QuerySearchEvent>((event, emit) async {
      // 暂存数据
      // 返品区分
      String? returnKbn;
      // 商品コード
      String? productCode;
      // 商品名
      String? productName;
      // 入荷予定番号/出荷指示番号
      String? revShipNo;
      for (int i = 0; i < event.shipList.length; i++) {
        List<String> parts = event.shipList[i].split("：");
        String key = parts[0];
        String value = parts[1];
        if (key == WMSLocalizations.i18n(state.context)!.returns_note_1) {
          if (value == '売上返品')
            returnKbn = '1';
          else if (value == '仕入返品')
            returnKbn = '2';
          else
            returnKbn = value;
        } else if (key == WMSLocalizations.i18n(state.context)!.pink_list_49) {
          productCode = value;
        } else if (key ==
            WMSLocalizations.i18n(state.context)!.outbound_adjust_query_name) {
          productName = value;
        } else {
          revShipNo = value;
        }
      }
      // 设定检索条件
      state.returnKbn = returnKbn;
      state.productCode = productCode;
      state.productName = productName;
      state.revShipNo = revShipNo;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });
    // 返品删除
    on<DeleteReturnEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 更新表dtb_return(返品) 字段【削除区分】=【1:削除済み】 条件【id】=选中数据的id
      await SupabaseUtils.getClient()
          .from('dtb_return')
          .update({'del_kbn': '1'}).eq('id', event.deteleData['id']);
      // 【売上返品】的场合
      if (event.deteleData['return_kbn'] == '1') {
        add(UpdateReturnEvent(true, event.deteleData));
      } else if (event.deteleData['return_kbn'] == '2') {
        add(UpdateReturnEvent(false, event.deteleData));
      }
      state.deteleFlag = false;
      emit(clone(state));
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.context)!.returns_note_id +
              ':' +
              event.deteleData['id'].toString() +
              WMSLocalizations.i18n(state.context)!.delete_success);
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 更新表
    on<UpdateReturnEvent>((event, emit) async {
      // 更新表dtb_store(在庫)
      List<dynamic> storeData = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select()
          .eq('product_id', event.deteleData['product_id'])
          .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int);
      if (storeData[0]['return_stock'] == null) {
        storeData[0]['return_stock'] = 0;
      }
      if (storeData[0]['return_stock'] == null) {
        storeData[0]['stock'] = 0;
      }
      await SupabaseUtils.getClient()
          .from('dtb_store')
          .update({
            'stock': event.flag
                ? storeData[0]['stock'] - event.deteleData['return_num']
                : storeData[0]['stock'] + event.deteleData['return_num'],
            'return_stock':
                storeData[0]['return_stock'] - event.deteleData['return_num']
          })
          .eq('product_id', event.deteleData['product_id'])
          .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int);

      // 更新表dtb_product_location(商品在庫位置)
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .select()
          .eq('product_id', event.deteleData['product_id'])
          .eq('location_id', event.deteleData['location_id']);
      await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .update({
            'stock': event.flag
                ? locationData[0]['stock'] - event.deteleData['return_num']
                : locationData[0]['stock'] + event.deteleData['return_num']
          })
          .eq('product_id', event.deteleData['product_id'])
          .eq('location_id', event.deteleData['location_id']);
      // 更新表dtb_store_history(受払明細)  插入数据
      Map<String, dynamic> newData = {
        "stock_id": storeData[0]['id'],
        "year_month": DateFormat('yyyyMM').format(DateTime.now()),
        "rev_ship_line_no": event.deteleData['rev_ship_line_no'],
        "rev_ship_kbn": event.flag ? '2' : '1',
        "product_id": event.deteleData['product_id'],
        "num": event.deteleData['return_num'],
        'store_kbn': event.flag ? '2' : '1',
        "location_id": event.deteleData['location_id'],
        "action_id": 10,
        "company_id": StoreProvider.of<WMSState>(state.context)
            .state
            .loginUser
            ?.company_id as int,
      };
      // 执行插入操作
      // dtb_rev_ship_location(商品入出荷位置)
      await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([newData]);
    });

    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(PageQueryEvent());
  }
}
