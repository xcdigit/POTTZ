import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：解约画面跳转状态
 * 作者：muzd
 * 时间：2023/12/15
 */

final ContractFlagReducer = combineReducers<bool>([
  TypedReducer<bool, RefreshContractFlagAction>(_refresh),
]);

bool _refresh(bool contractFlag, RefreshContractFlagAction action) {
  contractFlag = action.contractFlag;
  return contractFlag;
}

class RefreshContractFlagAction {
  final bool contractFlag;

  RefreshContractFlagAction(this.contractFlag);
}
