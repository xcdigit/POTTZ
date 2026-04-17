import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../bloc/product_information_bloc.dart';
import '../bloc/product_information_model.dart';

/**
 * 内容：商品情报-仕掛情報
 * 作者：赵士淞
 * 时间：2024/10/30
 */
class ProductInformationDesign extends StatefulWidget {
  const ProductInformationDesign({super.key});

  @override
  State<ProductInformationDesign> createState() =>
      _ProductInformationDesignState();
}

class _ProductInformationDesignState extends State<ProductInformationDesign> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInformationBloc, ProductInformationModel>(
      builder: (context, state) {
        // 初始化在制品信息盒子
        List<Widget> _initDesignBox() {
          return [
            // 出荷
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 24,
                margin: EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.menu_content_3,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ),
            // 出荷指示済数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开出荷指示照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenDisplayInstructionPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_shipment_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.shipmentNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 未出荷数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开出荷指示照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenDisplayInstructionPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unshipped_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unshippedNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 本日出荷指示数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开出荷指示照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenDisplayInstructionPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_shipment_number_today,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.shipmentNumberToday.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 本日未出荷数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开出荷指示照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenDisplayInstructionPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unshipped_number_today,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unshippedNumberToday.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 未出庫数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开出庫照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenOutboundQueryCommodityPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unoutbound_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unoutboundNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 未ピッキング数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开ピッキングリスト （シングル）页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenPickListCommodityPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unpicking_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unpickingNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 入荷
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 24,
                margin: EdgeInsets.only(
                  bottom: 16,
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.menu_content_2,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ),
            // 入荷予定数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开入荷予定照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenInquirySchedulePageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.menu_content_2_5_9,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.expectedNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 未入荷数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开入荷予定照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenInquirySchedulePageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unexpected_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unexpectedNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 本日入荷予定数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开入荷予定照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenInquirySchedulePageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_expected_number_today,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.expectedNumberToday.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 本日未入荷数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开入荷予定照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenInquirySchedulePageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unexpected_number_today,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unexpectedNumberToday.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 未検品数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开入荷检品页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenIncomingInspectionPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unchecked_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.uncheckedNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 未入庫数
            FractionallySizedBox(
              widthFactor: 0.49,
              child: GestureDetector(
                onTap: () {
                  // 打开入庫照会页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenWarehouseQueryCommodityPageEvent());
                },
                child: Container(
                  height: 112.5,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .design_information_unlisted_number,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          state.unlistedNumber.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 40,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        }

        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(
            bottom: 32,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: _initDesignBox(),
          ),
        );
      },
    );
  }
}
