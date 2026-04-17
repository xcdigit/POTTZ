import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：当前法人管理菜单
 * 作者：muzd
 * 时间：2024/06/25
 */
final CurrentCorporateMenuReducer = combineReducers<int>([
  TypedReducer<int, RefreshCurrentCorporateMenuAction>(_refresh),
]);

int _refresh(int currentCorporateMenu, RefreshCurrentCorporateMenuAction action) {
  currentCorporateMenu = action.currentCorporateMenu;
  return currentCorporateMenu;
}

class RefreshCurrentCorporateMenuAction {
  final int currentCorporateMenu;

  RefreshCurrentCorporateMenuAction(this.currentCorporateMenu);
}
