import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/inventory_inquiry_bloc.dart';
import '../bloc/inventory_inquiry_dialog_bloc.dart';
import '../bloc/inventory_inquiry_dialog_model.dart';
import '../bloc/inventory_inquiry_model.dart';
import 'inventory_inquiry_table.dart';

/**
 * 内容：在庫照会
 * 作者：赵士淞
 * 时间：2023/11/21
 */
class InventoryInquiryPage extends StatefulWidget {
  const InventoryInquiryPage({super.key});

  @override
  State<InventoryInquiryPage> createState() => _InventoryInquiryPageState();
}

class _InventoryInquiryPageState extends State<InventoryInquiryPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InventoryInquiryBloc>(
          create: (context) {
            return InventoryInquiryBloc(
              InventoryInquiryModel(
                rootContext: context,
              ),
            );
          },
        ),
        BlocProvider<InventoryInquiryDialogBloc>(
          create: (context) {
            return InventoryInquiryDialogBloc(
              InventoryInquiryDialogModel(),
            );
          },
        ),
      ],
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          children: [
            // 表格
            InventoryInquiryTable(),
          ],
        ),
      ),
    );
  }
}
