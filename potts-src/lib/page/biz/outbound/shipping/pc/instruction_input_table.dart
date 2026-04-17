import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';

import '../bloc/instruction_input_bloc.dart';
import '../bloc/instruction_input_model.dart';

/**
 * 内容：出荷指示入力-表格
 * 作者：赵士淞
 * 时间：2023/08/03
 */
class InstructionInputTable extends StatefulWidget {
  const InstructionInputTable({super.key});

  @override
  State<InstructionInputTable> createState() => _InstructionInputTableState();
}

class _InstructionInputTableState extends State<InstructionInputTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 80, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: InstructionInputTableTab(),
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
                  child: InstructionInputTableContent(
                    state: state,
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

// 出荷指示入力-表格Tab
class InstructionInputTableTab extends StatefulWidget {
  const InstructionInputTableTab({super.key});

  @override
  State<InstructionInputTableTab> createState() =>
      _InstructionInputTableTabState();
}

class _InstructionInputTableTabState extends State<InstructionInputTableTab> {
  // 当前下标
  int currentIndex = Config.NUMBER_ZERO;
  // 当前悬停下标
  int currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
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
              currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 状态变更
              setState(() {
                // 当前下标
                currentIndex = tabItemList[i]['index'];
              });
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
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
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(6, 14, 15, 1),
                  height: 1.0,
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
        'title': WMSLocalizations.i18n(context)!.instruction_input_tab_list,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 出荷指示入力-表格内容
// ignore: must_be_immutable
class InstructionInputTableContent extends StatefulWidget {
  // 出荷指示入力-参数
  InstructionInputModel state;

  InstructionInputTableContent({super.key, required this.state});

  @override
  State<InstructionInputTableContent> createState() =>
      _InstructionInputTableContentState();
}

class _InstructionInputTableContentState
    extends State<InstructionInputTableContent> {
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
              context
                  .read<InstructionInputBloc>()
                  .add(RecordCheckAllEvent(true));
            } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
              // 全部取消
              context
                  .read<InstructionInputBloc>()
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
    // 按钮列表
    return buttonList;
  }

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 37,
          margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: TextButton.icon(
            onPressed: () async {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 查询出荷指示明细事件
                bool tempBool = await context
                    .read<InstructionInputBloc>()
                    .queryShipDetailEvent(0);
                // 判断临时标记
                if (tempBool) {
                  // 显示明细弹窗
                  _showDetailDialog(0);
                }
              } else {}
            },
            icon: Icon(
              buttonItemList[i]['icon'],
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
            label: Text(
              buttonItemList[i]['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(44, 167, 176, 1),
                height: 1.4,
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  // 显示明细弹窗
  _showDetailDialog(int buttonFlag) {
    InstructionInputBloc bloc = context.read<InstructionInputBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InstructionInputBloc>.value(
          value: bloc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_detail,
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
                            Color.fromRGBO(44, 167, 176, 1),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(90, 36),
                          ),
                        ),
                        onPressed: () {
                          if (buttonFlag == 1 &&
                              bloc.state.shipCustomize['ship_kbn'] != '0' &&
                              bloc.state.shipCustomize['ship_kbn'] != '1') {
                            WMSCommonBlocUtils.tipTextToast(
                                WMSLocalizations.i18n(bloc.state.rootContext)!
                                    .display_instruction_tip4);
                          } else {
                            // 保存出荷指示明细表单事件
                            bloc.add(SaveShipDetailFormEvent(
                                context, bloc.state.shipDetailCustomize));
                          }
                        },
                        child: Text(
                          buttonFlag == 1
                              ? WMSLocalizations.i18n(context)!
                                  .instruction_input_tab_button_update
                              : WMSLocalizations.i18n(context)!
                                  .instruction_input_tab_button_add,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
                          Navigator.pop(context);
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
                  ),
                ),
              ],
            ),
            content: Container(
              width: 1072,
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
              child: _showDetailDialogContent(),
            ),
          ),
        );
      },
    );
  }

  // 显示明细弹窗详情
  _showDetailDialogContent() {
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
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
                        // // 出荷倉庫
                        // _detailDialogTitle(WMSLocalizations.i18n(context)!
                        //     .instruction_input_table_title_2, false),
                        // WMSDropdownWidget(
                        //   dataList1: state.warehouseList,
                        //   inputInitialValue: state
                        //       .shipDetailCustomize['warehouse_name']
                        //       .toString(),
                        //   inputRadius: 4,
                        //   inputSuffixIcon: Container(
                        //     width: 24,
                        //     height: 24,
                        //     margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        //     child: Icon(
                        //       Icons.keyboard_arrow_down_rounded,
                        //     ),
                        //   ),
                        //   inputFontSize: 14,
                        //   dropdownRadius: 4,
                        //   dropdownTitle: 'name',
                        //   selectedCallBack: (value) {
                        //     // 设定出荷指示明细值事件
                        //     context.read<InstructionInputBloc>().add(
                        //         SetShipDetailValueEvent(
                        //             'warehouse_no', value['id']));
                        //     context.read<InstructionInputBloc>().add(
                        //         SetShipDetailValueEvent(
                        //             'warehouse_name', value['name']));
                        //   },
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 16),
                        // ),
                        // 商品名
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_4,
                            true),
                        WMSDropdownWidget(
                          dataList1: state.productList,
                          inputInitialValue: state
                              .shipDetailCustomize['product_name']
                              .toString(),
                          inputRadius: 4,
                          inputSuffixIcon: Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                          ),
                          inputFontSize: 14,
                          dropdownRadius: 4,
                          dropdownTitle: 'name',
                          selectedCallBack: (value) {
                            // 判断数值
                            if (value == '') {
                              // 设定出荷指示明细集合事件
                              context
                                  .read<InstructionInputBloc>()
                                  .add(SetShipDetailMapEvent({
                                    'product_id': value,
                                    'product_code': value,
                                    'product_name': value,
                                    'product_size': value,
                                    'product_image1': value,
                                    'product_image2': value,
                                    'product_company_note1': value,
                                    'product_company_note2': value,
                                    'product_notice_note1': value,
                                    'product_notice_note2': value,
                                  }));
                            } else if (value is String) {
                              // 设定出荷指示明细值事件
                              context.read<InstructionInputBloc>().add(
                                  SetShipDetailValueEvent(
                                      'product_name', value));
                            } else {
                              // 设定出荷指示明细集合事件
                              context
                                  .read<InstructionInputBloc>()
                                  .add(SetShipDetailMapEvent({
                                    'product_id': value['id'],
                                    'product_code': value['code'],
                                    'product_name': value['name'],
                                    'product_size': value['size'],
                                    'product_image1': value['image1'],
                                    'product_image2': value['image2'],
                                    'product_company_note1':
                                        value['company_note1'],
                                    'product_company_note2':
                                        value['company_note2'],
                                    'product_notice_note1':
                                        value['notice_note1'],
                                    'product_notice_note2':
                                        value['notice_note2'],
                                  }));
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 出荷指示数
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_13,
                            true),
                        WMSInputboxWidget(
                          text:
                              state.shipDetailCustomize['ship_num'].toString(),
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent('ship_num', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        //
                        _detailDialogTitle('', false),
                        Container(
                          height: 48,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        //
                        _detailDialogTitle('', false),
                        Container(
                          height: 48,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 得意先明細備考
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_9,
                            false),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state.shipDetailCustomize['note1'].toString(),
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context
                                .read<InstructionInputBloc>()
                                .add(SetShipDetailValueEvent('note1', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品社内備考2
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_18,
                            false),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state
                              .shipDetailCustomize['product_company_note2']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent(
                                    'product_company_note2', value));
                          },
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
                        // 商品コード
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_3,
                            false),
                        WMSInputboxWidget(
                          text: state.shipDetailCustomize['product_code']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent('product_code', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 単価
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_9,
                            true),
                        WMSInputboxWidget(
                          text: state.shipDetailCustomize['product_price']
                              .toString(),
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent(
                                    'product_price', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 規格
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_table_title_5,
                            false),
                        WMSInputboxWidget(
                          text: state.shipDetailCustomize['product_size']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent('product_size', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        //
                        _detailDialogTitle('', false),
                        Container(
                          height: 48,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 社内明細備考
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_12,
                            false),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state.shipDetailCustomize['note2'].toString(),
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context
                                .read<InstructionInputBloc>()
                                .add(SetShipDetailValueEvent('note2', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品注意備考1
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_19,
                            false),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state
                              .shipDetailCustomize['product_notice_note1']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent(
                                    'product_notice_note1', value));
                          },
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
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_5,
                            false),
                        Visibility(
                          visible: state
                                      .shipDetailCustomize['product_image1'] ==
                                  null ||
                              state.shipDetailCustomize['product_image1'] == '',
                          child: Image.asset(
                            WMSICons.NO_IMAGE,
                            width: 136,
                            height: 136,
                          ),
                        ),
                        Visibility(
                          visible: state
                                      .shipDetailCustomize['product_image1'] !=
                                  null &&
                              state.shipDetailCustomize['product_image1'] != '',
                          child: Image.network(
                            state.shipDetailCustomize['product_image1']
                                .toString(),
                            width: 136,
                            height: 136,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品写真2
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_6,
                            false),
                        Visibility(
                          visible: state
                                      .shipDetailCustomize['product_image2'] ==
                                  null ||
                              state.shipDetailCustomize['product_image2'] == '',
                          child: Image.asset(
                            WMSICons.NO_IMAGE,
                            width: 136,
                            height: 136,
                          ),
                        ),
                        Visibility(
                          visible: state
                                      .shipDetailCustomize['product_image2'] !=
                                  null &&
                              state.shipDetailCustomize['product_image2'] != '',
                          child: Image.network(
                            state.shipDetailCustomize['product_image2']
                                .toString(),
                            width: 136,
                            height: 136,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品社内備考1
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_17,
                            false),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state
                              .shipDetailCustomize['product_company_note1']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent(
                                    'product_company_note1', value));
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                        ),
                        // 商品注意備考2
                        _detailDialogTitle(
                            WMSLocalizations.i18n(context)!
                                .instruction_input_form_detail_20,
                            false),
                        WMSInputboxWidget(
                          height: 136,
                          maxLines: 5,
                          text: state
                              .shipDetailCustomize['product_notice_note2']
                              .toString(),
                          readOnly: true,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示明细值事件
                            context.read<InstructionInputBloc>().add(
                                SetShipDetailValueEvent(
                                    'product_notice_note2', value));
                          },
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
  _detailDialogTitle(String title, bool required) {
    return Container(
      height: 24,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color.fromRGBO(6, 14, 15, 1),
            ),
          ),
          Visibility(
            visible: required,
            child: Text(
              "*",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(255, 0, 0, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 删除弹窗
  _deleteDialog(int id) {
    InstructionInputBloc bloc = context.read<InstructionInputBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<InstructionInputBloc>.value(
          value: bloc,
          child: BlocBuilder<InstructionInputBloc, InstructionInputModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!
                        .instruction_input_table_operate_detail +
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
                      .read<InstructionInputBloc>()
                      .add(DeleteShipDetailEvent(id));
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
        'icon': Icons.add,
        'title': WMSLocalizations.i18n(context)!
            .instruction_input_tab_button_details_add,
      },
    ];

    return Column(
      children: [
        Container(
          height: 37,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
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
                    children: _initButtonRightList(_buttonRightItemList),
                  ),
                ),
              ),
            ],
          ),
        ),
        WMSTableWidget<InstructionInputBloc, InstructionInputModel>(
          columns: [
            {
              'key': 'id',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_8,
            },
            // {
            //   'key': 'warehouse_name',
            //   'width': 4,
            //   'title': WMSLocalizations.i18n(context)!
            //       .instruction_input_table_title_2,
            // },
            {
              'key': 'product_code',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_3,
            },
            {
              'key': 'product_name',
              'width': 8,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_4,
            },
            {
              'key': 'product_price',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_9,
            },
            {
              'key': 'ship_num',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_6,
            },
            {
              'key': 'product_size',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_5,
            },
          ],
          operatePopupOptions: [
            {
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_operate_detail,
              'callback': (_, value) async {
                // 查询出荷指示明细事件
                bool tempBool = await context
                    .read<InstructionInputBloc>()
                    .queryShipDetailEvent(value['id']);
                // 判断临时标记
                if (tempBool) {
                  // 显示明细弹窗
                  _showDetailDialog(1);
                }
              },
            },
            {
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_operate_delete,
              'callback': (_, value) {
                if (value['lock_kbn'] != '1') {
                  // 删除弹窗
                  _deleteDialog(value['id']);
                } else {
                  WMSCommonBlocUtils.tipTextToast(
                      WMSLocalizations.i18n(context)!.display_instruction_tip2);
                }
              },
            }
          ],
        ),
      ],
    );
  }
}
