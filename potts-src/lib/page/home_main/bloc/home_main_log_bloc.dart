import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/config/config.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/table/bloc/wms_table_bloc.dart';
import 'home_main_log_model.dart';
import 'package:intl/intl.dart';

/**
 * 内容：操作log-BLOC
 * 作者：luxy
 * 时间：2023/10/11
 */
// 事件
abstract class HomeMainLogEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends HomeMainLogEvent {
  // 初始化事件
  InitEvent();
}

class QueryLogEvent extends HomeMainLogEvent {
  int companyId;
  QueryLogEvent(this.companyId);
}

class HomeMainLogBloc extends WmsTableBloc<HomeMainLogModel> {
  // 刷新补丁
  @override
  HomeMainLogModel clone(HomeMainLogModel src) {
    return HomeMainLogModel.clone(src);
  }

  HomeMainLogBloc(HomeMainLogModel state) : super(state) {
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
      add(QueryLogEvent(companyId));
    });
    //查询操作log信息
    on<QueryLogEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      int roleId = StoreProvider.of<WMSState>(state.rootContext)
          .state
          .loginUser!
          .role_id as int;
      //操作log列表
      List<dynamic> logData = [];
      if (roleId == Config.NUMBER_ONE) {
        //超级管理员
        logData = await SupabaseUtils.getClient()
            .from('sys_log')
            .select('*')
            .order('create_time')
            .limit(5);
      } else if (roleId == Config.NUMBER_TWO) {
        //系统管理员
        logData = await SupabaseUtils.getClient()
            .from('sys_log')
            .select('*')
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .company_id)
            .order('create_time')
            .limit(5);
      } else {
        //普通角色
        logData = await SupabaseUtils.getClient()
            .from('sys_log')
            .select('*')
            .eq(
                'company_id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .company_id)
            .eq(
                'create_id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .id)
            .order('create_time')
            .limit(5);
      }
      if (logData.length > 0) {
        for (var i = 0; i < logData.length; i++) {
          //日期转换
          DateTime date = DateTime.parse(logData[i]['create_time']);
          String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
          logData[i]['create_time'] = time;
        }
      }
      state.logList = logData;
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    add(InitEvent());
  }
}
