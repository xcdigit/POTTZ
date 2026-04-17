import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';

/**
 * 内容：消息管理-用户列表
 * 作者：赵士淞
 * 时间：2025/01/02
 */
class MessageMasterUserList extends StatefulWidget {
  const MessageMasterUserList({super.key});

  @override
  State<MessageMasterUserList> createState() => _MessageMasterUserListState();
}

class _MessageMasterUserListState extends State<MessageMasterUserList> {
  // 初始化用户列表
  List<Widget> _initUserList(List userItemList) {
    // 用户列表
    List<Widget> userList = [];

    // 循环用户单个列表
    for (int i = 0; i < userItemList.length; i++) {
      // 用户列表
      userList.add(
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onPanDown: (details) {
                // 设置选中用户下标事件
                context
                    .read<MessageMasterBloc>()
                    .add(SetSelectUserIndexEvent(i));
              },
              child: Container(
                height: 82,
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    bottom: BorderSide(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context
                                .read<MessageMasterBloc>()
                                .state
                                .selectUserIndex ==
                            i
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(255, 255, 255, 0),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        WMSICons.PLAN_ICON,
                        width: 30,
                        height: 30,
                      ),
                      Container(
                        width: 245,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: Text(
                                userItemList[i]['company_name'] == null
                                    ? ''
                                    : userItemList[i]['company_name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              userItemList[i]['user_name'] == null
                                  ? ''
                                  : userItemList[i]['user_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(156, 156, 156, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              (userItemList[i]['addr_1'] == null
                                      ? ''
                                      : userItemList[i]['addr_1']) +
                                  (userItemList[i]['addr_2'] == null
                                      ? ''
                                      : userItemList[i]['addr_2']) +
                                  (userItemList[i]['addr_3'] == null
                                      ? ''
                                      : userItemList[i]['addr_3']),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(156, 156, 156, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 11,
              right: -40,
              child: Container(
                width:
                    context.read<MessageMasterBloc>().state.selectUserIndex == i
                        ? 20
                        : 0,
                height: 30,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(240, 250, 250, 1),
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 0,
                    ),
                    left: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 0,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 11,
              right: -40,
              child: Container(
                width:
                    context.read<MessageMasterBloc>().state.selectUserIndex == i
                        ? 20
                        : 0,
                height: 30,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(240, 250, 250, 1),
                  border: Border(
                    top: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 0,
                    ),
                    right: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 1,
                    ),
                    bottom: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      width: 0,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageMasterBloc, MessageMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 54, 0, 20),
          padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
          decoration: BoxDecoration(
            color: Color.fromRGBO(240, 250, 250, 1),
            border: Border.all(
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: WMSInputboxWidget(
                  backgroundColor: Color.fromRGBO(251, 251, 251, 1),
                  borderColor: Color.fromRGBO(224, 224, 224, 1),
                  text: state.searchUserText,
                  hintText: WMSLocalizations.i18n(context)!
                      .corporate_management_text_14,
                  prefixIcon: Container(
                    padding: EdgeInsets.fromLTRB(0, 14, 0, 10),
                    child: Image.asset(
                      WMSICons.HOME_HEAD_SEARCH,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      repeat: ImageRepeat.noRepeat,
                    ),
                  ),
                  inputBoxCallBack: (value) {
                    // 设置搜索用户文本事件
                    context
                        .read<MessageMasterBloc>()
                        .add(SetSearchUserTextEvent(value));
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100 - 134 - 80,
                child: state.userList.length == 0
                    ? Center(
                        child: Text(
                          WMSLocalizations.i18n(context)!.no_items_found,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : ListView(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.vertical,
                        children: _initUserList(state.userList),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
