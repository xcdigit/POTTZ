import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_bloc.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_model.dart';
import 'package:wms/page/app/application_cceptance/pc/application_cceptance_query.dart';
import 'package:wms/page/app/application_cceptance/pc/application_cceptance_table.dart';
import 'package:wms/page/app/application_cceptance/pc/application_cceptance_title.dart';

/**
 * 内容：申込受付
 * 作者：cuihr
 * 时间：2023/12/18
 */
class ApplicationCceptancePage extends StatefulWidget {
  const ApplicationCceptancePage({super.key});

  @override
  State<ApplicationCceptancePage> createState() =>
      _ApplicationCceptancePageState();
}

class _ApplicationCceptancePageState extends State<ApplicationCceptancePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationCceptanceBloc>(
      create: (context) {
        return ApplicationCceptanceBloc(
          ApplicationCceptanceModel(context: context, appId: 0),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              //头部
              ApplicationCceptanceTitle(),
              //检索
              ApplicationCceptanceQuery(),
              //表格
              ApplicationCceptanceTable(),
            ],
          ),
        ),
      ),
    );
  }
}
