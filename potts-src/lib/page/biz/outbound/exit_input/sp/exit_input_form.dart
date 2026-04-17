import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_bloc.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/page/home/bloc/home_menu_bloc.dart';
import 'package:wms/page/home/bloc/home_menu_model.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';
import 'package:wms/widget/wms_scan_widget.dart';

/**
 * 内容：入庫入力-表单-sp
 * 作者：張博睿
 * 时间：2023/11/02
 */

class ExitInputForm extends StatefulWidget {
  const ExitInputForm({super.key});

  @override
  State<ExitInputForm> createState() => _ExitInputFormState();
}

class _ExitInputFormState extends State<ExitInputForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExitInputBloc, ExitInputModel>(builder: (bloc, state) {
      return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
          builder: (menuBloc, menuState) {
        return Container(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 1.1,
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
                                  .exit_input_form_title_1,
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
                                              state.locationCodeValue,
                                              context));
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
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (builderContext) {
                                        return WMSScanWidget(
                                          scanCallBack: (value) {
                                            // 赋值
                                            state.locationCodeValue = value;
                                            // 查询
                                            bloc.read<ExitInputBloc>().add(
                                                QueryLocationinformation(
                                                    state.locationCodeValue,
                                                    context));
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
                widthFactor: 1.1,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .exit_input_form_title_2,
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
                        child: WMSInputboxWidget(
                          text: state.shipCodeValue.toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            state.shipCodeValue = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1.1,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .exit_input_form_title_3,
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
                        child: WMSInputboxWidget(
                          text: state.customerValue.toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            state.customerValue = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1.1,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .exit_input_form_title_4,
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
                        child: WMSInputboxWidget(
                          text: state.deliveryValue.toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            state.deliveryValue = value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.3,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // 设置按钮文本颜色
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(120, 48)), // 设置按钮宽度和高度
                    ),
                    child: Text(
                        WMSLocalizations.i18n(context)!.exit_input_button_1),
                    onPressed: () async {
                      if (state.locationCodeValue.isNotEmpty &&
                          state.shipCodeValue.isNotEmpty &&
                          state.customerValue.isNotEmpty &&
                          state.deliveryValue.isNotEmpty) {
                        // 跳转页面
                        // menuBloc.read<HomeMenuBloc>().add(PageJumpEvent('/' +
                        GoRouter.of(context).go('/' +
                            Config.PAGE_FLAG_3_12 +
                            '/' +
                            state.shipId.toString() +
                            '/details' +
                            '/' +
                            state.shipCodeValue +
                            '/' +
                            state.shipId.toString());
                      } else if (state.locationCodeValue.isNotEmpty &&
                          (state.shipCodeValue.isEmpty ||
                              state.customerValue.isEmpty ||
                              state.deliveryValue.isEmpty)) {
                        // 提示消息：正しいバーコードを入力をお願いします。
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .goods_receipt_input_toast_3);
                      } else {
                        // 提示消息：正しいバーコードを入力をお願いします。
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .goods_receipt_input_toast_1);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
