import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form_master_bloc.dart';
import '../bloc/form_master_model.dart';
import 'form_master_table.dart';
import 'form_master_title.dart';

/**
 * 内容：帳票マスタ
 * 作者：赵士淞
 * 时间：2023/12/22
 */
class FormMasterPage extends StatefulWidget {
  const FormMasterPage({super.key});

  @override
  State<FormMasterPage> createState() => _FormMasterPageState();
}

class _FormMasterPageState extends State<FormMasterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormMasterBloc>(
      create: (context) {
        return FormMasterBloc(
          FormMasterModel(
            rootContext: context,
          ),
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
                FormMasterTitle(),
                // 表格
                FormMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
