import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_master_management_bloc.dart';
import '../bloc/product_master_management_model.dart';
import 'product_master_management_search.dart';
import 'product_master_management_table.dart';
import 'product_master_management_title.dart';

/**
 * 内容：商品マスタ管理-主页
 * 作者：熊草云
 * 时间：2023/09/05
 */
class ProductMasterManagementPage extends StatefulWidget {
  const ProductMasterManagementPage({super.key});

  @override
  State<ProductMasterManagementPage> createState() =>
      _ProductMasterManagementPageState();
}

class _ProductMasterManagementPageState
    extends State<ProductMasterManagementPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductMasterManagementBloc>(
      create: (context) {
        return ProductMasterManagementBloc(
          ProductMasterManagementModel(context: context),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                // 头部
                ProductMasterManagementTitle(),
                // 检索
                ProductMasterManagementSearch(),
                // 表单
                ProductMasterManagementTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
