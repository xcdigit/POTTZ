import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/inquiry_schedule_bloc.dart';
import '../bloc/inquiry_schedule_model.dart';

/**
 * 内容：入荷予定照会-搜索
 * 作者：熊草云
 * 时间：2023/10/16
 */
class InquiryScheduleSearch extends StatefulWidget {
  const InquiryScheduleSearch({super.key});

  @override
  State<InquiryScheduleSearch> createState() => _InquiryScheduleSearchState();
}

class _InquiryScheduleSearchState extends State<InquiryScheduleSearch> {
  // 当前悬停标记
  bool _currentHoverFlag = false;

  // 构建检索单项
  Widget _buildQueryItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text +
                '：' +
                (index == 7
                    ? (value == '1'
                        ? WMSLocalizations.i18n(context)!.inventory_output_7
                        : value == '2'
                            ? WMSLocalizations.i18n(context)!.inventory_output_6
                            : '')
                    : index == 8
                        ? (value == '1'
                            ? WMSLocalizations.i18n(context)!
                                .importerror_flg_query_1
                            : value == '2'
                                ? WMSLocalizations.i18n(context)!
                                    .importerror_flg_query_2
                                : '')
                        : value),
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // 判断下标
              if (index == 1) {
                // 保存检索：入荷予定番号事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryReceiveNoEvent(''));
              } else if (index == 2) {
                // 保存检索：仕入先注文番号事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryOrderNoEvent(''));
              } else if (index == 3) {
                // 保存检索：仕入先事件
                context.read<InquiryScheduleBloc>().add(SaveQueryNameEvent(''));
              } else if (index == 4) {
                // 保存检索：商品名事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryProductNameEvent(''));
              } else if (index == 5) {
                // 保存检索：入荷予定起始日事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryRcvSchDateStartEvent(''));
              } else if (index == 6) {
                // 保存检索：入荷予定终了日事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryRcvSchDateEndEvent(''));
              } else if (index == 7) {
                // 保存检索：連携状態事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryCsvKbnEvent(''));
              } else if (index == 8) {
                // 保存检索：取込状態事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveQueryImporterrorFlgEvent(''));
              }
            },
            child: Icon(
              Icons.close,
              color: Color.fromRGBO(156, 156, 156, 1),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 构建查询单项
  Widget _buildSearchItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text +
                '：' +
                (index == 7
                    ? (value == '1'
                        ? WMSLocalizations.i18n(context)!.inventory_output_7
                        : value == '2'
                            ? WMSLocalizations.i18n(context)!.inventory_output_6
                            : '')
                    : index == 8
                        ? (value == '1'
                            ? WMSLocalizations.i18n(context)!
                                .importerror_flg_query_1
                            : value == '2'
                                ? WMSLocalizations.i18n(context)!
                                    .importerror_flg_query_2
                                : '')
                        : value),
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // 判断下标
              if (index == 1) {
                // 保存查询：入荷予定番号事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchReceiveNoEvent(''));
              } else if (index == 2) {
                // 保存查询：仕入先注文番号事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchOrderNoEvent(''));
              } else if (index == 3) {
                // 保存查询：仕入先事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchNameEvent(''));
              } else if (index == 4) {
                // 保存查询：商品名事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchProductNameEvent(''));
              } else if (index == 5) {
                // 保存查询：入荷予定起始日事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchRcvSchDateStartEvent(''));
              } else if (index == 6) {
                // 保存查询：入荷予定终了日事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchRcvSchDateEndEvent(''));
              } else if (index == 7) {
                // 保存查询：連携状態事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchCsvKbnEvent(''));
              } else if (index == 8) {
                // 保存查询：取込状態事件
                context
                    .read<InquiryScheduleBloc>()
                    .add(SaveSearchImporterrorFlgEvent(''));
              }
            },
            child: Icon(
              Icons.close,
              color: Color.fromRGBO(156, 156, 156, 1),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 构建文本
  _buildText(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 构建按钮
  _buildButtom(String text, int index) {
    return Container(
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () {
          // 判断按钮
          if (index == 0) {
            bool checkFlg = context
                .read<InquiryScheduleBloc>()
                .selectBeforeCheck(
                    context,
                    context.read<InquiryScheduleBloc>().state.searchReceiveNo,
                    context.read<InquiryScheduleBloc>().state.searchOrderNo);
            if (checkFlg) {
              // 搜索按钮事件
              context.read<InquiryScheduleBloc>().add(SearchButtonEvent());
            }
          } else if (index == 1) {
            // 重置按钮事件
            context.read<InquiryScheduleBloc>().add(ResetButtonEvent());
          } else {}
        },
        child: Text(
          text,
          style: TextStyle(
            color: index == 0 ? Colors.white : Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            Colors.black,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(index == 0
              ? Color.fromRGBO(44, 167, 176, 1)
              : Colors.white), // 设置背景颜色
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 1,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }

  // 构建連携状態复选框
  _buildCsvKbnCheckBox(String text, String index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1,
            child: Checkbox(
              fillColor: MaterialStateColor.resolveWith(
                (states) => Color.fromRGBO(44, 167, 176, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: context.read<InquiryScheduleBloc>().state.searchCsvKbn ==
                  index,
              onChanged: (value) {
                // 判断数值
                if (value == true) {
                  // 保存查询：連携状態事件
                  context
                      .read<InquiryScheduleBloc>()
                      .add(SaveSearchCsvKbnEvent(index));
                }
              },
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  // 构建取込状態复选框
  _buildImporterrorFlgCheckBox(String text, String index) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1,
            child: Checkbox(
              visualDensity: VisualDensity.compact, // 删除内外边距
              fillColor: MaterialStateColor.resolveWith(
                (states) => Color.fromRGBO(44, 167, 176, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: context
                      .read<InquiryScheduleBloc>()
                      .state
                      .searchImporterrorFlg ==
                  index,
              onChanged: (value) {
                // 判断数值
                if (value == true) {
                  // 保存检索：取込状態事件
                  context
                      .read<InquiryScheduleBloc>()
                      .add(SaveSearchImporterrorFlgEvent(index));
                }
              },
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  // 初始化检索列表
  List<Widget> _initSearchList(InquiryScheduleModel state) {
    return [
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          constraints: BoxConstraints(
            minHeight: 48,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
              width: 1.0,
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                  padding: EdgeInsets.fromLTRB(0, 6, 10, 6),
                  height: 34,
                  child: Text(
                    WMSLocalizations.i18n(context)!.delivery_note_11,
                    style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                  ),
                ),
              ),
              Visibility(
                visible: state.searchReceiveNo != '',
                child: _buildSearchItem(
                    1,
                    WMSLocalizations.i18n(context)!.menu_content_2_5_6,
                    state.searchReceiveNo),
              ),
              Visibility(
                visible: state.searchOrderNo != '',
                child: _buildSearchItem(
                    2,
                    WMSLocalizations.i18n(context)!.menu_content_2_5_7,
                    state.searchOrderNo),
              ),
              Visibility(
                visible: state.searchName != '',
                child: _buildSearchItem(
                    3,
                    WMSLocalizations.i18n(context)!.menu_content_2_5_5,
                    state.searchName),
              ),
              Visibility(
                visible: state.searchProductName != '',
                child: _buildSearchItem(
                    4,
                    WMSLocalizations.i18n(context)!.delivery_note_20,
                    state.searchProductName),
              ),
              Visibility(
                visible: state.searchRcvSchDateStart != '',
                child: _buildSearchItem(
                    5,
                    WMSLocalizations.i18n(context)!.home_main_page_table_text1,
                    state.searchRcvSchDateStart),
              ),
              Visibility(
                visible: state.searchRcvSchDateEnd != '',
                child: _buildSearchItem(
                    6,
                    WMSLocalizations.i18n(context)!.home_main_page_table_text1,
                    state.searchRcvSchDateEnd),
              ),
              Visibility(
                visible: state.searchCsvKbn != '',
                child: _buildSearchItem(
                    7,
                    WMSLocalizations.i18n(context)!.inventory_output_5,
                    state.searchCsvKbn),
              ),
              Visibility(
                visible: state.searchImporterrorFlg != '',
                child: _buildSearchItem(
                    8,
                    WMSLocalizations.i18n(context)!
                        .display_instruction_ingestion_state,
                    state.searchImporterrorFlg),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.menu_content_2_5_6),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchReceiveNo,
                  inputBoxCallBack: (value) {
                    // 保存查询：入荷予定番号事件
                    context
                        .read<InquiryScheduleBloc>()
                        .add(SaveSearchReceiveNoEvent(value));
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
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.menu_content_2_5_7),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchOrderNo,
                  inputBoxCallBack: (value) {
                    // 保存查询：仕入先注文番号事件
                    context
                        .read<InquiryScheduleBloc>()
                        .add(SaveSearchOrderNoEvent(value));
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
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.menu_content_2_5_5),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSDropdownWidget(
                  saveInput: true,
                  dataList1: state.supplierList,
                  inputInitialValue: state.searchName,
                  inputRadius: 4,
                  inputSuffixIcon: Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  dropdownRadius: 4,
                  dropdownTitle: 'name',
                  selectedCallBack: (value) {
                    // 判断数值
                    if (value is String) {
                      // 保存查询：仕入先事件
                      context
                          .read<InquiryScheduleBloc>()
                          .add(SaveSearchNameEvent(value));
                    } else {
                      // 保存查询：仕入先事件
                      context
                          .read<InquiryScheduleBloc>()
                          .add(SaveSearchNameEvent(value['name']));
                    }
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
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.delivery_note_20),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSDropdownWidget(
                  saveInput: true,
                  dataList1: state.productList,
                  inputInitialValue: state.searchProductName,
                  inputRadius: 4,
                  inputSuffixIcon: Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  dropdownRadius: 4,
                  dropdownTitle: 'name',
                  selectedCallBack: (value) {
                    // 判断数值
                    if (value is String) {
                      // 保存查询：商品名事件
                      context
                          .read<InquiryScheduleBloc>()
                          .add(SaveSearchProductNameEvent(value));
                    } else {
                      // 保存查询：商品名事件
                      context
                          .read<InquiryScheduleBloc>()
                          .add(SaveSearchProductNameEvent(value['name']));
                    }
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
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(
                  WMSLocalizations.i18n(context)!.home_main_page_table_text1),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: WMSDateWidget(
                          text: state.searchRcvSchDateStart,
                          dateCallBack: (value) {
                            // 保存查询：入荷予定起始日事件
                            context
                                .read<InquiryScheduleBloc>()
                                .add(SaveSearchRcvSchDateStartEvent(value));
                          },
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.1,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .instruction_input_form_from,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: SizedBox(height: 16),
                      ),
                      FractionallySizedBox(
                        widthFactor: .9,
                        child: WMSDateWidget(
                          text: state.searchRcvSchDateEnd,
                          dateCallBack: (value) {
                            // 保存查询：入荷予定终了日事件
                            context
                                .read<InquiryScheduleBloc>()
                                .add(SaveSearchRcvSchDateEndEvent(value));
                          },
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.1,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .delivery_note_delivery_until,
                          textAlign: TextAlign.center,
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
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.inventory_output_5),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 16),
                height: 48,
                constraints: BoxConstraints(
                  maxHeight: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCsvKbnCheckBox(
                        WMSLocalizations.i18n(context)!.delivery_note_22, ''),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 16,
                ),
                height: 48,
                constraints: BoxConstraints(
                  maxHeight: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCsvKbnCheckBox(
                        WMSLocalizations.i18n(context)!.inventory_output_7,
                        '1'),
                  ],
                ),
              ),
              Container(
                height: 48,
                constraints: BoxConstraints(
                  maxHeight: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCsvKbnCheckBox(
                        WMSLocalizations.i18n(context)!.inventory_output_6,
                        '2'),
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
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!
                  .display_instruction_ingestion_state),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 16),
                height: 48,
                constraints: BoxConstraints(
                  maxHeight: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildImporterrorFlgCheckBox(
                        WMSLocalizations.i18n(context)!.delivery_note_22, ''),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 16,
                ),
                height: 48,
                constraints: BoxConstraints(
                  maxHeight: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildImporterrorFlgCheckBox(
                        WMSLocalizations.i18n(context)!.importerror_flg_query_1,
                        '1'),
                  ],
                ),
              ),
              Container(
                height: 48,
                constraints: BoxConstraints(
                  maxHeight: 48,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildImporterrorFlgCheckBox(
                        WMSLocalizations.i18n(context)!.importerror_flg_query_2,
                        '2'),
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
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 解除按钮
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_25,
                1,
              ),
              SizedBox(
                height: 20,
              ),
              // 检索按钮
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_24,
                0,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // 检索按钮
  _searchButton(InquiryScheduleModel state) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 48,
            child: MouseRegion(
              onEnter: (event) {
                // 状态变更
                setState(() {
                  // 当前悬停标记
                  _currentHoverFlag = true;
                });
              },
              onExit: (event) {
                // 状态变更
                setState(() {
                  // 当前悬停标记
                  _currentHoverFlag = false;
                });
              },
              child: OutlinedButton.icon(
                onPressed: () {
                  // 保存检索按钮标记事件
                  context
                      .read<InquiryScheduleBloc>()
                      .add(SaveQueryButtonFlag(!state.queryButtonFlag));
                  // 状态变更
                  setState(() {
                    // 当前悬停标记
                    _currentHoverFlag = false;
                  });
                },
                icon: ColorFiltered(
                  colorFilter: state.queryButtonFlag
                      ? ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )
                      : _currentHoverFlag
                          ? ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : ColorFilter.mode(
                              Color.fromRGBO(0, 122, 255, 1),
                              BlendMode.srcIn,
                            ),
                  child: Image.asset(
                    WMSICons.WAREHOUSE_MENU_ICON,
                    height: 18,
                  ),
                ),
                label: Container(),
                style: OutlinedButton.styleFrom(
                  backgroundColor: state.queryButtonFlag
                      ? Color.fromRGBO(0, 122, 255, 1)
                      : _currentHoverFlag
                          ? Color.fromRGBO(0, 122, 255, .6)
                          : Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              // width: 280,
              height: 48,
              padding: EdgeInsets.only(
                left: 16,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    WMSICons.WAREHOUSE_SEARCH_ICON,
                    height: 16,
                    width: 16,
                  ),
                  Expanded(
                    child: WMSInputboxWidget(
                      text: state.queryInputContent,
                      height: 48,
                      borderColor: Colors.transparent,
                      hintFontColor: Color.fromRGBO(0, 122, 255, 1),
                      hintText: WMSLocalizations.i18n(context)!.delivery_note_2,
                      inputBoxCallBack: (value) {
                        // 搜索输入框变更事件
                        context
                            .read<InquiryScheduleBloc>()
                            .add(SearchInputChangeEvent(value));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InquiryScheduleBloc, InquiryScheduleModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 检索按钮
            _searchButton(state),
            // 检索详情
            Visibility(
              visible: state.queryButtonFlag,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        width: 1.0,
                      ),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        children: _initSearchList(state),
                      ),
                    ),
                  ),
                  // 关闭检索窗口按钮
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(-10, 20),
                      child: InkWell(
                        onTap: () {
                          // 保存检索按钮标记事件
                          context
                              .read<InquiryScheduleBloc>()
                              .add(SaveQueryButtonFlag(false));
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(44, 167, 176, 1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 检索详情
            Visibility(
              visible: state.queryReceiveNo != '' ||
                  state.queryRcvSchDateStart != '' ||
                  state.queryRcvSchDateEnd != '' ||
                  state.queryOrderNo != '' ||
                  state.queryName != '' ||
                  state.queryProductName != '' ||
                  state.queryCsvKbn != '' ||
                  state.queryImporterrorFlg != '',
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  constraints: BoxConstraints(
                    minHeight: 48,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      width: 1.0,
                    ),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                          // padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                          height: 34,
                          child: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_11,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 122, 255, 1)),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.queryReceiveNo != '',
                        child: _buildQueryItem(
                            1,
                            WMSLocalizations.i18n(context)!.menu_content_2_5_6,
                            state.queryReceiveNo),
                      ),
                      Visibility(
                        visible: state.queryOrderNo != '',
                        child: _buildQueryItem(
                            2,
                            WMSLocalizations.i18n(context)!.menu_content_2_5_7,
                            state.queryOrderNo),
                      ),
                      Visibility(
                        visible: state.queryName != '',
                        child: _buildQueryItem(
                            3,
                            WMSLocalizations.i18n(context)!.menu_content_2_5_5,
                            state.queryName),
                      ),
                      Visibility(
                        visible: state.queryProductName != '',
                        child: _buildQueryItem(
                            4,
                            WMSLocalizations.i18n(context)!.delivery_note_20,
                            state.queryProductName),
                      ),
                      Visibility(
                        visible: state.queryRcvSchDateStart != '',
                        child: _buildQueryItem(
                            5,
                            WMSLocalizations.i18n(context)!
                                .home_main_page_table_text1,
                            state.queryRcvSchDateStart),
                      ),
                      Visibility(
                        visible: state.queryRcvSchDateEnd != '',
                        child: _buildQueryItem(
                            6,
                            WMSLocalizations.i18n(context)!
                                .home_main_page_table_text1,
                            state.queryRcvSchDateEnd),
                      ),
                      Visibility(
                        visible: state.queryCsvKbn != '',
                        child: _buildQueryItem(
                            7,
                            WMSLocalizations.i18n(context)!.inventory_output_5,
                            state.queryCsvKbn),
                      ),
                      Visibility(
                        visible: state.queryImporterrorFlg != '',
                        child: _buildQueryItem(
                            8,
                            WMSLocalizations.i18n(context)!
                                .display_instruction_ingestion_state,
                            state.queryImporterrorFlg),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
