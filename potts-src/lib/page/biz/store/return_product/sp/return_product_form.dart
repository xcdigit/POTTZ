import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_scan_widget.dart';
import '../bloc/return_product_bloc.dart';
import '../bloc/return_product_model.dart';

/**
 * 内容：返品入力-表单
 * 作者：赵士淞
 * 时间：2023/11/22
 */
// 当前悬停下标
int currentHoverIndex = Config.NUMBER_NEGATIVE;
// 当前内容
Widget currentContent = Wrap();

class ReturnProductForm extends StatefulWidget {
  const ReturnProductForm({super.key});

  @override
  State<ReturnProductForm> createState() => _ReturnProductFormState();
}

class _ReturnProductFormState extends State<ReturnProductForm> {
  // 第一页売上返品表单
  Widget _initFormBasic(BuildContext context, ReturnProductModel state) {
    return BlocBuilder<ReturnProductBloc, ReturnProductModel>(
      builder: (bloc, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .return_product_form_1,
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
                            child: WMSInputboxWidget(
                              text: state.shipNumber.toString(),
                              borderColor: Colors.transparent,
                              inputBoxCallBack: (value) {
                                context
                                    .read<ReturnProductBloc>()
                                    .add(ClearFormEvent(Config.NUMBER_ZERO));
                                context.read<ReturnProductBloc>().add(
                                    SetRevShipNoEvent(
                                        value, Config.NUMBER_ZERO));
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ReturnProductBloc>().add(
                                  QuerySalesReturnProductInfoEvent(
                                      state.shipNumber, context));
                            },
                            icon: Icon(
                              Icons.search,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            FractionallySizedBox(
              widthFactor: 1,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .return_product_form_3,
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
                        Visibility(
                          visible: state.salesFlag,
                          child: WMSDropdownWidget(
                            dropdownKey: 'product_id',
                            dropdownTitle: 'product_name',
                            inputInitialValue:
                                state.salesProduct.name.toString(),
                            dataList1: state.salesProductInfoList,
                            inputRadius: 4,
                            inputBackgroundColor:
                                Color.fromRGBO(255, 255, 255, 1),
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            selectedCallBack: (value) {
                              context.read<ReturnProductBloc>().add(
                                    SetReturnProductInfoEvent(
                                        "id",
                                        value['product_id'].toString(),
                                        Config.NUMBER_ZERO),
                                  );
                              context.read<ReturnProductBloc>().add(
                                    SetReturnProductInfoEvent(
                                        "name",
                                        value['product_name'].toString(),
                                        Config.NUMBER_ZERO),
                                  );
                            },
                          ),
                        ),
                        Visibility(
                          visible: !state.salesFlag,
                          child: WMSInputboxWidget(
                            text: '',
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .return_product_form_4,
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
                                child: WMSInputboxWidget(
                                  text: state.salesReturnQuantity.toString(),
                                  borderColor: Colors.transparent,
                                  readOnly: !state.salesFlag ? true : false,
                                  inputBoxCallBack: (value) {
                                    context.read<ReturnProductBloc>().add(
                                        SetReturnQuantityEvent(
                                            value, Config.NUMBER_ZERO));
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color.fromRGBO(224, 224, 224, 1),
                                    ),
                                  ),
                                ),
                                height: 48,
                                width: 48,
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
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .return_product_form_5,
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
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Visibility(
                            visible: state.salesFlag,
                            child: Expanded(
                              child: WMSDropdownWidget(
                                dropdownTitle: 'loc_cd',
                                inputInitialValue:
                                    state.salesLocation.loc_cd.toString(),
                                dataList1: state.salesLocationList,
                                inputRadius: 4,
                                inputBackgroundColor:
                                    Color.fromRGBO(255, 255, 255, 1),
                                inputSuffixIcon: Container(
                                  width: 24,
                                  height: 24,
                                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                ),
                                selectedCallBack: (value) {
                                  context.read<ReturnProductBloc>().add(
                                      SetReturnLocationInfoEvent(
                                          "id",
                                          value['id'].toString(),
                                          Config.NUMBER_ZERO));
                                  context.read<ReturnProductBloc>().add(
                                      SetReturnLocationInfoEvent(
                                          "loc_cd",
                                          value['loc_cd'].toString(),
                                          Config.NUMBER_ZERO));
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !state.salesFlag,
                            child: Expanded(
                              child: WMSInputboxWidget(
                                borderColor: Colors.transparent,
                                text: '',
                                readOnly: true,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (builderContext) {
                                  return Container(
                                    width: 100,
                                    height: 100,
                                    child: WMSScanWidget(
                                      scanCallBack: (value) {
                                        context.read<ReturnProductBloc>().add(
                                            ReturnLocationInfoScanEvent(value,
                                                context, Config.NUMBER_ZERO));
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Image.asset(
                              WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                              height: 44,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 第二页仕入返品表单
  Widget _initFormBefore(BuildContext context, ReturnProductModel state) {
    return BlocBuilder<ReturnProductBloc, ReturnProductModel>(
      builder: (bloc, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 80,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .return_product_form_2,
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
                            child: WMSInputboxWidget(
                              text: state.receiveNumber.toString(),
                              borderColor: Colors.transparent,
                              inputBoxCallBack: (value) {
                                context
                                    .read<ReturnProductBloc>()
                                    .add(ClearFormEvent(Config.NUMBER_ONE));
                                context.read<ReturnProductBloc>().add(
                                    SetRevShipNoEvent(
                                        value, Config.NUMBER_ONE));
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<ReturnProductBloc>().add(
                                  QueryReturnProductInfoEvent(
                                      state.receiveNumber, context));
                            },
                            icon: Icon(
                              Icons.search,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            FractionallySizedBox(
              widthFactor: 1,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .return_product_form_3,
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
                        Visibility(
                          visible: state.deliverFlag,
                          child: WMSDropdownWidget(
                            dropdownKey: 'product_id',
                            dropdownTitle: 'product_name',
                            inputInitialValue: state.product.name.toString(),
                            dataList1: state.productInfoList,
                            inputRadius: 4,
                            inputBackgroundColor:
                                Color.fromRGBO(255, 255, 255, 1),
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            selectedCallBack: (value) {
                              context.read<ReturnProductBloc>().add(
                                    SetReturnProductInfoEvent(
                                        "id",
                                        value['product_id'].toString(),
                                        Config.NUMBER_ONE),
                                  );
                              context.read<ReturnProductBloc>().add(
                                    SetReturnProductInfoEvent(
                                        "name",
                                        value['product_name'].toString(),
                                        Config.NUMBER_ONE),
                                  );
                            },
                          ),
                        ),
                        Visibility(
                          visible: !state.deliverFlag,
                          child: WMSInputboxWidget(
                            text: '',
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .return_product_form_4,
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
                                child: WMSInputboxWidget(
                                  text: state.returnQuantity.toString(),
                                  borderColor: Colors.transparent,
                                  readOnly: !state.deliverFlag ? true : false,
                                  inputBoxCallBack: (value) {
                                    context.read<ReturnProductBloc>().add(
                                        SetReturnQuantityEvent(
                                            value, Config.NUMBER_ONE));
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Color.fromRGBO(224, 224, 224, 1),
                                    ),
                                  ),
                                ),
                                height: 48,
                                width: 48,
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
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Column(
                children: [
                  Container(
                    child: Container(
                      height: 80,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 24,
                            child: Row(
                              children: [
                                Text(
                                  WMSLocalizations.i18n(context)!
                                      .return_product_form_5,
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
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromRGBO(224, 224, 224, 1),
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: state.deliverFlag,
                                  child: Expanded(
                                    child: WMSDropdownWidget(
                                      dropdownTitle: 'loc_cd',
                                      inputInitialValue:
                                          state.location.loc_cd.toString(),
                                      dataList1: state.locationList,
                                      inputRadius: 4,
                                      inputBackgroundColor:
                                          Color.fromRGBO(255, 255, 255, 1),
                                      inputSuffixIcon: Container(
                                        width: 24,
                                        height: 24,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 16, 0),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ),
                                      selectedCallBack: (value) {
                                        context.read<ReturnProductBloc>().add(
                                            SetReturnLocationInfoEvent(
                                                "id",
                                                value['id'].toString(),
                                                Config.NUMBER_ONE));
                                        context.read<ReturnProductBloc>().add(
                                            SetReturnLocationInfoEvent(
                                                "loc_cd",
                                                value['loc_cd'].toString(),
                                                Config.NUMBER_ONE));
                                      },
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !state.deliverFlag,
                                  child: Expanded(
                                    child: WMSInputboxWidget(
                                      borderColor: Colors.transparent,
                                      text: '',
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (builderContext) {
                                        return WMSScanWidget(
                                          scanCallBack: (value) {
                                            context
                                                .read<ReturnProductBloc>()
                                                .add(
                                                    ReturnLocationInfoScanEvent(
                                                        value,
                                                        context,
                                                        Config.NUMBER_ONE));
                                          },
                                        );
                                      },
                                    );
                                  },
                                  icon: Image.asset(
                                    WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                                    height: 44,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 底部检索和解除按钮
  Container BuildButtom(String text, int flag) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 200),
      width: 88,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 61, 174, 182),
        border: Border.all(
          width: 1,
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
      ),
      child: OutlinedButton(
        onPressed: () async {
          bool returnFlag = await context
              .read<ReturnProductBloc>()
              .ExecuteReturnProductEvent(flag, context);
          if (returnFlag) {
            _showDetailDialog(flag);
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
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

  _showDetailDialog(int flag) {
    ReturnProductBloc bloc = context.read<ReturnProductBloc>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (builderContext) {
        return BlocProvider<ReturnProductBloc>.value(
          value: bloc,
          child: BlocBuilder<ReturnProductBloc, ReturnProductModel>(
            builder: (bloc, state) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero, // 设置为零边距
                content: Container(
                  height: 300,
                  width: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    children: [_showDetailDialogContent(flag, builderContext)],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _showDetailDialogContent(int flag, BuildContext builderContext) {
    return BlocBuilder<ReturnProductBloc, ReturnProductModel>(
      builder: (bloc, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                height: 80,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    WMSLocalizations.i18n(context)!.Return_product_3,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      "${WMSLocalizations.i18n(context)!.goods_receipt_input_completed_context_1} ${flag == Config.NUMBER_ZERO ? state.salesProduct.name : state.product.name} ${WMSLocalizations.i18n(context)!.Return_product_5}"),
                ),
              ),
            ),
            // 赵士淞 - 始
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // 设置按钮文本颜色
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(120, 48)), // 设置按钮宽度和高度
                  ),
                  child: Text(WMSLocalizations.i18n(context)!
                      .goods_receipt_input_label_publishing),
                  onPressed: () {
                    // 打印事件
                    context
                        .read<ReturnProductBloc>()
                        .add(PrinterEvent(context));
                  },
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // 设置按钮文本颜色
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(120, 48)), // 设置按钮宽度和高度
                  ),
                  child: Text(WMSLocalizations.i18n(context)!.app_ok),
                  onPressed: () async {
                    Navigator.of(builderContext).pop();
                    context
                        .read<ReturnProductBloc>()
                        .add(ClearFormEvent(Config.NUMBER_ZERO));
                    context
                        .read<ReturnProductBloc>()
                        .add(ClearFormEvent(Config.NUMBER_ONE));
                  },
                ),
              ],
            ),
            // 赵士淞 - 终
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReturnProductBloc, ReturnProductModel>(
      builder: (bloc, state) {
        // 判断当前下标
        if (state.currentIndex == Config.NUMBER_ZERO) {
          // 当前内容
          currentContent = _initFormBasic(context, state);
        }
        return Container(
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ReturnProductFormTab(
                    initFormBasic: _initFormBasic,
                    initFormBefore: _initFormBefore,
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: currentContent,
                ),
              ),
              BuildButtom(
                  WMSLocalizations.i18n(context)!
                      .exit_input_form_button_execute,
                  state.currentIndex),
            ],
          ),
        );
      },
    );
  }
}

typedef TabContextBuilder = Widget Function(
    BuildContext context, ReturnProductModel state);

// 返品入力-表单Tab
// ignore: must_be_immutable
class ReturnProductFormTab extends StatefulWidget {
  // 初始化基本情報入力表单
  TabContextBuilder initFormBasic;
  // 初始化出荷先情報入力表单
  TabContextBuilder initFormBefore;

  ReturnProductFormTab({
    super.key,
    required this.initFormBasic,
    required this.initFormBefore,
  });

  @override
  State<ReturnProductFormTab> createState() => _ReturnProductFormTabState();
}

class _ReturnProductFormTabState extends State<ReturnProductFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(
      tabItemList, BuildContext context, ReturnProductModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 判断当前下标
    if (state.currentIndex == Config.NUMBER_ZERO) {
      // 当前内容
      currentContent = widget.initFormBasic(context, state);
    } else if (state.currentIndex == Config.NUMBER_ONE) {
      // 当前内容
      currentContent = widget.initFormBefore(context, state);
    } else {
      // 当前内容
      currentContent = Wrap();
    }
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 当前下标
              context
                  .read<ReturnProductBloc>()
                  .add(CurrentIndexChangeEvent(tabItemList[i]['index']));
            },
            child: Container(
              height: 40,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: state.currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 108,
              ),
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: state.currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.Return_product_1,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.Return_product_2,
      },
    ];
    return BlocBuilder<ReturnProductBloc, ReturnProductModel>(
      builder: (bloc, state) {
        return Row(
          children: _initTabList(_tabItemList, context, state),
        );
      },
    );
  }
}
