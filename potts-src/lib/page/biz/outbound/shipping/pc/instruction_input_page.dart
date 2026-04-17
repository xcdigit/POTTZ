import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/outbound/shipping/bloc/instruction_input_bloc.dart';

import '../../../../../common/config/config.dart';
import 'instruction_input_file.dart';
import 'instruction_input_form.dart';
import '../bloc/instruction_input_model.dart';
import 'instruction_input_table.dart';
import 'instruction_input_title.dart';

/**
 * 内容：出荷指示入力
 * 作者：赵士淞
 * 时间：2023/08/03
 */
// ignore: must_be_immutable
class InstructionInputPage extends StatefulWidget {
  // 出荷指示ID
  int shipId;

  InstructionInputPage({super.key, this.shipId = Config.NUMBER_NEGATIVE});

  @override
  State<InstructionInputPage> createState() => _InstructionInputPageState();
}

class _InstructionInputPageState extends State<InstructionInputPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<InstructionInputBloc>(
      create: (context) {
        return InstructionInputBloc(
          InstructionInputModel(
            rootContext: context,
            shipId: widget.shipId,
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
                InstructionInputTitle(),
                // 文件
                InstructionInputFile(),
                // 表单
                InstructionInputForm(),
                // 表格
                InstructionInputTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
