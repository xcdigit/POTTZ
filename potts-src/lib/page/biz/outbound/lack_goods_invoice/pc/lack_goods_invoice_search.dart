import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/outbound/lack_goods_invoice/bloc/lack_goods_invoice_model.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import '../../../../../common/config/config.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../bloc/lack_goods_invoice_bloc.dart';

/**
 * 内容：欠品伝票照会
 * 作者：熊草云
 * 时间：2023/09/04
 */
Map searchList = {};
String? date1;
String? date2;

class LackGoodsInvoiceSearch extends StatefulWidget {
  const LackGoodsInvoiceSearch({super.key});

  @override
  State<LackGoodsInvoiceSearch> createState() => _LackGoodsInvoiceSearchState();
}

class _LackGoodsInvoiceSearchState extends State<LackGoodsInvoiceSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LackGoodsInvoiceBloc, LackGoodsInvoiceModel>(
        builder: (context, state) {
      return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // 出荷指示番号
          FractionallySizedBox(
            widthFactor: .3,
            child: Container(
              // width: 400,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.delivery_note_14,
                      ),
                    ),
                    Container(
                      height: 48,
                      child: WMSInputboxWidget(
                        text: state.shipno.toString(),
                        inputBoxCallBack: (value) {
                          context
                              .read<LackGoodsInvoiceBloc>()
                              .add(SetSearchEvent(0, value));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          FractionallySizedBox(widthFactor: .1, child: Container()),
          FractionallySizedBox(
            widthFactor: .25,
            child: Container(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.delivery_note_16,
                    ),
                  ),
                  Container(
                    height: 48,
                    child: WMSDateWidget(
                      text: date1,
                      dateCallBack: (value) {
                        setState(() {
                          date1 = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: .05,
            child: Container(
              height: 80,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                    ),
                    Container(
                      height: 48,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "~",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]),
            ),
          ),
          FractionallySizedBox(
            widthFactor: .25,
            child: Container(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                  ),
                  Container(
                    height: 48,
                    child: WMSDateWidget(
                      text: date2,
                      dateCallBack: (value) {
                        setState(() {
                          date2 = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          // 商品名
          FractionallySizedBox(
            widthFactor: .3,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 24,
                    child: Text(
                      WMSLocalizations.i18n(context)!.reserve_input_11,
                    ),
                  ),
                  Container(
                    height: 48,
                    child: WMSInputboxWidget(
                      text: state.product.toString(),
                      inputBoxCallBack: (value) {
                        context
                            .read<LackGoodsInvoiceBloc>()
                            .add(SetSearchEvent(1, value));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          FractionallySizedBox(
            widthFactor: .3,
            child: Container(
              width: 100,
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 24),
                    Container(
                      height: 48,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(44, 167, 176, 1),
                            ), // 设置文本颜色
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(120, 48)), // 设置按钮宽度和高度
                          ),
                          child: Text(
                              WMSLocalizations.i18n(context)!.delivery_note_24),
                          onPressed: () {
                            bool checkFlg = context
                                .read<LackGoodsInvoiceBloc>()
                                .selectBeforeCheck(context, state.shipno);
                            if (checkFlg) {
                              setState(() {
                                searchList['p_ship_no'] = state.shipno;
                                searchList['p_rcv_sch_date1'] = date1;
                                searchList['p_rcv_sch_date2'] = date2;
                                searchList['p_product_name'] = state.product;
                                context
                                    .read<LackGoodsInvoiceBloc>()
                                    .add(SetQueryShipEvent(searchList));
                                context
                                    .read<LackGoodsInvoiceBloc>()
                                    .add(SetTabEvent(Config.NUMBER_ZERO));
                              });
                              context
                                  .read<LackGoodsInvoiceBloc>()
                                  .add(PageQueryEvent());
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
