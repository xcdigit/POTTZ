import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/display_instruction_bloc.dart';
import '../bloc/display_instruction_modle.dart';
import '/common/localization/default_localizations.dart';
import './display_instruction_table.dart';
import './display_instruction_retrieval.dart';

/**
 * 内容：出荷指示照会-文件
 * 作者：熊草云
 * 时间：2023/08/10
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
          return Scrollbar(
            thumbVisibility: true,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40, 40, 20, 20),
                  child: Column(
                    children: [
                      // 出荷指示照会标题
                      Row(
                        children: [
                          Container(
                            height: 64,
                            child: Text(
                              WMSLocalizations.i18n(context)!.menu_content_3_5,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                height: 1.0,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      displayInstructionRetrieval(),
                      DisplayInstructionTable(),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
