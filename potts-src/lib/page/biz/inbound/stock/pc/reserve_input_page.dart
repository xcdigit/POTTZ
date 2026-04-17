// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/inbound/stock/bloc/reserve_input_bloc.dart';
import 'package:wms/page/biz/inbound/stock/bloc/reserve_input_model.dart';

import '../../../../../redux/wms_state.dart';
import 'reserve_input_file.dart';
import 'reserve_input_form.dart';
import 'reserve_input_table.dart';
import 'reserve_input_title.dart';

/**
 * 内容：入荷予定入力
 * 作者：王光顺
 * 时间：2023/08/18
 * 作者：luxy
 * 时间：2023/10/17
 */

class ReserveInputPage extends StatefulWidget {
  // 入荷予定ID
  int receiveId = 0;
  ReserveInputPage({super.key, this.receiveId = 0});

  @override
  State<ReserveInputPage> createState() => _ReserveInputPageState();
}

class _ReserveInputPageState extends State<ReserveInputPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<ReserveInputBloc>(
      create: (context) {
        return ReserveInputBloc(
          ReserveInputModel(
              rootContext: context,
              receiveId: widget.receiveId,
              companyId: companyId),
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
                ReserveInputTitle(),
                // 文件
                ReserveInputFile(),
                // 表单
                ReserveInputForm(),
                // 表格
                ReserveInputTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
