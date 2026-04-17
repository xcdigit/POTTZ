import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/inventory_query_detail_bloc.dart';
import '../bloc/inventory_query_detail_model.dart';

/**
 * 内容：棚卸照会-搜索
 * 作者：熊草云
 * 时间：2023/11/22
 */
class InventoryQueryDetailSearch extends StatefulWidget {
  const InventoryQueryDetailSearch({super.key});

  @override
  State<InventoryQueryDetailSearch> createState() =>
      _InventoryQueryDetailSearchState();
}

class _InventoryQueryDetailSearchState
    extends State<InventoryQueryDetailSearch> {
  // 当前悬停标记
  bool _currentHoverFlag = false;

  // 构建检索单项
  Widget _buildQueryItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      // height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        children: [
          Text(
            text +
                '：' +
                (index == 4
                    ? (value == Config.DIFF_KBN_1
                        ? WMSLocalizations.i18n(context)!
                            .inventory_query_detail_differing
                        : value == Config.DIFF_KBN_2
                            ? WMSLocalizations.i18n(context)!
                                .inventory_query_detail_without
                            : '')
                    : index == 5
                        ? (value == Config.DELETE_YES
                            ? WMSLocalizations.i18n(context)!
                                .inventory_query_completion
                            : value == Config.DELETE_NO
                                ? WMSLocalizations.i18n(context)!
                                    .inventory_query_detail_incomplete
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
                // 保存检索：位置代码事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveQueryLocationLocCdEvent('', true));
              } else if (index == 2) {
                // 保存检索：商品代码事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveQueryProductCodeEvent('', true));
              } else if (index == 3) {
                // 保存检索：商品名称事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveQueryProductNameEvent('', true));
              } else if (index == 4) {
                // 保存检索：差異チェック事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveQueryDetailDiffKbnEvent('', true));
              } else if (index == 5) {
                // 保存检索：完了チェック事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveQueryDetailEndKbnEvent('', true));
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        children: [
          Text(
            text +
                '：' +
                (index == 4
                    ? (value == Config.DIFF_KBN_1
                        ? WMSLocalizations.i18n(context)!
                            .inventory_query_detail_differing
                        : value == Config.DIFF_KBN_2
                            ? WMSLocalizations.i18n(context)!
                                .inventory_query_detail_without
                            : '')
                    : index == 5
                        ? (value == Config.DELETE_YES
                            ? WMSLocalizations.i18n(context)!
                                .inventory_query_completion
                            : value == Config.DELETE_NO
                                ? WMSLocalizations.i18n(context)!
                                    .inventory_query_detail_incomplete
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
                // 保存查询：位置代码事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveSearchLocationLocCdEvent('', true));
              } else if (index == 2) {
                // 保存查询：商品代码事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveSearchProductCodeEvent('', true));
              } else if (index == 3) {
                // 保存查询：商品名称事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveSearchProductNameEvent('', true));
              } else if (index == 4) {
                // 保存查询：差異チェック事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveSearchDetailDiffKbnEvent('', true));
              } else if (index == 5) {
                // 保存查询：完了チェック事件
                context
                    .read<InventoryQueryDetailBloc>()
                    .add(SaveSearchDetailEndKbnEvent('', true));
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

  // 构建按钮
  _buildButtom(String text, int index) {
    return Container(
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () {
          // 判断按钮
          if (index == 0) {
            // 搜索按钮事件
            context.read<InventoryQueryDetailBloc>().add(SearchButtonEvent());
          } else if (index == 1) {
            // 重置按钮事件
            context.read<InventoryQueryDetailBloc>().add(ResetButtonEvent());
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

  // 构建差異チェック复选框
  _buildDiffKbnCheckBox(String text, String index) {
    return Expanded(
      flex: 1,
      child: Row(
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
              value: context
                      .read<InventoryQueryDetailBloc>()
                      .state
                      .searchDetailDiffKbn ==
                  index,
              onChanged: (value) {
                // 判断数值
                if (value == true) {
                  // 保存查询：差異チェック事件
                  context
                      .read<InventoryQueryDetailBloc>()
                      .add(SaveSearchDetailDiffKbnEvent(index, false));
                }
              },
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  // 构建完了チェック复选框
  _buildEndeKbnCheckBox(String text, String index) {
    return Expanded(
      flex: 1,
      child: Row(
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
              value: context
                      .read<InventoryQueryDetailBloc>()
                      .state
                      .searchDetailEndKbn ==
                  index,
              onChanged: (value) {
                // 判断数值
                if (value == true) {
                  // 保存查询：完了チェック事件
                  context
                      .read<InventoryQueryDetailBloc>()
                      .add(SaveSearchDetailEndKbnEvent(index, false));
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
  List<Widget> _initSearchList(InventoryQueryDetailModel state) {
    return [
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
              width: 1.0,
            ),
          ),
          child: Wrap(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 16, 0, 6),
                  child: Text(
                    WMSLocalizations.i18n(context)!.delivery_note_11,
                    style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                  ),
                ),
              ),
              Visibility(
                visible: state.searchLocationLocCd != '',
                child: _buildSearchItem(
                    1,
                    WMSLocalizations.i18n(context)!.exit_input_table_title_3,
                    state.searchLocationLocCd),
              ),
              Visibility(
                visible: state.searchProductCode != '',
                child: _buildSearchItem(
                    2,
                    WMSLocalizations.i18n(context)!
                        .instruction_input_table_title_3,
                    state.searchProductCode),
              ),
              Visibility(
                visible: state.searchProductName != '',
                child: _buildSearchItem(
                    3,
                    WMSLocalizations.i18n(context)!.delivery_note_20,
                    state.searchProductName),
              ),
              Visibility(
                visible: state.searchDetailDiffKbn != '',
                child: _buildSearchItem(
                    4,
                    WMSLocalizations.i18n(context)!
                        .inventory_query_search_text_1,
                    state.searchDetailDiffKbn),
              ),
              Visibility(
                visible: state.searchDetailEndKbn != '',
                child: _buildSearchItem(
                    5,
                    WMSLocalizations.i18n(context)!
                        .inventory_query_search_text_2,
                    state.searchDetailEndKbn),
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
                  WMSLocalizations.i18n(context)!.exit_input_table_title_3),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSDropdownWidget(
                  dataList1: state.locationList,
                  inputInitialValue: state.searchLocationLocCd,
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
                  dropdownTitle: 'loc_cd',
                  selectedCallBack: (value) {
                    // 判断数值
                    if (value == '') {
                      // 保存查询：位置代码事件
                      context
                          .read<InventoryQueryDetailBloc>()
                          .add(SaveSearchLocationLocCdEvent(value, false));
                    } else {
                      // 保存查询：位置代码事件
                      context.read<InventoryQueryDetailBloc>().add(
                          SaveSearchLocationLocCdEvent(value['loc_cd'], false));
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
              _buildText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_3),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchProductCode,
                  inputBoxCallBack: (value) {
                    // 保存查询：商品代码事件
                    context
                        .read<InventoryQueryDetailBloc>()
                        .add(SaveSearchProductCodeEvent(value, false));
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
                child: WMSInputboxWidget(
                  text: state.searchProductName,
                  inputBoxCallBack: (value) {
                    // 保存查询：商品名称事件
                    context
                        .read<InventoryQueryDetailBloc>()
                        .add(SaveSearchProductNameEvent(value, false));
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
              _buildText(WMSLocalizations.i18n(context)!
                  .inventory_query_search_text_1),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
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
                child: Column(
                  children: [
                    _buildDiffKbnCheckBox(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_detail_differing,
                        Config.DIFF_KBN_1),
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
              Container(
                margin: EdgeInsets.only(
                  top: 5,
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
                child: Column(
                  children: [
                    _buildDiffKbnCheckBox(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_detail_without,
                        Config.DIFF_KBN_2),
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
              Container(
                margin: EdgeInsets.only(
                  top: 5,
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
                child: Column(
                  children: [
                    _buildDiffKbnCheckBox(
                        WMSLocalizations.i18n(context)!.delivery_note_22, ''),
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
                  .inventory_query_search_text_2),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
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
                    _buildEndeKbnCheckBox(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_completion,
                        Config.DELETE_YES),
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
              Container(
                margin: EdgeInsets.only(
                  top: 5,
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
                    _buildEndeKbnCheckBox(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_detail_incomplete,
                        Config.DELETE_NO),
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
              Container(
                margin: EdgeInsets.only(
                  top: 5,
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
                  children: [
                    _buildEndeKbnCheckBox(
                        WMSLocalizations.i18n(context)!.delivery_note_22, ''),
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
              // 清除
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_25,
                1,
              ),
              SizedBox(
                height: 20,
              ),
              // 检索
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
  _searchButton(InventoryQueryDetailModel state) {
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
                      .read<InventoryQueryDetailBloc>()
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
                    height: 24,
                  ),
                ),
                label: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_1,
                  style: TextStyle(
                    color: state.queryButtonFlag
                        ? Colors.white
                        : _currentHoverFlag
                            ? Colors.white
                            : Color.fromRGBO(0, 122, 255, 1),
                    fontSize: 14,
                  ),
                ),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
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
                    padding: EdgeInsets.fromLTRB(32, 30, 32, 30),
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
                              .read<InventoryQueryDetailBloc>()
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
              visible: state.queryLocationLocCd != '' ||
                  state.queryProductCode != '' ||
                  state.queryProductName != '' ||
                  state.queryDetailDiffKbn != '' ||
                  state.queryDetailEndKbn != '',
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      width: 1.0,
                    ),
                  ),
                  child: Wrap(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 16, 0, 6),
                          child: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_11,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 122, 255, 1)),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: state.queryLocationLocCd != '',
                        child: _buildQueryItem(
                            1,
                            WMSLocalizations.i18n(context)!
                                .exit_input_table_title_3,
                            state.queryLocationLocCd),
                      ),
                      Visibility(
                        visible: state.queryProductCode != '',
                        child: _buildQueryItem(
                            2,
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_3,
                            state.queryProductCode),
                      ),
                      Visibility(
                        visible: state.queryProductName != '',
                        child: _buildQueryItem(
                            3,
                            WMSLocalizations.i18n(context)!.delivery_note_20,
                            state.queryProductName),
                      ),
                      Visibility(
                        visible: state.queryDetailDiffKbn != '',
                        child: _buildQueryItem(
                            4,
                            WMSLocalizations.i18n(context)!
                                .inventory_query_search_text_1,
                            state.queryDetailDiffKbn),
                      ),
                      Visibility(
                        visible: state.queryDetailEndKbn != '',
                        child: _buildQueryItem(
                            5,
                            WMSLocalizations.i18n(context)!
                                .inventory_query_search_text_2,
                            state.queryDetailEndKbn),
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
