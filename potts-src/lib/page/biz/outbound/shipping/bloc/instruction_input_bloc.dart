import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wms/common/utils/check_utils.dart';

import '../../../../../bloc/wms_common_bloc.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../model/ship.dart';
import '../../../../../model/ship_detail.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'instruction_input_model.dart';

/**
 * 内容：出荷指示入力-BLOC
 * 作者：赵士淞
 * 时间：2023/09/04
 */
// 事件
abstract class InstructionInputEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InstructionInputEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定出荷指示值事件
class SetShipValueEvent extends InstructionInputEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipValueEvent(this.key, this.value);
}

// 设定出荷指示集合事件
class SetShipMapEvent extends InstructionInputEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定集合事件
  SetShipMapEvent(this.valueMap);
}

// 保存出荷指示表单事件
class SaveShipFormEvent extends InstructionInputEvent {
  // 出荷指示-结构
  Map<String, dynamic> shipStructure = {};
  // 保存出荷指示表单事件
  SaveShipFormEvent(this.shipStructure);
}

// 查询出荷指示明细事件
class QueryShipDetailEvent extends InstructionInputEvent {
  // 出荷指示明细ID
  int shipDetailId;
  // 查询出荷指示明细事件
  QueryShipDetailEvent(this.shipDetailId);
}

// 设定出荷指示明细值事件
class SetShipDetailValueEvent extends InstructionInputEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipDetailValueEvent(this.key, this.value);
}

// 设定出荷指示明细集合事件
class SetShipDetailMapEvent extends InstructionInputEvent {
  // 值集合
  Map<String, dynamic> valueMap;
  // 设定值事件
  SetShipDetailMapEvent(this.valueMap);
}

// 保存出荷指示明细表单事件
class SaveShipDetailFormEvent extends InstructionInputEvent {
  // 结构树
  BuildContext context;
  // 出荷指示明细-结构
  Map<String, dynamic> shipDetailStructure = {};
  // 保存出荷指示明细表单事件
  SaveShipDetailFormEvent(this.context, this.shipDetailStructure);
}

// 删除出荷指示明细事件
class DeleteShipDetailEvent extends InstructionInputEvent {
  // 出荷指示明细ID
  int shipDetailId;
  // 删除出荷指示明细事件
  DeleteShipDetailEvent(this.shipDetailId);
}

// 导入CSV文件事件
class ImportCSVFileEvent extends InstructionInputEvent {
  // 内容
  List<List<Map<String, dynamic>>> content;
  // 导入CSV文件事件
  ImportCSVFileEvent(this.content);
}

// 当前下标变更事件
class CurrentIndexChangeEvent extends InstructionInputEvent {
  // 内容
  int value;
  // 当前下标变更事件
  CurrentIndexChangeEvent(this.value);
}
// 自定义事件 - 终

class InstructionInputBloc extends WmsTableBloc<InstructionInputModel> {
  // 刷新补丁
  @override
  InstructionInputModel clone(InstructionInputModel src) {
    return InstructionInputModel.clone(src);
  }

  // 查询出荷指示明细事件
  bool queryShipDetailEvent(int shipDetailId) {
    // 判断出荷指示-定制ID
    if (state.shipCustomize['id'] == null || state.shipCustomize['id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.reserve_input_19);
      return false;
    } else {
      // 引当济的数据不能追加明细和修改明细
      if (shipDetailId == 0 &&
          state.shipCustomize['ship_kbn'] != '0' &&
          state.shipCustomize['ship_kbn'] != '1') {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!.display_instruction_tip3);
        return false;
      }

      // 查询出荷指示明细事件
      add(QueryShipDetailEvent(shipDetailId));
      return true;
    }
  }

  InstructionInputBloc(InstructionInputModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
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

      // 查询出荷指示
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_dtb_ship_detail',
              params: {'ship_id': state.shipId, 'del_kbn': Config.DELETE_NO})
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询出荷总数
      List<dynamic> count = await SupabaseUtils.getClient().rpc(
          'func_zhaoss_query_total_dtb_ship_detail',
          params: {'ship_id': state.shipId, 'del_kbn': Config.DELETE_NO});
      // 总页数
      state.total = count[0]['total'];

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      // 查询客户
      List<dynamic> customerData = await SupabaseUtils.getClient()
          .from('mtb_customer')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO)
          .gte('application_end_date',
              DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .lte('application_start_date',
              DateFormat('yyyy-MM-dd').format(DateTime.now()));
      // 客户列表
      state.customerList = customerData;

      // 查询收件人
      List<dynamic> customerAddressData = await SupabaseUtils.getClient()
          .from('mtb_customer_address')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO);
      // 收件人列表
      state.customerAddressList = customerAddressData;

      // 查询出荷指示
      List<dynamic> shipData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .eq('del_kbn', Config.DELETE_NO)
          .eq('id', state.shipId);
      // 判断出荷指示数量
      if (shipData.length != 0) {
        // 出荷指示-定制
        state.shipCustomize = shipData[0];
      } else {
        // 出荷指示-定制
        state.shipCustomize = {
          'id': '',
          'ship_no': '',
          'order_no': '',
          'rcv_sch_date': '',
          'cus_rev_date': '',
          'ship_kbn': '',
          'customer_id': '',
          'customer_name': '',
          'customer_name_kana': '',
          'customer_postal_cd': '',
          'customer_addr_1': '',
          'customer_addr_2': '',
          'customer_addr_3': '',
          'customer_tel': '',
          'customer_fax': '',
          'customer_addr_id': '',
          'same_kbn': '0',
          'name': '',
          'name_kana': '',
          'postal_cd': '',
          'addr_1': '',
          'addr_2': '',
          'addr_3': '',
          'addr_tel': '',
          'fax': '',
          'person': '',
          'note1': '',
          'note2': ''
        };
      }

      // 查询仓库事件
      List<dynamic> warehouseData = await SupabaseUtils.getClient()
          .from('mtb_warehouse')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id);
      // 仓库列表
      state.warehouseList = warehouseData;

      // 查询商品事件
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('del_kbn', Config.DELETE_NO)
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO);
      // 商品列表
      state.productList = productData;
      // 自定义事件 - 终

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 设定出荷指示值事件
    on<SetShipValueEvent>((event, emit) async {
      // 出荷指示-临时
      Map<String, dynamic> shipTemp = Map<String, dynamic>();
      shipTemp.addAll(state.shipCustomize);
      // 判断key
      if (shipTemp[event.key] != null) {
        // 出荷指示-临时
        shipTemp[event.key] = event.value;
      } else {
        // 出荷指示-临时
        shipTemp.addAll({event.key: event.value});
      }
      // 出荷指示-定制
      state.shipCustomize = shipTemp;

      // 更新
      emit(clone(state));
    });

    // 设定出荷指示集合事件
    on<SetShipMapEvent>((event, emit) async {
      // 出荷指示-临时
      Map<String, dynamic> shipTemp = Map<String, dynamic>();
      shipTemp.addAll(state.shipCustomize);
      // 循环值集合
      event.valueMap.forEach((key, value) {
        // 判断key
        if (shipTemp[key] != null) {
          // 出荷指示-临时
          shipTemp[key] = value;
        } else {
          // 出荷指示-临时
          shipTemp.addAll({key: value});
        }
      });
      // 出荷指示-定制
      state.shipCustomize = shipTemp;

      // 更新
      emit(clone(state));
    });

    // 保存出荷指示表单事件
    on<SaveShipFormEvent>((event, emit) async {
      // 保存出荷指示表单验证
      Map<String, dynamic> shipStructure =
          saveShipFormCheck(event.shipStructure);
      // 判断验证结果
      if (shipStructure.length == 0) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 出荷指示数据
      List<Map<String, dynamic>> shipData;
      // 納入先は得意先と同一 数据设置
      if (shipStructure['same_kbn'] == Config.WMS_COMPANY_FORCED_1) {
        // 设置納入先ID为null
        shipStructure['customer_addr_id'] = null;
        // 納入先_名称<----得意先_名称
        shipStructure['name'] = shipStructure['customer_name'];
        // 納入先_カナ名称<----得意先_カナ名称
        shipStructure['name_kana'] = shipStructure['customer_name_kana'];
        // 納入先_郵便番号<----得意先_郵便番号
        shipStructure['postal_cd'] = shipStructure['customer_postal_cd'];
        // 納入先_住所１<----得意先_住所１
        shipStructure['addr_1'] = shipStructure['customer_addr_1'];
        // 納入先_住所２<----得意先_住所２
        shipStructure['addr_2'] = shipStructure['customer_addr_2'];
        // 納入先_住所３<----得意先_住所３
        shipStructure['addr_3'] = shipStructure['customer_addr_3'];
        // 納入先_電話番号<----得意先_電話番号
        shipStructure['addr_tel'] = shipStructure['customer_tel'];
        // 納入先_FAX番号<----得意先_FAX番号
        shipStructure['fax'] = shipStructure['customer_fax'];
      }
      // 出荷指示
      Ship ship = Ship.fromJson(shipStructure);

      // 判断出荷指示ID
      if (ship.id == null) {
        // 创建出荷指示表单处理
        ship = await createShipFormHandle(ship);
        // 判断处理结果
        if (ship.create_id == null || ship.create_id == '') {
          return;
        }
        try {
          // 新增出荷指示
          shipData = await SupabaseUtils.getClient()
              .from('dtb_ship')
              .insert([ship.toJson()]).select('*');
          // 判断出荷指示数据
          if (shipData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_title_10 +
                    WMSLocalizations.i18n(state.rootContext)!.create_success);
            //插入操作履历 sys_log表
            CommonUtils().createLogInfo(
                '出荷指示入力（NO：' +
                    ship.ship_no.toString() +
                    '）' +
                    Config.OPERATION_TEXT1 +
                    Config.OPERATION_BUTTON_TEXT1 +
                    Config.OPERATION_TEXT2,
                "SaveShipFormEvent()",
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .company_id,
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .id);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_title_10 +
                    WMSLocalizations.i18n(state.rootContext)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_title_10 +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        // 更新出荷指示表单处理
        ship = updateShipFormHandle(ship);
        // 判断处理结果
        if (ship.update_id == null || ship.update_id == '') {
          return;
        }
        try {
          // 修改出荷指示
          shipData = await SupabaseUtils.getClient()
              .from('dtb_ship')
              .update(ship.toJson())
              .eq('id', ship.id)
              .select('*');
          // 判断出荷指示数据
          if (shipData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_title_10 +
                    WMSLocalizations.i18n(state.rootContext)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_title_10 +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_title_10 +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      // 出荷指示-定制
      state.shipCustomize = shipData[0];
      // 出荷指示-定制ID
      state.shipId = state.shipCustomize['id']!;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 查询出荷指示明细事件
    on<QueryShipDetailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询出荷指示明细
      List<dynamic> shipDetailData = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_item_dtb_ship_detail', params: {
        'id': event.shipDetailId,
        'del_kbn': Config.DELETE_NO
      }).select('*');
      // 判断出荷指示明细数量
      if (shipDetailData.length != 0) {
        // 出荷指示明细-定制
        state.shipDetailCustomize = shipDetailData[0];
        // 判断商品写真1
        if (shipDetailData[0]['product_image1'] != null &&
            shipDetailData[0]['product_image1'] != '') {
          // 出荷指示明细-定制
          state.shipDetailCustomize['product_image1'] = await WMSCommonFile()
              .previewImageFile(shipDetailData[0]['product_image1']);
        }
        // 判断商品写真2
        if (shipDetailData[0]['product_image2'] != null &&
            shipDetailData[0]['product_image2'] != '') {
          // 出荷指示明细-定制
          state.shipDetailCustomize['product_image2'] = await WMSCommonFile()
              .previewImageFile(shipDetailData[0]['product_image2']);
        }
      } else {
        // 出荷指示明细-定制
        state.shipDetailCustomize = {
          'id': '',
          'ship_id': '',
          // 'warehouse_no': '',
          // 'warehouse_name': '',
          'product_id': '',
          'product_code': '',
          'product_name': '',
          'product_price': '',
          'ship_num': '',
          'product_size': '',
          'note1': '',
          'note2': '',
          'product_image1': '',
          'product_image2': '',
          'product_company_note1': '',
          'product_company_note2': '',
          'product_notice_note1': '',
          'product_notice_note2': ''
        };
      }

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定出荷指示明细值事件
    on<SetShipDetailValueEvent>((event, emit) async {
      // 出荷指示明细-临时
      Map<String, dynamic> shipDetailTemp = Map<String, dynamic>();
      shipDetailTemp.addAll(state.shipDetailCustomize);
      // 判断key
      if (shipDetailTemp[event.key] != null) {
        // 出荷指示明细-临时
        shipDetailTemp[event.key] = event.value;
      } else {
        // 出荷指示明细-临时
        shipDetailTemp.addAll({event.key: event.value});
      }
      // 出荷指示明细-定制
      state.shipDetailCustomize = shipDetailTemp;

      // 更新
      emit(clone(state));
    });

    // 设定出荷指示明细集合事件
    on<SetShipDetailMapEvent>((event, emit) async {
      // 出荷指示明细-临时
      Map<String, dynamic> shipDetailTemp = Map<String, dynamic>();
      shipDetailTemp.addAll(state.shipDetailCustomize);
      // 主键列表
      List keyList = event.valueMap.keys.toList();
      // 循环值集合
      for (int i = 0; i < keyList.length; i++) {
        // 主键
        String key = keyList[i];
        // 值
        dynamic value = event.valueMap[key];
        // 判断商品写真1
        if (key == 'product_image1' && value != null && value != '') {
          // 出荷指示明细-定制
          value = await WMSCommonFile().previewImageFile(value);
        }
        // 判断商品写真2
        if (key == 'product_image2' && value != null && value != '') {
          // 出荷指示明细-定制
          value = await WMSCommonFile().previewImageFile(value);
        }
        // 判断key
        if (shipDetailTemp[key] != null) {
          // 出荷指示明细-临时
          shipDetailTemp[key] = value;
        } else {
          // 出荷指示明细-临时
          shipDetailTemp.addAll({key: value});
        }
      }
      // 出荷指示明细-定制
      state.shipDetailCustomize = shipDetailTemp;

      // 更新
      emit(clone(state));
    });

    // 保存出荷指示明细表单事件
    on<SaveShipDetailFormEvent>((event, emit) async {
      // 保存出荷指示明细表单验证
      Map<String, dynamic> shipDetailStructure =
          saveShipDetailFormCheck(event.shipDetailStructure);
      // 判断验证结果
      if (shipDetailStructure.length == 0) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 出荷指示明细数据
      List<Map<String, dynamic>> shipDetailData;
      // 出荷指示明细
      ShipDetail shipDetail = ShipDetail.fromJson(shipDetailStructure);

      // 判断实体类ID
      if (shipDetail.id == null) {
        // 创建或更新出荷指示明细表单处理
        bool checkFlag =
            await createOrUpdateShipDetailFormHandle(shipDetail, state.shipId);
        // 判断处理结果
        if (checkFlag == false) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.product_exists);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // 创建出荷指示明细表单处理
        shipDetail = await createShipDetailFormHandle(
            shipDetail, state.shipId, state.shipCustomize['ship_no']);
        // 判断处理结果
        if (shipDetail.create_id == null || shipDetail.create_id == '') {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_operate_detail +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        try {
          // 新增出荷指示明细
          shipDetailData = await SupabaseUtils.getClient()
              .from('dtb_ship_detail')
              .insert([shipDetail.toJson()]).select('*');
          // 判断出荷指示明细数据
          if (shipDetailData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_operate_detail +
                    WMSLocalizations.i18n(state.rootContext)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_operate_detail +
                    WMSLocalizations.i18n(state.rootContext)!.create_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_operate_detail +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        // 创建或更新出荷指示明细表单处理
        bool checkFlag =
            await createOrUpdateShipDetailFormHandle(shipDetail, state.shipId);
        // 判断处理结果
        if (checkFlag == false) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.product_exists);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // 更新出荷指示明细表单处理
        shipDetail = await updateShipDetailFormHandle(shipDetail);
        // 判断处理结果
        if (shipDetail.update_id == null || shipDetail.update_id == '') {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_operate_detail +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        try {
          // 修改出荷指示明细
          shipDetailData = await SupabaseUtils.getClient()
              .from('dtb_ship_detail')
              .update(shipDetail.toJson())
              .eq('id', shipDetail.id)
              .select('*');
          // 判断出荷指示明细数据
          if (shipDetailData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_operate_detail +
                    WMSLocalizations.i18n(state.rootContext)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .instruction_input_table_operate_detail +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_operate_detail +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }

      if (kIsWeb) {
        // 关闭弹窗
        Navigator.pop(event.context);
      } else {
        GoRouter.of(state.rootContext).pop('refresh return');
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 删除出荷指示明细事件
    on<DeleteShipDetailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 修改出荷指示明细
        List<Map<String, dynamic>> shipDetailData =
            await SupabaseUtils.getClient()
                .from('dtb_ship_detail')
                .update({'del_kbn': Config.DELETE_YES})
                .eq('id', event.shipDetailId)
                .select('*');
        // 判断出荷指示明细数据
        if (shipDetailData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_operate_detail +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                      .instruction_input_table_operate_detail +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_table_operate_detail +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 导入CSV文件事件
    on<ImportCSVFileEvent>((event, emit) async {
      // 判断内容长度
      if (event.content.length == 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 判断内容长度
      if (event.content.length > 0 && event.content.length < 3) {
        // 出荷指示列表
        List<Map<String, dynamic>> shipList = [];
        // 出荷指示明细列表
        List<Map<String, dynamic>> shipDetailList = [];

        // 判断内容长度
        if (event.content.length == 1) {
          // 出荷指示列表
          shipList = event.content[0];
        } else if (event.content.length == 2) {
          // 出荷指示列表
          shipList = event.content[0];
          // 出荷指示明细列表
          shipDetailList = event.content[1];
        }

        // 循环出荷指示列表
        for (int i = 0; i < shipList.length; i++) {
          // 出荷指示ID
          int shipId = 0;
          // 出荷指示番号
          String shipNo = '';
          // 当前出荷指示ID
          int currentShipId = 0;

          // 当前出荷指示
          Map<String, dynamic> currentShip = shipList[i];
          // 判断当前出荷指示ID
          if (currentShip['id'] != null && currentShip['id'] != '') {
            // 当前出荷指示ID
            currentShipId = int.parse(currentShip['id'].toString());
            // 当前出荷指示ID
            currentShip['id'] = '';
          }

          // 保存出荷指示表单验证
          Map<String, dynamic> shipStructure = saveShipFormCheck(currentShip);
          // 判断验证结果
          if (shipStructure.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 出荷指示
          Ship ship = Ship.fromJson(shipStructure);

          // 创建出荷指示表单处理
          ship = await createShipFormHandle(ship);
          // 判断处理结果
          if (ship.create_id == null || ship.create_id == '') {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          try {
            // 新增出荷指示
            List<Map<String, dynamic>> shipData =
                await SupabaseUtils.getClient()
                    .from('dtb_ship')
                    .insert([ship.toJson()]).select('*');
            // 判断出荷指示数据
            if (shipData.length == 0) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                      WMSLocalizations.i18n(state.rootContext)!.import_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            } else {
              //csv导入成功
              //插入操作履历 sys_log表
              CommonUtils().createLogInfo(
                  '出荷指示入力CSV' +
                      Config.OPERATION_TEXT1 +
                      Config.OPERATION_BUTTON_TEXT9 +
                      Config.OPERATION_TEXT2,
                  "ImportCSVFileEvent()",
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser!
                      .company_id,
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser!
                      .id);
            }
            // 出荷指示ID
            shipId = shipData[0]['id'];
            // 出荷指示番号
            shipNo = shipData[0]['ship_no'];
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                    WMSLocalizations.i18n(state.rootContext)!.import_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }

          // 循环出荷指示明细列表
          for (int j = 0; j < shipDetailList.length; j++) {
            // 判断当前出荷指示ID
            if (shipDetailList[j]['ship_id'] != null &&
                shipDetailList[j]['ship_id'] != '' &&
                int.parse(shipDetailList[j]['ship_id'].toString()) ==
                    currentShipId) {
              // 当前出荷指示明细
              Map<String, dynamic> currentShipDetail = shipDetailList[j];
              currentShipDetail['id'] = '';

              // 保存出荷指示明细表单验证
              Map<String, dynamic> shipDetailStructure =
                  saveShipDetailFormCheck(currentShipDetail);
              // 判断验证结果
              if (shipDetailStructure.length == 0) {
                // 出荷指示导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_ship')
                    .update({'importerror_flg': 5}).eq('id', shipId);
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              // 出荷指示明细
              ShipDetail shipDetail = ShipDetail.fromJson(shipDetailStructure);

              // 创建或更新出荷指示明细表单处理
              bool checkFlag =
                  await createOrUpdateShipDetailFormHandle(shipDetail, shipId);
              // 判断处理结果
              if (checkFlag == false) {
                // 出荷指示导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_ship')
                    .update({'importerror_flg': 5}).eq('id', shipId);
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              // 创建出荷指示明细表单处理
              shipDetail =
                  await createShipDetailFormHandle(shipDetail, shipId, shipNo);
              // 判断处理结果
              if (shipDetail.create_id == null || shipDetail.create_id == '') {
                // 出荷指示导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_ship')
                    .update({'importerror_flg': 5}).eq('id', shipId);
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              // 查询商品
              List<dynamic> productData = await SupabaseUtils.getClient()
                  .from('mtb_product')
                  .select('*')
                  .eq('id', shipDetail.product_id)
                  .eq(
                      'company_id',
                      StoreProvider.of<WMSState>(state.rootContext)
                          .state
                          .loginUser
                          ?.company_id);
              // 判断商品数据
              if (productData.length == 0) {
                // 出荷指示导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_ship')
                    .update({'importerror_flg': 1}).eq('id', shipId);
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }

              try {
                // 新增出荷指示明细
                List<Map<String, dynamic>> shipDetailData =
                    await SupabaseUtils.getClient()
                        .from('dtb_ship_detail')
                        .insert([shipDetail.toJson()]).select('*');
                // 判断出荷指示明细数据
                if (shipDetailData.length == 0) {
                  // 出荷指示导入异常字段更新
                  await SupabaseUtils.getClient()
                      .from('dtb_ship')
                      .update({'importerror_flg': 4}).eq('id', shipId);
                  // 失败提示
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                          WMSLocalizations.i18n(state.rootContext)!
                              .import_error);
                  // 关闭加载
                  BotToast.closeAllLoading();
                  return;
                }
              } catch (e) {
                // 出荷指示导入异常字段更新
                await SupabaseUtils.getClient()
                    .from('dtb_ship')
                    .update({'importerror_flg': 4}).eq('id', shipId);
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                        WMSLocalizations.i18n(state.rootContext)!.import_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            }
          }
        }

        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!.file_type_csv +
                WMSLocalizations.i18n(state.rootContext)!.import_success);
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 当前下标变更事件
    on<CurrentIndexChangeEvent>((event, emit) async {
      // 当前下标
      state.currentIndex = event.value;
      // 更新
      emit(clone(state));
    });
    // 自定义事件 - 终

    add(InitEvent());
  }

  // 保存出荷指示表单验证
  Map<String, dynamic> saveShipFormCheck(Map<String, dynamic> shipStructure) {
    // 判断是否为空
    if (shipStructure['rcv_sch_date'] == null ||
        shipStructure['rcv_sch_date'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_3 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['cus_rev_date'] == null ||
        shipStructure['cus_rev_date'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_5 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (DateFormat('yyyy/MM/dd')
        .parse(shipStructure['cus_rev_date'].toString().replaceAll('-', '/'))
        .isBefore(DateFormat('yyyy/MM/dd').parse(
            shipStructure['rcv_sch_date'].toString().replaceAll('-', '/')))) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
          .instruction_input_form_basic_3_less_than_basic_5);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['order_no'] != null &&
        shipStructure['order_no'] != '' &&
        CheckUtils.check_Half_Alphanumeric(shipStructure['order_no'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_2 +
          WMSLocalizations.i18n(state.rootContext)!
              .check_half_width_alphanumeric);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_name'] == null ||
        shipStructure['customer_name'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_basic_4 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_name_kana'] == null ||
        shipStructure['customer_name_kana'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_21 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Kana(shipStructure['customer_name_kana'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_21 +
          WMSLocalizations.i18n(state.rootContext)!.check_kana);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_postal_cd'] == null ||
        shipStructure['customer_postal_cd'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_22 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Postal(shipStructure['customer_postal_cd'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_22 +
          WMSLocalizations.i18n(state.rootContext)!.check_postal);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_addr_1'] == null ||
        shipStructure['customer_addr_1'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_23 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_addr_2'] == null ||
        shipStructure['customer_addr_2'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_24 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_addr_3'] == null ||
        shipStructure['customer_addr_3'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_25 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_tel'] == null ||
        shipStructure['customer_tel'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_26 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Number_Hyphen(
        shipStructure['customer_tel'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_26 +
          WMSLocalizations.i18n(state.rootContext)!
              .check_half_width_numbers_with_hyphen);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipStructure['customer_fax'] != null &&
        shipStructure['customer_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(shipStructure['customer_fax'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_27 +
          WMSLocalizations.i18n(state.rootContext)!
              .check_half_width_numbers_with_hyphen);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }
    if (shipStructure['same_kbn'] == null ||
        shipStructure['same_kbn'] == '' ||
        shipStructure['same_kbn'] == '0') {
      if (shipStructure['name'] == null || shipStructure['name'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_basic_8 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['name_kana'] == null ||
          shipStructure['name_kana'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_12 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (CheckUtils.check_Kana(shipStructure['name_kana'])) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_12 +
                WMSLocalizations.i18n(state.rootContext)!.check_kana);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['postal_cd'] == null ||
          shipStructure['postal_cd'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_13 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (CheckUtils.check_Postal(shipStructure['postal_cd'])) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_13 +
                WMSLocalizations.i18n(state.rootContext)!.check_postal);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['addr_1'] == null ||
          shipStructure['addr_1'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_14 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['addr_2'] == null ||
          shipStructure['addr_2'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_15 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['addr_3'] == null ||
          shipStructure['addr_3'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_16 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['addr_tel'] == null ||
          shipStructure['addr_tel'] == '') {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_17 +
                WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (CheckUtils.check_Half_Number_Hyphen(
          shipStructure['addr_tel'])) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_17 +
                WMSLocalizations.i18n(state.rootContext)!
                    .check_half_width_numbers_with_hyphen);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      } else if (shipStructure['fax'] != null &&
          shipStructure['fax'] != '' &&
          CheckUtils.check_Half_Number_Hyphen(shipStructure['fax'])) {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                    .instruction_input_form_before_18 +
                WMSLocalizations.i18n(state.rootContext)!
                    .check_half_width_numbers_with_hyphen);
        // 关闭加载
        BotToast.closeAllLoading();
        return {};
      }
    }
    if (shipStructure['person'] == null || shipStructure['person'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_before_2 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 处理出荷指示-结构
    if (shipStructure['id'] == null || shipStructure['id'] == '') {
      shipStructure.remove('id');
    } else {
      shipStructure['id'] = int.parse(shipStructure['id'].toString());
    }
    if (shipStructure['delivery_company_id'] == null ||
        shipStructure['delivery_company_id'] == '') {
      shipStructure.remove('delivery_company_id');
    } else {
      shipStructure['delivery_company_id'] =
          int.parse(shipStructure['delivery_company_id'].toString());
    }
    if (shipStructure['customer_id'] == null ||
        shipStructure['customer_id'] == '') {
      shipStructure.remove('customer_id');
    } else {
      shipStructure['customer_id'] =
          int.parse(shipStructure['customer_id'].toString());
    }
    if (shipStructure['customer_addr_id'] == null ||
        shipStructure['customer_addr_id'] == '') {
      shipStructure.remove('customer_addr_id');
    } else {
      shipStructure['customer_addr_id'] =
          int.parse(shipStructure['customer_addr_id'].toString());
    }

    // 返回
    return shipStructure;
  }

  // 创建出荷指示表单处理
  Future<Ship> createShipFormHandle(Ship ship) async {
    try {
      // 获取自动采番连番
      ship.ship_no = await WMSCommonBloc.selectNumber(
          StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser
              ?.company_id,
          Config.WMS_CHANNEL_B);
      // 更新自动采番连番
      WMSCommonBloc.updateNumberSeqNo(
          StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser
              ?.company_id,
          Config.WMS_CHANNEL_B,
          ship.ship_no!);
    } catch (e) {
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.rootContext)!
                  .instruction_input_form_basic_1 +
              WMSLocalizations.i18n(state.rootContext)!.create_error);
      // 关闭加载
      BotToast.closeAllLoading();
      return Ship.empty();
    }
    // 出荷指示
    ship.ship_kbn = Config.SHIP_KBN_WAIT_ASSIGN;
    ship.pick_list_kbn = Config.PICK_LIST_KBN_2;
    ship.pdf_kbn = Config.PDF_KBN_1;
    ship.csv_kbn = Config.CSV_KBN_2;
    ship.company_id = StoreProvider.of<WMSState>(state.rootContext)
        .state
        .loginUser
        ?.company_id;
    ship.del_kbn = Config.DELETE_NO;
    ship.create_time = DateTime.now().toString();
    ship.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    ship.update_time = DateTime.now().toString();
    ship.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return ship;
  }

  // 更新出荷指示表单处理
  Ship updateShipFormHandle(Ship ship) {
    // 出荷指示
    ship.update_time = DateTime.now().toString();
    ship.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return ship;
  }

  // 保存出荷指示明细表单验证
  Map<String, dynamic> saveShipDetailFormCheck(
      Map<String, dynamic> shipDetailStructure) {
    // 判断是否为空
    // if (shipDetailStructure['warehouse_no'] == null ||
    //     shipDetailStructure['warehouse_no'] == '') {
    //   // 消息提示
    //   WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
    //           .instruction_input_table_title_2 +
    //       WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
    //   // 关闭加载
    //   BotToast.closeAllLoading();
    //   return {};
    // } else
    if (shipDetailStructure['product_id'] == null ||
        shipDetailStructure['product_id'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_table_title_4 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipDetailStructure['product_price'] == null ||
        shipDetailStructure['product_price'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_table_title_9 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Number(
        shipDetailStructure['product_price'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_table_title_9 +
          WMSLocalizations.i18n(state.rootContext)!.check_half_width_numbers);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (shipDetailStructure['ship_num'] == null ||
        shipDetailStructure['ship_num'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_13 +
          WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (CheckUtils.check_Half_Number_In_10(
        shipDetailStructure['ship_num'])) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
              .instruction_input_form_detail_13 +
          WMSLocalizations.i18n(state.rootContext)!
              .check_half_width_numbers_in_10);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }
    // else if (shipDetailStructure['note1'] == null ||
    //     shipDetailStructure['note1'] == '') {
    //   // 消息提示
    //   WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
    //           .instruction_input_form_detail_9 +
    //       WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
    //   // 关闭加载
    //   BotToast.closeAllLoading();
    //   return {};
    // } else if (shipDetailStructure['note2'] == null ||
    //     shipDetailStructure['note2'] == '') {
    //   // 消息提示
    //   WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.rootContext)!
    //           .instruction_input_form_detail_12 +
    //       WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
    //   // 关闭加载
    //   BotToast.closeAllLoading();
    //   return {};
    // }

    // 处理出荷指示明细-结构
    if (shipDetailStructure['id'] == null || shipDetailStructure['id'] == '') {
      shipDetailStructure.remove('id');
    } else {
      shipDetailStructure['id'] =
          int.parse(shipDetailStructure['id'].toString());
    }
    if (shipDetailStructure['ship_id'] == null ||
        shipDetailStructure['ship_id'] == '') {
      shipDetailStructure.remove('ship_id');
    } else {
      shipDetailStructure['ship_id'] =
          int.parse(shipDetailStructure['ship_id'].toString());
    }
    if (shipDetailStructure['product_id'] == null ||
        shipDetailStructure['product_id'] == '') {
      shipDetailStructure.remove('product_id');
    } else {
      shipDetailStructure['product_id'] =
          int.parse(shipDetailStructure['product_id'].toString());
    }
    if (shipDetailStructure['ship_num'] == null ||
        shipDetailStructure['ship_num'] == '') {
      shipDetailStructure.remove('ship_num');
    } else {
      shipDetailStructure['ship_num'] =
          int.parse(shipDetailStructure['ship_num'].toString());
    }
    if (shipDetailStructure['product_price'] == null ||
        shipDetailStructure['product_price'] == '') {
      shipDetailStructure.remove('product_price');
    } else {
      shipDetailStructure['product_price'] =
          double.parse(shipDetailStructure['product_price'].toString());
    }
    if (shipDetailStructure['location_id'] == null ||
        shipDetailStructure['location_id'] == '') {
      shipDetailStructure.remove('location_id');
    } else {
      shipDetailStructure['location_id'] =
          int.parse(shipDetailStructure['location_id'].toString());
    }
    if (shipDetailStructure['lock_num'] == null ||
        shipDetailStructure['lock_num'] == '') {
      shipDetailStructure.remove('lock_num');
    } else {
      shipDetailStructure['lock_num'] =
          int.parse(shipDetailStructure['lock_num'].toString());
    }
    if (shipDetailStructure['store_num'] == null ||
        shipDetailStructure['store_num'] == '') {
      shipDetailStructure.remove('store_num');
    } else {
      shipDetailStructure['store_num'] =
          int.parse(shipDetailStructure['store_num'].toString());
    }
    if (shipDetailStructure['check_num'] == null ||
        shipDetailStructure['check_num'] == '') {
      shipDetailStructure.remove('check_num');
    } else {
      shipDetailStructure['check_num'] =
          int.parse(shipDetailStructure['check_num'].toString());
    }
    if (shipDetailStructure['packing_num'] == null ||
        shipDetailStructure['packing_num'] == '') {
      shipDetailStructure.remove('packing_num');
    } else {
      shipDetailStructure['packing_num'] =
          int.parse(shipDetailStructure['packing_num'].toString());
    }

    // 返回
    return shipDetailStructure;
  }

  // 创建或更新出荷指示明细表单处理
  Future<bool> createOrUpdateShipDetailFormHandle(
      ShipDetail shipDetail, int shipId) async {
    // 查询出荷指示明细
    List<dynamic> shipDetailData = await SupabaseUtils.getClient()
        .from('dtb_ship_detail')
        .select('*')
        .eq('ship_id', shipId)
        .eq('product_id', shipDetail.product_id);
    // 判断出荷指示明细长度
    if (shipDetailData.length == 0 ||
        shipDetailData[0]['id'] == shipDetail.id) {
      // 返回
      return true;
    } else {
      // 返回
      return false;
    }
  }

  // 创建出荷指示明细表单处理
  Future<ShipDetail> createShipDetailFormHandle(
      ShipDetail shipDetail, int shipId, String shipNo) async {
    // 番号
    String lineNo = '001';
    // 查询出荷指示明细
    List<dynamic> shipDetailData = await SupabaseUtils.getClient()
        .from('dtb_ship_detail')
        .select('*')
        .eq('ship_id', shipId)
        .order('id', ascending: false);
    // 判断出荷指示明细长度
    if (shipDetailData.length != 0) {
      // 上一个出荷指示明细番号
      dynamic lastShipLineNo = shipDetailData[0]['ship_line_no'];
      // 判断上一个出荷指示明细番号
      if (lastShipLineNo != null && lastShipLineNo != '') {
        // 上一个番号
        int lastLineNo = int.parse(lastShipLineNo.substring(
            lastShipLineNo.length - 3, lastShipLineNo.length));
        // 当前番号
        int nowLineNo = lastLineNo + 1;
        // 判断当前番号
        if (nowLineNo < 10) {
          // 番号
          lineNo = '00' + nowLineNo.toString();
        } else if (lastLineNo < 100) {
          // 番号
          lineNo = '0' + nowLineNo.toString();
        } else {
          // 番号
          lineNo = nowLineNo.toString();
        }
      }
    }

    // 出荷指示明细
    shipDetail.ship_id = shipId;
    shipDetail.ship_line_no = shipNo + lineNo;
    shipDetail.lock_kbn = Config.LOCK_KBN_0;
    shipDetail.store_kbn = Config.STORE_KBN_2;
    shipDetail.check_kbn = Config.CHECK_KBN_2;
    shipDetail.packing_kbn = Config.PACKING_KBN_2;
    shipDetail.confirm_kbn = Config.CONFIRM_KBN_2;
    shipDetail.del_kbn = Config.DELETE_NO;
    shipDetail.create_time = DateTime.now().toString();
    shipDetail.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    shipDetail.update_time = DateTime.now().toString();
    shipDetail.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return shipDetail;
  }

  // 更新出荷指示明细表单处理
  ShipDetail updateShipDetailFormHandle(ShipDetail shipDetail) {
    // 出荷指示明细
    shipDetail.update_time = DateTime.now().toString();
    shipDetail.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return shipDetail;
  }
}
