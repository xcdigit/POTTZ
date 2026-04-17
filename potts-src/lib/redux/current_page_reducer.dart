import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：当前页面
 * 作者：赵士淞
 * 时间：2023/07/27
 */
final CurrentPageReducer = combineReducers<String>([
  TypedReducer<String, RefreshCurrentPageAction>(_refresh),
]);

String _refresh(String currentPage, RefreshCurrentPageAction action) {
  currentPage = action.currentPage;
  return currentPage;
}

class RefreshCurrentPageAction {
  final String currentPage;

  RefreshCurrentPageAction(this.currentPage);
}
