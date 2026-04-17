import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form_master_detail_bloc.dart';
import '../bloc/form_master_detail_model.dart';
import 'form_master_detail_table.dart';
import 'form_master_detail_title.dart';

/**
 * 内容：帳票マスタ明细
 * 作者：赵士淞
 * 时间：2023/12/25
 */
// ignore: must_be_immutable
class FormMasterDetailPage extends StatefulWidget {
  // 账票ID
  int formId;

  FormMasterDetailPage({super.key, required this.formId});

  @override
  State<FormMasterDetailPage> createState() => _FormMasterDetailPageState();
}

class _FormMasterDetailPageState extends State<FormMasterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormMasterDetailBloc>(
      create: (context) {
        return FormMasterDetailBloc(
          FormMasterDetailModel(
            rootContext: context,
            formId: widget.formId,
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
                FormMasterDetailTitle(),
                // 表格
                FormMasterDetailTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
