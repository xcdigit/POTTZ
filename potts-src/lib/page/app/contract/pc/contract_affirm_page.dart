import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/page/app/contract/bloc/contract_bloc.dart';
import 'package:wms/page/app/contract/bloc/contract_model.dart';
import 'package:wms/page/app/contract/pc/contract_head_page.dart';

import '../../../../redux/wms_state.dart';
import '../bloc/contract_affirm_bloc.dart';
import '../bloc/contract_affirm_model.dart';

import 'contract_affirm.dart';

/**
 * 内容：サービス解約-主页
 * 作者：王光顺
 * 时间：2023/12/07
 */
class ContractAffirmPage extends StatefulWidget {
  const ContractAffirmPage({super.key});

  @override
  State<ContractAffirmPage> createState() => _ContractAffirmPageState();
}

class _ContractAffirmPageState extends State<ContractAffirmPage> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> DateList =
        StoreProvider.of<WMSState>(context).state.contractParam;
    //获取当前登录用户会社ID
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    return Material(
      //整体
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ContractAffirmBloc>(
            create: (context) {
              return ContractAffirmBloc(
                ContractAffirmModel(DateList: DateList),
              );
            },
          ),
          BlocProvider<ContractBloc>(
            create: (context) {
              return ContractBloc(
                ContractModel(context: context, companyId: companyId),
              );
            },
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            children: [
              //头部
              Container(
                height: 100,
                child: ContractHeadPage(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 60, right: 60),
                  child: ListView(
                    children: [
                      //内容
                      ContractAffirm(),
                    ],
                  ),
                  constraints: BoxConstraints(
                    minWidth: Config.WEB_MINI_WIDTH_LIMIT.toDouble(),
                    maxWidth: Config.WEB_MINI_WIDTH_LIMIT.toDouble(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
