import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:wms/redux/wms_state.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../home/bloc/home_menu_bloc.dart';
import '../../home/bloc/home_menu_bloc.dart' as HMBFunction;
import '../../home/bloc/home_menu_model.dart';
import '../bloc/home_main_calendar_bloc.dart';
import '../bloc/home_main_calendar_bloc.dart' as HMCBFunction;
import '../bloc/home_main_calendar_model.dart';
import '../bloc/home_main_log_bloc.dart';
import '../bloc/home_main_log_bloc.dart' as HMLBFunction;
import '../bloc/home_main_log_model.dart';
import '../bloc/home_main_receive_bloc.dart';
import '../bloc/home_main_receive_bloc.dart' as HMRBFunction;
import '../bloc/home_main_receive_model.dart';
import '../bloc/home_main_ship_bloc.dart';
import '../bloc/home_main_ship_bloc.dart' as HMSBFunction;
import '../bloc/home_main_ship_model.dart';

/**
 * 内容：首页主页内容
 * 作者：luxy
 * 时间：2023/10/12
 */
class HomeMainPage extends StatefulWidget {
  static const String sName = "Home";

  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  //当前语言，默认日语
  var _locale = "ja";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //入荷予定
        BlocProvider(
          create: (context) => HomeMainReceiveBloc(HomeMainReceiveModel(
            rootContext: context,
          )),
        ),
        //出荷指示
        BlocProvider(
          create: (context) => HomeMainShipBloc(HomeMainShipModel(
            rootContext: context,
          )),
        ),
        //操作log
        BlocProvider(
          create: (context) => HomeMainLogBloc(HomeMainLogModel(
            rootContext: context,
          )),
        ),
        // 営業日マスタ - 赵士淞 - 始
        BlocProvider(
          create: (context) => HomeMainCalendarBloc(HomeMainCalendarModel(
            rootContext: context,
          )),
        ),
        // 営業日マスタ - 赵士淞 - 终
      ],
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: BlocBuilder<HomeMenuBloc, HomeMenuModel>(
              builder: (menuContext, menuState) {
            return BlocBuilder<HomeMainReceiveBloc, HomeMainReceiveModel>(
              builder: (receiveContext, receiveState) {
                return BlocBuilder<HomeMainShipBloc, HomeMainShipModel>(
                  builder: (shipContext, shipState) {
                    // 営業日マスタ - 赵士淞 - 始
                    return BlocBuilder<HomeMainCalendarBloc,
                            HomeMainCalendarModel>(
                        builder: (calendarContext, calendarState) {
                      // 営業日マスタ - 赵士淞 - 终
                      return new ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Container(
                            margin: EdgeInsets.all(20.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //第一行 当日出荷進捗
                                new Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: new Text(
                                    WMSLocalizations.i18n(context)!
                                        .home_main_page_text1,
                                    style: TextStyle(
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                new Padding(padding: new EdgeInsets.all(5.0)),
                                //第二行 出荷统计一览
                                new Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  height: 296,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //当日出荷数
                                          new Expanded(
                                            flex: 1,
                                            child: new ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 82,
                                                maxHeight: 82,
                                              ),
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: new Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0),
                                                  child: new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //内容
                                                      new Text(WMSLocalizations
                                                              .i18n(context)!
                                                          .home_main_page_text1),
                                                      //数量
                                                      new Text(
                                                        shipState.dayTotalCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              44, 167, 176, 1),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 32,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                              padding:
                                                  EdgeInsets.only(left: 14)),
                                          //引当済み
                                          new Expanded(
                                            flex: 1,
                                            child: new ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 82,
                                                maxHeight: 82,
                                              ),
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: new Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0),
                                                  child: new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //内容
                                                      new Text(
                                                          WMSLocalizations.i18n(
                                                                  context)!
                                                              .ship_kbn_text_2),
                                                      //数量
                                                      new Text(
                                                        shipState.dayWaitCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              44, 167, 176, 1),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 32,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //出荷待ち
                                          new Expanded(
                                            flex: 1,
                                            child: new ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 82,
                                                maxHeight: 82,
                                              ),
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: new Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0),
                                                  child: new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //内容
                                                      new Text(WMSLocalizations
                                                              .i18n(context)!
                                                          .instruction_input_tab_wait),
                                                      //数量
                                                      new Text(
                                                        shipState
                                                            .dayWaitShipmentCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              44, 167, 176, 1),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 32,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                              padding:
                                                  EdgeInsets.only(left: 14)),
                                          //出荷作業中
                                          new Expanded(
                                            flex: 1,
                                            child: new ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 82,
                                                maxHeight: 82,
                                              ),
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: new Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0),
                                                  child: new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //内容
                                                      new Text(WMSLocalizations
                                                              .i18n(context)!
                                                          .instruction_input_tab_work),
                                                      //数量
                                                      new Text(
                                                        shipState.dayWorkCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              44, 167, 176, 1),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 32,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //出荷済み
                                          new Expanded(
                                            flex: 1,
                                            child: new ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 82,
                                                maxHeight: 82,
                                              ),
                                              child: new Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ),
                                                child: new Container(
                                                  padding: EdgeInsets.only(
                                                      top: 16.0),
                                                  child: new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      //内容
                                                      new Text(WMSLocalizations
                                                              .i18n(context)!
                                                          .instruction_input_tab_complete),
                                                      //数量
                                                      new Text(
                                                        shipState
                                                            .dayShippedCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              44, 167, 176, 1),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 32,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                              padding:
                                                  EdgeInsets.only(left: 14)),
                                          //占位
                                          new Expanded(
                                            flex: 1,
                                            child: new ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 82,
                                                maxHeight: 82,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(padding: new EdgeInsets.all(16.0)),
                                //第三行 日历
                                new Container(
                                  height: 228,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    border: Border.all(
                                      color: Color.fromRGBO(224, 224, 224, 1),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: _getCalendar(
                                    calendarContext,
                                    calendarState,
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.all(16.0),
                                ),
                                //第四行 入荷予定标题
                                new Container(
                                  height: 22,
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(
                                        WMSLocalizations.i18n(context)!
                                            .home_main_page_text6,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                          fontSize: 16,
                                        ),
                                      ),
                                      //admin登录的场合隐藏按钮
                                      StoreProvider.of<WMSState>(context)
                                                  .state
                                                  .loginUser
                                                  ?.role_id !=
                                              1
                                          ? GestureDetector(
                                              onTap: () {
                                                // 跳转页面
                                                context
                                                    .read<HomeMenuBloc>()
                                                    .add(PageJumpEvent('/' +
                                                        Config.PAGE_FLAG_2_5));
                                                // 触发菜单变更事件
                                                context
                                                    .read<HomeMenuBloc>()
                                                    .add(ChangeMenuEvent(
                                                        context
                                                            .read<
                                                                HomeMenuBloc>()
                                                            .state
                                                            .menuList[1],
                                                        context));
                                              },
                                              child: new Text(
                                                WMSLocalizations.i18n(context)!
                                                    .home_main_page_text7,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 122, 255, 1),
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                new Padding(padding: new EdgeInsets.all(5.0)),
                                //第五行 入荷予定照会列表
                                new Container(
                                  height: 360,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                  ),
                                  child: new Container(
                                    padding: EdgeInsets.all(20),
                                    child: Container(
                                      height: 328,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: _getTable1(receiveState),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                new Padding(padding: new EdgeInsets.all(16.0)),
                                //第六行 出荷指示标题
                                new Container(
                                  height: 22,
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(
                                        WMSLocalizations.i18n(context)!
                                            .home_main_page_text8,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                          fontSize: 16,
                                        ),
                                      ),
                                      //admin登录的场合隐藏按钮
                                      StoreProvider.of<WMSState>(context)
                                                  .state
                                                  .loginUser
                                                  ?.role_id !=
                                              1
                                          ? GestureDetector(
                                              onTap: () {
                                                // 跳转页面
                                                context
                                                    .read<HomeMenuBloc>()
                                                    .add(PageJumpEvent('/' +
                                                        Config.PAGE_FLAG_3_5));

                                                // 触发菜单变更事件
                                                context
                                                    .read<HomeMenuBloc>()
                                                    .add(ChangeMenuEvent(
                                                        context
                                                            .read<
                                                                HomeMenuBloc>()
                                                            .state
                                                            .menuList[2],
                                                        context));
                                              },
                                              child: new Text(
                                                WMSLocalizations.i18n(context)!
                                                    .home_main_page_text7,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      0, 122, 255, 1),
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                new Padding(padding: new EdgeInsets.all(5.0)),
                                //第七行 出荷指示照会列表
                                new Container(
                                  height: 360,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    color: Color.fromRGBO(245, 245, 245, 1),
                                  ),
                                  child: new Container(
                                    padding: EdgeInsets.all(20),
                                    child: Container(
                                      height: 328,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: _getTable2(shipState),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                new Padding(padding: new EdgeInsets.all(16.0)),
                                //第八行 操作log标题
                                new Container(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(
                                        WMSLocalizations.i18n(context)!
                                            .home_main_page_text9,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // 跳转页面
                                          context.read<HomeMenuBloc>().add(
                                              PageJumpEvent(
                                                  '/' + Config.PAGE_FLAG_99_6));

                                          // 触发菜单变更事件
                                          context.read<HomeMenuBloc>().add(
                                              ChangeMenuEvent(
                                                  context
                                                      .read<HomeMenuBloc>()
                                                      .state
                                                      .menuList[11],
                                                  context));
                                        },
                                        child: new Text(
                                          WMSLocalizations.i18n(context)!
                                              .home_main_page_text7,
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 122, 255, 1),
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.all(5.0),
                                ),
                                //第九行 操作log列表
                                BlocBuilder<HomeMainLogBloc, HomeMainLogModel>(
                                    builder: (logContext, logState) {
                                  // 赵士淞 - 始
                                  // 判断路径
                                  if (GoRouter.of(context)
                                          .routeInformationProvider
                                          .value
                                          .location !=
                                      menuState.targetPath) {
                                    // 设置目标路径事件
                                    context.read<HomeMenuBloc>().add(
                                        HMBFunction.SetTargetPathEvent(
                                            GoRouter.of(context)
                                                .routeInformationProvider
                                                .value
                                                .location!));
                                    // 判断目标路径
                                    if (GoRouter.of(context)
                                            .routeInformationProvider
                                            .value
                                            .location! ==
                                        '/') {
                                      // 初始化
                                      context
                                          .read<HomeMenuBloc>()
                                          .add(HMBFunction.InitEvent());
                                      // 初始化
                                      receiveContext
                                          .read<HomeMainReceiveBloc>()
                                          .add(HMRBFunction.InitEvent());
                                      // 初始化
                                      shipContext
                                          .read<HomeMainShipBloc>()
                                          .add(HMSBFunction.InitEvent());
                                      // 初始化
                                      calendarContext
                                          .read<HomeMainCalendarBloc>()
                                          .add(HMCBFunction.InitEvent());
                                      // 初始化
                                      logContext
                                          .read<HomeMainLogBloc>()
                                          .add(HMLBFunction.InitEvent());
                                    }
                                  }
                                  // 赵士淞 - 终
                                  return new Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      border: Border.all(
                                        color: Color.fromRGBO(224, 224, 224, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: new Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: new Wrap(
                                        children: _getLog(logState),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      );
                      // 営業日マスタ - 赵士淞 - 始
                    });
                    // 営業日マスタ - 赵士淞 - 终
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }

  //入荷予定照会列表
  _getTable1(HomeMainReceiveModel state) {
    List<Widget> list = [];
    List<dynamic> receiveList = state.receiveList;
    if (receiveList.length > 0) {
      for (var i = 0; i < receiveList.length; i++) {
        if (i < 4) {
          list.add(Container(
            width: 328,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //入荷予定日
                  Text(
                    receiveList[i]['rcv_sch_date'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(156, 156, 156, 1),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //入荷予定番号
                      Container(
                        width: 100,
                        child: Text(
                          receiveList[i]['receive_no'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      //仕入先_名称
                      Container(
                        width: 60,
                        child: Text(
                          receiveList[i]['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      //入荷状態
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _judgeReceiveColor(
                                    state, receiveList[i]['receive_kbn']),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 8)),
                            Container(
                              width: 60,
                              child: Text(
                                receiveList[i]['receive_kbn'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        }
      }
    } else {
      list.add(
        Container(
          height: 280,
          alignment: Alignment.center,
          child: Text(
            WMSLocalizations.i18n(context)!.no_items_found,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    return list;
  }

  //出荷指示照会列表
  _getTable2(HomeMainShipModel state) {
    List<Widget> list = [];
    List<dynamic> shipList = state.shipList;
    if (shipList.length > 0) {
      for (var i = 0; i < shipList.length; i++) {
        if (i < 4) {
          list.add(Container(
            width: 328,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //出荷指示日
                  Text(
                    shipList[i]['rcv_sch_date'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(156, 156, 156, 1),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //出荷指示番号
                      Container(
                        width: 100,
                        child: Text(
                          shipList[i]['ship_no'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      //納入先_名称
                      Container(
                        width: 60,
                        child: Text(
                          shipList[i]['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      //出荷状態
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _judgeShipColor(
                                    state, shipList[i]['ship_kbn']),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 8)),
                            Container(
                              width: 60,
                              child: Text(
                                shipList[i]['ship_kbn'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));
        }
      }
    } else {
      list.add(
        Container(
          height: 280,
          alignment: Alignment.center,
          child: Text(
            WMSLocalizations.i18n(context)!.no_items_found,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    return list;
  }

  //日历
  Widget _getCalendar(BuildContext bloc, HomeMainCalendarModel model) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: CalendarCarousel<Event>(
        key: GlobalKey(),
        onDayPressed: (DateTime date, List<Event> events) {
          // this.setState(() => _currentDate = date);
        },
        iconColor: Colors.black, //标题的颜色
        headerMargin: EdgeInsets.symmetric(vertical: 0.0),
        //标题的样式
        headerTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        //周六周天的样式
        weekendTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        // weekDayMargin: EdgeInsets.only(bottom: 1.0),
        //周一到五的样式
        weekdayTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),

        //当天的样式
        todayTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 12,
          // decoration: TextDecoration.combine(),
        ),
        todayBorderColor: Colors.transparent, //当天选中的颜色
        todayButtonColor: Colors.transparent, //当天选中的颜色
        //其余天的样式
        daysTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
        //当月显示上个月天的样式
        prevDaysTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        //当月显示下个月天的样式
        nextDaysTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 12,
        ),
        //选中的样式
        selectedDayTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        selectedDayBorderColor: Colors.transparent, //选中的颜色
        selectedDayButtonColor: Colors.transparent, //选中的颜色

        locale: _locale, //语言
        childAspectRatio: 1.5, // xcy
        showIconBehindDayText: true,
        markedDateIconMaxShown: 5,
        markedDateIconMargin: 1.0,
        markedDateIconOffset: 1.0,
        customDayBuilder: (
          /// you can provide your own build function to make custom day containers
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          // 営業日マスタ - 赵士淞 - 始
          // 判断是否为当前月
          if (isThisMonthDay) {
            return Column(
              children: [CustomDay(day: day, isToday: isToday)],
            );
          } else {
            return null;
          }
          // 営業日マスタ - 赵士淞 - 终
          /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
          /// This way you can build custom containers for specific days only, leaving rest as default.
        },
        weekFormat: false,
        // markedDatesMap: _markedDateMap,
        width: 352.0,
        // selectedDateTime: _currentDate,
        // 営業日マスタ - 赵士淞 - 始
        targetDateTime: DateTime(model.calendarYear, model.calendarMonth, 1),
        markedDatesMap: model.markedDatesMap,
        onCalendarChanged: (p0) {
          // 营业月变更事件
          bloc
              .read<HomeMainCalendarBloc>()
              .add(CalendarMonthChangeEvent(p0.year, p0.month));
        },
        // 営業日マスタ - 赵士淞 - 终
      ),
    );
  }

  //操作log
  List<Widget> _getLog(HomeMainLogModel logState) {
    List<Widget> list = [];
    List<dynamic> logList = logState.logList;
    if (logList.length > 0) {
      for (var i = 0; i < 5; i++) {
        //页面展示只能展示5个信息
        list.add(
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              padding: EdgeInsets.all(4),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    logList[i]['create_time'].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(44, 167, 176, 1),
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(2)),
                  Text(
                    logList[i]['content'].toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      list.add(
        Container(
          height: 256,
          alignment: Alignment.center,
          child: Text(
            WMSLocalizations.i18n(context)!.no_items_found,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    return list;
  }

  //入荷状態颜色判断
  Color _judgeReceiveColor(HomeMainReceiveModel state, String kbn) {
    if (kbn == WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_1) {
      return Color.fromRGBO(255, 81, 65, 1);
    } else if (kbn ==
        WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_2) {
      return Color.fromRGBO(255, 178, 0, 1);
    } else if (kbn ==
        WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_3) {
      return Color.fromRGBO(221, 255, 0, 0.974);
    } else if (kbn ==
        WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_4) {
      return Color.fromRGBO(10, 243, 2, 1);
    } else if (kbn ==
        WMSLocalizations.i18n(state.rootContext)!.receive_kbn_text_5) {
      return Color.fromRGBO(44, 167, 176, 1);
    } else {
      return Colors.white;
    }
  }

  //出荷状態颜色判断
  Color _judgeShipColor(HomeMainShipModel state, String kbn) {
    if (kbn == state.SHIP_KBN_ASSIGN_FAIL) {
      return Color.fromRGBO(255, 81, 65, 1);
    } else if (kbn == state.SHIP_KBN_WAIT_ASSIGN) {
      return Color.fromRGBO(255, 178, 0, 1);
    } else if (kbn == state.SHIP_KBN_WAIT_OUTBOUND) {
      return Color.fromRGBO(221, 255, 0, 0.974);
    } else if (kbn == state.SHIP_KBN_IS_BEING_OUTBOUND) {
      return Color.fromRGBO(10, 243, 2, 1);
    } else if (kbn == state.SHIP_KBN_WAIT_INSPECT) {
      return Color.fromRGBO(44, 167, 176, 1);
    } else if (kbn == state.SHIP_KBN_WAIT_PACKAGING) {
      return Color.fromRGBO(0, 122, 255, 1);
    } else if (kbn == state.SHIP_KBN_WAIT_SHIPMENT_CONFIRM) {
      return Color.fromRGBO(229, 1, 245, 1);
    } else if (kbn == state.SHIP_KBN_SHIPPED) {
      return Color.fromRGBO(247, 3, 105, 1);
    } else {
      return Colors.white;
    }
  }
}

// 営業日マスタ - 赵士淞 - 始
// 自定义日历元素
class CustomDay extends StatelessWidget {
  // 日期
  final DateTime day;
  // 是否今天
  final bool isToday;

  const CustomDay({Key? key, required this.day, required this.isToday})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Center(
          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: isToday
                  ? Color.fromRGBO(44, 167, 176, 1)
                  : Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
        ),
        onTap: () async {
          // 获取营业
          List<Widget> widgetList =
              await context.read<HomeMainCalendarBloc>().getCalendar(day);
          // 判断标记
          if (widgetList.length != 0) {
            // 弹出框
            showPopover(
              context: context,
              bodyBuilder: (bodyBuilderContext) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: widgetList,
                  ),
                );
              },
              onPop: () {},
              direction: PopoverDirection.bottom,
              backgroundColor: Colors.white,
              width: 200,
              height: 200,
              arrowHeight: 15,
              arrowWidth: 30,
            );
          }
        },
      ),
    );
  }
}
// 営業日マスタ - 赵士淞 - 终
