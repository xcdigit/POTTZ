import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_date_widget.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../bloc/shipment_confirmation_export_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/shipment_confirmation_export_model.dart';
/**
 * 内容：出荷確定データ出力-检索
 * 作者：张博睿
 * 时间：2023/08/22
 */

// 出荷確定日
DateTime now = DateTime.now();
String data1 = DateFormat('yyyy/MM/dd').format(now);
// String data1 = DateTime.now().toString();

class ShipmentConfirmationExportQuery extends StatefulWidget {
  const ShipmentConfirmationExportQuery({super.key});

  @override
  State<ShipmentConfirmationExportQuery> createState() =>
      _ShipmentConfirmationExportQueryState();
}

class _ShipmentConfirmationExportQueryState
    extends State<ShipmentConfirmationExportQuery> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentConfirmationExportBloc,
        ShipmentConfirmationExportModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(WMSLocalizations.i18n(context)!
                              .shipment_confirmation_export_query_1),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: WMSDateWidget(
                            text: state.searchDate,
                            dateCallBack: (value) {
                              data1 = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(""),
                        ),
                        Container(
                          width: 210,
                          height: 48,
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: OutlinedButton(
                            onPressed: () {
                              context
                                  .read<ShipmentConfirmationExportBloc>()
                                  .add(SetSearchEvent(data1));
                            },
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .shipment_confirmation_export_query,
                              style: TextStyle(
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
