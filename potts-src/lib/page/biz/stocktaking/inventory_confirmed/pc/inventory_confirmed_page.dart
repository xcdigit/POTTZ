import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_confirmed_bloc.dart';
import '../bloc/inventory_confirmed_model.dart';
import 'inventory_confirmed_search.dart';
import 'inventory_confirmed_table.dart';
import 'inventory_confirmed_title.dart';

/**
 * content：棚卸確定-画面
 * author：张博睿
 * date：2023/08/30
 */

class InventoryConfirmedPage extends StatefulWidget {
  const InventoryConfirmedPage({super.key});

  @override
  State<InventoryConfirmedPage> createState() => _InventoryConfirmedPageState();
}

class _InventoryConfirmedPageState extends State<InventoryConfirmedPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InventoryConfirmedBloc>(
      create: (context) {
        return InventoryConfirmedBloc(
          InventoryConfirmedModel(context: context),
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
                // 标题
                InventoryConfirmedTitle(),
                // 搜索
                InventoryConfirmedSearch(),
                // 表格
                InventoryConfirmedTable()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
