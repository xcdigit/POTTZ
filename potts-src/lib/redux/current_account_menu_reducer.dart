import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：当前账户菜单
 * 作者：赵士淞
 * 时间：2023/08/16
 */
final CurrentAccountMenuReducer = combineReducers<int>([
  TypedReducer<int, RefreshCurrentAccountMenuAction>(_refresh),
]);

int _refresh(int currentAccountMenu, RefreshCurrentAccountMenuAction action) {
  currentAccountMenu = action.currentAccountMenu;
  return currentAccountMenu;
}

class RefreshCurrentAccountMenuAction {
  final int currentAccountMenu;

  RefreshCurrentAccountMenuAction(this.currentAccountMenu);
}
