import 'package:flutter/cupertino.dart';

/**
 * 内容：消息列表-参数
 * 作者：luxy
 * 时间：2023/10/07
 */
class NoticeModel {
  // 克隆
  factory NoticeModel.clone(NoticeModel src) {
    NoticeModel dest = NoticeModel(rootContext: src.rootContext);
    dest.noticeContent = src.noticeContent;
    dest.noticeList = src.noticeList;
    dest.languageList = src.languageList;
    dest.index = src.index;
    return dest;
  }

  // 根结构树
  BuildContext rootContext;
  //选中通知内容
  Map<String, dynamic> noticeContent = {};
  //下标
  int index = -1;
  //消息列表
  List<dynamic> noticeList = [];
  // 多语言列表
  List<Map<String, dynamic>> languageList = [];

  // 构造函数
  NoticeModel({
    required this.rootContext,
    this.noticeContent = const {
      'id': '',
      'title': '',
      'selected': false,
      'create_time': '',
      'message': '',
      'status': '',
      'user_id': '',
      'read_status': ''
    },
    this.index = -1,
    this.noticeList = const [],
    this.languageList = const [],
  });
}
