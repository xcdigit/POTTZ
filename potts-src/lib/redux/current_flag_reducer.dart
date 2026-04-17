import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：参数
 * 作者：luxy
 * 时间：2023/10/09
 */

final CurrentFlagReducer = combineReducers<bool>([
  TypedReducer<bool, RefreshCurrentFlagAction>(_refresh),
]);

bool _refresh(bool currentFlag, RefreshCurrentFlagAction action) {
  currentFlag = action.currentFlag;
  return currentFlag;
}

class RefreshCurrentFlagAction {
  final bool currentFlag;

  RefreshCurrentFlagAction(this.currentFlag);
}
