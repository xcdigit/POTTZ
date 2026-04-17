import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/file/wms_common_file.dart';
import 'package:wms/model/product_location.dart';
import 'package:wms/model/store_history.dart';
import 'package:wms/model/store_move.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../common/utils/check_utils.dart';

/**
 * content：在庫移動入力-参数
 * author：张博睿
 * date：2023/09/21
 */

abstract class GoodsTransferEntryEvent extends TableListEvent {}

class InitEvent extends GoodsTransferEntryEvent {
  // 初始化事件
  InitEvent();
}

class ClearFormDataEvent extends GoodsTransferEntryEvent {
  // 清除form表单数据
  ClearFormDataEvent();
}

//取得元货架位置
class QueryProductLocationMessageEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  String locationCode;
  int flag;
  QueryProductLocationMessageEvent(this.context, this.locationCode, this.flag);
}

class QueryProductLocationGoodsMessageEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  String productCode;
  int flag;
  QueryProductLocationGoodsMessageEvent(
      this.context, this.productCode, this.flag);
}

class QueryLocationToMessageEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  String locationCode;
  QueryLocationToMessageEvent(this.context, this.locationCode);
}

class SetMoveCountEvent extends GoodsTransferEntryEvent {
  String moveCount;
  BuildContext context;
  SetMoveCountEvent(this.moveCount, this.context);
}

class SetMoveReasonEvent extends GoodsTransferEntryEvent {
  String moveReason;
  SetMoveReasonEvent(this.moveReason);
}

class ExecuteTransferGoodsEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  ExecuteTransferGoodsEvent(this.context);
}

class AddStoreMoveDataEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  AddStoreMoveDataEvent(this.context);
}

class UpdateProductLocationFromInformationEvent
    extends GoodsTransferEntryEvent {
  BuildContext context;
  UpdateProductLocationFromInformationEvent(this.context);
}

class UpdateProductLocationToInformationEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  UpdateProductLocationToInformationEvent(this.context);
}

class AddStoreHistoryDataEvent extends GoodsTransferEntryEvent {
  BuildContext context;
  AddStoreHistoryDataEvent(this.context);
}

class GoodsTransferEntryBloc extends WmsTableBloc<GoodsTransferEntryModel> {
  @override
  GoodsTransferEntryModel clone(GoodsTransferEntryModel src) {
    return GoodsTransferEntryModel.clone(src);
  }

  GoodsTransferEntryBloc(GoodsTransferEntryModel state) : super(state) {
    on<InitEvent>((event, emit) async {});

    on<ClearFormDataEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 赋值-用户所属会社ID
      state.companyId =
          StoreProvider.of<WMSState>(state.context).state.loginUser?.company_id;
      // 赋值-用户ID
      state.userId =
          StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
      // 赋值-移动前位置主键
      state.locationIdFrom = 0;
      // 赋值-移动前位置code
      state.locationCodeFrom = '';
      // 赋值-商品主键
      state.productId = 0;
      // 赋值-商品code
      state.productCode = '';
      // 赋值-商品名称
      state.productName = '';
      // 赋值-消费期限
      state.expirationDate = '';
      // 赋值-商品写真
      state.goodImage = '';
      // 赋值-批号
      state.lotNo = '';
      // 赋值-序列号
      state.serialNo = '';
      // 赋值-补充资料
      state.supplementaryInformation = '';
      // 赋值-在庫数
      state.stockCount = 0;
      // 赋值-lock数
      state.lockCount = 0;
      // 赋值-移动后位置主键
      state.locationIdTo = 0;
      // 赋值-移动后位置code
      state.locationCodeTo = '';
      // 赋值-移动数量
      state.moveCount = 0;
      // 赋值-移动理由
      state.moveReason = '';
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QueryProductLocationMessageEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 清除数据
      this.clearFormDataPCEvent(state);

      state.locationCodeFrom = event.locationCode;

      if (event.locationCode != '') {
        // 查询位置集合
        List<dynamic> locationData = await SupabaseUtils.getClient()
            .from('mtb_location')
            .select('*')
            .eq('loc_cd', event.locationCode)
            .eq("del_kbn", "2");

        if (locationData.length > 0) {
          // 查询位置集合
          List<dynamic> productLocationData = await SupabaseUtils.getClient()
              .from('dtb_product_location')
              .select('*')
              .eq('location_id', locationData[0]['id']);
          if (productLocationData.length == 0) {
            state.locationCodeFrom = '';
            state.locationIdFrom = 0;
            // 消息提示：请输入正确位置的条形码
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                    .goods_transfer_entry_form_toast_2);
          } else {
            state.locationIdFrom = productLocationData[0]['location_id'];
          }
        } else {
          state.locationCodeFrom = '';
          // 消息提示：请输入正确位置的条形码
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
              .goods_transfer_entry_form_toast_2);
        }
      }
      // 刷新补丁
      emit(clone(state));

      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QueryProductLocationGoodsMessageEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (event.productCode != '') {
        // func_query_product_location_goods_message
        // 查询商品信息
        List goodsMessage = await SupabaseUtils.getClient()
            .rpc('func_query_product_location_goods_message', params: {
          'location_id': state.locationIdFrom,
          'product_code': event.productCode,
        });
        if (goodsMessage.length > 0) {
          // 商品主键
          state.productId = int.parse(goodsMessage[0]['product_id'].toString());
          // 商品code
          state.productCode = goodsMessage[0]['product_code'] != null
              ? goodsMessage[0]['product_code']
              : '';
          // 商品名称
          state.productName = goodsMessage[0]['product_name'] != null
              ? goodsMessage[0]['product_name']
              : '';
          // 消费期限
          state.expirationDate = goodsMessage[0]['limit_date'] != null
              ? goodsMessage[0]['limit_date']
              : '';
          // 商品写真
          // state.goodImage = goodsMessage[0]['product_image'];
          if (goodsMessage[0]['product_image'] != '' &&
              goodsMessage[0]['product_image'] != null &&
              !goodsMessage[0]['product_image'].toString().contains('https')) {
            state.goodImage = await WMSCommonFile()
                .previewImageFile(goodsMessage[0]['product_image']);
          }
          // 批号
          state.lotNo = goodsMessage[0]['lot_no'] != null
              ? goodsMessage[0]['lot_no']
              : '0';
          // 序列号
          state.serialNo = goodsMessage[0]['serial_no'] != null
              ? goodsMessage[0]['serial_no']
              : '0';
          // 补充资料
          state.supplementaryInformation =
              goodsMessage[0]['note'] != null ? goodsMessage[0]['note'] : '';
          // 在庫数
          state.stockCount =
              goodsMessage[0]['stock'] != null ? goodsMessage[0]['stock'] : '0';
          // lock数
          state.lockCount = goodsMessage[0]['lock_stock'] != null
              ? goodsMessage[0]['lock_stock']
              : '0';
        } else {
          // 消息提示：不在该ロケーション上
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
              .goods_transfer_entry_form_toast_3);
        }
      }
      if (event.flag == Config.NUMBER_ZERO) {
        // 刷新补丁
        emit(clone(state));
      }
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QueryLocationToMessageEvent>((event, emit) async {
      state.locationCodeTo = event.locationCode;
      // 打开加载状态
      BotToast.showLoading();
      if (event.locationCode != '') {
        //自货架移动不可
        if (event.locationCode == state.locationCodeFrom) {
          // 消息提示：请输入正确位置的条形码
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
              .goods_transfer_entry_form_toast_2);
          //清空条形码数据
          state.locationCodeTo = '';
          // 刷新补丁
          emit(clone(state));
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 查询位置集合
        List locationData = await SupabaseUtils.getClient()
            .from('mtb_location')
            .select('*')
            .eq('loc_cd', event.locationCode)
            .eq('company_id', state.companyId)
            .eq("del_kbn", "2");
        if (locationData.length == 0) {
          state.locationIdTo = 0;
          // 消息提示：请输入正确位置的条形码
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
              .goods_transfer_entry_form_toast_2);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        } else {
          state.locationIdTo = locationData[0]['id'];
        }
      }
      //判断平台
      if (kIsWeb) {
        // 刷新补丁
        emit(clone(state));
      } else {
        // 重新取得商品情报
        add(QueryProductLocationGoodsMessageEvent(
            event.context, state.productCode, Config.NUMBER_ONE));
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<SetMoveCountEvent>((event, emit) async {
      if (event.moveCount != '') {
        // 验证是否全数字
        final reg = RegExp('^[0-9]*\$');
        bool res = reg.hasMatch(event.moveCount);
        if (!res) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!
                      .goods_transfer_entry_number_of_moves +
                  WMSLocalizations.i18n(event.context)!.input_int_check);
          state.moveCount = 0;
        } else {
          if (int.parse(event.moveCount) > state.stockCount - state.lockCount) {
            state.moveCount = state.stockCount - state.lockCount;
            // 消息提示：移動數不能超過在庫數和鎖定數的差
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                    .goods_transfer_entry_form_toast_5);
          } else {
            state.moveCount = int.parse(event.moveCount);
          }
        }
      }
      // 刷新补丁
      emit(clone(state));
    });

    on<SetMoveReasonEvent>((event, emit) async {
      state.moveReason = event.moveReason;
      // 刷新补丁
      emit(clone(state));
    });

    on<ExecuteTransferGoodsEvent>((event, emit) async {
      if (state.locationCodeFrom == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .goods_transfer_entry_location_barcode +
            WMSLocalizations.i18n(event.context)!.can_not_null_text);
      } else if (CheckUtils.check_Half_Alphanumeric_Symbol(
          state.locationCodeFrom)) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .goods_transfer_entry_location_barcode +
            WMSLocalizations.i18n(event.context)!
                .check_half_width_alphanumeric_with_symbol);
      } else if (state.productCode == '') {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .shipment_inspection_product_barcodes +
            WMSLocalizations.i18n(event.context)!.can_not_null_text);
      } else if (CheckUtils.check_Half_Alphanumeric_6_50(state.productCode)) {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .shipment_inspection_product_barcodes +
            WMSLocalizations.i18n(event.context)!.text_must_six_number_letter);
      } else if (state.locationCodeTo == '') {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .goods_transfer_entry_destination_location_barcode +
            WMSLocalizations.i18n(event.context)!.can_not_null_text);
      } else if (CheckUtils.check_Half_Alphanumeric_Symbol(
          state.locationCodeTo)) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .goods_transfer_entry_destination_location_barcode +
            WMSLocalizations.i18n(event.context)!
                .check_half_width_alphanumeric_with_symbol);
      } else if (state.moveCount == 0) {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
            .goods_transfer_entry_form_toast_6);
      } else if (CheckUtils.check_Half_Number_In_10(state.moveCount)) {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
            .check_half_width_numbers_in_10);
      } else if (state.moveReason == '') {
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .goods_transfer_entry_reason_for_movement +
            WMSLocalizations.i18n(event.context)!.can_not_null_text);
      } else {
        // 打开加载状态
        BotToast.showLoading();
        add(AddStoreMoveDataEvent(event.context));
      }
    });

    on<AddStoreMoveDataEvent>((event, emit) async {
      // 在库调整表实例化
      StoreMove storeMove = new StoreMove.empty();
      // 赋值-移動調整区分
      storeMove.move_kbn = Config.NUMBER_ONE.toString();
      // 赋值-移動元ロケーションID
      storeMove.from_location_id = state.locationIdFrom;
      // 赋值-移動先ロケーションID
      storeMove.to_location_id = state.locationIdTo;
      // 赋值-商品ＩＤ
      storeMove.product_id = state.productId;
      // 赋值-移動数量
      storeMove.move_num = state.moveCount;
      // 赋值-移动前数量
      storeMove.before_ad_num = state.stockCount;
      // 赋值-移动后数量
      storeMove.after_ad_num = state.stockCount - state.moveCount;
      // 赋值-移動調整日付
      storeMove.adjust_date = DateTime.now().toString();
      // 赋值-移動調整理由
      storeMove.adjust_reason = state.moveReason;
      // 赋值-会社_ID
      storeMove.company_id = state.companyId;
      // 赋值-创建时间
      storeMove.create_time = DateTime.now().toString();
      // 赋值-创建者
      storeMove.create_id = state.userId;
      // 赋值-更新时间
      storeMove.update_time = DateTime.now().toString();
      // 赋值-更新者
      storeMove.update_id = state.userId;
      // 新增在库移动数据
      await SupabaseUtils.getClient()
          .from('dtb_store_move')
          .insert([storeMove.toJson()]).select('*');

      add(UpdateProductLocationFromInformationEvent(event.context));
    });

    // 更新table表dtb_product_location移動元ロケーション在库数
    on<UpdateProductLocationFromInformationEvent>((event, emit) async {
      // 变更table表dtb_product_location的移動元ロケーション在库数减少
      await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .update({
            'stock': state.stockCount - state.moveCount,
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          })
          .eq('location_id', state.locationIdFrom)
          .eq('product_id', state.productId)
          .select('*');
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();
      String yearMonth = year + month;
      // 查询商品在库数据
      List<dynamic> storeInformationList = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', state.productId)
          .eq('year_month', yearMonth);
      if (storeInformationList.length > 0) {
        // 变更table表dtb_store的在库数减少，出庫移動数增加
        await SupabaseUtils.getClient()
            .from('dtb_store')
            .update({
              'move_out_stock':
                  storeInformationList[0]['move_out_stock'] + state.moveCount,
              'update_time': DateTime.now().toString(),
              'update_id': state.userId,
            })
            .eq('product_id', state.productId)
            .eq('company_id', state.companyId)
            .eq('year_month', yearMonth);
        add(UpdateProductLocationToInformationEvent(event.context));
      }
    });

    // 更新table表dtb_product_location的移動先ロケーション在库数
    on<UpdateProductLocationToInformationEvent>((event, emit) async {
      // 查询商品在库数据
      List<dynamic> productInformationList = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .select('*')
          .eq('product_id', state.productId)
          .eq('location_id', state.locationIdTo);

      if (productInformationList.length > 0) {
        // 变更table表dtb_product_location的移動先ロケーション在库数增加
        await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .update({
              'stock': productInformationList[0]['stock'] + state.moveCount,
              'update_time': DateTime.now().toString(),
              'update_id': state.userId,
            })
            .eq('product_id', state.productId)
            .eq('location_id', state.locationIdTo)
            .select('*');
      } else {
        List<dynamic> tempList = await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .select('*')
            .eq('product_id', state.productId)
            .eq('location_id', state.locationIdFrom);
        if (tempList.length > 0) {
          // table表dtb_product_location 实例化
          ProductLocation productLocation = new ProductLocation.empty();
          // 赋值-移動先ロケーション
          productLocation.location_id = state.locationIdTo;
          // 赋值-在庫ID
          productLocation.stock_id = tempList[0]['stock_id'];
          // 赋值-商品ID
          productLocation.product_id = tempList[0]['product_id'];
          // 赋值-在庫数
          productLocation.stock = state.moveCount;
          // 赋值-lock数
          productLocation.lock_stock = 0;
          // 赋值-消费期限
          productLocation.limit_date = tempList[0]['limit_date'];
          // 赋值-批号
          productLocation.lot_no = tempList[0]['lot_no'];
          // 赋值-序列号
          productLocation.serial_no = tempList[0]['serial_no'];
          // 赋值-补充资料
          productLocation.note = tempList[0]['note'];
          // 赋值-创建时间
          productLocation.create_time = DateTime.now().toString();
          // 赋值-创建者
          productLocation.create_id = state.userId;
          // 赋值-更新时间
          productLocation.update_time = DateTime.now().toString();
          // 赋值-更新者
          productLocation.update_id = state.userId;

          // 新增商品在庫信息数据
          await SupabaseUtils.getClient()
              .from('dtb_product_location')
              .insert([productLocation.toJson()]).select('*');
        }
      }
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();

      String yearMonth = year + month;
      // 查询商品在库数据
      List<dynamic> storeInformationList = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', state.productId)
          .eq('year_month', yearMonth);
      if (storeInformationList.length > 0) {
        // 变更table表dtb_store的在库数减少，出庫移動数增加
        await SupabaseUtils.getClient()
            .from('dtb_store')
            .update({
              'move_in_stock':
                  storeInformationList[0]['move_in_stock'] + state.moveCount,
              'update_time': DateTime.now().toString(),
              'update_id': state.userId,
            })
            .eq('product_id', state.productId)
            .eq('company_id', state.companyId)
            .eq('year_month', yearMonth);
      }
      add(AddStoreHistoryDataEvent(event.context));
    });

    // 追加受払明細数据
    on<AddStoreHistoryDataEvent>((event, emit) async {
      List<dynamic> storeList = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', state.productId)
          .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()));
      StoreHistory storeHistory = new StoreHistory.empty();
      // 赋值-在库ID
      storeHistory.stock_id = storeList[0]['id'];
      // 赋值-年月
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();
      storeHistory.year_month = year + month;
      // 赋值-mtb_product表主键
      storeHistory.product_id = state.productId;
      //  赋值-出庫数
      storeHistory.num = state.moveCount;
      //  赋值-入出庫区分-----入庫：“1”，出庫：“2”
      storeHistory.store_kbn = Config.NUMBER_TWO.toString();
      // 赋值-ロケーションid
      storeHistory.location_id = state.locationIdFrom;
      // 赋值-アクション区分 11：在庫移動
      storeHistory.action_id = 11;
      // 赋值-会社_ID
      storeHistory.company_id = state.companyId;
      // 赋值-登録日時
      storeHistory.create_time = DateTime.now().toString();
      // 赋值-登録者
      storeHistory.create_id = state.userId;

      // 新增出庫明細历史
      await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]).select('*');

      //  赋值-入出庫区分-----入庫：“1”，出庫：“2”
      storeHistory.store_kbn = Config.NUMBER_ONE.toString();
      // 赋值-ロケーションid
      storeHistory.location_id = state.locationIdTo;
      // 赋值-登録日時
      storeHistory.create_time = DateTime.now().toString();
      // 赋值-登録者
      storeHistory.create_id = state.userId;

      // 新增出庫明細历史
      await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]).select('*');
      // 消息提示：移動成功です
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
          .goods_transfer_entry_form_toast_4);
      //清空数据
      add(ClearFormDataEvent());
      // 刷新补丁
      emit(clone(state));
      // 插入操作履历 sys_log表
      CommonUtils().createLogInfo(
          '在庫移動入力' +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "ExecuteTransferGoodsEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);
      // 判断平台
      if (kIsWeb) {
        // DO NOTHING
      } else {
        // 返回上一页
        GoRouter.of(event.context).pop('refresh return');
        // 关闭加载
        BotToast.closeAllLoading();
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });

    add(InitEvent());
  }
  //清除数据 PC用
  clearFormDataPCEvent(GoodsTransferEntryModel state) {
// 赋值-用户所属会社ID
    state.companyId =
        StoreProvider.of<WMSState>(state.context).state.loginUser?.company_id;
    // 赋值-用户ID
    state.userId =
        StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
    // 赋值-移动前位置主键
    state.locationIdFrom = 0;
    // 赋值-移动前位置code
    state.locationCodeFrom = '';
    // 赋值-商品主键
    state.productId = 0;
    // 赋值-商品code
    state.productCode = '';
    // 赋值-商品名称
    state.productName = '';
    // 赋值-消费期限
    state.expirationDate = '';
    // 赋值-商品写真
    state.goodImage = '';
    // 赋值-批号
    state.lotNo = '';
    // 赋值-序列号
    state.serialNo = '';
    // 赋值-补充资料
    state.supplementaryInformation = '';
    // 赋值-在庫数
    state.stockCount = 0;
    // 赋值-lock数
    state.lockCount = 0;
    // 赋值-移动后位置主键
    state.locationIdTo = 0;
    // 赋值-移动后位置code
    state.locationCodeTo = '';
    // 赋值-移动数量
    state.moveCount = 0;
    // 赋值-移动理由
    state.moveReason = '';
  }
}
