import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../bloc/start_inventory_bloc.dart';
import '../bloc/start_inventory_model.dart';

/**
 * 内容：棚卸開始-文件
 * 作者：熊草云
 * 时间：2023/08/28
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
List currentContent = [];
List currentContent_1 = [];

class StartInventoryTable extends StatefulWidget {
  const StartInventoryTable({super.key});

  @override
  State<StartInventoryTable> createState() => _StartInventoryTableState();
}

class _StartInventoryTableState extends State<StartInventoryTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartInventoryBloc, StartInventoryModel>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.fromLTRB(20, 40, 20, 80),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 24,
                  child: Text(
                    WMSLocalizations.i18n(context)!.start_inventory_list,
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
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
                        child: StartInventoryTableButton(),
                      ),
                      StartInventoryTableContent(),
                      Divider(),
                    ],
                  ),
                ),
              ),
              // 登录
              Container(
                margin: EdgeInsets.only(top: 40),
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(44, 167, 176, 1),
                    ), // 设置按钮背景颜色
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // 设置按钮文本颜色
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(120, 48),
                    ), // 设置按钮宽度和高度
                  ),
                  child: Text(WMSLocalizations.i18n(context)!
                      .account_profile_registration),
                  onPressed: () {
                    context
                        .read<StartInventoryBloc>()
                        .add(RegistrationEvent(context));
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

// 出荷确定-表格按钮

class StartInventoryTableButton extends StatefulWidget {
  const StartInventoryTableButton({super.key});

  @override
  State<StartInventoryTableButton> createState() =>
      _StartInventoryTableButtonState();
}

class _StartInventoryTableButtonState extends State<StartInventoryTableButton> {
  // 初始化左侧按钮列表
  _initButtonLeftList(List buttonItemList, StartInventoryModel state) {
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
            WMSLocalizations.i18n(context)!.start_inventory_location_code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        value: 'loc_cd',
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
                                context.read<StartInventoryBloc>().add(
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
                            context.read<StartInventoryBloc>().add(SetSortEvent(
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
                context
                    .read<StartInventoryBloc>()
                    .add(RecordCheckAllEvent(true));
                // 全部选择
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                context
                    .read<StartInventoryBloc>()
                    .add(RecordCheckAllEvent(false));
                // 全部取消
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
    return BlocBuilder<StartInventoryBloc, StartInventoryModel>(
        builder: (context, state) {
      // 左侧按钮单个列表
      List _buttonLeftItemList = [
        {
          'index': Config.NUMBER_ZERO,
          'title': WMSLocalizations.i18n(context)!
              .instruction_input_tab_button_choice,
          'sort': false,
        },
        {
          'index': Config.NUMBER_ONE,
          'title': WMSLocalizations.i18n(context)!
              .instruction_input_tab_button_cancellation,
          'sort': false,
        },
        {
          'index': Config.NUMBER_THREE,
          'title': WMSLocalizations.i18n(context)!.table_sort_column,
          'sort': true,
        },
      ];

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
        ),
      );
    });
  }
}

//出荷确定-表格内容
class StartInventoryTableContent extends StatefulWidget {
  const StartInventoryTableContent({super.key});

  @override
  State<StartInventoryTableContent> createState() =>
      _StartInventoryTableContentState();
}

class _StartInventoryTableContentState
    extends State<StartInventoryTableContent> {
  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<StartInventoryBloc, StartInventoryModel>(
      operatePopupHeight: 100,
      //表头
      columns: [
        // ID
        {
          'key': 'id',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_1,
        },
        // ロケーションコード
        {
          'key': 'loc_cd',
          'width': 5,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_code,
        },
        // フロア
        {
          'key': 'floor_cd',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_floor,
        },
        // 部屋
        {
          'key': 'room_cd',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_room,
        },
        // ゾーン
        {
          'key': 'zone_cd',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_zone,
        },
        // 列
        {
          'key': 'row_cd',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_column,
        },
        // 棚
        {
          'key': 'shelve_cd',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_shelf,
        },
        // 段
        {
          'key': 'step_cd',
          'width': 2,
          'title':
              WMSLocalizations.i18n(context)!.start_inventory_location_stage,
        },
      ],
      showCheckboxColumn: true,
      needPageInfo: false,
    );
  }
}
