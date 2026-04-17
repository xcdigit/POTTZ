import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/operate_log_bloc.dart';
import '../bloc/operate_log_model.dart';
import 'operate_log_table.dart';

/**
 * 内容：操作ログSP
 * 作者：luxy
 * 时间：2023/11/29
 */
class OperateLogPage extends StatefulWidget {
  const OperateLogPage({super.key});

  @override
  State<OperateLogPage> createState() => _OperateLogPageState();
}

class _OperateLogPageState extends State<OperateLogPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OperateLogBloc>(
      create: (context) {
        return OperateLogBloc(
          OperateLogModel(context: context),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: ListView(
          children: [
            //表格
            OperateLogTable(),
          ],
        ),
      ),
    );
  }
}
