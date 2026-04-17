import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/outbound/shipping/bloc/instruction_input_bloc.dart';

import '../../../../../common/config/config.dart';
import 'instruction_input_form.dart';
import '../bloc/instruction_input_model.dart';

/**
 * 内容：出荷指示入力
 * 作者：luxy
 * 时间：2023/11/01
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
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 表单
              InstructionInputForm(),
            ],
          ),
        ),
      ),
    );
  }
}
