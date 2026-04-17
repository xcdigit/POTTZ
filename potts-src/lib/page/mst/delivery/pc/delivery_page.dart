import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_bloc.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_model.dart';
import 'package:wms/page/mst/delivery/pc/delivery_title.dart';
import '../../../../redux/wms_state.dart';
import 'delivery_search.dart';
import 'delivery_table.dart';

/**
 * 内容：納入先マスタ-画面
 * 作者：张博睿
 * 时间：2023/09/06
 */

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  @override
  Widget build(BuildContext context) {
    //获取当前登录用户身份
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    //获取当前登录用户会社ID
    int companyId = 0;
    if (StoreProvider.of<WMSState>(context).state.loginUser!.company_id !=
        null) {
      companyId = StoreProvider.of<WMSState>(context)
          .state
          .loginUser!
          .company_id as int;
    }
    return BlocProvider<DeliveryBloc>(
      create: (context) {
        return DeliveryBloc(
          DeliveryModel(context: context, companyId: companyId, roleId: roleId),
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
                // title
                DeliveryTitle(),
                //search
                DeliverySearch(),
                // table、
                DeliveryTable()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
