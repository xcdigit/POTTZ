import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：参数
 * 作者：luxy
 * 时间：2023/11/08
 */

final CurrentNoticeFlagReducer = combineReducers<bool>([
  TypedReducer<bool, RefreshCurrentNoticeFlagAction>(_refresh),
]);

bool _refresh(bool currentNoticeFlag, RefreshCurrentNoticeFlagAction action) {
  currentNoticeFlag = action.currentNoticeFlag;
  return currentNoticeFlag;
}

class RefreshCurrentNoticeFlagAction {
  final bool currentNoticeFlag;

  RefreshCurrentNoticeFlagAction(this.currentNoticeFlag);
}
