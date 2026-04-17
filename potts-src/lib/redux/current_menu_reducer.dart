import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：当前菜单
 * 作者：赵士淞
 * 时间：2023/07/31
 */
final CurrentMenuReducer = combineReducers<int>([
  TypedReducer<int, RefreshCurrentMenuAction>(_refresh),
]);

int _refresh(int currentMenu, RefreshCurrentMenuAction action) {
  currentMenu = action.currentMenu;
  return currentMenu;
}

class RefreshCurrentMenuAction {
  final int currentMenu;

  RefreshCurrentMenuAction(this.currentMenu);
}
