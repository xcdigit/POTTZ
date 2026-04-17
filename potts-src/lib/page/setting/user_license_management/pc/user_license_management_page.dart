import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../redux/wms_state.dart';
import '../bloc/user_license_management_bloc.dart';
import '../bloc/user_license_management_model.dart';
import 'user_license_management_search.dart';
import 'user_license_management_table.dart';
import 'user_license_management_title.dart';

/**
 * 内容：ユーザーライセンス管理-主页
 * 作者：熊草云
 * 时间：2023/12/07
 */
class UserLicenseManagementPage extends StatefulWidget {
  const UserLicenseManagementPage({super.key});

  @override
  State<UserLicenseManagementPage> createState() =>
      _UserLicenseManagementPageState();
}

class _UserLicenseManagementPageState extends State<UserLicenseManagementPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    int companyId = 0;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<UserLicenseManagementBloc>(
      create: (context) {
        return UserLicenseManagementBloc(
          UserLicenseManagementModel(
              context: context, roleId: roleId, companyId: companyId),
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
                UserLicenseManagementTitle(),
                // 检索
                UserLicenseManagementSearch(),
                // 表单
                UserLicenseManagementTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
