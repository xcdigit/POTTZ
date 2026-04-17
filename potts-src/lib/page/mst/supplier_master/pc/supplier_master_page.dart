import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_bloc.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_model.dart';
import 'package:wms/page/mst/supplier_master/pc/supplier_master_query.dart';
import 'package:wms/page/mst/supplier_master/pc/supplier_master_table.dart';
import 'package:wms/page/mst/supplier_master/pc/supplier_master_title.dart';

import '../../../../redux/wms_state.dart';

/**
* 内容：仕入先マスタ管理 -页面
 * 作者：cuihr
 * 时间：2023/09/06
 */
class SupplierMasterPage extends StatefulWidget {
  const SupplierMasterPage({super.key});

  @override
  State<SupplierMasterPage> createState() => _SupplierMasterPageState();
}

class _SupplierMasterPageState extends State<SupplierMasterPage> {
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
    return BlocProvider<SupplierMasterBloc>(
      create: (context) {
        return SupplierMasterBloc(
          SupplierMasterModel(
              context: context, companyId: companyId, roleId: roleId),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                //标题
                SupplierMasterTitle(),
                //搜索
                SupplierMasterQuery(),
                // //表格
                SupplierMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
