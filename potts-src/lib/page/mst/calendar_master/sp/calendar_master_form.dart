import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../widget/wms_date_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/calendar_master_bloc.dart';
import '../bloc/calendar_master_model.dart';

/**
 * 内容：営業日マスタ-表单
 * 作者：赵士淞
 * 时间：2023/12/01
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前悬停下标
int currentHoverIndex = Config.NUMBER_NEGATIVE;
// 当前内容
Widget currentContent = Wrap();

// ignore: must_be_immutable
class CalendarMasterForm extends StatefulWidget {
  // 营业ID
  int calendarId;
  // 标记
  int flag;

  CalendarMasterForm({
    super.key,
    required this.calendarId,
    required this.flag,
  });

  @override
  State<CalendarMasterForm> createState() => _CalendarMasterFormState();
}

class _CalendarMasterFormState extends State<CalendarMasterForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarMasterBloc>(
      create: (context) {
        return CalendarMasterBloc(
          CalendarMasterModel(
            rootContext: context,
            spCalendarId: widget.calendarId,
            spCalendarFlag: widget.flag,
          ),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 表单
              CalendarMasterFormContent(),
            ],
          ),
        ),
      ),
    );
  }
}

// 営業日マスタ-表单内容
// ignore: must_be_immutable
class CalendarMasterFormContent extends StatefulWidget {
  const CalendarMasterFormContent({super.key});

  @override
  State<CalendarMasterFormContent> createState() =>
      _CalendarMasterFormContentState();
}

class _CalendarMasterFormContentState extends State<CalendarMasterFormContent> {
  // 构建营业类型复选框
  _buildCalendarTypeCheckBox(String text, String index) {
    return Container(
      height: 48,
      constraints: BoxConstraints(
        maxHeight: 48,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromRGBO(224, 224, 224, 1),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1,
            child: Checkbox(
              fillColor: MaterialStateColor.resolveWith(
                (states) => context.read<CalendarMasterBloc>().state.formDisable
                    ? Color.fromRGBO(224, 224, 224, 1)
                    : Color.fromRGBO(44, 167, 176, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: context
                      .read<CalendarMasterBloc>()
                      .state
                      .calendarCustomize['calendar_type'] ==
                  index,
              onChanged: (value) {
                // 判断数值
                if (value == true &&
                    !context.read<CalendarMasterBloc>().state.formDisable) {
                  // 设定营业值事件
                  context
                      .read<CalendarMasterBloc>()
                      .add(SetCalendarValueEvent('calendar_type', index));
                }
              },
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  // 构建文本
  _buildText(String title, bool flag) {
    return Container(
      height: 24,
      child: Row(
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(6, 14, 15, 1),
            ),
          ),
          Visibility(
            visible: flag,
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

  // 初始化基本情報表单
  Widget _initFormBasic(CalendarMasterModel state) {
    return BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_1,
                        false),
                    WMSInputboxWidget(
                      text: state.calendarCustomize['id'].toString(),
                      readOnly: true,
                      inputBoxCallBack: (value) {
                        // 设定营业值事件
                        context
                            .read<CalendarMasterBloc>()
                            .add(SetCalendarValueEvent('id', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_2,
                        true),
                    WMSDateWidget(
                      text: state.calendarCustomize['calendar_date'].toString(),
                      readOnly:
                          context.read<CalendarMasterBloc>().state.formDisable,
                      dateCallBack: (value) {
                        // 设定营业值事件
                        context
                            .read<CalendarMasterBloc>()
                            .add(SetCalendarValueEvent('calendar_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                // height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_3,
                        true),
                    _buildCalendarTypeCheckBox(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_3_1,
                        Config.NUMBER_ONE.toString()),
                    SizedBox(
                      height: 5,
                    ),
                    _buildCalendarTypeCheckBox(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_3_2,
                        Config.NUMBER_TWO.toString()),
                    SizedBox(
                      height: 5,
                    ),
                    _buildCalendarTypeCheckBox(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_3_3,
                        Config.NUMBER_THREE.toString()),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(
                        WMSLocalizations.i18n(context)!.mtb_calendar_text_4,
                        false),
                    WMSInputboxWidget(
                      height: 136,
                      maxLines: 5,
                      text: state.calendarCustomize['note'].toString(),
                      readOnly:
                          context.read<CalendarMasterBloc>().state.formDisable,
                      inputBoxCallBack: (value) {
                        // 设定营业值事件
                        context
                            .read<CalendarMasterBloc>()
                            .add(SetCalendarValueEvent('note', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  // 按钮
                  child: CalendarMasterButton(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
      builder: (context, state) {
        // 判断当前下标
        if (currentIndex == Config.NUMBER_ZERO) {
          // 当前内容
          currentContent = _initFormBasic(state);
        }
        return Container(
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: CalendarMasterFormTab(
                  initFormBasic: _initFormBasic,
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.only(bottom: 200),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: currentContent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 営業日マスタ-表单Tab
typedef TabContextBuilder = Widget Function(CalendarMasterModel state);

// ignore: must_be_immutable
class CalendarMasterFormTab extends StatefulWidget {
  // 初始化基本情報表单
  TabContextBuilder initFormBasic;

  CalendarMasterFormTab({
    super.key,
    required this.initFormBasic,
  });

  @override
  State<CalendarMasterFormTab> createState() => _CalendarMasterFormTabState();
}

class _CalendarMasterFormTabState extends State<CalendarMasterFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, CalendarMasterModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 判断当前下标
    if (currentIndex == Config.NUMBER_ZERO) {
      // 当前内容
      currentContent = widget.initFormBasic(state);
    } else {
      // 当前内容
      currentContent = Wrap();
    }
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
              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
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
                minWidth: 108,
              ),
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
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
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 営業日マスタ-表单按钮
class CalendarMasterButton extends StatefulWidget {
  const CalendarMasterButton({super.key});

  @override
  State<CalendarMasterButton> createState() => _CalendarMasterButtonState();
}

class _CalendarMasterButtonState extends State<CalendarMasterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      height: 37,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: !context.read<CalendarMasterBloc>().state.formDisable,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(44, 167, 176, 1),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(255, 255, 255, 1),
                ),
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ),
              ),
              onPressed: () {
                // 保存营业事件
                context.read<CalendarMasterBloc>().add(SaveCalendarEvent());
              },
              child: Text(
                context.read<CalendarMasterBloc>().state.selectedId ==
                        Config.NUMBER_NEGATIVE
                    ? WMSLocalizations.i18n(context)!
                        .instruction_input_tab_button_add
                    : WMSLocalizations.i18n(context)!
                        .instruction_input_tab_button_update,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
