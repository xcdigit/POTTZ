import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/return_product/bloc/return_product_bloc.dart';
import 'package:wms/page/biz/store/return_product/bloc/return_product_model.dart';
import 'package:wms/page/biz/store/return_product/pc/return_product_form.dart';
import 'package:wms/page/biz/store/return_product/pc/return_product_title.dart';
import 'package:wms/redux/wms_state.dart';

/**
 * 内容：返品入力
 * 作者：王光顺
 * 时间：2023/08/25
 */
class ReturnProductPage extends StatefulWidget {
  const ReturnProductPage({super.key});

  @override
  State<ReturnProductPage> createState() => _ReturnProductPageState();
}

class _ReturnProductPageState extends State<ReturnProductPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider<ReturnProductBloc>(
      create: (context) {
        return ReturnProductBloc(
          ReturnProductModel(companyId: companyId, userId: userId),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 80),
            child: ListView(
              children: [
                // 头部
                ReturnProductTitle(),
                // 表单
                ReturnProductForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
