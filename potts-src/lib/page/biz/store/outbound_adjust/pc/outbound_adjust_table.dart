import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_bloc.dart';
import 'package:wms/page/biz/store/outbound_adjust/bloc/outbound_adjust_model.dart';
import 'package:wms/page/biz/store/outbound_adjust/pc/outbound_adjust_query.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:wms/widget/table/pc/wms_table_widget.dart';
import 'package:wms/widget/wms_dialog_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../../common/utils/check_utils.dart';

/**
 * 内容：在库调整入力 -表格
 * 作者：cuihr
 * 时间：2023/08/28
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
// 当前选择内容
List currentCheckContent = [];
// 检索条件
List<String> conditionList = [];

class OutboundAdjustTable extends StatefulWidget {
  const OutboundAdjustTable({super.key});

  @override
  State<OutboundAdjustTable> createState() => _OutboundAdjustTableState();
}

class _OutboundAdjustTableState extends State<OutboundAdjustTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
        builder: (context, state) {
      return Container(
        child: Column(
          children: [
            //检索按钮
            searchButton(),
            Visibility(
              visible: _buttonFlag,
              child: OutboundAdjustQuery(
                onSearchLabel: (List<String> list) {
                  /*检索页面label集合*/
                  setState(() {
                    conditionList = list;
                  });
                },
                onSearchValue: (List<String> list) {
                  // 调用方法赋值并检索数据
                  context.read<OutboundAdjustBloc>().add(PageQueryEvent());
                },
                // 选择搜索返回的条件集合
                onBoxChanged: (List<String> list) {
                  setState(() {
                    // conditionList = list;
                    _buttonFlag = false;
                  });
                },
                onValueChanged: (bool value) {
                  setState(() {
                    _buttonFlag = value;
                  });
                },
                onbottomChanged: (bool value) {
                  setState(() {
                    _buttonFlag = false;
                  });
                },
              ),
            ),

            Visibility(
              visible: (state.data1 != '' ||
                      state.data2 != '' ||
                      state.location.id != null) &&
                  !_buttonFlag,
              child: // 检索条件小框
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
                                  .transfer_inquiry_note_1,
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 122, 255, 1)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Visibility(
                        visible: state.data1 != '',
                        child: buildCondition(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_id,
                            state.data1),
                      ),
                      Visibility(
                        visible: state.data2 != '',
                        child: buildCondition(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_name,
                            state.data2),
                      ),
                      Visibility(
                        visible: state.location.id != null,
                        child: buildCondition(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_query_location,
                            state.location.loc_cd.toString()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.only(top: 16, bottom: 16)),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Column(
                children: [],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                //表格tab -一览表
                child: OutboundAdjustTableTab(),
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
                child: Column(children: [
                  // //调整按钮
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                  //   child: Container(),
                  //   // OutboundAdjustTableButton()
                  // ),
                  //内容
                  OutboundAdjustTableContent(),
                ]),
              ),
            )
          ],
        ),
      );
    });
  }

  //检索条件内部数据
  Container buildCondition(String queryLabel, String queryValue) {
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
                              .outbound_adjust_query_id) {
                        context
                            .read<OutboundAdjustBloc>()
                            .add(SetProductCodeEvent(''));
                        context
                            .read<OutboundAdjustBloc>()
                            .add(PageQueryEvent());
                      } else if (queryLabel ==
                          WMSLocalizations.i18n(context)!
                              .outbound_adjust_query_name) {
                        context
                            .read<OutboundAdjustBloc>()
                            .add(SetProductNameEvent(''));
                        context
                            .read<OutboundAdjustBloc>()
                            .add(PageQueryEvent());
                      } else if (queryLabel ==
                          WMSLocalizations.i18n(context)!
                              .outbound_adjust_query_location) {
                        context
                            .read<OutboundAdjustBloc>()
                            .add(SetAdjustInquiryEvent("id", ''));
                        context
                            .read<OutboundAdjustBloc>()
                            .add(SetAdjustInquiryEvent("loc_cd", ''));
                        context
                            .read<OutboundAdjustBloc>()
                            .add(PageQueryEvent());
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
  }

  //按钮是否选中
  bool _buttonFlag = false;
  // 悬停追踪
  bool buttonHovered = false;
  //检索按钮
  searchButton() {
    return Container(
      child: Row(
        children: [
          Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: MouseRegion(
              onEnter: (event) {
                setState(() {
                  buttonHovered = true; // 鼠标进入，按钮悬停状态为 true
                });
              },
              onExit: (event) {
                setState(() {
                  buttonHovered = false; // 鼠标离开，按钮悬停状态为 false
                });
              },
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _buttonFlag = !_buttonFlag;
                  });
                },
                icon: ColorFiltered(
                  colorFilter: _buttonFlag
                      ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : buttonHovered
                          ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : ColorFilter.mode(
                              Color.fromRGBO(0, 122, 255, 1), BlendMode.srcIn),
                  child: Image.asset(
                    WMSICons.WAREHOUSE_MENU_ICON,
                    height: 24,
                    width: 24,
                  ),
                ),
                //筛选搜索
                label: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_1,
                  style: TextStyle(
                    color: _buttonFlag
                        ? Colors.white
                        : buttonHovered
                            ? Colors.white
                            : Color.fromRGBO(0, 122, 255, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: _buttonFlag
                      ? Color.fromRGBO(0, 122, 255, 1)
                      : buttonHovered
                          ? Color.fromRGBO(0, 122, 255, 1)
                          : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 在库调整入力-表格Tab
class OutboundAdjustTableTab extends StatefulWidget {
  const OutboundAdjustTableTab({super.key});

  @override
  State<OutboundAdjustTableTab> createState() => _OutboundAdjustTableTabState();
}

class _OutboundAdjustTableTabState extends State<OutboundAdjustTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          child: Container(
            height: 46,
            padding: EdgeInsets.fromLTRB(12, 11, 12, 11),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: tabItemList[i]['index'] == currentIndex
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            constraints: BoxConstraints(
              minWidth: 158,
            ),
            child: Stack(
              children: [
                Text(
                  tabItemList[i]['title'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: tabItemList[i]['index'] == currentIndex
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(6, 14, 15, 1),
                    height: 1.5,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    height: 24,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        tabItemList[i]['number'].toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
    return BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
        builder: (context, state) {
      // Tab单个列表
      List _tabItemList = [
        {
          //一览表
          'index': Config.NUMBER_ZERO,
          'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
          'number': state.total,
        },
      ];
      return Row(
        children: _initTabList(_tabItemList),
      );
    });
  }
}

//在库调整入力 -表格内容
class OutboundAdjustTableContent extends StatefulWidget {
  const OutboundAdjustTableContent({super.key});

  @override
  State<OutboundAdjustTableContent> createState() =>
      _OutboundAdjustTableContentState();
}

class _OutboundAdjustTableContentState
    extends State<OutboundAdjustTableContent> {
// 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, OutboundAdjustModel state) {
    List<DropdownMenuItem<String>> getListData() {
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
            WMSLocalizations.i18n(context)!.outbound_adjust_table_title_3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'code',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.outbound_adjust_table_title_5,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'loc_cd',
      );
      items.add(dropdownMenuItem3);
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
                            value: state.sortCol,
                            isExpanded: true, // 使 DropdownButton 填满宽度
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                            items: getListData(),
                            onChanged: (String? newValue) {
                              setState(() {
                                state.sortCol = newValue!;
                                context.read<OutboundAdjustBloc>().add(
                                    SetSortEvent(
                                        state.sortCol, state.ascendingFlg));
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
                        value: state.ascendingFlg,
                        onChanged: (bool value) {
                          setState(() {
                            state.ascendingFlg = !state.ascendingFlg;
                            context.read<OutboundAdjustBloc>().add(SetSortEvent(
                                state.sortCol, state.ascendingFlg));
                          });
                        },
                      ),
                      Positioned(
                        left: state.ascendingFlg ? 17 : null, // 开时文字在左侧
                        right: state.ascendingFlg ? null : 17, // 关时文字在右侧
                        child: Text(
                          state.ascendingFlg ? 'A' : 'D', // 根据开关状态显示文本
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
                    .read<OutboundAdjustBloc>()
                    .add(RecordCheckAllEvent(true));
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 全部取消
                context
                    .read<OutboundAdjustBloc>()
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

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      // {
      //   'index': Config.NUMBER_ZERO,
      //   'title':
      //       WMSLocalizations.i18n(context)!.transfer_inquiry_tab_button_choice,
      //                   'sort': false,
      // },
      // {
      //   'index': Config.NUMBER_ONE,
      //   'title': WMSLocalizations.i18n(context)!
      //       .transfer_inquiry_tab_button_cancellation,
      //                   'sort': false,
      // },
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];

    return BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
        builder: (bloc, state) {
      return Column(
        children: [
          Container(
            height: 37,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
            child: Stack(
              children: [
                Container(
                  child: Row(
                    children: _initButtonLeftList(_buttonLeftItemList, state),
                  ),
                ),
              ],
            ),
          ),
          WMSTableWidget<OutboundAdjustBloc, OutboundAdjustModel>(
            columns: [
              {
                'key': 'id',
                'width': 3,
                'title': WMSLocalizations.i18n(context)!
                    .outbound_adjust_table_title_2,
              },
              {
                'key': 'code',
                'width': 4,
                'title': WMSLocalizations.i18n(context)!
                    .outbound_adjust_table_title_3,
              },
              {
                'key': 'name',
                'width': 5,
                'title': WMSLocalizations.i18n(context)!
                    .outbound_adjust_table_title_4,
              },
              {
                'key': 'loc_cd',
                'width': 6,
                'title': WMSLocalizations.i18n(context)!
                    .outbound_adjust_table_title_5,
              },
              {
                'key': 'stock',
                'width': 5,
                'title': WMSLocalizations.i18n(context)!
                    .outbound_adjust_table_title_6,
              },
              {
                'key': 'lock_stock',
                'width': 3,
                'title': WMSLocalizations.i18n(context)!
                    .outbound_adjust_table_title_7,
              },
            ],
            operatePopupHeight: 95,
            operatePopupOptions: [
              {
                'title':
                    WMSLocalizations.i18n(context)!.outbound_adjust_table_text,
                'callback': (_, value) {
                  bloc
                      .read<OutboundAdjustBloc>()
                      .add(SetDataToDialogEvent(value, context));
                  _showAdjustDialog();
                },
              },
            ],
          ),
        ],
      );
    });
  }

  showAdjustSureDialog() {
    OutboundAdjustBloc bloc = context.read<OutboundAdjustBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<OutboundAdjustBloc>.value(
          value: bloc,
          child: BlocBuilder<OutboundAdjustBloc, OutboundAdjustModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText:
                    WMSLocalizations.i18n(context)!.outbound_adjust_sure_title,
                contentText: WMSLocalizations.i18n(context)!
                    .outbound_adjust_sure_content,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.outbound_adjust_table_btn,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () async {
                  bool flag = await bloc.InsertStoreMoveData();
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
                    //重新检索
                    bloc.add(PageQueryEvent());
                    Navigator.pop(context);
                  } else {
                    WMSCommonBlocUtils.tipTextToast(
                        WMSLocalizations.i18n(context)!
                            .outbound_adjust_toast_1);
                  }
                  // 关闭弹窗
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  //弹出明细弹框
  //调整弹窗
  _showAdjustDialog() {
    OutboundAdjustBloc bloc = context.read<OutboundAdjustBloc>();
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return BlocProvider<OutboundAdjustBloc>.value(
          value: bloc,
          child: AlertDialog(
            //圆角设置
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            //标题
            title: PhysicalModel(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: 500,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
                child: Text(
                  WMSLocalizations.i18n(context)!.outbound_adjust_table_text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ),
            ),
            titlePadding: EdgeInsets.all(0.0),
            contentPadding: EdgeInsets.all(0.0),
            //内容
            content: Container(
                width: 500,
                height: 450,
                padding: EdgeInsets.all(34),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 24,
                                          child: Row(
                                            children: [
                                              Text(
                                                WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_table_btn_1,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      6, 14, 15, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 48,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: WMSInputboxWidget(
                                                height: 100,
                                                text:
                                                    bloc.state.stock.toString(),
                                                readOnly: true,
                                                inputBoxCallBack: (value) {},
                                              ),
                                            ),
                                            Container(
                                              width: 40,
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
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .shipment_inspection_item),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 24,
                                          child: Row(
                                            children: [
                                              Text(
                                                WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_table_btn_2,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      6, 14, 15, 1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 48,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: WMSInputboxWidget(
                                                height: 100,
                                                text: bloc.state.lockStock
                                                    .toString(),
                                                readOnly: true,
                                                inputBoxCallBack: (value) {},
                                              ),
                                            ),
                                            Container(
                                              width: 40,
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
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .shipment_inspection_item),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 90,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 24,
                                          child: Row(
                                            children: [
                                              Text(
                                                WMSLocalizations.i18n(context)!
                                                    .outbound_adjust_table_btn_3,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      6, 14, 15, 1),
                                                ),
                                              ),
                                              Text(
                                                "*",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Color.fromRGBO(
                                                      255, 0, 0, 1.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 48,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(2)),
                                              child: WMSInputboxWidget(
                                                height: 100,
                                                text: bloc
                                                    .state.afterAdjustNumber
                                                    .toString(),
                                                inputBoxCallBack: (value) {
                                                  bloc.state.afterAdjustNumber =
                                                      value;
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: 40,
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
                                                child: Text(WMSLocalizations
                                                        .i18n(context)!
                                                    .shipment_inspection_item),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Text(
                                              WMSLocalizations.i18n(context)!
                                                  .outbound_adjust_table_btn_4,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    6, 14, 15, 1),
                                              ),
                                            ),
                                            Text(
                                              "*",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: 600,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        border: Border.all(
                                          color:
                                              Color.fromRGBO(224, 224, 224, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(2)),
                                    child: WMSInputboxWidget(
                                      height: 220,
                                      maxLines: 9,
                                      text: bloc.state.afterReason,
                                      inputBoxCallBack: (value) {
                                        bloc.state.afterReason = value;
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            buttonPadding: EdgeInsets.fromLTRB(16, 16, 0, 16),
            actions: <Widget>[
              //左边按钮 默认显示
              Visibility(
                visible: true,
                child: Container(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Text(
                      WMSLocalizations.i18n(context)!.app_cancel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
                    onPressed: () async {
                      // 关闭弹窗
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              //右边按钮 默认显示
              Visibility(
                visible: true,
                child: Container(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(44, 167, 176, 1),
                    ),
                    child: Text(
                      WMSLocalizations.i18n(context)!.app_ok,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(233, 238, 238, 1),
                      ),
                    ),
                    onPressed: () async {
                      if (bloc.state.afterAdjustNumber == '') {
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_toast_6);
                      } else if (CheckUtils.check_Half_Number_In_10(
                          bloc.state.afterAdjustNumber)) {
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                    .outbound_adjust_table_btn_3 +
                                WMSLocalizations.i18n(context)!
                                    .check_half_width_numbers_in_10);
                      } else if (bloc.state.afterReason == '') {
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_toast_7);
                      } else if (int.parse(bloc.state.afterAdjustNumber) ==
                          bloc.state.stock) {
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_toast_3);
                      } else if (int.parse(bloc.state.afterAdjustNumber) <
                          bloc.state.lockStock) {
                        WMSCommonBlocUtils.tipTextToast(
                            WMSLocalizations.i18n(context)!
                                .outbound_adjust_toast_4);
                      } else {
                        showAdjustSureDialog();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
