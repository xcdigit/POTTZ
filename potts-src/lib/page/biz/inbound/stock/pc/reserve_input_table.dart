import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../model/receive.dart';

import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/reserve_input_bloc.dart';
import '../bloc/reserve_input_model.dart';

/**
 * 内容：入荷予定入力
 * 作者：王光顺
 * 时间：2023/08/18
 * 作者：luxy
 * 时间：2023/10/17
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List<Receive> currentContent = [];
// 当前选择内容
List currentCheckContent = [];

String code = '';

double product_price = 0;

int product_num = 0;

String note1 = '';

String note2 = '';

// 删除
List deleteContent = [];
List detaildata = [];

class ReserveInputTable extends StatefulWidget {
  const ReserveInputTable({super.key});

  @override
  State<ReserveInputTable> createState() => _ReserveInputTableState();
}

class _ReserveInputTableState extends State<ReserveInputTable> {
  List<Map<String, dynamic>> data = [];
  //按钮是否选中
  // bool _buttonFlag = false;
  @override
  void initState() {
    super.initState();
  }

  // 明细
  bool detailbutton = false; // 用于追踪检索按钮状态
  void updetailButton(bool value) {
    setState(() {
      detailbutton = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //检索按钮
          new Padding(padding: EdgeInsets.only(top: 16, bottom: 16)),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ReserveInputTableTab(
                      initTableList: currentContent,
                    ),
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
                          child: ReserveInputTableButton(),
                        ),
                        ReserveInputTableContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 入荷予定照会-表格Tab
// ignore: must_be_immutable
class ReserveInputTableTab extends StatefulWidget {
  // 初始化一覧表格
  List initTableList;
  ReserveInputTableTab({
    super.key,
    required this.initTableList,
  });

  @override
  State<ReserveInputTableTab> createState() => _ReserveInputTableTabState();
}

class _ReserveInputTableTabState extends State<ReserveInputTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, ReserveInputModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {},
          child: Container(
            height: 46,
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
                      color: tabItemList[i]['index'] == currentIndex
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                      height: 1.0,
                    ),
                  ),
                  i > 0
                      ? Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 24,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              "1",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 24,
                          width: 32,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              (state.num).toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        )
                ],
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
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
      },
    ];
    return BlocBuilder<ReserveInputBloc, ReserveInputModel>(
      builder: (context, state) => Row(
        children: _initTabList(_tabItemList, state),
      ),
    );
  }
}

//表格按钮
class ReserveInputTableButton extends StatefulWidget {
  const ReserveInputTableButton({super.key});

  @override
  State<ReserveInputTableButton> createState() =>
      _ReserveInputTableButtonState();
}

class _ReserveInputTableButtonState extends State<ReserveInputTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          onTap: () {
            // 判断循环下标
            if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 全部选择
              context.read<ReserveInputBloc>().add(RecordCheckAllEvent(true));
            } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
              // 全部取消
              context.read<ReserveInputBloc>().add(RecordCheckAllEvent(false));
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
    // 按钮列表
    return buttonList;
  }

  // 明细按钮
  Map detaildataDilog = {};
  Map detaildata = {};
  bool detailbottom = false;

  void updetaildata(Map value, bool detailbottom) {
    setState(() {
      detaildata = Map.from(value);
      detaildataDilog = Map.from(value);
    });
  }

  List<dynamic> dataList = [];
  void updataList(List<dynamic> value) {
    setState(() {
      dataList = List.from(value);
      detaildata = dataList.length == 1 ? dataList[0] : {};
      detaildataDilog = dataList[0];
    });
  }

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, ReserveInputModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          onTap: () async {
            // 查询入荷予定明细事件
            bool tempBool = await context
                .read<ReserveInputBloc>()
                .QueryReceiveDetailEvent(state.receiveId);
            if (tempBool) {
              Map<String, dynamic> value = {};
              state.customer = value;
              //处理入荷予定明细表行NO
              context
                  .read<ReserveInputBloc>()
                  .add(handleReceiveLineNoEvent(value));
              _showDetailDialog(1, context);
            }
          },
          child: Container(
            child: Row(
              children: [
                Icon(
                  Icons.add, // 使用自带的加号图标
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
                SizedBox(width: 8),
                Text(
                  WMSLocalizations.i18n(context)!.reserve_input_15,
                  style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 左侧按钮单个列表
    List _buttonLeftItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_choice,
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!
            .instruction_input_tab_button_cancellation,
      },
    ];

    // 右侧按钮单个列表
    List _buttonRightItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_15,
      },
    ];

    return BlocBuilder<ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
      return Container(
        height: 37,
        child: Stack(
          children: [
            Container(
              child: Row(
                children: _initButtonLeftList(_buttonLeftItemList),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                child: Row(
                  children: _initButtonRightList(_buttonRightItemList, state),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// 表格内容
class ReserveInputTableContent extends StatefulWidget {
  @override
  State<ReserveInputTableContent> createState() =>
      _ReserveInputTableContentState();
}

class _ReserveInputTableContentState extends State<ReserveInputTableContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
      return WMSTableWidget<ReserveInputBloc, ReserveInputModel>(
        columns: [
          {
            'key': 'id',
            'width': 1,
            'title': 'ID',
          },
          {
            'key': 'receive_line_no',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.reserve_input_17,
          },
          {
            'key': 'code',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.reserve_input_10,
          },
          {
            'key': 'name',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.reserve_input_11,
          },
          {
            'key': 'product_price',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.reserve_input_12,
          },
          {
            'key': 'product_num',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.reserve_input_13,
          },
          {
            'key': 'size',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!.reserve_input_14,
          },
          {
            'key': 'importerror_flg',
            'width': 1,
            'title': WMSLocalizations.i18n(context)!
                .display_instruction_ingestion_state,
          },
        ],
        showCheckboxColumn: true,
        operatePopupOptions: [
          {
            'title': WMSLocalizations.i18n(context)!.menu_content_2_5_11,
            'callback': (_, value) async {
              // 查询入荷予定明细事件
              bool tempBool = await context
                  .read<ReserveInputBloc>()
                  .QueryReceiveDetailEvent(state.receiveId);
              if (tempBool) {
                //处理商品写真路径
                context
                    .read<ReserveInputBloc>()
                    .add(handleProductImageEvent(value));
                _showDetailDialog(0, context);
              }
            },
          },
          {
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_table_operate_delete,
            'callback': (_, value) {
              // 删除弹窗
              _showDelDialog(value['receive_line_no'], context);
            },
          }
        ],
      );
    });
  }

  //删除弹框
  _showDelDialog(String _text, BuildContext parentContext) {
    ReserveInputBloc bloc = context.read<ReserveInputBloc>();
    showDialog<bool>(
        context: context,
        builder: (context) {
          return BlocProvider<ReserveInputBloc>.value(
              value: bloc,
              child: BlocBuilder<ReserveInputBloc, ReserveInputModel>(
                builder: (context, state) {
                  return WMSDiaLogWidget(
                    titleText: WMSLocalizations.i18n(context)!
                        .display_instruction_confirm_delete,
                    contentText:
                        WMSLocalizations.i18n(context)!.menu_content_2_5_6 +
                            _text +
                            WMSLocalizations.i18n(context)!
                                .display_instruction_delete,
                    buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                    buttonRightText:
                        WMSLocalizations.i18n(context)!.delivery_note_10,
                    onPressedLeft: () {
                      //关闭对话框并返回true
                      Navigator.of(context).pop(true);
                    },
                    onPressedRight: () async {
                      //关闭对话框并返回true
                      Navigator.of(context).pop(true);

                      context
                          .read<ReserveInputBloc>()
                          .add(delectEvent(parentContext, _text));
                      // await SupabaseUtils.getClient()
                      //     .from("dtb_receive")
                      //     .delete()
                      //     .match({'id': 1}).select();
                      //删除成功刷新页面，重新获取数据
                    },
                  );
                },
              ));
        });
  }
}

_showDetailDialog(int flag, BuildContext context) {
  ReserveInputBloc bloc = context.read<ReserveInputBloc>();
  showDialog<bool>(
    context: context,
    builder: (context) {
      return BlocProvider<ReserveInputBloc>.value(
        value: bloc,
        child: BlocBuilder<ReserveInputBloc, ReserveInputModel>(
          builder: (context, state) {
            return AlertDialog(
              // 弹窗圆角
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    WMSLocalizations.i18n(context)!.delivery_note_8,
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: 10), // 添加一些水平间隔

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (state.customer['check_kbn'] != '1')
                          Container(
                            height: 36,
                            child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(44, 167, 176, 1),
                              ),
                              child: Text(
                                flag == 1
                                    ? WMSLocalizations.i18n(context)!
                                        .account_profile_registration
                                    : WMSLocalizations.i18n(context)!
                                        .instruction_input_tab_button_update,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                if (flag == 1) {
                                  // 登录出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      registrationReceiveDetailFormEvent(
                                          context,
                                          state.customer,
                                          state.receiveId));
                                } else {
                                  // 设定出荷指示值事件
                                  context.read<ReserveInputBloc>().add(
                                      SaveReceiveDetailFormEvent(
                                          context, state.customer));
                                }
                              },
                            ),
                          ),

                        SizedBox(width: 10), // 添加按钮之间的水平间隔
                        Container(
                          height: 36,
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                            onPressed: () {
                              // 关闭弹窗
                              Navigator.pop(context);
                            },
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .delivery_note_close,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              content: Container(
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * .8,
                  child: ListView(children: [
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Column(
                            children: [
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitle(
                                        WMSLocalizations.i18n(context)!
                                            .reserve_input_17),
                                    //入荷予定入力明細行
                                    WMSInputboxWidget(
                                      text: state.customer['receive_line_no']
                                          .toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'receive_line_no', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitleMust(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_3),
                                    //商品名
                                    WMSDropdownWidget(
                                      saveInput: true,
                                      dataList1: state.productList,
                                      inputInitialValue: state.customer['name'],
                                      inputRadius: 4,
                                      inputSuffixIcon: Container(
                                        width: 24,
                                        height: 24,
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 16, 0),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                      ),
                                      dropdownRadius: 4,
                                      dropdownTitle: 'name',
                                      selectedCallBack: (value) {
                                        if (value == '') {
                                          //其余相关商品信息赋值
                                          context
                                              .read<ReserveInputBloc>()
                                              .add(SaveOtherProductEvent({}));
                                        } else {
                                          //其余相关商品信息赋值
                                          context.read<ReserveInputBloc>().add(
                                              SaveOtherProductEvent(value));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitle(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_2),

                                    //商品コード
                                    WMSInputboxWidget(
                                      text: state.customer['code'].toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'code', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitleMust(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_4),
                                    //単価
                                    WMSInputboxWidget(
                                      text: state.customer['product_price']
                                          .toString(),
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'product_price', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Column(
                            children: [
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitleMust(
                                        WMSLocalizations.i18n(context)!
                                            .reserve_input_13),
                                    //入荷数量
                                    WMSInputboxWidget(
                                      text: state.customer['product_num']
                                          .toString(),
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'product_num', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitle(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_6),
                                    //規格
                                    WMSInputboxWidget(
                                      text: state.customer['size'].toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'size', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitle(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_11),
                                    //消費期限
                                    WMSInputboxWidget(
                                      text: state.customer['limit_date']
                                          .toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'limit_date', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitle(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_12),
                                    //ロット番号
                                    WMSInputboxWidget(
                                      text: state.customer['lot_no'].toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'lot_no', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Column(
                            children: [
                              Container(
                                height: 72,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailDialogTitle(
                                        WMSLocalizations.i18n(context)!
                                            .delivery_note_shipment_details_13),
                                    //シリアル
                                    WMSInputboxWidget(
                                      text: state.customer['serial_no']
                                          .toString(),
                                      readOnly: true,
                                      inputBoxCallBack: (value) {
                                        // 设定出荷指示值事件
                                        context.read<ReserveInputBloc>().add(
                                            SetReceiveValueEvent(
                                                'serial_no', value));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 204,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .menu_content_2_5_10),
                                //仕入先明細備考
                                WMSInputboxWidget(
                                  height: 136,
                                  maxLines: 5,
                                  text: state.customer['note1'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定出荷指示值事件
                                    context.read<ReserveInputBloc>().add(
                                        SetReceiveValueEvent('note1', value));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 204,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .instruction_input_form_detail_12),
                                //社内明細備考
                                WMSInputboxWidget(
                                  height: 136,
                                  maxLines: 5,
                                  text: state.customer['note2'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定出荷指示值事件
                                    context.read<ReserveInputBloc>().add(
                                        SetReceiveValueEvent('note2', value));
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 204,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_shipment_details_14),
                                //商品_写真１
                                Visibility(
                                  visible: state.customer['image1'] == null ||
                                      state.customer['image1'] == '',
                                  child: Image.asset(
                                    WMSICons.NO_IMAGE,
                                    width: 136,
                                    height: 136,
                                  ),
                                ),
                                Visibility(
                                  visible: state.customer['image1'] != null &&
                                      state.customer['image1'] != '',
                                  child: Image.network(
                                    state.customer['image1'].toString(),
                                    width: 136,
                                    height: 136,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 204,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_shipment_details_15),
                                //商品_写真2
                                Visibility(
                                  visible: state.customer['image2'] == null ||
                                      state.customer['image2'] == '',
                                  child: Image.asset(
                                    WMSICons.NO_IMAGE,
                                    width: 136,
                                    height: 136,
                                  ),
                                ),
                                Visibility(
                                  visible: state.customer['image2'] != null &&
                                      state.customer['image2'] != '',
                                  child: Image.network(
                                    state.customer['image2'].toString(),
                                    width: 136,
                                    height: 136,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 160,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_shipment_details_16),
                                //商品_社内備考１
                                WMSInputboxWidget(
                                  height: 136,
                                  maxLines: 5,
                                  text: state.customer['company_note1']
                                      .toString(),
                                  readOnly: true,
                                  inputBoxCallBack: (value) {
                                    // 设定出荷指示值事件
                                    context.read<ReserveInputBloc>().add(
                                        SetReceiveValueEvent(
                                            'company_note1', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 160,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_shipment_details_18),
                                //商品_社内備考2
                                WMSInputboxWidget(
                                  height: 136,
                                  maxLines: 5,
                                  text: state.customer['company_note2']
                                      .toString(),
                                  readOnly: true,
                                  inputBoxCallBack: (value) {
                                    // 设定出荷指示值事件
                                    context.read<ReserveInputBloc>().add(
                                        SetReceiveValueEvent(
                                            'company_note2', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 160,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_shipment_details_19),
                                //商品_注意備考1
                                WMSInputboxWidget(
                                  height: 136,
                                  maxLines: 5,
                                  text:
                                      state.customer['notice_note1'].toString(),
                                  readOnly: true,
                                  inputBoxCallBack: (value) {
                                    // 设定出荷指示值事件
                                    context.read<ReserveInputBloc>().add(
                                        SetReceiveValueEvent(
                                            'notice_note1', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 160,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailDialogTitle(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_shipment_details_17),
                                //商品_注意備考2
                                WMSInputboxWidget(
                                  height: 136,
                                  maxLines: 5,
                                  text:
                                      state.customer['notice_note2'].toString(),
                                  readOnly: true,
                                  inputBoxCallBack: (value) {
                                    // 设定出荷指示值事件
                                    context.read<ReserveInputBloc>().add(
                                        SetReceiveValueEvent(
                                            'notice_note2', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.3,
                          child: Container(
                            height: 160,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 160),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])),
            );
          },
        ),
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
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color.fromRGBO(6, 14, 15, 1),
      ),
    ),
  );
}

// 明细弹窗标题-必须入力
_detailDialogTitleMust(String title) {
  return Container(
    height: 24,
    child: Row(
      children: [
        Text(
          title,
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
  );
}
