import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_bloc.dart';
import 'package:wms/page/mst/customer_master/bloc/customer_master_model.dart';
import 'package:wms/redux/current_param_reducer.dart';
import 'package:wms/widget/table/sp/wms_table_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dialog_widget.dart';

/**
 * 内容：得意先マスタ管理-表格
 * 作者：王光顺
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class CustomerMasterTable extends StatefulWidget {
  const CustomerMasterTable({super.key});

  @override
  State<CustomerMasterTable> createState() => _CustomerMasterTableState();
}

class _CustomerMasterTableState extends State<CustomerMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerMasterBloc, CustomerMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CustomerMasterTableTab(),
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
                      CustomerMasterTableContent(),
                    ],
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

// -表格Tab
// ignore: must_be_immutable
class CustomerMasterTableTab extends StatefulWidget {
  CustomerMasterTableTab({
    super.key,
  });

  @override
  State<CustomerMasterTableTab> createState() => _CustomerMasterTableTabState();
}

class _CustomerMasterTableTabState extends State<CustomerMasterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(List tabItemList, CustomerMasterModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          child: Container(
            height: 46,
            padding: EdgeInsets.fromLTRB(12, 11, 12, 11),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: state.tableTabIndex == tabItemList[i]['index']
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            constraints: BoxConstraints(
              minWidth: 108,
            ),
            child: Stack(
              children: [
                Text(
                  tabItemList[i]['title'],
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(255, 255, 255, 1),
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
    return BlocBuilder<CustomerMasterBloc, CustomerMasterModel>(
      builder: (context, state) {
        // Tab单个列表
        List _tabItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!.customer_master_19,
            'number': state.total,
          },
        ];

        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// -表格内容
class CustomerMasterTableContent extends StatefulWidget {
  const CustomerMasterTableContent({super.key});

  @override
  State<CustomerMasterTableContent> createState() =>
      _CustomerMasterTableContentState();
}

class _CustomerMasterTableContentState
    extends State<CustomerMasterTableContent> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, CustomerMasterModel state) {
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
            WMSLocalizations.i18n(context)!.customer_master_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'name',
      );
      items.add(dropdownMenuItem2);
      DropdownMenuItem<String> dropdownMenuItem3 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.customer_master_20,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'corporation_number',
      );
      items.add(dropdownMenuItem3);
      DropdownMenuItem<String> dropdownMenuItem4 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.customer_master_5,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'postal_cd',
      );
      items.add(dropdownMenuItem4);
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
                                context.read<CustomerMasterBloc>().add(
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
                            context.read<CustomerMasterBloc>().add(SetSortEvent(
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
      } else {}
    }
    // 按钮列表
    return buttonList;
  }

  // 获取表格数据

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerMasterBloc, CustomerMasterModel>(
      builder: (context, state) {
        // 左侧按钮单个列表
        List _buttonLeftItemList = [
          {
            'index': Config.NUMBER_THREE,
            'title': WMSLocalizations.i18n(context)!.table_sort_column,
            'sort': true,
          },
        ];
        // 右侧按钮单个列表
        List _buttonRightItemList = [
          //登录新增按钮
          {
            'index': Config.NUMBER_ZERO,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_add,
          },
        ];

        return Column(
          children: [
            Container(
              // height: 95,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children:
                            _initButtonRightList(_buttonRightItemList, state),
                      ),
                    ),
                    Container(
                      child: SizedBox(height: 10, width: double.infinity),
                    ),
                    Container(
                      // right: 0,
                      child: Container(
                        child: Wrap(
                          children:
                              _initButtonLeftList(_buttonLeftItemList, state),
                        ),
                      ),
                    )
                  ]),
            ),
            WMSTableWidget<CustomerMasterBloc, CustomerMasterModel>(
              operatePopupHeight: 170,
              headTitle: 'id',
              columns: [
                {
                  //得意先id
                  'key': 'id',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_1,
                },
                {
                  //名称
                  'key': 'name',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_2,
                },
                {
                  //カナ名称
                  'key': 'name_kana',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_3,
                },
                {
                  //略称
                  'key': 'name_short',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_4,
                },
                {
                  // 法人番号
                  'key': 'corporation_number',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_20,
                },
                {
                  //郵便番号
                  'key': 'postal_cd',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_5,
                },
                {
                  // 大分類
                  'key': 'classify_1',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_21,
                },
                {
                  // 中分類
                  'key': 'classify_2',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_22,
                },
                {
                  // 小分類
                  'key': 'classify_3',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_23,
                },
                {
                  // 国
                  'key': 'country',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_24,
                },
                {
                  // 地域
                  'key': 'region',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_25,
                },
                {
                  //都道府県
                  'key': 'addr_1',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_6,
                },
                {
                  //市区町村
                  'key': 'addr_2',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_7,
                },
                {
                  //住所
                  'key': 'addr_3',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_29,
                },
                {
                  // 住所詳細2
                  'key': 'addr_4',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_26,
                },
                {
                  //電話番号
                  'key': 'tel',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_9,
                },
                {
                  //FAX番号
                  'key': 'fax',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_10,
                },
                {
                  //代表者名
                  'key': 'owner_name',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_11,
                },
                {
                  //担当者名
                  'key': 'contact',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_12,
                },
                {
                  //担当者名 -電話番号
                  'key': 'contact_tel',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_13,
                },
                {
                  //担当者名 -FAX番号
                  'key': 'contact_fax',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_14,
                },
                {
                  //担当者名 -email
                  'key': 'contact_email',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_15,
                },
                {
                  // 適用開始日
                  'key': 'application_start_date',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_27,
                },
                {
                  // 適用終了日
                  'key': 'application_end_date',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_28,
                },
                {
                  // 消費期限
                  'key': 'limit_date',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_31,
                },
                {
                  // 消費期限制御
                  'key': 'limit_date_flg_name',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!.customer_master_32,
                },
                // {
                //   //会社名
                //   'key': 'company_name',
                //   'width': 0.5,
                //   'title':
                //       WMSLocalizations.i18n(context)!.company_information_2,
                // },
              ],
              operatePopupOptions: [
                {
                  //明細按钮
                  'title': WMSLocalizations.i18n(context)!.delivery_note_8,
                  'callback': (_, value) async {
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/' +
                            Config.PAGE_FLAG_8_6 +
                            '/details/' +
                            value['id'].toString() +
                            '/0')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CustomerMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //修正按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) async {
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/' +
                            Config.PAGE_FLAG_8_6 +
                            '/details/' +
                            value['id'].toString() +
                            '/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CustomerMasterBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //删除按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) async {
                    // 删除弹窗
                    _deleteDialog(value['id'], context);
                  },
                },
              ],
            ),
          ],
        );
      },
    );
  }

// 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, CustomerMasterModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 将_stop变量移至循环内部
      bool _stop = false;
      // 按钮列表
      buttonList.add(
        StatefulBuilder(
          builder: (context, setState) {
            // 使用StatefulBuilder包裹每个按钮
            return MouseRegion(
              onEnter: (event) {
                setState(() {
                  _stop = true;
                });
              },
              onExit: (event) {
                setState(() {
                  _stop = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  // 判断循环下标
                  if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                    Map<String, dynamic> value = {};
                    //数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    //页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 登录按钮跳转页面
                    GoRouter.of(context)
                        .push('/' + Config.PAGE_FLAG_8_6 + '/details/0/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<CustomerMasterBloc>().add(InitEvent());
                      }
                    });
                  }
                },
                child: Container(
                  height: 37,
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        WMSICons.MASTER_LOGIN_ICON,
                        height: 17,
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                      Text(
                        buttonItemList[i]['title'],
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
            );
          },
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  // 删除弹窗
  _deleteDialog(int id, BuildContext parentContext) {
    CustomerMasterBloc bloc = context.read<CustomerMasterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<CustomerMasterBloc>.value(
          value: bloc,
          child: BlocBuilder<CustomerMasterBloc, CustomerMasterModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .instruction_input_table_title_8 +
                    '：' +
                    id.toString() +
                    ' ' +
                    WMSLocalizations.i18n(context)!.display_instruction_delete,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText:
                    WMSLocalizations.i18n(context)!.delivery_note_10,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  // 删除出荷指示明细事件
                  context
                      .read<CustomerMasterBloc>()
                      .add(DeleteCustomerDataEvent(parentContext, id));
                  // 关闭弹窗
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
