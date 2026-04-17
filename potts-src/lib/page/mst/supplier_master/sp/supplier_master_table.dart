import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_bloc.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_model.dart';
import 'package:wms/widget/table/sp/wms_table_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/wms_dialog_widget.dart';

/**
* 内容：仕入先マスタ管理 -表格
 * 作者：王光顺
 * 时间：2023/11/22
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;

class SupplierMasterTable extends StatefulWidget {
  const SupplierMasterTable({super.key});

  @override
  State<SupplierMasterTable> createState() => _SupplierMasterTableState();
}

class _SupplierMasterTableState extends State<SupplierMasterTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierMasterBloc, SupplierMasterModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 40, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SupplierMasterTableTab(),
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
                        child: SupplierMasterInformationTableButton(),
                      ),
                      SupplierMasterTableContent(),
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

//tab
class SupplierMasterTableTab extends StatefulWidget {
  const SupplierMasterTableTab({super.key});

  @override
  State<SupplierMasterTableTab> createState() => _SupplierMasterTableTabState();
}

class _SupplierMasterTableTabState extends State<SupplierMasterTableTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, SupplierMasterModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Container(
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
        // ),
      );
    }
    // Tab列表
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierMasterBloc, SupplierMasterModel>(
      builder: (context, state) {
        // Tab单个列表
        List _tabItemList = [
          {
            //一览
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

class SupplierMasterInformationTableButton extends StatefulWidget {
  const SupplierMasterInformationTableButton({super.key});

  @override
  State<SupplierMasterInformationTableButton> createState() =>
      _SupplierMasterInformationTableButtonState();
}

class _SupplierMasterInformationTableButtonState
    extends State<SupplierMasterInformationTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, state) {
    List<DropdownMenuItem<String>> getListData() {
      List<DropdownMenuItem<String>> items = [];
      DropdownMenuItem<String> dropdownMenuItem1 = new DropdownMenuItem<String>(
        child: Container(
          width: double.infinity, // 设置宽度为无限
          child: Text(
            WMSLocalizations.i18n(context)!.supplier_id,
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
            WMSLocalizations.i18n(context)!.supplier_name,
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
            WMSLocalizations.i18n(context)!.supplie_zip_code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'postal_cd',
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
                                context.read<SupplierMasterBloc>().add(
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
                            context.read<SupplierMasterBloc>().add(SetSortEvent(
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
              List<Map<String, dynamic>> contentList = [];
              // 表格选中列表
              List<WmsRecordModel> wmsRecordModelList = state.checkedRecords();
              // 循环表格选中列表
              for (int i = 0; i < wmsRecordModelList.length; i++) {
                // 内容列表
                contentList.add(wmsRecordModelList[i].data);
              }
              Map<String, dynamic> value = {};
              GoRouter.of(context)
                  .push('/' + Config.PAGE_FLAG_8_10 + '/from/0')
                  .then((value) {
                // 判断返回值
                if (value == 'refresh return') {
                  // 初始化事件
                  context.read<SupplierMasterBloc>().add(InitEvent());
                }
              });
              ; //传递数据
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentParamAction(value));
              //页面取值
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(true));
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

    return BlocBuilder<SupplierMasterBloc, SupplierMasterModel>(
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
              ],
            ));
      },
    );
  }
}

//表格内容
class SupplierMasterTableContent extends StatefulWidget {
  const SupplierMasterTableContent({super.key});

  @override
  State<SupplierMasterTableContent> createState() =>
      _SupplierMasterTableContentState();
}

class _SupplierMasterTableContentState
    extends State<SupplierMasterTableContent> {
  // 初始化一覧表格
  // 删除弹窗
  _deleteDialog(int id, BuildContext parentContext) {
    SupplierMasterBloc bloc = context.read<SupplierMasterBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<SupplierMasterBloc>.value(
          value: bloc,
          child: BlocBuilder<SupplierMasterBloc, SupplierMasterModel>(
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
                      .read<SupplierMasterBloc>()
                      .add(DeleteSupplierDataEvent(parentContext, id));
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WMSTableWidget<SupplierMasterBloc, SupplierMasterModel>(
          showCheckboxColumn: false,
          operatePopupHeight: 180,
          columns: [
            {
              //仕入先id
              'key': 'id',
              'width': .2,
              'title': WMSLocalizations.i18n(context)!.supplier_id,
            },
            {
              //名称
              'key': 'name',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_name,
            },
            {
              //カナ名称
              'key': 'name_kana',
              'width': .4,
              'title': WMSLocalizations.i18n(context)!.supplier_kana,
            },
            {
              //略称
              'key': 'name_short',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_abbreviation,
            },
            {
              //郵便番号
              'key': 'postal_cd',
              'width': .4,
              'title': WMSLocalizations.i18n(context)!.supplie_zip_code,
            },
            {
              //都道府県
              'key': 'addr_1',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_province,
            },
            {
              //市区町村
              'key': 'addr_2',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_villages,
            },
            {
              //住所
              'key': 'addr_3',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_address,
            },
            {
              //電話番号
              'key': 'tel',
              'width': .5,
              'title':
                  WMSLocalizations.i18n(context)!.supplier_telephone_number,
            },
            {
              //FAX番号
              'key': 'fax',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_fax_number,
            },
            {
              //代表者名
              'key': 'owner_name',
              'width': .5,
              'title':
                  WMSLocalizations.i18n(context)!.supplier_representative_name,
            },
            {
              //担当者名
              'key': 'contact',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_contact_name,
            },
            {
              //担当者名 -電話番号
              'key': 'contact_tel',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!
                  .supplier_contact_telephone_number,
            },
            {
              //担当者名 -FAX番号
              'key': 'contact_fax',
              'width': .5,
              'title':
                  WMSLocalizations.i18n(context)!.supplier_contact_fax_number,
            },
            {
              //担当者名 -email
              'key': 'contact_email',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.supplier_contact_email,
            },
            {
              //会社名
              'key': 'company_name',
              'width': .5,
              'title': WMSLocalizations.i18n(context)!.company_information_2,
            },
          ],
          operatePopupOptions: [
            {
              //明細按钮
              'title': WMSLocalizations.i18n(context)!.delivery_note_8,
              'callback': (_, value) async {
                GoRouter.of(context)
                    .push('/' + Config.PAGE_FLAG_8_10 + '/from/2')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<SupplierMasterBloc>().add(InitEvent());
                  }
                });
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value)); //页面取值
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(true));
              },
            },
            {
              //修正按钮
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_tab_button_update,
              'callback': (_, value) async {
                GoRouter.of(context)
                    .push('/' + Config.PAGE_FLAG_8_10 + '/from/1')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<SupplierMasterBloc>().add(InitEvent());
                  }
                });
                //传递数据
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value)); //页面取值
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(true));
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
        )
      ],
    );
  }
}
