import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_bloc.dart';
import 'package:wms/page/biz/store/adjust_inquiry/bloc/inventory_adjust_inquiry_model.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/utils/check_utils.dart';

/**
 * content：在庫調整照会-检索
 * author：张博睿
 * date：2023/11/24
 */
// 全局主键-下拉共通
GlobalKey<WMSDropdownWidgetState> _dropdownWidgetKey1 = new GlobalKey();

class InventoryAdjustInquirySearch extends StatefulWidget {
  // 检索按钮
  final ValueChanged<bool> onValueChanged;
  final ValueChanged<bool> onbottomChanged;
  final Function() onSearchValue;
  const InventoryAdjustInquirySearch(
      {super.key,
      required this.onValueChanged,
      required this.onSearchValue,
      required this.onbottomChanged});

  @override
  State<InventoryAdjustInquirySearch> createState() =>
      _InventoryAdjustInquirySearchState();
}

class _InventoryAdjustInquirySearchState
    extends State<InventoryAdjustInquirySearch> {
  // 检索条件
  List<String> conditionLabelList = [];
  // 下拉框value值列表
  List<String> conditionValueList = [];
  bool flag = false;
  // 检索
  bool valueFromChild = false;

  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>(
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
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
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
                        // 检索条件小框
                        Container(
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
                                  margin: EdgeInsets.only(right: 10, bottom: 8),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  height: 35,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        WMSLocalizations.i18n(context)!
                                            .adjust_inquiry_note_1,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 122, 255, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Visibility(
                                  visible: state.productCode != '',
                                  child: buildCondition(
                                      WMSLocalizations.i18n(context)!
                                          .adjust_inquiry_note_2,
                                      state.productCode),
                                ),
                                Visibility(
                                  visible: state.productName != '',
                                  child: buildCondition(
                                      WMSLocalizations.i18n(context)!
                                          .adjust_inquiry_note_3,
                                      state.productName),
                                ),
                                Visibility(
                                  visible: state.queryLocCode != '',
                                  child: buildCondition(
                                      WMSLocalizations.i18n(context)!
                                          .adjust_inquiry_note_4,
                                      state.queryLocCode),
                                ),
                                Visibility(
                                  visible: state.adjustDate != '',
                                  child: buildCondition(
                                      WMSLocalizations.i18n(context)!
                                          .adjust_inquiry_note_5,
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
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                //商品コード
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .adjust_inquiry_note_2,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Color.fromRGBO(6, 14, 15, 1),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 48,
                                          child: WMSInputboxWidget(
                                            text: state.productCode,
                                            inputBoxCallBack: (value) {
                                              context
                                                  .read<
                                                      InventoryAdjustInquiryBloc>()
                                                  .add(SetProductCodeEvent(
                                                      value));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //商品コード
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .adjust_inquiry_note_3,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Color.fromRGBO(6, 14, 15, 1),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 48,
                                          child: WMSInputboxWidget(
                                            text: state.productName,
                                            inputBoxCallBack: (value) {
                                              context
                                                  .read<
                                                      InventoryAdjustInquiryBloc>()
                                                  .add(SetProductNameEvent(
                                                      value));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //商品コード
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .adjust_inquiry_note_4,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Color.fromRGBO(6, 14, 15, 1),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 48,
                                          child: WMSDropdownWidget(
                                            dropdownTitle: 'loc_cd',
                                            inputInitialValue: state
                                                .locationBefore.loc_cd
                                                .toString(),
                                            dataList1:
                                                state.moveBeforeLocationList,
                                            key: _dropdownWidgetKey1,
                                            inputRadius: 4,
                                            inputSuffixIcon: Container(
                                              width: 24,
                                              height: 24,
                                              margin: EdgeInsets.fromLTRB(
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
                                              context
                                                  .read<
                                                      InventoryAdjustInquiryBloc>()
                                                  .add(SetAdjustInquiryEvent(
                                                      "id",
                                                      value['id'].toString()));
                                              context
                                                  .read<
                                                      InventoryAdjustInquiryBloc>()
                                                  .add(SetAdjustInquiryEvent(
                                                      "loc_cd",
                                                      value['loc_cd']
                                                          .toString()));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //商品コード
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 24,
                                          child: Text(
                                            WMSLocalizations.i18n(context)!
                                                .adjust_inquiry_note_5,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color:
                                                  Color.fromRGBO(6, 14, 15, 1),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 48,
                                          child: WMSDateWidget(
                                            text: state.adjustDate,
                                            dateCallBack: (value) {
                                              context
                                                  .read<
                                                      InventoryAdjustInquiryBloc>()
                                                  .add(SetMoveDateEvent(value));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 底部检索和解除按钮
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                            height: 116,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .adjust_inquiry_note_7,
                                    1),
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .adjust_inquiry_note_6,
                                    0),
                              ],
                            ),
                          ),
                        ),
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
                          child:
                              Icon(Icons.close, size: 14, color: Colors.white),
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
    });
  }

  // 底部检索和解除按钮
  BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>
      BuildButtom(String text, int number) {
    return BlocBuilder(builder: (bloc, state) {
      return StatefulBuilder(builder: (context, setState) {
        return MouseRegion(
          child: Container(
            height: 48,
            width: 224,
            child: OutlinedButton(
              onPressed: () {
                if (number == 0) {
                  if (state.productCode != '' &&
                      CheckUtils.check_Half_Alphanumeric_6_50(
                          state.productCode)) {
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!.adjust_inquiry_note_2 +
                            WMSLocalizations.i18n(context)!
                                .input_must_six_number_check);
                    return;
                  }
                  setState(() {
                    flag = false;
                  });
                } else {
                  // 检索条件 商品ID
                  context
                      .read<InventoryAdjustInquiryBloc>()
                      .add(SetProductCodeEvent(''));
                  // 检索条件 商品名
                  context
                      .read<InventoryAdjustInquiryBloc>()
                      .add(SetProductNameEvent(''));
                  // 检索条件 ロケーション
                  context
                      .read<InventoryAdjustInquiryBloc>()
                      .add(SetAdjustInquiryEvent('id', ''));
                  context
                      .read<InventoryAdjustInquiryBloc>()
                      .add(SetAdjustInquiryEvent('loc_cd', ''));
                  // 检索条件 調整日付
                  context
                      .read<InventoryAdjustInquiryBloc>()
                      .add(SetMoveDateEvent(''));
                  conditionLabelList.clear();
                  conditionValueList.clear();
                  flag = false;
                }
                // 检索条件value集合
                widget.onSearchValue();
                widget.onValueChanged(flag);
              },
              child: Text(
                text,
                style: TextStyle(
                  color: number == 0
                      ? Colors.white
                      : Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(number == 0
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : Colors.white), // 设置背景颜色
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
  BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>
      buildCondition(String queryLabel, String queryValue) {
    return BlocBuilder<InventoryAdjustInquiryBloc, InventoryAdjustInquiryModel>(
        builder: (bloc, state) {
      return Container(
        margin: EdgeInsets.only(right: 10, bottom: 8),
        padding: EdgeInsets.only(left: 10, right: 10),
        constraints: BoxConstraints(minHeight: 35),
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
                                .adjust_inquiry_note_2) {
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetProductCodeEvent(''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_3) {
                          context
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetProductNameEvent(''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_4) {
                          bloc
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetAdjustInquiryEvent("id", ''));
                          bloc
                              .read<InventoryAdjustInquiryBloc>()
                              .add(SetAdjustInquiryEvent("loc_cd", ''));
                        } else if (queryLabel ==
                            WMSLocalizations.i18n(context)!
                                .adjust_inquiry_note_5) {
                          context
                              .read<InventoryAdjustInquiryBloc>()
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
