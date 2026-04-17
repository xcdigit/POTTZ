import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/setting/menu_master/bloc/menu_master_model.dart';

import '../bloc/menu_master_bloc.dart';
import 'menu_master_search.dart';
import 'menu_master_table.dart';
import 'menu_master_title.dart';

/**
 * 内容：メニューマスタ管理-主页
 * 作者：熊草云
 * 时间：2023/09/05
 */

class MenuMasterPage extends StatefulWidget {
  const MenuMasterPage({super.key});

  @override
  State<MenuMasterPage> createState() => _MenuMasterPageState();
}

class _MenuMasterPageState extends State<MenuMasterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuMasterBloc>(
      create: (context) {
        return MenuMasterBloc(
          MenuMasterModel(context: context),
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
                MenuMasterTitle(),
                // 检索
                MenuMasterSearch(),
                // 表单
                MenuMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
