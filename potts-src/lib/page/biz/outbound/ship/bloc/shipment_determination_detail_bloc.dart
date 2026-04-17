import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_detail_model.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../model/store_history.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：出荷确定详细 -bloc
 * 作者：cuihr
 * 时间：2023/09/19
 */
// 事件
abstract class ShipmentDeterminationDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ShipmentDeterminationDetailEvent {
  // 初始化事件
  InitEvent();
}

// 表单数据
class QueryShipDetailEvent extends ShipmentDeterminationDetailEvent {
  QueryShipDetailEvent();
}

// 表格数据
class QueryShipDetailValueEvent extends ShipmentDeterminationDetailEvent {
  QueryShipDetailValueEvent();
}

//查询出荷确定详细弹窗内容
class QueryShipDetailAndProductEvent extends ShipmentDeterminationDetailEvent {
  dynamic id;
  QueryShipDetailAndProductEvent(this.id);
}

//清除出荷确定详细弹窗内容
class ClearShipDetailAndProductEvent extends ShipmentDeterminationDetailEvent {
  ClearShipDetailAndProductEvent();
}

//根据shipid查询ship表
class queryShipByShipIdEvent extends ShipmentDeterminationDetailEvent {
  dynamic ShipId;
  queryShipByShipIdEvent(this.ShipId);
}

class updateShipEvent extends ShipmentDeterminationDetailEvent {
  // 结构树
  BuildContext context;
  dynamic shipDetail;
  updateShipEvent(this.context, this.shipDetail);
}

class ShipmentDeterminationDetailBloc
    extends WmsTableBloc<ShipmentDeterminationDetailModel> {
  //刷新补丁
  @override
  ShipmentDeterminationDetailModel clone(ShipmentDeterminationDetailModel src) {
    return ShipmentDeterminationDetailModel.clone(src);
  }

  // 查询出荷指示明细事件
  bool queryShipBoolDetailEvent(BuildContext context, int id) {
    // 判断出荷指示-定制ID
    if (id == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_8 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else {
      // 查询出荷指示明细事件
      add(QueryShipDetailAndProductEvent(id));
      return true;
    }
  }

  ShipmentDeterminationDetailBloc(ShipmentDeterminationDetailModel state)
      : super(state) {
    // 检索条件
    //消除区分：未消除  2
    String delKbn = Config.DELETE_NO;

    on<InitEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        // 加载标记
        state.loadingFlag = false;
        add(QueryShipDetailEvent());
        add(PageQueryEvent());
        add(queryShipByShipIdEvent(state.shipId));
        // 刷新补丁
        emit(clone(state));
      },
    );
    //表单
    on<QueryShipDetailEvent>(
      (event, emit) async {
        List<dynamic> data = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('id', state.shipId)
            .eq('del_kbn', delKbn);
        // 列表数据增加
        state.shipDetailCustomize = data[0];
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    // //表格
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
        // 查询出荷明细指示
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_table_dtb_ship_detail_and_product',
                params: {'ship_id': state.shipId})
            .select('*')
            .order('id', ascending: false)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
        // 列表数据清空
        state.records.clear();
        // 循环出荷指示数据
        for (int i = 0; i < data.length; i++) {
          data[i]['confirm_kbn_msg'] =
              data[i]['confirm_kbn'] == '1' ? 'ON' : 'OFF';
          double subtotal =
              data[i]['ship_num'] != null && data[i]['product_price'] != null
                  ? data[i]['ship_num'] * data[i]['product_price']
                  : 0;
          data[i].addAll({'subtotal': subtotal.toString()});
          // 列表数据增加
          state.records.add(WmsRecordModel(i, data[i]));
        }
        state.total = data.length;
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    on<QueryShipDetailAndProductEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();

        // 查询出荷明细指示
        List<dynamic> data = await SupabaseUtils.getClient().rpc(
            'func_query_table_dtb_ship_detail_and_product_location',
            params: {'id': event.id}).select('*');
        if (data.length > 0) {
          for (var i = 0; i < data.length; i++) {
            if (data[i]['image1'] != null && data[i]['image1'] != '') {
              data[i]['image1'] =
                  await WMSCommonFile().previewImageFile(data[i]['image1']);
            }
            if (data[i]['image2'] != null && data[i]['image2'] != '') {
              data[i]['image2'] =
                  await WMSCommonFile().previewImageFile(data[i]['image2']);
            }
          }
          state.shipDetailData = data[0];
        }
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    on<ClearShipDetailAndProductEvent>(
      (event, emit) {
        state.shipDetailData = {};
        // 刷新补丁
        emit(clone(state));
      },
    );
    on<queryShipByShipIdEvent>(
      (event, emit) async {
        List<dynamic> ship = await SupabaseUtils.getClient()
            .from("dtb_ship")
            .select('*')
            .eq('id', event.ShipId);
        state.shipData = ship[0];
        // 刷新补丁
        emit(clone(state));
      },
    );
    //取消按钮
    on<updateShipEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        try {
          //获取当前登录用户会社ID
          int companyId = StoreProvider.of<WMSState>(event.context)
              .state
              .loginUser!
              .company_id!;
          int updateId =
              StoreProvider.of<WMSState>(event.context).state.loginUser!.id!;
          String updateTime = DateTime.now().toString();
          int num = event.shipDetail['packing_num'] == '' ||
                  event.shipDetail['packing_num'] == null
              ? 0
              : event.shipDetail['packing_num'];

          //创建 dtb_store_history受払明細
          Map<String, dynamic> formInfo = {};
          StoreHistory history = StoreHistory.fromJson(formInfo);
          history.rev_ship_line_no = event.shipDetail['ship_line_no'];
          history.rev_ship_kbn = event.shipDetail['confirm_kbn'];
          history.product_id = event.shipDetail['product_id'];
          history.num = event.shipDetail['store_num'];
          history.store_kbn = event.shipDetail['store_kbn'];
          history.location_id = event.shipDetail['location_id'];
          history.note1 = event.shipDetail['note1'];
          history.note2 = event.shipDetail['note2'];
          history.company_id = companyId;
          //8:出荷確定取消
          history.action_id = 8;
          history.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          history.create_time = DateTime.now().toString();

          //插入表 dtb_store_history受払明細
          await SupabaseUtils.getClient()
              .from('dtb_store_history')
              .insert([history.toJson()]).select('*');
          //查询dtb_store在库
          List<dynamic> storeList = await SupabaseUtils.getClient()
              .from('dtb_store')
              .select('*')
              .eq('product_id', event.shipDetail['product_id'])
              .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
              .eq('company_id', companyId);
          //在库数
          int stock = 0;
          //ロック数
          int lockStock = 0;
          //出库数
          int outStock = 0;
          if (storeList.length > 0) {
            for (var i = 0; i < storeList.length; i++) {
              stock = storeList[i]['stock'] != null ? storeList[i]['stock'] : 0;
              lockStock = storeList[i]['lock_stock'] != null
                  ? storeList[i]['stock']
                  : 0;
              outStock =
                  storeList[i]['out_stock'] != null ? storeList[i]['stock'] : 0;
              //更新dtb_store在库
              await SupabaseUtils.getClient()
                  .from('dtb_store')
                  .update({
                    "stock": stock + num,
                    "lock_stock": lockStock + num,
                    "out_stock": outStock - num,
                    'update_id': updateId,
                    'update_time': updateTime
                  })
                  .eq('product_id', event.shipDetail['product_id'])
                  .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
                  .eq('company_id', companyId);
            }
          }

          //根据出荷指示明细行no 查找 商品入出荷位置
          List<dynamic> location = await SupabaseUtils.getClient()
              .from('dtb_rev_ship_location')
              .select('*')
              .eq('rev_ship_line_no', event.shipDetail['ship_line_no'])
              .eq('rev_ship_kbn', '2');
          int stockNum = 0;
          // 商品入出荷位置的【入/出庫数】
          if (location.length > 0) {
            for (var l = 0; l < location.length; l++) {
              stockNum =
                  location[l]['stock'] != null ? location[l]['stock'] : 0;
              List<dynamic> productLocList = await SupabaseUtils.getClient()
                  .from('dtb_product_location')
                  .select('*')
                  .eq('location_id', location[l]['product_location_id'])
                  .eq('product_id', event.shipDetail['product_id']);
              if (productLocList.length > 0) {
                //根据
                // 【ロケーションid】=商品入出荷位置的【商品ロケーションid】
                // 【商品ID】=出荷指示明細的【商品ID】
                //修改 dtb_product_location(商品在庫位置)
                for (var p = 0; p < productLocList.length; p++) {
                  await SupabaseUtils.getClient()
                      .from('dtb_product_location')
                      .update({
                        'stock': productLocList[p]['stock'] + stockNum,
                        'lock_stock':
                            productLocList[p]['lock_stock'] + stockNum,
                        'update_id': updateId,
                        'update_time': updateTime
                      })
                      .eq('location_id', location[l]['product_location_id'])
                      .eq('product_id', event.shipDetail['product_id']);
                }
              }
            }
          }
          // 修改出荷指示ship[【出荷状態】=【6:出荷確定待ち】 【出荷確定日】= NULL
          await SupabaseUtils.getClient()
              .from('dtb_ship')
              .update({
                "ship_kbn": '6',
                'rcv_real_date': null,
                'update_id': updateId,
                'update_time': updateTime
              })
              .eq('id', event.shipDetail['ship_id'])
              .select('*');
          //更新表：dtb_ship_detail(出荷指示明細) 【出荷確定】=【2:OFF(default)】
          await SupabaseUtils.getClient()
              .from('dtb_ship_detail')
              .update({
                'confirm_kbn': '2',
                'update_id': updateId,
                'update_time': updateTime
              })
              .eq('id', event.shipDetail['id'])
              .select('*');

          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.Inventory_Confirmed_tip_8);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.Inventory_Confirmed_tip_10);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );
    add(InitEvent());
  }
}
