import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/redux/current_flag_reducer.dart';
import 'package:wms/widget/table/sp/wms_table_widget.dart';

import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../bloc/warehouse_master_bloc.dart';
import '../bloc/warehouse_master_model.dart';

/**
 * 内容：倉庫マスタ管理SP-表格
 * 作者：luxy
 * 时间：2023/11/21
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class WarehouseMasterTable extends StatefulWidget {
  const WarehouseMasterTable({super.key});

  @override
  State<WarehouseMasterTable> createState() => _WarehouseMasterTableState();
}

class _WarehouseMasterTableState extends State<WarehouseMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseMasterBloc, WarehouseMasterModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ProductMasterManagementTableTab(),
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
                      child: ProductMasterManagementTableButton(),
                    ),
                    ProductMasterManagementTableContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// -表格Tab
// ignore: must_be_immutable
class ProductMasterManagementTableTab extends StatefulWidget {
  ProductMasterManagementTableTab({
    super.key,
  });

  @override
  State<ProductMasterManagementTableTab> createState() =>
      _ProductMasterManagementTableTabState();
}

class _ProductMasterManagementTableTabState
    extends State<ProductMasterManagementTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            // 状态变更
            setState(() {
              // 当前下标
              currentIndex = tabItemList[i]['index'];
            });
          },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: tabItemList[i]['index'] == currentIndex
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(245, 245, 245, 1),
                    height: 1.5,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    height: 20,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        tabItemList[i]['number'].toString(),
                        style: TextStyle(
                          fontSize: 10,
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
    return BlocBuilder<WarehouseMasterBloc, WarehouseMasterModel>(
        builder: (context, state) {
      // Tab单个列表
      List _tabItemList = [
        {
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

// 表格按钮
class ProductMasterManagementTableButton extends StatefulWidget {
  const ProductMasterManagementTableButton({super.key});

  @override
  State<ProductMasterManagementTableButton> createState() =>
      _ProductMasterManagementTableButtonState();
}

class _ProductMasterManagementTableButtonState
    extends State<ProductMasterManagementTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.warehouse_master_1,
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
            WMSLocalizations.i18n(context)!.delivery_form_company,
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
            WMSLocalizations.i18n(context)!.warehouse_master_2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'code',
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
                                context.read<WarehouseMasterBloc>().add(
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
                            context.read<WarehouseMasterBloc>().add(
                                SetSortEvent(
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
                Map<String, dynamic> value = {};
                //数据存入
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));
                //页面取值
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(true));
                // 登录按钮跳转页面
                GoRouter.of(context)
                    .push('/' + Config.PAGE_FLAG_8_19 + '/details/0/1')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<WarehouseMasterBloc>().add(InitEvent());
                  }
                });
              } else {
                print('');
              }
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
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
                    // width: 17,
                    height: 17,
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                  Text(
                    buttonItemList[i]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(0, 122, 255, 1),
                      height: 1.4,
                    ),
                  ),
                ],
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
      //登録
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_add,
        'sort': false,
      },
      {
        'index': Config.NUMBER_THREE,
        'title': WMSLocalizations.i18n(context)!.table_sort_column,
        'sort': true,
      },
    ];
    return BlocBuilder<WarehouseMasterBloc, WarehouseMasterModel>(
      builder: (context, state) => Container(
        height: 37,
        child: Container(
          child: Row(
            children: _initButtonLeftList(_buttonLeftItemList, state),
          ),
        ),
      ),
    );
  }
}

// -表格内容
class ProductMasterManagementTableContent extends StatefulWidget {
  const ProductMasterManagementTableContent({super.key});

  @override
  State<ProductMasterManagementTableContent> createState() =>
      _ProductMasterManagementTableContentState();
}

class _ProductMasterManagementTableContentState
    extends State<ProductMasterManagementTableContent> {
  // 获取表格数据

  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<WarehouseMasterBloc, WarehouseMasterModel>(
      columns: [
        {
          'key': 'id',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.warehouse_master_1,
        },
        // 赵士淞 - 始
        {
          'key': 'company_name',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.delivery_form_company,
        },
        // 赵士淞 - 终
        {
          'key': 'code',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.warehouse_master_2,
        },
        {
          'key': 'name',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.warehouse_master_3,
        },
        {
          'key': 'name_short',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.warehouse_master_7,
        },
        {
          'key': 'kbn',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.warehouse_master_4,
        },
        {
          'key': 'area',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.warehouse_master_5,
        },
        {
          'key': 'postal_cd',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.customer_master_5,
        },
        {
          'key': 'addr_1',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.customer_master_6,
        },
        {
          'key': 'addr_2',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.customer_master_7,
        },
        {
          'key': 'addr_3',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.customer_master_8,
        },
        {
          'key': 'tel',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.customer_master_9,
        },
        {
          'key': 'fax',
          'width': 0.5,
          'title': WMSLocalizations.i18n(context)!.customer_master_10,
        },
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
                    Config.PAGE_FLAG_8_19 +
                    '/details/' +
                    value['id'].toString() +
                    '/0')
                .then((value) {
              // 判断返回值
              if (value == 'refresh return') {
                // 初始化事件
                context.read<WarehouseMasterBloc>().add(InitEvent());
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
                    Config.PAGE_FLAG_8_19 +
                    '/details/' +
                    value['id'].toString() +
                    '/1')
                .then((value) {
              // 判断返回值
              if (value == 'refresh return') {
                // 初始化事件
                context.read<WarehouseMasterBloc>().add(InitEvent());
              }
            });
          },
        },
      ],
    );
  }
}
