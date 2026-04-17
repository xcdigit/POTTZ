import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';

import '../bloc/corporate_management_bloc.dart';
import '../bloc/corporate_management_model.dart';
import 'corporate_management_content.dart';
import 'corporate_management_menu.dart';

/**
 * 内容：法人管理-内容
 * 作者：赵士淞
 * 时间：2024/06/25
 */
// ignore: must_be_immutable
class CorporateManagementPage extends StatefulWidget {
  int currentMenuIndex;
  CorporateManagementPage({super.key, required this.currentMenuIndex});

  @override
  State<CorporateManagementPage> createState() =>
      _CorporateManagementPageState();
}

class _CorporateManagementPageState extends State<CorporateManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CorporateManagementBloc>(
      create: (context) {
        return CorporateManagementBloc(
          CorporateManagementModel(
              rootContext: context, currentMenuIndex: Config.NUMBER_ZERO),
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
                  width: 183,
                  child: CorporateManagementMenu(),
                ),
                CorporateManagementContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
