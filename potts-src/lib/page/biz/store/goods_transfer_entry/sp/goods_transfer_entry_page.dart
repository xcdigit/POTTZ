import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_bloc.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_model.dart';

import 'goods_transfer_entry_form.dart';

/**
 * 内容：在庫移動入力 -文件
 * 作者：張博睿
 * 时间：2023/11/23
 */
class GoodsTransferEntryPage extends StatefulWidget {
  const GoodsTransferEntryPage({super.key});

  @override
  State<GoodsTransferEntryPage> createState() => _GoodsTransferEntryPageState();
}

class _GoodsTransferEntryPageState extends State<GoodsTransferEntryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoodsTransferEntryBloc>(
      create: (context) {
        return GoodsTransferEntryBloc(
            GoodsTransferEntryModel(detail: false, context: context));
      },
      child: BlocBuilder<GoodsTransferEntryBloc, GoodsTransferEntryModel>(
        builder: (context, state) {
          return FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView(
                children: [
                  // 表单
                  GoodsTransferEntryForm(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
