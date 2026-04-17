import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/store_history.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_model.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/common_utils.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';

/**
 * 内容：出荷确定 -bloc
 * 作者：cuihr
 * 时间：2023/09/19
 */
//事件
abstract class ShipmentDeterminationEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ShipmentDeterminationEvent {
  // 初始化事件
  InitEvent();
}

// 表格数据
class QueryShipEvent extends ShipmentDeterminationEvent {
  String key;
  List<dynamic> list;
  QueryShipEvent(this.key, this.list);
}

// 设定出荷指示日事件
class SetShipSchDateEvent extends ShipmentDeterminationEvent {
  String schDate;
  SetShipSchDateEvent(this.schDate);
}

class SelectShipBySchDateEvent extends ShipmentDeterminationEvent {
// 结构树
  BuildContext context;
  SelectShipBySchDateEvent(this.context);
}

class foreachUpdateShipEvent extends ShipmentDeterminationEvent {
  String flag;
  // 结构树
  BuildContext context;
  foreachUpdateShipEvent(this.flag, this.context);
}

// 设置sort字段
class SetSortEvent extends ShipmentDeterminationEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class ShipmentDeterminationBloc
    extends WmsTableBloc<ShipmentDeterminationModel> {
  //刷新补丁
  @override
  ShipmentDeterminationModel clone(ShipmentDeterminationModel src) {
    return ShipmentDeterminationModel.clone(src);
  }

  ShipmentDeterminationBloc(ShipmentDeterminationModel state) : super(state) {
    // 检索条件
    //出荷状态 6：出荷確定待ち 7：出荷済み
    String six = Config.SHIP_KBN_WAIT_SHIPMENT_CONFIRM;
    String seven = Config.SHIP_KBN_SHIPPED;
    List<dynamic> list = [six, seven];

    //初始化事件
    on<InitEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );
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
      // 查询未确定个数
      var query1 = SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .eq('ship_kbn', six);
      query1 = setSelectConditions(state.rcvSchDate, query1);
      //查询已确定个数
      var query2 = SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .eq('ship_kbn', seven);
      query2 = setSelectConditions(state.rcvSchDate, query2);
      //查询已确定个数
      var query3 = SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .in_('ship_kbn', ['6', '7']);
      query3 = setSelectConditions(state.rcvSchDate, query3);
      List<dynamic> shipCount1 = await query1.order('id', ascending: true);
      List<dynamic> shipCount2 = await query2.order('id', ascending: true);
      List<dynamic> shipCount3 = await query3.order('id', ascending: true);
      state.count1 = shipCount1.length;
      state.count2 = shipCount2.length;
      state.count3 = shipCount3.length;
      // state.total = shipCount3.length;
      // 查询出荷指示
      var query = SupabaseUtils.getClient()
          .from("dtb_ship")
          .select('*')
          .in_('ship_kbn', list);
      query = setSelectConditions(state.rcvSchDate, query);
      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环出荷指示数据
      for (int i = 0; i < data.length; i++) {
        if (data[i]['ship_kbn'] != null && data[i]['ship_kbn'] != '') {
          data[i]['ship_kbn_meg'] =
              data[i]['ship_kbn'] == '6' ? '出荷確定待ち' : '出荷済み';
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
      var queryCount = SupabaseUtils.getClient()
          .from('dtb_ship')
          .select(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          )
          .in_('ship_kbn', list);
      //设置检索条件
      queryCount = setSelectConditions(state.rcvSchDate, queryCount);
      final countResult = await queryCount;
      // 总页数
      state.total = countResult.count;
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // tab检索查询分页数据事件
    on<QueryShipEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        //tab选中
        list = event.list;
        state.currentIndex = int.tryParse(event.key)!;
        // // 刷新补丁
        // emit(clone(state));
        // 加载标记
        state.loadingFlag = false;
        add(PageQueryEvent());
      },
    );
    // 设定出荷指示日事件
    on<SetShipSchDateEvent>(
      (event, emit) async {
        state.rcvSchDate = event.schDate;
        // 刷新补丁
        emit(clone(state));
      },
    );
    on<SelectShipBySchDateEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        // // 刷新补丁
        // emit(clone(state));
        // 加载标记
        state.loadingFlag = false;
        add(PageQueryEvent());
      },
    );
    //一览表格内按钮（确定，取消）
    on<foreachUpdateShipEvent>(
      (event, emit) async {
        BotToast.showLoading();
        List<Map<String, dynamic>> shipIdList = [];
        //当前时间 出荷确定日
        String rcvRealDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        int updateId =
            StoreProvider.of<WMSState>(event.context).state.loginUser!.id!;
        String updateTime = DateTime.now().toString();
        int limit_flag = 0;
        try {
          state.checkedRecords().forEach(
            (element) {
              if (element.data['ship_kbn'] != '') {
                shipIdList.add(element.data);
              }
            },
          );
          //当event.flag = '1' 出荷状态【7:出荷済み】 ，'2'：【6:出荷確定待ち】循环更新dtb_ship(出荷指示表)

          for (int i = 0; i < shipIdList.length; i++) {
            //根据dtb_ship(出荷指示表)id 查出二级明细数据
            List<dynamic> detail = await SupabaseUtils.getClient()
                .from('dtb_ship_detail')
                .select('*')
                .eq('ship_id', shipIdList[i]['id']);
            if (detail.length > 0) {
              //确定的场合
              if (event.flag == '1') {
                // 得意先の消費期限のチェック
                List<dynamic> resCheck = await reservationBeforeCheck(
                    shipIdList[i]['id'].toString(), detail);
                if (resCheck.length > 0 && resCheck[0]['result'] == 1) {
                  limit_flag = 1;
                  // 关闭加载
                  BotToast.closeAllLoading();
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(event.context)!.delivery_note_14 +
                          '：${shipIdList[i]['ship_no']}  ' +
                          WMSLocalizations.i18n(event.context)!
                              .display_instruction_message2);
                  return;
                } else {
                  if (resCheck.length > 0 && resCheck[0]['result'] == 2) {
                    limit_flag = 2;
                  }
                }
              }

              for (int j = 0; j < detail.length; j++) {
                if (detail[j]['confirm_kbn'] != '' &&
                    detail[j]['confirm_kbn'] != null) {
                  // 赵士淞 - 始
                  //明细検品济数量
                  int num = detail[j]['check_num'] == '' ||
                          detail[j]['check_num'] == null
                      ? 0
                      : detail[j]['check_num'];
                  // 赵士淞 - 终
                  //确定按钮
                  if (event.flag == '1') {
                    //出荷确定状态 == 1：No
                    if (detail[j]['confirm_kbn'] == '1') {
                      continue;
                      //出荷确定状态 =2 :Off
                    } else if (detail[j]['confirm_kbn'] == '2' ||
                        detail[j]['confirm_kbn'] == null ||
                        detail[j]['confirm_kbn'] == '') {
                      //创建 dtb_store_history受払明細
                      Map<String, dynamic> formInfo = {};
                      StoreHistory history = StoreHistory.fromJson(formInfo);
                      history.rev_ship_line_no = detail[j]['ship_line_no'];
                      history.rev_ship_kbn = '1';
                      history.product_id = detail[j]['product_id'];
                      history.num = detail[j]['store_num'];
                      history.store_kbn = detail[j]['store_kbn'];
                      history.location_id = null;
                      history.note1 = detail[j]['note1'];
                      history.note2 = detail[j]['note2'];
                      history.company_id = state.companyId;
                      history.action_id = 7;
                      history.create_id =
                          StoreProvider.of<WMSState>(event.context)
                              .state
                              .loginUser
                              ?.id;
                      history.create_time = DateTime.now().toString();
                      //插入表 dtb_store_history受払明細
                      await SupabaseUtils.getClient()
                          .from('dtb_store_history')
                          .insert([history.toJson()]).select('*');
                      //查询dtb_store在库
                      List<dynamic> storeList = await SupabaseUtils.getClient()
                          .from('dtb_store')
                          .select('*')
                          .eq('product_id', detail[j]['product_id'])
                          .eq('year_month',
                              DateFormat('yyyyMM').format(DateTime.now()))
                          .eq('company_id', state.companyId);
                      //在库数
                      int stock = 0;
                      //ロック数
                      int lockStock = 0;
                      //出库数
                      int outStock = 0;
                      if (storeList.length > 0) {
                        for (var k = 0; k < storeList.length; k++) {
                          stock = storeList[k]['stock'] != null
                              ? storeList[k]['stock']
                              : 0;
                          lockStock = storeList[k]['lock_stock'] != null
                              ? storeList[k]['lock_stock']
                              : 0;
                          outStock = storeList[k]['out_stock'] != null
                              ? storeList[k]['out_stock']
                              : 0;
                          //更新dtb_store在库
                          await SupabaseUtils.getClient()
                              .from('dtb_store')
                              .update({
                                "stock": stock - num,
                                "lock_stock": lockStock - num,
                                "out_stock": outStock + num,
                                'update_id': updateId,
                                'update_time': updateTime
                              })
                              .eq('product_id', detail[j]['product_id'])
                              .eq('year_month',
                                  DateFormat('yyyyMM').format(DateTime.now()))
                              .eq('company_id', state.companyId);
                        }
                      }

                      //根据出荷指示明细行no 查找 商品入出荷位置
                      List<dynamic> location = await SupabaseUtils.getClient()
                          .from('dtb_rev_ship_location')
                          .select('*')
                          .eq('rev_ship_line_no', detail[j]['ship_line_no'])
                          .eq('rev_ship_kbn', '2');
                      // 商品入出荷位置的【入/出庫数】
                      int stockNum = 0;
                      if (location.length > 0) {
                        for (var w = 0; w < location.length; w++) {
                          stockNum = location[w]['stock'] != null
                              ? location[w]['stock']
                              : 0;
                          List<dynamic> productLocList =
                              await SupabaseUtils.getClient()
                                  .from('dtb_product_location')
                                  .select('*')
                                  .eq('location_id',
                                      location[w]['product_location_id'])
                                  .eq('product_id', detail[j]['product_id']);
                          if (productLocList.length > 0) {
                            //根据
                            // 【ロケーションid】=商品入出荷位置的【商品ロケーションid】
                            // 【商品ID】=出荷指示明細的【商品ID】
                            //修改 dtb_product_location(商品在庫位置)
                            for (var a = 0; a < productLocList.length; a++) {
                              await SupabaseUtils.getClient()
                                  .from('dtb_product_location')
                                  .update({
                                    'stock':
                                        productLocList[a]['stock'] - stockNum,
                                    'lock_stock': productLocList[a]
                                            ['lock_stock'] -
                                        stockNum,
                                    'update_id': updateId,
                                    'update_time': updateTime
                                  })
                                  .eq('location_id',
                                      location[w]['product_location_id'])
                                  .eq('product_id', detail[j]['product_id']);
                            }
                          }
                        }
                      }
                      //更新dtb_ship_detail明细表，将出荷确定状态改为 1：NO
                      await SupabaseUtils.getClient()
                          .from('dtb_ship_detail')
                          .update({
                        'confirm_kbn': '1',
                        'update_id': updateId,
                        'update_time': updateTime
                      }).eq('ship_id', detail[j]['ship_id']);
                    } else {
                      continue;
                    }
                    //取消
                  } else {
                    //出荷确定状态 = 2 :Off
                    if (detail[j]['confirm_kbn'] == '2') {
                      continue;
                      //出荷确定状态 == 1：No
                    } else if (detail[j]['confirm_kbn'] == '1' ||
                        detail[j]['confirm_kbn'] == null ||
                        detail[j]['confirm_kbn'] == '') {
                      //创建 dtb_store_history受払明細
                      Map<String, dynamic> formInfo = {};
                      StoreHistory history = StoreHistory.fromJson(formInfo);
                      history.rev_ship_line_no = detail[j]['ship_line_no'];
                      history.rev_ship_kbn = '2';
                      history.product_id = detail[j]['product_id'];
                      history.num = detail[j]['store_num'];
                      history.store_kbn = detail[j]['store_kbn'];
                      history.location_id = detail[j]['location_id'];
                      history.note1 = detail[j]['note1'];
                      history.note2 = detail[j]['note2'];
                      history.company_id = state.companyId;
                      //8:出荷確定取消
                      history.action_id = 8;
                      history.create_id =
                          StoreProvider.of<WMSState>(event.context)
                              .state
                              .loginUser
                              ?.id;
                      history.create_time = DateTime.now().toString();
                      //插入表 dtb_store_history受払明細
                      await SupabaseUtils.getClient()
                          .from('dtb_store_history')
                          .insert([history.toJson()]).select('*');
                      //查询dtb_store在库
                      List<dynamic> storeList = await SupabaseUtils.getClient()
                          .from('dtb_store')
                          .select('*')
                          .eq('product_id', detail[j]['product_id'])
                          .eq('year_month',
                              DateFormat('yyyyMM').format(DateTime.now()))
                          .eq('company_id', state.companyId);
                      //在库数
                      int stock = 0;
                      //ロック数
                      int lockStock = 0;
                      //出库数
                      int outStock = 0;
                      if (storeList.length > 0) {
                        for (var s = 0; s < storeList.length; s++) {
                          stock = storeList[s]['stock'] != null
                              ? storeList[s]['stock']
                              : 0;
                          lockStock = storeList[s]['lock_stock'] != null
                              ? storeList[s]['lock_stock']
                              : 0;
                          outStock = storeList[s]['out_stock'] != null
                              ? storeList[s]['out_stock']
                              : 0;
                          //更新dtb_store在库
                          await SupabaseUtils.getClient()
                              .from('dtb_store')
                              .update({
                                "stock": stock + num,
                                "lock_stock": lockStock + num,
                                "out_stock": outStock - num,
                                'update_id': updateId,
                                'update_time': updateTime
                              })
                              .eq('product_id', detail[j]['product_id'])
                              .eq('year_month',
                                  DateFormat('yyyyMM').format(DateTime.now()))
                              .eq('company_id', state.companyId);
                        }
                      }
                      //根据出荷指示明细行no 查找 商品入出荷位置
                      List<dynamic> location = await SupabaseUtils.getClient()
                          .from('dtb_rev_ship_location')
                          .select('*')
                          .eq('rev_ship_line_no', detail[j]['ship_line_no'])
                          .eq('rev_ship_kbn', '2');
                      int stockNum = 0;
                      // 商品入出荷位置的【入/出庫数】
                      if (location.length > 0) {
                        for (var l = 0; l < location.length; l++) {
                          stockNum = location[l]['stock'] != null
                              ? location[l]['stock']
                              : 0;
                          List<dynamic> productLocList =
                              await SupabaseUtils.getClient()
                                  .from('dtb_product_location')
                                  .select('*')
                                  .eq('location_id',
                                      location[l]['product_location_id'])
                                  .eq('product_id', detail[j]['product_id']);
                          if (productLocList.length > 0) {
                            //根据
                            // 【ロケーションid】=商品入出荷位置的【商品ロケーションid】
                            // 【商品ID】=出荷指示明細的【商品ID】
                            //修改 dtb_product_location(商品在庫位置)
                            for (var p = 0; p < productLocList.length; p++) {
                              await SupabaseUtils.getClient()
                                  .from('dtb_product_location')
                                  .update({
                                    'stock':
                                        productLocList[p]['stock'] + stockNum,
                                    'lock_stock': productLocList[p]
                                            ['lock_stock'] +
                                        stockNum,
                                    'update_id': updateId,
                                    'update_time': updateTime
                                  })
                                  .eq('location_id',
                                      location[l]['product_location_id'])
                                  .eq('product_id', detail[j]['product_id']);
                            }
                          }
                        }
                      }
                      //更新dtb_ship_detail明细表，将出荷确定状态改为 2 :Off
                      await SupabaseUtils.getClient()
                          .from('dtb_ship_detail')
                          .update({
                        'confirm_kbn': '2',
                        'update_id': updateId,
                        'update_time': updateTime
                      }).eq('ship_id', detail[j]['ship_id']);
                    } else {
                      continue;
                    }
                  }
                }
              }
              //更新出荷指示
              await SupabaseUtils.getClient().from('dtb_ship').update({
                'ship_kbn': event.flag == '1' ? '7' : '6',
                'rcv_real_date': event.flag == '1' ? rcvRealDate : null,
                'update_id': updateId,
                'update_time': updateTime
              }).eq('id', shipIdList[i]['id']);
              // 成功提示
              WMSCommonBlocUtils.successTextToast(event.flag == '1'
                  ? WMSLocalizations.i18n(event.context)!
                      .Inventory_Confirmed_tip_4
                  : WMSLocalizations.i18n(event.context)!
                      .Inventory_Confirmed_tip_8);
              if (event.flag == '1' && limit_flag == 2) {
                Future.delayed(Duration(seconds: 2), () {
                  WMSCommonBlocUtils.errorTextToast(
                      WMSLocalizations.i18n(event.context)!.delivery_note_14 +
                          '：${shipIdList[i]['ship_no']}  ' +
                          WMSLocalizations.i18n(event.context)!
                              .display_instruction_message3);
                });
              }
              //确定按钮
              if (event.flag == '1') {
                //插入操作履历 sys_log表
                CommonUtils().createLogInfo(
                    '出荷確定' +
                        Config.OPERATION_TEXT1 +
                        Config.OPERATION_BUTTON_TEXT5 +
                        Config.OPERATION_TEXT2,
                    "foreachUpdateShipEvent()",
                    StoreProvider.of<WMSState>(event.context)
                        .state
                        .loginUser!
                        .company_id,
                    StoreProvider.of<WMSState>(event.context)
                        .state
                        .loginUser!
                        .id);
              } else {
                //插入操作履历 sys_log表
                CommonUtils().createLogInfo(
                    '出荷確定' +
                        Config.OPERATION_TEXT1 +
                        Config.OPERATION_BUTTON_TEXT6 +
                        Config.OPERATION_TEXT2,
                    "foreachUpdateShipEvent()",
                    StoreProvider.of<WMSState>(event.context)
                        .state
                        .loginUser!
                        .company_id,
                    StoreProvider.of<WMSState>(event.context)
                        .state
                        .loginUser!
                        .id);
              }
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .Inventory_Confirmed_tip_12);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(event.flag == '1'
              ? WMSLocalizations.i18n(event.context)!.Inventory_Confirmed_tip_9
              : WMSLocalizations.i18n(event.context)!
                  .Inventory_Confirmed_tip_10);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );

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
  //自定义方法 - 始
  bool selectShipEventBefore(
      String index, BuildContext context, ShipmentDeterminationModel state) {
    List<Map<String, dynamic>> shipDataList = [];
    //确定
    state.checkedRecords().forEach(
      (element) {
        shipDataList.add(element.data);
      },
    );
    if (shipDataList.length > 0) {
      for (int i = 0; i < shipDataList.length; i++) {
        if (shipDataList[i]['ship_kbn'] != '') {
          //点击确定按钮check【6:出荷確定待ち】以外的场合
          if (shipDataList[i]['ship_kbn'] != '6' && index == '1') {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(context)!.ship_confirm_error);
            return false;
            //点击取消按钮check【7:出荷済み】以外的场合,提示【有数据确定未成功】
          }
          if (shipDataList[i]['ship_kbn'] != '7' && index == '2') {
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(context)!.ship_prompt_error);
            return false;
          }
        }
      }
      add(foreachUpdateShipEvent(index, context));
    } else {
      return false;
    }
    return true;
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      String rcvSchDate, PostgrestFilterBuilder query) {
    query = query.eq('del_kbn', '2').eq('company_id', state.companyId);
    var result = query;
    if (rcvSchDate != '') {
      query = query.eq('rcv_sch_date', rcvSchDate);
    }
    return result;
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
        int l = 0;
        int k = 0;
        for (j = 0; j < data.length; j++) {
          Map<String, int> resultMapIn = new Map();
          //  商品入出荷位置数据检索
          List<dynamic> dataRevShipLocation = await SupabaseUtils.getClient()
              .from('dtb_rev_ship_location')
              .select('*')
              .eq('rev_ship_line_no', data[j]['ship_line_no']);
          // ignore: unnecessary_null_comparison
          if (dataRevShipLocation == null || dataRevShipLocation.length == 0) {
            break;
          }
          // 循环商品入出荷位置
          for (l = 0; l < dataRevShipLocation.length; l++) {
            //　検索表：dtb_product_location（商品在庫位置）
            //　検索項目：消費期限
            //　条件：「ロケーションID」＝商品入出荷位置の「商品ロケーションID」
            //　「商品ID」＝出荷指示明細の「商品ID」
            List<dynamic> dataLocation = await SupabaseUtils.getClient()
                .from('dtb_product_location')
                .select('*')
                .eq('product_id', data[j]['product_id'])
                .eq('location_id',
                    dataRevShipLocation[l]['product_location_id']);
            // 在库位置没有商品
            // ignore: unnecessary_null_comparison
            if (dataLocation == null || dataLocation.length == 0) {
              break;
            }

            // 循环商品在库位置
            for (k = 0; k < dataLocation.length; k++) {
              if (dataLocation[k]['limit_date'] != null) {
                //消費期限 < 現在日付 + 得意先_消費期限の場合
                // 当前日期
                DateTime now = DateTime.now();
                // 得意先_消費期限
                int customerExpiryDays = int.parse(customerData['limit_date']);
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
                  } else if (customerData['limit_date_flg'].toString() == '2') {
                    resultMapIn['result'] = 2;
                    resultMapIn['projectId'] = data[j]['product_id'];
                  }
                }
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
