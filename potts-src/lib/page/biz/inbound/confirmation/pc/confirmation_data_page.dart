import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/model/receive.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_bloc.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_model.dart';

import 'confirmation_data_query.dart';
import 'confirmation_data_table.dart';
import 'confirmation_data_title.dart';

/**
 * 内容：入荷確定データ出力
 * 作者：cuihr
 * 时间：2023/08/24
 */
// ignore_for_file: must_be_immutable
class ConfirmationDataPage extends StatefulWidget {
  DateTime rcvSchDate = DateTime.now();
  ConfirmationDataPage({super.key});

  @override
  State<ConfirmationDataPage> createState() => _ConfirmationDataPageState();
}

class _ConfirmationDataPageState extends State<ConfirmationDataPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConfirmationDataBloc>(
      create: (context) {
        return ConfirmationDataBloc(ConfirmationDataModel(
          rcvSchDate: widget.rcvSchDate,
          receive: Receive.empty(),
        ));
      },
      // 水平/垂直方向平铺
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView(
              children: [
                // 头部
                ConfirmationDataTitle(),
                // 檢索
                ConfirmationDataQuery(),
                // 表格
                ConfirmationDataTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
