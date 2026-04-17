// ignore_for_file: unnecessary_null_comparison

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/file/wms_common_file.dart';
import 'package:wms/model/store_history.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/printer_utils.dart';

/**
 * content：出庫入力-bloc
 * author：张博睿
 * date：2023/09/13
 */

abstract class ExitInputEvent extends TableListEvent {}

class InitEvent extends ExitInputEvent {
  // 初始化事件
  InitEvent();
}

class QueryLocationinformation extends ExitInputEvent {
  String code;
  BuildContext context;
  QueryLocationinformation(this.code, this.context);
}

class QueryDetailsinformation extends ExitInputEvent {
  String detailsCodeValue;
  BuildContext context;
  QueryDetailsinformation(this.context, this.detailsCodeValue);
}

class QueryLocationBarCode extends ExitInputEvent {
  String locationBarCode;
  BuildContext context;
  QueryLocationBarCode(this.context, this.locationBarCode);
}

class ClearInformation extends ExitInputEvent {
  ClearInformation();
}

class QueryTableDetails extends ExitInputEvent {
  String detailsCodeValue;
  BuildContext context;
  QueryTableDetails(this.context, this.detailsCodeValue);
}

class updateTableDetails extends ExitInputEvent {
  String allocationNumberValue;
  BuildContext context;
  int dtbPickListId;
  updateTableDetails(
      this.context, this.allocationNumberValue, this.dtbPickListId);
}

class QueryTableDetailShipKbn extends ExitInputEvent {
  dynamic value;
  BuildContext context;
  QueryTableDetailShipKbn(this.value, this.context);
}

class UpdateShipKbn extends ExitInputEvent {
  dynamic value;
  BuildContext context;
  UpdateShipKbn(this.value, this.context);
}

class UpdateShipDetail extends ExitInputEvent {
  dynamic value;
  BuildContext context;
  UpdateShipDetail(this.value, this.context);
}

class UpdatePickList extends ExitInputEvent {
  dynamic value;
  BuildContext context;
  UpdatePickList(this.value, this.context);
}

class SetShopBarcodeEvent extends ExitInputEvent {
  String value;
  String index;
  SetShopBarcodeEvent(this.value, this.index);
}

class SetBarCodeCountEvent extends ExitInputEvent {
  String value;
  BuildContext context;
  SetBarCodeCountEvent(this.value, this.context);
}

class SetProductCountEvent extends ExitInputEvent {
  String value;
  BuildContext context;
  SetProductCountEvent(this.value, this.context);
}

class SetLocationEvent extends ExitInputEvent {
  String value;
  BuildContext context;
  SetLocationEvent(this.value, this.context);
}

// 赵士淞 - 始
// 位置码事件（扫描用）
class LocationBarCodeEvent extends ExitInputEvent {
  // 上下文
  BuildContext context;
  // 值
  String value;

  // 位置码事件（扫描用）
  LocationBarCodeEvent(this.context, this.value);
}

// 商品码事件（扫描用）
class ProductBarCodeEvent extends ExitInputEvent {
  // 上下文
  BuildContext context;
  // 值
  String value;

  // 商品码事件（扫描用）
  ProductBarCodeEvent(this.context, this.value);
}

// 商铺码事件（扫描用）
class ShopBarCodeEvent extends ExitInputEvent {
  // 上下文
  BuildContext context;
  // 值
  String value;

  // 商铺码事件（扫描用）
  ShopBarCodeEvent(this.context, this.value);
}

// 打印事件
class PrinterEvent extends ExitInputEvent {
  // 上下文
  BuildContext context;
  // 选中下标
  int chooseIndex;

  // 打印事件
  PrinterEvent(this.context, this.chooseIndex);
}
// 赵士淞 - 始

class ExitInputBloc extends WmsTableBloc<ExitInputModel> {
  @override
  ExitInputModel clone(ExitInputModel src) {
    return ExitInputModel.clone(src);
  }

  ExitInputBloc(ExitInputModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // // 判断加载标记
      // if (state.loadingFlag) {
      //   // 打开加载状态
      //   BotToast.showLoading();
      // } else {
      //   // 页数
      //   state.pageNum = 0;
      //   // 加载标记
      //   state.loadingFlag = true;
      // }
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_dtb_pick_list', params: {
        'ship_id': state.shipId != 0 ? state.shipId : 0,
      }).range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询出荷总数
      List<dynamic> count = await SupabaseUtils.getClient()
          .rpc('func_query_total_dtb_pick_list', params: {
        'id': state.shipId != 0 ? state.shipId : 0,
      });
      // 总页数
      state.total = count[0]['total'];
      // 刷新补丁
      emit(clone(state));
    });

    on<InitEvent>((event, emit) async {
      if (state.shipId != 0) {
        // 打开加载状态
        BotToast.showLoading();
        // 调用出荷指示表检索数据
        List<dynamic> locationData = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .select('*')
            .in_("ship_kbn", ["2", "3"])
            .eq("del_kbn", "2")
            .eq("id", state.shipId);
        if (locationData.length > 0) {
          state.locationInformation = locationData;
          // 赋值-位置编码
          state.locationCodeValue = locationData[0]['ship_no'];
          // 赋值-出荷指示番号
          state.shipCodeValue = locationData[0]['ship_no'];
          // 赋值-得意先_名称
          state.customerValue = locationData[0]['customer_name'];
          // 赋值-納入先_名称
          state.deliveryValue = locationData[0]['name'];
          // 调用出荷指示表检索数据
          List<dynamic> pickListData = await SupabaseUtils.getClient()
              .from('dtb_pick_list')
              .select('*')
              .eq('ship_id', state.shipId)
              .eq("del_kbn", "2");
          if (pickListData.length > 0) {
            state.pickListData = pickListData;
          }
          add(PageQueryEvent());
        }
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // ピッキングリスト情報 获取
    on<QueryLocationinformation>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      try {
        if (event.code != '') {
          // 半角英数記号 check
          if (CheckUtils.check_Half_Alphanumeric_Symbol(event.code)) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.exit_input_form_title_1 +
                    WMSLocalizations.i18n(event.context)!
                        .check_half_width_alphanumeric_with_symbol);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          // 调用出荷指示表检索数据
          List<dynamic> locationData = await SupabaseUtils.getClient()
              .from('dtb_ship')
              .select('*')
              .in_("ship_kbn", ["2", "3"])
              .eq('company_id', state.companyId)
              .eq("del_kbn", "2")
              .eq("ship_no", event.code);
          if (locationData.length > 0) {
            state.locationInformation = locationData;
            // 赋值-ship_id
            state.shipId = locationData[0]['id'];
            // 赋值-位置编码
            state.locationCodeValue = locationData[0]['ship_no'];
            // 赋值-出荷指示番号
            state.shipCodeValue = locationData[0]['ship_no'];
            // 赋值-得意先_名称
            state.customerValue = locationData[0]['customer_name'];
            // 赋值-納入先_名称
            state.deliveryValue = locationData[0]['name'];
            // 调用出荷指示表检索数据
            List<dynamic> pickListData = await SupabaseUtils.getClient()
                .from('dtb_pick_list')
                .select('*')
                .eq('ship_id', locationData[0]['id'])
                .eq("del_kbn", "2");
            if (pickListData.length > 0) {
              state.pickListData = pickListData;
            }
            add(PageQueryEvent());
          } else {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_3);
            // 赋值-ship_id
            state.shipId = 0;
            // 赋值-位置编码
            state.locationCodeValue = '';
            // 赋值-出荷指示番号
            state.shipCodeValue = '';
            // 赋值-得意先_名称
            state.customerValue = '';
            // 赋值-納入先_名称
            state.deliveryValue = '';
          }
        } else {
          state.locationInformation = [];
          // 赋值-ship_id
          state.shipId = 0;
          // 赋值-位置编码
          state.locationCodeValue = '';
          // 赋值-出荷指示番号
          state.shipCodeValue = '';
          // 赋值-得意先_名称
          state.customerValue = '';
          // 赋值-納入先_名称
          state.deliveryValue = '';
        }
      } catch (e) {
        // 关闭加载
        BotToast.closeAllLoading();
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_3);
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询
    on<QueryDetailsinformation>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (event.detailsCodeValue != '') {
        // 半角英数記号 check
        if (CheckUtils.check_Half_Alphanumeric_Symbol(event.detailsCodeValue)) {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_form_title_5 +
                  WMSLocalizations.i18n(event.context)!
                      .check_half_width_alphanumeric_with_symbol);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        int index = state.pickListData.indexWhere((element) =>
            element['pick_line_no'].toString() == event.detailsCodeValue);
        if (index != -1) {
          if (state.pickListData[index]['store_kbn'] !=
              Config.NUMBER_ONE.toString()) {
            state.shipLineNo = state.pickListData[index]['ship_line_no'];
            List<dynamic> data = await SupabaseUtils.getClient()
                .rpc('func_query_details_dtb_pick_list', params: {
              'pick_line_no': event.detailsCodeValue,
              'ship_line_no': state.pickListData[index]['ship_line_no']
            });
            // 赋值- dtb_pick_list 主键
            state.dtbPickListId = data[0]['id'];
            // 赋值- 元 location ID
            state.fromLocationId = data[0]['loc_id_from'];
            // 赋值- 先 location ID
            state.toLocationId =
                data[0]['loc_id_to'] != null ? data[0]['loc_id_to'] : 0;
            // 赋值- 商品ID
            state.productId = data[0]['product_id'];
            // 赋值- 出荷明細行no
            state.shipLineNo = data[0]['ship_line_no'];
            // 赋值- 明細部のバーコード
            state.detailsCodeValue = data[0]['pick_line_no'];
            // 赋值- ロケーションコード
            state.detailLocationCode = data[0]['loc_cd_from'];
            // 赋值-商品コード
            state.productCodeValue = data[0]['code'];
            // 赋值-商品名
            state.productNameValue = data[0]['name'];
            // 赋值-引当数
            state.allocationNumberValue = data[0]['lock_num'];
            // 赋值-商品写真
            if (data[0]['image1'] != null && data[0]['image1'] != '') {
              state.productImage1 =
                  await WMSCommonFile().previewImageFile(data[0]['image1']);
            }
            if (data[0]['image2'] != null && data[0]['image2'] != '') {
              state.productImage2 =
                  await WMSCommonFile().previewImageFile(data[0]['image2']);
            }
          } else {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.exit_input_text_5);
          }
        } else {
          // 赋值- dtb_pick_list 主键
          state.dtbPickListId = 0;
          // 赋值- 元 location ID
          state.fromLocationId = 0;
          // 赋值- 先 location ID
          state.toLocationId = 0;
          // 赋值- 商品ID
          state.productId = 0;
          // 赋值- 出荷明細行no
          state.shipLineNo = '';
          // 赋值- 明細部のバーコード
          state.detailsCodeValue = '';
          // 赋值- ロケーションコード
          state.detailLocationCode = '';
          // 赋值-商品コード
          state.productCodeValue = '';
          // 赋值-商品名
          state.productNameValue = '';
          // 赋值-引当数
          state.allocationNumberValue = 0;
          // 赋值-商品写真
          state.productImage1 = '';
          state.productImage2 = '';
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_1);
        }
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    on<ClearInformation>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 出庫入力- 明細部のバーコード
      state.detailsCodeValue = '';
      // 出庫入力- ロケーションコード
      state.detailLocationCode = '';
      // 出庫入力- 商品コード
      state.productCodeValue = '';
      // 出庫入力- 商品名
      state.productNameValue = '';
      // 出庫入力- 引当数
      state.allocationNumberValue = 0;
      // 出庫入力- 商品写真
      state.productImage1 = '';
      // 出庫入力- 商品写真
      state.productImage2 = '';
      // 出庫入力- ロケーションのバーコード
      state.locationBarCode = '';
      // 出庫入力- 商品ラベルのバーコード
      state.productBarCode = '';
      // 出庫入力- 合计数
      state.productCount = 0;
      // 出庫入力- 购物车码
      state.shopBarcode = '';
      state.shipLineNo = '';

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询
    on<QueryTableDetails>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (event.detailsCodeValue != '') {
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_details_dtb_pick_list', params: {
          'pick_line_no': event.detailsCodeValue,
          'ship_line_no': state.shipLineNo != null && state.shipLineNo != ''
              ? state.shipLineNo
              : null,
        });

        if (data.length > 0) {
          // 赋值- dtb_pick_list 主键
          state.dtbPickListId = data[0]['id'];
          // 赋值- 元 location ID
          state.fromLocationId = data[0]['loc_id_from'];
          // 赋值- 先 location ID
          state.toLocationId =
              data[0]['loc_id_to'] != null ? data[0]['loc_id_to'] : 0;
          // 赋值- 商品ID
          state.productId = data[0]['product_id'];
          // 赋值- 出荷明細行no
          state.shipLineNo = data[0]['ship_line_no'];
          // 赋值- 明細部のバーコード
          state.detailsCodeValue = data[0]['pick_line_no'];
          // 赋值- ロケーションコード
          state.detailLocationCode = data[0]['loc_cd_from'];
          // 赋值-商品コード
          state.productCodeValue = data[0]['code'];
          // 赋值-商品名
          state.productNameValue = data[0]['name'];
          // 赋值-引当数
          state.allocationNumberValue = data[0]['lock_num'];
          // 赋值-商品写真
          if (data[0]['image1'] != null && data[0]['image1'] != '') {
            state.productImage1 =
                await WMSCommonFile().previewImageFile(data[0]['image1']);
          }
          if (data[0]['image2'] != null && data[0]['image2'] != '') {
            state.productImage2 =
                await WMSCommonFile().previewImageFile(data[0]['image2']);
          }
          // 赋值-ロケーションのバーコード
          state.locationBarCode = data[0]['loc_cd_from'];
          // 赋值-商品ラベルのバーコード
          state.productBarCode = data[0]['code'];
          // 赋值-合计数
          state.productCount = data[0]['lock_num'];
          // 赋值-购物车码
          state.shopBarcode = data[0]['loc_cd_to'];
        } else {
          // 消息提示
          // WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
          //         .exit_input_form_title_5 +
          //     WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_1);
        }
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询
    on<updateTableDetails>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (event.allocationNumberValue != '') {
        List<dynamic> data = [];
        try {
          // 查询“カゴ車またはオリコンのバーコード”对应的主键ID
          data = await SupabaseUtils.getClient()
              .from('mtb_location')
              .select('*')
              .eq("del_kbn", "2")
              .eq("loc_cd", event.allocationNumberValue);
          if (data.length > 0) {
            state.toLocationId = data[0]['id'];
          } else {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_7);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          // 查询商品在库位置信息
          List<dynamic> productLocationData = await SupabaseUtils.getClient()
              .from('dtb_product_location')
              .select('*')
              .eq('location_id', state.fromLocationId)
              .eq('product_id', state.productId);
          if (productLocationData.length > 0) {
            state.stockId = productLocationData[0]['stock_id'];
          }
          // 更新dtb_pick_list表，字段：先ロケーションid = “カゴ車またはオリコンのバーコード”，出庫済 = “1”
          await SupabaseUtils.getClient()
              .from('dtb_pick_list')
              .update({'to_location_id': data[0]['id'], 'store_kbn': '1'})
              .eq('id', event.dtbPickListId)
              .select('*');

          String year = DateTime.now().year.toString();
          String month = DateTime.now().month < 10
              ? DateTime.now().month.toString().padLeft(2, '0')
              : DateTime.now().month.toString();
          StoreHistory storeHistory = new StoreHistory.empty();
          // 赋值-自動採番キー
          storeHistory.id = null;
          // 赋值-在库ID
          storeHistory.stock_id = state.stockId != 0 ? state.stockId : null;
          // 赋值-出荷明細行no
          storeHistory.rev_ship_line_no = state.shipLineNo;
          // 赋值-入/出荷予定区分-----入荷：“1”，出荷：“2”
          storeHistory.rev_ship_kbn = '2';
          // 赋值-mtb_product表主键
          storeHistory.product_id =
              state.productId != 0 ? state.productId : null;
          //  赋值-出庫数
          storeHistory.num = state.productCount;
          //  赋值-入出庫区分-----入庫：“1”，出庫：“2”
          storeHistory.store_kbn = '2';
          // 赋值-ロケーションid
          storeHistory.location_id =
              state.fromLocationId != 0 ? state.fromLocationId : null;
          // 赋值-アクション区分 3：出庫入力
          storeHistory.action_id = 3;
          // 赋值-会社_ID
          storeHistory.company_id = StoreProvider.of<WMSState>(event.context)
              .state
              .loginUser
              ?.company_id;
          // 赋值-登録日時
          storeHistory.create_time = DateTime.now().toString();
          // 赋值-登録者
          storeHistory.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          // 年月
          storeHistory.year_month = year + month;

          // 新增出庫明細历史
          await SupabaseUtils.getClient()
              .from('dtb_store_history')
              .insert([storeHistory.toJson()]).select('*');
          //  赋值-入出庫区分-----入庫：“1”，出庫：“2”
          storeHistory.store_kbn = '1';
          // 赋值-ロケーションid
          storeHistory.location_id =
              state.toLocationId != 0 ? state.toLocationId : null;

          // 新增出庫明細历史
          await SupabaseUtils.getClient()
              .from('dtb_store_history')
              .insert([storeHistory.toJson()]).select('*');

          // 查询是否有未出库完成的数据
          List<dynamic> uncompletedPickList = await SupabaseUtils.getClient()
              .from('dtb_pick_list')
              .select('*')
              .eq('store_kbn', '2')
              .eq('del_kbn', '2')
              .eq('ship_id', state.shipId);

          if (uncompletedPickList.length > 0) {
            // 变更table表dtb_ship的出荷状態为“出庫中”
            await SupabaseUtils.getClient()
                .from('dtb_ship')
                .update({'ship_kbn': '3'})
                .eq('id', event.dtbPickListId)
                .select('*');
          } else {
            // 查询是否有未出库完成的数据
            List<dynamic> completedPickList = await SupabaseUtils.getClient()
                .from('dtb_pick_list')
                .select('*')
                .eq('store_kbn', '1')
                .eq('del_kbn', '2')
                .eq('ship_id', state.shipId);
            for (int i = 0; i < completedPickList.length; i++) {
              int count = completedPickList[i]['lock_num'];
              int tempLocationId = completedPickList[i]['to_location_id'];
              // 赵士淞 - 测试修复 2023/11/17 - 始
              String shipLineNo = completedPickList[i]['ship_line_no'];
              await SupabaseUtils.getClient()
                  .from('dtb_ship_detail')
                  .update({
                    'store_num': count,
                    'store_kbn': '1',
                    'location_id': tempLocationId != 0 ? tempLocationId : null
                  })
                  .eq('ship_id', state.shipId)
                  .eq('ship_line_no', shipLineNo)
                  .select('*');
              // 赵士淞 - 测试修复 2023/11/17 - 终
            }

            await SupabaseUtils.getClient()
                .from('dtb_ship')
                .update({'ship_kbn': '4'})
                .eq('id', state.shipId)
                .select('*');
            //插入操作履历 sys_log表
            CommonUtils().createLogInfo(
                '出庫入力（NO：' +
                    state.shipCodeValue +
                    '）' +
                    Config.OPERATION_TEXT1 +
                    Config.OPERATION_BUTTON_TEXT4 +
                    Config.OPERATION_TEXT2,
                "updateTableDetails()",
                StoreProvider.of<WMSState>(event.context)
                    .state
                    .loginUser!
                    .company_id,
                StoreProvider.of<WMSState>(event.context).state.loginUser!.id);
          }
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_text_2);
        } catch (e) {
          // 关闭加载
          BotToast.closeAllLoading();
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_text_3);
          return;
        }
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
      add(ClearInformation());
      add(PageQueryEvent());
    });

    on<QueryTableDetailShipKbn>((event, emit) async {
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .not("ship_kbn", "eq", "5")
          .not("ship_kbn", "eq", "6")
          .not("ship_kbn", "eq", "7")
          .eq("del_kbn", "2")
          .eq("id", event.value['ship_id']);
      if (locationData.length > 0) {
        // 打开加载状态
        BotToast.showLoading();
        add(UpdateShipKbn(event.value, event.context));
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_text_4);
      }
    });

    on<UpdateShipKbn>((event, emit) async {
      try {
        // 调用出荷指示表检索数据
        List<dynamic> list = await SupabaseUtils.getClient()
            .from('dtb_ship')
            .update({'ship_kbn': '3'})
            .eq("id", event.value['ship_id'])
            .select('*');
        if (list.length > 0) {
          add(UpdateShipDetail(event.value, event.context));
        } else {
          BotToast.closeAllLoading();
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          return;
        }
      } catch (e) {
        BotToast.closeAllLoading();
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                WMSLocalizations.i18n(event.context)!.delete_error);
        return;
      }
    });

    // 更新出荷指示明細表数据
    on<UpdateShipDetail>((event, emit) async {
      try {
        // 调用出荷指示表检索数据
        List<dynamic> list = await SupabaseUtils.getClient()
            .from('dtb_ship_detail')
            .update({'store_kbn': '2', 'location_id': null, 'store_num': null})
            .eq("ship_id", event.value['ship_id'])
            .eq("product_id", event.value['product_id'])
            .select('*');
        if (list.length > 0) {
          add(UpdatePickList(event.value, event.context));
        } else {
          BotToast.closeAllLoading();
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          return;
        }
      } catch (e) {
        BotToast.closeAllLoading();
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                WMSLocalizations.i18n(event.context)!.delete_error);
        return;
      }
    });

    on<SetShopBarcodeEvent>((event, emit) {
      if (event.index == '1') {
        state.locationBarCode = event.value;
      } else if (event.index == '2') {
        state.productBarCode = event.value;
      } else if (event.index == '3') {
        state.productCount = int.tryParse(event.value)!;
      } else if (event.index == '4') {
        state.shopBarcode = event.value;
      }

      // 刷新补丁
      emit(clone(state));
    });

    on<SetBarCodeCountEvent>((event, emit) {
      state.productBarCode = event.value;
      //半角英数記号
      if (CheckUtils.check_Half_Alphanumeric_Symbol(event.value)) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_form_title_12 +
                WMSLocalizations.i18n(event.context)!
                    .check_half_width_alphanumeric_with_symbol);
      } else if (state.locationBarCode == state.detailLocationCode &&
          state.locationBarCode != '') {
        if (state.productBarCode != state.productCodeValue ||
            state.productBarCode == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_6);
        } else {
          if (state.productCount < state.allocationNumberValue) {
            state.productCount = state.productCount + 1;
          } else {
            state.productCount = state.allocationNumberValue;
          }
        }
      }
      // 刷新补丁
      emit(clone(state));
    });

    on<SetProductCountEvent>((event, emit) {
      // 半角数字 9位
      if (CheckUtils.check_Half_Number_In_10(event.value)) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_form_title_13 +
                WMSLocalizations.i18n(event.context)!
                    .check_half_width_numbers_in_10);
      } else if (state.locationBarCode == state.detailLocationCode &&
          state.productBarCode == state.productCodeValue) {
        state.productCount = int.parse(event.value);
        if (state.productCount < 0) {
          state.productCount = 0;
        }
        if (state.productCount > state.allocationNumberValue) {
          state.productCount = state.allocationNumberValue;
        }
      } else {
        if (state.productBarCode != state.productCodeValue ||
            state.productBarCode == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_6);
        }
        if (state.locationBarCode != state.detailLocationCode ||
            state.locationBarCode == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_5);
        }
      }
      // 刷新补丁
      emit(clone(state));
    });

    on<SetLocationEvent>((event, emit) {
      state.locationBarCode = event.value.toString();
      // 半角英数記号
      if (CheckUtils.check_Half_Alphanumeric_Symbol(event.value.toString())) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_form_title_11 +
                WMSLocalizations.i18n(event.context)!
                    .check_half_width_alphanumeric_with_symbol);
      } else if (state.locationBarCode != state.detailLocationCode) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_5);
      }
      // 刷新补丁
      emit(clone(state));
    });

    // 更新出荷指示明細表数据
    on<UpdatePickList>((event, emit) async {
      try {
        List<dynamic> dplList = await SupabaseUtils.getClient()
            .from('dtb_pick_list')
            .select('*')
            .eq("id", event.value['id']);
        StoreHistory storeHistory = StoreHistory.empty();
        String year = DateTime.now().year.toString();
        String month = DateTime.now().month < 10
            ? DateTime.now().month.toString().padLeft(2, '0')
            : DateTime.now().month.toString();
        if (dplList.length > 0) {
          storeHistory.year_month = year + month;
          storeHistory.rev_ship_line_no = dplList[0]['ship_line_no'];
          storeHistory.rev_ship_kbn = Config.NUMBER_TWO.toString();
          storeHistory.product_id = dplList[0]['product_id'];
          storeHistory.num = dplList[0]['lock_num'];
          storeHistory.store_kbn = Config.NUMBER_TWO.toString();
          storeHistory.location_id = dplList[0]['to_location_id'];
          storeHistory.action_id = Config.NUMBER_THREE;
          storeHistory.company_id = state.companyId;
          storeHistory.create_id = state.userId;
          storeHistory.create_time = DateTime.now().toString();

          // 新增出庫明細历史
          await SupabaseUtils.getClient()
              .from('dtb_store_history')
              .insert([storeHistory.toJson()]);
        }
        // 调用出荷指示表检索数据
        List<dynamic> list = await SupabaseUtils.getClient()
            .from('dtb_pick_list')
            .update({'store_kbn': '2', 'to_location_id': null})
            .eq("id", event.value['id'])
            .select('*');
        if (list.length > 0) {
          List<dynamic> dsList = await SupabaseUtils.getClient()
              .from('dtb_store')
              .select('*')
              .eq('year_month', year + month)
              .eq('product_id', dplList[0]['product_id']);
          if (dsList.length > 0) {
            storeHistory.stock_id = dsList[0]['id'];
          }
          storeHistory.store_kbn = Config.NUMBER_ONE.toString();
          storeHistory.location_id = dplList[0]['from_location_id'];
          storeHistory.action_id = Config.NUMBER_THREE;
          storeHistory.company_id = state.companyId;
          storeHistory.create_id = state.userId;
          storeHistory.create_time = DateTime.now().toString();
          // 新增出庫明細历史
          await SupabaseUtils.getClient()
              .from('dtb_store_history')
              .insert([storeHistory.toJson()]);
          add(PageQueryEvent());
          // 刷新补丁
          emit(clone(state));
          // 关闭加载
          BotToast.closeAllLoading();
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } else {
          // 关闭加载
          BotToast.closeAllLoading();
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          return;
        }
      } catch (e) {
        // 关闭加载
        BotToast.closeAllLoading();
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.menu_content_3_8 +
                WMSLocalizations.i18n(event.context)!.delete_error);
        return;
      }
    });

    // 赵士淞 - 始
    // 位置码事件（扫描用）
    on<LocationBarCodeEvent>((event, emit) async {
      // 赋值
      state.locationBarCode = event.value.toString();
      // 判断
      if (state.locationBarCode != state.detailLocationCode) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_5);
      }

      // 刷新补丁
      emit(clone(state));
    });

    // 商品码事件（扫描用）
    on<ProductBarCodeEvent>((event, emit) async {
      // 赋值
      state.productBarCode = event.value.toString();
      // 判断
      if (state.locationBarCode == state.detailLocationCode &&
          state.locationBarCode != '') {
        if (state.productBarCode != state.productCodeValue ||
            state.productBarCode == '') {
          // 消息提示
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.exit_input_form_Toast_6);
        } else {
          if (state.productCount < state.allocationNumberValue) {
            state.productCount = state.productCount + 1;
          } else {
            state.productCount = state.allocationNumberValue;
          }
        }
      }

      // 刷新补丁
      emit(clone(state));
    });

    // 商铺码事件（扫描用）
    on<ShopBarCodeEvent>((event, emit) async {
      // 赋值
      state.shopBarcode = event.value.toString();

      // 刷新补丁
      emit(clone(state));
    });

    // 打印事件
    on<PrinterEvent>((event, emit) async {
      // 判断选中下标
      if (event.chooseIndex == Config.NUMBER_NEGATIVE) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 查询商品
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('id', state.productId);
      // 查询在库
      List<dynamic> storeData = await SupabaseUtils.getClient()
          .from('dtb_store')
          .select('*')
          .eq('product_id', state.productId)
          .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()));
      // 查询位置
      List<dynamic> locationData = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select('*')
          .eq('loc_cd', state.locationBarCode)
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(event.context)
                  .state
                  .loginUser
                  ?.company_id);
      // 查询商品位置
      List<dynamic> productLocationData = [];
      // 判断查询数据长度
      if (storeData.length != 0 && locationData.length != 0) {
        // 查询商品位置
        productLocationData = await SupabaseUtils.getClient()
            .from('dtb_product_location')
            .select('*')
            .eq('location_id', locationData[0]['id'])
            .eq('stock_id', storeData[0]['id'])
            .eq('product_id', state.productId);
      }

      // 判断查询数据长度
      if (productData.length != 0 && productLocationData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {};
        // 判断选中下标
        if (event.chooseIndex == Config.NUMBER_ZERO) {
          // 打印数据
          printData = {
            'code': productData[0]['code'],
            'name': productData[0]['name_short'],
            'type': productData[0]['packing_type'],
            'company_name': state.customerValue + ' / ' + state.deliveryValue,
            'limit_date': productLocationData[0]['limit_date'],
          };
        } else if (event.chooseIndex == Config.NUMBER_ONE) {
          // 打印数据
          printData = {
            'code': productData[0]['code'],
            'name': productData[0]['name_short'],
            'number': state.productCount.toString(),
            'type': productData[0]['packing_type'],
            'no': state.locationCodeValue,
            'details_no': state.detailsCodeValue,
            'company_name': state.customerValue + ' / ' + state.deliveryValue,
            'limit_date': productLocationData[0]['limit_date'],
          };
        }
        // 商品ラベル打印
        PrinterUtils.productInfoPrint(2, printData);
        // 关闭弹窗
        Navigator.pop(event.context);
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

  read() {}
}
