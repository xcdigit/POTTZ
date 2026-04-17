import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/calendar.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'calendar_master_model.dart';

/**
 * 内容：営業日マスタ-BLOC
 * 作者：赵士淞
 * 时间：2023/11/29
 */
// 事件
abstract class CalendarMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends CalendarMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 删除营业事件
class DeleteCalendarEvent extends CalendarMasterEvent {
  // 营业ID
  int calendarId;
  // 删除营业事件
  DeleteCalendarEvent(this.calendarId);
}

// 获取营业值事件
class GetCalendarValueEvent extends CalendarMasterEvent {
  // 营业ID
  int calendarId;
  // 营业标记
  int calendarFlag;
  // 获取营业值事件
  GetCalendarValueEvent(this.calendarId, this.calendarFlag);
}

// 清空营业事件
class ClearCalendarEvent extends CalendarMasterEvent {
  // 清空营业事件
  ClearCalendarEvent();
}

// 保存营业事件
class SaveCalendarEvent extends CalendarMasterEvent {
  // 保存营业事件
  SaveCalendarEvent();
}

// 设定营业值事件
class SetCalendarValueEvent extends CalendarMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetCalendarValueEvent(this.key, this.value);
}

// 保存检索按钮标记事件
class SaveQueryButtonFlag extends CalendarMasterEvent {
  // 值
  bool value;
  // 保存检索按钮标记事件
  SaveQueryButtonFlag(this.value);
}

// 保存查询：营业日事件
class SaveSearchCalendarDateEvent extends CalendarMasterEvent {
  // 值
  String value;
  // 保存查询：营业日事件
  SaveSearchCalendarDateEvent(this.value);
}

// 保存查询：营业类型事件
class SaveSearchCalendarTypeEvent extends CalendarMasterEvent {
  // 值
  String value;
  // 保存查询：营业类型事件
  SaveSearchCalendarTypeEvent(this.value);
}

// 搜索按钮事件
class SearchButtonEvent extends CalendarMasterEvent {
  // 搜索按钮事件
  SearchButtonEvent();
}

// 重置按钮事件
class ResetButtonEvent extends CalendarMasterEvent {
  // 重置按钮事件
  ResetButtonEvent();
}

// 保存检索：营业日事件
class SaveQueryCalendarDateEvent extends CalendarMasterEvent {
  // 值
  String value;
  // 保存检索：营业日事件
  SaveQueryCalendarDateEvent(this.value);
}

// 保存检索：营业类型事件
class SaveQueryCalendarTypeEvent extends CalendarMasterEvent {
  // 值
  String value;
  // 保存检索：营业类型事件
  SaveQueryCalendarTypeEvent(this.value);
}

// 设置sort字段
class SetSortEvent extends CalendarMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class CalendarMasterBloc extends WmsTableBloc<CalendarMasterModel> {
  // 刷新补丁
  @override
  CalendarMasterModel clone(CalendarMasterModel src) {
    return CalendarMasterModel.clone(src);
  }

  CalendarMasterBloc(CalendarMasterModel state) : super(state) {
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

      // 查询营业
      List<dynamic> data1 = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_mtb_calendar', params: {
            'calendar_date':
                state.queryCalendarDate == '' ? null : state.queryCalendarDate,
            'calendar_type':
                state.queryCalendarType == '' ? null : state.queryCalendarType,
            'company_id': StoreProvider.of<WMSState>(state.rootContext)
                .state
                .loginUser
                ?.company_id as int,
            'del_kbn': Config.DELETE_NO,
          })
          .select('*')
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环营业数据
      for (int i = 0; i < data1.length; i++) {
        // 判断营业类型
        if (data1[i]['calendar_type'] == Config.NUMBER_ONE.toString()) {
          // 营业类型文本
          data1[i]['calendar_type_text'] =
              WMSLocalizations.i18n(state.rootContext)!.mtb_calendar_text_3_1;
        } else if (data1[i]['calendar_type'] == Config.NUMBER_TWO.toString()) {
          // 营业类型文本
          data1[i]['calendar_type_text'] =
              WMSLocalizations.i18n(state.rootContext)!.mtb_calendar_text_3_2;
        } else if (data1[i]['calendar_type'] ==
            Config.NUMBER_THREE.toString()) {
          // 营业类型文本
          data1[i]['calendar_type_text'] =
              WMSLocalizations.i18n(state.rootContext)!.mtb_calendar_text_3_3;
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data1[i]));
      }

      // 查询营业
      List<dynamic> data2 = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_table_mtb_calendar', params: {
        'calendar_date':
            state.queryCalendarDate == '' ? null : state.queryCalendarDate,
        'calendar_type':
            state.queryCalendarType == '' ? null : state.queryCalendarType,
        'company_id': StoreProvider.of<WMSState>(state.rootContext)
            .state
            .loginUser
            ?.company_id as int,
        'del_kbn': Config.DELETE_NO,
      }).select('*');
      // 总页数
      state.total = data2.length;

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      // 页面标记
      bool currentFlag =
          StoreProvider.of<WMSState>(state.rootContext).state.currentFlag;
      // 判端页面标记
      if (currentFlag) {
        // 判断SP营业ID
        if (state.spCalendarId != Config.NUMBER_NEGATIVE) {
          // 查询营业
          List<dynamic> calendarData = await SupabaseUtils.getClient()
              .from('mtb_calendar')
              .select('*')
              .eq('id', state.spCalendarId);
          // 判断营业数量
          if (calendarData.length != 0) {
            // 营业-定制
            state.calendarCustomize = calendarData[0];
            // 选中ID
            state.selectedId = calendarData[0]['id'];
            // 判断营业标记
            if (state.spCalendarFlag == Config.NUMBER_ONE) {
              // 表单禁用
              state.formDisable = true;
            } else {
              // 表单禁用
              state.formDisable = false;
            }
          }
        }
        // 页面标记
        StoreProvider.of<WMSState>(state.rootContext)
            .dispatch(RefreshCurrentFlagAction(false));
      }
      // 自定义事件 - 终

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 删除营业事件
    on<DeleteCalendarEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 修改营业
        List<Map<String, dynamic>> calendarData =
            await SupabaseUtils.getClient()
                .from('mtb_calendar')
                .update({'del_kbn': Config.DELETE_YES})
                .eq('id', event.calendarId)
                .select('*');
        // 判断营业数据
        if (calendarData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 获取营业值事件
    on<GetCalendarValueEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询营业
      List<dynamic> calendarData = await SupabaseUtils.getClient()
          .from('mtb_calendar')
          .select('*')
          .eq('id', event.calendarId);
      // 判断营业数量
      if (calendarData.length != 0) {
        // 营业-定制
        state.calendarCustomize = calendarData[0];
        // 选中ID
        state.selectedId = calendarData[0]['id'];
        // 判断营业标记
        if (event.calendarFlag == Config.NUMBER_ONE) {
          // 表单禁用
          state.formDisable = true;
        } else {
          // 表单禁用
          state.formDisable = false;
        }
      }

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 清空营业事件
    on<ClearCalendarEvent>((event, emit) async {
      // 营业-定制
      state.calendarCustomize = {
        'id': '',
        'calendar_date': '',
        'calendar_type': '',
        'note': '',
      };
      // 选中ID
      state.selectedId = Config.NUMBER_NEGATIVE;
      // 表单禁用
      state.formDisable = false;

      // 更新
      emit(clone(state));
    });

    // 保存营业事件
    on<SaveCalendarEvent>((event, emit) async {
      // 判断表单禁用
      if (state.formDisable) {
        return;
      }

      // 保存营业验证
      Map<String, dynamic> calendarCustomize =
          saveCalendarCheck(state.calendarCustomize);
      // 判断验证结果
      if (calendarCustomize.length == 0) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 营业数据
      List<Map<String, dynamic>> calendarData;
      // 营业
      Calendar calendar = Calendar.fromJson(calendarCustomize);

      // 判断营业ID
      if (calendar.id == null) {
        // 创建营业处理
        calendar = createCalendarHandle(calendar);
        // 判断处理结果
        if (calendar.create_id == null || calendar.create_id == '') {
          return;
        }

        try {
          // 新增营业
          calendarData = await SupabaseUtils.getClient()
              .from('mtb_calendar')
              .insert([calendar.toJson()]).select('*');
          // 判断营业数据
          if (calendarData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                    WMSLocalizations.i18n(state.rootContext)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                    WMSLocalizations.i18n(state.rootContext)!.create_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        // 更新营业处理
        calendar = updateCalendarHandle(calendar);
        // 判断处理结果
        if (calendar.update_id == null || calendar.update_id == '') {
          return;
        }

        try {
          // 修改营业
          calendarData = await SupabaseUtils.getClient()
              .from('mtb_calendar')
              .update(calendar.toJson())
              .eq('id', calendar.id)
              .select('*');
          // 判断营业数据
          if (calendarData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                    WMSLocalizations.i18n(state.rootContext)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_21 +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }

      // 营业-定制
      state.calendarCustomize = {
        'id': '',
        'calendar_date': '',
        'calendar_type': '',
        'note': '',
      };
      // 选中ID
      state.selectedId = Config.NUMBER_NEGATIVE;
      // 表单禁用
      state.formDisable = false;

      // 关闭加载
      BotToast.closeAllLoading();
      // 返回上一页
      GoRouter.of(state.rootContext).pop('refresh return');
    });

    // 设定营业值事件
    on<SetCalendarValueEvent>((event, emit) async {
      // 营业-临时
      Map<String, dynamic> calendarTemp = Map<String, dynamic>();
      calendarTemp.addAll(state.calendarCustomize);
      // 判断key
      if (calendarTemp[event.key] != null) {
        // 营业-临时
        calendarTemp[event.key] = event.value;
      } else {
        // 营业-临时
        calendarTemp.addAll({event.key: event.value});
      }
      // 营业-定制
      state.calendarCustomize = calendarTemp;

      // 更新
      emit(clone(state));
    });

    // 保存检索按钮标记事件
    on<SaveQueryButtonFlag>((event, emit) async {
      // 检索按钮标记
      state.queryButtonFlag = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：营业日事件
    on<SaveSearchCalendarDateEvent>((event, emit) async {
      // 查询：营业日
      state.searchCalendarDate = event.value;

      // 更新
      emit(clone(state));
    });

    // 保存查询：营业类型事件
    on<SaveSearchCalendarTypeEvent>((event, emit) async {
      // 判断查询：营业类型
      if (event.value == state.searchCalendarType) {
        // 查询：营业类型
        state.searchCalendarType = '';
      } else {
        // 查询：营业类型
        state.searchCalendarType = event.value;
      }

      // 更新
      emit(clone(state));
    });

    // 搜索按钮事件
    on<SearchButtonEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索按钮标记
      state.queryButtonFlag = false;
      // 检索：营业日
      state.queryCalendarDate = state.searchCalendarDate;
      // 检索：营业类型
      state.queryCalendarType = state.searchCalendarType;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 重置按钮事件
    on<ResetButtonEvent>((event, emit) async {
      // 查询：营业日
      state.searchCalendarDate = '';
      // 查询：营业类型
      state.searchCalendarType = '';

      // 更新
      emit(clone(state));
    });

    // 保存检索：营业日事件
    on<SaveQueryCalendarDateEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：营业日
      state.queryCalendarDate = event.value;
      // 查询：营业日
      state.searchCalendarDate = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 保存检索：营业类型事件
    on<SaveQueryCalendarTypeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 检索：营业类型
      state.queryCalendarType = event.value;
      // 查询：营业类型
      state.searchCalendarType = event.value;

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    // 自定义事件 - 终
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

  // 保存营业验证
  Map<String, dynamic> saveCalendarCheck(
      Map<String, dynamic> calendarStructure) {
    // 判断是否为空
    if (calendarStructure['calendar_date'] == null ||
        calendarStructure['calendar_date'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.mtb_calendar_text_2 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return {};
    } else if (calendarStructure['calendar_type'] == null ||
        calendarStructure['calendar_type'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.mtb_calendar_text_3 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return {};
    }

    // 处理营业-结构
    if (calendarStructure['id'] == null || calendarStructure['id'] == '') {
      calendarStructure.remove('id');
    } else {
      calendarStructure['id'] = int.parse(calendarStructure['id'].toString());
    }

    return calendarStructure;
  }

  // 创建营业处理
  Calendar createCalendarHandle(Calendar calendar) {
    // 营业
    calendar.company_id = StoreProvider.of<WMSState>(state.rootContext)
        .state
        .loginUser
        ?.company_id;
    calendar.del_kbn = Config.DELETE_NO;
    calendar.create_time = DateTime.now().toString();
    calendar.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    calendar.update_time = DateTime.now().toString();
    calendar.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    return calendar;
  }

  // 更新营业处理
  Calendar updateCalendarHandle(Calendar calendar) {
    // 出荷指示
    calendar.update_time = DateTime.now().toString();
    calendar.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    return calendar;
  }
}
