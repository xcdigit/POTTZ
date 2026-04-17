import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：页面参数
 * 作者：luxy
 * 时间：2023/08/22
 */

final CurrentParamReducer = combineReducers<dynamic>([
  TypedReducer<dynamic, RefreshCurrentParamAction>(_refresh),
]);

dynamic _refresh(dynamic currentParam, RefreshCurrentParamAction action) {
  currentParam = action.currentParam;
  return currentParam;
}

class RefreshCurrentParamAction {
  final dynamic currentParam;

  RefreshCurrentParamAction(this.currentParam);
}
