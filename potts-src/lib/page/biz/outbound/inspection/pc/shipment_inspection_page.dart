import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_bloc.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'shipment_inspection_form.dart';
import 'shipment_inspection_title.dart';

/**
 * 内容：出荷検品-文件
 * 作者：熊草云
 * 时间：2023/08/17
 */
class ShipmentInspectionPage extends StatefulWidget {
  const ShipmentInspectionPage({super.key});

  @override
  State<ShipmentInspectionPage> createState() => _ShipmentInspectionPageState();
}

class _ShipmentInspectionPageState extends State<ShipmentInspectionPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider(
      create: (context) {
        return ShipmentInspectionBloc(
          ShipmentInspectionModel(companyId: companyId, userId: userId),
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
                ShipmentInspectionTitle(),
                // 表单
                ShipmentInspectionForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
