import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/utils/check_utils.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'lack_goods_invoice_model.dart';
import 'package:bot_toast/bot_toast.dart';

/**
 * 内容：欠品伝票照会-BLOC
 * 作者：熊草云
 * 时间：2023/09/18
 */
// 事件
abstract class LackGoodsInvoiceEvent extends TableListEvent {}

class SetShipPrintingEvent extends LackGoodsInvoiceEvent {
  // 设定值事件
  SetShipPrintingEvent();
}

// 设置检索条件
class SetSearchEvent extends LackGoodsInvoiceEvent {
  // 初始化事件
  String searchData;
  int searchId;
  SetSearchEvent(this.searchId, this.searchData);
}

// 初始化检索条件
class InitEvent extends LackGoodsInvoiceEvent {
  // 初始化事件
  InitEvent();
} // 查询出荷指示事件

class SetTabEvent extends LackGoodsInvoiceEvent {
  // 出荷指示
  // 查询出荷指示事件
  int tab;
  SetTabEvent(this.tab);
// 初始化事件
}

class SetQueryShipEvent extends LackGoodsInvoiceEvent {
  Map searchData;
  SetQueryShipEvent(this.searchData);
}

// 查询商品一览状态事件
class QueryShipStateEvent extends LackGoodsInvoiceEvent {
  // 商品一览
  // 查询商品一览事件
  BuildContext context;
  QueryShipStateEvent(this.context);
}

// 引当
class ReservationShipLineEvent extends LackGoodsInvoiceEvent {
  // 结构树
  BuildContext context;
  ReservationShipLineEvent(this.context);
}

// 设置sort字段
class SetSortEvent extends LackGoodsInvoiceEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终
class LackGoodsInvoiceBloc extends WmsTableBloc<LackGoodsInvoiceModel> {
  // 刷新补丁
  @override
  LackGoodsInvoiceModel clone(LackGoodsInvoiceModel src) {
    return LackGoodsInvoiceModel.clone(src);
  }

  LackGoodsInvoiceBloc(LackGoodsInvoiceModel state) : super(state) {
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (!state.loadingFlag) {
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      // 清空table
      state.records.clear();
      // 执行查询操作
      List<dynamic> data;
      // 欠品
      List<dynamic> dataOut = await SupabaseUtils.getClient()
          .rpc(
            'func_query_table_dtb_ship_lack_goods_search',
            params: {
              'p_ship_no': state.searchList['p_ship_no'] == ''
                  ? null
                  : state.searchList['p_ship_no'],
              'p_rcv_sch_date1': state.searchList['p_rcv_sch_date1'] == ''
                  ? null
                  : state.searchList['p_rcv_sch_date1'],
              'p_rcv_sch_date2': state.searchList['p_rcv_sch_date2'] == ''
                  ? null
                  : state.searchList['p_rcv_sch_date2'],
              'p_user': StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int,
            },
          )
          .select()
          .order(state.sortCol1, ascending: state.ascendingFlg1)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 商品一览
      List<dynamic> dataProduct = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_store_lack_goods_store', params: {
            'p_product_name': state.searchList['p_product_name'] == ''
                ? null
                : state.searchList['p_product_name'],
            'p_user': StoreProvider.of<WMSState>(state.context)
                .state
                .loginUser
                ?.company_id as int
          })
          .select()
          .order(state.sortCol2, ascending: state.ascendingFlg2)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      data = state.searchFlag == Config.NUMBER_ZERO ? dataOut : dataProduct;
      state.records.clear();
      for (int i = 0; i < data.length; i++) {
        // 赵士淞 - 测试修复 2023/11/16 - 始
        data[i]['rcv_sch_date'] =
            data[i]['rcv_sch_date'] != null && data[i]['rcv_sch_date'] != ''
                ? data[i]['rcv_sch_date'].toString().substring(0, 10)
                : '';
        data[i]['cus_rev_date'] =
            data[i]['cus_rev_date'] != null && data[i]['cus_rev_date'] != ''
                ? data[i]['cus_rev_date'].toString().substring(0, 10)
                : '';
        // 赵士淞 - 测试修复 2023/11/16 - 终
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 总页数
      List<dynamic> count1 = await SupabaseUtils.getClient().rpc(
        'func_query_table_dtb_ship_lack_goods_search',
        params: {
          'p_ship_no': state.searchList['p_ship_no'] == ''
              ? null
              : state.searchList['p_ship_no'],
          'p_rcv_sch_date1': state.searchList['p_rcv_sch_date1'] == ''
              ? null
              : state.searchList['p_rcv_sch_date1'],
          'p_rcv_sch_date2': state.searchList['p_rcv_sch_date2'] == ''
              ? null
              : state.searchList['p_rcv_sch_date2'],
          'p_user': StoreProvider.of<WMSState>(state.context)
              .state
              .loginUser
              ?.company_id as int,
        },
      ).select();
      List<dynamic> count2 = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_store_lack_goods_store', params: {
        'p_product_name': state.searchList['p_product_name'] == ''
            ? null
            : state.searchList['p_product_name'],
        'p_user': StoreProvider.of<WMSState>(state.context)
            .state
            .loginUser
            ?.company_id as int
      }).select();
      if (state.searchFlag != Config.NUMBER_ZERO) {
        for (int i = 0; i < dataProduct.length; i++) {
          try {
            // ignore: unnecessary_null_comparison
            if (dataProduct[i]['image1'] != null &&
                dataProduct[i]['image1'] != '') {
              dataProduct[i]['image1'] = await WMSCommonFile()
                  .previewImageFile(dataProduct[i]['image1']);
            }
          } catch (e) {
            dataProduct[i]['image1'] = '';
          }
          try {
            // ignore: unnecessary_null_comparison
            if (dataProduct[i]['image2'] != null &&
                dataProduct[i]['image2'] != '') {
              dataProduct[i]['image2'] = await WMSCommonFile()
                  .previewImageFile(dataProduct[i]['image2']);
            }
          } catch (e) {
            dataProduct[i]['image2'] = '';
          }
        }
      }
      // 总页数
      state.total = state.searchFlag == Config.NUMBER_ZERO
          ? count1.length
          : count2.length;
      state.tab1 = count1.length;
      state.tab2 = count2.length;
      // 刷新补丁
      emit(clone(state));
      BotToast.closeAllLoading();
    });

    on<SetSearchEvent>((event, emit) async {
      if (event.searchId == 0) {
        state.shipno = event.searchData;
      } else {
        state.product = event.searchData;
      }
      emit(clone(state));
    });

    // 查询欠品伝票照会检索数据
    on<SetTabEvent>((event, emit) async {
      state.searchFlag = event.tab;
      state.shipState = event.tab;
      emit(clone(state));
      if (state.searchList.length != 0 &&
          state.searchList != {} &&
          // ignore: unnecessary_null_comparison
          state.searchList != null) {
        state.loadingFlag = false;
        add(PageQueryEvent());
      }
    });
    on<SetQueryShipEvent>((event, emit) async {
      state.searchList = event.searchData;
      emit(clone(state));
    });
    // 引当
    on<ReservationShipLineEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      List<String> shipIdList = [];
      List<String> shipKbnList = [];
      String shipNo = '';
      int i = 0;
      int j = 0;
      int k = 0;
      state.checkedRecords().forEach((record) {
        shipNo = record.data['ship_no'].toString();
        String shipId = record.data['id'].toString();
        shipIdList.add(shipId);
      });

      state.checkedRecords().forEach((record) {
        String shipKbn = record.data['ship_kbn'].toString();
        shipKbnList.add(shipKbn);
      });
      bool ship_flag = true;
      int limit_flag = 0;
      if (shipIdList.length != 1) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.display_instruction_message1);
        BotToast.closeAllLoading();
        return;
      }
      for (i = 0; i < shipIdList.length; i++) {
        if (shipKbnList[i] == '1') {
          ship_flag = false;
          break;
        }
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_table_dtb_ship_inquiry_reservation', params: {
          'p_ship_id': shipIdList[i],
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
        List<dynamic> resCheck =
            await reservationBeforeCheck(shipIdList[i], data);
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
                if (flag) {
                  break;
                }
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
                    .eq('year_month',
                        DateFormat('yyyyMM').format(DateTime.now()))
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
        if (limit_flag != 1) {
          if (ship_flag) {
            // 引当成功
            await SupabaseUtils.getClient().from('dtb_ship').update({
              'ship_kbn': '2',
            }).eq('id', shipIdList[i]);
          } else {
            // 引当失败
            await SupabaseUtils.getClient().from('dtb_ship').update({
              'ship_kbn': '0',
            }).eq('id', shipIdList[i]);
            break;
          }
        }
      }
      if (ship_flag) {
        // 关闭加载
        BotToast.closeAllLoading();
        // 消息提示
        WMSCommonBlocUtils.tipTextTwoSecondToast(
            WMSLocalizations.i18n(event.context)!
                .display_instruction_reservation_success);
        if (limit_flag == 2) {
          Future.delayed(Duration(seconds: 2), () {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!.delivery_note_14 +
                    '：${shipNo}  ' +
                    WMSLocalizations.i18n(state.context)!
                        .display_instruction_message3);
          });
        }
      } else {
        if (limit_flag == 1) {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.delivery_note_14 +
                  '：${shipNo}  ' +
                  WMSLocalizations.i18n(state.context)!
                      .display_instruction_message2);
        } else {
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(event.context)!.delivery_note_14 +
                  '：${shipNo}  ' +
                  WMSLocalizations.i18n(event.context)!
                      .display_instruction_reservation_disappearance);
        }
      }
      state.loadingFlag = false;
      //插入操作履历 sys_log表
      CommonUtils().createLogInfo(
          Config.OPERATION_BUTTON_TEXT7 +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "欠品 ReservationShipLineEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);

      // 刷新补丁
      emit(clone(state));
      add(PageQueryEvent());
    });

    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 查询商品事件
      List<dynamic> shipData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('ship_no')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int)
          .eq('ship_kbn', Config.SHIP_KBN_ASSIGN_FAIL);
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id as int);
      // 商品列表
      state.shipnoList = shipData.fold([], (List<dynamic> acc, dynamic item) {
        var itemExists =
            acc.any((accItem) => accItem['ship_no'] == item['ship_no']);
        if (!itemExists) {
          acc.add(item);
        }
        return acc;
      });
      ;
      state.productList = productData;
      emit(clone(state));
      BotToast.closeAllLoading();
    });
    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      if (state.searchFlag == Config.NUMBER_ZERO) {
        state.sortCol1 = event.sortCol;
        state.ascendingFlg1 = event.asc;
      } else {
        state.sortCol2 = event.sortCol;
        state.ascendingFlg2 = event.asc;
      }
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    add(InitEvent());
  }

  //检索前check处理
  bool selectBeforeCheck(BuildContext context, String? shipNo) {
    //检索条件check
    // 出荷指示番号 半角英数記号
    if (shipNo != '' && shipNo != null) {
      if (CheckUtils.check_Half_Alphanumeric_Symbol(shipNo)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.delivery_note_14 +
                WMSLocalizations.i18n(context)!
                    .input_letter_and_number_and_symbol_check);
        return false;
      }
    }

    return true;
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
