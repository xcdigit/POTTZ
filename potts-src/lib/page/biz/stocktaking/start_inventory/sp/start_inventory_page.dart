import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/start_inventory_bloc.dart';
import '../bloc/start_inventory_model.dart';
import 'start_inventory_flie.dart';
import 'start_inventory_table.dart';

/**
 * 内容：棚卸開始-文件
 * 作者：熊草云
 * 时间：2023/11/23
 */
class StartInventoryPage extends StatefulWidget {
  const StartInventoryPage({super.key});

  @override
  State<StartInventoryPage> createState() => _StartInventoryPageState();
}

class _StartInventoryPageState extends State<StartInventoryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StartInventoryBloc>(
      create: (context) {
        return StartInventoryBloc(
          StartInventoryModel(context: context),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 检索
              StartInventoryFile(),
              // 表单
              StartInventoryTable(),
            ],
          ),
        ),
      ),
    );
  }
}
