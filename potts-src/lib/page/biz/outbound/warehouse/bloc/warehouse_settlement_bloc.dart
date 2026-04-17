import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/utils/supabase_untils.dart';
import 'warehouse_settlement_model.dart';

// 事件
abstract class WarehouseSettlementEvent {}

// 初始化事件
class InitEvent extends WarehouseSettlementEvent {
  // 初始化事件
  InitEvent();
}

class WarehouseSettlementBloc
    extends Bloc<WarehouseSettlementEvent, WarehouseSettlementModel> {
  // 刷新补丁
  WarehouseSettlementModel clone(WarehouseSettlementModel src) {
    return WarehouseSettlementModel.clone(src);
  }

  WarehouseSettlementBloc(WarehouseSettlementModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 查询会社
      List<dynamic> companyData = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('id', state.companyId);
      // 会社定制
      state.companyCustomize = companyData[0];

      // 出荷指示列表
      List<dynamic> shipList = [];
      // 出荷指示明细列表
      List<dynamic> shipDetailList = [];

      // 循环出荷指示ID列表
      for (int i = 0; i < state.shipIdList.length; i++) {
        // 查询出荷指示
        List<dynamic> shipData = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('id', state.shipIdList[i]);
        // 出荷指示列表
        shipList.add(shipData[0]);

        // 查询出荷指示明细
        List<dynamic> shipDetailData = await SupabaseUtils.getClient().rpc(
            'func_query_warehouse_dtb_ship_settlement',
            params: {'ship_id': state.shipIdList[i]}).select('*');
        // 出荷指示明细列表
        shipDetailList.add(shipDetailData);
      }

      // 出荷指示列表
      state.shipList = shipList;
      // 出荷指示明细列表
      state.shipDetailList = shipDetailList;

      // 更新
      emit(clone(state));
    });

    add(InitEvent());
  }
}
