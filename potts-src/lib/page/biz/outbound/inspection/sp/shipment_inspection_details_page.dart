// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_bloc.dart';
import 'package:wms/page/biz/outbound/inspection/bloc/shipment_inspection_model.dart';
import 'package:wms/page/biz/outbound/inspection/sp/shipment_inspection_details.dart';
import 'package:wms/redux/wms_state.dart';

/**
 * content：出荷検品-details-page
 * author：张博睿
 * date：2023/11/09
 */
class ShipmentInspectionDetailsPage extends StatefulWidget {
  String shipNo;
  String shipId;
  String index;
  String pageNum;
  ShipmentInspectionDetailsPage({
    super.key,
    required this.shipNo,
    required this.shipId,
    required this.index,
    required this.pageNum,
  });

  @override
  State<ShipmentInspectionDetailsPage> createState() =>
      _ShipmentInspectionDetailsPageState();
}

class _ShipmentInspectionDetailsPageState
    extends State<ShipmentInspectionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider<ShipmentInspectionBloc>(
      create: (context) {
        return ShipmentInspectionBloc(
          ShipmentInspectionModel(
            companyId: companyId,
            userId: userId,
            shipNo: widget.shipNo,
            shipId: widget.shipId,
            index: widget.index != '' ? int.parse(widget.index) : 0,
            pageNum: widget.pageNum != '' ? int.parse(widget.pageNum) : 0,
          ),
        );
      },
      child: FractionallySizedBox(
        // widthFactor: 1,
        // heightFactor: 1,
        child: Container(
          // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ShipmentInspectionDetails(
            shipId: widget.shipId,
            shipNo: widget.shipNo,
            index: widget.index,
            pageNum: widget.pageNum,
          ),
        ),
      ),
    );
  }
}
