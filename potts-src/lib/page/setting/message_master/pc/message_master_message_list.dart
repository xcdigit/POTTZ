import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../common/utils/format_utils.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';

/**
 * 内容：消息管理-消息列表
 * 作者：赵士淞
 * 时间：2025/01/02
 */
class MessageMasterMessageList extends StatefulWidget {
  const MessageMasterMessageList({super.key});

  @override
  State<MessageMasterMessageList> createState() =>
      _MessageMasterMessageListState();
}

class _MessageMasterMessageListState extends State<MessageMasterMessageList> {
  // 初始化消息列表
  List<Widget> _initMessageList(List messageItemList) {
    // 消息列表
    List<Widget> messageList = [];

    // 循环消息单个列表
    for (int i = 0; i < messageItemList.length; i++) {
      // 消息列表
      messageList.add(
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onPanDown: (details) {
                // 设置选中消息下标事件
                context
                    .read<MessageMasterBloc>()
                    .add(SetSelectMessageIndexEvent(i));
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
                                .selectMessageIndex ==
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
                        width: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                              child: Text(
                                messageItemList[i]['message_title'],
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
                              messageItemList[i]['company_name'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(156, 156, 156, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              messageItemList[i]['message'],
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
                      Container(
                        width: 55,
                        alignment: Alignment.topRight,
                        child: Text(
                          FormatUtils.dateTimeFormat(
                              messageItemList[i]['create_time']),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(44, 167, 176, 1),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
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
                width: context
                            .read<MessageMasterBloc>()
                            .state
                            .selectMessageIndex ==
                        i
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
                width: context
                            .read<MessageMasterBloc>()
                            .state
                            .selectMessageIndex ==
                        i
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

    return messageList;
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
                  text: state.searchMessageText,
                  hintText: WMSLocalizations.i18n(context)!
                      .corporate_management_text_15,
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
                    // 设置搜索消息文本事件
                    context
                        .read<MessageMasterBloc>()
                        .add(SetSearchMessageTextEvent(value));
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 100 - 134 - 80,
                child: state.messageList.length == 0
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
                        children: _initMessageList(state.messageList),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
