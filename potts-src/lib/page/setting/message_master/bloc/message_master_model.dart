import 'package:flutter/material.dart';

import '../../../../common/config/config.dart';

/**
 * 内容：消息管理-参数
 * 作者：赵士淞
 * 时间：2024/07/11
 */
class MessageMasterModel {
  // 克隆
  factory MessageMasterModel.clone(MessageMasterModel src) {
    MessageMasterModel dest = MessageMasterModel(rootContext: src.rootContext);
    dest.messageList = src.messageList;
    dest.userList = src.userList;
    dest.currentMenuIndex = src.currentMenuIndex;
    dest.searchMessageText = src.searchMessageText;
    dest.selectMessageIndex = src.selectMessageIndex;
    dest.searchUserText = src.searchUserText;
    dest.selectUserIndex = src.selectUserIndex;
    dest.inputMessageTitle = src.inputMessageTitle;
    dest.inputMessageContent = src.inputMessageContent;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  // 消息列表
  List<dynamic> messageList;
  // 用户列表
  List<dynamic> userList;
  // 当前菜单下标
  int currentMenuIndex;
  // 搜索消息文本
  String searchMessageText;
  // 选中消息下标
  int selectMessageIndex;
  // 搜索用户文本
  String searchUserText;
  // 选中用户下标
  int selectUserIndex;
  // 输入消息标题
  String inputMessageTitle;
  // 输入消息内容
  String inputMessageContent;

  // 构造函数
  MessageMasterModel({
    required this.rootContext,
    this.messageList = const [],
    this.userList = const [],
    this.currentMenuIndex = Config.NUMBER_ZERO,
    this.searchMessageText = '',
    this.selectMessageIndex = Config.NUMBER_NEGATIVE,
    this.searchUserText = '',
    this.selectUserIndex = Config.NUMBER_NEGATIVE,
    this.inputMessageTitle = '',
    this.inputMessageContent = '',
  });
}
