import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/revenue_and_expenditure_bloc.dart';
import '../bloc/revenue_and_expenditure_model.dart';
import 'revenue_and_expenditure_table.dart';

/**
 * 内容：受払照会-文件-sp
 * 作者：熊草云
 * 时间：2023/11/21
 */
class RevenueAndExpenditurePage extends StatefulWidget {
  const RevenueAndExpenditurePage({super.key});

  @override
  State<RevenueAndExpenditurePage> createState() =>
      _RevenueAndExpenditurePageState();
}

class _RevenueAndExpenditurePageState extends State<RevenueAndExpenditurePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RevenueAndExpenditureBloc>(
      create: (context) {
        return RevenueAndExpenditureBloc(
          RevenueAndExpenditureModel(context: context),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          children: [
            //表格
            RevenueAndExpenditureTable(),
          ],
        ),
      ),
    );
  }
}
