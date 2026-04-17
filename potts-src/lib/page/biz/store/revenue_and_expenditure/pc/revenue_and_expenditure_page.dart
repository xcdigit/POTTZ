import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/store/revenue_and_expenditure/pc/revenue_and_expenditure_table.dart';
import 'package:wms/page/biz/store/revenue_and_expenditure/pc/revenue_and_expenditure_title.dart';

import '../bloc/revenue_and_expenditure_bloc.dart';
import '../bloc/revenue_and_expenditure_model.dart';

/**
 * 内容：受払照会
 * 作者：luxy
 * 时间：2023/08/28
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
      child: Scrollbar(
        thumbVisibility: true,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              //头部
              RevenueAndExpenditureTitle(),
              //表格
              RevenueAndExpenditureTable(),
            ],
          ),
        ),
      ),
    );
  }
}
