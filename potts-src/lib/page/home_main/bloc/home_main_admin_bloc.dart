import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/config/config.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import 'home_main_admin_model.dart';

/**
 * 内容：首页（管理员）-BLOC
 * 作者：赵士淞
 * 时间：2024/06/25
 */
// 事件
abstract class HomeMainAdminEvent {}

// 初始化事件
class InitEvent extends HomeMainAdminEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始

// 自定义事件 - 终

class HomeMainAdminBloc extends Bloc<HomeMainAdminEvent, HomeMainAdminModel> {
  // 刷新补丁
  HomeMainAdminModel clone(HomeMainAdminModel src) {
    return HomeMainAdminModel.clone(src);
  }

  HomeMainAdminBloc(HomeMainAdminModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 判断登录用户角色
      if (StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser
              ?.role_id ==
          Config.ROLE_ID_1) {
        // 查询过去30天的销售额
        List<dynamic> sales30DaysList = await SupabaseUtils.getClient()
            .rpc('func_query_sales_in_the_past_30_days')
            .select('*');
        // 30日销售额列表
        state.sales30DaysList = sales30DaysList;

        // 查询过去3月的销售额
        List<dynamic> sales3MonthsList = await SupabaseUtils.getClient()
            .rpc('func_query_sales_in_the_past_3_months')
            .select('*');
        // 3月销售额列表
        state.sales3MonthsList = sales3MonthsList;

        // 查询今日销售额
        List<dynamic> salesTodayList = await SupabaseUtils.getClient()
            .rpc('func_query_sales_in_the_today')
            .select('*');
        // 今日销售额
        state.salesToday = salesTodayList[0]['price'];

        // 查询今日注册数
        List<dynamic> registrationsTodayList = await SupabaseUtils.getClient()
            .rpc('func_query_today_number_of_registration')
            .select('*');
        // 今日注册数
        state.registrationsToday = registrationsTodayList[0]['number'];

        // 查询今日解约数
        List<dynamic> terminationsTodayList = await SupabaseUtils.getClient()
            .rpc('func_query_today_number_of_termination')
            .select('*');
        // 今日解约数
        state.terminationsToday = terminationsTodayList[0]['number'];

        // 查询今天阅览数
        List<dynamic> viewersTodayList = await SupabaseUtils.getClient()
            .rpc('func_query_today_number_of_viewer')
            .select('*');
        // 今天阅览数
        state.viewersToday = viewersTodayList[0]['number'];

        emit(clone(state));
      }
    });

    // 自定义事件 - 始

    // 自定义事件 - 终

    add(InitEvent());
  }
}
