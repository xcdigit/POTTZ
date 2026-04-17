import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/company_master_bloc.dart';
import '../bloc/company_master_model.dart';
import 'company_master_search.dart';
import 'company_master_table.dart';

/**
 * 内容：会社情報マスタ管理-主页
 * 作者：王光顺
 * 时间：2023/09/05
 */
class CompanyMasterPage extends StatefulWidget {
  const CompanyMasterPage({super.key});

  @override
  State<CompanyMasterPage> createState() => _CompanyMasterPageState();
}

class _CompanyMasterPageState extends State<CompanyMasterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CompanyMasterBloc>(
      create: (context) {
        return CompanyMasterBloc(
          CompanyMasterModel(context: context),
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
              CompanyMasterSearch(),
              // 表单
              CompanyMasterTable(),
            ],
          ),
        ),
      ),
    );
  }
}
