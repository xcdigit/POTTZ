import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import '../../../../../common/utils/supabase_untils.dart';

import '../../../../../file/wms_common_file.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'pick_list_detail_model.dart';

/**
 * 内容：ピッキングリスト(シングル)-BLOC
 * 作者：王光顺
 * 时间：2023/09/07
 */
// 事件
abstract class PickListDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends PickListDetailEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定出荷指示值事件
class SetShipValueEvent extends PickListDetailEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipValueEvent(this.key, this.value);
}

// 保存出荷指示表单事件
class SaveShipFormEvent extends PickListDetailEvent {
  // 结构树
  BuildContext context;
  // 保存出荷指示表单事件
  SaveShipFormEvent(this.context);
}

// 检索事件
class QueryShipDetailEvent extends PickListDetailEvent {
  //检索日期
  DateTime date;
  // 数组属性
  List<dynamic> list;
  // 查询出荷指示明细事件
  QueryShipDetailEvent(this.date, this.list);
}

// 明细事件
class QueryShipEvent extends PickListDetailEvent {
  // 出荷指示明细ID
  int shipDetailId;
  // 查询出荷指示明细事件
  QueryShipEvent(this.shipDetailId);
}

// 单条明细事件
class OneQueryShipEvent extends PickListDetailEvent {
  // 出荷指示明细ID
  String pickLineNo;
  // 查询出荷指示明细事件
  OneQueryShipEvent(this.pickLineNo);
}

// 弹窗明细事件
class QueryShipEvent2 extends PickListDetailEvent {
  // 出荷指示明细ID
  int shipLineNo;
  // 查询出荷指示明细事件
  QueryShipEvent2(this.shipLineNo);
}

// 设定出荷指示明细值事件
class SetShipDetailValueEvent extends PickListDetailEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipDetailValueEvent(this.key, this.value);
}

// 保存出荷指示明细表单事件
class SaveShipDetailFormEvent extends PickListDetailEvent {
  // 保存出荷指示明细表单事件
  SaveShipDetailFormEvent();
}
// 自定义事件 - 终

class PickListDetailBloc extends WmsTableBloc<PickListDetailModel> {
  // 刷新补丁
  @override
  PickListDetailModel clone(PickListDetailModel src) {
    return PickListDetailModel.clone(src);
  }

  PickListDetailBloc(PickListDetailModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      List<dynamic> DetailData = await SupabaseUtils.getClient()
          .rpc('func_query_table_mtb_dtb_product', params: {
        'id': state.shipId,
      }).select('*');
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < DetailData.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, DetailData[i]));

        state.shipDetailCustomize.addAll(DetailData[i]);
      }
      // 总页数
      state.total = DetailData.length;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询分页数据事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //查询出荷指示
      List<dynamic> data = await SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .eq('id', state.shipId);

      for (int i = 0; i < data.length; i++) {
        state.shipCustomize.addAll(data[i]);
      }
      add(PageQueryEvent());
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
