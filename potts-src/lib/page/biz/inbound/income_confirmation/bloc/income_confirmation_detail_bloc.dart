import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/inbound/income_confirmation/bloc/income_confirmation_detail_model.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/utils/supabase_untils.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：入荷确定详细 -bloc
 * 作者：cuihr
 * 时间：2023/09/28
 */
// 事件
abstract class IncomeConfirmationDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends IncomeConfirmationDetailEvent {
  // 初始化事件
  InitEvent();
}

// 表单数据
class QueryReceiveDetailEvent extends IncomeConfirmationDetailEvent {
  QueryReceiveDetailEvent();
}

//查询入荷预定连携济是否为ON
class QueryReceiveByIdEvent extends IncomeConfirmationDetailEvent {
  int receiveId;
  QueryReceiveByIdEvent(this.receiveId);
}

//查询入荷确定详细弹窗内容
class QueryComeDetailAndProductEvent extends IncomeConfirmationDetailEvent {
  int id;
  QueryComeDetailAndProductEvent(this.id);
}

class updateReceiveEvent extends IncomeConfirmationDetailEvent {
  Map<String, dynamic> receiveData;
  int detailId;
  // 结构树
  BuildContext context;
  updateReceiveEvent(this.receiveData, this.detailId, this.context);
}

class IncomeConfirmationDetailBloc
    extends WmsTableBloc<IncomeConfirmationDetailModel> {
  //刷新补丁
  @override
  IncomeConfirmationDetailModel clone(IncomeConfirmationDetailModel src) {
    return IncomeConfirmationDetailModel.clone(src);
  }

  IncomeConfirmationDetailBloc(IncomeConfirmationDetailModel state)
      : super(state) {
    // 检索条件
    //消除区分：未消除  2
    String delKbn = Config.DELETE_NO;
    on<InitEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        // 加载标记
        state.loadingFlag = false;
        add(QueryReceiveDetailEvent());
        add(PageQueryEvent());
        add(QueryReceiveByIdEvent(state.receiveId));
        // 刷新补丁
        emit(clone(state));
      },
    );
    //表单
    on<QueryReceiveDetailEvent>(
      (event, emit) async {
        List<dynamic> data = await SupabaseUtils.getClient()
            .from("dtb_receive")
            .select('*')
            .eq('id', state.receiveId)
            .eq('del_kbn', delKbn);
        // 列表数据增加
        state.receiveDetailCustomize = data[0];
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    // //表格
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
        // 查询出荷明细指示
        List<dynamic> data = await SupabaseUtils.getClient()
            .rpc('func_query_table_dtb_receive_detail_and_product',
                params: {'receive_id': state.receiveId})
            .select('*')
            .order('id', ascending: false)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
        // 列表数据清空
        state.records.clear();
        // 循环出荷指示数据
        if (data.length > 0) {
          for (int i = 0; i < data.length; i++) {
            if (data[i]['confirm_kbn'] != '' &&
                data[i]['confirm_kbn'] != null) {
              data[i]['confirm_kbn_msg'] =
                  data[i]['confirm_kbn'] == '1' ? 'ON' : 'OFF';
            }
            // if (data[i]['image1'] != null && data[i]['image1'] != '') {
            //   data[i]['image1'] =
            //       await WMSCommonFile().previewImageFile(data[i]['image1']);
            // }
            // if (data[i]['image2'] != null && data[i]['image2'] != '') {
            //   data[i]['image2'] =
            //       await WMSCommonFile().previewImageFile(data[i]['image2']);
            // }
            // 列表数据增加
            state.records.add(WmsRecordModel(i, data[i]));
          }
        }
        state.total = data.length;
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    on<QueryReceiveByIdEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        List<dynamic> data = await SupabaseUtils.getClient()
            .from('dtb_receive')
            .select('*')
            .eq('id', event.receiveId);
        if (data.length > 0) {
          state.receiveData = data[0];
        }
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    on<QueryComeDetailAndProductEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();

        // 查询入荷明细指示
        List<dynamic> data = await SupabaseUtils.getClient().rpc(
            'func_query_table_dtb_receive_detail_and_product_location',
            params: {'id': event.id, 'rev_ship_kbn': "1"}).select('*');
        if (data.length > 0) {
          for (var i = 0; i < data.length; i++) {
            if (data[i]['image1'] != null && data[i]['image1'] != '') {
              data[i]['image1'] =
                  await WMSCommonFile().previewImageFile(data[i]['image1']);
            }
            if (data[i]['image2'] != null && data[i]['image2'] != '') {
              data[i]['image2'] =
                  await WMSCommonFile().previewImageFile(data[i]['image2']);
            }
          }
          state.receiveDetailData = data[0];
        }
        // 刷新补丁
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    on<updateReceiveEvent>(
      (event, emit) async {
        BotToast.showLoading();
        try {
          int updateId =
              StoreProvider.of<WMSState>(event.context).state.loginUser!.id!;
          String updateTime = DateTime.now().toString();
          if (event.receiveData['receive_kbn'] == 5) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootBuildContext)!
                    .receive_status_no);
          } else {
            await SupabaseUtils.getClient().from('dtb_receive').update({
              'receive_kbn': '4',
              'update_id': updateId,
              'update_time': updateTime
            }).eq('id', event.receiveData['id']);
            await SupabaseUtils.getClient().from('dtb_receive_detail').update({
              'confirm_kbn': '2',
              'update_id': updateId,
              'update_time': updateTime
            }).eq('id', event.detailId);
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootBuildContext)!
                    .ship_kbn_cancel_success);
          }
        } catch (e) {
          // 关闭加载
          BotToast.closeAllLoading();
          //失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootBuildContext)!.ship_kbn_cancel);
        }
        // 加载标记
        state.loadingFlag = false;
        add(PageQueryEvent());
      },
    );
    add(InitEvent());
  }

  // 查询入荷指示明细事件
  bool QueryIncomeDetailEvent(BuildContext context, int id) {
    // 判断出荷指示-定制ID
    if (id == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_8 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else {
      // 查询入荷指示明细事件
      add(QueryComeDetailAndProductEvent(id));
      return true;
    }
  }
}
