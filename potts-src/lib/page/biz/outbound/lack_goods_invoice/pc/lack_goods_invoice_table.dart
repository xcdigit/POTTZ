import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/localization/default_localizations.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/lack_goods_invoice_bloc.dart';
import '../bloc/lack_goods_invoice_model.dart';

/**
 * 内容：欠品伝票照会-表格
 * 作者：luxy
 * 时间：2023/08/15
 */

// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 通信数据
List<Map<String, dynamic>> commData = [];
// 当前选择内容
List currentCheckContent = [];
//引当选中数据
List<dynamic>? LockNumData;
// 全局主键-表格共通

class LackGoodsInvoiceTable extends StatefulWidget {
  const LackGoodsInvoiceTable({super.key});

  @override
  State<LackGoodsInvoiceTable> createState() => _LackGoodsInvoiceTableState();
}

class _LackGoodsInvoiceTableState extends State<LackGoodsInvoiceTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: LackGoodsInvoiceTableTab(),
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
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: LackGoodsInvoiceTableButton(),
                  ),
                  LackGoodsInvoiceTableContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 欠品伝票照会-表格Tab
// ignore: must_be_immutable
class LackGoodsInvoiceTableTab extends StatefulWidget {
  LackGoodsInvoiceTableTab({super.key});

  @override
  State<LackGoodsInvoiceTableTab> createState() =>
      _LackGoodsInvoiceTableTabState();
}

class _LackGoodsInvoiceTableTabState extends State<LackGoodsInvoiceTableTab> {
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 状态变更
              setState(() {
                context
                    .read<LackGoodsInvoiceBloc>()
                    .add(SetTabEvent(tabItemList[i]['index']));
              });
            },
            child: Container(
              height: 46,
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: state.shipState == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : _currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 158,
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                onPressed: () {},
                hoverColor: Color.fromRGBO(44, 167, 176, .6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tabItemList[i]['title'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: state.shipState == tabItemList[i]['index']
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : _currentHoverIndex == tabItemList[i]['index']
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(6, 14, 15, 1),
                        height: 1.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      height: 24,
                      width: 32,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          i == 0
                              ? state.tab1.toString()
                              : state.tab2.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
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
        'title': WMSLocalizations.i18n(context)!.menu_content_3_11_12,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!.menu_content_3_11_13,
      },
    ];

    return BlocBuilder<LackGoodsInvoiceBloc, LackGoodsInvoiceModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 欠品伝票照会-表格按钮
class LackGoodsInvoiceTableButton extends StatefulWidget {
  const LackGoodsInvoiceTableButton({super.key});

  @override
  State<LackGoodsInvoiceTableButton> createState() =>
      _LackGoodsInvoiceTableButtonState();
}

class _LackGoodsInvoiceTableButtonState
    extends State<LackGoodsInvoiceTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, LackGoodsInvoiceModel state) {
    List<DropdownMenuItem<String>> getListData1() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            'ID',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'id',
      );
      items.add(dropdownMenuItem1);
      DropdownMenuItem<String> dropdownMenuItem2 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_14,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'ship_no',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_16,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'rcv_sch_date',
      );
      items.add(dropdownMenuItem3);
      DropdownMenuItem<String> dropdownMenuItem4 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_18,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'cus_rev_date',
      );
      items.add(dropdownMenuItem4);
      return items;
    }

    List<DropdownMenuItem<String>> getListData2() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            'ID',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'id',
      );
      items.add(dropdownMenuItem1);
      DropdownMenuItem<String> dropdownMenuItem2 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.instruction_input_table_title_3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'code',
      );
      items.add(dropdownMenuItem2);
      return items;
    }

    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      if (buttonItemList[i]['sort']) {
        buttonList.add(
          Container(
            child: Row(
              children: [
                Container(
                  height: 37,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: state.searchFlag == Config.NUMBER_ZERO
                                ? state.sortCol1
                                : state.sortCol2,
                            isExpanded: true, // 使 DropdownButton 填满宽度
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                            items: state.searchFlag == Config.NUMBER_ZERO
                                ? getListData1()
                                : getListData2(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (state.searchFlag == Config.NUMBER_ZERO) {
                                  state.sortCol1 = newValue!;
                                  context.read<LackGoodsInvoiceBloc>().add(
                                      SetSortEvent(
                                          state.sortCol1, state.ascendingFlg1));
                                } else {
                                  state.sortCol2 = newValue!;
                                  context.read<LackGoodsInvoiceBloc>().add(
                                      SetSortEvent(
                                          state.sortCol2, state.ascendingFlg2));
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70, // 设置 Switch 的宽度
                  height: 37, // 设置 Switch 的高度
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CupertinoSwitch(
                        value: state.searchFlag == Config.NUMBER_ZERO
                            ? state.ascendingFlg1
                            : state.ascendingFlg2,
                        onChanged: (bool value) {
                          setState(() {
                            if (state.searchFlag == Config.NUMBER_ZERO) {
                              state.ascendingFlg1 = !state.ascendingFlg1;
                              context.read<LackGoodsInvoiceBloc>().add(
                                  SetSortEvent(
                                      state.sortCol1, state.ascendingFlg1));
                            } else {
                              state.ascendingFlg2 = !state.ascendingFlg2;
                              context.read<LackGoodsInvoiceBloc>().add(
                                  SetSortEvent(
                                      state.sortCol2, state.ascendingFlg2));
                            }
                          });
                        },
                      ),
                      Positioned(
                        left: (state.searchFlag == Config.NUMBER_ZERO
                                ? state.ascendingFlg1
                                : state.ascendingFlg2)
                            ? 17
                            : null, // 开时文字在左侧
                        right: (state.searchFlag == Config.NUMBER_ZERO
                                ? state.ascendingFlg1
                                : state.ascendingFlg2)
                            ? null
                            : 17, // 关时文字在右侧
                        child: Text(
                          (state.searchFlag == Config.NUMBER_ZERO
                                  ? state.ascendingFlg1
                                  : state.ascendingFlg2)
                              ? 'A'
                              : 'D', // 根据开关状态显示文本
                          style: TextStyle(
                            color: Colors.black, // 设置文字颜色
                            fontSize: 14, // 设置字体大小
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // 按钮列表
        buttonList.add(
          GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 全部选择
                context
                    .read<LackGoodsInvoiceBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<LackGoodsInvoiceBloc>()
                    .add(RecordCheckAllEvent(false));
              } else {}
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                buttonItemList[i]['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
            ),
          ),
        );
      }
    }
    // 按钮列表
    return buttonList;
  }

  bool _stop = false;
  void setStop(stop) {
    setState(() {
      _stop = stop;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_choice,
        'sort': false,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!
            .instruction_input_tab_button_cancellation,
        'sort': false,
      },
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];

    return BlocBuilder<LackGoodsInvoiceBloc, LackGoodsInvoiceModel>(
      builder: (context, state) {
        return Container(
          height: 37,
          child: Stack(
            children: [
              Container(
                child: Row(
                  children: _initButtonLeftList(_buttonLeftItemList, state),
                ),
              ),
              state.shipState == Config.NUMBER_ZERO
                  ? Positioned(
                      right: 0,
                      child: Container(
                        child: Row(
                          children: [
                            MouseRegion(
                              onEnter: (event) {
                                setState(() {
                                  setStop(true);
                                });
                              },
                              onExit: (event) {
                                setState(() {
                                  setStop(false);
                                });
                              },
                              child: GestureDetector(
                                onPanDown: (details) {
                                  context
                                      .read<LackGoodsInvoiceBloc>()
                                      .add(ReservationShipLineEvent(context));
                                },
                                child: Container(
                                  height: 37,
                                  width: 77,
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: 16),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _stop
                                        ? Color.fromRGBO(0, 122, 255, .6)
                                        : Colors.white,
                                    border: Border.all(
                                      color: _stop
                                          ? Color.fromRGBO(0, 122, 255, .6)
                                          : Color.fromRGBO(224, 224, 224, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                        child: Image.asset(
                                          WMSICons.WAREHOUSE_DETAILS_ICON,
                                          width: 17,
                                          height: 19.43,
                                          color: _stop
                                              ? Colors.white
                                              : Color.fromRGBO(0, 122, 255, 1),
                                        ),
                                      ),
                                      Text(
                                        WMSLocalizations.i18n(context)!
                                            .menu_content_3_11_1,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: _stop
                                              ? Colors.white
                                              : Color.fromRGBO(0, 122, 255, 1),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            // }),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}

// 欠品伝票照会-表格内容
class LackGoodsInvoiceTableContent extends StatefulWidget {
  const LackGoodsInvoiceTableContent({super.key});

  @override
  State<LackGoodsInvoiceTableContent> createState() =>
      _LackGoodsInvoiceTableContentState();
}

class _LackGoodsInvoiceTableContentState
    extends State<LackGoodsInvoiceTableContent> {
  // 获取表格数据

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LackGoodsInvoiceBloc, LackGoodsInvoiceModel>(
        builder: (context, state) {
      return WMSTableWidget<LackGoodsInvoiceBloc, LackGoodsInvoiceModel>(
        columns: state.shipState == Config.NUMBER_ZERO
            ? [
                {
                  'key': 'id',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_1,
                },
                {
                  'key': 'ship_no',
                  'width': 5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_1,
                },
                {
                  'key': 'rcv_sch_date',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_3,
                },
                {
                  'key': 'cus_rev_date',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_5,
                },
                {
                  'key': 'customer_name',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_4,
                },
                {
                  'key': 'name',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_basic_8,
                },
              ]
            : [
                {
                  'key': 'id',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_1,
                },
                {
                  'key': 'code',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_3,
                },
                {
                  'key': 'name',
                  'width': 3,
                  'title':
                      WMSLocalizations.i18n(context)!.exit_input_form_title_8,
                },
                {
                  'key': 'name_short',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_product_abbreviation,
                },
                {
                  'key': 'jan_cd',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!.menu_content_3_11_14,
                },
                {
                  'key': 'stock',
                  'width': 3,
                  'title': WMSLocalizations.i18n(context)!
                      .outbound_adjust_table_btn_1,
                },
              ],
        operatePopupHeight: 100,
        showCheckboxColumn: true,
        operatePopupOptions: [
          {
            'title': WMSLocalizations.i18n(context)!.menu_content_3_11_2,
            'callback': (_, value) {
              if (state.shipState == Config.NUMBER_ZERO) {
                GoRouter.of(context)
                    .push(
                  '/lackgoodsinvoice/details/' + value['id'].toString(),
                )
                    .then((value) {
                  // 判断返回值
                  if (value != 'return') {
                    // 初始化事件
                    context.read<LackGoodsInvoiceBloc>().add(PageQueryEvent());
                  }
                });
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));
              } else {
                _showDetailDialog(value);
              }
            }
          }
        ],
      );
    });
  }

  // 显示明细弹窗
  _showDetailDialog(Map value) {
    LackGoodsInvoiceBloc bloc = context.read<LackGoodsInvoiceBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<LackGoodsInvoiceBloc>.value(
          value: bloc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  WMSLocalizations.i18n(context)!.delivery_note_8,
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
                              Color.fromRGBO(255, 255, 255, 1),
                            ),
                            minimumSize: MaterialStatePropertyAll(
                              Size(90, 36),
                            ),
                          ),
                          onPressed: () {
                            // 关闭弹窗
                            Navigator.of(context).pop(true);
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
                    )),
              ],
            ),
            content: Container(
              width: 1072,
              height: 580,
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
              child: _showDetailDialogContent(value),
            ),
          ),
        );
      },
    );
  }

  _showDetailDialogContent(Map value) {
    return BlocBuilder<LackGoodsInvoiceBloc, LackGoodsInvoiceModel>(
      builder: (context, state) {
        return ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 商品コード
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_table_title_3),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: value['code'],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品名
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_table_title_4),
                        WMSInputboxWidget(
                          readOnly: true,
                          text: value['name'],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品社内備考1
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_17),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: value['company_note1'],
                          readOnly: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品注意備考1
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_19),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: value['notice_note1'],
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 24),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 在库数
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .outbound_adjust_table_btn_1),
                        WMSInputboxWidget(
                          text: value['stock'],
                          readOnly: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 規格
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_table_title_5),
                        WMSInputboxWidget(
                          text: value['size'],
                          readOnly: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品社内備考2
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_18),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: value['company_note2'],
                          readOnly: true,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品注意備考2
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_20),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: value['notice_note2'],
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 24),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 商品写真1
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_5),
                        value['image1'] != null && value['image1'] != ''
                            ? Image.network(
                                value['image1'],
                                height: 220,
                              )
                            : Image.asset(
                                WMSICons.NO_IMAGE,
                                height: 220,
                              ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品写真2
                        _detailDialogTitle(WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_6),
                        value['image2'] != null && value['image2'] != ''
                            ? Image.network(
                                value['image2'],
                                height: 230,
                              )
                            : Image.asset(
                                WMSICons.NO_IMAGE,
                                height: 220,
                              ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // 明细弹窗标题
  _detailDialogTitle(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }
}
