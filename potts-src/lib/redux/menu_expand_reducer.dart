import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：菜单展开
 * 作者：赵士淞
 * 时间：2023/07/31
 */
final MenuExpandReducer = combineReducers<bool>([
  TypedReducer<bool, RefreshMenuExpandAction>(_refresh),
]);

bool _refresh(bool menuExpand, RefreshMenuExpandAction action) {
  menuExpand = action.menuExpand;
  return menuExpand;
}

class RefreshMenuExpandAction {
  final bool menuExpand;

  RefreshMenuExpandAction(this.menuExpand);
}
