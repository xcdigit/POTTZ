import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_bloc.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../widget/wms_dropdown_widget.dart';

/**
 * 内容：出庫入力-表单
 * 作者：赵士淞
 * 时间：2023/08/17
 */
class ExitInputForm extends StatefulWidget {
  const ExitInputForm({super.key});

  @override
  State<ExitInputForm> createState() => _ExitInputFormState();
}

class _ExitInputFormState extends State<ExitInputForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromRGBO(224, 224, 224, 1),
        ),
      ),
      child: Column(
        children: [
          ExitInputFormContent(),
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: 36,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    child: ExitInputFormButton(),
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

// 出庫入力-表单内容
class ExitInputFormContent extends StatefulWidget {
  const ExitInputFormContent({super.key});

  @override
  State<ExitInputFormContent> createState() => _ExitInputFormContentState();
}

class _ExitInputFormContentState extends State<ExitInputFormContent> {
  // 初始化表单内容
  List<Widget> _initFormContent(
      {required ExitInputModel state, required BuildContext bloc}) {
    return [
      //ピッキングリストバーコード
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.exit_input_form_title_1,
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
                        text: state.locationCodeValue.toString(),
                        borderColor: Colors.transparent,
                        inputBoxCallBack: (value) {
                          state.locationCodeValue = value;
                          if (value != '') {
                            bloc.read<ExitInputBloc>().add(
                                QueryLocationinformation(
                                    state.locationCodeValue, context));
                          } else {
                            if (state.records.length > 0) {
                              bloc.read<ExitInputBloc>().add(
                                  QueryLocationinformation(
                                      state.locationCodeValue, context));
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {},
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
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              WMSInputboxWidget(
                text: state.shipCodeValue.toString(),
                readOnly: true,
                inputBoxCallBack: (value) {
                  state.shipCodeValue = value;
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_3,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              WMSInputboxWidget(
                text: state.customerValue.toString(),
                readOnly: true,
                inputBoxCallBack: (value) {
                  state.customerValue = value;
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_4,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              WMSInputboxWidget(
                text: state.deliveryValue.toString(),
                readOnly: true,
                inputBoxCallBack: (value) {
                  state.deliveryValue = value;
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Divider(
            height: 1.0,
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
      ),
      //ピッキングリスト明細部のバーコード
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.exit_input_form_title_5,
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
                        text: state.detailsCodeValue.toString(),
                        borderColor: Colors.transparent,
                        inputBoxCallBack: (value) {
                          bloc.read<ExitInputBloc>().add(
                                QueryDetailsinformation(
                                  context,
                                  value,
                                ),
                              );
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {},
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
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_6,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              WMSInputboxWidget(
                text: state.detailLocationCode.toString(),
                readOnly: true,
                inputBoxCallBack: (value) {
                  state.detailLocationCode = value;
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_7,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              WMSInputboxWidget(
                text: state.productCodeValue.toString(),
                readOnly: true,
                inputBoxCallBack: (value) {
                  state.productCodeValue = value;
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_8,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              WMSInputboxWidget(
                text: state.productNameValue.toString(),
                readOnly: true,
                inputBoxCallBack: (value) {
                  state.productNameValue = value;
                },
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_9,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
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
                      flex: 1,
                      child: WMSInputboxWidget(
                        text: state.allocationNumberValue.toString(),
                        readOnly: true,
                        inputBoxCallBack: (value) {},
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
        widthFactor: 0.4,
        child: Container(
          height: 160,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.exit_input_form_title_10,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Visibility(
                  visible:
                      // ignore: unnecessary_null_comparison
                      state.productImage1 != null && state.productImage1 != '',
                  child: Image.network(
                    state.productImage1,
                    width: 136,
                    height: 136,
                  )),
              Visibility(
                visible:
                    // ignore: unnecessary_null_comparison
                    state.productImage2 != null && state.productImage2 != '',
                child: Image.network(
                  state.productImage2,
                  width: 136,
                  height: 136,
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Divider(
            height: 1.0,
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
      ),
      //ロケーションのバーコード
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.exit_input_form_title_11,
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
                        text: state.locationBarCode.toString(),
                        borderColor: Colors.transparent,
                        inputBoxCallBack: (value) {
                          bloc
                              .read<ExitInputBloc>()
                              .add(SetLocationEvent(value, context));
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {},
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
      //商品ラベルのバーコード
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.exit_input_form_title_12,
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
                        text: state.productBarCode.toString(),
                        borderColor: Colors.transparent,
                        inputBoxCallBack: (value) {
                          bloc
                              .read<ExitInputBloc>()
                              .add(SetBarCodeCountEvent(value, context));
                          state.productBarCode = value.toString();
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {},
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
      //合計数
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.exit_input_form_title_13,
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
                      flex: 1,
                      child: WMSInputboxWidget(
                        borderColor: Colors.transparent,
                        text: state.productCount.toString(),
                        inputBoxCallBack: (value) {
                          bloc
                              .read<ExitInputBloc>()
                              .add(SetProductCountEvent(value, context));
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
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Divider(
            height: 1.0,
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
      ),
      //カゴ車またはオリコンのバーコード
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 72,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.exit_input_form_title_14,
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
                        borderColor: Colors.transparent,
                        text: state.shopBarcode.toString(),
                        inputBoxCallBack: (value) {
                          bloc
                              .read<ExitInputBloc>()
                              .add(SetShopBarcodeEvent(value, '4'));
                          //半角英数記号
                          if (CheckUtils.check_Half_Alphanumeric_Symbol(
                              value)) {
                            // 消息提示
                            WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                        .i18n(context)!
                                    .exit_input_form_title_14 +
                                WMSLocalizations.i18n(context)!
                                    .check_half_width_alphanumeric_with_symbol);
                          }
                        },
                      ),
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {},
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
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Divider(
            height: 1.0,
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExitInputBloc, ExitInputModel>(builder: (bloc, state) {
      return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: _initFormContent(bloc: bloc, state: state),
      );
    });
  }
}

// 出庫入力-表单按钮
class ExitInputFormButton extends StatefulWidget {
  const ExitInputFormButton({super.key});

  @override
  State<ExitInputFormButton> createState() => _ExitInputFormButtonState();
}

class _ExitInputFormButtonState extends State<ExitInputFormButton> {
  // ラベル発行-数量
  int labelCount = 0;

  // 赵士淞 - 始
  // 显示打印弹窗
  _showPrinterDialog(buttonItemList) {
    // 选中下标
    int chooseIndex = Config.NUMBER_NEGATIVE;

    ExitInputBloc bloc = context.read<ExitInputBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ExitInputBloc>.value(
          value: bloc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                    fontSize: 24,
                  ),
                ),
                Container(
                  height: 36,
                  child: Row(
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(44, 167, 176, 1),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(90, 36),
                          ),
                        ),
                        onPressed: () {
                          // 打印事件
                          bloc.add(PrinterEvent(context, chooseIndex));
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!.app_ok,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromRGBO(255, 255, 255, 1),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(90, 36),
                          ),
                        ),
                        onPressed: () {
                          // 关闭弹窗
                          Navigator.pop(context);
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_close,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: Container(
              width: 500,
              child: WMSDropdownWidget(
                dataList1: buttonItemList,
                inputRadius: 4,
                inputSuffixIcon: Container(
                  width: 24,
                  height: 24,
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                inputFontSize: 14,
                dropdownRadius: 4,
                dropdownKey: 'index',
                dropdownTitle: 'title',
                selectedCallBack: (value) {
                  // 判断数值
                  if (value == '') {
                    // 参数赋值
                    this.setState(() {
                      // 选中下标
                      chooseIndex = Config.NUMBER_NEGATIVE;
                    });
                  } else {
                    // 参数赋值
                    this.setState(() {
                      // 选中下标
                      chooseIndex = value['index'];
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
  // 赵士淞 - 终

  // 初始化表单按钮
  List<Widget> _initFormButton(
      List buttonItemList, BuildContext bloc, ExitInputModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          onTap: () {
            // 判断循环下标
            if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 赵士淞 - 始
              // 判断参数
              if (state.locationCodeValue != '' &&
                  state.detailsCodeValue != '' &&
                  state.locationBarCode != '' &&
                  state.productId != 0 &&
                  state.productCount != 0) {
                // 按钮单个列表
                List _buttonItemList = [
                  {
                    'index': Config.NUMBER_ZERO,
                    'title':
                        WMSLocalizations.i18n(context)!.shelves_product_label,
                  },
                  {
                    'index': Config.NUMBER_ONE,
                    'title':
                        WMSLocalizations.i18n(context)!.baskets_product_label,
                  },
                ];
                // 显示打印弹窗
                _showPrinterDialog(_buttonItemList);
              } else {
                // 消息提示
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.miss_param_unable_print);
              }
              // 赵士淞 - 终
            } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
              bloc.read<ExitInputBloc>().add(ClearInformation());
            } else if (buttonItemList[i]['index'] == Config.NUMBER_TWO) {
              bool flag = true;
              if (state.locationInformation.length == 0) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_form_title_1 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
              } else if (state.locationInformation[0]['ship_kbn'] != '2' &&
                  state.locationInformation[0]['ship_kbn'] != '3') {
                flag = false;
                WMSCommonBlocUtils.tipTextToast('状態が間違います');
              } else if (state.detailsCodeValue.isEmpty) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_form_title_5 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
              } else if (state.locationBarCode.isEmpty) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_form_title_11 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
              } else if (state.productBarCode.isEmpty) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_form_title_12 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
              } else if (state.productCount == 0) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_form_title_13 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
              } else if (state.shopBarcode.isEmpty) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_form_title_14 +
                        WMSLocalizations.i18n(context)!.can_not_null_text);
              } else if (state.allocationNumberValue != state.productCount &&
                  state.allocationNumberValue != 0 &&
                  state.productCount != 0) {
                flag = false;
                WMSCommonBlocUtils.tipTextToast(
                    WMSLocalizations.i18n(context)!.exit_input_text_1);
              }
              if (flag) {
                bloc.read<ExitInputBloc>().add(updateTableDetails(
                    bloc, state.shopBarcode, state.dtbPickListId));
              }
            } else {
              print('');
            }
          },
          child: Container(
            height: 36,
            padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
            margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 167, 176, 1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              buttonItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(255, 255, 255, 1),
                height: 1.28,
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_issue,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      {
        'index': Config.NUMBER_TWO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_execute,
      },
    ];

    return BlocBuilder<ExitInputBloc, ExitInputModel>(builder: (bloc, state) {
      return Row(
        children: _initFormButton(_buttonItemList, bloc, state),
      );
    });
  }
}
