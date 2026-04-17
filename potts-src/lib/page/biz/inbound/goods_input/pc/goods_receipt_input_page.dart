// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_bloc.dart';
import 'package:wms/page/biz/inbound/goods_input/bloc/goods_input_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'goods_receipt_input_form.dart';
import 'goods_receipt_input_table.dart';
import 'goods_receipt_input_title.dart';

/**
 * 内容：入庫入力-文件
 * 作者：熊草云
 * 时间：2023/08/23
 */
class GoodsReceiptInputPage extends StatefulWidget {
  String receiveId;
  GoodsReceiptInputPage({super.key, required this.receiveId});

  @override
  State<GoodsReceiptInputPage> createState() => _GoodsReceiptInputPageState();
}

class _GoodsReceiptInputPageState extends State<GoodsReceiptInputPage> {
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
              receiveId: widget.receiveId),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
            child: ListView(
              children: [
                // 头部
                GoodsReceiptInputTitle(),
                // 表单
                GoodsReceiptInputForm(),
                // 表格
                GoodsReceiptInputTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
