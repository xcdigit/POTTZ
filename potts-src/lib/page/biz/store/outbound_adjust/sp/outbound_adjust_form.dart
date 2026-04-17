// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_bloc.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../common/utils/check_utils.dart';

/**
 * 内容：在库调整入力
 * 作者：zhangbr
 * 时间：2023/11/29
 */
class OutboundAdjustForm extends StatefulWidget {
  int id;
  int pageFlag;
  OutboundAdjustForm({super.key, required this.id, required this.pageFlag});

  @override
  State<OutboundAdjustForm> createState() => _OutboundAdjustFormState();
}

class _OutboundAdjustFormState extends State<OutboundAdjustForm> {
  @override
  Widget build(BuildContext context) {
    int companyId =
        StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    int userId = StoreProvider.of<WMSState>(context).state.loginUser!.id!;
    //商品数据取出
    dynamic data = StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocProvider<OutboundAdjustBloc>(
      create: (context) {
        return OutboundAdjustBloc(
          OutboundAdjustModel(
              companyId: companyId,
              userId: userId,
              data: data,
              pageFlag: widget.pageFlag),
        );
      },
      child: BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
          builder: (bloc, state) {
        return Container(
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 40),
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
                                            .outbound_adjust_table_btn_1,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromRGBO(6, 14, 15, 1),
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
                                          height: 100,
                                          text: state.stock.toString(),
                                          readOnly: true,
                                          inputBoxCallBack: (value) {},
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              WMSLocalizations.i18n(context)!
                                                  .shipment_inspection_item),
                                        ),
                                      )
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
                                            .outbound_adjust_table_btn_2,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromRGBO(6, 14, 15, 1),
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
                                          height: 100,
                                          text: state.lockStock.toString(),
                                          readOnly: true,
                                          inputBoxCallBack: (value) {},
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              WMSLocalizations.i18n(context)!
                                                  .shipment_inspection_item),
                                        ),
                                      )
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
                                            .outbound_adjust_table_btn_3,
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
                                          height: 100,
                                          text: state.afterAdjustNumber
                                              .toString(),
                                          inputBoxCallBack: (value) {
                                            bloc.read<OutboundAdjustBloc>().add(
                                                SetAfterAdjustNumberEvent(
                                                    value, context));
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, 1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              WMSLocalizations.i18n(context)!
                                                  .shipment_inspection_item),
                                        ),
                                      )
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 24,
                                  child: Row(
                                    children: [
                                      Text(
                                        WMSLocalizations.i18n(context)!
                                            .outbound_adjust_table_btn_4,
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
                                  width: 600,
                                  height: 220,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                      borderRadius: BorderRadius.circular(2)),
                                  child: WMSInputboxWidget(
                                    height: 220,
                                    maxLines: 9,
                                    text: state.afterReason,
                                    inputBoxCallBack: (value) {
                                      state.afterReason = value;
                                      bloc
                                          .read<OutboundAdjustBloc>()
                                          .add(SetAfterReasonEvent(value));
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color.fromRGBO(44, 167, 176, 1),
                                    ), // 设置按钮背景颜色
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white), // 设置按钮文本颜色
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                      Size(120, 48),
                                    ), // 设置按钮宽度和高度
                                  ),
                                  child: Text(WMSLocalizations.i18n(context)!
                                      .outbound_adjust_form_button),
                                  onPressed: () async {
                                    if (state.afterAdjustNumber == '' ||
                                        state.afterReason == '') {
                                      if (state.afterAdjustNumber == '') {
                                        WMSCommonBlocUtils.tipTextToast(
                                            WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_table_btn_3 +
                                                WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_toast_2);
                                      } else if (state.afterReason == '') {
                                        WMSCommonBlocUtils.tipTextToast(
                                            WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_table_btn_4 +
                                                WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_toast_2);
                                      }
                                    } else if (CheckUtils
                                        .check_Half_Number_In_10(
                                            state.afterAdjustNumber)) {
                                      WMSCommonBlocUtils.tipTextToast(
                                          WMSLocalizations.i18n(context)!
                                                  .outbound_adjust_table_btn_3 +
                                              WMSLocalizations.i18n(context)!
                                                  .check_half_width_numbers_in_10);
                                    } else if (int.parse(
                                            state.afterAdjustNumber) ==
                                        state.stock) {
                                      WMSCommonBlocUtils.tipTextToast(
                                          WMSLocalizations.i18n(context)!
                                              .outbound_adjust_toast_3);
                                    } else if (int.parse(
                                            state.afterAdjustNumber) <
                                        state.lockStock) {
                                      WMSCommonBlocUtils.tipTextToast(
                                          WMSLocalizations.i18n(context)!
                                              .outbound_adjust_toast_4);
                                    } else {
                                      bool flag = await bloc
                                          .read<OutboundAdjustBloc>()
                                          .InsertStoreMoveData();
                                      if (flag) {
                                        // 插入操作履历 sys_log表
                                        CommonUtils().createLogInfo(
                                            '在庫調整入力' +
                                                Config.OPERATION_TEXT1 +
                                                Config.OPERATION_BUTTON_TEXT4 +
                                                Config.OPERATION_TEXT2,
                                            "InsertStoreMoveData()",
                                            StoreProvider.of<WMSState>(context)
                                                .state
                                                .loginUser!
                                                .company_id,
                                            StoreProvider.of<WMSState>(context)
                                                .state
                                                .loginUser!
                                                .id);
                                        bloc
                                            .read<OutboundAdjustBloc>()
                                            .add(SetMessageEvent());
                                        WMSCommonBlocUtils.tipTextToast(
                                            WMSLocalizations.i18n(context)!
                                                .outbound_adjust_toast_5);
                                        GoRouter.of(context)
                                            .pop('delete return');
                                      } else {
                                        WMSCommonBlocUtils.tipTextToast(
                                            WMSLocalizations.i18n(context)!
                                                .outbound_adjust_toast_1);
                                      }
                                    }
                                  },
                                ),
                              ],
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
        );
      }),
    );
  }
}
