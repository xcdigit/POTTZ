import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../common/utils/check_utils.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_scan_widget.dart';
import '../../../../home/bloc/home_menu_bloc.dart';
import '../../../../home/bloc/home_menu_model.dart';
import '../bloc/incoming_inspection_bloc.dart';
import '../bloc/incoming_inspection_model.dart';

/**
 * 内容：入荷検品-文件
 * 作者：熊草云
 * 时间：2023/10/13
 */
class IncomingInspectionForm extends StatefulWidget {
  const IncomingInspectionForm({super.key});

  @override
  State<IncomingInspectionForm> createState() => _IncomingInspectionFormState();
}

class _IncomingInspectionFormState extends State<IncomingInspectionForm> {
  // 检品弹窗
  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
      builder: (menuBloc, menuState) {
        return BlocBuilder<IncomingInspectionBloc, IncomingInspectionModel>(
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                      .incoming_inspection_expected_barcode,
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
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
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
                                    text: state.qrCode1,
                                    inputBoxCallBack: (value) {
                                      context
                                          .read<IncomingInspectionBloc>()
                                          .add(QueryArrivalNumberEvent(
                                              value.trim()));
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
                                                context
                                                    .read<
                                                        IncomingInspectionBloc>()
                                                    .add(
                                                        QueryArrivalNumberEvent(
                                                            value.trim()));
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
                    widthFactor: 1,
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
                                  .incoming_inspection_expected_id,
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
                              readOnly: true,
                              text: state.receive_no,
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
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .incoming_inspection_supplier,
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
                              readOnly: true,
                              text: state.receive_name,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(44, 167, 176, 1)), // 设置按钮背景颜色
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // 设置按钮文本颜色
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(120, 40)), // 设置按钮宽度和高度
                      ),
                      child: Text(WMSLocalizations.i18n(context)!
                          .shipment_inspection_inspection),
                      onPressed: () {
                        setState(
                          () {
                            if (CheckUtils.check_Half_Alphanumeric_Symbol(
                                state.qrCode1)) {
                              WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                          .i18n(context)!
                                      .incoming_inspection_expected_barcode +
                                  WMSLocalizations.i18n(context)!
                                      .check_half_width_alphanumeric_with_symbol);
                            } else if (state.receive['datalength'] != 0 &&
                                state.receive['datalength'] != null) {
                              menuBloc.read<HomeMenuBloc>().add(PageJumpEvent(
                                  '/' +
                                      Config.PAGE_FLAG_2_4 +
                                      '/details' +
                                      '/' +
                                      state.receive['id'].toString() +
                                      '/' +
                                      state.qrCode1.toString()));
                            } else {
                              WMSCommonBlocUtils.tipTextToast(WMSLocalizations
                                          .i18n(context)!
                                      .incoming_inspection_expected_barcode +
                                  WMSLocalizations.i18n(context)!
                                      .can_not_null_text);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
