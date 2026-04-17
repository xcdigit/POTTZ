import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/user_license_management_detail_bloc.dart';
import '../bloc/user_license_management_detail_model.dart';
import 'user_license_management_detail_form.dart';

/**
 * 内容：ユーザーライセンス管理明细
 * 作者：熊草云
 * 时间：2023/12/07
 */
// ignore: must_be_immutable
class UserLicenseManagementDetailPage extends StatefulWidget {
  // 入荷指示ID
  int receiveId;

  UserLicenseManagementDetailPage({super.key, this.receiveId = -1});

  @override
  State<UserLicenseManagementDetailPage> createState() =>
      _UserLicenseManagementDetailPageState();
}

class _UserLicenseManagementDetailPageState
    extends State<UserLicenseManagementDetailPage> {
  @override
  Widget build(BuildContext context) {
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    int companyId = 0;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }

    //仓库数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocProvider<UserLicenseManagementDetailBloc>(
      create: (context) {
        return UserLicenseManagementDetailBloc(
          UserLicenseManagementDetailModel(
              context: context,
              formInfo: data,
              companyId: companyId,
              roleId: roleId),
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
                // 表单
                UserLicenseManagementDetailForm(),
                // 表格
                // UserLicenseManagementDetailTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
