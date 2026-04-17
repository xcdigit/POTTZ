import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/table/sp/wms_table_widget.dart';
import '../bloc/product_information_bloc.dart';
import '../bloc/product_information_model.dart';

/**
 * 内容：商品情报-在庫情報
 * 作者：赵士淞
 * 时间：2024/10/31
 */
class ProductInformationInventory extends StatefulWidget {
  const ProductInformationInventory({super.key});

  @override
  State<ProductInformationInventory> createState() =>
      _ProductInformationInventoryState();
}

class _ProductInformationInventoryState
    extends State<ProductInformationInventory> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInformationBloc, ProductInformationModel>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(
            bottom: 32,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child:
              WMSTableWidget<ProductInformationBloc, ProductInformationModel>(
            columns: [
              {
                'key': 'warehouse_name',
                'width': 1.0,
                'title': WMSLocalizations.i18n(context)!.inventory_output_3,
              },
              {
                'key': 'location_loc_cd',
                'width': 1.0,
                'title':
                    WMSLocalizations.i18n(context)!.inventory_information_shelf,
              },
              {
                'key': 'limit_date',
                'width': 0.5,
                'title': WMSLocalizations.i18n(context)!
                    .instruction_input_form_detail_14,
              },
              {
                'key': 'lot_no',
                'width': 0.5,
                'title':
                    WMSLocalizations.i18n(context)!.inventory_information_lot,
              },
              {
                'key': 'stock',
                'width': 0.5,
                'title': WMSLocalizations.i18n(context)!
                    .inventory_information_current_inventory,
              },
              {
                'key': 'note',
                'width': 1.0,
                'title': WMSLocalizations.i18n(context)!
                    .goods_receipt_input_information,
              },
            ],
            needPageInfo: false,
            showCheckboxColumn: false,
          ),
        );
      },
    );
  }
}
