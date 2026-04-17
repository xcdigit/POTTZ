import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';

import 'package:wms/page/biz/outbound/warehouse/bloc/warehouse_detail_model.dart';

import '../../../../../common/utils/supabase_untils.dart';

import '../../../../../file/wms_common_file.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：納品書-BLOC
 * 作者：王光顺
 * 时间：2023/09/18
 */
// 事件
abstract class WarehouseDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends WarehouseDetailEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始

// 查询出荷指示明细事件
class QueryShipDetailEvent extends WarehouseDetailEvent {
  // 出荷指示明细ID
  int shipId;
  // 查询出荷指示明细事件
  QueryShipDetailEvent(this.shipId);
}

// 保存出荷指示明细表单事件
class SaveShipDetailFormEvent extends WarehouseDetailEvent {
  // 结构树
  BuildContext context;
  // 保存出荷指示明细表单事件
  SaveShipDetailFormEvent(this.context);
}

// 删除出荷指示明细事件
class DeleteShipDetailEvent extends WarehouseDetailEvent {
  // 结构树
  BuildContext context;
  // 出荷指示明细ID
  int shipDetailId;
  // 删除出荷指示明细事件
  DeleteShipDetailEvent(this.context, this.shipDetailId);
}

// 设置检索条件
class SetSearchEvent extends WarehouseDetailEvent {
  // 初始化事件
  Map<String, dynamic> list;
  SetSearchEvent(this.list);
}

// 保存出荷指示表单事件
class ShipDetailDateEvent extends WarehouseDetailEvent {
  // 保存出荷指示明细表单事件
  Map<String, dynamic> currentParam;
  ShipDetailDateEvent(this.currentParam);
}
// 自定义事件 - 终

class WarehouseDetailBloc extends WmsTableBloc<WarehouseDetailModel> {
  // 刷新补丁
  @override
  WarehouseDetailModel clone(WarehouseDetailModel src) {
    return WarehouseDetailModel.clone(src);
  }

  int shipId = 0;

  WarehouseDetailBloc(WarehouseDetailModel state) : super(state) {
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 查询出荷指示
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_warehouse_dtb_ship_detail',
              params: {'ship_id': shipId})
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        data[i]['subtotal'] =
            double.parse(data[i]['product_price'].toString()) *
                double.parse(data[i]['ship_num'].toString());

        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      List<dynamic> count = await SupabaseUtils.getClient().rpc(
          'func_query_warehouse_dtb_ship_detail',
          params: {'ship_id': shipId}).select('*');
      // 总页数
      state.total = count.length;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 检索查询明细分页数据事件
    on<QueryShipDetailEvent>((event, emit) async {
      shipId = event.shipId;
      // 刷新补丁
      add(PageQueryEvent());
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 查询出荷指示，明细一览上方数据
      List<dynamic> data = await SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .eq('id', state.shipId)
          .eq('del_kbn', '2')
          .in_('ship_kbn', ['4', '5', '6', '7']).range(
              state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.shipDetailCustomize.addAll(data[i]);
      }
      // 检索查询明细分页数据事件
      add(QueryShipDetailEvent(state.shipId));
    });

    add(InitEvent());
  }

  // 设置纳品行明细数据
  Future<Map<String, dynamic>> SetDetailDataEvent(
      Map<String, dynamic> detailData) async {
    // 打开加载状态
    BotToast.showLoading();
    // 判断商品写真1
    if (detailData['image1'] != null && detailData['image1'] != '') {
      // 出荷指示明细-定制
      try {
        detailData['image1_effective'] =
            await WMSCommonFile().previewImageFile(detailData['image1']);
      } catch (e) {
        // 在这里处理异常
        detailData['image1_effective'] = '';
      }
    }
    // 判断商品写真2
    if (detailData['image2'] != null && detailData['image2'] != '') {
      // 出荷指示明细-定制
      try {
        detailData['image2_effective'] =
            await WMSCommonFile().previewImageFile(detailData['image2']);
      } catch (e) {
        // 在这里处理异常
        detailData['image2_effective'] = '';
      }
    }
    // 关闭加载
    BotToast.closeAllLoading();

    return detailData;
  }
}
