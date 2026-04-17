import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/table/bloc/wms_record_model.dart';
import '../../../widget/table/bloc/wms_table_bloc.dart';
import 'home_main_ship_model.dart';
import 'package:intl/intl.dart';

/**
 * 内容：出荷指示照会-BLOC
 * 作者：luxy
 * 时间：2023/10/10
 */
// 事件
abstract class HomeMainShipEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends HomeMainShipEvent {
  // 初始化事件
  InitEvent();
}

class QueryShipEvent extends HomeMainShipEvent {
  int companyId;
  QueryShipEvent(this.companyId);
}

class HomeMainShipBloc extends WmsTableBloc<HomeMainShipModel> {
  // 刷新补丁
  @override
  HomeMainShipModel clone(HomeMainShipModel src) {
    return HomeMainShipModel.clone(src);
  }

  HomeMainShipBloc(HomeMainShipModel state) : super(state) {
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
      add(QueryShipEvent(companyId));
    });
    //查询出荷指示信息
    on<QueryShipEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //出荷指示照会列表
      List<dynamic> shipData = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .eq("del_kbn", "2")
          .eq('company_id', event.companyId)
          .order('rcv_sch_date')
          .order('update_time')
          .limit(5);
      state.shipList = shipData;
      // 列表数据清空
      state.records.clear();
      //列表数据赋值
      if (shipData.length > 0) {
        for (var i = 0; i < shipData.length; i++) {
          //出荷状態判断
          switch (shipData[i]['ship_kbn']) {
            case Config.SHIP_KBN_ASSIGN_FAIL:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_ASSIGN_FAIL;
              break;
            case Config.SHIP_KBN_WAIT_ASSIGN:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_WAIT_ASSIGN;
              break;
            case Config.SHIP_KBN_WAIT_OUTBOUND:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_WAIT_OUTBOUND;
              break;
            case Config.SHIP_KBN_IS_BEING_OUTBOUND:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_IS_BEING_OUTBOUND;
              break;
            case Config.SHIP_KBN_WAIT_INSPECT:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_WAIT_INSPECT;
              break;
            case Config.SHIP_KBN_WAIT_PACKAGING:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_WAIT_PACKAGING;
              break;
            case Config.SHIP_KBN_WAIT_SHIPMENT_CONFIRM:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_WAIT_SHIPMENT_CONFIRM;
              break;
            case Config.SHIP_KBN_SHIPPED:
              shipData[i]['ship_kbn'] = state.SHIP_KBN_SHIPPED;
              break;
            default:
          }
          // 判断取込状態
          if (shipData[i]['importerror_flg'] == Config.NUMBER_ONE.toString()) {
            // 取込状態名称
            shipData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_1;
          } else if (shipData[i]['importerror_flg'] ==
              Config.NUMBER_TWO.toString()) {
            // 取込状態名称
            shipData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_2;
          } else if (shipData[i]['importerror_flg'] ==
              Config.NUMBER_THREE.toString()) {
            // 取込状態名称
            shipData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_3;
          } else if (shipData[i]['importerror_flg'] ==
              Config.NUMBER_FOUR.toString()) {
            // 取込状態名称
            shipData[i]['importerror_flg'] =
                WMSLocalizations.i18n(state.rootContext)!
                    .importerror_flg_text_4;
          } else {
            // 取込状態名称
            shipData[i]['importerror_flg'] = '';
          }
          state.records.add(WmsRecordModel(i, shipData[i]));
        }
        state.total = shipData.length;
      }
      //获取当前日期
      DateTime now = DateTime.now();
      String nowDay = DateFormat('yyyy-MM-dd').format(now);
      //当日出荷進捗
      List<dynamic> shipData1 = await SupabaseUtils.getClient()
          .from('dtb_ship')
          .select('*')
          .eq("del_kbn", "2")
          .eq('company_id', event.companyId)
          .eq('rcv_sch_date', nowDay);
      state.dayTotalCount = shipData1.length;
      //1:引当待ち
      List<dynamic> shipData2 =
          shipData1.where((element) => element["ship_kbn"] == '1').toList();
      state.dayWaitCount = shipData2.length;
      //2:出庫待ち
      List<dynamic> shipData3 =
          shipData1.where((element) => element["ship_kbn"] == '2').toList();
      state.dayWaitShipmentCount = shipData3.length;
      //3:出庫中 4:検品待ち 5:梱包待ち 6:出荷確定待ち
      List<dynamic> shipData4 = shipData1
          .where((element) => (element["ship_kbn"] == '3' ||
              element["ship_kbn"] == '4' ||
              element["ship_kbn"] == '5' ||
              element["ship_kbn"] == '6'))
          .toList();
      state.dayWorkCount = shipData4.length;
      //7:出荷済み
      List<dynamic> shipData5 =
          shipData1.where((element) => element["ship_kbn"] == '7').toList();
      state.dayShippedCount = shipData5.length;
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    add(InitEvent());
  }
}
