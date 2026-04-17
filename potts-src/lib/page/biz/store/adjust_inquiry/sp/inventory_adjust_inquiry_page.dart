import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_bloc.dart';
import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_model.dart';
import 'package:wms/page/biz/store/adjust_inquiry/sp/inventory_adjust_inquiry_table.dart';
import 'package:wms/redux/wms_state.dart';

/**
 * content：在庫調整照会-画面
 * author：张博睿
 * date：2023/11/24
 */

class InventoryAdjustInquiryPage extends StatefulWidget {
  const InventoryAdjustInquiryPage({super.key});

  @override
  State<InventoryAdjustInquiryPage> createState() =>
      _InventoryAdjustInquiryPageState();
}

class _InventoryAdjustInquiryPageState
    extends State<InventoryAdjustInquiryPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider(
      create: (context) {
        return InventoryAdjustInquiryBloc(
          InventoryAdjustInquiryModel(companyId: companyId),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // table、search
              InventoryAdjustInquiryTable()
            ],
          ),
        ),
      ),
    );
  }
}
