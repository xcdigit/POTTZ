import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_date_widget.dart';
import '../bloc/calendar_master_bloc.dart';
import '../bloc/calendar_master_model.dart';

/**
 * 内容：営業日マスタ-搜索
 * 作者：赵士淞
 * 时间：2023/12/01
 */
// 当前悬停标记
bool currentHoverFlag = false;

class CalendarMasterSearch extends StatefulWidget {
  const CalendarMasterSearch({super.key});

  @override
  State<CalendarMasterSearch> createState() => _CalendarMasterSearchState();
}

class _CalendarMasterSearchState extends State<CalendarMasterSearch> {
  // 构建检索单项
  Widget _buildQueryItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text +
                '：' +
                (index == 2
                    ? (value == Config.NUMBER_ONE.toString()
                        ? WMSLocalizations.i18n(context)!.mtb_calendar_text_3_1
                        : value == Config.NUMBER_TWO.toString()
                            ? WMSLocalizations.i18n(context)!
                                .mtb_calendar_text_3_2
                            : value == Config.NUMBER_THREE.toString()
                                ? WMSLocalizations.i18n(context)!
                                    .mtb_calendar_text_3_3
                                : '')
                    : value),
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // 判断下标
              if (index == 1) {
                // 保存检索：营业日事件
                context
                    .read<CalendarMasterBloc>()
                    .add(SaveQueryCalendarDateEvent(''));
              } else if (index == 2) {
                // 保存检索：营业类型事件
                context
                    .read<CalendarMasterBloc>()
                    .add(SaveQueryCalendarTypeEvent(''));
              }
            },
            child: Icon(
              Icons.close,
              color: Color.fromRGBO(156, 156, 156, 1),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 构建按钮
  _buildButtom(String text, int index) {
    return Container(
      decoration: BoxDecoration(
        color: index == Config.NUMBER_ZERO
            ? Color.fromRGBO(44, 167, 176, 1)
            : Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 48,
      width: 220,
      child: OutlinedButton(
        onPressed: () {
          // 判断按钮
          if (index == Config.NUMBER_ZERO) {
            // 搜索按钮事件
            context.read<CalendarMasterBloc>().add(SearchButtonEvent());
          } else if (index == Config.NUMBER_ONE) {
            // 重置按钮事件
            context.read<CalendarMasterBloc>().add(ResetButtonEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: index == Config.NUMBER_ZERO
                ? Color.fromRGBO(255, 255, 255, 1)
                : Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            Colors.black,
          ),
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 1,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }

  // 构建营业类型复选框
  _buildCalendarTypeCheckBox(String text, String index) {
    return Container(
      margin: EdgeInsets.only(
        top: 5,
      ),
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
                (states) => Color.fromRGBO(44, 167, 176, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value:
                  context.read<CalendarMasterBloc>().state.searchCalendarType ==
                      index,
              onChanged: (value) {
                // 保存查询：营业类型事件
                context
                    .read<CalendarMasterBloc>()
                    .add(SaveSearchCalendarTypeEvent(index));
              },
            ),
          ),
          Text(text),
        ],
      ),
    );
  }

  // 构建文本
  _buildText(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 构建查询单项
  Widget _buildSearchItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text +
                '：' +
                (index == 2
                    ? (value == Config.NUMBER_ONE.toString()
                        ? WMSLocalizations.i18n(context)!.mtb_calendar_text_3_1
                        : value == Config.NUMBER_TWO.toString()
                            ? WMSLocalizations.i18n(context)!
                                .mtb_calendar_text_3_2
                            : value == Config.NUMBER_THREE.toString()
                                ? WMSLocalizations.i18n(context)!
                                    .mtb_calendar_text_3_3
                                : '')
                    : value),
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // 判断下标
              if (index == 1) {
                // 保存查询：营业日事件
                context
                    .read<CalendarMasterBloc>()
                    .add(SaveSearchCalendarDateEvent(''));
              } else if (index == 2) {
                // 保存查询：营业类型事件
                context
                    .read<CalendarMasterBloc>()
                    .add(SaveSearchCalendarTypeEvent(''));
              }
            },
            child: Icon(
              Icons.close,
              color: Color.fromRGBO(156, 156, 156, 1),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 初始化检索列表
  List<Widget> _initSearchList(CalendarMasterModel state) {
    return [
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          constraints: BoxConstraints(
            minHeight: 48,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
              width: 1.0,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                height: 34,
                child: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_11,
                  style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                ),
              ),
              Visibility(
                visible: state.searchCalendarDate != '',
                child: _buildSearchItem(
                    1,
                    WMSLocalizations.i18n(context)!.mtb_calendar_text_2,
                    state.searchCalendarDate),
              ),
              Visibility(
                visible: state.searchCalendarType != '',
                child: _buildSearchItem(
                    2,
                    WMSLocalizations.i18n(context)!.mtb_calendar_text_3,
                    state.searchCalendarType),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.mtb_calendar_text_2),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSDateWidget(
                  text: state.searchCalendarDate,
                  dateCallBack: (value) {
                    // 保存查询：营业日事件
                    context
                        .read<CalendarMasterBloc>()
                        .add(SaveSearchCalendarDateEvent(value));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(WMSLocalizations.i18n(context)!.mtb_calendar_text_3),
              _buildCalendarTypeCheckBox(
                  WMSLocalizations.i18n(context)!.mtb_calendar_text_3_1,
                  Config.NUMBER_ONE.toString()),
              _buildCalendarTypeCheckBox(
                  WMSLocalizations.i18n(context)!.mtb_calendar_text_3_2,
                  Config.NUMBER_TWO.toString()),
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
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: _buildButtom(
            WMSLocalizations.i18n(context)!.delivery_note_25,
            Config.NUMBER_ONE,
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.only(
            top: 16,
          ),
          child: _buildButtom(
            WMSLocalizations.i18n(context)!.delivery_note_24,
            Config.NUMBER_ZERO,
          ),
        ),
      ),
    ];
  }

  // 检索按钮
  _searchButton(CalendarMasterModel state) {
    return Container(
      height: 48,
      child: MouseRegion(
        onEnter: (event) {
          // 状态变更
          setState(() {
            // 当前悬停标记
            currentHoverFlag = true;
          });
        },
        onExit: (event) {
          // 状态变更
          setState(() {
            // 当前悬停标记
            currentHoverFlag = false;
          });
        },
        child: OutlinedButton.icon(
          onPressed: () {
            // 保存检索按钮标记事件
            context
                .read<CalendarMasterBloc>()
                .add(SaveQueryButtonFlag(!state.queryButtonFlag));
            // 状态变更
            setState(() {
              // 当前悬停标记
              currentHoverFlag = false;
            });
          },
          icon: ColorFiltered(
            colorFilter: state.queryButtonFlag
                ? ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  )
                : currentHoverFlag
                    ? ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      )
                    : ColorFilter.mode(
                        Color.fromRGBO(0, 122, 255, 1),
                        BlendMode.srcIn,
                      ),
            child: Image.asset(
              WMSICons.WAREHOUSE_MENU_ICON,
              height: 24,
            ),
          ),
          label: Text(
            WMSLocalizations.i18n(context)!.delivery_note_1,
            style: TextStyle(
              color: state.queryButtonFlag
                  ? Colors.white
                  : currentHoverFlag
                      ? Colors.white
                      : Color.fromRGBO(0, 122, 255, 1),
              fontSize: 14,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: state.queryButtonFlag
                ? Color.fromRGBO(0, 122, 255, 1)
                : currentHoverFlag
                    ? Color.fromRGBO(0, 122, 255, .6)
                    : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarMasterBloc, CalendarMasterModel>(
      builder: (context, state) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 检索按钮
              _searchButton(state),
              // 检索详情
              Visibility(
                visible: state.queryButtonFlag,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 30,
                      ),
                      padding: EdgeInsets.fromLTRB(32, 30, 32, 30),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color.fromRGBO(245, 245, 245, 1),
                          width: 1.0,
                        ),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceBetween,
                          children: _initSearchList(state),
                        ),
                      ),
                    ),
                    // 关闭检索窗口按钮
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.translate(
                        offset: Offset(-10, 20),
                        child: InkWell(
                          onTap: () {
                            // 保存检索按钮标记事件
                            context
                                .read<CalendarMasterBloc>()
                                .add(SaveQueryButtonFlag(false));
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(44, 167, 176, 1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black12,
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 检索详情
              Visibility(
                visible: state.queryCalendarDate != '' ||
                    state.queryCalendarType != '',
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    constraints: BoxConstraints(
                      minHeight: 48,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                        width: 1.0,
                      ),
                    ),
                    child: Wrap(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                          padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                          height: 34,
                          child: Text(
                            WMSLocalizations.i18n(context)!.delivery_note_11,
                            style: TextStyle(
                                color: Color.fromRGBO(0, 122, 255, 1)),
                          ),
                        ),
                        Visibility(
                          visible: state.queryCalendarDate != '',
                          child: _buildQueryItem(
                              1,
                              WMSLocalizations.i18n(context)!
                                  .mtb_calendar_text_2,
                              state.queryCalendarDate),
                        ),
                        Visibility(
                          visible: state.queryCalendarType != '',
                          child: _buildQueryItem(
                              2,
                              WMSLocalizations.i18n(context)!
                                  .mtb_calendar_text_3,
                              state.queryCalendarType),
                        ),
                      ],
                    ),
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
