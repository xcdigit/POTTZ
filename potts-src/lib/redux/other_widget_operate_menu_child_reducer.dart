import 'package:redux/redux.dart';

/**
 * 内容：持久化状态：其他容器操作菜单子级
 * 作者：赵士淞
 * 时间：2023/08/04
 */
final OtherWidgetOperateMenuChildReducer = combineReducers<bool>([
  TypedReducer<bool, RefreshOtherWidgetOperateMenuChildAction>(_refresh),
]);

bool _refresh(bool otherWidgetOperateMenuChild,
    RefreshOtherWidgetOperateMenuChildAction action) {
  otherWidgetOperateMenuChild = action.otherWidgetOperateMenuChild;
  return otherWidgetOperateMenuChild;
}

class RefreshOtherWidgetOperateMenuChildAction {
  final bool otherWidgetOperateMenuChild;

  RefreshOtherWidgetOperateMenuChildAction(this.otherWidgetOperateMenuChild);
}
