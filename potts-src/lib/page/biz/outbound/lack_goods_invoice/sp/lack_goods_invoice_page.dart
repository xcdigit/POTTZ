import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/outbound/lack_goods_invoice/bloc/lack_goods_invoice_bloc.dart';
import '../bloc/lack_goods_invoice_model.dart';
import 'lack_goods_invoice_search.dart';
import 'lack_goods_invoice_table.dart';

/**
 * 内容：欠品伝票照会-SP
 * 作者：熊草云
 * 时间：2023/10/31
 */
class LackGoodsInvoicePage extends StatefulWidget {
  const LackGoodsInvoicePage({super.key});

  @override
  State<LackGoodsInvoicePage> createState() => _LackGoodsInvoicePageState();
}

class _LackGoodsInvoicePageState extends State<LackGoodsInvoicePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LackGoodsInvoiceBloc>(
      create: (context) {
        return LackGoodsInvoiceBloc(
          LackGoodsInvoiceModel(context: context),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          children: [
            // 检索 xcy
            LackGoodsInvoiceSearch(),
            //表格
            LackGoodsInvoiceTable(),
          ],
        ),
      ),
    );
  }
}
