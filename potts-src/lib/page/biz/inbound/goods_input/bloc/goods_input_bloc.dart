import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/file/wms_common_file.dart';
import 'package:wms/model/product_location.dart';
import 'package:wms/model/rev_ship_location.dart';
import 'package:wms/model/store.dart';
import 'package:wms/model/store_history.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_model.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../common/utils/printer_utils.dart';
import '../../../../../redux/wms_state.dart';

/**
 * content：入庫入力-bloc
 * author：张博睿
 * date：2023/09/27
 */

abstract class GoodsInputEvent extends TableListEvent {}

class InitEvent extends GoodsInputEvent {
  // 初始化事件
  InitEvent();
}

// 清空form表单数据
class ClearFormDataEvent extends GoodsInputEvent {
  ClearFormDataEvent();
}

class ClearProductInfoEvent extends GoodsInputEvent {
  ClearProductInfoEvent();
}

// 检索位置条形码列表
class QueryLocationListEvent extends GoodsInputEvent {
  QueryLocationListEvent();
}

class QueryDtbReceiveDataEvent extends GoodsInputEvent {
  String barCode;
  BuildContext context;
  QueryDtbReceiveDataEvent(this.barCode, this.context);
}

class QueryDtbReceiveDetailDataEvent extends GoodsInputEvent {
  String barCode;
  BuildContext context;
  QueryDtbReceiveDetailDataEvent(this.barCode, this.context);
}

class SetLocationInfoEvent extends GoodsInputEvent {
  String key;
  String value;
  SetLocationInfoEvent(this.key, this.value);
}

class SetExpirationDateEvent extends GoodsInputEvent {
  String value;
  SetExpirationDateEvent(this.value);
}

class SetInputNumerEvent extends GoodsInputEvent {
  String value;
  SetInputNumerEvent(this.value);
}

class SetLotNoEvent extends GoodsInputEvent {
  String value;
  SetLotNoEvent(this.value);
}

class SetSerialNoEvent extends GoodsInputEvent {
  String value;
  SetSerialNoEvent(this.value);
}

class SetNoteEvent extends GoodsInputEvent {
  String value;
  SetNoteEvent(this.value);
}

class ExecuteButtonEvent extends GoodsInputEvent {
  ExecuteButtonEvent();
}

class ExecuteQueryDtbReceiveDetailEvent extends GoodsInputEvent {
  ExecuteQueryDtbReceiveDetailEvent();
}

class ExecuteQueryDtbRevShipLocationEvent extends GoodsInputEvent {
  ExecuteQueryDtbRevShipLocationEvent();
}

class ExecuteUpdateDtbProductLocationExistEvent extends GoodsInputEvent {
  ExecuteUpdateDtbProductLocationExistEvent();
}

class ExecuteUpdateDtbProductLocationAbsentEvent extends GoodsInputEvent {
  int locationId = 0;
  ExecuteUpdateDtbProductLocationAbsentEvent(this.locationId);
}

class ExecuteUpdateDtbReceiveDetailEvent extends GoodsInputEvent {
  ExecuteUpdateDtbReceiveDetailEvent();
}

class ExecuteUpdateDtbStoreEvent extends GoodsInputEvent {
  ExecuteUpdateDtbStoreEvent();
}

class ExecuteUpdateDtbProductLocationEvent extends GoodsInputEvent {
  int storeId;
  ExecuteUpdateDtbProductLocationEvent(this.storeId);
}

class ExecuteInsertDtbRevShipLocationEvent extends GoodsInputEvent {
  int storeId;
  ExecuteInsertDtbRevShipLocationEvent(this.storeId);
}

class ExecuteInsertDtbStoreHistoryEvent extends GoodsInputEvent {
  int storeId;
  ExecuteInsertDtbStoreHistoryEvent(this.storeId);
}

class ConfirmButtonEvent extends GoodsInputEvent {
  ConfirmButtonEvent();
}

class QueryTableDetailsEvent extends GoodsInputEvent {
  BuildContext context;
  dynamic value;
  QueryTableDetailsEvent(this.context, this.value);
}

class DeleteTableDetailsEvent extends GoodsInputEvent {
  BuildContext context;
  dynamic value;
  DeleteTableDetailsEvent(this.context, this.value);
}

class SetSpDataEvent extends GoodsInputEvent {
  String receiveId;
  // List<WmsRecordModel> records;
  String total;
  SetSpDataEvent(this.receiveId, this.total);
}

// 赵士淞 - 始
// 打印事件
class TablePrinterEvent extends GoodsInputEvent {
  // 上下文
  BuildContext context;
  // 明细ID
  int detailId;

  // 打印事件
  TablePrinterEvent(this.context, this.detailId);
}

// 打印事件
class FormPrinterEvent extends GoodsInputEvent {
  // 上下文
  BuildContext context;

  // 打印事件
  FormPrinterEvent(this.context);
}
// 赵士淞 - 终

class GoodsInputBloc extends WmsTableBloc<GoodsInputModel> {
  @override
  GoodsInputModel clone(GoodsInputModel src) {
    return GoodsInputModel.clone(src);
  }

  // 查询出荷指示明细事件
  Future<bool> ExecuteButtonEvent(BuildContext context) async {
    // 判断出荷指示-定制ID
    if (state.incomingBarCode.isNotEmpty &&
        state.goodsBarCode.isNotEmpty &&
        state.expirationDate.isNotEmpty &&
        state.location.loc_cd != null &&
        state.location.loc_cd != '') {
      // 查询出荷指示明细事件
      return ExecuteQueryDtbReceiveDetailEvent(context);
    } else if (!state.incomingBarCode.isNotEmpty) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.goods_receipt_input_list_bar_code +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_Symbol(
        state.incomingBarCode)) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.goods_receipt_input_list_bar_code +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    } else if (!state.goodsBarCode.isNotEmpty) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipment_inspection_product_barcodes +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_Symbol(state.goodsBarCode)) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipment_inspection_product_barcodes +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    } else if (!state.expirationDate.isNotEmpty) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.pink_list_54 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.lotNo != '' &&
        CheckUtils.check_Half_Alphanumeric_Symbol(state.lotNo)) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.goods_receipt_input_lot_no +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    } else if (state.serialNo != '' &&
        CheckUtils.check_Half_Alphanumeric_Symbol(state.serialNo)) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.goods_receipt_input_serial_no +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    } else if (state.location.loc_cd == null || state.location.loc_cd == '') {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.exit_input_form_title_11 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else {
      // 提示消息：正確な情報の入力をお願いします。
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.goods_receipt_input_toast_4);
      return false;
    }
  }

  // 执行按钮检索dtb_receive_detail数据
  Future<bool> ExecuteQueryDtbReceiveDetailEvent(BuildContext context) async {
    // 打开加载状态
    BotToast.showLoading();
    try {
      List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .select('*')
          .eq('receive_line_no', state.goodsBarCode)
          .eq("del_kbn", "2");
      if (receiveDetailData.length > 0) {
        if (receiveDetailData[0]['store_kbn'] == '1') {
          return ExecuteQueryDtbRevShipLocationEvent(context);
        } else if (receiveDetailData[0]['store_kbn'] == '2') {
          return ExecuteUpdateDtbReceiveDetailEvent(context);
        } else {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .goods_receipt_input_toast_execute_fail);
          return false;
        }
      } else {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  // 执行按钮检索dtb_rev_ship_location数据，获取商品入出荷位置
  Future<bool> ExecuteQueryDtbRevShipLocationEvent(BuildContext context) async {
    try {
      List<dynamic> dtbRevShipLocationData = await SupabaseUtils.getClient()
          .from('dtb_rev_ship_location')
          .select('*')
          .eq('rev_ship_line_no', state.goodsBarCode)
          .eq('rev_ship_kbn', '1');
      if (dtbRevShipLocationData.length > 0) {
        if (dtbRevShipLocationData[0]['product_location_id'] ==
            state.location.id) {
          return ExecuteUpdateDtbProductLocationExistEvent(context);
        } else {
          return ExecuteUpdateDtbProductLocationAbsentEvent(
              dtbRevShipLocationData[0]['product_location_id'], context);
        }
      } else {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  // 执行按钮更新dtb_product_location数据(画面入力的【ロケーションのバーコード】存在场合)
  Future<bool> ExecuteUpdateDtbProductLocationExistEvent(
      BuildContext context) async {
    try {
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .update({
            'limit_date': state.expirationDate,
            'lot_no': state.lotNo != '' ? state.lotNo : null,
            'serial_no': state.serialNo != '' ? state.serialNo : null,
            'note': state.supplementaryInformation != ''
                ? state.supplementaryInformation
                : null,
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          })
          .eq('location_id', state.location.id)
          .eq('product_id', state.goodsId)
          .select('*');
      if (data.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      } else {
        // 关闭加载
        BotToast.closeAllLoading();
        return true;
      }
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  // 执行按钮更新dtb_product_location数据(画面入力的【ロケーションのバーコード】不存在场合)
  Future<bool> ExecuteUpdateDtbProductLocationAbsentEvent(
      locationId, BuildContext context) async {
    try {
      // 检索商品在库位置数据
      List<dynamic> dtbProductLocationData = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .select('*')
          .eq('location_id', locationId)
          .eq('product_id', state.goodsId);
      var count = dtbProductLocationData[0]['stock'];
      var storeId = dtbProductLocationData[0]['stock_id'];
      // 更新商品在库位置的在库数
      List<dynamic> updateDataDPL = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .update({
            'stock': count - state.stock,
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          })
          .eq('location_id', locationId)
          .eq('product_id', state.goodsId)
          .select('*');
      if (updateDataDPL.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      ProductLocation productLocation = ProductLocation.empty();
      productLocation.location_id = state.location.id;
      productLocation.stock_id = storeId;
      productLocation.product_id = state.goodsId;
      productLocation.stock = state.stock;
      productLocation.lock_stock = 0;
      productLocation.limit_date = state.expirationDate;
      productLocation.lot_no = state.lotNo;
      productLocation.serial_no = state.serialNo;
      productLocation.note = state.supplementaryInformation;
      productLocation.create_id = state.userId;
      productLocation.create_time = DateTime.now().toString();
      productLocation.update_id = state.userId;
      productLocation.update_time = DateTime.now().toString();
      // 新增商品在库位置数据
      List<dynamic> insertDataDPL = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .insert([productLocation.toJson()]).select('*');
      if (insertDataDPL.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      // 更新商品入出荷最新位置
      List<dynamic> updateDataDRSL = await SupabaseUtils.getClient()
          .from('dtb_rev_ship_location')
          .update({
            'product_location_id': state.location.id,
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          })
          .eq('rev_ship_line_no', state.goodsBarCode)
          .eq('rev_ship_kbn', '1')
          .select('*');
      if (updateDataDRSL.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      StoreHistory storeHistory = StoreHistory.empty();
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();
      // 赋值-在库ID
      storeHistory.stock_id = storeId;
      // 赋值-年月
      storeHistory.year_month = year + month;
      // 赋值-入/出荷明細行no
      storeHistory.rev_ship_line_no = state.goodsBarCode;
      // 赋值-入/出荷予定区分
      storeHistory.rev_ship_kbn = '1';
      // 赋值-商品ID
      storeHistory.product_id = state.goodsId;
      // 赋值-入/出库数
      storeHistory.num = state.stock;
      // 赋值-入出庫区分
      storeHistory.store_kbn = '2';
      // 赋值-ロケーションid
      storeHistory.location_id = locationId;
      // 赋值-アクション区分
      storeHistory.action_id = 1;
      // 赋值-会社_ID
      storeHistory.company_id = state.companyId;
      // 赋值-登録者
      storeHistory.create_id = state.userId;
      // 赋值-登録日時
      storeHistory.create_time = DateTime.now().toString();
      // 新增dtb_store_history(受払明細)旧位置出库数据
      List<dynamic> insertDateDSH1 = await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]).select('*');
      if (insertDateDSH1.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      // 赋值-入出庫区分
      storeHistory.store_kbn = '1';
      // 赋值-ロケーションid
      storeHistory.location_id = state.location.id;
      // 赋值-登録日時
      storeHistory.create_time = DateTime.now().toString();
      // 新增dtb_store_history(受払明細)新位置入库数据
      List<dynamic> insertDateDSH2 = await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]).select('*');
      if (insertDateDSH2.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      // 关闭加载
      BotToast.closeAllLoading();
      return true;
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  // 执行按钮更新dtb_receive_detail数据
  Future<bool> ExecuteUpdateDtbReceiveDetailEvent(BuildContext context) async {
    try {
      List<dynamic> updateDataDRD = await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .update({
            'store_num': state.stock,
            'store_kbn': '1',
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          })
          .eq('receive_line_no', state.goodsBarCode)
          .eq('receive_id', int.tryParse(state.receiveId))
          .select('*');
      if (updateDataDRD.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      return ExecuteUpdateDtbStoreEvent(context);
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  Future<bool> ExecuteUpdateDtbStoreEvent(BuildContext context) async {
    try {
      // 检索商品在库位置数据
      List<dynamic> storeData = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', state.goodsId)
          .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(context).state.loginUser?.company_id
                  as int);
      int storeId;
      if (storeData.length > 0) {
        // 更新dtb_store表“在庫数”和“入庫数”
        List<dynamic> tempData = await SupabaseUtils.getClient()
            .from('dtb_store')
            .update({
              'stock': storeData[0]['stock'] + state.stock,
              'in_stock': storeData[0]['in_stock'] + state.stock,
              'update_time': DateTime.now().toString(),
              'update_id': state.userId,
            })
            .eq('product_id', state.goodsId)
            .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(context).state.loginUser?.company_id
                    as int)
            .select('*');
        if (tempData.length < 0) {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .goods_receipt_input_toast_execute_fail);
          return false;
        }
        storeId = tempData[0]['id'];
      } else {
        String year = DateTime.now().year.toString();
        String month = DateTime.now().month < 10
            ? DateTime.now().month.toString().padLeft(2, '0')
            : DateTime.now().month.toString();
        Store store = Store.empty();
        store.product_id = state.goodsId;
        store.year_month = year + month;
        store.stock = state.stock;
        store.lock_stock = 0;
        store.before_stock = 0;
        store.in_stock = state.stock;
        store.out_stock = 0;
        store.adjust_stock = 0;
        store.inventory_stock = 0;
        store.move_in_stock = 0;
        store.move_out_stock = 0;
        store.return_stock = 0;
        store.company_id = state.companyId;
        store.create_id = state.userId;
        store.create_time = DateTime.now().toString();
        store.update_id = state.userId;
        store.update_time = DateTime.now().toString();
        // 新增dtb_store在库数据
        List<dynamic> tempData = await SupabaseUtils.getClient()
            .from('dtb_store')
            .insert([store.toJson()]).select('*');
        if (tempData.length < 0) {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .goods_receipt_input_toast_execute_fail);
          return false;
        }
        storeId = tempData[0]['id'];
      }
      return ExecuteUpdateDtbProductLocationEvent(storeId, context);
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  // 执行按钮更新dtb_product_location数据
  Future<bool> ExecuteUpdateDtbProductLocationEvent(
      int storeId, BuildContext context) async {
    try {
      // 检索商品在库位置数据
      List<dynamic> productLocationData = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .select('*')
          .eq('location_id', state.location.id)
          .eq('product_id', state.goodsId);

      if (productLocationData.length > 0) {
        // 更新dtb_product_location表数据
        List<dynamic> updateDataDPL = await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .update({
              'stock': productLocationData[0]['stock'] + state.stock,
              'limit_date': state.expirationDate,
              'lot_no': state.lotNo != '' ? state.lotNo : null,
              'serial_no': state.serialNo != '' ? state.serialNo : null,
              'note': state.supplementaryInformation != ''
                  ? state.supplementaryInformation
                  : null,
              'update_time': DateTime.now().toString(),
              'update_id': state.userId,
            })
            .eq('product_id', state.goodsId)
            .eq('location_id', state.location.id)
            .select('*');

        if (updateDataDPL.length < 0) {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .goods_receipt_input_toast_execute_fail);
          return false;
        }
      } else {
        ProductLocation productLocation = ProductLocation.empty();
        productLocation.location_id = state.location.id;
        productLocation.stock_id = storeId;
        productLocation.product_id = state.goodsId;
        productLocation.stock = state.stock;
        productLocation.lock_stock = 0;
        productLocation.limit_date = state.expirationDate;
        productLocation.lot_no = state.lotNo;
        productLocation.serial_no = state.serialNo;
        productLocation.note = state.supplementaryInformation;
        productLocation.create_id = state.userId;
        productLocation.create_time = DateTime.now().toString();
        productLocation.update_id = state.userId;
        productLocation.update_time = DateTime.now().toString();
        // 新增dtb_product_location在库数据
        List<dynamic> insertDataDPL = await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .insert([productLocation.toJson()]).select('*');
        if (insertDataDPL.length < 0) {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .goods_receipt_input_toast_execute_fail);
          return false;
        }
      }
      return ExecuteInsertDtbRevShipLocationEvent(storeId, context);
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  Future<bool> ExecuteInsertDtbRevShipLocationEvent(
      int storeId, BuildContext context) async {
    try {
      RevShipLocation revShipLocation = RevShipLocation.empty();
      revShipLocation.rev_ship_line_no = state.goodsBarCode;
      revShipLocation.rev_ship_kbn = '1';
      revShipLocation.product_location_id = state.location.id;
      revShipLocation.stock = state.stock;
      revShipLocation.create_id = state.userId;
      revShipLocation.create_time = DateTime.now().toString();
      revShipLocation.update_id = state.userId;
      revShipLocation.update_time = DateTime.now().toString();
      List<dynamic> insertDataDRSL = await SupabaseUtils.getClient()
          .from('dtb_rev_ship_location')
          .insert([revShipLocation.toJson()]).select('*');
      if (insertDataDRSL.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      }
      return ExecuteInsertDtbStoreHistoryEvent(storeId, context);
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  Future<bool> ExecuteInsertDtbStoreHistoryEvent(
      int storeId, BuildContext context) async {
    try {
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();
      StoreHistory storeHistory = StoreHistory.empty();
      storeHistory.stock_id = storeId;
      storeHistory.year_month = year + month;
      storeHistory.rev_ship_line_no = state.goodsBarCode;
      storeHistory.rev_ship_kbn = '1';
      storeHistory.product_id = state.goodsId;
      storeHistory.num = state.stock;
      storeHistory.store_kbn = '1';
      storeHistory.location_id = state.location.id;
      storeHistory.action_id = 1;
      storeHistory.company_id = state.companyId;
      storeHistory.create_id = state.userId;
      storeHistory.create_time = DateTime.now().toString();
      List<dynamic> insertDataDSH = await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]).select('*');
      if (insertDataDSH.length < 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
            .goods_receipt_input_toast_execute_fail);
        return false;
      } else {
        // 关闭加载
        BotToast.closeAllLoading();
        return true;
      }
    } catch (e) {
      // 关闭加载
      BotToast.closeAllLoading();
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
          .goods_receipt_input_toast_execute_fail);
      return false;
    }
  }

  Future<bool> ConfirmButtonEvent(BuildContext context) async {
    // 打开加载状态
    BotToast.showLoading();
    // 检索未入库数据
    List<dynamic> dtbReceiveDetailData = await SupabaseUtils.getClient()
        .from('dtb_receive_detail')
        .select('*')
        .eq('receive_id', int.tryParse(state.receiveId))
        .eq('store_kbn', '2')
        .eq("del_kbn", "2");
    if (dtbReceiveDetailData.length == 0) {
      await SupabaseUtils.getClient().from('dtb_receive').update({
        'receive_kbn': 4,
        'update_time': DateTime.now().toString(),
        'update_id': state.userId,
      }).eq('receive_no', state.incomingBarCode);
    } else {
      await SupabaseUtils.getClient().from('dtb_receive').update({
        'receive_kbn': 3,
        'update_time': DateTime.now().toString(),
        'update_id': state.userId,
      }).eq('receive_no', state.incomingBarCode);
    }
    WMSCommonBlocUtils.tipTextToast(
        WMSLocalizations.i18n(context)!.goods_receipt_input_toast_5);
    //插入操作履历 sys_log表
    CommonUtils().createLogInfo(
        '入庫入力（NO：' +
            state.incomingBarCode +
            '）' +
            Config.OPERATION_TEXT1 +
            Config.OPERATION_BUTTON_TEXT4 +
            Config.OPERATION_TEXT2,
        "ConfirmButtonEvent()",
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id,
        StoreProvider.of<WMSState>(context).state.loginUser!.id);

    add(SetLocationInfoEvent('id', ''));
    add(SetLocationInfoEvent('loc_cd', ''));
    add(ClearProductInfoEvent());
    add(QueryDtbReceiveDataEvent(state.incomingBarCode, context));

    // 关闭加载
    BotToast.closeAllLoading();
    return true;
  }

  Future<bool> DeleteTableDetailsEvent(
      BuildContext context, dynamic value) async {
    // 打开加载状态
    BotToast.showLoading();
    bool flag = false;
    try {
      // 检索table表dtb_receive数据
      List<dynamic> receiveData = await SupabaseUtils.getClient()
          .from('dtb_receive')
          .select('*')
          .eq('id', value['receive_id'])
          .eq('del_kbn', '2');
      if (receiveData.length > 0) {
        if (receiveData[0]['receive_kbn'] == '4') {
          await SupabaseUtils.getClient().from('dtb_receive').update({
            'receive_kbn': '3',
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          }).eq('id', value['receive_id']);
        }
      }
      // 检索table表dtb_receive_detail数据
      await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .update({
            'store_num': null,
            'store_kbn': '2',
            'update_time': DateTime.now().toString(),
            'update_id': state.userId,
          })
          .eq('receive_id', value['receive_id'])
          .eq('receive_line_no', value['receive_line_no']);
      // 检索table表dtb_store数据
      List<dynamic> storeData = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', value['product_id'])
          .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(context).state.loginUser?.company_id
                  as int);
      int? storeId;
      if (storeData.length > 0) {
        storeId = storeData[0]['id'];
        await SupabaseUtils.getClient()
            .from('dtb_store')
            .update({
              'stock': storeData[0]['stock'] - value['store_num'],
              'in_stock': storeData[0]['in_stock'] - value['store_num'],
              'update_time': DateTime.now().toString(),
              'update_id': state.userId,
            })
            .eq('product_id', value['product_id'])
            .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(context).state.loginUser?.company_id
                    as int);
      }

      List<dynamic> RevShipLocationData = await SupabaseUtils.getClient()
          .from('dtb_rev_ship_location')
          .select('*')
          .eq('rev_ship_line_no', value['receive_line_no'])
          .eq('rev_ship_kbn', '1');
      if (RevShipLocationData.length > 0) {
        //取得当前货架上商品在库数
        List<dynamic> productLocationData = await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .select('*')
            .eq('product_id', value['product_id'])
            .eq('location_id', RevShipLocationData[0]['product_location_id']);
        if (productLocationData.length > 0) {
          await SupabaseUtils.getClient()
              .from('dtb_product_location')
              .update({
                'stock': productLocationData[0]['stock'] - value['store_num'],
                'update_time': DateTime.now().toString(),
                'update_id': state.userId,
              })
              .eq('product_id', productLocationData[0]['product_id'])
              .eq('location_id', productLocationData[0]['location_id']);
        }
      }
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();
      StoreHistory storeHistory = StoreHistory.empty();
      storeHistory.stock_id = storeId;
      storeHistory.year_month = year + month;
      storeHistory.rev_ship_line_no = value['receive_line_no'];
      storeHistory.rev_ship_kbn = '1';
      storeHistory.product_id = value['product_id'];
      storeHistory.num = value['store_num'];
      storeHistory.store_kbn = '2';
      storeHistory.location_id = value['location_id'];
      storeHistory.action_id = 2;
      storeHistory.company_id = state.companyId;
      storeHistory.create_id = state.userId;
      storeHistory.create_time = DateTime.now().toString();
      await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]);
      // 删除table表dtb_rev_ship_location数据
      await SupabaseUtils.getClient()
          .from('dtb_rev_ship_location')
          .delete()
          .eq('rev_ship_line_no', value['receive_line_no'])
          .eq('rev_ship_kbn', '1');
      // 关闭加载
      BotToast.closeAllLoading();
      // 提示消息：削除完了。
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.goods_receipt_input_toast_6);
      flag = true;
    } catch (e) {
      print('$e');
      flag = false;
    } finally {
      return flag;
    }
  }

  GoodsInputBloc(GoodsInputModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (state.receiveId == '0') {
        add(ClearFormDataEvent());
      } else {
        // 调用出荷指示表检索数据
        List<dynamic> receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq("id", int.tryParse(state.receiveId))
            .eq('company_id', state.companyId)
            .eq("del_kbn", "2")
            .or('importerror_flg.is.null,importerror_flg.eq.""');
        if (receiveData.length > 0) {
          // 赋值-入荷予定一覧バーコード
          state.incomingBarCode = receiveData[0]['receive_no'];
          // 赋值-入荷予定番号
          state.incomingNumber = receiveData[0]['receive_no'];
          // 赋值-仕入先
          state.supplier = receiveData[0]['name'];
          // 检索table表dtb_receive_detail数据
          List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
              .rpc('func_query_dtb_receive_detail_table', params: {
            'receive_id': int.tryParse(state.receiveId),
            'store_kbn': Config.NUMBER_ONE.toString(),
            'del_kbn': Config.NUMBER_TWO.toString()
          });

          // 列表数据清空
          state.records.clear();
          if (receiveDetailData.length > 0) {
            // 循环出荷指示数据
            for (int i = 0; i < receiveDetailData.length; i++) {
              // 列表数据增加
              state.records.add(WmsRecordModel(i, receiveDetailData[i]));
            }
            state.total = receiveDetailData.length;
          }
          add(QueryLocationListEvent());
        } else {
          // 提示消息：正しいバーコードを入力をお願いします。
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .goods_receipt_input_toast_1);
        }
      }
    });

    // 清空form表单数据
    on<ClearFormDataEvent>((event, emit) async {
      // Form表单赋空
      state.incomingBarCode = '';
      state.incomingNumber = '';
      state.supplier = '';
      state.goodsBarCode = '';
      state.goodsCode = '';
      state.goodsName = '';
      state.stock = 0;
      state.goodsImage1 = '';
      state.goodsImage2 = '';
      state.expirationDate = '';
      state.lotNo = '';
      state.serialNo = '';
      state.supplementaryInformation = '';

      add(QueryLocationListEvent());
    });

    // 清空商品信息数据
    on<ClearProductInfoEvent>((event, emit) async {
      // 商品信息数据清空
      state.goodsBarCode = '';
      state.goodsCode = '';
      state.goodsName = '';
      state.stock = 0;
      state.goodsImage1 = '';
      state.goodsImage2 = '';
      state.expirationDate = '';
      state.lotNo = '';
      state.serialNo = '';
      state.supplementaryInformation = '';
      // 刷新补丁
      emit(clone(state));
    });

    on<QueryLocationListEvent>((event, emit) async {
      // 调用出荷指示表检索数据
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq("company_id", state.companyId)
          .eq("del_kbn", "2");
      // 赋值-位置条形码列表
      state.locationBarCodeList = locationData;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QueryDtbReceiveDataEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 赋值-入荷予定ID
      state.receiveId = '';
      // 赋值-入荷予定一覧バーコード
      state.incomingBarCode = event.barCode;
      // 赋值-入荷予定番号
      state.incomingNumber = '';
      // 赋值-仕入先
      state.supplier = '';
      if (event.barCode.isNotEmpty) {
        if (CheckUtils.check_Half_Alphanumeric_Symbol(event.barCode)) {
          // 提示消息：正しいバーコードを入力をお願いします。
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                  .goods_receipt_input_list_bar_code +
              WMSLocalizations.i18n(event.context)!
                  .check_half_width_alphanumeric_with_symbol);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 检索table表dtb_receive数据
        List<dynamic> receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('receive_no', event.barCode)
            .eq("company_id", state.companyId)
            .eq("del_kbn", "2")
            .or('importerror_flg.is.null,importerror_flg.eq.""');

        if (receiveData.length == 0) {
          // 提示消息：正しいバーコードを入力をお願いします。
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
              .goods_receipt_input_toast_1);
        } else {
          bool flag = false;
          for (int i = 0; i < receiveData.length; i++) {
            if (receiveData[i]['receive_kbn'] != '2' &&
                receiveData[i]['receive_kbn'] != '3' &&
                receiveData[i]['receive_kbn'] != '4') {
              flag = true;
              break;
            }
          }
          if (flag) {
            // 提示消息：現在のデータ状態では入庫できません。
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                    .goods_receipt_input_toast_2);
          } else {
            // 赋值-入荷予定ID
            state.receiveId = receiveData[0]['id'].toString();
            // 赋值-入荷予定一覧バーコード
            state.incomingBarCode = receiveData[0]['receive_no'];
            // 赋值-入荷予定番号
            state.incomingNumber = receiveData[0]['receive_no'];
            // 赋值-仕入先
            state.supplier = receiveData[0]['name'];
            // 检索table表dtb_receive_detail数据
            List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
                .rpc('func_query_dtb_receive_detail_table', params: {
              'receive_id': int.tryParse(state.receiveId),
              'store_kbn': '1',
              'del_kbn': '2'
            });

            // 列表数据清空
            state.records.clear();
            if (receiveDetailData.length > 0) {
              // 循环出荷指示数据
              for (int i = 0; i < receiveDetailData.length; i++) {
                // 列表数据增加
                state.records.add(WmsRecordModel(i, receiveDetailData[i]));
              }
              state.total = receiveDetailData.length;
            }
          }
        }
      } else {
        // 列表数据清空
        state.records.clear();
        state.total = 0;
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<SetSpDataEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      state.receiveId = event.receiveId;
      state.total = int.parse(event.total);
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QueryDtbReceiveDetailDataEvent>((event, emit) async {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(event.barCode)) {
        // 提示消息：入力したバーコードが正しくありません。
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
                .shipment_inspection_product_barcodes +
            WMSLocalizations.i18n(event.context)!
                .check_half_width_alphanumeric_with_symbol);
        return;
      }
      // 打开加载状态
      BotToast.showLoading();
      // 检索table表dtb_receive_detail数据
      // receive_id - state.receiveId
      List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .select('*')
          .eq('receive_line_no', event.barCode)
          .eq("receive_id", int.tryParse(state.receiveId))
          .eq("del_kbn", "2");
      if (receiveDetailData.length == 0) {
        // 提示消息：入力したバーコードが正しくありません。
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.goods_receipt_input_toast_3);
      } else {
        var productId = receiveDetailData[0]['product_id'];
        state.goodsId = productId;
        // 检索table表mtb_product数据
        List<dynamic> productData = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('id', productId)
            .eq('del_kbn', '2');
        if (productData.length > 0) {
          // 赋值-商品Code
          state.goodsCode = productData[0]['code'];
          // 赋值-商品名称
          state.goodsName = productData[0]['name'];
          // 赋值-商品ラベルのバーコード
          state.goodsBarCode = event.barCode;
          // 赋值-商品图片
          if (productData[0]['image1'] != '' &&
              productData[0]['image1'] != null &&
              !productData[0]['image1'].toString().contains('https')) {
            state.goodsImage1 = await WMSCommonFile()
                .previewImageFile(productData[0]['image1']);
          }
          if (productData[0]['image2'] != '' &&
              productData[0]['image2'] != null &&
              !productData[0]['image2'].toString().contains('https')) {
            state.goodsImage2 = await WMSCommonFile()
                .previewImageFile(productData[0]['image2']);
          }
          if (receiveDetailData[0]['check_num'] != null &&
              receiveDetailData[0]['check_num'] != '') {
            // 赋值-入库数
            state.stock = receiveDetailData[0]['check_num'];
          }
        }
        // if (productLocData.length > 0) {
        //   // 赋值-在库数
        //   state.stock = productLocData[0]['stock'];
        //   // 赋值-消费期限
        //   var tempDate = productLocData[0]['limit_date'];
        //   state.expirationDate = tempDate.replaceAll('-', '/');
        //   // 赋值-批号
        //   state.lotNo = productLocData[0]['lot_no'];
        //   // 赋值-序列号
        //   state.serialNo = productLocData[0]['serial_no'];
        //   // 赋值-补充资料
        //   state.supplementaryInformation = productLocData[0]['note'];
        // }
      }
      // if (state.location.id != null) {

      // } else {
      //   // 提示消息：请输入位置代码。
      //   WMSCommonBlocUtils.tipTextToast('请输入位置代码');
      // }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 赋值-位置条形码选中值
    on<SetLocationInfoEvent>((event, emit) async {
      // 移动前位置
      state.location = event.key == 'id'
          ? state.location.set(event.key, int.tryParse(event.value))
          : state.location.set(event.key, event.value);
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-消费期限
    on<SetExpirationDateEvent>((event, emit) async {
      // 消费期限
      state.expirationDate = event.value;
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-入库数
    on<SetInputNumerEvent>((event, emit) async {
      // 入库数
      if (event.value != '') {
        state.stock = int.tryParse(event.value)!;
      } else {
        state.stock = 0;
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-ロット番号
    on<SetLotNoEvent>((event, emit) async {
      // ロット番号
      state.lotNo = event.value;
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-シリアル
    on<SetSerialNoEvent>((event, emit) async {
      // シリアル
      state.serialNo = event.value;
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-補足情報
    on<SetNoteEvent>((event, emit) async {
      // 補足情報
      state.supplementaryInformation = event.value;
      // 刷新补丁
      emit(clone(state));
    });

    on<QueryTableDetailsEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 检索详细信息
      // 检索table表dtb_product_location数据
      List<dynamic> productLocationData = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .select('*')
          .eq('location_id', event.value['location_id'])
          .eq('product_id', event.value['product_id']);
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('id', event.value['location_id'])
          .eq('del_kbn', '2');
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('id', event.value['product_id'])
          .eq('del_kbn', '2');
      if (productLocationData.length > 0) {
        state.goodsBarCode = event.value['receive_line_no'];
        state.goodsId = productData[0]['id'];
        state.goodsCode = productData[0]['code'];
        // 赋值-商品图片
        if (productData[0]['image1'] != '' &&
            productData[0]['image1'] != null &&
            !productData[0]['image1'].toString().contains('https')) {
          state.goodsImage1 =
              await WMSCommonFile().previewImageFile(productData[0]['image1']);
        }
        if (productData[0]['image2'] != '' &&
            productData[0]['image2'] != null &&
            !productData[0]['image2'].toString().contains('https')) {
          state.goodsImage2 =
              await WMSCommonFile().previewImageFile(productData[0]['image2']);
        }
        state.goodsName = productData[0]['name'];
        state.stock = event.value['check_num'];
        state.expirationDate = productLocationData[0]['limit_date'];
        state.lotNo = productLocationData[0]['lot_no'] != null
            ? productLocationData[0]['lot_no']
            : '';
        state.serialNo = productLocationData[0]['serial_no'] != null
            ? productLocationData[0]['serial_no']
            : '';
        state.supplementaryInformation = productLocationData[0]['note'] != null
            ? productLocationData[0]['note']
            : '';
        if (locationData.length > 0) {
          add(SetLocationInfoEvent('id', locationData[0]['id'].toString()));
          add(SetLocationInfoEvent('loc_cd', locationData[0]['loc_cd']));
        }
      } else {
        // 提示消息：获取商品信息失败。
        WMSCommonBlocUtils.tipTextToast('获取商品信息失败');
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 赵士淞 - 始
    // 打印事件
    on<TablePrinterEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询入荷予定明细
      List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .select('*')
          .eq('id', event.detailId);
      // 查询商品
      List<dynamic> productData = [];
      // 查询入荷予定
      List<dynamic> receiveData = [];
      // 查询商品入出荷位置
      List<dynamic> revShipLocationData = [];
      // 判断入荷予定明细数量
      if (receiveDetailData.length != 0) {
        // 查询商品
        productData = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('id', receiveDetailData[0]['product_id']);
        // 查询入荷予定
        receiveData = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('id', receiveDetailData[0]['receive_id']);
        // 查询商品入出荷位置
        revShipLocationData = await SupabaseUtils.getClient()
            .from('dtb_rev_ship_location')
            .select('*')
            .eq('rev_ship_line_no', receiveDetailData[0]['receive_line_no'])
            .eq('rev_ship_kbn', '1');
      }
      // 查询商品在庫位置
      List<dynamic> productLocationData = [];
      // 判断商品入出荷位置数量
      if (revShipLocationData.length != 0) {
        // 查询商品在庫位置
        productLocationData = await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .select('*')
            .eq('location_id', revShipLocationData[0]['product_location_id'])
            .eq('product_id', receiveDetailData[0]['product_id']);
      }
      // 判断商品在庫位置数量
      if (productData.length != 0 &&
          receiveData.length != 0 &&
          productLocationData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {
          'code': productData[0]['code'],
          'name': productData[0]['name_short'],
          'type': productData[0]['packing_type'],
          'company_name': receiveData[0]['name'],
          'limit_date': productLocationData[0]['limit_date'],
        };
        // 商品ラベル打印
        PrinterUtils.productInfoPrint(5, printData);
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.miss_param_unable_print);
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 打印事件
    on<FormPrinterEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询入荷予定明细
      List<dynamic> receiveDetailData = await SupabaseUtils.getClient()
          .from('dtb_receive_detail')
          .select('*')
          .eq('receive_line_no', state.goodsBarCode);
      // 查询商品
      List<dynamic> productData = [];
      // 判断入荷予定明细数量
      if (receiveDetailData.length != 0) {
        // 查询商品
        productData = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('id', receiveDetailData[0]['product_id']);
      }
      // 判断商品数量
      if (productData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {
          'code': productData[0]['code'],
          'no': state.incomingBarCode,
          'details_no': state.goodsBarCode,
          'name': productData[0]['name_short'],
          'type': productData[0]['packing_type'],
          'company_name': state.supplier,
          'limit_date': state.expirationDate.replaceAll('/', '-'),
        };
        // 商品ラベル打印
        PrinterUtils.productInfoPrint(5, printData);
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.miss_param_unable_print);
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 赵士淞 - 终

    add(InitEvent());
  }
}
