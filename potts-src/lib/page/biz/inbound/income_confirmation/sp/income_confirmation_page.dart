import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../redux/wms_state.dart';
import '../bloc/income_confirmation_bloc.dart';
import '../bloc/income_confirmation_model.dart';
import 'income_confirmation_retrieval.dart';
import 'income_confirmation_table.dart';
import 'package:intl/intl.dart';

/**
 * 内容：入荷確定 -文件
 * 作者：熊草云
 * 时间：2023/08/24
 */
// ignore_for_file: must_be_immutable
class IncomeConfirmationPage extends StatefulWidget {
  //当前时间
  String rcvSchDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
  IncomeConfirmationPage({super.key});

  @override
  State<IncomeConfirmationPage> createState() => _IncomeConfirmationPageState();
}

class _IncomeConfirmationPageState extends State<IncomeConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户会社ID
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return BlocProvider<IncomeConfirmationBloc>(
      create: (context) {
        return IncomeConfirmationBloc(IncomeConfirmationModel(
            rootBuildContext: context,
            companyId: companyId,
            rcvSchDate: widget.rcvSchDate));
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          child: ListView(
            children: [
              // // 检索
              IncomeConfirmationRetrieval(),
              // // 表单
              IncomeConfirmationTable(),
            ],
          ),
        ),
      ),
    );
  }
}
