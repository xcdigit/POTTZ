import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_bloc.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/bloc/goods_transfer_entry_model.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/sp/goods_transfer_entry_scan.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

// ignore: must_be_immutable
class GoodsTransferEntryFormDetail extends StatefulWidget {
  int locationIdFrom;
  String locationCodeFrom;
  int productId;
  String productCode;
  GoodsTransferEntryFormDetail({
    super.key,
    required this.locationIdFrom,
    required this.locationCodeFrom,
    required this.productId,
    required this.productCode,
  });

  @override
  State<GoodsTransferEntryFormDetail> createState() =>
      _GoodsTransferEntryFormDetailState();
}

class _GoodsTransferEntryFormDetailState
    extends State<GoodsTransferEntryFormDetail> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    return BlocProvider(
      create: (context) => GoodsTransferEntryBloc(GoodsTransferEntryModel(
        locationIdFrom: widget.locationIdFrom,
        locationCodeFrom: widget.locationCodeFrom,
        productId: widget.productId,
        productCode: widget.productCode,
        companyId: companyId,
        userId: userId,
        context: context,
        detail: false,
      )),
      child: GoodsTransferEntryFormDetailMain(),
    );
  }
}

class GoodsTransferEntryFormDetailMain extends StatefulWidget {
  const GoodsTransferEntryFormDetailMain({super.key});

  @override
  State<GoodsTransferEntryFormDetailMain> createState() =>
      _GoodsTransferEntryFormDetailMainState();
}

class _GoodsTransferEntryFormDetailMainState
    extends State<GoodsTransferEntryFormDetailMain> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoodsTransferEntryBloc, GoodsTransferEntryModel>(
        builder: (bloc, state) {
      return Container(
        padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .goods_transfer_entry_destination_location_barcode,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: WMSInputboxWidget(
                              text: state.locationCodeTo,
                              borderColor: Colors.transparent,
                              inputBoxCallBack: (value) {
                                state.locationCodeTo = value;
                                bloc.read<GoodsTransferEntryBloc>().add(
                                    QueryLocationToMessageEvent(bloc, value));
                              },
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 48,
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GoodsTransferEntryScan(),
                                    ),
                                  );
                                },
                                icon: Image.asset(
                                  WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                                  height: 44,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .goods_transfer_entry_number_of_moves,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: WMSInputboxWidget(
                              text: state.moveCount.toString(),
                              borderColor: Colors.transparent,
                              inputBoxCallBack: (value) {
                                bloc
                                    .read<GoodsTransferEntryBloc>()
                                    .add(SetMoveCountEvent(value, context));
                              },
                            ),
                          ),
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(WMSLocalizations.i18n(context)!
                                  .shipment_inspection_item),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .goods_transfer_entry_reason_for_movement,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(255, 0, 0, 1.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromRGBO(224, 224, 224, 1),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: WMSInputboxWidget(
                            text: state.moveReason,
                            borderColor: Colors.transparent,
                            inputBoxCallBack: (value) {
                              bloc
                                  .read<GoodsTransferEntryBloc>()
                                  .add(SetMoveReasonEvent(value));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(44, 167, 176, 1),
                        ), // 设置按钮背景颜色
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // 设置按钮文本颜色
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(120, 48),
                        ), // 设置按钮宽度和高度
                      ),
                      child: Text(WMSLocalizations.i18n(context)!
                          .exit_input_form_button_execute),
                      onPressed: () {
                        bloc
                            .read<GoodsTransferEntryBloc>()
                            .add(ExecuteTransferGoodsEvent(bloc));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
