import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wms/common/utils/check_utils.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'display_instruction_modle.dart';

/**
 * 内容：出荷指示照会-BLOC
 * 作者：熊草云
 * 时间：2023/09/07
 */
// 事件
abstract class DisplayInstructionEvent extends TableListEvent {}

// 自定义事件 - 始
// 设定出荷指示值事件
class SetShipValueEvent extends DisplayInstructionEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetShipValueEvent(this.key, this.value);
}

// 查询出荷指示事件
class QueryShipEvent extends DisplayInstructionEvent {
  // 出荷指示
  String searchData;
  // 查询出荷指示事件
  QueryShipEvent(this.searchData);
// 初始化事件
}

// 初始化检索条件
class InitEvent extends DisplayInstructionEvent {
  // 初始化事件
  InitEvent();
}

//
class SetSearchShipStateEvent extends DisplayInstructionEvent {
  List<String> searchdataList;
  SetSearchShipStateEvent(this.searchdataList);
}

// 设置检索条件
class SetSearchEvent extends DisplayInstructionEvent {
  // 初始化事件
  String key;
  String searchData;
  int searchId;
  SetSearchEvent(this.searchId, this.key, this.searchData);
}

// 查询检索条件事件
class QuerySearchShipStateEvent extends DisplayInstructionEvent {
  // 出荷指示
  List<String> shipList;
  BuildContext context;
  // 查询出荷指示事件
  QuerySearchShipStateEvent(this.shipList, this.context);
}

// 查询出荷状态事件
class QueryShipStateEvent extends DisplayInstructionEvent {
  // 出荷指示
  List<String> shipStateList;
  int tabState;
  // 查询出荷指示事件
  QueryShipStateEvent(this.shipStateList, this.tabState);
}

// 引当
class ReservationShipLineEvent extends DisplayInstructionEvent {
  List reservationList;
  // 结构树
  BuildContext context;
  ReservationShipLineEvent(this.reservationList, this.context);
}

// 引当解除
class ReservationCancelShipLineEvent extends DisplayInstructionEvent {
  // 结构树
  BuildContext context;
  ReservationCancelShipLineEvent(this.context);
}

// SetDeleteIdEvent
class SetDeleteIdEvent extends DisplayInstructionEvent {
  // 结构树\  BuildContext context;
  Map<String, dynamic> deleteList;
  // 删除荷指示表格事件
  SetDeleteIdEvent(this.deleteList);
}

// 删除荷指示表格事件
class DeleteShipEvent extends DisplayInstructionEvent {
  // 结构树\  BuildContext context;
  int deleteId;
  // 删除荷指示表格事件
  DeleteShipEvent(this.deleteId);
}

// 印刷数据
class SetPrintingEvent extends DisplayInstructionEvent {
  SetPrintingEvent();
}

// 设置sort字段
class SetSortEvent extends DisplayInstructionEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class DisplayInstructionBloc extends WmsTableBloc<DisplayInstructionModel> {
  // 刷新补丁
  @override
  DisplayInstructionModel clone(DisplayInstructionModel src) {
    return DisplayInstructionModel.clone(src);
  }

  DisplayInstructionBloc(DisplayInstructionModel state) : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 打开加载状态
      List<dynamic> data;
      if (!state.flag && !state.reservationFlag) {
        BotToast.showLoading();
        if (!state.loadingFlag) {
          state.pageNum = 0;
          // 加载标记
          state.loadingFlag = true;
        }
      }
      state.flag = false;
      data = await SupabaseUtils.getClient()
          .rpc(
            'func_query_table_dtb_ship_inquiry',
            params: {
              'p_csv_kbn': state.csvKbn,
              'p_order_no': state.orderNo,
              'p_ship_no': state.shipNo,
              'p_customer_name': state.customerName,
              'p_rcv_sch_date1': state.rcvSchDate1,
              'p_rcv_sch_date2': state.rcvSchDate2,
              'p_name': state.consignee,
              'p_cus_rev_date1': state.cusRevDate1,
              'p_cus_rev_date2': state.cusRevDate2,
              'p_person': state.head,
              'p_importerror_flg': state.importerrorFlg,
              'p_product_name': state.productName,
              'p_ship_kbn': state.shipStateList,
              'p_keyword': state.keyword,
              'p_company_id': StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id,
            },
          )
          .select()
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);

      //列表清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        // 判断取込状態
        if (data[i]['importerror_flg'] == Config.NUMBER_ONE.toString()) {
          // 取込状態名称
          data[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_1;
        } else if (data[i]['importerror_flg'] == Config.NUMBER_TWO.toString()) {
          // 取込状態名称
          data[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_2;
        } else if (data[i]['importerror_flg'] ==
            Config.NUMBER_THREE.toString()) {
          // 取込状態名称
          data[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_3;
        } else if (data[i]['importerror_flg'] ==
            Config.NUMBER_FOUR.toString()) {
          // 取込状態名称
          data[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_4;
        } else if (data[i]['importerror_flg'] ==
            Config.NUMBER_FIVE.toString()) {
          // 取込状態名称
          data[i]['importerror_flg'] =
              WMSLocalizations.i18n(state.context)!.importerror_flg_text_5;
        } else {
          // 取込状態名称
          data[i]['importerror_flg'] = '';
        }

        if (data[i]['ship_kbn'] == Config.NUMBER_ZERO.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_1;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_ONE.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_2;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_TWO.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_3;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_THREE.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_4;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_FOUR.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_5;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_FIVE.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_6;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_SIX.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_7;
        } else if (data[i]['ship_kbn'] == Config.NUMBER_SEVEN.toString()) {
          // 出荷状態名称
          data[i]['ship_kbn_name'] =
              WMSLocalizations.i18n(state.context)!.ship_kbn_text_8;
        } else {
          // 出荷状態名称
          data[i]['ship_kbn_name'] = '';
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 查询出荷总数
      List<dynamic> dataLength = await pageTotalNumber(
          state, ['0', '1', '2', '3', '4', '5', '6', '7']);
      state.tabCount1 = dataLength.length;
      state.tabCount2 =
          dataLength.where((data) => data['ship_kbn'] == '1').length;
      state.tabCount3 =
          dataLength.where((data) => data['ship_kbn'] == '2').length;
      state.tabCount4 = dataLength
          .where((data) => ['3', '4', '5', '6'].contains(data['ship_kbn']))
          .length;
      state.tabCount5 =
          dataLength.where((data) => data['ship_kbn'] == '7').length;

      //总件数修正
      state.total = state.tabCount1;
      if (state.shipStateList != null) {
        if (state.shipStateList?.length == 1) {
          if (state.shipStateList?[0] == '1') {
            state.total = state.tabCount2;
          } else if (state.shipStateList?[0] == '2') {
            state.total = state.tabCount3;
          } else if (state.shipStateList?[0] == '7') {
            state.total = state.tabCount5;
          }
        } else if (state.shipStateList?.length == 4) {
          state.total = state.tabCount4;
        }
      }
      // 刷新补丁

      // 关闭加载

      BotToast.closeAllLoading();
      if (state.reservationFlag && state.reservationState) {
        WMSCommonBlocUtils.tipTextTwoSecondToast(
            WMSLocalizations.i18n(state.context)!
                .display_instruction_reservation_success);
        if (state.reservationLimitFlag == 2) {
          Future.delayed(Duration(seconds: 2), () {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!.delivery_note_14 +
                    '：${state.reservationID}  ' +
                    WMSLocalizations.i18n(state.context)!
                        .display_instruction_message3);
          });
        }
      }
      if (state.reservationFlag && !state.reservationState) {
        if (state.reservationLimitFlag == 1) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.delivery_note_14 +
                  '：${state.reservationID}  ' +
                  WMSLocalizations.i18n(state.context)!
                      .display_instruction_message2);
        } else {
          WMSCommonBlocUtils.tipTextTwoSecondToast(
              WMSLocalizations.i18n(state.context)!.delivery_note_14 +
                  '：${state.reservationID}  ' +
                  WMSLocalizations.i18n(state.context)!
                      .display_instruction_reservation_disappearance);
        }
      }
      state.reservationFlag = false;
      emit(clone(state));
    });
    // 查询出荷指示表格数据
    on<QueryShipEvent>((event, emit) async {
      state.keyword = event.searchData;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });
//
    on<SetSearchShipStateEvent>((event, emit) async {
      state.searchdataList = event.searchdataList;
    });
    // 初始化事件
    on<InitEvent>((event, emit) async {
      BotToast.showLoading();
      state.flag = true;
      // 查询客户
      List<dynamic> customerNames = await SupabaseUtils.getClient()
          .from('mtb_customer')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO)
          .gte('application_end_date',
              DateFormat('yyyy-MM-dd').format(DateTime.now()))
          .lte('application_start_date',
              DateFormat('yyyy-MM-dd').format(DateTime.now()));
      ;
      // 得意先列表
      state.customerList = customerNames;
      // 纳入先列表
      List<dynamic> customerAddressData = await SupabaseUtils.getClient()
          .from('mtb_customer_address')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO);
      // 纳入先列表
      state.nameList = customerAddressData;
      // 担当者
      List<dynamic> personData = await SupabaseUtils.getClient()
          .from('mtb_customer_address')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO);
      // 仓库列表
      state.personList = personData;
      // 查询商品事件
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.context)
                  .state
                  .loginUser
                  ?.company_id)
          .eq('del_kbn', Config.DELETE_NO);
      // 商品列表
      state.productList = productData;
      // state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // SetSearchEvent 检索条件
    on<SetSearchEvent>((event, emit) async {
      Map<String, dynamic> shipTemp = Map<String, dynamic>();
      shipTemp.addAll(state.customer);
      shipTemp[event.key] = event.searchData;
      if (event.searchId == 0) {
        state.customer = shipTemp;
      } else if (event.searchId == 1) {
        Map<String, dynamic> shipTemp = Map<String, dynamic>();
        shipTemp.addAll(state.customer);
        shipTemp[event.key] = event.searchData;
        state.name = shipTemp;
      } else if (event.searchId == 2) {
        state.person = shipTemp;
      } else {
        state.product = shipTemp;
      }
      emit(clone(state));
    });

// QueryShipStateEvent tab状态
    on<QueryShipStateEvent>((event, emit) async {
      // 打开加载状态
      state.tabState = event.tabState;
      state.shipStateList = event.shipStateList;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 检索条件
    on<QuerySearchShipStateEvent>((event, emit) async {
      // 打开加载状态
      List<String>? csvKbn;
      String? orderNo;
      String? shipNo;
      String? customerName;
      String? rcvSchDate1;
      String? rcvSchDate2;
      String? consignee;
      String? cusRevDate1;
      String? cusRevDate2;
      String? head;
      String? importerrorFlg;
      String? productName;
      for (int i = 0; i < event.shipList.length; i++) {
        List<String> parts = event.shipList[i].split("：");
        String key = parts[0];
        String value = parts[1];
        if (key == WMSLocalizations.i18n(event.context)!.delivery_note_12) {
          List<String> In = [];
          List<String> partss = value.split(",");
          for (int i = 0; i < partss.length; i++) {
            if (partss[i] ==
                WMSLocalizations.i18n(state.context)!.delivery_note_4) {
              In.addAll(['1']);
            } else if (partss[i] ==
                WMSLocalizations.i18n(state.context)!.delivery_note_5) {
              In.addAll(['2']);
            }
          }
          // ignore: unnecessary_null_comparison
          if (!In.isEmpty && In != null) {
            List<String> Out = In.toSet().toList();
            csvKbn = Out;
          }
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_13) {
          orderNo = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_14) {
          shipNo = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_15) {
          customerName = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_16) {
          if (value.contains('-')) {
            List<String> partsDate = value.split("-");
            rcvSchDate1 = partsDate[0];
            rcvSchDate2 = partsDate[1];
          } else {
            if (value.contains('^')) {
              rcvSchDate1 = value.replaceAll('^', '');
            } else {
              rcvSchDate2 = value;
            }
          }
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_17) {
          consignee = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_18) {
          if (value.contains('-')) {
            List<String> partsDatee = value.split("-");
            rcvSchDate1 = partsDatee[0];
            rcvSchDate2 = partsDatee[1];
          } else {
            if (value.contains('^')) {
              cusRevDate1 = value.replaceAll('^', '');
            } else {
              cusRevDate2 = value;
            }
          }
        } else if (key ==
            WMSLocalizations.i18n(event.context)!.delivery_note_19) {
          head = value;
        } else if (key ==
            WMSLocalizations.i18n(event.context)!
                .display_instruction_ingestion_state) {
          List<String> partss = value.split(",");
          for (int i = 0; i < partss.length; i++) {
            if (partss[i] ==
                WMSLocalizations.i18n(state.context)!.importerror_flg_query_1) {
              importerrorFlg = '1';
            } else if (partss[i] ==
                WMSLocalizations.i18n(state.context)!.importerror_flg_query_2) {
              importerrorFlg = '2';
            }
          }
        } else {
          productName = value;
        }
      }
      state.csvKbn = csvKbn;
      state.orderNo = orderNo;
      state.shipNo = shipNo;
      state.customerName = customerName;
      state.rcvSchDate1 = rcvSchDate1;
      state.rcvSchDate2 = rcvSchDate2;
      state.consignee = consignee;
      state.cusRevDate1 = cusRevDate1;
      state.cusRevDate2 = cusRevDate2;
      state.head = head;
      state.importerrorFlg = importerrorFlg;
      state.productName = productName;
      state.sreachFlag = false;
      state.loadingFlag = false;
      add(PageQueryEvent());
    });

    // 引当
    on<ReservationShipLineEvent>((event, emit) async {
      // 打开加载状
      BotToast.showLoading();
      List<String> shipIdList = [];
      String shipNo = '';
      int i = 0;
      int j = 0;
      int k = 0;
      state.checkedRecords().forEach((record) {
        shipNo = record.data['ship_no'].toString();
        String shipId = record.data['id'].toString();
        shipIdList.add(shipId);
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
          // 以表【dtb_ship_detail(出荷指示明細)】为单位循环处理
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
              // 锁定库存数
              int ship_count = data[j]['ship_num'];
              // 单个货架满足锁库存需求flg
              bool flag = false;
              // 在库位置没有商品 引当失败
              // ignore: unnecessary_null_comparison
              if (dataLocation == null || dataLocation.length == 0) {
                ship_flag = false;
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
                  // 锁定库存
                  await SupabaseUtils.getClient()
                      .from('dtb_product_location')
                      .update({
                    'lock_stock': dataLocation[k]['lock_stock'] + ship_sum
                  }).eq('id', dataLocation[k]['id']);
                  //当前锁定库存数
                  ship_count = ship_sum;
                  // 当前剩余需要锁定库存数
                  ship_sum -= ship;
                  flag = true;
                } else {
                  // 当前货架库存数 <= 出荷指示数
                  // 锁定库存
                  await SupabaseUtils.getClient()
                      .from('dtb_product_location')
                      .update({'lock_stock': dataLocation[k]['stock']}).eq(
                          'id', dataLocation[k]['id']);
                  // 当前剩余需要锁定库存数
                  ship_sum -= ship;
                  //当前锁定库存数
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
                      .id!,
                  'update_time': updataTime,
                  'update_id': StoreProvider.of<WMSState>(state.context)
                      .state
                      .loginUser!
                      .id!,
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
                // 库存数量>0，锁定了库存才能插入数据
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
                // 更新明细仓库名（同一商品更新一次）
                if (k == 0) {
                  await SupabaseUtils.getClient()
                      .from('dtb_ship_detail')
                      .update({'warehouse_no': warehouse[0]['name']}).eq(
                          'id', data[j]['id']);
                }
                // 单个货架满足需求，退出循环
                if (flag) {
                  break;
                }
              }
              // 判断所有货架的商品库存是否能够提供足够商品来锁定库存
              if (ship_sum > 0) {
                // 引当不足
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
              //【出荷指示数】>【当前库存件数】的场合, 引当不足
              await SupabaseUtils.getClient().from('dtb_ship_detail').update({
                'lock_kbn': '2',
              }).eq('id', data[j]['id']);
              ship_flag = false;
            }
          }
        }
        if (limit_flag != 1) {
          if (ship_flag) {
            //引当成功
            await SupabaseUtils.getClient().from('dtb_ship').update({
              'ship_kbn': '2',
            }).eq('id', shipIdList[i]);
          } else {
            //引当失败
            await SupabaseUtils.getClient().from('dtb_ship').update({
              'ship_kbn': '0',
            }).eq('id', shipIdList[i]);
            break;
          }
        }
      }

      if (ship_flag) {
        // 消息提示
        state.reservationState = true;
        if (limit_flag == 2) {
          state.reservationID = shipNo;
          state.reservationLimitFlag = 2;
        }
      } else {
        // 关闭加载
        state.reservationID = shipNo;
        state.reservationState = false;
        if (limit_flag == 1) {
          state.reservationLimitFlag = 1;
        } else if (limit_flag == 2) {
          state.reservationLimitFlag = 2;
        }
      }
      state.reservationFlag = true;
      state.loadingFlag = false;
      //插入操作履历 sys_log表
      //出荷指示照会：引当
      CommonUtils().createLogInfo(
          Config.OPERATION_BUTTON_TEXT7 +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "ReservationShipLineEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);

      // 刷新补丁
      emit(clone(state));
      add(PageQueryEvent());
    });

    // 引当解除
    on<ReservationCancelShipLineEvent>((event, emit) async {
      // 打开加载状
      BotToast.showLoading();
      List<String> shipIdList = [];
      int i = 0;
      int j = 0;
      int k = 0;
      state.checkedRecords().forEach((record) {
        String shipId = record.data['id'].toString();
        shipIdList.add(shipId);
      });
      if (shipIdList.length != 1) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(event.context)!.display_instruction_message1);
        BotToast.closeAllLoading();
        return;
      }

      for (i = 0; i < shipIdList.length; i++) {
        //  1表【dtb_ship_detail（出荷指示明細）】の単位でサイクル処理
        List<dynamic> detailList = await SupabaseUtils.getClient()
            .from('dtb_ship_detail')
            .select('*')
            .eq('ship_id', shipIdList[i])
            .eq('del_kbn', '2');
        // ignore: unnecessary_null_comparison
        if (detailList == null || detailList.length == 0) {
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.Inventory_Confirmed_tip_12);
          return;
        }
        for (j = 0; j < detailList.length; j++) {
          //  1-1 表【dtb_ship_detail（出荷指示明細）】更新すする
          //  項目：【引当数量】【引当済】【出荷倉庫】【ロケーションid】【出庫済数量】【出庫済】【検品済数量】【検品済】【梱包済数量】【梱包済】【出荷確定】
          await SupabaseUtils.getClient().from('dtb_ship_detail').update({
            'warehouse_no': null,
            'location_id': null,
            'lock_num': null,
            'store_num': null,
            'check_num': null,
            'packing_num': null,
            'lock_kbn': '0',
            'store_kbn': '2',
            'check_kbn': '2',
            'packing_kbn': '2',
            'confirm_kbn': '2'
          }).eq('id', detailList[j]['id']);
          //  1-2 表【dtb_store（在庫）】更新すする
          //  項目：【ロック数】：元ロック数-出荷指示数
          // 查询在库
          List<dynamic> storeList = await SupabaseUtils.getClient()
              .from('dtb_store')
              .select('*')
              .eq('product_id', detailList[j]['product_id'])
              .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
              .eq(
                  'company_id',
                  StoreProvider.of<WMSState>(state.context)
                      .state
                      .loginUser
                      ?.company_id as int);
          // ignore: unnecessary_null_comparison
          if (storeList == null || storeList.length == 0) {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!
                    .Inventory_Confirmed_tip_12);
            return;
          }

          await SupabaseUtils.getClient()
              .from('dtb_store')
              .update({
                'lock_stock':
                    storeList[0]['lock_stock'] - detailList[j]['ship_num']
              })
              .eq('product_id', detailList[j]['product_id'])
              .eq('year_month', DateFormat('yyyyMM').format(DateTime.now()))
              .eq(
                  'company_id',
                  StoreProvider.of<WMSState>(state.context)
                      .state
                      .loginUser
                      ?.company_id as int);

          //  1-3 dtb_ship_detail（出荷指示明細）の【出荷指示明細行No】により、テーブル【dtb _rev_ship_location（商品入出荷位置）】のデータを検索する
          List<dynamic> revShipLocationDataList =
              await SupabaseUtils.getClient()
                  .from('dtb_rev_ship_location')
                  .select('*')
                  .eq('rev_ship_line_no', detailList[j]['ship_line_no'])
                  .eq('rev_ship_kbn', '2');
          // ignore: unnecessary_null_comparison
          if (revShipLocationDataList == null ||
              revShipLocationDataList.length == 0) {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!
                    .Inventory_Confirmed_tip_12);
            return;
          }
          //  1-3-1 表【dtb_rev_ship_location（商品入出荷位置）】の単位でサイクル処理
          for (k = 0; k < revShipLocationDataList.length; k++) {
            List<dynamic> dataLocation = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('product_id', detailList[j]['product_id'])
                .eq('location_id',
                    revShipLocationDataList[k]['product_location_id']);
            //  1-3-1-1 更新表：dtb_product_location（商品在庫位置）
            //    項目：【ロック数】=元ロック数- dtb_rev_ship_location（商品入出荷位置）の入/出庫数
            //          条件：【商品ID】= dtb_ship_detail（出荷指示明細）の商品ID
            //    　　　【ロケーションid】=dtb_rev_ship_location（商品入出荷位置）の商品ロケーションid
            // ignore: unnecessary_null_comparison
            if (dataLocation == null || dataLocation.length == 0) {
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .Inventory_Confirmed_tip_12);
              return;
            }
            await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .update({
              'lock_stock': dataLocation[0]['lock_stock'] -
                  revShipLocationDataList[k]['stock']
            }).eq('id', dataLocation[0]['id']);
            //  1-3-1-2 削除表；dtb_rev_ship_location（商品入出荷位置）
            await SupabaseUtils.getClient()
                .from('dtb_rev_ship_location')
                .delete()
                .eq('id', revShipLocationDataList[k]['id']);
          }
        }
        //  2 表【dtb_pick_list(ピッキングリスト)】のデータを削除する。
        //   条件：【出荷指示ID】=出荷指示ID
        await SupabaseUtils.getClient()
            .from('dtb_pick_list')
            .delete()
            .eq('ship_id', shipIdList[i]);
        //  3 表【dtb_ship(出荷指示)】更新すする
        //    項目：【出荷状態】=引当待ち
        //    【ピッキングリスト出力済】=2:OFF(default)
        //    【納品書出力】=1:未出力
        await SupabaseUtils.getClient()
            .from('dtb_ship')
            .update({'ship_kbn': '1', 'pick_list_kbn': '2', 'pdf_kbn': '1'})
            .eq('id', shipIdList[i])
            .select('*');
      }
      //  4プロンプト結果メッセージ
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(event.context)!
          .display_instruction_reservation_cancel_success);

      state.loadingFlag = false;
      //插入操作履历 sys_log表
      //出荷指示照会：引当解除
      CommonUtils().createLogInfo(
          Config.OPERATION_BUTTON_TEXT7_1 +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT4 +
              Config.OPERATION_TEXT2,
          "ReservationCancelShipLineEvent()",
          StoreProvider.of<WMSState>(event.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(event.context).state.loginUser!.id);

      // 刷新补丁
      emit(clone(state));
      add(PageQueryEvent());
    });

    // 删除出荷指示表格数据
    on<DeleteShipEvent>((event, emit) async {
      // 出荷状態は【1:引当待ち 】の場合、削除可能
      if (state.deleteList['ship_kbn'] != Config.NUMBER_ONE.toString()) {
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.display_instruction_tip1);
        return;
      }
      try {
        await SupabaseUtils.getClient()
            .from('dtb_ship')
            .update({'del_kbn': '1'}).eq('id', event.deleteId);
        // 赵士淞 - 测试修复 2023/11/16 - 始
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .instruction_input_table_title_10 +
            WMSLocalizations.i18n(state.context)!.delete_success);
        // 赵士淞 - 测试修复 2023/11/16 - 终
      } catch (e) {
        // 赵士淞 - 测试修复 2023/11/16 - 始
        WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                .instruction_input_table_title_10 +
            WMSLocalizations.i18n(state.context)!.delete_error);
        // 赵士淞 - 测试修复 2023/11/16 - 终
      }
      state.loadingFlag = false;
      emit(clone(state));
      add(PageQueryEvent());
    });
    // SetDeleteIdEvent
    on<SetDeleteIdEvent>((event, emit) async {
      // 执行删除操作
      state.deleteList = event.deleteList;
      emit(clone(state));
    });
    // 印刷
    on<SetPrintingEvent>((event, emit) async {
      List<Map<String, dynamic>> printValueListt = [];
      state.checkedRecords().forEach((record) {
        Map<String, dynamic> printValue = Map.from(record.data);
        printValueListt.add(printValue);
      });
      state.printValueList = printValueListt;
    });
    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(InitEvent());
  }
// 查询总数量
  Future<List<dynamic>> pageTotalNumber(
      DisplayInstructionModel state, List<String> shipKbn) async {
    // 查询入荷予定照会总数
    List<dynamic> count;
    count = await SupabaseUtils.getClient().rpc(
      'func_query_table_dtb_ship_inquiry',
      params: {
        'p_csv_kbn': state.csvKbn,
        'p_order_no': state.orderNo,
        'p_ship_no': state.shipNo,
        'p_customer_name': state.customerName,
        'p_rcv_sch_date1': state.rcvSchDate1,
        'p_rcv_sch_date2': state.rcvSchDate2,
        'p_name': state.consignee,
        'p_cus_rev_date1': state.cusRevDate1,
        'p_cus_rev_date2': state.cusRevDate2,
        'p_person': state.head,
        'p_importerror_flg': state.importerrorFlg,
        'p_product_name': state.productName,
        'p_ship_kbn': shipKbn,
        'p_keyword': state.keyword,
        'p_company_id': StoreProvider.of<WMSState>(state.context)
            .state
            .loginUser
            ?.company_id,
      },
    ).select();
    // 返回
    return count;
  }

  //检索前check处理
  bool selectBeforeCheck(BuildContext context, String orderNo, String shipNo) {
    //检索条件check
    // 得意先注文番号 半角英数
    if (orderNo != '') {
      if (CheckUtils.check_Half_Alphanumeric(orderNo)) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.delivery_note_13 +
                WMSLocalizations.i18n(context)!.input_letter_and_number_check);
        return false;
      }
    }
    // 出荷指示番号 半角英数記号
    if (shipNo != '') {
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
