import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/location.dart';
import 'package:wms/model/store_history.dart';

import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../common/utils/printer_utils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import 'shipment_inspection_model.dart';

/**
 * 内容：出荷検品 - bloc
 * 作者：王光顺
 * author：张博睿
 * 时间：2023/09/19
 */
abstract class ShipmentInspectionEvent extends TableListEvent {}

class InitEvent extends ShipmentInspectionEvent {
  // 初始化事件
  InitEvent();
}

class ClearInformationEvent extends ShipmentInspectionEvent {
  ClearInformationEvent();
}

class FlushDataEvent extends ShipmentInspectionEvent {
  List<dynamic> shipData;
  List<dynamic> detailData;
  int index;
  FlushDataEvent(this.shipData, this.detailData, this.index);
}

class SetLocationInfoEvent extends ShipmentInspectionEvent {
  String key;
  String value;
  String flag;
  SetLocationInfoEvent(this.key, this.value, this.flag);
}

class DesignationEvent extends ShipmentInspectionEvent {
  String ship;
  BuildContext context;
  DesignationEvent(this.ship, this.context);
}

class SetProductBarCodeEvent extends ShipmentInspectionEvent {
  String value;
  SetProductBarCodeEvent(this.value);
}

class SetNumCountEvent extends ShipmentInspectionEvent {
  String value;
  BuildContext context;
  SetNumCountEvent(this.value, this.context);
}

//完了
class QueryDetailsinformation extends ShipmentInspectionEvent {
  int id;
  int locationId;
  String shipNo;
  int inputlocationId;
  int companyId;
  int productId;
  QueryDetailsinformation(this.id, this.locationId, this.shipNo,
      this.inputlocationId, this.companyId, this.productId);
}

//更新字段
class updateLocationBarCode extends ShipmentInspectionEvent {
  int update;
  int id;
  updateLocationBarCode(this.update, this.id);
}

//index当前页面更新事件
class SetindexEvent extends ShipmentInspectionEvent {
  SetindexEvent();
}

// 获取位置ID（扫描用）
class GetLocationIdEvent extends ShipmentInspectionEvent {
  String locCd;
  GetLocationIdEvent(this.locCd);
}

// 赵士淞 - 始
// 标签打印
class PrinterEvent extends ShipmentInspectionEvent {
  // 上下文
  BuildContext context;

  // 标签打印
  PrinterEvent(this.context);
}

// 设置打印纳品书No
class SetPrintShipNoEvent extends ShipmentInspectionEvent {
  // 打印纳品书No
  String value;

  // 设置打印纳品书No
  SetPrintShipNoEvent(this.value);
}
// 赵士淞 - 终

class ShipmentInspectionBloc extends WmsTableBloc<ShipmentInspectionModel> {
  @override
  ShipmentInspectionModel clone(ShipmentInspectionModel src) {
    return ShipmentInspectionModel.clone(src);
  }

  Future<bool> QueryShipInformationEvent(
      String value, BuildContext context) async {
    // 打开加载状态
    BotToast.showLoading();
    bool flag = false;

    // 检索出荷数据
    List<dynamic> shipData = await SupabaseUtils.getClient()
        .from('dtb_ship')
        .select('*')
        .eq('ship_no', value)
        .eq('company_id', state.companyId)
        .eq('del_kbn', Config.NUMBER_TWO.toString());
    if (shipData.length == 0) {
      // 提示消息：获取商品信息失败。
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipment_inspection_toast_1);
    } else {
      if (shipData[0]['ship_kbn'] == Config.NUMBER_FOUR.toString()) {
        // 检索table表dtb_receive_detail数据
        List<dynamic> detailData = await SupabaseUtils.getClient()
            .rpc('func_query_table_dtb_ship_product', params: {
          'ship_no': value,
          'company_id': state.companyId,
        });
        if (detailData.length > 0) {
          add(FlushDataEvent(shipData, detailData, 0));
        }
        // 赵士淞 - 始
        // 设置打印纳品书No
        add(SetPrintShipNoEvent(value));
        // 赵士淞 - 终
      } else if (shipData[0]['ship_kbn'] == Config.NUMBER_FIVE.toString() ||
          shipData[0]['ship_kbn'] == Config.NUMBER_SIX.toString() ||
          shipData[0]['ship_kbn'] == Config.NUMBER_SEVEN.toString()) {
        // 赵士淞 - 始
        // 设置打印纳品书No
        add(SetPrintShipNoEvent(value));
        // 赵士淞 - 终
        flag = true;
      } else {
        // 提示消息：数据未到检品阶段
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.shipment_inspection_toast_2);
      }
    }

    BotToast.closeAllLoading();
    return flag;
  }

  Future<bool> CheckProductBarCodeEvent(String value) async {
    bool flag = false;
    if (state.shipmentNote.isNotEmpty) {
      // 赵士淞 - 始
      // 商品ID
      int productId = 0;
      // 查询商品
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('code', value)
          .eq('company_id', state.companyId)
          .eq('del_kbn', Config.NUMBER_TWO.toString());
      // 判断商品数量
      if (productData.length > 0) {
        // 商品ID
        productId = productData[0]['id'];
      }
      // 赵士淞 - 终
      List<dynamic> detailData = await SupabaseUtils.getClient()
          .from('dtb_ship_detail')
          .select('*')
          .eq('ship_id', int.parse(state.shipId))
          // 赵士淞 - 始
          .eq('product_id', productId)
          // 赵士淞 - 终
          .eq('del_kbn', Config.NUMBER_TWO.toString());
      if (detailData.length > 0) {
        add(SetProductBarCodeEvent(value));
        flag = true;
      }
    }
    return flag;
  }

  Future<int> executeEvent() async {
    int numKbn = 0;
    if (state.productformation.length == 0 || state.productformation.isEmpty) {
      // 【納品書バーコード】没有输入
      numKbn = 1;
    } else {
      if (state.shipKbn == Config.NUMBER_SIX ||
          state.shipKbn == Config.NUMBER_SEVEN) {
        // 【出荷状態】in【5:梱包待ち 6:出荷確定待ち 7:出荷済み】场合
        // 弹出【出荷検品完了】弹窗，只可进行【出荷ラベル】出力
        numKbn = 2;
      } else if (state.shipKbn == Config.NUMBER_ZERO ||
          state.shipKbn == Config.NUMBER_ONE ||
          state.shipKbn == Config.NUMBER_TWO ||
          state.shipKbn == Config.NUMBER_THREE) {
        // 提示【该数据还未到检品阶段】
        numKbn = 3;
      } else {
        if (state.productBarCode == '' || state.numCount == '') {
          if (state.productBarCode == '') {
            // 商品ラベルのバーコード为空
            numKbn = 4;
          }
          if (state.numCount == '') {
            // 合計数为空
            numKbn = 5;
          }
        } else {
          if (state.numCount != state.storeOutCount) {
            // 合計数】<>【出庫済数量】
            numKbn = 6;
          } else {
            if (state.checkKbn == Config.NUMBER_ONE.toString()) {
              // 【検品済】=【1:ON】的场合
              // 提示【该商品检品已完成，自动跳转下一条】
              numKbn = 7;
            } else if (state.checkKbn == Config.NUMBER_TWO.toString()) {
              // 【検品済】=【 2:OFF(default)】的场合
              int detailId = state.productformation[state.index - 1]['id'];
              await SupabaseUtils.getClient().from('dtb_ship_detail').update({
                'check_num': state.numCount,
                'check_kbn': Config.NUMBER_ONE.toString(),
                'update_id': state.userId,
                'update_time': DateTime.now().toString(),
              }).eq('id', detailId);
              numKbn = 8;
            }
          }
        }
      }
    }
    return numKbn;
  }

  Future<bool> SetNextMessageEvent() async {
    bool flag = false;
    if (state.index < state.pageNum) {
      add(FlushDataEvent(state.shipData, state.productformation, state.index));
      flag = true;
    }
    return flag;
  }

  Future<bool> executeEndEvent(BuildContext context) async {
    // 打开加载状态
    BotToast.showLoading();
    bool flag = false;
    if (state.oriconBarcode.id == null) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.shipment_inspection_oricon_barcode +
              WMSLocalizations.i18n(context)!.can_not_null_text);
    } else {
      // 更新表：【dtb_ship(出荷指示)】
      await SupabaseUtils.getClient().from('dtb_ship').update({
        'ship_kbn': Config.NUMBER_SIX.toString(),
        'update_time': DateTime.now().toString(),
        'update_id': state.userId,
      }).eq('id', state.shipId);
      for (int i = 0; i < state.productformation.length; i++) {
        // 更新表：【dtb_store_history(受払明細)】
        StoreHistory storeHistory = StoreHistory.empty();
        storeHistory.action_id = Config.NUMBER_FIVE;
        storeHistory.location_id = state.location.id;
        storeHistory.company_id = state.companyId;
        storeHistory.create_id = state.userId;
        storeHistory.create_time = DateTime.now().toString();
        // 插入数据
        await SupabaseUtils.getClient()
            .from('dtb_store_history')
            .insert([storeHistory.toJson()]).select('*');
        // 更新数据
        await SupabaseUtils.getClient().from('dtb_ship_detail').update({
          'location_id':
              state.oriconBarcode.id != null ? state.oriconBarcode.id : '',
          'update_id': state.userId,
          'update_time': DateTime.now().toString()
        }).eq('id', state.productformation[i]['id']);
        storeHistory.location_id =
            state.oriconBarcode.id != null ? state.oriconBarcode.id : null;
        storeHistory.create_time = DateTime.now().toString();
        // 插入数据
        await SupabaseUtils.getClient()
            .from('dtb_store_history')
            .insert([storeHistory.toJson()]).select('*');
        flag = true;

        //插入操作履历 sys_log表
        CommonUtils().createLogInfo(
            '出荷検品（NO：' +
                state.shipNo +
                '）' +
                Config.OPERATION_TEXT1 +
                Config.OPERATION_BUTTON_TEXT4 +
                Config.OPERATION_TEXT2,
            "updateTableDetails()",
            StoreProvider.of<WMSState>(context).state.loginUser!.company_id,
            StoreProvider.of<WMSState>(context).state.loginUser!.id);
      }
      // 消息提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(context)!.shipment_inspection_completion_title);
    }
    // 关闭加载状态
    BotToast.closeAllLoading();

    return flag;
  }

  //index当前页面更新事件
  ShipmentInspectionBloc(ShipmentInspectionModel state) : super(state) {
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      add(ClearInformationEvent());
    });

    // 清空表单
    on<ClearInformationEvent>((event, emit) async {
      // 纳品书code码
      state.shipmentNote = '';
      // 出荷指示番号
      state.shipNo = '';
      // 得意先
      state.customer = '';
      // 納入先
      state.delivery = '';
      // 商品code
      state.productCode = '';
      // 商品名
      state.productName = '';
      // 出库数
      state.storeOutCount = '';
      // 商品写真
      state.prpductImage1 = '';
      // 商品标签code
      state.productBarCode = '';
      // 合计数
      state.numCount = '';
      state.shipId = '';
      state.shipKbn = '';
      state.checkKbn = '';
      state.oriconBarcode = Location.empty();
      state.pageNum = 0;
      state.index = 0;
      add(SetLocationInfoEvent('id', '', Config.NUMBER_ONE.toString()));
      add(SetLocationInfoEvent('loc_cd', '', Config.NUMBER_ONE.toString()));
      // ship集合
      state.productformation = [];
      state.locationBarCodeList = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select()
          .eq('company_id', state.companyId)
          .eq('del_kbn', Config.NUMBER_TWO);
      // 更新
      emit(clone(state));
      // 关闭加载状态
      BotToast.closeAllLoading();
    });

    on<FlushDataEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      List<dynamic> temp = [];
      state.shipId = event.shipData[0]['id'].toString();
      state.shipData = event.shipData;
      state.pageNum = event.detailData.length;
      state.index = event.index + 1;
      for (var i = 0; i < event.detailData.length; i++) {
        temp.add(event.detailData[i]);
      }
      state.productformation = temp;
      state.shipmentNote = event.shipData[0]['ship_no'];
      // 出荷指示番号赋值
      state.shipNo = event.shipData[0]['ship_no'];
      // 得意先赋值
      state.customer = event.shipData[0]['customer_name'] != null
          ? event.shipData[0]['customer_name']
          : '';
      // 纳入先赋值
      state.delivery =
          event.shipData[0]['name'] != null ? event.shipData[0]['name'] : '';
      // 位置赋值
      add(SetLocationInfoEvent(
          'id',
          event.detailData[event.index]['location_id'].toString(),
          Config.NUMBER_ONE.toString()));
      add(SetLocationInfoEvent(
          'loc_cd',
          event.detailData[event.index]['location_code'],
          Config.NUMBER_ONE.toString()));
      // 商品名赋值
      state.productName = event.detailData[event.index]['product_name'] != null
          ? event.detailData[event.index]['product_name']
          : '';
      // 商品code赋值
      state.productCode = event.detailData[event.index]['code'] != null
          ? event.detailData[event.index]['code']
          : '';
      // 出库数赋值
      state.storeOutCount = event.detailData[event.index]['store_num'] != null
          ? event.detailData[event.index]['store_num'].toString()
          : '0';
      // 商品写真赋值
      if (event.detailData[event.index]['image1'] != '' &&
          event.detailData[event.index]['image1'] != null &&
          !event.detailData[event.index]['image1']
              .toString()
              .contains('https')) {
        state.prpductImage1 = await WMSCommonFile()
            .previewImageFile(event.detailData[event.index]['image1']);
      }
      state.checkKbn = event.detailData[event.index]['check_kbn'] != null
          ? event.detailData[event.index]['check_kbn']
          : '';
      if (event.detailData[event.index]['check_kbn'] ==
          Config.NUMBER_ONE.toString()) {
        // 第一个商品barCode赋值
        // 赵士淞 - 始
        state.productBarCode = event.detailData[event.index]['code'];
        // 赵士淞 - 终
        // 第一个合计数赋值
        state.numCount = event.detailData[event.index]['check_num'] != null
            ? event.detailData[event.index]['check_num'].toString()
            : '0';
      } else {
        // 第一个商品barCode赋值
        state.productBarCode = '';
        // 第一个合计数赋值
        state.numCount = '';
      }

      // 更新
      emit(clone(state));
      // 查询出荷指示明细事件
      // StoreProvider.of<WMSState>(context)
      //     .dispatch(RefreshCurrentParamAction(state));
      BotToast.closeAllLoading();
    });

    on<SetLocationInfoEvent>((event, emit) async {
      if (event.flag == Config.NUMBER_ONE.toString()) {
        // 位置赋值
        state.location = event.key == 'id'
            ? state.location.set(event.key, int.tryParse(event.value))
            : state.location.set(event.key, event.value);
      } else {
        state.oriconBarcode = event.key == 'id'
            ? state.oriconBarcode.set(event.key, int.tryParse(event.value))
            : state.oriconBarcode.set(event.key, event.value);
      }
      // 刷新补丁
      emit(clone(state));
    });

    on<SetProductBarCodeEvent>((event, emit) async {
      state.productBarCode = event.value;
      emit(clone(state));
    });

    on<SetNumCountEvent>((event, emit) async {
      if (!CheckUtils.check_Half_Number_In_10(event.value))
        state.numCount = event.value;
      else if (event.value == '') {
        state.numCount = event.value;
      } else {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.shipment_inspection_sum +
                WMSLocalizations.i18n(event.context)!
                    .check_half_width_numbers_in_10);
      }
      emit(clone(state));
    });

    // 获取位置ID（扫描用）
    on<GetLocationIdEvent>((event, emit) async {
      var locationBarCodeList = await SupabaseUtils.getClient()
          .from('mtb_location')
          .select()
          .eq('loc_cd', event.locCd);
      // 判断长度
      if (locationBarCodeList.length != 0) {
        // 位置赋值
        add(SetLocationInfoEvent('id', locationBarCodeList[0]['id'].toString(),
            Config.NUMBER_TWO.toString()));
      }
    });

    // 赵士淞 - 始
    // 标签打印
    on<PrinterEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询出荷指示
      List<dynamic> shipData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .eq('ship_no', state.printShipNo)
          .eq('company_id', state.companyId)
          .eq('del_kbn', Config.NUMBER_TWO.toString());
      // 查询会社
      List<dynamic> companyData = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('id', state.companyId);
      // 判断出荷指示+会社数量
      if (shipData.length != 0 && companyData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {
          'code': shipData[0]['delivery_no'],
          'no': 'オーダーNo：' + shipData[0]['order_no'],
          'date': shipData[0]['rcv_real_date'],
          'name1': shipData[0]['name'],
          'name2': shipData[0]['customer_name'],
          'company_name': companyData[0]['name'],
          'company_phone': companyData[0]['tel'],
        };
        // 出荷ラベル打印
        PrinterUtils.kaihoPrint(printData);
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.miss_param_unable_print);
      }

      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置打印纳品书No
    on<SetPrintShipNoEvent>((event, emit) async {
      // 打印纳品书No
      state.printShipNo = event.value;
      // 纳品书No
      state.shipmentNote = event.value;

      // 刷新补丁
      emit(clone(state));
    });
    // 赵士淞 - 终

    add(InitEvent());
  }
  // 入力check
  bool inputCheck(BuildContext context, String value, String flg) {
    // 納品書バーコード 半角英数記号 check
    if (value != '' && flg == '1') {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(value)) {
        WMSCommonBlocUtils.errorTextToast(WMSLocalizations.i18n(context)!
                .shipment_inspection_delivery_note_barcode +
            WMSLocalizations.i18n(context)!
                .check_half_width_alphanumeric_with_symbol);
        return false;
      }
    }
    // 商品ラベルのバーコード 半角英数記号 check
    if (value != '' && flg == '2') {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(value)) {
        WMSCommonBlocUtils.errorTextToast(WMSLocalizations.i18n(context)!
                .shipment_inspection_product_barcodes +
            WMSLocalizations.i18n(context)!
                .check_half_width_alphanumeric_with_symbol);
        return false;
      }
    }

    // 払出先オリコンのバーコード 半角英数記号 check
    if (value != '' && flg == '3') {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(value)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.shipment_inspection_oricon_barcode +
                WMSLocalizations.i18n(context)!
                    .check_half_width_alphanumeric_with_symbol);
        return false;
      }
    }

    return true;
  }
}
