import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_bloc.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_model.dart';
import 'package:wms/redux/wms_state.dart';

import 'goods_transfer_entry_form.dart';
import 'goods_transfer_entry_title.dart';

/**
 * 内容：在庫移動入力 -文件
 * 作者：熊草云
 * 时间：2023/08/25
 */
class GoodsTransferEntryPage extends StatefulWidget {
  const GoodsTransferEntryPage({super.key});

  @override
  State<GoodsTransferEntryPage> createState() => _GoodsTransferEntryPageState();
}

class _GoodsTransferEntryPageState extends State<GoodsTransferEntryPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider<GoodsTransferEntryBloc>(
      create: (context) {
        return GoodsTransferEntryBloc(GoodsTransferEntryModel(
            companyId: companyId,
            userId: userId,
            detail: false,
            context: context));
      },
      child: BlocBuilder<GoodsTransferEntryBloc, GoodsTransferEntryModel>(
        builder: (context, state) {
          return Scrollbar(
            thumbVisibility: true,
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView(
                  children: [
                    // 头部
                    GoodsTransferEntryTitle(),
                    // 表单
                    GoodsTransferEntryForm(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
