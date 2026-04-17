import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/wms_common_bloc_utils.dart';
import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/current_flag_reducer.dart';
import '../../../redux/current_notice_flag_reducer.dart';
import '../../../redux/current_param_reducer.dart';
import '../../../redux/wms_state.dart';
import 'notice_model.dart';

/**
 * 内容：消息-BLOC
 * 作者：luxy
 * 时间：2023/10/07
 */

// 事件
abstract class NoticeEvent {}

// 初始化事件
class InitEvent extends NoticeEvent {
  // 初始化事件
  InitEvent();
}

// 查询消息列表
class QueryNoticeEvent extends NoticeEvent {
  // 当前登录者id
  int userId;
  // 检索框内容
  String title;
  // 方法
  QueryNoticeEvent(this.userId, this.title);
}

// 查询消息列表-pc
class QueryNoticeEventInit extends NoticeEvent {
  // 方法
  QueryNoticeEventInit();
}

// 查询消息列表-sp
class QueryNoticeSPEventInit extends NoticeEvent {
  // 方法
  QueryNoticeSPEventInit();
}

// 右侧内容显示判断
class RightShowNoticeEvent extends NoticeEvent {
  // 值
  int i;
  // 方法
  RightShowNoticeEvent(this.i);
}

// 删除内容
class DelNoticeEvent extends NoticeEvent {
  //值
  Map<String, dynamic> noticeContent;
  // 方法
  DelNoticeEvent(this.noticeContent);
}

// 删除内容-sp
class DelNoticeSpEvent extends NoticeEvent {
  //值
  Map<String, dynamic> noticeContent;
  // 方法
  DelNoticeSpEvent(this.noticeContent);
}

// 点击消息按钮1事件
class ClickMessageButtonOneEvent extends NoticeEvent {
  // 点击消息按钮1事件
  ClickMessageButtonOneEvent();
}

// 点击消息按钮2事件
class ClickMessageButtonTwoEvent extends NoticeEvent {
  // 点击消息按钮2事件
  ClickMessageButtonTwoEvent();
}

class NoticeBloc extends Bloc<NoticeEvent, NoticeModel> {
  // 刷新补丁
  NoticeModel clone(NoticeModel src) {
    return NoticeModel.clone(src);
  }

  NoticeBloc(NoticeModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      // BotToast.showLoading();
      // 查询多语言信息
      List<Map<String, dynamic>> languageData =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageData;
      // 赵士淞 - 始
      //传入参数，控制消息页面刷新
      StoreProvider.of<WMSState>(state.rootContext)
          .dispatch(RefreshCurrentFlagAction(true));
      // 赵士淞 - 终
      if (kIsWeb == true) {
        // 赵士淞 - 始
        // 查询消息列表-pc
        add(QueryNoticeEventInit());
        // 赵士淞 - 终
      } else {
        // 赵士淞 - 始
        //查询消息列表-sp
        add(QueryNoticeSPEventInit());
        // 赵士淞 - 终
      }
    });
    // 查询消息列表（带检索框内容）
    on<QueryNoticeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询消息列表
      List<dynamic> noticeData = await SupabaseUtils.getClient().rpc(
          'func_query_notice_message',
          params: {'user_id': event.userId, 'title': event.title}).select('*');
      //左侧列表日期转换
      for (var i = 0; i < noticeData.length; i++) {
        //日期转换
        DateTime date = DateTime.parse(noticeData[i]['create_time']);
        noticeData[i]['left_date'] =
            date.month.toString() + '月' + date.day.toString() + '日';
      }
      //消息列表
      state.noticeList = noticeData;

      //初始化
      state.index = -1;
      state.noticeContent = {};
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询消息列表（不带检索框内容）
    on<QueryNoticeEventInit>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //获取控制页面刷新参数
      bool currentFlag =
          StoreProvider.of<WMSState>(state.rootContext).state.currentFlag;
      //获取消息列表下标
      int currentIndex =
          StoreProvider.of<WMSState>(state.rootContext).state.currentIndex;
      //赋值
      state.index = currentIndex;
      if (currentFlag) {
        // 查询消息列表
        List<dynamic> noticeData = await SupabaseUtils.getClient()
            .rpc('func_query_dialog_notice_message', params: {
          'user_id':
              StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id
        }).select('*');
        //判断是否存在未读消息
        List<dynamic> list = noticeData
            .where((element) => element["read_status"] == '2')
            .toList();
        if (list.length != 0) {
          //存在未读信息
          StoreProvider.of<WMSState>(state.rootContext)
              .dispatch(RefreshCurrentNoticeFlagAction(true));
        } else {
          //不存在未读信息
          StoreProvider.of<WMSState>(state.rootContext)
              .dispatch(RefreshCurrentNoticeFlagAction(false));
        }
        //左侧列表日期转换
        for (var i = 0; i < noticeData.length; i++) {
          //日期转换
          DateTime date = DateTime.parse(noticeData[i]['create_time']);
          noticeData[i]['left_date'] =
              date.month.toString() + '月' + date.day.toString() + '日';
        }
        if (state.index != -1) {
          // 判断右侧内容是否显示
          List<dynamic> noticeList =
              StoreProvider.of<WMSState>(state.rootContext).state.currentParam;
          List<dynamic> updNoticeData = [];
          if (noticeList[state.index]['read_status'] == '2') {
            if (noticeList[state.index]['message_kbn'] == 'ytb') {
              //系统通知
              updNoticeData = await SupabaseUtils.getClient()
                  .from('ytb_message_history')
                  .update({
                    'read_status': '1',
                    'update_time': DateTime.now().toString(),
                    'update_id': StoreProvider.of<WMSState>(state.rootContext)
                        .state
                        .loginUser
                        ?.id,
                  })
                  .eq('id', noticeList[state.index]['id'])
                  .select('*');
              // 判断数据是否更新成功
              if (updNoticeData.length != 0) {
                //消息状态更新
                noticeData[state.index]['read_status'] =
                    updNoticeData[0]['read_status'];
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!
                            .home_head_notice_text2 +
                        WMSLocalizations.i18n(state.rootContext)!.update_error);
              }
            } else if (noticeList[state.index]['message_kbn'] == 'mtb') {
              //其余通知
              updNoticeData = await SupabaseUtils.getClient()
                  .from('mtb_com_message_history')
                  .update({
                    'read_status': '1',
                    'update_time': DateTime.now().toString(),
                    'update_id': StoreProvider.of<WMSState>(state.rootContext)
                        .state
                        .loginUser
                        ?.id,
                  })
                  .eq('id', noticeList[state.index]['id'])
                  .select('*');
              // 判断数据是否更新成功
              if (updNoticeData.length != 0) {
                //消息状态更新
                noticeData[state.index]['read_status'] =
                    updNoticeData[0]['read_status'];
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.rootContext)!
                            .home_head_notice_text2 +
                        WMSLocalizations.i18n(state.rootContext)!.update_error);
              }
            }
          }
          noticeList[state.index]['selected'] = true;
          noticeData[state.index]['selected'] = true;
          //右侧内容
          state.noticeContent = noticeData[state.index];
        } else {
          //初始化
          state.index = -1;
          state.noticeContent = {};
        }

        //消息列表
        state.noticeList = noticeData;
        //更新弹框中显示的消息列表
        StoreProvider.of<WMSState>(state.rootContext)
            .dispatch(RefreshCurrentParamAction(noticeData));
      } else {
        //初始化
        state.index = -1;
        state.noticeContent = {};
      }
      //传入参数，控制消息页面刷新
      StoreProvider.of<WMSState>(state.rootContext)
          .dispatch(RefreshCurrentFlagAction(false));
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 查询消息列表-sp
    on<QueryNoticeSPEventInit>((event, emit) async {
      BotToast.showLoading();
      //获取消息列表下标
      int currentIndex =
          StoreProvider.of<WMSState>(state.rootContext).state.currentIndex;
      //赋值
      state.index = currentIndex;
      // 查询消息列表
      List<dynamic> noticeData = await SupabaseUtils.getClient()
          .rpc('func_query_dialog_notice_message', params: {
        'user_id':
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id
      }).select('*');
      //判断是否存在未读消息
      List<dynamic> list =
          noticeData.where((element) => element["read_status"] == '2').toList();
      if (list.length != 0) {
        //存在未读信息
        StoreProvider.of<WMSState>(state.rootContext)
            .dispatch(RefreshCurrentNoticeFlagAction(true));
      } else {
        //不存在未读信息
        StoreProvider.of<WMSState>(state.rootContext)
            .dispatch(RefreshCurrentNoticeFlagAction(false));
      }
      //左侧列表日期转换
      for (var i = 0; i < noticeData.length; i++) {
        //日期转换
        DateTime date = DateTime.parse(noticeData[i]['create_time']);
        noticeData[i]['left_date'] =
            date.month.toString() + '月' + date.day.toString() + '日';
      }
      if (state.index != -1) {
        // 判断右侧内容是否显示
        List<dynamic> noticeList =
            StoreProvider.of<WMSState>(state.rootContext).state.currentParam;
        List<dynamic> updNoticeData = [];
        if (noticeList[state.index]['read_status'] == '2') {
          if (noticeList[state.index]['message_kbn'] == 'ytb') {
            //系统通知
            updNoticeData = await SupabaseUtils.getClient()
                .from('ytb_message_history')
                .update({
                  'read_status': '1',
                  'update_time': DateTime.now().toString(),
                  'update_id': StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.id,
                })
                .eq('id', noticeList[state.index]['id'])
                .select('*');
            // 判断数据是否更新成功
            if (updNoticeData.length != 0) {
              //消息状态更新
              noticeData[state.index]['read_status'] =
                  updNoticeData[0]['read_status'];
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!
                          .home_head_notice_text2 +
                      WMSLocalizations.i18n(state.rootContext)!.update_error);
            }
          } else if (noticeList[state.index]['message_kbn'] == 'mtb') {
            //其余通知
            updNoticeData = await SupabaseUtils.getClient()
                .from('mtb_com_message_history')
                .update({
                  'read_status': '1',
                  'update_time': DateTime.now().toString(),
                  'update_id': StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.id,
                })
                .eq('id', noticeList[state.index]['id'])
                .select('*');
            // 判断数据是否更新成功
            if (updNoticeData.length != 0) {
              //消息状态更新
              noticeData[state.index]['read_status'] =
                  updNoticeData[0]['read_status'];
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.rootContext)!
                          .home_head_notice_text2 +
                      WMSLocalizations.i18n(state.rootContext)!.update_error);
            }
          }
        }
        //右侧内容
        state.noticeContent = noticeData[state.index];
      } else {
        //初始化
        state.index = -1;
        state.noticeContent = {};
      }

      //消息列表
      state.noticeList = noticeData;
      //更新弹框中显示的消息列表
      StoreProvider.of<WMSState>(state.rootContext)
          .dispatch(RefreshCurrentParamAction(noticeData));
      //传入参数，控制上一消息页面刷新
      StoreProvider.of<WMSState>(state.rootContext)
          .dispatch(RefreshCurrentFlagAction(false));
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 判断右侧内容是否显示
    on<RightShowNoticeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      List<dynamic> noticeList = state.noticeList;
      //修改消息状态，未读变为已读
      List<dynamic> noticeData = [];
      if (noticeList[event.i]['read_status'] == '2') {
        if (noticeList[event.i]['message_kbn'] == 'ytb') {
          //系统通知
          noticeData = await SupabaseUtils.getClient()
              .from('ytb_message_history')
              .update({
                'read_status': '1',
                'update_time': DateTime.now().toString(),
                'update_id': StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id,
              })
              .eq('id', noticeList[event.i]['id'])
              .select('*');
          // 判断数据是否更新成功
          if (noticeData.length != 0) {
            //消息状态更新
            noticeList[event.i]['read_status'] = noticeData[0]['read_status'];
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
          }
        } else if (noticeList[event.i]['message_kbn'] == 'mtb') {
          //其余通知
          noticeData = await SupabaseUtils.getClient()
              .from('mtb_com_message_history')
              .update({
                'read_status': '1',
                'update_time': DateTime.now().toString(),
                'update_id': StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id,
              })
              .eq('id', noticeList[event.i]['id'])
              .select('*');
          // 判断数据是否更新成功
          if (noticeData.length != 0) {
            //消息状态更新
            noticeList[event.i]['read_status'] = noticeData[0]['read_status'];
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
          }
        }
      }

      state.index = event.i;
      noticeList[event.i]['selected'] = true;
      //右侧内容
      state.noticeContent = noticeList[event.i];

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除内容-pc
    on<DelNoticeEvent>((event, emit) async {
      try {
        //传入参数，控制消息页面刷新
        StoreProvider.of<WMSState>(state.rootContext)
            .dispatch(RefreshCurrentFlagAction(true));
        // 打开加载状态
        BotToast.showLoading();
        if (event.noticeContent['message_kbn'] == 'ytb') {
          //系统通知
          List<Map<String, dynamic>> noticeData =
              await SupabaseUtils.getClient()
                  .from('ytb_message_history')
                  .update({
                    'status': '2',
                    'update_time': DateTime.now().toString(),
                    'update_id': StoreProvider.of<WMSState>(state.rootContext)
                        .state
                        .loginUser
                        ?.id,
                  })
                  .eq('id', event.noticeContent['id'])
                  .select('*');
          // 判断数据是否删除成功
          if (noticeData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_success);
            // 查询消息列表
            add(QueryNoticeEventInit());
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_error);
          }
          return;
        } else if (event.noticeContent['message_kbn'] == 'mtb') {
          //其余通知
          List<Map<String, dynamic>> noticeData =
              await SupabaseUtils.getClient()
                  .from('mtb_com_message_history')
                  .update({
                    'status': '2',
                    'update_time': DateTime.now().toString(),
                    'update_id': StoreProvider.of<WMSState>(state.rootContext)
                        .state
                        .loginUser
                        ?.id,
                  })
                  .eq('id', event.noticeContent['id'])
                  .select('*');
          // 判断数据是否删除成功
          if (noticeData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_success);
            // 查询消息列表
            add(QueryNoticeEventInit());
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_error);
          }
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.home_head_notice_text2 +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        return;
      }
    });
    // 删除内容-sp
    on<DelNoticeSpEvent>((event, emit) async {
      try {
        //传入参数，控制消息页面刷新
        StoreProvider.of<WMSState>(state.rootContext)
            .dispatch(RefreshCurrentFlagAction(true));
        // 打开加载状态
        BotToast.showLoading();
        if (event.noticeContent['message_kbn'] == 'ytb') {
          //系统通知
          List<Map<String, dynamic>> noticeData =
              await SupabaseUtils.getClient()
                  .from('ytb_message_history')
                  .update({
                    'status': '2',
                    'update_time': DateTime.now().toString(),
                    'update_id': StoreProvider.of<WMSState>(state.rootContext)
                        .state
                        .loginUser
                        ?.id,
                  })
                  .eq('id', event.noticeContent['id'])
                  .select('*');
          // 判断数据是否删除成功
          if (noticeData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_success);
            // 返回上一页
            GoRouter.of(state.rootContext).pop();
            // 查询消息列表
            add(QueryNoticeEventInit());
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_error);
          }
          return;
        } else if (event.noticeContent['message_kbn'] == 'mtb') {
          //其余通知
          List<Map<String, dynamic>> noticeData =
              await SupabaseUtils.getClient()
                  .from('mtb_com_message_history')
                  .update({
                    'status': '2',
                    'update_time': DateTime.now().toString(),
                    'update_id': StoreProvider.of<WMSState>(state.rootContext)
                        .state
                        .loginUser
                        ?.id,
                  })
                  .eq('id', event.noticeContent['id'])
                  .select('*');
          // 判断数据是否删除成功
          if (noticeData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_success);
            // 返回上一页
            GoRouter.of(state.rootContext).pop();
            // 查询消息列表
            add(QueryNoticeEventInit());
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!
                        .home_head_notice_text2 +
                    WMSLocalizations.i18n(state.rootContext)!.delete_error);
          }
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.home_head_notice_text2 +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        return;
      }
    });

    // 点击消息按钮1事件
    on<ClickMessageButtonOneEvent>((event, emit) async {
      // 判断消息类型
      if (state.noticeContent['push_kbn'] == 1) {
        // 跳转页面
        GoRouter.of(state.rootContext).go('/' + Config.PAGE_FLAG_98_25);
      } else if (state.noticeContent['push_kbn'] == 2) {
        // 跳转页面
        GoRouter.of(state.rootContext).go('/' + Config.PAGE_FLAG_98_26);
      }
    });

    // 点击消息按钮2事件
    on<ClickMessageButtonTwoEvent>((event, emit) async {
      // 复制文本
      await Clipboard.setData(ClipboardData(text: Config.BASE_URL + '/login'));
      // 成功提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.rootContext)!.option_share_copy_success);
    });

    add(InitEvent());
  }
}
