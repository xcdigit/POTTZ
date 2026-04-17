import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_bloc.dart';
import 'package:wms/page/biz/inbound/confirmation/bloc/confirmation_data_model.dart';

import '../../../../../widget/wms_date_widget.dart';

/**
 * 内容：入荷確定データ出力 -搜索
 * 作者：cuihr
 * 时间：2023/08/24
 */
class ConfirmationDataQuery extends StatefulWidget {
  const ConfirmationDataQuery({super.key});

  @override
  State<ConfirmationDataQuery> createState() => _ConfirmationDataQueryState();
}

String _datetime = DateFormat('yyyy/MM/dd').format(DateTime.now());

class _ConfirmationDataQueryState extends State<ConfirmationDataQuery> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfirmationDataBloc, ConfirmationDataModel>(
      builder: ((context, state) {
        return Container(
          child: Row(
            children: [
              //入荷予定日
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .shipment_confirmation_data_query_1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      // 时间组件
                      Container(
                        child: WMSDateWidget(
                          //进入页面日期设置为当前日期
                          text: _datetime,
                          //返回日期
                          dateCallBack: (value) {
                            if (value != '') {
                              _datetime = value;
                            } else {
                              _datetime = '';
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 24, left: 18),
                      child: BuildButtom(
                        WMSLocalizations.i18n(context)!
                            .shipment_confirmation_data_query,
                        0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
    //入荷確定データ出力 -搜索
  }

  // 底部检索和解除按钮
  Container BuildButtom(String text, int number) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 61, 174, 182),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: OutlinedButton(
        onPressed: () {
          if (number == 0) {
            context
                .read<ConfirmationDataBloc>()
                .add(SetReceiveValueEvent(_datetime));
          } else {}
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 61, 174, 182),
          ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          side: MaterialStateProperty.all(
            BorderSide.none,
          ),
        ),
      ),
    );
  }

  //日期
  Expanded BuildData(String text) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TextStyle(color: Colors.black)),
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2050),
              );
              if (selectedDate != null) {
                setState(() {
                  _datetime = DateFormat('yyyy/MM/dd').format(selectedDate);
                });
              }
            },
            child: FractionallySizedBox(
              widthFactor: .3,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(_datetime,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
