import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calendar_master_bloc.dart';
import '../bloc/calendar_master_model.dart';
import 'calendar_master_search.dart';
import 'calendar_master_table.dart';
import 'calendar_master_title.dart';

/**
 * 内容：営業日マスタ
 * 作者：赵士淞
 * 时间：2023/11/29
 */
class CalendarMasterPage extends StatefulWidget {
  const CalendarMasterPage({super.key});

  @override
  State<CalendarMasterPage> createState() => _CalendarMasterPageState();
}

class _CalendarMasterPageState extends State<CalendarMasterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarMasterBloc>(
      create: (context) {
        return CalendarMasterBloc(
          CalendarMasterModel(
            rootContext: context,
          ),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ListView(
              children: [
                // 头部
                CalendarMasterTitle(),
                // 搜索
                CalendarMasterSearch(),
                // 表格
                CalendarMasterTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
