import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/redux/current_flag_reducer.dart';

import '../../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../redux/current_param_reducer.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/sp/wms_table_widget.dart';
import '../../../../../widget/wms_dialog_widget.dart';

import '../../../../home/bloc/home_menu_bloc.dart';
import '../../../../home/bloc/home_menu_model.dart';
import '../bloc/instruction_input_bloc.dart' as instruction_input_bloc;
import '../bloc/instruction_input_model.dart';

/**
 * 内容：出荷指示入力-表格
 * 作者：luxy
 * 时间：2023/11/01
 */
// ignore: must_be_immutable
class InstructionInputTable extends StatefulWidget {
  // 出荷指示ID
  int shipId;
  InstructionInputTable({super.key, this.shipId = Config.NUMBER_NEGATIVE});

  @override
  State<InstructionInputTable> createState() => _InstructionInputTableState();
}

class _InstructionInputTableState extends State<InstructionInputTable> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<instruction_input_bloc.InstructionInputBloc>(
      create: (context) {
        return instruction_input_bloc.InstructionInputBloc(
          InstructionInputModel(
            rootContext: context,
            shipId: widget.shipId,
          ),
        );
      },
      child: BlocBuilder<instruction_input_bloc.InstructionInputBloc,
          InstructionInputModel>(
        builder: (context, state) {
          return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
              builder: (menuContext, menuState) {
            return Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ListView(
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
                      child: Column(
                        children: [
                          //表格内容
                          InstructionInputTableContent(
                            state: state,
                          ),
                          //明细行追加按钮
                          GestureDetector(
                            onTap: () async {
                              //判断是否已经引当
                              if (state.shipCustomize['ship_kbn'] != '0' &&
                                  state.shipCustomize['ship_kbn'] != '1') {
                                WMSCommonBlocUtils.tipTextToast(
                                    WMSLocalizations.i18n(state.rootContext)!
                                        .display_instruction_tip3);
                                return;
                              } else {
                                Map<String, dynamic> value = {};
                                //出荷指示明细存入
                                StoreProvider.of<WMSState>(context)
                                    .dispatch(RefreshCurrentParamAction(value));
                                //是否刷新
                                StoreProvider.of<WMSState>(context)
                                    .dispatch(RefreshCurrentFlagAction(true));
                                //跳转明细页面
                                GoRouter.of(context)
                                    .push('/instructioninput/' +
                                        state.shipId.toString() +
                                        '/table' +
                                        '/details' +
                                        '/0')
                                    .then((value) {
                                  // 判断返回值
                                  if (value == 'refresh return') {
                                    // 初始化事件
                                    context
                                        //重新加载页面
                                        .read<
                                            instruction_input_bloc
                                                .InstructionInputBloc>()
                                        .add(
                                            instruction_input_bloc.InitEvent());
                                  }
                                });
                                // context.read<HomeMenuBloc>().add(PageJumpEvent(
                                //     '/instructioninput/' +
                                //         state.shipId.toString() +
                                //         '/table' +
                                //         '/details' +
                                //         '/0'));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add, // 使用自带的加号图标
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    WMSLocalizations.i18n(context)!
                                        .reserve_input_15,
                                    style: TextStyle(
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
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
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 60,
              ),
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
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
  // 删除弹窗
  _deleteDialog(int id) {
    instruction_input_bloc.InstructionInputBloc bloc =
        context.read<instruction_input_bloc.InstructionInputBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<instruction_input_bloc.InstructionInputBloc>.value(
          value: bloc,
          child: BlocBuilder<instruction_input_bloc.InstructionInputBloc,
              InstructionInputModel>(
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
                      .read<instruction_input_bloc.InstructionInputBloc>()
                      .add(instruction_input_bloc.DeleteShipDetailEvent(id));
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
        WMSTableWidget<instruction_input_bloc.InstructionInputBloc,
            InstructionInputModel>(
          columns: [
            {
              'key': 'id',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_8,
            },
            {
              'key': 'product_code',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_3,
            },
            {
              'key': 'product_name',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_4,
            },
            {
              'key': 'product_price',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_9,
            },
            {
              'key': 'ship_num',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_6,
            },
            {
              'key': 'product_size',
              'width': 0.5,
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_5,
            },
          ],
          operatePopupOptions: [
            {
              'title': WMSLocalizations.i18n(context)!
                  .instruction_input_table_operate_detail,
              'callback': (_, value) async {
                //出荷指示明细存入
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentParamAction(value));
                //是否刷新
                StoreProvider.of<WMSState>(context)
                    .dispatch(RefreshCurrentFlagAction(true));
                //跳转明细页面
                // context.read<HomeMenuBloc>().add(PageJumpEvent(
                //     '/instructioninput/' +
                //         value['ship_id'].toString() +
                //         '/table' +
                //         '/details' +
                //         '/1'));
                //跳转明细页面
                GoRouter.of(context)
                    .push('/instructioninput/' +
                        value['ship_id'].toString() +
                        '/table' +
                        '/details' +
                        '/1')
                    .then((value) {
                  // 判断返回值
                  if (value == 'refresh return') {
                    // 初始化事件
                    context
                        //重新加载页面
                        .read<instruction_input_bloc.InstructionInputBloc>()
                        .add(instruction_input_bloc.InitEvent());
                  }
                });
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
