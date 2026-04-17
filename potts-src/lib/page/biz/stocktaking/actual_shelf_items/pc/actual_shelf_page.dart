// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/stocktaking/actual_shelf_items/bloc/actual_shelf_bloc.dart';
import 'package:wms/page/biz/stocktaking/actual_shelf_items/bloc/actual_shelf_model.dart';
import 'actual_shelf_form.dart';
import 'actual_shelf_title.dart';

/**
 * 内容：実棚明細入力
 * 作者：王光顺
 * 时间：2023/08/28
 */
class ActualShelfPage extends StatefulWidget {
  //棚卸明细id
  final int MactualId;
  //棚卸id
  final int actualId;

  //棚卸传递状态
  final int actualState;

  //棚卸日传递
  final String actualDate;

  //仓库传递
  final String warehouse;

  ActualShelfPage(
      {super.key,
      required this.MactualId,
      required this.actualId,
      required this.actualState,
      required this.actualDate,
      required this.warehouse});

  @override
  State<ActualShelfPage> createState() => _ActualShelfState();
}

class _ActualShelfState extends State<ActualShelfPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActualShelfBloc>(
      create: (context) {
        return ActualShelfBloc(
          ActualShelfModel(
              MactualId: widget.MactualId,
              actualId: widget.actualId,
              actualState: widget.actualState,
              warehouse: widget.warehouse,
              actualDate: widget.actualDate,
              rootBuildContext: context),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 80),
            child: ListView(
              children: [
                // 头部
                ActualShelfTitle(),
                // 表单
                ActualShelfForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
