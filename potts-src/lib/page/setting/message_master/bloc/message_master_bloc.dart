import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/format_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/message.dart';
import '../../../../model/message_history.dart';
import '../../../../redux/wms_state.dart';
import 'message_master_model.dart';

/**
 * 内容：消息管理-BLOC
 * 作者：赵士淞
 * 时间：2024/07/11
 */
// 事件
abstract class MessageMasterEvent {}

// 初始化事件
class InitEvent extends MessageMasterEvent {
  // 初始化事件
  InitEvent();
}

// 设置当前菜单下标事件
class SetCurrentMenuIndexEvent extends MessageMasterEvent {
  // 当前菜单下标
  int currentMenuIndex;

  // 设置当前菜单下标事件
  SetCurrentMenuIndexEvent(this.currentMenuIndex);
}

// 设置搜索消息文本事件
class SetSearchMessageTextEvent extends MessageMasterEvent {
  // 搜索消息文本
  String searchMessageText;

  // 设置搜索消息文本事件
  SetSearchMessageTextEvent(this.searchMessageText);
}

// 设置选中消息下标事件
class SetSelectMessageIndexEvent extends MessageMasterEvent {
  // 选中消息下标
  int selectMessageIndex;

  // 设置选中消息下标事件
  SetSelectMessageIndexEvent(this.selectMessageIndex);
}

// 删除消息事件
class DeleteMessageEvent extends MessageMasterEvent {
  // 消息ID
  int messageId;

  // 删除消息事件
  DeleteMessageEvent(this.messageId);
}

// 设置搜索用户文本事件
class SetSearchUserTextEvent extends MessageMasterEvent {
  // 搜索用户文本
  String searchUserText;

  // 设置搜索用户文本事件
  SetSearchUserTextEvent(this.searchUserText);
}

// 设置选中用户下标事件
class SetSelectUserIndexEvent extends MessageMasterEvent {
  // 选中用户下标
  int selectUserIndex;

  // 设置选中用户下标事件
  SetSelectUserIndexEvent(this.selectUserIndex);
}

// 设置输入消息标题事件
class SetInputMessageTitleEvent extends MessageMasterEvent {
  // 值
  String value;

  // 设置输入消息标题事件
  SetInputMessageTitleEvent(this.value);
}

// 设置输入消息内容事件
class SetInputMessageContentEvent extends MessageMasterEvent {
  // 值
  String value;

  // 设置输入消息内容事件
  SetInputMessageContentEvent(this.value);
}

// 点击发送邮件给一个人事件
class ClickSendEmailToOneEvent extends MessageMasterEvent {
  // 点击发送邮件给一个人事件
  ClickSendEmailToOneEvent();
}

// 点击发送邮件给所有人事件
class ClickSendEmailToAllEvent extends MessageMasterEvent {
  // 点击发送邮件给所有人事件
  ClickSendEmailToAllEvent();
}

// 点击发送邮件给所有有效人事件
class ClickSendEmailToAllValidEvent extends MessageMasterEvent {
  // 点击发送邮件给所有有效人事件
  ClickSendEmailToAllValidEvent();
}

class MessageMasterBloc extends Bloc<MessageMasterEvent, MessageMasterModel> {
  // 刷新补丁
  MessageMasterModel clone(MessageMasterModel src) {
    return MessageMasterModel.clone(src);
  }

  MessageMasterBloc(MessageMasterModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询消息关联数据
      await selectMessageHistoryData(state);
      // 查询用户数据
      await selectUserData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置当前菜单下标事件
    on<SetCurrentMenuIndexEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 当前菜单下标
      state.currentMenuIndex = event.currentMenuIndex;
      // 搜索消息文本
      state.searchMessageText = '';
      // 选中消息下标
      state.selectMessageIndex = Config.NUMBER_NEGATIVE;
      // 搜索用户文本
      state.searchUserText = '';
      // 选中用户下标
      state.selectUserIndex = Config.NUMBER_NEGATIVE;
      // 输入消息标题
      state.inputMessageTitle = '';
      // 输入消息内容
      state.inputMessageContent = '';
      // 查询消息关联数据
      await selectMessageHistoryData(state);
      // 查询用户数据
      await selectUserData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置搜索消息文本事件
    on<SetSearchMessageTextEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 搜索消息文本
      state.searchMessageText = event.searchMessageText;
      // 选中消息下标
      state.selectMessageIndex = Config.NUMBER_NEGATIVE;
      // 查询消息关联数据
      await selectMessageHistoryData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置选中消息下标事件
    on<SetSelectMessageIndexEvent>((event, emit) async {
      // 选中消息下标
      state.selectMessageIndex = event.selectMessageIndex;

      // 更新
      emit(clone(state));
    });

    // 删除消息事件
    on<DeleteMessageEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 选中消息下标
      state.selectMessageIndex = Config.NUMBER_NEGATIVE;
      // 删除消息
      await SupabaseUtils.getClient().from('ytb_message').update({
        'del_kbn': '1',
      }).eq('id', event.messageId);
      // 成功提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.rootContext)!.message_master_base_title +
              WMSLocalizations.i18n(state.rootContext)!.delete_success);
      // 查询消息关联数据
      await selectMessageHistoryData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置搜索用户文本事件
    on<SetSearchUserTextEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 搜索用户文本
      state.searchUserText = event.searchUserText;
      // 选中用户下标
      state.selectUserIndex = Config.NUMBER_NEGATIVE;
      // 输入消息标题
      state.inputMessageTitle = '';
      // 输入消息内容
      state.inputMessageContent = '';
      // 查询用户数据
      await selectUserData(state);

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置选中用户下标事件
    on<SetSelectUserIndexEvent>((event, emit) async {
      // 选中用户下标
      state.selectUserIndex = event.selectUserIndex;
      // 输入消息标题
      state.inputMessageTitle = '';
      // 输入消息内容
      state.inputMessageContent = '';

      // 更新
      emit(clone(state));
    });

    // 设置输入消息标题事件
    on<SetInputMessageTitleEvent>((event, emit) async {
      // 输入消息标题
      state.inputMessageTitle = event.value;
    });

    // 设置输入消息内容事件
    on<SetInputMessageContentEvent>((event, emit) async {
      // 输入消息内容
      state.inputMessageContent = event.value;
    });

    // 点击发送邮件给一个人事件
    on<ClickSendEmailToOneEvent>((event, emit) async {
      // 发送邮件检查
      bool flag = sendEmailCheck(state);
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 新增消息数据
        int messageId = await addMessageData(state);
        // 新增消息历史数据
        await addMessageHistoryData(state, messageId,
            [state.userList[state.selectUserIndex]['user_id']]);
        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_confirm_text_success);
        // 输入消息标题
        state.inputMessageTitle = '';
        // 输入消息内容
        state.inputMessageContent = '';

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 点击发送邮件给所有人事件
    on<ClickSendEmailToAllEvent>((event, emit) async {
      // 发送邮件检查
      bool flag = sendEmailCheck(state);
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 新增消息数据
        int messageId = await addMessageData(state);
        // 查询会社用户关联情报
        List<dynamic> formList = await SupabaseUtils.getClient().rpc(
            'func_zhaoss_query_table_ytb_company_manage_corporation',
            params: {
              'p_company_name': '',
              'p_company_id': null,
            }).select("*");
        // 用户ID列表
        List<int> userIdList = [];
        // 循环会社用户关联情报
        for (int i = 0; i < formList.length; i++) {
          // 用户ID列表
          userIdList.add(formList[i]['user_id']);
        }
        // 新增消息历史数据
        await addMessageHistoryData(state, messageId, userIdList);
        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_confirm_text_success);
        // 输入消息标题
        state.inputMessageTitle = '';
        // 输入消息内容
        state.inputMessageContent = '';

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 点击发送邮件给所有有效人事件
    on<ClickSendEmailToAllValidEvent>((event, emit) async {
      // 发送邮件检查
      bool flag = sendEmailCheck(state);
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 新增消息数据
        int messageId = await addMessageData(state);
        // 查询会社用户关联情报
        List<dynamic> formList = await SupabaseUtils.getClient().rpc(
            'func_zhaoss_query_table_ytb_company_manage_corporation',
            params: {
              'p_company_name': '',
              'p_company_id': null,
            }).select("*");
        // 用户ID列表
        List<int> userIdList = [];
        // 循环会社用户关联情报
        for (int i = 0; i < formList.length; i++) {
          // 判断开始时间与结束时间是否为空
          if (formList[i]['start_date'] != null &&
              formList[i]['start_date'] != '' &&
              formList[i]['next_date'] != null &&
              formList[i]['next_date'] != '') {
            // 开始时间
            String startDateFormat =
                FormatUtils.dateTimeFormat(formList[i]['start_date']);
            DateTime startDate = DateTime.parse(startDateFormat);
            // 结束时间
            String nextDateFormat =
                FormatUtils.dateTimeFormat(formList[i]['next_date']);
            DateTime nextDate = DateTime.parse(nextDateFormat);
            // 当前时间
            DateTime now = DateTime.now();
            // 判断是否在有效时间之内
            if (startDate.isBefore(now) && nextDate.isAfter(now)) {
              // 用户ID列表
              userIdList.add(formList[i]['user_id']);
            }
          }
        }
        // 新增消息历史数据
        await addMessageHistoryData(state, messageId, userIdList);
        // 成功提示
        WMSCommonBlocUtils.successTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_confirm_text_success);
        // 输入消息标题
        state.inputMessageTitle = '';
        // 输入消息内容
        state.inputMessageContent = '';

        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    add(InitEvent());
  }

  // 查询消息关联数据
  Future<void> selectMessageHistoryData(MessageMasterModel state) async {
    // 消息关联情报
    List<dynamic> formList = [];
    // 判断当前菜单下标
    if (state.currentMenuIndex == Config.NUMBER_ZERO) {
      // 查询消息关联情报
      formList = await SupabaseUtils.getClient()
          .rpc('func_zhaoss_query_ytb_message_history_send', params: {
        'p_message_title': state.searchMessageText,
        'p_user_id':
            StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id
      }).select("*");
    }
    // 消息列表
    state.messageList = formList;
  }

  // 查询用户数据
  Future<void> selectUserData(MessageMasterModel state) async {
    // 会社用户关联情报
    List<dynamic> formList = [];
    // 判断当前菜单下标
    if (state.currentMenuIndex == Config.NUMBER_ONE) {
      // 查询会社用户关联情报
      formList = await SupabaseUtils.getClient().rpc(
          'func_zhaoss_query_table_ytb_company_manage_corporation',
          params: {
            'p_company_name': state.searchUserText,
            'p_company_id': null,
          }).select("*");
    }
    // 用户列表
    state.userList = formList;
  }

  // 发送邮件检查
  bool sendEmailCheck(MessageMasterModel state) {
    // 判断
    if (state.inputMessageTitle == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.message_title +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    } else if (state.inputMessageTitle.length > 30) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.message_title +
              WMSLocalizations.i18n(state.rootContext)!
                  .message_cannot_exceed_30_characters);
      return false;
    } else if (state.inputMessageContent == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.message_content +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    }
    // 返回
    return true;
  }

  // 新增消息数据
  Future<int> addMessageData(MessageMasterModel state) async {
    // 消息新增
    Message message = Message.fromJson({});
    message.title = state.inputMessageTitle;
    message.message = state.inputMessageContent;
    message.push_kbn = 0;
    message.del_kbn = '2';
    message.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    message.create_time = DateTime.now().toString();
    message.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    message.update_time = DateTime.now().toString();
    List<Map<String, dynamic>> messageList = await SupabaseUtils.getClient()
        .from('ytb_message')
        .insert([message.toJson()]).select('*');
    return messageList[0]['id'];
  }

  // 新增消息历史数据
  Future<void> addMessageHistoryData(
      MessageMasterModel state, int messageId, List<int> userIdList) async {
    // 消息历史列表
    List<Map<String, dynamic>> messageHistoryList = [];
    // 循环用户ID列表
    for (int i = 0; i < userIdList.length; i++) {
      // 消息历史
      MessageHistory messageHistory = MessageHistory.fromJson({});
      messageHistory.message_kbn = 'ytb';
      messageHistory.message_id = messageId;
      messageHistory.status = '1';
      messageHistory.read_status = '2';
      messageHistory.user_id = userIdList[i];
      messageHistory.create_id =
          StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
      messageHistory.create_time = DateTime.now().toString();
      messageHistory.update_id =
          StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
      messageHistory.update_time = DateTime.now().toString();
      // 消息历史列表
      messageHistoryList.add(messageHistory.toJson());
    }
    // 消息历史新增
    await SupabaseUtils.getClient()
        .from('ytb_message_history')
        .insert(messageHistoryList);
  }
}
