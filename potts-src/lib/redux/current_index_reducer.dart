import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：参数
 * 作者：luxy
 * 时间：2023/10/09
 */

final CurrentIndexReducer = combineReducers<int>([
  TypedReducer<int, RefreshCurrentIndexAction>(_refresh),
]);

int _refresh(int currentIndex, RefreshCurrentIndexAction action) {
  currentIndex = action.currentIndex;
  return currentIndex;
}

class RefreshCurrentIndexAction {
  final int currentIndex;

  RefreshCurrentIndexAction(this.currentIndex);
}
