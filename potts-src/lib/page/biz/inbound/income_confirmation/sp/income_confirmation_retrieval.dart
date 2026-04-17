import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_date_widget.dart';

import '../bloc/income_confirmation_bloc.dart';
import '../bloc/income_confirmation_model.dart';

/**
 * 内容：入荷確定 -文件
 * 作者：熊草云
 * 时间：2023/08/24
 */
class IncomeConfirmationRetrieval extends StatefulWidget {
  const IncomeConfirmationRetrieval({super.key});

  @override
  State<IncomeConfirmationRetrieval> createState() =>
      _IncomeConfirmationRetrievalState();
}

class _IncomeConfirmationRetrievalState
    extends State<IncomeConfirmationRetrieval> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomeConfirmationBloc, IncomeConfirmationModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BuildData(state),
              SizedBox(width: 20),
              BuildButtom(),
            ],
          ),
        );
      },
    );
  }

// 底部检索和解除按钮
  Container BuildButtom() {
    return Container(
      width: 80,
      height: 48,
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
          //检索方法
          context
              .read<IncomeConfirmationBloc>()
              .add(SelectIncomeBySchDateEvent(context));
        },
        child: Text(
          WMSLocalizations.i18n(context)!.delivery_note_24,
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

  // 日期
  Container BuildData(IncomeConfirmationModel state) {
    return Container(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(WMSLocalizations.i18n(context)!
                  .shipment_confirmation_data_query_1),
            ],
          ),
          SizedBox(height: 8),
          WMSDateWidget(
            borderColor: Color.fromRGBO(224, 224, 224, 1),
            backgroundColor: Colors.white,
            //进入页面日期设置为当前日期
            text: state.rcvSchDate,
            //返回日期
            dateCallBack: (value) {
              if (value != '') {
                context
                    .read<IncomeConfirmationBloc>()
                    .add(SetReceiveSchDateEvent(value));
              } else {
                context
                    .read<IncomeConfirmationBloc>()
                    .add(SetReceiveSchDateEvent(''));
              }
            },
          ),
        ],
      ),
    );
  }
}
