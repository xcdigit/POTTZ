import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：登录权限
 * 作者：赵士淞
 * 时间：2023/12/19
 */
final LoginAuthorityReducer = combineReducers<List<dynamic>>([
  TypedReducer<List<dynamic>, RefreshLoginAuthorityAction>(_refresh),
]);

List<dynamic> _refresh(
    List<dynamic> loginAuthority, RefreshLoginAuthorityAction action) {
  loginAuthority = action.loginAuthority;
  return loginAuthority;
}

class RefreshLoginAuthorityAction {
  final List<dynamic> loginAuthority;

  RefreshLoginAuthorityAction(this.loginAuthority);
}
