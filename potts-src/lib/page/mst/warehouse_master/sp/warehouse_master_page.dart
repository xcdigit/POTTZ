import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/warehouse_master/bloc/warehouse_master_bloc.dart';
import 'package:wms/redux/wms_state.dart';

import '../bloc/warehouse_master_model.dart';
import 'warehouse_master_search.dart';
import 'warehouse_master_table.dart';

/**
 * 内容：倉庫マスタ管理SP-主页
 * 作者：luxy
 * 时间：2023/11/21
 */
class WarehouseMasterPage extends StatefulWidget {
  const WarehouseMasterPage({super.key});
  @override
  State<WarehouseMasterPage> createState() => _WarehouseMasterPageState();
}

class _WarehouseMasterPageState extends State<WarehouseMasterPage> {
  @override
  Widget build(BuildContext context) {
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //获取当前登录用户会社ID
    int companyId = 0;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<WarehouseMasterBloc>(create: (context) {
      return WarehouseMasterBloc(
        WarehouseMasterModel(
          context: context,
          companyId: companyId,
        ),
      );
    }, child: BlocBuilder<WarehouseMasterBloc, WarehouseMasterModel>(
        builder: (context, state) {
      return FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 检索
              WarehouseMasterSearch(),
              // 表格
              WarehouseMasterTable(),
            ],
          ),
        ),
      );
    }));
  }
}
