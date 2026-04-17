import 'package:bot_toast/bot_toast.dart';

import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'inventory_inquiry_dialog_model.dart';

/**
 * 内容：在庫照会弹窗-BLOC
 * 作者：赵士淞
 * 时间：2023/11/07
 */
// 事件
abstract class InventoryInquiryDialogEvent extends TableListEvent {}

// 查询商品在庫位置事件
class QueryProductLocationEvent extends InventoryInquiryDialogEvent {
  // 商品ID
  int productId;
  // 查询商品在庫位置事件
  QueryProductLocationEvent(this.productId);
}

class InventoryInquiryDialogBloc
    extends WmsTableBloc<InventoryInquiryDialogModel> {
  // 刷新补丁
  @override
  InventoryInquiryDialogModel clone(InventoryInquiryDialogModel src) {
    return InventoryInquiryDialogModel.clone(src);
  }

  InventoryInquiryDialogBloc(InventoryInquiryDialogModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 查询商品在庫位置
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_item_dtb_product_location', params: {
        'product_id': state.productId,
      }).select('*');
      // 列表数据清空
      state.records.clear();
      // 循环在庫照会数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 总页数
      state.total = data.length;

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询商品在庫位置事件
    on<QueryProductLocationEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 商品ID
      state.productId = event.productId;

      // 查询分页数据事件
      add(PageQueryEvent());
    });
  }
}
