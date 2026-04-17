import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/charge_management_bloc.dart';
import '../bloc/charge_management_model.dart';
import 'charge_management_search.dart';
import 'charge_management_table.dart';
import 'charge_management_title.dart';

/**
 * 内容：課金法人管理-主页
 * 作者：熊草云
 * 时间：2023/12/05
 */
class ChargeManagementPage extends StatefulWidget {
  const ChargeManagementPage({super.key});

  @override
  State<ChargeManagementPage> createState() => _ChargeManagementPageState();
}

class _ChargeManagementPageState extends State<ChargeManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChargeManagementBloc>(
      create: (context) {
        return ChargeManagementBloc(
          ChargeManagementModel(context: context),
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
              children: [
                // 头部
                ChargeManagementTitle(),
                // 检索
                ChargeManagementSearch(),
                // 表单
                ChargeManagementTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
