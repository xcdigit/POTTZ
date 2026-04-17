import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/returns_note_bloc.dart';
import '../bloc/returns_note_model.dart';
import 'returns_note_table.dart';

/**
 * 内容：返品照会-文件-sp
 * 作者：熊草云
 * 时间：2023/11/22
 */
class ReturnsNotePage extends StatefulWidget {
  const ReturnsNotePage({super.key});

  @override
  State<ReturnsNotePage> createState() => _ReturnsNotePageState();
}

class _ReturnsNotePageState extends State<ReturnsNotePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReturnNoteBloc>(
      create: (context) {
        return ReturnNoteBloc(
          ReturnNoteModel(context: context),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          children: [
            //表格
            ReturnsNoteTable(),
          ],
        ),
      ),
    );
  }
}
