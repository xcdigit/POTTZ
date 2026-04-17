// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_bloc.dart';
import 'package:wms/page/biz/store/transfer_inquiry/bloc/inventory_transfer_inquiry_model.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/utils/check_utils.dart';

/**
 * content：在庫移動照会-检索
 * author：张博睿
 * date：2023/08/28
 */
// 全局主键-下拉共通
GlobalKey<WMSDropdownWidgetState> _dropdownWidgetKey1 = new GlobalKey();
GlobalKey<WMSDropdownWidgetState> _dropdownWidgetKey2 = new GlobalKey();

class InventoryTransferInquirySearch extends StatefulWidget {
  // 检索按钮
  final ValueChanged<bool> onValueChanged;
  final ValueChanged<bool> onbottomChanged;
  final Function() onSearchValue;
  const InventoryTransferInquirySearch(
      {super.key,
      required this.onValueChanged,
      required this.onSearchValue,
      required this.onbottomChanged});

  @override
  State<InventoryTransferInquirySearch> createState() =>
      _InventoryTransferInquirySearchState();
}

class _InventoryTransferInquirySearchState
    extends State<InventoryTransferInquirySearch> {
  bool flag = false;
  // 检索
  bool valueFromChild = false;

  bool _hover = false;
  // 悬停追踪
  void updateStop(bool stop) {
    setState(() {
      _hover = stop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 48,
                      child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            updateStop(true); // 鼠标进入，按钮悬停状态为 true
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            updateStop(false); // 鼠标离开，按钮悬停状态为 false
                          });
                        },
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(
                              () {
                                flag = !flag; // 更新按钮状态为按下
                                widget.onValueChanged(flag);
                                valueFromChild = false;
                              },
                            );
                          },
                          icon: ColorFiltered(
                            colorFilter: flag
                                ? ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn)
                                : _hover
                                    ? ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn)
                                    : ColorFilter.mode(
                                        Color.fromRGBO(0, 122, 255, 1),
                                        BlendMode.srcIn),
                            child: Image.asset(WMSICons.WAREHOUSE_MENU_ICON,
                                height: 24),
                          ),
                          label: Text(
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_9,
                            style: TextStyle(
                                color: flag
                                    ? Colors.white
                                    : _hover
                                        ? Colors.white
                                        : Color.fromRGBO(0, 122, 255, 1),
                                fontSize: 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: flag
                                ? Color.fromRGBO(0, 122, 255, 1)
                                : _hover
                                    ? Color.fromRGBO(0, 122, 255, .6)
                                    : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: flag,
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 500,
                      ),
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.only(left: 31, right: 32),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color.fromRGBO(245, 245, 245, 89),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            // 检索条件小框
                            constraints: BoxConstraints(
                              minHeight: 50,
                            ),
                            margin: EdgeInsets.only(top: 30),
                            padding: EdgeInsets.only(left: 20, top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.0,
                              ),
                            ),
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: 10, bottom: 8),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      height: 35,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            WMSLocalizations.i18n(context)!
                                                .transfer_inquiry_note_1,
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    0, 122, 255, 1)),
                                          ),
                                        ],
                                      )),
                                  SizedBox(width: 20),
                                  Visibility(
                                    visible: state.productCode != '',
                                    child: buildCondition(
                                        WMSLocalizations.i18n(context)!
                                            .transfer_inquiry_note_2,
                                        state.productCode),
                                  ),
                                  Visibility(
                                    visible: state.productName != '',
                                    child: buildCondition(
                                        WMSLocalizations.i18n(context)!
                                            .transfer_inquiry_note_3,
                                        state.productName),
                                  ),
                                  Visibility(
                                    visible: state.queryFromLocCode != '',
                                    child: buildCondition(
                                        WMSLocalizations.i18n(context)!
                                            .transfer_inquiry_note_4,
                                        state.queryFromLocCode),
                                  ),
                                  Visibility(
                                    visible: state.queryToLocCode != '',
                                    child: buildCondition(
                                        WMSLocalizations.i18n(context)!
                                            .transfer_inquiry_note_5,
                                        state.queryToLocCode),
                                  ),
                                  Visibility(
                                    visible: state.adjustDate != '',
                                    child: buildCondition(
                                        WMSLocalizations.i18n(context)!
                                            .transfer_inquiry_note_6,
                                        state.adjustDate),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 检索条件主体内容
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            child: Container(
                              height: 300,
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5),
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .transfer_inquiry_note_2),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: WMSInputboxWidget(
                                                      text: state.productCode,
                                                      inputBoxCallBack:
                                                          (value) {
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(
                                                                SetProductCodeEvent(
                                                                    value));
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5),
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .transfer_inquiry_note_3),
                                              ),
                                              Column(
                                                children: [
                                                  WMSInputboxWidget(
                                                    text: state.productName,
                                                    inputBoxCallBack: (value) {
                                                      context
                                                          .read<
                                                              InventoryTransferInquiryBloc>()
                                                          .add(
                                                              SetProductNameEvent(
                                                                  value));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5),
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .transfer_inquiry_note_4),
                                              ),
                                              Column(
                                                children: [
                                                  WMSDropdownWidget(
                                                    dropdownTitle: 'loc_cd',
                                                    inputInitialValue: state
                                                        .locationBefore.loc_cd
                                                        .toString(),
                                                    dataList1: state
                                                        .moveBeforeLocationList,
                                                    key: _dropdownWidgetKey1,
                                                    inputRadius: 4,
                                                    inputSuffixIcon: Container(
                                                      width: 24,
                                                      height: 24,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 16, 0),
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                      ),
                                                    ),
                                                    inputBackgroundColor:
                                                        Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                    selectedCallBack: (value) {
                                                      if (value != '') {
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(SetTransferInquiryEvent(
                                                                "id",
                                                                value['id']
                                                                    .toString(),
                                                                "Before"));
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(SetTransferInquiryEvent(
                                                                "loc_cd",
                                                                value['loc_cd']
                                                                    .toString(),
                                                                "Before"));
                                                      } else {
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(
                                                                SetTransferInquiryEvent(
                                                                    "loc_cd",
                                                                    '',
                                                                    "Before"));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5),
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .transfer_inquiry_note_5),
                                              ),
                                              Column(
                                                children: [
                                                  WMSDropdownWidget(
                                                    inputInitialValue: state
                                                        .locationAfter.loc_cd
                                                        .toString(),
                                                    dropdownTitle: 'loc_cd',
                                                    dataList1: state
                                                        .moveBeforeLocationList,
                                                    key: _dropdownWidgetKey2,
                                                    inputRadius: 4,
                                                    inputSuffixIcon: Container(
                                                      width: 24,
                                                      height: 24,
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 16, 0),
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                      ),
                                                    ),
                                                    inputBackgroundColor:
                                                        Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                    selectedCallBack: (value) {
                                                      if (value != '') {
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(SetTransferInquiryEvent(
                                                                "id",
                                                                value['id']
                                                                    .toString(),
                                                                "After"));
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(SetTransferInquiryEvent(
                                                                "loc_cd",
                                                                value['loc_cd']
                                                                    .toString(),
                                                                "After"));
                                                      } else {
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(
                                                                SetTransferInquiryEvent(
                                                                    "loc_cd",
                                                                    '',
                                                                    "After"));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5),
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .transfer_inquiry_note_6),
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: WMSDateWidget(
                                                      text: state.adjustDate,
                                                      dateCallBack: (value) {
                                                        context
                                                            .read<
                                                                InventoryTransferInquiryBloc>()
                                                            .add(
                                                                SetMoveDateEvent(
                                                                    value));
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .transfer_inquiry_note_7,
                                  0),
                              SizedBox(width: 32),
                              BuildButtom(
                                  WMSLocalizations.i18n(context)!
                                      .transfer_inquiry_note_8,
                                  1),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ), // 删除检索窗口按钮
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.translate(
                        offset: Offset(-10, 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              flag = false;
                              widget.onValueChanged(flag);
                            });
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 167, 176, 1),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black12, width: 0.5),
                            ),
                            child: Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 底部检索和解除按钮
  BlocBuilder<InventoryTransferInquiryBloc, InventoryTransferInquiryModel>
      BuildButtom(String text, int number) {
    bool _hover = false;
    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(builder: (bloc, state) {
      return StatefulBuilder(builder: (context, setState) {
        return MouseRegion(
          onEnter: (event) {
            setState(() {
              _hover = true;
            });
          },
          onExit: (event) {
            setState(() {
              _hover = false;
            });
          },
          child: Container(
            height: 48,
            width: 220,
            color: _hover ? Color.fromRGBO(44, 167, 176, .6) : Colors.white,
            child: OutlinedButton(
              onPressed: () {
                if (number == 0) {
                  if (state.productCode != '' &&
                      CheckUtils.check_Half_Alphanumeric_6_50(
                          state.productCode)) {
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_2 +
                            WMSLocalizations.i18n(context)!
                                .input_must_six_number_check);
                    return;
                  }
                  setState(() {
                    flag = false;
                  });
                } else {
                  // 检索条件 商品コード
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetProductCodeEvent(''));
                  // 检索条件 商品名
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetProductNameEvent(''));
                  // 检索条件 移動元ロケーション
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetTransferInquiryEvent("id", '', "Before"));
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetTransferInquiryEvent("loc_cd", '', "Before"));
                  // 检索条件 移動先ロケーション
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetTransferInquiryEvent("id", '', "After"));
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetTransferInquiryEvent("loc_cd", '', "After"));
                  // 检索条件 移動日付
                  bloc
                      .read<InventoryTransferInquiryBloc>()
                      .add(SetMoveDateEvent(''));
                  flag = false;
                }
                // 检索条件value集合
                widget.onSearchValue();
                widget.onValueChanged(flag);
              },
              child: Text(
                text,
                style: TextStyle(
                  color:
                      _hover ? Colors.white : Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                side: MaterialStateProperty.all(
                  BorderSide(
                    width: 1,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  //检索条件内部数据
  BlocBuilder<InventoryTransferInquiryBloc, InventoryTransferInquiryModel>
      buildCondition(String queryLabel, String queryValue) {
    return BlocBuilder<InventoryTransferInquiryBloc,
        InventoryTransferInquiryModel>(builder: (bloc, state) {
      return Container(
        margin: EdgeInsets.only(right: 10, bottom: 8),
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 35,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.black12,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  child: Text(
                    queryLabel + ':' + queryValue,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(156, 156, 156, 1),
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    setState(
                      () {
                        if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_2) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetProductCodeEvent(''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_3) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetProductNameEvent(''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_4) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetTransferInquiryEvent("id", '', "Before"));
                          bloc.read<InventoryTransferInquiryBloc>().add(
                              SetTransferInquiryEvent("loc_cd", '', "Before"));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_5) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetTransferInquiryEvent("id", '', "After"));
                          bloc.read<InventoryTransferInquiryBloc>().add(
                              SetTransferInquiryEvent("loc_cd", '', "After"));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .transfer_inquiry_note_6) {
                          bloc
                              .read<InventoryTransferInquiryBloc>()
                              .add(SetMoveDateEvent(''));
                        }
                      },
                    );
                  },
                  child: Icon(
                    Icons.close,
                    color: Color.fromRGBO(156, 156, 156, 1),
                    size: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
