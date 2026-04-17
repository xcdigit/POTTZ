import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/mst/role_master/pc/role_master_search.dart';
import 'package:wms/page/mst/role_master/pc/role_master_table.dart';
import 'package:wms/page/mst/role_master/pc/role_master_title.dart';

import '../bloc/role_master_bloc.dart';
import '../bloc/role_master_model.dart';

/**
* 内容：ロールマスタ管理 -页面
 * 作者：cuihr
 * 时间：2023/09/05
 */
class RoleMasterPage extends StatefulWidget {
  const RoleMasterPage({super.key});

  @override
  State<RoleMasterPage> createState() => _RoleMasterPageState();
}

class _RoleMasterPageState extends State<RoleMasterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoleMasterBloc>(
      create: (context) {
        return RoleMasterBloc(
          RoleMasterModel(context: context),
        );
      },
      child: FractionallySizedBox(
        heightFactor: 1,
        widthFactor: 1,
        child: Scrollbar(
          thumbVisibility: true,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                //标题
                RoleMasterTitle(),
                //搜索
                RoleMasterSearch(),
                //表格
                RoleMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
