import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/display_instruction_bloc.dart';
import '../bloc/display_instruction_modle.dart';
import './display_instruction_table.dart';
import './display_instruction_retrieval.dart';

/**
 * 内容：出荷指示照会-文件-SP
 * 作者：熊草云
 * 时间：2023/10/30
 */
class DisplayInstructionPage extends StatefulWidget {
  const DisplayInstructionPage({super.key});

  @override
  State<DisplayInstructionPage> createState() => _DisplayInstructionPageState();
}

class _DisplayInstructionPageState extends State<DisplayInstructionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DisplayInstructionBloc>(
      create: (context) {
        return DisplayInstructionBloc(
          DisplayInstructionModel(context: context),
        );
      },
      child: BlocBuilder<DisplayInstructionBloc, DisplayInstructionModel>(
        builder: (context, state) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    displayInstructionRetrieval(),
                    DisplayInstructionTable(),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
