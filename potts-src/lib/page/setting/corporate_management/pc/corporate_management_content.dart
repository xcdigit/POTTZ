import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../bloc/corporate_management_bloc.dart';
import '../bloc/corporate_management_model.dart';
import 'corporate_management_confirm_confirm_tab.dart';
import 'corporate_management_content_add.dart';
import 'corporate_management_content_confirm.dart';

/**
 * 内容：法人管理-内容
 * 作者：赵士淞
 * 时间：2024/07/01
 */
class CorporateManagementContent extends StatefulWidget {
  const CorporateManagementContent({super.key});

  @override
  State<CorporateManagementContent> createState() =>
      _CorporateManagementContentState();
}

class _CorporateManagementContentState
    extends State<CorporateManagementContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
      builder: (context, state) {
        return context.read<CorporateManagementBloc>().state.detailPageSign ==
                Config.NUMBER_ZERO
            ? Container(
                width: 979,
                child: ListView(
                  children: [
                    Container(
                      width: 928,
                      margin: EdgeInsets.fromLTRB(51, 100, 0, 100),
                      child: CorporateManagementContentConfirmTab(),
                    ),
                  ],
                ),
              )
            : context.read<CorporateManagementBloc>().state.currentMenuIndex ==
                    Config.NUMBER_ZERO
                ? Container(
                    width: 1064,
                    child: ListView(
                      children: [
                        Container(
                          width: 1024,
                          margin: EdgeInsets.fromLTRB(40, 100, 0, 100),
                          child: CorporateManagementConfirm(),
                        ),
                      ],
                    ),
                  )
                : context
                            .read<CorporateManagementBloc>()
                            .state
                            .currentMenuIndex ==
                        Config.NUMBER_ONE
                    ? Container(
                        width: 812,
                        child: ListView(
                          children: [
                            Container(
                              width: 638,
                              margin: EdgeInsets.fromLTRB(174, 100, 0, 100),
                              child: CorporateManagementContentAdd(),
                            ),
                          ],
                        ),
                      )
                    : context
                                .read<CorporateManagementBloc>()
                                .state
                                .currentMenuIndex ==
                            Config.NUMBER_TWO
                        ? Container(
                            width: 1064,
                            child: ListView(
                              children: [
                                Container(
                                  width: 1024,
                                  margin: EdgeInsets.fromLTRB(40, 100, 0, 100),
                                  child: CorporateManagementConfirm(),
                                ),
                              ],
                            ),
                          )
                        : Container();
      },
    );
  }
}
