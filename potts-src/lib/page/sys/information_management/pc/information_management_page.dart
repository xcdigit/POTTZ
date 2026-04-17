import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/sys/information_management/bloc/information_management_bloc.dart';

import '../bloc/information_management_model.dart';
import 'information_management_form.dart';
import 'information_management_title.dart';

/**
 * 内容：運用基本情報管理-主页
 * 作者：王光顺
 * 时间：2023/09/06
 */
class InformationManagementPage extends StatefulWidget {
  const InformationManagementPage({super.key});
  @override
  State<InformationManagementPage> createState() =>
      _InformationManagementPageState();
}

class _InformationManagementPageState extends State<InformationManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InformationManagementBloc>(
        create: (context) {
          return InformationManagementBloc(
            InformationManagementModel(),
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
                  InformationManagementTitle(),
                  //  表单
                  InformationManagementForm(),
                ],
              ),
            ),
          ),
        ));
  }
}
