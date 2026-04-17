import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../common/config/config.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/message_master_bloc.dart';
import '../bloc/message_master_model.dart';
import 'message_master_content.dart';
import 'message_master_menu.dart';

/**
 * 内容：消息管理
 * 作者：赵士淞
 * 时间：2025/01/02
 */
class MessageMasterPage extends StatefulWidget {
  const MessageMasterPage({super.key});

  @override
  State<MessageMasterPage> createState() => _MessageMasterPageState();
}

class _MessageMasterPageState extends State<MessageMasterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageMasterBloc>(
      create: (context) {
        return MessageMasterBloc(
          MessageMasterModel(
            rootContext: context,
          ),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 71, 0),
                  width: 254,
                  child: MessageMasterMenu(),
                ),
                Container(
                  width: StoreProvider.of<WMSState>(context).state.menuExpand
                      ? (MediaQuery.of(context).size.width <
                              Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                          ? Config.WEB_MINI_WIDTH_LIMIT.toDouble() -
                              328 -
                              40 -
                              254
                          : MediaQuery.of(context).size.width - 328 - 40 - 254)
                      : (MediaQuery.of(context).size.width <
                              Config.WEB_MINI_WIDTH_LIMIT.toDouble()
                          ? Config.WEB_MINI_WIDTH_LIMIT.toDouble() -
                              168 -
                              40 -
                              254
                          : MediaQuery.of(context).size.width - 168 - 40 - 254),
                  child: MessageMasterContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
