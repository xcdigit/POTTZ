import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/model/ship.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_bloc.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_model.dart';
import 'package:wms/page/biz/outbound/ship/sp/shipment_determination_check.dart';
import 'package:wms/page/biz/outbound/ship/sp/shipment_determination_table.dart';
import '../../../../../redux/wms_state.dart';
import 'package:intl/intl.dart';

/**
 * 内容：出荷确定
 * 作者：崔浩然
 * 时间：2023/08/18
 */
// ignore_for_file: must_be_immutable
class ShipmentDeterminationPage extends StatefulWidget {
  //当前时间
  String rcvSchDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  ShipmentDeterminationPage({super.key});

  @override
  State<ShipmentDeterminationPage> createState() =>
      _ShipmentDeterminationPageState();
}

class _ShipmentDeterminationPageState extends State<ShipmentDeterminationPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<ShipmentDeterminationBloc>(
      create: (context) {
        return ShipmentDeterminationBloc(ShipmentDeterminationModel(
          rcvSchDate: widget.rcvSchDate,
          receive: Ship.empty(),
          companyId: companyId,
        ));
      },
      // 水平/垂直方向平铺
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          child: ListView(
            children: [
              //检索
              ShipmentDeterminationCheck(),
              //表格
              ShipmentDeterminationTable(),
            ],
          ),
        ),
      ),
    );
  }
}
