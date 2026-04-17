import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_bloc.dart';
import 'package:wms/page/biz/outbound/ship/bloc/shipment_determination_model.dart';
import 'package:wms/widget/wms_date_widget.dart';
import '../../../../../common/localization/default_localizations.dart';

/**
 * 内容：出荷确定-检索
 * 作者：崔浩然
 * 时间：2023/08/18
 */
class ShipmentDeterminationCheck extends StatefulWidget {
  ShipmentDeterminationCheck({super.key});

  @override
  State<ShipmentDeterminationCheck> createState() =>
      ShipmentDeterminationCheckState();
}

class ShipmentDeterminationCheckState
    extends State<ShipmentDeterminationCheck> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDeterminationBloc, ShipmentDeterminationModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //出荷指示日
                      Container(
                        height: 22,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .instruction_input_form_basic_3,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      // 时间组件
                      WMSDateWidget(
                        //进入页面日期设置为当前日期
                        text: state.rcvSchDate,
                        //返回日期
                        dateCallBack: (value) {
                          if (value != '') {
                            context
                                .read<ShipmentDeterminationBloc>()
                                .add(SetShipSchDateEvent(value));
                          } else {
                            context
                                .read<ShipmentDeterminationBloc>()
                                .add(SetShipSchDateEvent(''));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              //搜索
              Expanded(
                flex: 1,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 22, left: 18),
                      child: BuildButtom(
                          WMSLocalizations.i18n(context)!.delivery_note_24, 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 底部检索和解除按钮
  Container BuildButtom(String text, int number) {
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
          if (number == 0) {
            //检索方法
            context
                .read<ShipmentDeterminationBloc>()
                .add(SelectShipBySchDateEvent(context));
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
}
