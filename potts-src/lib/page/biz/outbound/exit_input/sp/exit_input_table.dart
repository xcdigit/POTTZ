import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_bloc.dart';
import 'package:wms/page/biz/outbound/exit_input/bloc/exit_input_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:wms/widget/table/pc/wms_table_widget.dart';

/**
 * 内容：出庫入力-表格
 * 作者：張博睿
 * 时间：2023/11/02
 */
// 全局主键-表格共通

class ExitInputTable extends StatefulWidget {
  const ExitInputTable({super.key});

  @override
  State<ExitInputTable> createState() => _ExitInputTableState();
}

class _ExitInputTableState extends State<ExitInputTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExitInputBloc, ExitInputModel>(builder: (bloc, state) {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
        ),
        child: ExitInputTableContent(state: state),
      );
    });
  }
}

// 出庫入力-表格内容
// ignore: must_be_immutable
class ExitInputTableContent extends StatefulWidget {
  // 出庫入力-参数
  ExitInputModel state;
  ExitInputTableContent({super.key, required this.state});

  @override
  State<ExitInputTableContent> createState() => _ExitInputTableContentState();
}

class _ExitInputTableContentState extends State<ExitInputTableContent> {
  // 初始化一覧表格
  // List _tableContentList = [];

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
              context.read<ExitInputBloc>().add(RecordCheckAllEvent(true));
            } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
              // 全部取消
              context.read<ExitInputBloc>().add(RecordCheckAllEvent(false));
            } else {
              print('');
            }
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
    // List _buttonRightItemList = [
    //   {
    //     'index': Config.NUMBER_ZERO,
    //     'title': WMSLocalizations.i18n(context)!.exit_input_table_update,
    //   },
    //   {
    //     'index': Config.NUMBER_ONE,
    //     'title': WMSLocalizations.i18n(context)!.exit_input_table_delete,
    //   },
    // ];

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
                    children: [],
                  ),
                ),
              ),
            ],
          ),
        ),
        WMSTableWidget<ExitInputBloc, ExitInputModel>(
          columns: [
            {
              'key': 'id',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_1,
            },
            {
              'key': 'warehouse_no',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_2,
            },
            {
              'key': 'loc_cd',
              'width': 5,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_3,
            },
            {
              'key': 'code',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_4,
            },
            {
              'key': 'name',
              'width': 8,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_5,
            },
            {
              'key': 'product_price',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_6,
            },
            {
              'key': 'lock_num',
              'width': 2,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_7,
            },
            {
              'key': 'size',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_8,
            },
            {
              'key': 'count',
              'width': 3,
              'title': WMSLocalizations.i18n(context)!.exit_input_table_title_9,
            },
          ],
          operatePopupOptions: [
            {
              'title': WMSLocalizations.i18n(context)!.exit_input_table_update,
              'callback': (_, value) {
                context
                    .read<ExitInputBloc>()
                    .add(QueryTableDetails(context, value['pick_line_no']));
              },
            },
            {
              'title': WMSLocalizations.i18n(context)!.exit_input_table_delete,
              'callback': (_, value) {
                context
                    .read<ExitInputBloc>()
                    .add(QueryTableDetailShipKbn(value, context));
              },
            },
          ],
        ),
      ],
    );
  }
}
