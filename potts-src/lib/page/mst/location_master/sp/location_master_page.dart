import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/location_master/bloc/location_master_model.dart';
import 'package:wms/redux/wms_state.dart';
import '../bloc/location_master_bloc.dart';
import 'location_master_search.dart';
import 'location_master_table.dart';

/**
 * 内容：ロケーションマスタ管理SP-主页
 * 作者：luxy
 * 时间：2023/11/22
 */
// ignore_for_file: must_be_immutable

class LocationMasterPage extends StatefulWidget {
  const LocationMasterPage({super.key});

  @override
  State<LocationMasterPage> createState() => _LocationMasterPageState();
}

class _LocationMasterPageState extends State<LocationMasterPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId = 0;
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    if (roleId != 1) {
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<LocationMasterBloc>(
      create: (context) {
        return LocationMasterBloc(
          LocationMasterModel(
            companyId: companyId,
            roleId: roleId,
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
              // 检索
              LocationMasterSearch(),
              // 表单
              LocationMasterTable(),
            ],
          ),
        ),
      ),
    );
  }
}
