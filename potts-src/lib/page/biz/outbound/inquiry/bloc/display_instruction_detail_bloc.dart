import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:wms/common/config/config.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'display_instruction_detail_modle.dart';

/**
 * 内容：出荷指示照会-BLOC
 * 作者：熊草云
 * 时间：2023/09/07
 */
// 事件
abstract class DisplayInstructionDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends DisplayInstructionDetailEvent {
  // 初始化事件
  InitEvent();
}

// 引当
class ReservationShipLineEvent extends DisplayInstructionDetailEvent {
  List reservationList;
  // 结构树
  BuildContext context;
  ReservationShipLineEvent(this.reservationList, this.context);
}

// 删除荷指示表格事件
class DeleteShipEvent extends DisplayInstructionDetailEvent {
  // 结构树\
  int deleteId;
  // 删除荷指示表格事件
  DeleteShipEvent(this.deleteId);
}

class DeleteShipLineEvent extends DisplayInstructionDetailEvent {
  int deleteLineId;
  // 删除荷指示明细行事件
  DeleteShipLineEvent(
    this.deleteLineId,
  );
}

// 查询出荷指示明细事件
class QueryShipDetailEvent extends DisplayInstructionDetailEvent {
  // 出荷指示明细ID
  int shipDetailId;
  // 查询出荷指示明细事件
  QueryShipDetailEvent(this.shipDetailId);
}
// 自定义事件 - 终

class DisplayInstructionDetailBloc
    extends WmsTableBloc<DisplayInstructionDetailModel> {
  // 刷新补丁
  @override
  DisplayInstructionDetailModel clone(DisplayInstructionDetailModel src) {
    return DisplayInstructionDetailModel.clone(src);
  }

  DisplayInstructionDetailBloc(DisplayInstructionDetailModel state)
      : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 列表数据清空
      state.records.clear();
      // 查询出荷指示明细
      List<dynamic> dataDetail = await SupabaseUtils.getClient()
          .rpc('func_query_table_dtb_ship_inquiry_detial_line',
              params: {'p_ship_id': state.shipId})
          .select('*')
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 赵士淞 - 测试修复 2023/11/17 - 始
      double sumAll = 0;
      // 赵士淞 - 测试修复 2023/11/17 - 终
      int countAll = 0;
      // 循环出荷指示数据
      for (int i = 0; i < dataDetail.length; i++) {
        // 列表数据增加
        int sum = 0;
        // 赵士淞 - 测试修复 2023/11/17 - 始
        double size = 0;
        // 赵士淞 - 测试修复 2023/11/17 - 终
        if (dataDetail[i]['product_price'] != '' &&
            dataDetail[i]['product_price'] != null) {
          // 赵士淞 - 测试修复 2023/11/17 - 始
          size = double.parse(dataDetail[i]['product_price'].toString());
          // 赵士淞 - 测试修复 2023/11/17 - 终
        }
        if (dataDetail[i]['ship_num'] != '' &&
            dataDetail[i]['ship_num'] != null) {
          sum = dataDetail[i]['ship_num'];
        }
        dataDetail[i]['sum'] = sum * size;
        // 赵士淞 - 测试修复 2023/11/17 - 始
        sumAll = double.parse(dataDetail[i]['sum'].toString()) + sumAll;
        // 赵士淞 - 测试修复 2023/11/17 - 终
        countAll = sum + countAll;
        // 引当状態
        if (dataDetail[i]['lock_kbn'] == Config.LOCK_KBN_0) {
          dataDetail[i]['lock_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.lock_kbn_text_0;
        } else if (dataDetail[i]['lock_kbn'] == Config.LOCK_KBN_1) {
          dataDetail[i]['lock_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.lock_kbn_text_1;
        } else if (dataDetail[i]['lock_kbn'] == Config.LOCK_KBN_2) {
          dataDetail[i]['lock_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.lock_kbn_text_2;
        } else {
          dataDetail[i]['lock_kbn_name'] = '';
        }
        // 判断取込状態
        if (dataDetail[i]['importerror_flg'] == Config.NUMBER_ONE.toString()) {
          // 取込状態名称
          dataDetail[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_1;
        } else if (dataDetail[i]['importerror_flg'] ==
            Config.NUMBER_TWO.toString()) {
          // 取込状態名称
          dataDetail[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_2;
        } else if (dataDetail[i]['importerror_flg'] ==
            Config.NUMBER_THREE.toString()) {
          // 取込状態名称
          dataDetail[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_3;
        } else if (dataDetail[i]['importerror_flg'] ==
            Config.NUMBER_FOUR.toString()) {
          // 取込状態名称
          dataDetail[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_4;
        } else {
          // 取込状態名称
          dataDetail[i]['importerror_flg'] = '';
        }
        state.records.add(WmsRecordModel(i, dataDetail[i]));
      }
      state.sum = sumAll;
      state.count = countAll;
      // 查询出荷总数
      List<dynamic> count = await SupabaseUtils.getClient().rpc(
          'func_query_table_dtb_ship_inquiry_detial_line',
          params: {'p_ship_id': state.shipId}).select('*');
      // 总页数
      state.total = count.length;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除出荷指示表格数据
    on<DeleteShipEvent>((event, emit) async {
      // 执行删除操作
      try {
        await SupabaseUtils.getClient()
            .from('dtb_ship')
            .update({'del_kbn': Config.DELETE_YES}).eq('id', event.deleteId);
        // 赵士淞 - 测试修复 2023/11/16 - 始
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .instruction_input_table_title_10 +
            WMSLocalizations.i18n(state.context)!.delete_success);
        // 赵士淞 - 测试修复 2023/11/16 - 终
        GoRouter.of(state.context).pop('delete return');
      } catch (e) {
        // 赵士淞 - 测试修复 2023/11/16 - 始
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .instruction_input_table_title_10 +
            WMSLocalizations.i18n(state.context)!.delete_error);
        // 赵士淞 - 测试修复 2023/11/16 - 终
      }
      state.deleteSuccess = true;

      //列表清空
    });
    // 删除出荷指示明细表格数据
    on<DeleteShipLineEvent>((event, emit) async {
      // 执行删除操作
      try {
        await SupabaseUtils.getClient()
            .from('dtb_ship_detail')
            .update({'del_kbn': '1'}).eq('id', event.deleteLineId);
        // 赵士淞 - 测试修复 2023/11/16 - 始
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .instruction_input_table_operate_detail +
            WMSLocalizations.i18n(state.context)!.delete_success);
        // 赵士淞 - 测试修复 2023/11/16 - 终
      } catch (e) {
        // 删除失败
        // 赵士淞 - 测试修复 2023/11/16 - 始
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .instruction_input_table_operate_detail +
            WMSLocalizations.i18n(state.context)!.delete_error);
        // 赵士淞 - 测试修复 2023/11/16 - 终
      }
      // 触发查询事件，刷新页面
      add(PageQueryEvent());
    });

    // 查询出荷指示明细事件
    on<QueryShipDetailEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 查询出荷指示明细
      List<dynamic> shipDetailData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .eq('id', event.shipDetailId);
      state.shipDetail = shipDetailData[0];

      state.shipId = shipDetailData[0]['id'];
      // 更新
      emit(clone(state));
      // 关闭加载
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
        state.reFlag = 1;
        await SupabaseUtils.getClient().from('dtb_ship').update({
          'ship_kbn': '2',
        }).eq('id', shipId);
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
          state.reFlag = 2;
          await SupabaseUtils.getClient().from('dtb_ship').update({
            'ship_kbn': '0',
          }).eq('id', shipId);
          // 关闭加载
          BotToast.closeAllLoading();
          WMSCommonBlocUtils.tipTextTwoSecondToast(
              WMSLocalizations.i18n(state.context)!.delivery_note_14 +
                  '：${shipNo}  ' +
                  WMSLocalizations.i18n(state.context)!
                      .display_instruction_reservation_disappearance);
        }
      }
      //插入操作履历 sys_log表
      //出荷指示照会：引当
      CommonUtils().createLogInfo(
          Config.OPERATION_BUTTON_TEXT7 +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "Detail ReservationShipLineEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);
      // 刷新补丁
      emit(clone(state));
      // add(PageQueryEvent());
    });
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      add(PageQueryEvent());
      // BotToast.showLoading();
      // 查询出荷指示明细
      List<dynamic> shipDetailData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .eq('id', state.shipId);
      state.shipDetail = shipDetailData[0];

      state.shipId = shipDetailData[0]['id'];
      // 更新
      emit(clone(state));
      // 关闭加载
      // BotToast.closeAllLoading();
    });

    add(InitEvent());
  }

  // 赵士淞 - 始
  // 图片处理
  dynamic imageProcessing(dynamic dataDetail) async {
    // 打开加载状态
    BotToast.showLoading();
    try {
      if (dataDetail['image1'] != null && dataDetail['image1'] != '') {
        dataDetail['image1_real'] =
            await WMSCommonFile().previewImageFile(dataDetail['image1']);
      }
    } catch (e) {
      dataDetail['image1_real'] = '';
      // 关闭加载
      BotToast.closeAllLoading();
    }
    try {
      if (dataDetail['image2'] != null && dataDetail['image2'] != '') {
        dataDetail['image2_real'] =
            await WMSCommonFile().previewImageFile(dataDetail['image2']);
      }
    } catch (e) {
      dataDetail['image2_real'] = '';
      // 关闭加载
      BotToast.closeAllLoading();
    }
    // 关闭加载
    BotToast.closeAllLoading();
    return dataDetail;
  }
  // 赵士淞 - 终

  read() {}

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
