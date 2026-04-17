import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/setting/auth/bloc/auth_master_bloc.dart';
import 'package:wms/page/setting/auth/bloc/auth_master_model.dart';
import 'package:wms/page/setting/auth/sp/auth_search.dart';
import 'package:wms/page/setting/auth/sp/auth_table.dart';

/**
 * 内容：権限マスタ-页面
 * 作者：张博睿
 * 时间：2023/09/05
 */

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthMasterBloc>(
      create: (context) {
        return AuthMasterBloc(
          AuthMasterModel(context: context),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // search
              AuthSearch(),
              // table
              AuthTable(),
            ],
          ),
        ),
      ),
    );
  }
}
