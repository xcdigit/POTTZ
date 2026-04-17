import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/table/bloc/wms_table_bloc.dart';
import 'home_main_receive_model.dart';

/**
 * 内容：入何予定照会-BLOC
 * 作者：luxy
 * 时间：2023/10/10
 */
// 事件
abstract class HomeMainReceiveEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends HomeMainReceiveEvent {
  // 初始化事件
  InitEvent();
}

class QueryReceiveEvent extends HomeMainReceiveEvent {
  int companyId;
  QueryReceiveEvent(this.companyId);
}

class HomeMainReceiveBloc extends WmsTableBloc<HomeMainReceiveModel> {
  // 刷新补丁
  @override
  HomeMainReceiveModel clone(HomeMainReceiveModel src) {
    return HomeMainReceiveModel.clone(src);
  }

  HomeMainReceiveBloc(HomeMainReceiveModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      int companyId = 0;
      if (StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser
              ?.company_id !=
          null) {
        companyId = StoreProvider.of<WMSState>(state.rootContext)
            .state
            .loginUser
            ?.company_id as int;
      }
      add(QueryReceiveEvent(companyId));
    });
    //查询入荷予定信息
    on<QueryReceiveEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //入荷予定照会列表
      List<dynamic> receiveData = await SupabaseUtils.getClient()
          .from('dtb_receive')
          .select('*')
          .eq("del_kbn", "2")
          .eq('company_id', event.companyId)
          .order('rcv_sch_date')
          .order('update_time')
          .limit(5);
      state.receiveList = receiveData;
      // 列表数据清空
      state.records.clear();
      //列表数据赋值
      if (receiveData.length > 0) {
        for (var i = 0; i < receiveData.length; i++) {
          // 判断入荷状態
          switch (receiveData[i]['receive_kbn']) {
            case Config.RECEIVE_KBN_WAIT_INSPECT:
              receiveData[i]['receive_kbn'] =
                  WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_1;
              break;
            case Config.RECEIVE_KBN_WAIT_INBOUND:
              receiveData[i]['receive_kbn'] =
                  WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_2;
              break;
            case Config.RECEIVE_KBN_IS_BEING_INBOUND:
              receiveData[i]['receive_kbn'] =
                  WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_3;
              break;
            case Config.RECEIVE_KBN_WAIT_RECEIVE_CONFIRM:
              receiveData[i]['receive_kbn'] =
                  WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_4;
              break;
            case Config.RECEIVE_KBN_RECEIVED:
              receiveData[i]['receive_kbn'] =
                  WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_5;
              break;
            default:
              receiveData[i]['receive_kbn'] = '';
              break;
          }
          // 判断取込状態
          if (receiveData[i]['importerror_flg'] ==
              Config.NUMBER_ONE.toString()) {
            // 取込状態名称
            receiveData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_1;
          } else if (receiveData[i]['importerror_flg'] ==
              Config.NUMBER_TWO.toString()) {
            // 取込状態名称
            receiveData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_2;
          } else if (receiveData[i]['importerror_flg'] ==
              Config.NUMBER_THREE.toString()) {
            // 取込状態名称
            receiveData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_3;
          } else if (receiveData[i]['importerror_flg'] ==
              Config.NUMBER_FOUR.toString()) {
            // 取込状態名称
            receiveData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_4;
          } else {
            // 取込状態名称
            receiveData[i]['importerror_flg'] = '';
          }
          state.records.add(WmsRecordModel(i, receiveData[i]));
        }
        state.total = receiveData.length;
      }
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    add(InitEvent());
  }
}
