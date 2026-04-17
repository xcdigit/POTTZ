import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_bloc.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_model.dart';

import '../../../../redux/wms_state.dart';
import 'customer_master_search.dart';
import 'customer_master_table.dart';
import 'customer_master_title.dart';

/**
 * 内容：得意先マスタ管理-主页
 * 作者：王光顺
 * 时间：2023/09/05
 */
class CustomerMasterPage extends StatefulWidget {
  const CustomerMasterPage({super.key});
  @override
  State<CustomerMasterPage> createState() => _CustomerMasterPageState();
}

class _CustomerMasterPageState extends State<CustomerMasterPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId = 0;

    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;

    return BlocProvider<CustomerMasterBloc>(
      create: (context) {
        return CustomerMasterBloc(
          CustomerMasterModel(
              context: context, companyId: companyId, roleId: roleId),
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
                CustomerMasterTitle(),
                // 检索
                CustomerMasterSearch(),
                // 表单
                CustomerMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
