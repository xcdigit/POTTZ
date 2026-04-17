import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：页面参数
 * 作者：muzd
 * 时间：2023/12/19
 */

final ContractParamReducer = combineReducers<dynamic>([
  TypedReducer<dynamic, RefreshContractParamAction>(_refresh),
]);

dynamic _refresh(dynamic contractParam, RefreshContractParamAction action) {
  contractParam = action.contractParam;
  return contractParam;
}

class RefreshContractParamAction {
  final dynamic contractParam;

  RefreshContractParamAction(this.contractParam);
}
