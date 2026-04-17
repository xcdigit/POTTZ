// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_bloc.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/page/biz/outbound/exit_input/sp/exit_input_details.dart';
import 'package:wms/redux/wms_state.dart';

/**
 * content：出库入力-details-page
 * author：张博睿
 * date：2023/11/09
 */
class exitInputDetailsPage extends StatefulWidget {
  // 入荷指示ID
  String shipCodeValue;
  String shipId;
  exitInputDetailsPage(
      {super.key, required this.shipCodeValue, required this.shipId});

  @override
  State<exitInputDetailsPage> createState() => _exitInputDetailsPageState();
}

class _exitInputDetailsPageState extends State<exitInputDetailsPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider<ExitInputBloc>(
      create: (context) {
        return ExitInputBloc(
          ExitInputModel(
              companyId: companyId,
              userId: userId,
              shipCodeValue: widget.shipCodeValue,
              shipId: int.parse(widget.shipId)),
        );
      },
      child: FractionallySizedBox(
        // widthFactor: 1,
        // heightFactor: 1,
        child: Container(
          // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ExitInputDetails(
            shipCodeValue: widget.shipCodeValue,
            shipId: widget.shipId,
          ),
        ),
      ),
    );
  }
}
