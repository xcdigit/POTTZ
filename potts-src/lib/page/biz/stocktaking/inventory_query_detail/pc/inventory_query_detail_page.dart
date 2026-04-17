import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_query_detail_bloc.dart';
import '../bloc/inventory_query_detail_model.dart';
import 'inventory_query_detail_form.dart';
import 'inventory_query_detail_search.dart';
import 'inventory_query_detail_table.dart';
import 'inventory_query_detail_title.dart';

/**
 * 内容：棚卸照会明细
 * 作者：熊草云
 * 时间：2023/10/07
 * 作者：赵士淞
 * 时间：2023/10/26
 */
// ignore: must_be_immutable
class InventoryQueryDetailPage extends StatefulWidget {
  // 明细ID
  int detailId;

  InventoryQueryDetailPage({super.key, this.detailId = -1});

  @override
  State<InventoryQueryDetailPage> createState() =>
      _InventoryQueryDetailPageState();
}

class _InventoryQueryDetailPageState extends State<InventoryQueryDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InventoryQueryDetailBloc>(
      create: (context) {
        return InventoryQueryDetailBloc(
          InventoryQueryDetailModel(
            rootContext: context,
            detailId: widget.detailId,
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
              children: [
                // 头部
                InventoryQueryDetailTitle(),
                // 表单
                InventoryQueryDetailForm(),
                // 检索
                InventoryQueryDetailSearch(),
                // 表格
                InventoryQueryDetailTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
