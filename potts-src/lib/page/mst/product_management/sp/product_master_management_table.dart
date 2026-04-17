import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/style/wms_style.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../../../../widget/table/sp/wms_table_widget.dart';
import '../bloc/product_master_management_bloc.dart';
import '../bloc/product_master_management_model.dart';

/**
 * 内容：商品マスタ管理-表格
 * 作者：熊草云
 * 时间：2023/09/05
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class ProductMasterManagementTable extends StatefulWidget {
  const ProductMasterManagementTable({super.key});

  @override
  State<ProductMasterManagementTable> createState() =>
      _ProductMasterManagementTableState();
}

class _ProductMasterManagementTableState
    extends State<ProductMasterManagementTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductMasterManagementBloc,
        ProductMasterManagementModel>(
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
                      ProductMasterManagementTableContent(),
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
  List<Widget> _initTabList(
      List tabItemList, ProductMasterManagementModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          // onPanDown: (details) {
          //   // 状态变更
          //   setState(() {
          //     // 当前下标
          //     currentIndex = tabItemList[i]['index'];
          //   });
          // },
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
            decoration: BoxDecoration(
              color: state.tableTabIndex == tabItemList[i]['index']
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, 0.6)
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: state.tableTabIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : tabItemList == tabItemList[i]['index']
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(6, 14, 15, 1),
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
    return BlocBuilder<ProductMasterManagementBloc,
        ProductMasterManagementModel>(
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
          children: _initTabList(_tabItemList, state),
        );
      },
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
  // 删除弹窗
  _deleteDialog(int id, BuildContext parentContext) {
    ProductMasterManagementBloc bloc =
        context.read<ProductMasterManagementBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<ProductMasterManagementBloc>.value(
          value: bloc,
          child: BlocBuilder<ProductMasterManagementBloc,
              ProductMasterManagementModel>(
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
                  // 删除商品事件
                  context
                      .read<ProductMasterManagementBloc>()
                      .add(DeleteProductEvent(parentContext, id));
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

// 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, ProductMasterManagementModel state) {
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
                                context.read<ProductMasterManagementBloc>().add(
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
                            context.read<ProductMasterManagementBloc>().add(
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
      } else {}
    }
    // 按钮列表
    return buttonList;
  }

  // 初始化右侧按钮列表
  _initButtonRightList(
      List buttonItemList, ProductMasterManagementModel state) {
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
                        .push('/productMaster/details/0/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(InitEvent());
                      }
                    });
                  } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                    //标签打印 一次只能打印一个
                    // 判断选中数据
                    if (state.checkedRecords().length == 1) {
                      context
                          .read<ProductMasterManagementBloc>()
                          .add(PrinterProductEvent());
                    } else {
                      // 消息提示
                      WMSCommonBlocUtils.tipTextToast(
                          WMSLocalizations.i18n(context)!.menu_content_2_5_13);
                    }
                  }
                },
                child: Container(
                  height: 37,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                        buttonItemList[i]['icon'],
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

  // 获取表格数据
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductMasterManagementBloc,
        ProductMasterManagementModel>(
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
            'icon': WMSICons.MASTER_LOGIN_ICON,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_add,
          },
          //印刷按钮
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.WAREHOUSE_PRINTING_ICON,
            'title': WMSLocalizations.i18n(context)!.label_printing,
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
            WMSTableWidget<ProductMasterManagementBloc,
                ProductMasterManagementModel>(
              operatePopupHeight: 180,
              headTitle: 'id',
              columns: [
                {
                  //商品コード
                  'key': 'code',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_3,
                },
                {
                  //会社名
                  'key': 'company_name',
                  'width': 0.5,
                  'title':
                      WMSLocalizations.i18n(context)!.company_information_2,
                },
                {
                  //商品_名称
                  'key': 'name',
                  'width': 1.0,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_4,
                },
                {
                  //商品_略称
                  'key': 'name_short',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_product_abbreviation,
                },
                {
                  //商品_JANCD
                  'key': 'jan_cd',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_junk,
                },
                {
                  //商品_大分類
                  'key': 'category_l',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_major_categories,
                },
                {
                  //商品_中分類
                  'key': 'category_m',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_medium_classification,
                },
                {
                  //商品_小分類
                  'key': 'category_s',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_subclassification,
                },
                {
                  //商品規格
                  'key': 'size',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_5,
                },
                {
                  //商品荷姿
                  'key': 'packing_type',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_form_detail_1,
                },
                {
                  //入数
                  'key': 'packing_num',
                  'width': 0.5,
                  'title': WMSLocalizations.i18n(context)!
                      .product_master_management_quantity,
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
                        .push('/productMaster/details/' +
                            value['id'].toString() +
                            '/0')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(InitEvent());
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
                        .push('/productMaster/details/' +
                            value['id'].toString() +
                            '/1')
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(InitEvent());
                      }
                    });
                  },
                },
                {
                  //消除按钮
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) async {
                    //消除弹窗
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
}
