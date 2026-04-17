import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_bloc.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'exit_input_form.dart';
import 'exit_input_table.dart';
import 'exit_input_title.dart';

/**
 * 内容：出庫入力
 * 作者：赵士淞
 * 时间：2023/08/17
 */

// ignore: must_be_immutable
class ExitInputPage extends StatefulWidget {
  // 出荷指示ID
  int shipId = 0;

  ExitInputPage({super.key, this.shipId = 0});

  @override
  State<ExitInputPage> createState() => _ExitInputPageState();
}

class _ExitInputPageState extends State<ExitInputPage> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider(
      create: (context) {
        return ExitInputBloc(
          ExitInputModel(
              companyId: companyId, userId: userId, shipId: widget.shipId),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ListView(
              children: [
                // 头部
                ExitInputTitle(
                  titleText: WMSLocalizations.i18n(context)!.menu_content_3_12,
                ),
                // 表单
                ExitInputForm(),
                // 头部
                ExitInputTitle(
                  titleText:
                      WMSLocalizations.i18n(context)!.exit_input_form_overview,
                ),
                // 表格
                ExitInputTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
