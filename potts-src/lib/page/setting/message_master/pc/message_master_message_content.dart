import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../common/utils/format_utils.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';

/**
 * 内容：消息管理-消息内容
 * 作者：赵士淞
 * 时间：2025/01/02
 */
class MessageMasterMessageContent extends StatefulWidget {
  const MessageMasterMessageContent({super.key});

  @override
  State<MessageMasterMessageContent> createState() =>
      _MessageMasterMessageContentState();
}

class _MessageMasterMessageContentState
    extends State<MessageMasterMessageContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageMasterBloc, MessageMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 54, 0, 20),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
            border: Border.all(
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: state.selectMessageIndex == Config.NUMBER_NEGATIVE
              ? Container(
                  child: Center(
                    child: Text(
                      WMSLocalizations.i18n(context)!.no_items_found,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              : ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 45, 16, 0),
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.messageList[state.selectMessageIndex]
                                ['message_title'],
                            style: TextStyle(
                              color: Color.fromRGBO(6, 14, 15, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // 删除消息事件
                              context.read<MessageMasterBloc>().add(
                                  DeleteMessageEvent(state
                                          .messageList[state.selectMessageIndex]
                                      ['message_id']));
                            },
                            child: Image(
                              image: AssetImage(
                                WMSICons.HOME_HEAD_NOTICE_PAGE_DEL_IMG,
                              ),
                              width: 26.0,
                              height: 26.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 28, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                WMSICons.PLAN_ICON,
                                width: 32,
                                height: 32,
                              ),
                              Container(
                                width: 200,
                                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Text(
                                  state.messageList[state.selectMessageIndex]
                                      ['company_name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color.fromRGBO(4, 14, 15, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 160,
                            alignment: Alignment.topRight,
                            child: Text(
                              FormatUtils.dateTimeFormat(
                                  state.messageList[state.selectMessageIndex]
                                      ['create_time']),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(44, 167, 176, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(78, 25, 78, 0),
                      child: Text(
                        state.messageList[state.selectMessageIndex]['message'],
                        style: TextStyle(
                          color: Color.fromRGBO(6, 14, 15, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
