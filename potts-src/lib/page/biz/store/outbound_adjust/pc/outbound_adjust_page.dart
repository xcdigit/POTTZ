import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_bloc.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'outbound_adjust_table.dart';
import 'outbound_adjust_title.dart';

/**
 * 内容：在库调整入力
 * 作者：cuihr
 * 时间：2023/08/28
 */
class OutboundAdjustPage extends StatefulWidget {
  const OutboundAdjustPage({super.key});

  @override
  State<OutboundAdjustPage> createState() => _OutboundAdjustPageState();
}

class _OutboundAdjustPageState extends State<OutboundAdjustPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider<OutboundAdjustBloc>(
      create: (context) {
        return OutboundAdjustBloc(
          OutboundAdjustModel(companyId: companyId, userId: userId),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
            child: ListView(
              children: [
                //头部
                OutboundAdjustTitle(),
                //表格
                OutboundAdjustTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
