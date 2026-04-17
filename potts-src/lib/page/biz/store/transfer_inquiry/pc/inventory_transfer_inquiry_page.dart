import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_bloc.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_model.dart';
import 'package:wms/page/biz/store/transfer_inquiry/pc/inventory_transfer_inquiry_table.dart';
import 'package:wms/page/biz/store/transfer_inquiry/pc/inventory_transfer_inquiry_title.dart';
import 'package:wms/redux/wms_state.dart';

/**
 * content：在庫移動照会-画面
 * author：张博睿
 * date：2023/08/28
 */

int? companyId;

class InventoryTransferInquiryPage extends StatefulWidget {
  const InventoryTransferInquiryPage({super.key});

  @override
  State<InventoryTransferInquiryPage> createState() =>
      _InventoryTransferInquiryPageState();
}

class _InventoryTransferInquiryPageState
    extends State<InventoryTransferInquiryPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<InventoryTransferInquiryBloc>(
      create: (context) {
        return InventoryTransferInquiryBloc(
          InventoryTransferInquiryModel(companyId: companyId),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
            child: ListView(
              children: [
                // title
                InventoryTransferInquiryTitle(),
                // table、search
                InventoryTransferInquiryTable()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
