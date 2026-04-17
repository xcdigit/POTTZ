import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'lack_goods_invoice_detail_model.dart';

/**
 * 内容：欠品伝票照会-BLOC
 * 作者：熊草云
 * 时间：2023/09/18
 */
// 事件
// 事件
abstract class LackGoodsInvoiceDetailEvent extends TableListEvent {}

class SetShipPrintingEvent extends LackGoodsInvoiceDetailEvent {
  // 设定值事件
  SetShipPrintingEvent();
}

// 设置检索条件
class SetSearchEvent extends LackGoodsInvoiceDetailEvent {
  // 初始化事件
  String key;
  String searchData;
  int searchId;
  SetSearchEvent(this.searchId, this.key, this.searchData);
}

// 初始化检索条件
class SearchInitEvent extends LackGoodsInvoiceDetailEvent {
  // 初始化事件
  SearchInitEvent();
}

// 引当
class ReservationShipLineEvent extends LackGoodsInvoiceDetailEvent {
  List reservationList;
  // 结构树
  BuildContext context;
  ReservationShipLineEvent(this.reservationList, this.context);
}

// 自定义事件 - 终
class LackGoodsInvoiceDetailBloc
    extends WmsTableBloc<LackGoodsInvoiceDetailModel> {
  // 刷新补丁
  @override
  LackGoodsInvoiceDetailModel clone(LackGoodsInvoiceDetailModel src) {
    return LackGoodsInvoiceDetailModel.clone(src);
  }

  LackGoodsInvoiceDetailBloc(LackGoodsInvoiceDetailModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      BotToast.showLoading();
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_ship_detial_lack_goods',
              params: {'p_ship_id': state.shipno})
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1)
          .order('id', ascending: true);
      //列表清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        data[i]['sum'] = (data[i]['product_price'] * data[i]['ship_num']);
        // 引当状態
        // 引当待ち
        if (data[i]['lock_kbn'] == Config.LOCK_KBN_0) {
          data[i]['lock_kbn'] =
              WMSLocalizations.i18n(state.context)!.lock_kbn_text_0;
        }
        // 引当済
        else if (data[i]['lock_kbn'] == Config.LOCK_KBN_1) {
          data[i]['lock_kbn'] =
              WMSLocalizations.i18n(state.context)!.lock_kbn_text_1;
        }
        // 引当不足
        else if (data[i]['lock_kbn'] == Config.LOCK_KBN_2) {
          data[i]['lock_kbn'] =
              WMSLocalizations.i18n(state.context)!.lock_kbn_text_2;
        } else {
          data[i]['lock_kbn'] = '';
        }
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 查询出荷总数
      List<dynamic> count = await SupabaseUtils.getClient().rpc(
          'func_query_table_dtb_ship_detial_lack_goods',
          params: {'p_ship_id': state.shipno}).select('*');
      // 总页数
      for (int i = 0; i < data.length; i++) {
        try {
          // ignore: unnecessary_null_comparison
          if (data[i]['image1'] != null && data[i]['image1'] != '') {
            data[i]['image1'] =
                await WMSCommonFile().previewImageFile(data[i]['image1']);
          }
        } catch (e) {
          data[i]['image1'] = '';
        }
        try {
          // ignore: unnecessary_null_comparison
          if (data[i]['image2'] != null && data[i]['image2'] != '') {
            data[i]['image2'] =
                await WMSCommonFile().previewImageFile(data[i]['image2']);
          }
        } catch (e) {
          data[i]['image2'] = '';
        }
      }
      state.total = count.length;

      emit(clone(state));
      BotToast.closeAllLoading();
    });
    // 引当
    on<ReservationShipLineEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      String shipId;
      String shipNo;
      // 赵士淞 - 测试修复 2023/11/17 - 始
      // String shipList;
      // 赵士淞 - 测试修复 2023/11/17 - 终
      int j = 0;
      int k = 0;
      shipId = event.reservationList[0].toString();
      shipNo = event.reservationList[1].toString();
      // 赵士淞 - 测试修复 2023/11/17 - 始
      // shipList = event.reservationList[1].toString();
      // 赵士淞 - 测试修复 2023/11/17 - 终
      bool ship_flag = true;
      int limit_flag = 0;
      List<dynamic> data = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_ship_inquiry_reservation', params: {
        'p_ship_id': shipId,
        'p_user': StoreProvider.of<WMSState>(event.context)
            .state
            .loginUser
            ?.company_id as int
      }).select('*');
      // ignore: unnecessary_null_comparison
      if (data == null || data.length == 0) {
        ship_flag = false;
      }
      //得意先の消費期限のチェック
      List<dynamic> resCheck = await reservationBeforeCheck(shipId, data);
      if (resCheck.length > 0 && resCheck[0]['result'] == 1) {
        ship_flag = false;
        limit_flag = 1;
      } else {
        if (resCheck.length > 0 && resCheck[0]['result'] == 2) {
          limit_flag = 2;
        }
        // 当前库存件数 = 在庫数-ロック数
        for (j = 0; j < data.length; j++) {
          if (data[j]['product_id'] == null ||
              data[j]['company_id'] == null ||
              data[j]['year_month'] == null ||
              data[j]['stock'] == null ||
              data[j]['lock_stock'] == null) {
            ship_flag = false;
            break;
          }
          // 判断【引当済】为【1:引当済】的场合，跳过，执行下一条数据
          if (data[j]['lock_kbn'] == '1') {
            continue;
          }
          int number = data[j]['stock'] - data[j]['lock_stock'];
          if (number >= data[j]['ship_num']) {
            // 根据dtb_store(在庫)的【id】【商品ID】检索表【dtb_product_location(商品在庫位置)】list数据
            // ※dtb _ product _ location（商品在庫位置）からデータを抽出する場合、「登録日時」で昇順する。（先入先出法対応) 20241204
            List<dynamic> dataLocation = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('product_id', data[j]['product_id'])
                .order('create_time', ascending: true);
            int ship_sum = data[j]['ship_num'];
            // 锁定库存数
            int ship_count = data[j]['ship_num'];
            // ignore: unnecessary_null_comparison
            bool flag = false;
            // ignore: unnecessary_null_comparison
            if (dataLocation == null || dataLocation.length == 0) {
              ship_flag = false;
              break;
            }
            for (k = 0; k < dataLocation.length; k++) {
              // 每个货架中商品的库存数量
              int ship =
                  dataLocation[k]['stock'] - dataLocation[k]['lock_stock'];
              if (dataLocation[k]['stock'] - dataLocation[k]['lock_stock'] >
                  ship_sum) {
                await SupabaseUtils.getClient()
                    .from('dtb_product_location')
                    .update({
                  'lock_stock': dataLocation[k]['lock_stock'] + ship_sum
                }).eq('id', dataLocation[k]['id']);
                ship_count = ship_sum;
                ship_sum -= ship;
                flag = true;
              } else {
                await SupabaseUtils.getClient()
                    .from('dtb_product_location')
                    .update({'lock_stock': dataLocation[k]['stock']}).eq(
                        'id', dataLocation[k]['id']);
                ship_sum -= ship;
                ship_count = ship;
              }
              String currentTime = DateTime.now().toIso8601String();
              String updataTime = DateTime.now().toUtc().toString();
              // 准备要插入的数据
              Map<String, dynamic> newData = {
                'rev_ship_line_no': data[j]['ship_line_no'],
                'rev_ship_kbn': '2',
                'product_location_id': dataLocation[k]['location_id'],
                'stock': ship_count,
                'create_time': currentTime,
                'create_id': StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser!
                    .id,
                'update_time': updataTime,
                'update_id': StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser!
                    .id,
              };
              // 查找仓库名
              // func_query_table_dtb_ship_inquiry_reservation_warehouse_name
              List<dynamic> warehouse = await SupabaseUtils.getClient().rpc(
                  'func_query_table_dtb_ship_inquiry_reservation_warehouse_name',
                  params: {
                    'location_id': dataLocation[k]['location_id']
                  }).select('*');
              Map<String, dynamic> newDataLoction = {
                'ship_id': data[j]['ship_id'],
                // 赵士淞 - 测试修复 2023/11/17 - 始
                'ship_line_no': data[j]['ship_line_no'],
                // 赵士淞 - 测试修复 2023/11/17 - 终
                'pick_line_no':
                    "${data[j]['ship_line_no']}-${(k + 1).toString().padLeft(3, '0')}",
                'product_id': dataLocation[k]['product_id'],
                'product_price': data[j]['product_price'],
                'warehouse_no': warehouse[0]['name'],
                'from_location_id': dataLocation[k]['location_id'],
                'lock_num': ship_count,
                'store_kbn': 2,
                'del_kbn': Config.DELETE_NO
              };

              // 执行插入操作
              // 库存数量>0，才能插入数据
              if (ship > 0) {
                // dtb_rev_ship_location(商品入出荷位置)
                await SupabaseUtils.getClient()
                    .from('dtb_rev_ship_location')
                    .insert([newData]);
                // dtb_pick_list
                // 插入数据 dtb_pick_list(ピッキングリスト)
                await SupabaseUtils.getClient()
                    .from('dtb_pick_list')
                    .insert([newDataLoction]);
              }
              // 更新明细仓库名
              if (k == 0) {
                await SupabaseUtils.getClient()
                    .from('dtb_ship_detail')
                    .update({'warehouse_no': warehouse[0]['name']}).eq(
                        'id', data[j]['id']);
              }
              if (flag) break;
            }
            // 判断所有货架的商品库存是否能够提供足够商品来锁定库存
            if (ship_sum > 0) {
              await SupabaseUtils.getClient().from('dtb_ship_detail').update({
                'lock_kbn': '2',
              }).eq('id', data[j]['id']);
              ship_flag = false;
            } else {
              // dtb_ship_detail(出荷指示明細)【引当数量】【引当済】【出荷倉庫】
              await SupabaseUtils.getClient().from('dtb_ship_detail').update({
                'lock_num': data[j]['ship_num'],
                'lock_kbn': '1',
              }).eq('id', data[j]['id']);
              // dtb_store(在庫)【ロック数：元ロック数+出荷指示数】
              await SupabaseUtils.getClient()
                  .from('dtb_store')
                  .update({
                    'lock_stock': data[j]['ship_num'] + data[j]['lock_stock']
                  })
                  .eq('product_id', data[j]['product_id'])
                  .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
                  .eq(
                      'company_id',
                      StoreProvider.of<WMSState>(state.context)
                          .state
                          .loginUser
                          ?.company_id as int);
            }
          } else {
            await SupabaseUtils.getClient().from('dtb_ship_detail').update({
              'lock_kbn': '2',
            }).eq('id', data[j]['id']);
            ship_flag = false;
          }
        }
      }
      if (ship_flag) {
        await SupabaseUtils.getClient().from('dtb_ship').update({
          'ship_kbn': '2',
        }).eq('id', shipId);
        BotToast.closeAllLoading();
        // 消息提示
        WMSCommonBlocUtils.tipTextTwoSecondToast(
            WMSLocalizations.i18n(event.context)!
                .display_instruction_reservation_success);
        if (limit_flag == 2) {
          Future.delayed(Duration(seconds: 2), () {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.delivery_note_14 +
                    '：${shipNo}  ' +
                    WMSLocalizations.i18n(event.context)!
                        .display_instruction_message3);
          });
        }
        Future.delayed(Duration(seconds: 2), () {
          state.context.pop();
        });
      } else {
        if (limit_flag == 1) {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.delivery_note_14 +
                  '：${shipNo}  ' +
                  WMSLocalizations.i18n(event.context)!
                      .display_instruction_message2);
        } else {
          await SupabaseUtils.getClient().from('dtb_ship').update({
            'ship_kbn': '0',
          }).eq('id', shipId);
          // 关闭加载
          BotToast.closeAllLoading();
          // 消息提示
          WMSCommonBlocUtils.tipTextTwoSecondToast(
              WMSLocalizations.i18n(event.context)!.delivery_note_14 +
                  '：${shipNo}  ' +
                  WMSLocalizations.i18n(event.context)!
                      .display_instruction_reservation_disappearance);
        }
      }
      //插入操作履历 sys_log表
      CommonUtils().createLogInfo(
          Config.OPERATION_BUTTON_TEXT7 +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "欠品Detail ReservationShipLineEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);

      // 刷新补丁
      emit(clone(state));
      // add(PageQueryEvent());
    });
    add(PageQueryEvent());
  }

  //引当チェック処理
  Future<List<dynamic>> reservationBeforeCheck(
      String shipId, List<dynamic> data) async {
    //2.得意先の消費期限のチェックを実施する。
    //　検索テーブル：mtb_customer(得意先マスタ)
    //　条件：得意先コード（dtb_ship（出荷指示)の得意先と同じ）
    //　検索項目：得意先_消費期限制御、得意先_消費期限
    // 查询得意先
    List<dynamic> resultList = [];
    List<dynamic> shipDataList = await SupabaseUtils.getClient()
        .from('dtb_ship')
        .select('*')
        .eq('id', int.parse(shipId));

    int? customerId = shipDataList[0]['customer_id'];
    if (customerId == null) {
      return resultList;
    }
    List<dynamic> customerDataList = await SupabaseUtils.getClient()
        .from('mtb_customer')
        .select('*')
        .eq('id', customerId);
    if (customerDataList.length > 0) {
      var customerData = customerDataList[0];
      //2.1.得意先_消費期限制御の値は、0(OFF)の時、次の処理を実施。
      if (customerData['limit_date_flg'] == null ||
          customerData['limit_date_flg'].toString() == '0') {
        return resultList;
      } else {
        //2.2.得意先_消費期限制御の値は、0(OFF)以外の時、商品の消費期間のチェック処理追加
        int j = 0;
        int k = 0;
        for (j = 0; j < data.length; j++) {
          if (data[j]['product_id'] == null ||
              data[j]['company_id'] == null ||
              data[j]['year_month'] == null ||
              data[j]['stock'] == null ||
              data[j]['lock_stock'] == null) {
            break;
          }
          Map<String, int> resultMapIn = new Map();
          // 判断【引当済】为【1:引当済】的场合，跳过，执行下一条数据
          if (data[j]['lock_kbn'] == '1') {
            continue;
          }
          // 当前库存件数 = 在庫数-ロック数
          int number = data[j]['stock'] - data[j]['lock_stock'];
          // 【出荷指示数】<=【当前库存件数】的场合
          if (number >= data[j]['ship_num']) {
            // 根据dtb_store(在庫)的【id】【商品ID】检索表【dtb_product_location(商品在庫位置)】list数据
            // ※dtb _ product _ location（商品在庫位置）からデータを抽出する場合、「登録日時」で昇順する。（先入先出法対応) 20241204
            List<dynamic> dataLocation = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('product_id', data[j]['product_id'])
                .order('create_time', ascending: true);
            // 初始设置出荷指示数
            int ship_sum = data[j]['ship_num'];
            // 单个货架满足锁库存需求flg
            bool flag = false;
            // 在库位置没有商品 引当失败
            // ignore: unnecessary_null_comparison
            if (dataLocation == null || dataLocation.length == 0) {
              break;
            }

            // 循环商品在库位置，先入先出锁定商品
            for (k = 0; k < dataLocation.length; k++) {
              // 每个货架中商品的库存数量
              int ship =
                  dataLocation[k]['stock'] - dataLocation[k]['lock_stock'];
              // 当前货架库存数>出荷指示数 （单个货架满足锁库存需求）
              if (dataLocation[k]['stock'] - dataLocation[k]['lock_stock'] >
                  ship_sum) {
                // 当前剩余需要锁定库存数
                ship_sum -= ship;
                flag = true;
              } else {
                // 当前货架库存数 <= 出荷指示数
                // 当前剩余需要锁定库存数
                ship_sum -= ship;
              }
              if (ship > 0) {
                if (dataLocation[k]['limit_date'] != null) {
                  //消費期限 < 現在日付 + 得意先_消費期限の場合
                  // 当前日期
                  DateTime now = DateTime.now();
                  // 得意先_消費期限
                  int customerExpiryDays =
                      int.parse(customerData['limit_date']);
                  // 计算当前日期 + 得意先消费期限
                  DateTime expiryDate =
                      now.add(Duration(days: customerExpiryDays));
                  // 消費期限
                  DateTime limitDate =
                      DateTime.parse(dataLocation[k]['limit_date']);
                  if (limitDate.isBefore(expiryDate)) {
                    if (customerData['limit_date_flg'].toString() == '1') {
                      resultMapIn['result'] = 1;
                      resultMapIn['projectId'] = data[j]['product_id'];
                    } else if (customerData['limit_date_flg'].toString() ==
                        '2') {
                      resultMapIn['result'] = 2;
                      resultMapIn['projectId'] = data[j]['product_id'];
                    }
                  }
                }
              }
              // 单个货架满足需求，退出循环
              if (flag) {
                break;
              }
            }
          }
          if (resultMapIn['result'] != null) {
            resultList.add(resultMapIn);
          }
        }
      }
    }
    return resultList;
  }
}
