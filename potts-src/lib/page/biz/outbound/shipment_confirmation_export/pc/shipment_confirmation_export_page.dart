import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/shipment_confirmation_export_bloc.dart';
import '../bloc/shipment_confirmation_export_model.dart';
import 'shipment_confirmation_export_query.dart';
import 'shipment_confirmation_export_table.dart';
import 'shipment_confirmation_export_title.dart';

/**
 * 内容：出荷確定データ出力
 * 作者：张博睿
 * 时间：2023/08/03
 */
class ShipmentConfirmationExportPage extends StatefulWidget {
  const ShipmentConfirmationExportPage({super.key});

  @override
  State<ShipmentConfirmationExportPage> createState() =>
      _ShipmentConfirmationExportPagePageState();
}

class _ShipmentConfirmationExportPagePageState
    extends State<ShipmentConfirmationExportPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShipmentConfirmationExportBloc>(
      create: (context) {
        return ShipmentConfirmationExportBloc(
          ShipmentConfirmationExportModel(context: context),
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
                ShipmentConfirmationExportTitle(),
                // 檢索
                ShipmentConfirmationExportQuery(),
                // 表格
                ShipmentConfirmationExportTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
