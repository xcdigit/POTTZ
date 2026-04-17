import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/page/biz/inbound/income_confirmation/bloc/income_confirmation_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';

import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
/**
 * 内容：入荷确定-BLOC
 * 作者：cuihr
 * 时间：2023/09/27
 */

// 事件
abstract class IncomeConfirmationEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends IncomeConfirmationEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 表格数据
class QueryIncomeEvent extends IncomeConfirmationEvent {
  String key;
  List<dynamic> list;
  QueryIncomeEvent(this.key, this.list);
}

//设置入荷予定日
class SetReceiveSchDateEvent extends IncomeConfirmationEvent {
  String schDate;
  SetReceiveSchDateEvent(this.schDate);
}

//检索按钮执行
class SelectIncomeBySchDateEvent extends IncomeConfirmationEvent {
// 结构树
  BuildContext context;
  SelectIncomeBySchDateEvent(this.context);
}

class foreachUpdateReceiveEvent extends IncomeConfirmationEvent {
  String flag;
  // 结构树
  BuildContext context;
  foreachUpdateReceiveEvent(this.flag, this.context);
}

// 设置sort字段
class SetSortEvent extends IncomeConfirmationEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}
// 自定义事件 - 终

class IncomeConfirmationBloc extends WmsTableBloc<IncomeConfirmationModel> {
// 刷新补丁
  @override
  IncomeConfirmationModel clone(IncomeConfirmationModel src) {
    return IncomeConfirmationModel.clone(src);
  }

  IncomeConfirmationBloc(IncomeConfirmationModel state) : super(state) {
    //检索条件
    //消除区分：未消除  2
    String delKbn = Config.DELETE_NO;
    //出荷状态 4：入荷確定待ち 5：入荷済み
    String four = Config.SHIP_KBN_WAIT_INSPECT;
    String five = Config.SHIP_KBN_WAIT_PACKAGING;
    List<dynamic> list = [four, five];

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
    on<PageQueryEvent>(
      (event, emit) async {
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
            .from("dtb_receive")
            .select('*')
            .eq('receive_kbn', four);
        query1 = setSelectConditions(state.rcvSchDate, query1);
        // 查询已确定个数
        var query2 = SupabaseUtils.getClient()
            .from("dtb_receive")
            .select('*')
            .eq('receive_kbn', five);
        query2 = setSelectConditions(state.rcvSchDate, query2);
        // 查询一览个数
        var query3 = SupabaseUtils.getClient()
            .from("dtb_receive")
            .select('*')
            .in_('receive_kbn', [five, four]);
        query3 = setSelectConditions(state.rcvSchDate, query3);
        List<dynamic> receiveCount1 = await query1.order('id', ascending: true);
        List<dynamic> receiveCount2 = await query2.order('id', ascending: true);
        List<dynamic> receiveCount3 = await query3.order('id', ascending: true);
        state.count1 = receiveCount1.length;
        state.count2 = receiveCount2.length;
        state.count = receiveCount3.length;
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_table_dtb_receive_kbn', params: {
              'company_id': state.companyId,
              'del_kbn': delKbn,
              'rcv_sch_date': state.rcvSchDate != '' ? state.rcvSchDate : null,
              'receive_no': null,
              'receive_kbn': list
            })
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1)
            .order(state.sortCol, ascending: state.ascendingFlg);
        // 列表数据清空
        state.records.clear();
        // 循环出荷指示数据
        for (int i = 0; i < data.length; i++) {
          if (data[i]['receive_kbn'] != null && data[i]['receive_kbn'] != '') {
            data[i]['receive_kbn_msg'] =
                data[i]['receive_kbn'] == '4' ? '入荷確定待ち' : '入荷済み';
          }
          // 列表数据增加
          state.records.add(WmsRecordModel(i, data[i]));
        }
        var queryCount = SupabaseUtils.getClient()
            .from('dtb_receive')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .in_('receive_kbn', list);
        //设置检索条件
        queryCount = setSelectConditions(state.rcvSchDate, queryCount);
        final countResult = await queryCount;
        // 总页数
        state.total = countResult.count;
        // 刷新补丁
        emit(clone(state));
        // 关闭加载状态
        BotToast.closeAllLoading();
      },
    );
    // tab检索查询分页数据事件
    on<QueryIncomeEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        //tab选中
        list = event.list;
        state.currentIndex = int.tryParse(event.key)!;
        // 加载标记
        state.loadingFlag = false;
        add(PageQueryEvent());
      },
    );
    // 设定入荷予定日事件
    on<SetReceiveSchDateEvent>(
      (event, emit) async {
        state.rcvSchDate = event.schDate;
        // 刷新补丁
        emit(clone(state));
      },
    );
    on<SelectIncomeBySchDateEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        // 加载标记
        state.loadingFlag = false;
        add(PageQueryEvent());
      },
    );
    //一览表格内按钮（确定，取消）
    on<foreachUpdateReceiveEvent>(
      (event, emit) async {
        BotToast.showLoading();
        try {
          bool flag = false;
          String errorText = '';
          int updateId =
              StoreProvider.of<WMSState>(event.context).state.loginUser!.id!;
          String updateTime = DateTime.now().toString();
          List<Map<String, dynamic>> receiveIdList = [];
          state.checkedRecords().forEach(
            (element) {
              receiveIdList.add(element.data);
            },
          );
          if (receiveIdList.length > 0) {
            for (int i = 0; i < receiveIdList.length; i++) {
              //4:入荷確定待ち 确定按钮
              if (receiveIdList[i]['receive_kbn'] != '4' && event.flag == '1') {
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.ship_confirm_error);
                flag = true;
                errorText =
                    WMSLocalizations.i18n(event.context)!.ship_confirm_error;
                break;
              }
              //5:入荷済み  取消按钮
              if (receiveIdList[i]['receive_kbn'] != '5' && event.flag == '2') {
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.ship_prompt_error_2);
                flag = true;
                errorText =
                    WMSLocalizations.i18n(event.context)!.ship_prompt_error_2;
                break;
              }
              //更新receive入荷予定表
              await SupabaseUtils.getClient().from('dtb_receive').update({
                'receive_kbn': event.flag == '1' ? '5' : '4',
                'update_id': updateId,
                'update_time': updateTime
              }).eq('id', receiveIdList[i]['id']);
              //根据receive入荷予定id查找dtb_receive_detail入荷予定明细
              List<dynamic> detailList = await SupabaseUtils.getClient()
                  .from('dtb_receive_detail')
                  .select('*')
                  .eq('receive_id', receiveIdList[i]['id']);
              if (detailList.length > 0) {
                for (int j = 0; j < detailList.length; j++) {
                  //更新dtb_receive_detail入荷予定明细  【入荷確定】=【1:ON】【入荷確定】=【2:OFF】
                  await SupabaseUtils.getClient()
                      .from('dtb_receive_detail')
                      .update({
                    'confirm_kbn': event.flag == '1' ? '1' : '2',
                    'update_id': updateId,
                    'update_time': updateTime
                  }).eq('receive_id', detailList[j]['receive_id']);
                }
              }
            }
            if (flag) {
              // 更新失败消息提示
              WMSCommonBlocUtils.errorTextToast(errorText);
            } else {
              // 更新成功消息提示
              event.flag == '1'
                  ? WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(event.context)!.menu_content_2_12 +
                          WMSLocalizations.i18n(event.context)!.update_success)
                  : WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(state.rootBuildContext)!
                          .ship_kbn_cancel_success);
            }
          } else {
            // 更新失败消息提示
            event.flag == '1'
                ? WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!
                        .Inventory_Confirmed_tip_9)
                : WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.ship_kbn_cancel);
          }
        } catch (e) {
          // 关闭加载状态
          BotToast.closeAllLoading();
          // 更新失败消息提示
          event.flag == '1'
              ? WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootBuildContext)!
                      .Inventory_Confirmed_tip_9)
              : WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootBuildContext)!
                      .ship_kbn_cancel);
        }

        //插入操作履历 sys_log表
        if (event.flag == '1') {
          //確認
          CommonUtils().createLogInfo(
              '入荷確定' +
                  Config.OPERATION_TEXT1 +
                  Config.OPERATION_BUTTON_TEXT5 +
                  Config.OPERATION_TEXT2,
              "foreachUpdateReceiveEvent()",
              StoreProvider.of<WMSState>(state.rootBuildContext)
                  .state
                  .loginUser!
                  .company_id,
              StoreProvider.of<WMSState>(state.rootBuildContext)
                  .state
                  .loginUser!
                  .id);
        } else {
          //キャンセル
          CommonUtils().createLogInfo(
              '入荷確定' +
                  Config.OPERATION_TEXT1 +
                  Config.OPERATION_BUTTON_TEXT6 +
                  Config.OPERATION_TEXT2,
              "foreachUpdateReceiveEvent()",
              StoreProvider.of<WMSState>(state.rootBuildContext)
                  .state
                  .loginUser!
                  .company_id,
              StoreProvider.of<WMSState>(state.rootBuildContext)
                  .state
                  .loginUser!
                  .id);
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
}
