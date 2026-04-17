import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/organization_master_bloc.dart';
import '../bloc/organization_master_model.dart';
import 'organization_master_search.dart';
import 'organization_master_table.dart';
import 'organization_master_title.dart';

/**
 * 内容：組織マスタ-主页
 * 作者：熊草云
 * 时间：2023/11/29
 */
class OrganizationMasterPage extends StatefulWidget {
  const OrganizationMasterPage({super.key});

  @override
  State<OrganizationMasterPage> createState() => _OrganizationMasterPageState();
}

class _OrganizationMasterPageState extends State<OrganizationMasterPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId = 0;
    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId = StoreProvider.of<WMSState>(context)
          .state
          .loginUser!
          .company_id as int;
    }
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    return BlocProvider<OrganizationMasterBloc>(
      create: (context) {
        return OrganizationMasterBloc(
          OrganizationMasterModel(
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
                OrganizationMasterTitle(),
                // 检索
                OrganizationMasterSearch(),
                // 表单
                OrganizationMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
