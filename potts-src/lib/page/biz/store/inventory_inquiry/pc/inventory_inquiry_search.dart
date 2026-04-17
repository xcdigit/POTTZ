import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_month_widget.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../file/wms_common_file.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/inventory_inquiry_bloc.dart';
import '../bloc/inventory_inquiry_model.dart';

/**
 * 内容：在庫照会
 * 作者：王光顺
 * 时间：2023/08/24
 * 作者：赵士淞
 * 时间：2023/10/08
 */
class InventoryInquirySearch extends StatefulWidget {
  const InventoryInquirySearch({super.key});

  @override
  State<InventoryInquirySearch> createState() => _InventoryInquirySearchState();
}

class _InventoryInquirySearchState extends State<InventoryInquirySearch> {
  // 当前检索悬停标记
  bool _currentSearchHoverFlag = false;
  // 当前CSV悬停标记
  bool _currentCsvHoverFlag = false;

  // 导入文件回调函数
  void _importFileCallBack(List<List<Map<String, dynamic>>> content) {
    // 导入CSV文件事件
    context.read<InventoryInquiryBloc>().add(ImportCSVFileEvent(content));
  }

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
            text + '：' + value,
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
                // 保存检索：商品コード事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveQueryProductCodeEvent(''));
              } else if (index == 2) {
                // 保存检索：商品名事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveQueryProductNameEvent(''));
              } else if (index == 3) {
                // 保存检索：ロケーションコード事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveQueryLocationLocCdEvent(''));
              } else if (index == 4) {
                // 保存检索：年月事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveQueryYearMonthEvent(''));
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
            text + '：' + value,
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
                // 保存查询：商品コード事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveSearchProductCodeEvent(''));
              } else if (index == 2) {
                // 保存查询：商品名事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveSearchProductNameEvent(''));
              } else if (index == 3) {
                // 保存查询：ロケーションコード事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveSearchLocationLocCdEvent(''));
              } else if (index == 4) {
                // 保存查询：年月事件
                context
                    .read<InventoryInquiryBloc>()
                    .add(SaveSearchYearMonthEvent(''));
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
      color: Colors.white,
      height: 48,
      width: 220,
      child: OutlinedButton(
        onPressed: () {
          // 判断按钮
          if (index == 0) {
            // 搜索按钮事件
            context.read<InventoryInquiryBloc>().add(SearchButtonEvent());
          } else if (index == 1) {
            // 重置按钮事件
            context.read<InventoryInquiryBloc>().add(ResetButtonEvent());
          } else {}
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            Colors.black,
          ),
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

  // 初始化检索列表
  List<Widget> _initSearchList(InventoryInquiryModel state) {
    return [
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
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
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                height: 34,
                child: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_11,
                  style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                ),
              ),
              Visibility(
                visible: state.searchProductCode != '',
                child: _buildSearchItem(
                    1,
                    WMSLocalizations.i18n(context)!.delivery_note_23,
                    state.searchProductCode),
              ),
              Visibility(
                visible: state.searchProductName != '',
                child: _buildSearchItem(
                    2,
                    WMSLocalizations.i18n(context)!
                        .delivery_note_shipment_details_3,
                    state.searchProductName),
              ),
              Visibility(
                visible: state.searchLocationLocCd != '',
                child: _buildSearchItem(
                    3,
                    WMSLocalizations.i18n(context)!
                        .start_inventory_location_code,
                    state.searchLocationLocCd),
              ),
              Visibility(
                visible: state.searchYearMonth != '',
                child: _buildSearchItem(
                    4,
                    WMSLocalizations.i18n(context)!.menu_content_4_10_11,
                    state.searchYearMonth),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // 商品コード
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.delivery_note_23),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchProductCode,
                  inputBoxCallBack: (value) {
                    // 保存查询：商品コード事件
                    context
                        .read<InventoryInquiryBloc>()
                        .add(SaveSearchProductCodeEvent(value));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // 商品名
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!
                  .delivery_note_shipment_details_3),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchProductName,
                  inputBoxCallBack: (value) {
                    // 保存查询：商品名事件
                    context
                        .read<InventoryInquiryBloc>()
                        .add(SaveSearchProductNameEvent(value));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // ロケーションコード
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!
                  .start_inventory_location_code),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSDropdownWidget(
                  saveInput: true,
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
                    if (value is String) {
                      // 保存查询：ロケーションコード事件
                      context
                          .read<InventoryInquiryBloc>()
                          .add(SaveSearchLocationLocCdEvent(value));
                    } else {
                      // 保存查询：ロケーションコード事件
                      context
                          .read<InventoryInquiryBloc>()
                          .add(SaveSearchLocationLocCdEvent(value['loc_cd']));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        // 年月
        widthFactor: 0.4,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.menu_content_4_10_11),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSMonthWidget(
                  text: state.searchYearMonth,
                  monthCallBack: (value) {
                    // 保存查询：年月事件
                    context
                        .read<InventoryInquiryBloc>()
                        .add(SaveSearchYearMonthEvent(value));
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
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_24,
                0,
              ),
              SizedBox(
                width: 32,
              ),
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_25,
                1,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // 检索按钮
  _searchButton(InventoryInquiryModel state) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 48,
            child: MouseRegion(
              onEnter: (event) {
                // 状态变更
                setState(() {
                  // 当前检索悬停标记
                  _currentSearchHoverFlag = true;
                });
              },
              onExit: (event) {
                // 状态变更
                setState(() {
                  // 当前检索悬停标记
                  _currentSearchHoverFlag = false;
                });
              },
              child: OutlinedButton.icon(
                onPressed: () {
                  // 保存检索按钮标记事件
                  context
                      .read<InventoryInquiryBloc>()
                      .add(SaveQueryButtonFlag(!state.queryButtonFlag));
                  // 状态变更
                  setState(() {
                    // 当前检索悬停标记
                    _currentSearchHoverFlag = false;
                  });
                },
                icon: ColorFiltered(
                  colorFilter: state.queryButtonFlag
                      ? ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )
                      : _currentSearchHoverFlag
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
                        : _currentSearchHoverFlag
                            ? Colors.white
                            : Color.fromRGBO(0, 122, 255, 1),
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: state.queryButtonFlag
                      ? Color.fromRGBO(0, 122, 255, 1)
                      : _currentSearchHoverFlag
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
          Container(
            height: 48,
            child: MouseRegion(
              onEnter: (event) {
                // 状态变更
                setState(() {
                  // 当前CSV悬停标记
                  _currentCsvHoverFlag = true;
                });
              },
              onExit: (event) {
                // 状态变更
                setState(() {
                  // 当前CSV悬停标记
                  _currentCsvHoverFlag = false;
                });
              },
              child: OutlinedButton.icon(
                onPressed: () {
                  // 打开加载状态
                  BotToast.showLoading();
                  // 导入CSV文件
                  WMSCommonFile().importCSVFile(_importFileCallBack);
                },
                icon: ColorFiltered(
                  colorFilter: _currentCsvHoverFlag
                      ? ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )
                      : ColorFilter.mode(
                          Color.fromRGBO(0, 122, 255, 1),
                          BlendMode.srcIn,
                        ),
                  child: Image.asset(
                    WMSICons.INSTRUCTION_INPUT_FILE_CSV,
                    height: 24,
                  ),
                ),
                label: Text(
                  WMSLocalizations.i18n(context)!.Stock_present_2,
                  style: TextStyle(
                    color: _currentCsvHoverFlag
                        ? Colors.white
                        : Color.fromRGBO(0, 122, 255, 1),
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _currentCsvHoverFlag
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
    return BlocBuilder<InventoryInquiryBloc, InventoryInquiryModel>(
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
                              .read<InventoryInquiryBloc>()
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
              visible: state.queryProductCode != '' ||
                  state.queryProductName != '' ||
                  state.queryLocationLocCd != '' ||
                  state.queryYearMonth != '',
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
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                        padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                        height: 34,
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_11,
                          style:
                              TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                        ),
                      ),
                      Visibility(
                        visible: state.queryProductCode != '',
                        child: _buildQueryItem(
                            1,
                            WMSLocalizations.i18n(context)!.delivery_note_23,
                            state.queryProductCode),
                      ),
                      Visibility(
                        visible: state.queryProductName != '',
                        child: _buildQueryItem(
                            2,
                            WMSLocalizations.i18n(context)!
                                .delivery_note_shipment_details_3,
                            state.queryProductName),
                      ),
                      Visibility(
                        visible: state.queryLocationLocCd != '',
                        child: _buildQueryItem(
                            3,
                            WMSLocalizations.i18n(context)!
                                .start_inventory_location_code,
                            state.queryLocationLocCd),
                      ),
                      Visibility(
                        visible: state.queryYearMonth != '',
                        child: _buildQueryItem(
                            4,
                            WMSLocalizations.i18n(context)!
                                .menu_content_4_10_11,
                            state.queryYearMonth),
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
