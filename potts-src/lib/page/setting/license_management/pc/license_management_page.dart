import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/license_management_bloc.dart';
import '../bloc/license_management_model.dart';
import 'license_management_search.dart';
import 'license_management_table.dart';
import 'license_management_title.dart';

/**
 * 内容：ライセンス管理-主页
 * 作者：王光顺
 * 时间：2023/12/05
 */
class LicenseManagementPage extends StatefulWidget {
  const LicenseManagementPage({super.key});

  @override
  State<LicenseManagementPage> createState() => _LicenseManagementPageState();
}

class _LicenseManagementPageState extends State<LicenseManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicenseManagementBloc>(
      create: (context) {
        return LicenseManagementBloc(
          LicenseManagementModel(
            context: context,
          ),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              LicenseManagementTitle(),
              // 检索
              LicenseManagementSearch(),
              // 表单
              LicenseManagementTable(),
            ],
          ),
        ),
      ),
    );
  }
}
