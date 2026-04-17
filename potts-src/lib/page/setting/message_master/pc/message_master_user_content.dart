import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';

/**
 * 内容：消息管理-用户内容
 * 作者：赵士淞
 * 时间：2025/01/02
 */
class MessageMasterUserContent extends StatefulWidget {
  const MessageMasterUserContent({super.key});

  @override
  State<MessageMasterUserContent> createState() =>
      _MessageMasterUserContentState();
}

class _MessageMasterUserContentState extends State<MessageMasterUserContent> {
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
          child: state.selectUserIndex == Config.NUMBER_NEGATIVE
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
                      child: Text(
                        WMSLocalizations.i18n(context)!.message_title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                      child: WMSInputboxWidget(
                        text: state.inputMessageTitle,
                        inputBoxCallBack: (value) {
                          // 设置输入消息标题事件
                          context
                              .read<MessageMasterBloc>()
                              .add(SetInputMessageTitleEvent(value));
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 28, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              state.userList[state.selectUserIndex]
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
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(78, 25, 78, 16),
                      child: Text(
                        WMSLocalizations.i18n(context)!.message_content,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(78, 0, 78, 0),
                      child: WMSInputboxWidget(
                        height: 400,
                        maxLines: 18,
                        text: state.inputMessageContent,
                        inputBoxCallBack: (value) {
                          // 设置输入消息内容事件
                          context
                              .read<MessageMasterBloc>()
                              .add(SetInputMessageContentEvent(value));
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(78, 25, 78, 0),
                      child: Row(
                        children: [
                          Container(
                            height: 36,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                            child: OutlinedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Color.fromRGBO(255, 255, 255, 1),
                                ),
                                minimumSize: MaterialStatePropertyAll(
                                  Size(120, 36),
                                ),
                              ),
                              onPressed: () {
                                // 点击发送邮件给一个人事件
                                context
                                    .read<MessageMasterBloc>()
                                    .add(ClickSendEmailToOneEvent());
                              },
                              child: Text(
                                WMSLocalizations.i18n(context)!
                                    .login_confirm_text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                  height: 1.28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
