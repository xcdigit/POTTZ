import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:quiver/time.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import 'home_main_calendar_model.dart';

/**
 * 内容：首页营业-BLOC
 * 作者：赵士淞
 * 时间：2023/11/30
 */
// 事件
abstract class HomeMainCalendarEvent {}

// 初始化事件
class InitEvent extends HomeMainCalendarEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 营业标记事件
class CalendarDotEvent extends HomeMainCalendarEvent {
  // 营业标记事件
  CalendarDotEvent();
}

// 营业月变更事件
class CalendarMonthChangeEvent extends HomeMainCalendarEvent {
  // 年份
  int year;
  // 月份
  int month;
  // 营业月变更事件
  CalendarMonthChangeEvent(this.year, this.month);
}
// 自定义事件 - 终

class HomeMainCalendarBloc
    extends Bloc<HomeMainCalendarEvent, HomeMainCalendarModel> {
  // 刷新补丁
  HomeMainCalendarModel clone(HomeMainCalendarModel src) {
    return HomeMainCalendarModel.clone(src);
  }

  HomeMainCalendarBloc(HomeMainCalendarModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 营业年份
      state.calendarYear = DateTime.now().year;
      // 营业月份
      state.calendarMonth = DateTime.now().month;

      // 营业标记事件
      add(CalendarDotEvent());
    });

    // 自定义事件 - 始
    // 营业标记事件
    on<CalendarDotEvent>((event, emit) async {
      // 营业开始日期
      DateTime calendarStartDate =
          DateTime(state.calendarYear, state.calendarMonth, 1);
      // 年月最大天数
      int maxDays = daysInMonth(state.calendarYear, state.calendarMonth);
      // 营业结束日期
      DateTime calendarEndDate =
          DateTime(state.calendarYear, state.calendarMonth, maxDays);

      //admin的场合 company_id为0
      int company_id = 0;
      if (StoreProvider.of<WMSState>(state.rootContext)
              .state
              .loginUser
              ?.company_id !=
          null) {
        company_id = StoreProvider.of<WMSState>(state.rootContext)
            .state
            .loginUser
            ?.company_id as int;
      }
      // 查询营业
      List<dynamic> calendarData = await SupabaseUtils.getClient()
          .from('mtb_calendar')
          .select('*')
          .gte('calendar_date', calendarStartDate)
          .lte('calendar_date', calendarEndDate)
          .eq('company_id', company_id)
          .eq('del_kbn', Config.DELETE_NO);

      // 标记日期集合
      EventList<Event> markedDatesMap = new EventList<Event>(events: {});

      // 按日期循环
      for (int i = 1; i <= maxDays; i++) {
        // 临时日期
        DateTime tempDateTime =
            DateTime(state.calendarYear, state.calendarMonth, i);
        // 临时列表
        List<Event> tempList = [];
        // 循环营业数据
        for (int j = 0; j < calendarData.length; j++) {
          // 判断是否是循环日期
          if (int.parse(calendarData[j]['calendar_date']
                  .toString()
                  .substring(8, 10)) ==
              i) {
            // 临时列表
            tempList.add(
              new Event(
                date: new DateTime(state.calendarYear, state.calendarMonth, i),
                dot: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.0),
                  color: calendarData[j]['calendar_type'] ==
                          Config.NUMBER_ONE.toString()
                      ? Colors.red
                      : calendarData[j]['calendar_type'] ==
                              Config.NUMBER_TWO.toString()
                          ? Colors.green
                          : calendarData[j]['calendar_type'] ==
                                  Config.NUMBER_THREE.toString()
                              ? Colors.blue
                              : Colors.transparent,
                  height: 5.0,
                  width: 5.0,
                ),
              ),
            );
          }
        }
        // 标记日期集合
        markedDatesMap.addAll(tempDateTime, tempList);
      }

      // 标记日期集合
      state.markedDatesMap = markedDatesMap;

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 营业月变更事件
    on<CalendarMonthChangeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 营业年份
      state.calendarYear = event.year;
      // 营业月份
      state.calendarMonth = event.month;

      // 营业标记事件
      add(CalendarDotEvent());
    });
    // 自定义事件 - 终

    add(InitEvent());
  }

  // 获取营业
  Future<List<Widget>> getCalendar(DateTime selectedDateTime) async {
    // 查询营业
    List<dynamic> calendarData = await SupabaseUtils.getClient()
        .from('mtb_calendar')
        .select('*')
        .eq('calendar_date', selectedDateTime)
        .eq(
            'company_id',
            StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id as int)
        .eq('del_kbn', Config.DELETE_NO);

    // 组件列表
    List<Widget> widgetList = [];

    // 循环营业弹窗列表
    for (int i = 0; i < calendarData.length; i++) {
      // 组件列表
      widgetList.add(
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: calendarData[i]['calendar_type'] ==
                        Config.NUMBER_ONE.toString()
                    ? Colors.red
                    : calendarData[i]['calendar_type'] ==
                            Config.NUMBER_TWO.toString()
                        ? Colors.green
                        : calendarData[i]['calendar_type'] ==
                                Config.NUMBER_THREE.toString()
                            ? Colors.blue
                            : Colors.transparent),
          ),
          child: Tooltip(
            message: calendarData[i]['note'],
            preferBelow: false, // 设置为 false 以显示在上方
            child: Text(
                calendarData[i]['calendar_type'] == Config.NUMBER_ONE.toString()
                    ? WMSLocalizations.i18n(state.rootContext)!
                        .mtb_calendar_text_3_1
                    : calendarData[i]['calendar_type'] ==
                            Config.NUMBER_TWO.toString()
                        ? WMSLocalizations.i18n(state.rootContext)!
                            .mtb_calendar_text_3_2
                        : calendarData[i]['calendar_type'] ==
                                Config.NUMBER_THREE.toString()
                            ? WMSLocalizations.i18n(state.rootContext)!
                                .mtb_calendar_text_3_3
                            : ''),
          ),
        ),
      );
    }

    return widgetList;
  }
}
