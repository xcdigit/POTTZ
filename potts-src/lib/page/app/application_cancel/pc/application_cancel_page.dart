import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/application_cancel_bloc.dart';
import '../bloc/application_cancel_model.dart';
import 'application_cancel_search.dart';
import 'application_cancel_table.dart';
import 'application_cancel_title.dart';

/**
 * 内容：解约受付
 * 作者：赵士淞
 * 时间：2025/01/08
 */
class ApplicationCancelPage extends StatefulWidget {
  const ApplicationCancelPage({super.key});

  @override
  State<ApplicationCancelPage> createState() => _ApplicationCancelPageState();
}

class _ApplicationCancelPageState extends State<ApplicationCancelPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationCancelBloc>(
      create: (context) {
        return ApplicationCancelBloc(
          ApplicationCancelModel(rootContext: context),
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
              ApplicationCancelTitle(),
              // 检索
              ApplicationCancelSearch(),
              // 表格
              ApplicationCancelTable(),
            ],
          ),
        ),
      ),
    );
  }
}
