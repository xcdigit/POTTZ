import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：首次进入首页
 * 作者：赵士淞
 * 时间：2024/08/28
 */
final FirstEnterHomeReducer = combineReducers<bool>([
  TypedReducer<bool, RefreshFirstEnterHomeAction>(_refresh),
]);

bool _refresh(bool firstEnterHomeFlag, RefreshFirstEnterHomeAction action) {
  firstEnterHomeFlag = action.firstEnterHomeFlag;
  return firstEnterHomeFlag;
}

class RefreshFirstEnterHomeAction {
  final bool firstEnterHomeFlag;

  RefreshFirstEnterHomeAction(this.firstEnterHomeFlag);
}
