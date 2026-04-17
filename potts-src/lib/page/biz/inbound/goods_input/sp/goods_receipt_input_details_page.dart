// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_bloc.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_model.dart';
import 'package:wms/page/biz/inbound/goods_input/sp/goods_receipt_input_details.dart';
import 'package:wms/redux/wms_state.dart';

/**
 * content：入庫入力-details-page
 * author：张博睿
 * date：2023/11/09
 */
class GoodsReceiptInputDetailsPage extends StatefulWidget {
  // 入荷指示ID
  String incomingNumber;
  String receiveId;
  GoodsReceiptInputDetailsPage({
    super.key,
    required this.incomingNumber,
    required this.receiveId,
  });

  @override
  State<GoodsReceiptInputDetailsPage> createState() =>
      _GoodsReceiptInputDetailsPageState();
}

class _GoodsReceiptInputDetailsPageState
    extends State<GoodsReceiptInputDetailsPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider<GoodsInputBloc>(
      create: (context) {
        return GoodsInputBloc(
          GoodsInputModel(
              rootContext: context,
              companyId: companyId,
              userId: userId,
              incomingNumber: widget.incomingNumber,
              receiveId: widget.receiveId),
        );
      },
      child: FractionallySizedBox(
        // widthFactor: 1,
        // heightFactor: 1,
        child: Container(
            // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: GoodsReceiptInputDetails(
          incomingNumber: widget.incomingNumber,
          receiveId: widget.receiveId,
        )),
      ),
    );
  }
}
