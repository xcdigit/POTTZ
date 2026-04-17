import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/current_param_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../bloc/form_master_detail_bloc.dart';
import '../bloc/form_master_detail_model.dart';

/**
 * 内容：帳票マスタ明细-表格
 * 作者：赵士淞
 * 时间：2023/12/25
 */
class FormMasterDetailTable extends StatefulWidget {
  const FormMasterDetailTable({super.key});

  @override
  State<FormMasterDetailTable> createState() => _FormMasterDetailTableState();
}

class _FormMasterDetailTableState extends State<FormMasterDetailTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormMasterDetailBloc, FormMasterDetailModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FormMasterDetailTableTab(),
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
                  child: FormMasterDetailTableContent(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 帳票マスタ明细-表格Tab
class FormMasterDetailTableTab extends StatefulWidget {
  const FormMasterDetailTableTab({super.key});

  @override
  State<FormMasterDetailTableTab> createState() =>
      _FormMasterDetailTableTabState();
}

class _FormMasterDetailTableTabState extends State<FormMasterDetailTableTab> {
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

// 帳票マスタ明细-表格内容
class FormMasterDetailTableContent extends StatefulWidget {
  const FormMasterDetailTableContent({super.key});

  @override
  State<FormMasterDetailTableContent> createState() =>
      _FormMasterDetailTableContentState();
}

class _FormMasterDetailTableContentState
    extends State<FormMasterDetailTableContent> {
  // 删除弹窗
  _deleteDialog(int id) {
    FormMasterDetailBloc bloc = context.read<FormMasterDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<FormMasterDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<FormMasterDetailBloc, FormMasterDetailModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .display_instruction_confirm_delete,
                contentText: WMSLocalizations.i18n(context)!.form_detail_title +
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
                  // 删除账票明细定制事件
                  context
                      .read<FormMasterDetailBloc>()
                      .add(DeleteFormDetailCustomizeEvent(id));
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

  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, FormMasterDetailModel state) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = buttonItemList[i]['index'];
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
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                Map<String, dynamic> value = {};
                // 数据存入
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));
                // 页面取值
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(true));
                // 登录按钮跳转页面
                GoRouter.of(context)
                    .push(
                        '/formMaster/details/adjust/' + state.formId.toString())
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context.read<FormMasterDetailBloc>().add(InitEvent());
                  }
                });
              }
            },
            child: Container(
              height: 37,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              decoration: BoxDecoration(
                color: _currentHoverIndex == buttonItemList[i]['index']
                    ? Color.fromRGBO(0, 122, 255, .6)
                    : Colors.white,
                border: Border.all(
                  color: _currentHoverIndex == buttonItemList[i]['index']
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
                      buttonItemList[i]['icon'],
                      width: 17,
                      height: 19.43,
                      color: _currentHoverIndex == buttonItemList[i]['index']
                          ? Colors.white
                          : Color.fromRGBO(0, 122, 255, 1),
                    ),
                  ),
                  Text(
                    buttonItemList[i]['title'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _currentHoverIndex == buttonItemList[i]['index']
                          ? Colors.white
                          : Color.fromRGBO(0, 122, 255, 1),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
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
    return BlocBuilder<FormMasterDetailBloc, FormMasterDetailModel>(
      builder: (context, state) {
        // 右侧按钮单个列表
        List _buttonRightItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.MASTER_LOGIN_ICON,
            'title': WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_add,
          },
        ];

        return Column(
          children: [
            Container(
              height: 37,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Stack(
                children: [
                  Container(),
                  Positioned(
                    right: 0,
                    child: Container(
                      child: Row(
                        children:
                            _initButtonRightList(_buttonRightItemList, state),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WMSTableWidget<FormMasterDetailBloc, FormMasterDetailModel>(
              columns: [
                // ID
                {
                  'key': 'id',
                  'width': 2,
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_title_8,
                },
                // 位置
                {
                  'key': 'location_title',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.form_location,
                },
                // 順序番号
                {
                  'key': 'sequence_number',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.form_sequence_number,
                },
                // 分類
                {
                  'key': 'assort_title',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.form_assort,
                },
                // 数式
                {
                  'key': 'form_formula',
                  'width': 8,
                  'title': WMSLocalizations.i18n(context)!.form_formula,
                },
                // フィールド名を表示
                {
                  'key': 'show_field_name_title',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.form_show_field_name,
                },
                // サイズ
                {
                  'key': 'word_size',
                  'width': 4,
                  'title': WMSLocalizations.i18n(context)!.form_word_size,
                },
              ],
              operatePopupOptions: [
                // 修正
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_tab_button_update,
                  'callback': (_, value) async {
                    // 数据存入
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentParamAction(value));
                    // 页面取值
                    StoreProvider.of<WMSState>(context)
                        .dispatch(RefreshCurrentFlagAction(true));
                    // 跳转页面
                    GoRouter.of(context)
                        .push('/formMaster/details/adjust/' +
                            state.formId.toString())
                        .then((value) {
                      // 判断返回值
                      if (value == 'refresh return') {
                        // 初始化事件
                        context.read<FormMasterDetailBloc>().add(InitEvent());
                      }
                    });
                  },
                },
                // 消除
                {
                  'title': WMSLocalizations.i18n(context)!
                      .instruction_input_table_operate_delete,
                  'callback': (_, value) async {
                    // 消除弹窗
                    _deleteDialog(value['id']);
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
