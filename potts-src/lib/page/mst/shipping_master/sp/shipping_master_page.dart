import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/shipping_master_bloc.dart';
import '../bloc/shipping_master_model.dart';

import 'shipping_master_search.dart';
import 'shipping_master_table.dart';

/**
 * 内容：荷主マスタ-主页
 * 作者：王光顺
 * 时间：2023/11/29
 */
class ShippingMasterPage extends StatefulWidget {
  const ShippingMasterPage({super.key});

  @override
  State<ShippingMasterPage> createState() => _ShippingMasterPageState();
}

class _ShippingMasterPageState extends State<ShippingMasterPage> {
  @override
  Widget build(BuildContext context) {
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //获取当前登录用户会社ID
    int companyId = 0;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<ShippingMasterBloc>(
      create: (context) {
        return ShippingMasterBloc(
          ShippingMasterModel(
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
              ShippingMasterSearch(),
              // 表单
              ShippingMasterTable(),
            ],
          ),
        ),
      ),
    );
  }
}
