import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/stocktaking/inventory_output/bloc/inventory_output_bloc.dart';

import '../../../../../redux/wms_state.dart';
import '../bloc/inventory_output_model.dart';
import 'inventory_output_retrieval.dart';
import 'inventory_output_table.dart';
import 'inventory_output_title.dart';

/**
 * 内容：棚卸データ出力
 * 作者：王光顺
 * 时间：2023/08/30
 */
class InventoryOutputPage extends StatefulWidget {
  const InventoryOutputPage({super.key});

  @override
  State<InventoryOutputPage> createState() => _InventoryOutputPageState();
}

class _InventoryOutputPageState extends State<InventoryOutputPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<InventoryOutputBloc>(
      create: (context) {
        return InventoryOutputBloc(
          InventoryOutputModel(companyId: companyId),
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
                InventoryOutputTitle(),
                // 检索
                InventoryOutputRetrieval(),
                // 表单
                InventoryOutputTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
