import 'package:redux/redux.dart';

import '../model/user.dart';

/**
 * 内容：持久化状态：登录用户
 * 作者：赵士淞
 * 时间：2023/09/08
 */
final LoginUserReducer = combineReducers<User?>([
  TypedReducer<User?, RefreshLoginUserAction>(_refresh),
]);

User? _refresh(User? loginUser, RefreshLoginUserAction action) {
  loginUser = action.loginUser;
  return loginUser;
}

class RefreshLoginUserAction {
  final User? loginUser;

  RefreshLoginUserAction(this.loginUser);
}
