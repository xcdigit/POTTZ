import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/inventory_query_bloc.dart';
import '../bloc/inventory_query_model.dart';
import 'inventory_query_search.dart';
import 'inventory_query_table.dart';
import 'inventory_query_title.dart';
/**
 * 内容：棚卸照会 -文件
 * 作者：熊草云
 * 时间：2023/08/29
 */

class InventoryQueryPage extends StatefulWidget {
  const InventoryQueryPage({super.key});

  @override
  State<InventoryQueryPage> createState() => _InventoryQueryPageState();
}

class _InventoryQueryPageState extends State<InventoryQueryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InventoryQueryBloc>(
      create: (context) {
        return InventoryQueryBloc(
          InventoryQueryModel(context: context),
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
                InventoryQueryTitle(),
                // 检索
                InventoryQuerySearch(),
                // 表单
                InventoryQueryTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
