import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../common/config/config.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';
import 'message_master_all_content.dart';
import 'message_master_message_content.dart';
import 'message_master_message_list.dart';
import 'message_master_user_content.dart';
import 'message_master_user_list.dart';

/**
 * 内容：消息管理-内容
 * 作者：赵士淞
 * 时间：2025/01/02
 */
class MessageMasterContent extends StatefulWidget {
  const MessageMasterContent({super.key});

  @override
  State<MessageMasterContent> createState() => _MessageMasterContentState();
}

class _MessageMasterContentState extends State<MessageMasterContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageMasterBloc, MessageMasterModel>(
      builder: (context, state) {
        return state.currentMenuIndex == Config.NUMBER_TWO
            ? MessageMasterAllContent()
            : ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    width: 378,
                    child: state.currentMenuIndex == Config.NUMBER_ZERO
                        ? MessageMasterMessageList()
                        : state.currentMenuIndex == Config.NUMBER_ONE
                            ? MessageMasterUserList()
                            : Container(),
                  ),
                  Container(
                    width: StoreProvider.of<WMSState>(context).state.menuExpand
                        ? (MediaQuery.of(context).size.width <
                                Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                            ? Config.WEB_MINI_WIDTH_LIMIT.toDouble() -
                                328 -
                                40 -
                                254 -
                                378
                            : MediaQuery.of(context).size.width -
                                328 -
                                40 -
                                254 -
                                378)
                        : (MediaQuery.of(context).size.width <
                                Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                            ? Config.WEB_MINI_WIDTH_LIMIT.toDouble() -
                                168 -
                                40 -
                                254 -
                                378
                            : MediaQuery.of(context).size.width -
                                168 -
                                40 -
                                254 -
                                378),
                    child: state.currentMenuIndex == Config.NUMBER_ZERO
                        ? MessageMasterMessageContent()
                        : state.currentMenuIndex == Config.NUMBER_ONE
                            ? MessageMasterUserContent()
                            : Container(),
                  ),
                ],
              );
      },
    );
  }
}
