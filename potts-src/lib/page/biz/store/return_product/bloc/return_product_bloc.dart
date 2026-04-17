import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/product_location.dart';
import 'package:wms/model/return.dart';
import 'package:wms/model/store_history.dart';
import 'package:wms/page/biz/store/return_product/bloc/return_product_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../common/utils/check_utils.dart';
import '../../../../../common/utils/printer_utils.dart';

/**
 * content：返品入力-bloc
 * author：张博睿
 * date：2023/10/09
 */

abstract class ReturnProductEvent extends TableListEvent {}

class InitEvent extends ReturnProductEvent {
  // 初始化事件
  InitEvent();
}

class SetTabValueEvent extends ReturnProductEvent {
  int index;
  SetTabValueEvent(this.index);
}

// 获取売上商品名方法
class QuerySalesReturnProductInfoEvent extends ReturnProductEvent {
  String value;
  BuildContext context;
  QuerySalesReturnProductInfoEvent(this.value, this.context);
}

// 获取仕入商品名方法
class QueryReturnProductInfoEvent extends ReturnProductEvent {
  String value;
  BuildContext context;
  QueryReturnProductInfoEvent(this.value, this.context);
}

class ExecuteReturnProductEvent extends ReturnProductEvent {
  int flag;
  ExecuteReturnProductEvent(this.flag, BuildContext context);
}

class ClearFormEvent extends ReturnProductEvent {
  int flag;
  ClearFormEvent(this.flag);
}

// 赋值-出荷入荷指示番号
class SetRevShipNoEvent extends ReturnProductEvent {
  dynamic value;
  int flag;
  SetRevShipNoEvent(this.value, this.flag);
}

// 赋值-商品信息
class SetReturnProductInfoEvent extends ReturnProductEvent {
  String key;
  dynamic value;
  int flag;
  SetReturnProductInfoEvent(this.key, this.value, this.flag);
}

// 赋值-返品数量
class SetReturnQuantityEvent extends ReturnProductEvent {
  dynamic value;
  int flag;
  SetReturnQuantityEvent(this.value, this.flag);
}

// 赋值-位置信息
class SetReturnLocationInfoEvent extends ReturnProductEvent {
  String key;
  dynamic value;
  int flag;
  SetReturnLocationInfoEvent(this.key, this.value, this.flag);
}

// 赋值-位置信息（扫描）
class ReturnLocationInfoScanEvent extends ReturnProductEvent {
  dynamic value;
  BuildContext buildContext;
  int flag;
  ReturnLocationInfoScanEvent(this.value, this.buildContext, this.flag);
}

// 当前下标变更事件
class CurrentIndexChangeEvent extends ReturnProductEvent {
  // 内容
  int value;
  // 当前下标变更事件
  CurrentIndexChangeEvent(this.value);
}

// 赵士淞 - 始
// 打印事件
class PrinterEvent extends ReturnProductEvent {
  // 上下文
  BuildContext context;

  // 打印事件
  PrinterEvent(this.context);
}
// 赵士淞 - 终

class ReturnProductBloc extends WmsTableBloc<ReturnProductModel> {
  @override
  ReturnProductModel clone(ReturnProductModel src) {
    return ReturnProductModel.clone(src);
  }

// 执行-返品入力
  Future<bool> ExecuteReturnProductEvent(int flag, BuildContext context) async {
    String returnKbn = '';
    String revShipId = '';
    String revShipLineNo = '';
    String productId = '';
    String locationId = '';
    String returnNum = '';
    String revShipKbn = '';
    String storeKbn = '';
    if (flag == Config.NUMBER_ZERO) {
      returnKbn = Config.NUMBER_ONE.toString();
      revShipId = state.shipId;
      revShipLineNo = state.shipNumber;
      productId =
          state.salesProduct.id != null ? state.salesProduct.id.toString() : '';
      locationId = state.salesLocation.id != null
          ? state.salesLocation.id.toString()
          : '';
      returnNum = state.salesReturnQuantity;
      revShipKbn = Config.NUMBER_TWO.toString();
      storeKbn = Config.NUMBER_ONE.toString();
    } else {
      returnKbn = Config.NUMBER_TWO.toString();
      revShipId = state.receiveId;
      revShipLineNo = state.receiveNumber;
      productId = state.product.id != null ? state.product.id.toString() : '';
      locationId =
          state.location.id != null ? state.location.id.toString() : '';
      returnNum = state.returnQuantity;
      revShipKbn = Config.NUMBER_ONE.toString();
      storeKbn = Config.NUMBER_TWO.toString();
    }

    if (revShipId.isNotEmpty &&
        revShipLineNo.isNotEmpty &&
        productId.isNotEmpty &&
        locationId.isNotEmpty &&
        returnNum.isNotEmpty) {
      // 赵士淞 - 2023/11/27 始
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(returnNum)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.return_product_form_4 +
                WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
        return false;
      }
      // 赵士淞 - 2023/11/27 终

      // 打开加载状态
      BotToast.showLoading();
      // 返品表插入数据
      Return returnInfo = Return.empty();
      // 赋值-入荷予定ID/出荷指示ID
      returnInfo.rev_ship_id = int.tryParse(revShipId);
      // 赋值-入荷予定明細行No/出荷指示明細行No
      returnInfo.rev_ship_line_no = revShipLineNo;
      // 赋值-返品区分：1:売上返品 2:仕入返品
      returnInfo.return_kbn = returnKbn;
      // 赋值-商品Id
      returnInfo.product_id = int.tryParse(productId);
      // 赋值-位置Id
      returnInfo.location_id = int.tryParse(locationId);
      // 赋值-返品数量
      returnInfo.return_num = int.tryParse(returnNum);
      // 赋值-会社ID
      returnInfo.company_id = state.companyId;
      // 赋值-削除区分
      returnInfo.del_kbn = Config.NUMBER_TWO.toString();
      // 赋值-登録者
      returnInfo.create_id = state.userId;
      // 赋值-登録日時
      returnInfo.create_time = DateTime.now().toString();
      // 赋值-更新者
      returnInfo.update_id = state.userId;
      // 赋值-更新日時
      returnInfo.update_time = DateTime.now().toString();
      // 插入数据
      await SupabaseUtils.getClient()
          .from('dtb_return')
          .insert([returnInfo.toJson()]);

      String yearMonth = '';
      String storeId = '';
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month < 10
          ? DateTime.now().month.toString().padLeft(2, '0')
          : DateTime.now().month.toString();
      yearMonth = year + month;
      // 在库表检索数据
      List<dynamic> storeData = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', int.tryParse(productId))
          .eq('year_month', yearMonth)
          .eq('company_id', state.companyId);
      if (storeData.length > 0) {
        storeId = storeData[0]['id'].toString();
        await SupabaseUtils.getClient()
            .from('dtb_store')
            .update(
              {
                'stock': flag == Config.NUMBER_ZERO
                    ? storeData[0]['stock'] + int.tryParse(returnNum)
                    : storeData[0]['stock'] - int.tryParse(returnNum),
                'return_stock':
                    storeData[0]['return_stock'] + int.tryParse(returnNum),
                'update_id': state.userId,
                'update_time': DateTime.now().toString(),
              },
            )
            .eq('product_id', int.tryParse(productId))
            .eq('year_month', yearMonth)
            .eq('company_id', state.companyId);
      }

      // 商品在库位置表检索数据
      List<dynamic> productLocationData = await SupabaseUtils.getClient()
          .from('dtb_product_location')
          .select('*')
          .eq('product_id', int.tryParse(productId))
          .eq('location_id', int.tryParse(locationId));
      if (productLocationData.length > 0) {
        await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .update(
              {
                'stock': flag == Config.NUMBER_ZERO
                    ? productLocationData[0]['stock'] + int.tryParse(returnNum)
                    : productLocationData[0]['stock'] - int.tryParse(returnNum),
                'update_id': state.userId,
                'update_time': DateTime.now().toString(),
              },
            )
            .eq('product_id', int.tryParse(productId))
            .eq('location_id', int.tryParse(locationId));
      } else {
        ProductLocation productLocation = ProductLocation.empty();
        productLocation.location_id = flag == Config.NUMBER_ZERO
            ? state.salesLocation.id
            : state.location.id;
        productLocation.product_id = flag == Config.NUMBER_ZERO
            ? state.salesProduct.id
            : state.product.id;
        productLocation.stock_id = int.tryParse(storeId);
        productLocation.stock = flag == Config.NUMBER_ZERO
            ? int.tryParse(state.salesReturnQuantity)
            : int.tryParse(state.returnQuantity);
        productLocation.lock_stock = 0;
        productLocation.create_time = DateTime.now().toString();
        productLocation.create_id = state.userId;
        productLocation.update_time = DateTime.now().toString();
        productLocation.update_id = state.userId;
        // 插入数据
        await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .insert([productLocation.toJson()]);
      }

      // 受払明細表插入数据
      StoreHistory storeHistory = StoreHistory.empty();
      // 赋值-在库Id
      storeHistory.stock_id = int.tryParse(storeId);
      // 赋值-年月
      storeHistory.year_month = yearMonth;
      // 赋值-入/出荷明細行no
      storeHistory.rev_ship_line_no = revShipLineNo;
      // 赋值-入/出荷予定区分
      storeHistory.rev_ship_kbn = revShipKbn;
      // 赋值-商品Id
      storeHistory.product_id = int.tryParse(productId);
      // 赋值-入/出庫数
      storeHistory.num = int.tryParse(returnNum);
      // 赋值-入出庫区分
      storeHistory.store_kbn = storeKbn;
      // 赋值-ロケーションid
      storeHistory.location_id = int.tryParse(locationId);
      // 赋值-アクション区分
      storeHistory.action_id = Config.NUMBER_NINE;
      // 赋值-会社_ID
      storeHistory.company_id = state.companyId;
      // 赋值-登録者
      storeHistory.create_id = state.userId;
      // 赋值-登録日時
      storeHistory.create_time = DateTime.now().toString();
      // 插入数据
      await SupabaseUtils.getClient()
          .from('dtb_store_history')
          .insert([storeHistory.toJson()]);
      //插入操作履历 sys_log表
      var returnName = flag == Config.NUMBER_ZERO ? '売上返品' : '仕入返品';
      CommonUtils().createLogInfo(
          returnName +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "ExecuteReturnProductEvent()",
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(context).state.loginUser!.id);

      // 关闭加载
      BotToast.closeAllLoading();
      return true;
    } else {
      if (revShipLineNo.isEmpty) {
        WMSCommonBlocUtils.tipTextToast((flag == Config.NUMBER_ZERO
                ? WMSLocalizations.i18n(context)!.return_product_form_1
                : WMSLocalizations.i18n(context)!.return_product_form_2) +
            WMSLocalizations.i18n(context)!.can_not_null_text);
      } else if (productId.isEmpty) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.return_product_form_3 +
                WMSLocalizations.i18n(context)!.can_not_null_text);
      } else if (returnNum.isEmpty) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.return_product_form_4 +
                WMSLocalizations.i18n(context)!.can_not_null_text);
      } else if (locationId.isEmpty) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.return_product_form_5 +
                WMSLocalizations.i18n(context)!.can_not_null_text);
      }
      return false;
    }
  }

  ReturnProductBloc(ReturnProductModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 获取売上ロケーション集合
      List<dynamic> salesLocationInfo = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('company_id', state.companyId)
          .eq('del_kbn', Config.NUMBER_TWO);
      if (salesLocationInfo.length > 0) {
        state.salesLocationList = salesLocationInfo;
      }
      // 获取仕入ロケーション集合
      List<dynamic> returnLocationInfo = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('company_id', state.companyId)
          .eq('del_kbn', Config.NUMBER_TWO);
      if (returnLocationInfo.length > 0) {
        state.locationList = returnLocationInfo;
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QuerySalesReturnProductInfoEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      state.shipNumber = event.value;
      if (event.value.isNotEmpty) {
        if (CheckUtils.check_Half_Alphanumeric_Symbol(event.value)) {
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.return_product_form_1 +
                  WMSLocalizations.i18n(event.context)!
                      .check_half_width_alphanumeric_with_symbol);
          BotToast.closeAllLoading();
          return;
        }
        // 调用出荷指示表检索数据
        List<dynamic> salesShipInfo = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .eq('ship_no', event.value)
            .eq('ship_kbn', Config.NUMBER_SEVEN.toString())
            .eq('del_kbn', Config.NUMBER_TWO.toString());
        if (salesShipInfo.length > 0) {
          state.shipId = salesShipInfo[0]['id'].toString();
          List<dynamic> salesShipDetailInfo = await SupabaseUtils.getClient()
              .rpc('func_query_sales_return_product_info', params: {
            'ship_id': salesShipInfo[0]['id'],
            'del_kbn': Config.NUMBER_TWO.toString(),
          });
          if (salesShipDetailInfo.length > 0) {
            state.salesProductInfoList = salesShipDetailInfo;
          }
          // 引き続き返品品の選択をお願いします
          // WMSCommonBlocUtils.tipTextToast(
          //     WMSLocalizations.i18n(event.context)!.return_product_toast_1);
          state.salesFlag = true;
        } else {
          state.salesProductInfoList = [];
          state.salesReturnQuantity = '';
          add(SetReturnProductInfoEvent('id', '', Config.NUMBER_ZERO));
          add(SetReturnProductInfoEvent('name', '', Config.NUMBER_ZERO));
          add(SetReturnLocationInfoEvent('id', '', Config.NUMBER_ZERO));
          add(SetReturnLocationInfoEvent('loc_cd', '', Config.NUMBER_ZERO));
          // 入力された出荷指示番号が正しくありません
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.return_product_toast_2);
        }
      } else {
        // 消息提示-出荷指示番号未入力
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.return_product_form_1 +
                WMSLocalizations.i18n(event.context)!
                    .return_product_must_enter_toast);
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<QueryReturnProductInfoEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      state.receiveNumber = event.value;
      if (event.value.isNotEmpty) {
        if (CheckUtils.check_Half_Alphanumeric_Symbol(event.value)) {
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.return_product_form_2 +
                  WMSLocalizations.i18n(event.context)!
                      .check_half_width_alphanumeric_with_symbol);
          BotToast.closeAllLoading();
          return;
        }
        // 调用出荷指示表检索数据
        List<dynamic> receiveInfo = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('receive_no', event.value)
            .eq('receive_kbn', Config.NUMBER_FIVE.toString())
            .eq('del_kbn', Config.NUMBER_TWO.toString());
        if (receiveInfo.length > 0) {
          state.receiveId = receiveInfo[0]['id'].toString();
          List<dynamic> receiveDetailInfo = await SupabaseUtils.getClient()
              .rpc('func_query_return_product_info', params: {
            'receive_id': receiveInfo[0]['id'],
            'del_kbn': Config.NUMBER_TWO.toString(),
          });
          if (receiveDetailInfo.length > 0) {
            state.productInfoList = receiveDetailInfo;
          }
          // 引き続き返品品の選択をお願いします
          // WMSCommonBlocUtils.tipTextToast(
          //     WMSLocalizations.i18n(event.context)!.return_product_toast_1);
          state.deliverFlag = true;
        } else {
          state.productInfoList = [];
          state.returnQuantity = '';
          add(SetReturnProductInfoEvent('id', '', Config.NUMBER_ONE));
          add(SetReturnProductInfoEvent('name', '', Config.NUMBER_ONE));
          add(SetReturnLocationInfoEvent('id', '', Config.NUMBER_ONE));
          add(SetReturnLocationInfoEvent('loc_cd', '', Config.NUMBER_ONE));
          // 入力された入荷予定番号が正しくありません
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.return_product_toast_3);
        }
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.return_product_form_2 +
                WMSLocalizations.i18n(event.context)!
                    .return_product_must_enter_toast);
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<ClearFormEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (event.flag == Config.NUMBER_ZERO) {
        state.shipId = '';
        state.shipNumber = '';
        state.salesReturnQuantity = '';
        state.salesProductInfoList = const [];
        state.salesFlag = false;
      } else {
        state.receiveId = '';
        state.receiveNumber = '';
        state.returnQuantity = '';
        state.productInfoList = const [];
        state.deliverFlag = false;
      }
      add(SetReturnProductInfoEvent('id', '', event.flag));
      add(SetReturnProductInfoEvent('name', '', event.flag));
      add(SetReturnLocationInfoEvent('id', '', event.flag));
      add(SetReturnLocationInfoEvent('loc_cd', '', event.flag));
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 赋值-出荷入荷指示番号
    on<SetRevShipNoEvent>((event, emit) async {
      if (event.flag == Config.NUMBER_ZERO) {
        state.shipNumber = event.value;
      } else {
        state.receiveNumber = event.value;
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-出荷入荷指示番号
    on<SetReturnQuantityEvent>((event, emit) async {
      if (event.flag == Config.NUMBER_ZERO) {
        state.salesReturnQuantity = event.value;
      } else {
        state.returnQuantity = event.value;
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-商品信息
    on<SetReturnProductInfoEvent>((event, emit) async {
      if (event.flag == Config.NUMBER_ZERO) {
        state.salesProduct = event.key == 'id'
            ? state.salesProduct.set(event.key, int.tryParse(event.value))
            : state.salesProduct.set(event.key, event.value);
      } else {
        state.product = event.key == 'id'
            ? state.product.set(event.key, int.tryParse(event.value))
            : state.product.set(event.key, event.value);
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-位置信息
    on<SetReturnLocationInfoEvent>((event, emit) async {
      if (event.flag == Config.NUMBER_ZERO) {
        state.salesLocation = event.key == 'id'
            ? state.salesLocation.set(event.key, int.tryParse(event.value))
            : state.salesLocation.set(event.key, event.value);
      } else {
        state.location = event.key == 'id'
            ? state.location.set(event.key, int.tryParse(event.value))
            : state.location.set(event.key, event.value);
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 赋值-位置信息（扫描）
    on<ReturnLocationInfoScanEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 查询位置
      List<dynamic> locationInfo = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('loc_cd', event.value);
      // 判断位置长度
      if (locationInfo.length != 0) {
        // 判断标记
        if (event.flag == Config.NUMBER_ZERO) {
          state.salesLocation = state.salesLocation.set('loc_cd', event.value);
          state.salesLocation =
              state.salesLocation.set('id', locationInfo[0]['id']);
        } else {
          state.location = state.location.set('loc_cd', event.value);
          state.location = state.location.set('id', locationInfo[0]['id']);
        }
        // 刷新补丁
        emit(clone(state));
      } else {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.buildContext)!.return_product_toast_2);
      }
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 当前下标变更事件
    on<CurrentIndexChangeEvent>((event, emit) async {
      // 当前下标
      state.currentIndex = event.value;
      // 更新
      emit(clone(state));
    });

    // 赵士淞 - 始
    // 打印事件
    on<PrinterEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 判断当前下标
      if (state.currentIndex == Config.NUMBER_ZERO) {
        // 查询商品
        List<dynamic> productData = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('id', state.salesProduct.id);
        // 判断商品数量
        if (productData.length != 0) {
          // 打印数据
          Map<String, dynamic> printData = {
            'code': productData[0]['code'],
            'name': productData[0]['name_short'],
            'type': productData[0]['packing_type'],
            'no': state.shipNumber,
          };
          // 商品ラベル打印
          PrinterUtils.productInfoPrint(4, printData);
        } else {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.miss_param_unable_print);
        }
      } else if (state.currentIndex == Config.NUMBER_ONE) {
        // 查询商品
        List<dynamic> productData = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('id', state.product.id);
        // 判断商品数量
        if (productData.length != 0) {
          // 打印数据
          Map<String, dynamic> printData = {
            'code': productData[0]['code'],
            'name': productData[0]['name_short'],
            'number': state.returnQuantity,
            'type': productData[0]['packing_type'],
            'no': state.receiveNumber,
          };
          // 商品ラベル打印
          PrinterUtils.productInfoPrint(4, printData);
        } else {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.miss_param_unable_print);
        }
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 赵士淞 - 终

    // 加载初期化
    add(InitEvent());
  }
}
