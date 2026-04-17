import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/incoming_inspection_bloc.dart';
import '../bloc/incoming_inspection_model.dart';
import 'incoming_inspection_form.dart';

/**
 * 内容：入荷検品-文件
 * 作者：熊草云
 * 时间：2023/10/13
 */
class IncomingInspectionPage extends StatefulWidget {
  const IncomingInspectionPage({super.key});

  @override
  State<IncomingInspectionPage> createState() => _IncomingInspectionPageState();
}

class _IncomingInspectionPageState extends State<IncomingInspectionPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider<IncomingInspectionBloc>(
        create: (context) {
          return IncomingInspectionBloc(
            IncomingInspectionModel(context: context),
          );
        },
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                // 表单
                IncomingInspectionForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
