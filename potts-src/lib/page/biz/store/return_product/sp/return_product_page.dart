import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../../redux/wms_state.dart';
import '../bloc/return_product_bloc.dart';
import '../bloc/return_product_model.dart';
import 'return_product_form.dart';

/**
 * 内容：返品入力
 * 作者：赵士淞
 * 时间：2023/11/22
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
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 表单
              ReturnProductForm(),
            ],
          ),
        ),
      ),
    );
  }
}
