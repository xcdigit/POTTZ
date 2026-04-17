import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_bloc.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_model.dart';
import 'package:wms/page/mst/delivery_operators_master/sp/delivery_operators_master_search.dart';
import 'package:wms/page/mst/delivery_operators_master/sp/delivery_operators_master_table.dart';

import '../../../../redux/wms_state.dart';

/**
 * 内容：配送業者マスタ管理SP-主页
 * 作者：cuihr
 * 时间：2023/12/04
 */

class DeliveryOperatorsMasterPage extends StatefulWidget {
  const DeliveryOperatorsMasterPage({super.key});

  @override
  State<DeliveryOperatorsMasterPage> createState() =>
      _DeliveryOperatorsMasterPageState();
}

class _DeliveryOperatorsMasterPageState
    extends State<DeliveryOperatorsMasterPage> {
  @override
  Widget build(BuildContext context) {
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    int companyId = 0;
    if (roleId != 1) {
      //获取当前登录用户会社ID
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<DeliveryOperatorsMasterBloc>(
      create: (context) {
        return DeliveryOperatorsMasterBloc(
          DeliveryOperatorsMasterModel(
              context: context, companyId: companyId, roleId: roleId),
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
              DeliveryOperatorsMasterSearch(),
              // 表单
              DeliveryOperatorsMasterTable(),
            ],
          ),
        ),
      ),
    );
  }
}
