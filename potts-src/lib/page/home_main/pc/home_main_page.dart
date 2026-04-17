import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:popover/popover.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../redux/wms_state.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

import '../../../widget/table/pc/wms_table_widget.dart';
import '../../home/bloc/home_menu_bloc.dart';
import '../../home/bloc/home_menu_bloc.dart' as HMBFunction;
import '../../home/bloc/home_menu_model.dart';
import '../bloc/home_main_admin_bloc.dart';
import '../bloc/home_main_admin_model.dart';
import '../bloc/home_main_calendar_bloc.dart';
import '../bloc/home_main_calendar_bloc.dart' as HMCBFunction;
import '../bloc/home_main_calendar_model.dart';
import '../bloc/home_main_log_bloc.dart';
import '../bloc/home_main_log_bloc.dart' as HMLBFunction;
import '../bloc/home_main_log_model.dart';
import '../bloc/home_main_receive_bloc.dart';
import '../bloc/home_main_receive_bloc.dart' as HMRBFunction;
import '../bloc/home_main_ship_bloc.dart';
import '../bloc/home_main_ship_bloc.dart' as HMSBFunction;
import '../bloc/home_main_receive_model.dart';
import '../bloc/home_main_ship_model.dart';

/**
 * 内容：首页主页内容
 * 作者：luxy
 * 时间：2023/08/08
 */
class HomeMainPage extends StatefulWidget {
  static const String sName = "Home";

  HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  //当前语言，默认日语
  var _locale = "ja";

  // var _currentDate;

  @override
  Widget build(BuildContext context) {
    //获取当前语言
    _locale = StoreProvider.of<WMSState>(context).state.locale.toString();
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
        // 営業日マスタ / Admin - 赵士淞 - 始
        BlocProvider(
          create: (context) => HomeMainCalendarBloc(HomeMainCalendarModel(
            rootContext: context,
          )),
        ),
        BlocProvider(
          create: (context) => HomeMainAdminBloc(HomeMainAdminModel(
            rootContext: context,
          )),
        ),
        // 営業日マスタ / Admin - 赵士淞 - 终
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: BlocBuilder<HomeMenuBloc, HomeMenuModel>(
              builder: (menuContext, menuState) {
            return BlocBuilder<HomeMainReceiveBloc, HomeMainReceiveModel>(
              builder: (receiveContext, receiveState) {
                return BlocBuilder<HomeMainShipBloc, HomeMainShipModel>(
                  builder: (shipContext, shipState) {
                    // 営業日マスタ / Admin - 赵士淞 - 始
                    return BlocBuilder<HomeMainCalendarBloc,
                            HomeMainCalendarModel>(
                        builder: (calendarContext, calendarState) {
                      return BlocBuilder<HomeMainAdminBloc, HomeMainAdminModel>(
                          builder: (adminContext, adminState) {
                        // 営業日マスタ / Admin - 赵士淞 - 终
                        return new ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            Container(
                              margin: EdgeInsets.all(20.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //第一行 当日出荷進捗 / 本日売上
                                  new Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: new Text(
                                      StoreProvider.of<WMSState>(context)
                                                  .state
                                                  .loginUser
                                                  ?.role_id ==
                                              Config.ROLE_ID_1
                                          ? WMSLocalizations.i18n(context)!
                                              .home_main_page_text12
                                          : WMSLocalizations.i18n(context)!
                                              .home_main_page_text1,
                                      style: TextStyle(
                                        color: Color.fromRGBO(44, 167, 176, 1),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  new Padding(padding: new EdgeInsets.all(5.0)),
                                  //第二行 出荷统计一览 / 本日统计一览
                                  new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      //当日出荷数 / 本日の売上
                                      new Expanded(
                                        flex: 1,
                                        child: new ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 240,
                                            minHeight: 120,
                                            maxHeight: 120,
                                          ),
                                          child: new Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    224, 224, 224, 1),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: new Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  new Expanded(
                                                    flex: 1,
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        new Flexible(
                                                          flex: 2,
                                                          child: new Text(StoreProvider.of<
                                                                              WMSState>(
                                                                          context)
                                                                      .state
                                                                      .loginUser
                                                                      ?.role_id ==
                                                                  Config
                                                                      .ROLE_ID_1
                                                              ? WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .home_main_page_text12
                                                              : WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .home_main_page_text1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  new Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0)),
                                                  new Expanded(
                                                    flex: 2,
                                                    child: StoreProvider.of<
                                                                        WMSState>(
                                                                    context)
                                                                .state
                                                                .loginUser
                                                                ?.role_id ==
                                                            Config.ROLE_ID_1
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                (adminState.salesToday /
                                                                        10000)
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          44,
                                                                          167,
                                                                          176,
                                                                          1),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 40,
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            8,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  '万円',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            44,
                                                                            167,
                                                                            176,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : new Text(
                                                            shipState
                                                                .dayTotalCount
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      44,
                                                                      167,
                                                                      176,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 40,
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      new Padding(
                                          padding: new EdgeInsets.all(10.0)),
                                      //引当済み / 本日の閲覧者数
                                      new Expanded(
                                        flex: 1,
                                        child: new ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 240,
                                            minHeight: 120,
                                            maxHeight: 120,
                                          ),
                                          child: new Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    224, 224, 224, 1),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: new Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  new Expanded(
                                                    flex: 1,
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        new Flexible(
                                                          flex: 2,
                                                          child: new Text(StoreProvider.of<
                                                                              WMSState>(
                                                                          context)
                                                                      .state
                                                                      .loginUser
                                                                      ?.role_id ==
                                                                  Config
                                                                      .ROLE_ID_1
                                                              ? WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .home_main_page_text13
                                                              : WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .ship_kbn_text_2),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  new Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0)),
                                                  new Expanded(
                                                    flex: 2,
                                                    child: new Text(
                                                      StoreProvider.of<WMSState>(
                                                                      context)
                                                                  .state
                                                                  .loginUser
                                                                  ?.role_id ==
                                                              Config.ROLE_ID_1
                                                          ? adminState
                                                              .viewersToday
                                                              .toString()
                                                          : shipState
                                                              .dayWaitCount
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            44, 167, 176, 1),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      new Padding(
                                          padding: new EdgeInsets.all(10.0)),
                                      //出荷待ち / 本日の登録者数
                                      new Expanded(
                                        flex: 1,
                                        child: new ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 240,
                                            minHeight: 120,
                                            maxHeight: 120,
                                          ),
                                          child: new Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    224, 224, 224, 1),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: new Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  new Expanded(
                                                    flex: 1,
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        new Flexible(
                                                          flex: 2,
                                                          child: new Text(StoreProvider.of<
                                                                              WMSState>(
                                                                          context)
                                                                      .state
                                                                      .loginUser
                                                                      ?.role_id ==
                                                                  Config
                                                                      .ROLE_ID_1
                                                              ? WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .home_main_page_text14
                                                              : WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .instruction_input_tab_wait),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  new Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0)),
                                                  new Expanded(
                                                    flex: 2,
                                                    child: new Text(
                                                      StoreProvider.of<WMSState>(
                                                                      context)
                                                                  .state
                                                                  .loginUser
                                                                  ?.role_id ==
                                                              Config.ROLE_ID_1
                                                          ? adminState
                                                              .registrationsToday
                                                              .toString()
                                                          : shipState
                                                              .dayWaitShipmentCount
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            44, 167, 176, 1),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      new Padding(
                                          padding: new EdgeInsets.all(10.0)),
                                      //出荷作業中 / 本日の解約数
                                      new Expanded(
                                        flex: 1,
                                        child: new ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: 240,
                                            minHeight: 120,
                                            maxHeight: 120,
                                          ),
                                          child: new Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0)),
                                              border: Border.all(
                                                color: Color.fromRGBO(
                                                    224, 224, 224, 1),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: new Container(
                                              padding: EdgeInsets.all(16.0),
                                              child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  new Expanded(
                                                    flex: 1,
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        new Flexible(
                                                          flex: 2,
                                                          child: new Text(StoreProvider.of<
                                                                              WMSState>(
                                                                          context)
                                                                      .state
                                                                      .loginUser
                                                                      ?.role_id ==
                                                                  Config
                                                                      .ROLE_ID_1
                                                              ? WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .home_main_page_text15
                                                              : WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .instruction_input_tab_work),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  new Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0)),
                                                  new Expanded(
                                                    flex: 2,
                                                    child: new Text(
                                                      StoreProvider.of<WMSState>(
                                                                      context)
                                                                  .state
                                                                  .loginUser
                                                                  ?.role_id ==
                                                              Config.ROLE_ID_1
                                                          ? adminState
                                                              .terminationsToday
                                                              .toString()
                                                          : shipState
                                                              .dayWorkCount
                                                              .toString(),
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            44, 167, 176, 1),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      StoreProvider.of<WMSState>(context)
                                                  .state
                                                  .loginUser
                                                  ?.role_id ==
                                              Config.ROLE_ID_1
                                          ? Container()
                                          : new Padding(
                                              padding:
                                                  new EdgeInsets.all(10.0)),
                                      //出荷済み
                                      StoreProvider.of<WMSState>(context)
                                                  .state
                                                  .loginUser
                                                  ?.role_id ==
                                              Config.ROLE_ID_1
                                          ? Container()
                                          : new Expanded(
                                              flex: 1,
                                              child: new ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minWidth: 240,
                                                  minHeight: 120,
                                                  maxHeight: 120,
                                                ),
                                                child: new Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0)),
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          224, 224, 224, 1),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: new Container(
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child: new Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        new Expanded(
                                                          flex: 1,
                                                          child: new Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              new Flexible(
                                                                flex: 2,
                                                                child: new Text(
                                                                    WMSLocalizations.i18n(
                                                                            context)!
                                                                        .instruction_input_tab_complete),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        new Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10.0)),
                                                        new Expanded(
                                                          flex: 2,
                                                          child: new Text(
                                                            shipState
                                                                .dayShippedCount
                                                                .toString(),
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      44,
                                                                      167,
                                                                      176,
                                                                      1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 40,
                                                            ),
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
                                  new Padding(
                                      padding: new EdgeInsets.all(10.0)),
                                  //第三行：入荷予定 / 过去30日间的売上
                                  new Container(
                                    height: 290,
                                    //第三行 分成两列
                                    child: new Row(
                                      children: [
                                        //第三行 第一列
                                        new Expanded(
                                          flex: 2,
                                          child: new ConstrainedBox(
                                            constraints:
                                                BoxConstraints(minWidth: 792),
                                            child: new Column(
                                              children: [
                                                //第三行 第一列 分成两行 第一行
                                                new Container(
                                                  height: 22,
                                                  padding: EdgeInsets.only(
                                                      left: 10.0, right: 10.0),
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      new Text(
                                                        StoreProvider.of<WMSState>(
                                                                        context)
                                                                    .state
                                                                    .loginUser
                                                                    ?.role_id ==
                                                                Config.ROLE_ID_1
                                                            ? WMSLocalizations
                                                                    .i18n(
                                                                        context)!
                                                                .home_main_page_text10
                                                            : WMSLocalizations
                                                                    .i18n(
                                                                        context)!
                                                                .home_main_page_text6,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              44, 167, 176, 1),
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      StoreProvider.of<WMSState>(
                                                                      context)
                                                                  .state
                                                                  .loginUser
                                                                  ?.role_id ==
                                                              Config.ROLE_ID_1
                                                          ? Container()
                                                          : GestureDetector(
                                                              onTap: () {
                                                                // 跳转页面
                                                                GoRouter.of(
                                                                        context)
                                                                    .go('/' +
                                                                        Config
                                                                            .PAGE_FLAG_2_5);
                                                                // 触发菜单变更事件
                                                                context
                                                                    .read<
                                                                        HomeMenuBloc>()
                                                                    .add(ChangeMenuEvent(
                                                                        context
                                                                            .read<HomeMenuBloc>()
                                                                            .state
                                                                            .menuList[1],
                                                                        context));
                                                              },
                                                              child: new Text(
                                                                WMSLocalizations
                                                                        .i18n(
                                                                            context)!
                                                                    .home_main_page_text7,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          122,
                                                                          255,
                                                                          1),
                                                                  fontSize: 14,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                new Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                ),
                                                //第三行 第一列 第二行
                                                new Container(
                                                  height: 256,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0)),
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          224, 224, 224, 1),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: new Container(
                                                    padding: EdgeInsets.all(20),
                                                    child: StoreProvider.of<
                                                                        WMSState>(
                                                                    context)
                                                                .state
                                                                .loginUser
                                                                ?.role_id ==
                                                            Config.ROLE_ID_1
                                                        ? _getChart1(adminState)
                                                        : _getTable1(
                                                            receiveState),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        new Padding(
                                            padding: new EdgeInsets.all(10.0)),
                                        //第三行 第二列：日历
                                        new Expanded(
                                          flex: 1,
                                          child: new Column(
                                            children: [
                                              new SizedBox(
                                                height: 33.0,
                                              ),
                                              new Container(
                                                width: 352,
                                                height: 256,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: _getCalendar(
                                                  calendarContext,
                                                  calendarState,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                      padding: new EdgeInsets.all(10.0)),
                                  //第四行：出荷指示/ 过去3月的売上
                                  new Container(
                                    height: 290,
                                    //第四行 分成两列
                                    child: new Row(
                                      children: [
                                        //第四行 第一列
                                        new Expanded(
                                          flex: 2,
                                          child: new Column(
                                            children: [
                                              //第四行 第一列 分成两行 第一行
                                              new Container(
                                                height: 22,
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    new Text(
                                                      StoreProvider.of<WMSState>(
                                                                      context)
                                                                  .state
                                                                  .loginUser
                                                                  ?.role_id ==
                                                              Config.ROLE_ID_1
                                                          ? WMSLocalizations
                                                                  .i18n(
                                                                      context)!
                                                              .home_main_page_text11
                                                          : WMSLocalizations
                                                                  .i18n(
                                                                      context)!
                                                              .home_main_page_text8,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            44, 167, 176, 1),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    StoreProvider.of<WMSState>(
                                                                    context)
                                                                .state
                                                                .loginUser
                                                                ?.role_id ==
                                                            Config.ROLE_ID_1
                                                        ? Container()
                                                        : GestureDetector(
                                                            onTap: () {
                                                              // 跳转页面
                                                              GoRouter.of(
                                                                      context)
                                                                  .go('/' +
                                                                      Config
                                                                          .PAGE_FLAG_3_5);
                                                              // 触发菜单变更事件
                                                              context
                                                                  .read<
                                                                      HomeMenuBloc>()
                                                                  .add(ChangeMenuEvent(
                                                                      context
                                                                          .read<
                                                                              HomeMenuBloc>()
                                                                          .state
                                                                          .menuList[2],
                                                                      context));
                                                            },
                                                            child: new Text(
                                                              WMSLocalizations
                                                                      .i18n(
                                                                          context)!
                                                                  .home_main_page_text7,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        122,
                                                                        255,
                                                                        1),
                                                                fontSize: 14,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.all(5.0),
                                              ),
                                              //第四行 第一列 第二行
                                              new Container(
                                                height: 256,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20.0)),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        224, 224, 224, 1),
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: new Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: StoreProvider.of<
                                                                      WMSState>(
                                                                  context)
                                                              .state
                                                              .loginUser
                                                              ?.role_id ==
                                                          Config.ROLE_ID_1
                                                      ? _getChart2(adminState)
                                                      : _getTable2(shipState),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Padding(
                                            padding: new EdgeInsets.all(10.0)),
                                        //第四行 第二列
                                        new Expanded(
                                          flex: 1,
                                          child: new Column(
                                            children: [
                                              //第四行 第二列 分成两行 第一行
                                              new Container(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, right: 10.0),
                                                child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    new Text(
                                                      WMSLocalizations.i18n(
                                                              context)!
                                                          .home_main_page_text9,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            44, 167, 176, 1),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        // 跳转页面
                                                        GoRouter.of(context).go(
                                                            '/' +
                                                                Config
                                                                    .PAGE_FLAG_99_6);
                                                        // 触发菜单变更事件
                                                        context
                                                            .read<
                                                                HomeMenuBloc>()
                                                            .add(ChangeMenuEvent(
                                                                context
                                                                    .read<
                                                                        HomeMenuBloc>()
                                                                    .state
                                                                    .menuList[11],
                                                                context));
                                                      },
                                                      child: new Text(
                                                        WMSLocalizations.i18n(
                                                                context)!
                                                            .home_main_page_text7,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              0, 122, 255, 1),
                                                          fontSize: 14,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              new Padding(
                                                padding: EdgeInsets.all(5.0),
                                              ),
                                              //第四行 第二列 第二行
                                              BlocBuilder<HomeMainLogBloc,
                                                      HomeMainLogModel>(
                                                  builder:
                                                      (logContext, logState) {
                                                // 赵士淞 - 始
                                                // 判断路径
                                                if (GoRouter.of(context)
                                                        .routeInformationProvider
                                                        .value
                                                        .location !=
                                                    menuState.targetPath) {
                                                  // 设置目标路径事件
                                                  context
                                                      .read<HomeMenuBloc>()
                                                      .add(HMBFunction
                                                          .SetTargetPathEvent(
                                                              GoRouter.of(
                                                                      context)
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
                                                        .add(HMBFunction
                                                            .InitEvent());
                                                    // 初始化
                                                    receiveContext
                                                        .read<
                                                            HomeMainReceiveBloc>()
                                                        .add(HMRBFunction
                                                            .InitEvent());
                                                    // 初始化
                                                    shipContext
                                                        .read<
                                                            HomeMainShipBloc>()
                                                        .add(HMSBFunction
                                                            .InitEvent());
                                                    // 初始化
                                                    calendarContext
                                                        .read<
                                                            HomeMainCalendarBloc>()
                                                        .add(HMCBFunction
                                                            .InitEvent());
                                                    // 初始化
                                                    logContext
                                                        .read<HomeMainLogBloc>()
                                                        .add(HMLBFunction
                                                            .InitEvent());
                                                  }
                                                }
                                                // 赵士淞 - 终
                                                return new Container(
                                                  height: 256,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20.0)),
                                                    border: Border.all(
                                                      color: Color.fromRGBO(
                                                          224, 224, 224, 1),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: new Container(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: new ListView(
                                                      children:
                                                          _getLog(logState),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                        // 営業日マスタ / Admin - 赵士淞 - 始
                      });
                    });
                    // 営業日マスタ / Admin - 赵士淞 - 终
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
    return WMSTableWidget<HomeMainReceiveBloc, HomeMainReceiveModel>(
      columns: [
        {
          'key': 'receive_no',
          'width': 8,
          'title': WMSLocalizations.i18n(context)!.menu_content_2_5_6,
        },
        {
          'key': 'rcv_sch_date',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!.home_main_page_table_text1,
        },
        {
          'key': 'name',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!.menu_content_2_5_5,
        },
        {
          'key': 'receive_kbn',
          'width': 6,
          'title':
              WMSLocalizations.i18n(context)!.inquiry_schedule_table_title_5,
        },
        {
          'key': 'importerror_flg',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!
              .display_instruction_ingestion_state,
        },
      ],
      needPageInfo: false,
      showCheckboxColumn: false,
      //行高度
      columnsHeight: 36,
    );
  }

  //出荷指示照会列表
  _getTable2(HomeMainShipModel state) {
    return WMSTableWidget<HomeMainShipBloc, HomeMainShipModel>(
      columns: [
        {
          'key': 'ship_no',
          'width': 8,
          'title': WMSLocalizations.i18n(context)!.delivery_note_14,
        },
        {
          'key': 'rcv_sch_date',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!.delivery_note_16,
        },
        {
          'key': 'name',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!.delivery_note_17,
        },
        {
          'key': 'ship_kbn',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!
              .display_instruction_shipping_status,
        },
        {
          'key': 'importerror_flg',
          'width': 6,
          'title': WMSLocalizations.i18n(context)!
              .display_instruction_ingestion_state,
        },
      ],
      needPageInfo: false,
      showCheckboxColumn: false,
      //行高度
      columnsHeight: 36,
    );
  }

  //日历
  Widget _getCalendar(BuildContext bloc, HomeMainCalendarModel model) {
    return Container(
      margin: EdgeInsets.all(10),
      child: CalendarCarousel<Event>(
        key: GlobalKey(),
        onDayPressed: (DateTime date, List<Event> events) {},
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
          color: Color.fromRGBO(44, 167, 176, 1),
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
      for (var i = 0; i < logList.length; i++) {
        list.add(
          Container(
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

  // 图表1
  Widget _getChart1(HomeMainAdminModel state) {
    List<ChartData> chartData = [];

    for (int i = 0; i < state.sales30DaysList.length; i++) {
      dynamic salesDate = state.sales30DaysList[i]['date'];
      salesDate = salesDate.toString().substring(5, 7) +
          '/' +
          salesDate.toString().substring(8, 10);
      dynamic salesPrice = state.sales30DaysList[i]['price'];
      chartData.add(ChartData(salesDate, salesPrice));
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 0,
        ),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: '',
        ),
      ),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
          ),
          color: Color.fromRGBO(44, 167, 176, 1),
          width: 0.4,
        ),
      ],
    );
  }

  // 图表2
  Widget _getChart2(HomeMainAdminModel state) {
    List<ChartData> chartData = [];

    for (int i = 0; i < state.sales3MonthsList.length; i++) {
      dynamic salesDate = state.sales3MonthsList[i]['date'];
      salesDate = salesDate.toString().substring(0, 4) +
          '/' +
          salesDate.toString().substring(5, 7);
      dynamic salesPrice = state.sales3MonthsList[i]['price'];
      chartData.add(ChartData(salesDate, salesPrice));
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(
          width: 0,
        ),
        interval: 1,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: '',
        ),
      ),
      series: <CartesianSeries>[
        ColumnSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
          ),
          color: Color.fromRGBO(44, 167, 176, 1),
          width: 0.4,
        ),
      ],
    );
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

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
