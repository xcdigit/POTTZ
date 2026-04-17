import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';

/**
 * 内容：消息管理-全部内容
 * 作者：赵士淞
 * 时间：2025/01/03
 */
class MessageMasterAllContent extends StatefulWidget {
  const MessageMasterAllContent({super.key});

  @override
  State<MessageMasterAllContent> createState() =>
      _MessageMasterAllContentState();
}

class _MessageMasterAllContentState extends State<MessageMasterAllContent> {
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
          child: ListView(
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
                          // 点击发送邮件给所有人事件
                          context
                              .read<MessageMasterBloc>()
                              .add(ClickSendEmailToAllEvent());
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .message_master_content_button_3,
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
                          // 点击发送邮件给所有有效人事件
                          context
                              .read<MessageMasterBloc>()
                              .add(ClickSendEmailToAllValidEvent());
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .message_master_content_button_4,
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
