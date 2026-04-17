// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/current_flag_reducer.dart';
import '../../../redux/current_index_reducer.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/wms_dialog_widget.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_model.dart';

/**
 * 内容：首页通知主要内容
 * 作者：luxy
 * 时间：2023/08/10
 */
GlobalKey _tableWidgetKey1 = new GlobalKey();

class HomeHeadNoticePage extends StatefulWidget {
  int index;

  HomeHeadNoticePage({this.index = -1, super.key});

  @override
  State<HomeHeadNoticePage> createState() => _HomeHeadNoticePageState();
}

class _HomeHeadNoticePageState extends State<HomeHeadNoticePage> {
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoticeBloc>(
      create: (context) {
        return NoticeBloc(
          NoticeModel(
            rootContext: context,
            index: widget.index,
          ),
        );
      },
      child: BlocBuilder<NoticeBloc, NoticeModel>(
        builder: (context, state) {
          bool currentFlag =
              StoreProvider.of<WMSState>(state.rootContext).state.currentFlag;
          if (currentFlag) {
            //每次点击，重新刷新
            context.read<NoticeBloc>().add(QueryNoticeEventInit());
            //清空输入框内容
            _textEditingController.clear();
          }
          return Container(
            key: _tableWidgetKey1,
            margin: StoreProvider.of<WMSState>(context).state.menuExpand
                ? EdgeInsets.all(20)
                : EdgeInsets.fromLTRB(54, 44, 54, 44),
            height: MediaQuery.of(context).size.height - 100,
            child: new Row(
              children: [
                //左侧内容
                new Expanded(
                  flex: 1,
                  child: new Container(
                    width: 328,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(102, 199, 206, 0.1),
                      border: Border.all(
                        color: Color.fromRGBO(44, 167, 176, 1),
                        width: 1,
                      ), //边框
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: new ListView(
                      children: [
                        //检索框
                        Container(
                          width: MediaQuery.of(context).size.width <
                                  Config.WEB_MINI_WIDTH_LIMIT
                              ? 296
                              : (MediaQuery.of(context).size.width - 328) / 4,
                          height: 40,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(251, 251, 251, 1),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Color.fromRGBO(224, 224, 224, 1),
                                width: 1),
                          ),
                          child: TextField(
                            controller: _textEditingController,
                            cursorColor: Color.fromRGBO(6, 14, 15, 1),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                            decoration: InputDecoration(
                              hintText: WMSLocalizations.i18n(context)!
                                  .home_head_notice_text1,
                              hintStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(156, 156, 156, 1),
                              ),
                              contentPadding: EdgeInsets.fromLTRB(-12, 0, 0, 0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Container(
                                padding: EdgeInsets.only(left: 15),
                                child: new Image(
                                  image:
                                      new AssetImage(WMSICons.HOME_HEAD_SEARCH),
                                  width: 24.0,
                                  height: 24.0,
                                ),
                              ),
                              suffixIcon: Container(
                                width: 52,
                                margin: EdgeInsets.all(6),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_24,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  onPressed: () {
                                    var value = _textEditingController.text;
                                    int userId =
                                        StoreProvider.of<WMSState>(context)
                                            .state
                                            .loginUser!
                                            .id!;
                                    if (value.isEmpty) {
                                      //查询数据（不带检索条件）
                                      context
                                          .read<NoticeBloc>()
                                          .add(QueryNoticeEventInit());
                                    } else {
                                      //查询数据（带检索条件）
                                      context
                                          .read<NoticeBloc>()
                                          .add(QueryNoticeEvent(userId, value));
                                    }
                                  },
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                //查询数据（不带检索条件）
                                //传入参数，控制消息页面刷新
                                StoreProvider.of<WMSState>(context)
                                    .dispatch(RefreshCurrentFlagAction(true));
                                //传入参数：消息下标
                                StoreProvider.of<WMSState>(context)
                                    .dispatch(RefreshCurrentIndexAction(-1));
                                context
                                    .read<NoticeBloc>()
                                    .add(QueryNoticeEventInit());
                              }
                            },
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height - 230,
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: new ListView(
                            children: _noticeList(context, state),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Padding(padding: EdgeInsets.all(20)),
                //右侧内容
                new Expanded(
                  flex: 2,
                  child: new Container(
                    height: MediaQuery.of(context).size.height - 100,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      border: Border.all(
                        color: Color.fromRGBO(44, 167, 176, 1),
                        width: 1,
                      ), //边框
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    child: new Visibility(
                      visible: state.noticeContent.isNotEmpty
                          ? state.noticeContent['selected']
                          : false,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //第一行 消息标题
                          new Container(
                            margin: EdgeInsets.fromLTRB(30, 46, 30, 12),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child: new Text(
                                    WMSLocalizations.i18n(context)!
                                        .home_head_notice_text2,
                                    style: TextStyle(
                                        color: Color.fromRGBO(44, 167, 176, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                //删除按钮
                                GestureDetector(
                                  onTap: () {
                                    _showTipDialog(context);
                                  },
                                  child: new Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: new Image(
                                      image: new AssetImage(WMSICons
                                          .HOME_HEAD_NOTICE_PAGE_DEL_IMG),
                                      width: 26.0,
                                      height: 26.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //第二行 线
                          new Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                border: Border(
                              top: BorderSide(
                                width: 1,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            )),
                          ),
                          //第三行
                          new Container(
                            margin:
                                EdgeInsets.only(top: 20, left: 30, right: 30),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Row(
                                  children: [
                                    new Image(
                                      image: new AssetImage(
                                          WMSICons.HOME_head_NOTICE_PAGE_IMG1),
                                      width: 25.0,
                                      height: 25.0,
                                    ),
                                    new Container(
                                      width: 420,
                                      padding: EdgeInsets.only(left: 10),
                                      child: new Text(
                                        state.noticeContent.isNotEmpty
                                            ? state.noticeContent['title']
                                            : "",
                                        style: TextStyle(
                                          color: Color.fromRGBO(6, 14, 15, 1),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                new Container(
                                  child: new Text(
                                    state.noticeContent.isNotEmpty
                                        ? state.noticeContent['create_time']
                                        : "",
                                    style: TextStyle(
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //第四行
                          new Container(
                            margin: EdgeInsets.fromLTRB(50, 20, 30, 0),
                            height: StoreProvider.of<WMSState>(context)
                                    .state
                                    .menuExpand
                                ? MediaQuery.of(context).size.height - 370 - 160
                                : MediaQuery.of(context).size.height -
                                    430 -
                                    160,
                            width: MediaQuery.of(context).size.width - 400,
                            child: new ListView(
                              children: [
                                new Text(
                                  state.noticeContent.isNotEmpty
                                      ? state.noticeContent['message']
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 第五行
                          Visibility(
                            visible: state.noticeContent.isNotEmpty &&
                                (state.noticeContent['push_kbn'] == 1 ||
                                    state.noticeContent['push_kbn'] == 2),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(50, 19, 50, 30),
                              child: Row(
                                children: [
                                  Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(44, 167, 176, 1),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 0, 40, 0),
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                          Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                        minimumSize: MaterialStatePropertyAll(
                                          Size(120, 36),
                                        ),
                                      ),
                                      onPressed: () {
                                        // 点击消息按钮1事件
                                        context
                                            .read<NoticeBloc>()
                                            .add(ClickMessageButtonOneEvent());
                                      },
                                      child: Text(
                                        state.noticeContent['push_kbn'] == 1
                                            ? WMSLocalizations.i18n(context)!
                                                .message_button_1_1
                                            : state.noticeContent['push_kbn'] ==
                                                    2
                                                ? WMSLocalizations.i18n(
                                                        context)!
                                                    .message_button_2_1
                                                : '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(44, 167, 176, 1),
                                          height: 1.28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // 第六行
                          Visibility(
                            visible: state.noticeContent.isNotEmpty &&
                                (state.noticeContent['push_kbn'] == 1 ||
                                    state.noticeContent['push_kbn'] == 2),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                              padding: EdgeInsets.fromLTRB(24, 21, 24, 21),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(102, 199, 206, 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.noticeContent['push_kbn'] == 1
                                        ? WMSLocalizations.i18n(context)!
                                            .message_button_1_2
                                        : state.noticeContent['push_kbn'] == 2
                                            ? WMSLocalizations.i18n(context)!
                                                .message_button_2_2
                                            : '',
                                    style: TextStyle(
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Container(
                                    width: 512,
                                    margin: EdgeInsets.only(
                                      top: 19,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: OutlinedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                Color.fromRGBO(44, 167, 176, 1),
                                              ),
                                              minimumSize:
                                                  MaterialStatePropertyAll(
                                                Size(120, 36),
                                              ),
                                            ),
                                            onPressed: () {
                                              // 点击消息按钮2事件
                                              context.read<NoticeBloc>().add(
                                                  ClickMessageButtonTwoEvent());
                                            },
                                            child: Text(
                                              state.noticeContent['push_kbn'] ==
                                                      1
                                                  ? WMSLocalizations.i18n(
                                                          context)!
                                                      .message_button_1_3
                                                  : state.noticeContent[
                                                              'push_kbn'] ==
                                                          2
                                                      ? WMSLocalizations.i18n(
                                                              context)!
                                                          .message_button_2_3
                                                      : '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1),
                                                height: 1.28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //删除弹框
  _showTipDialog(BuildContext context) {
    NoticeBloc bloc = context.read<NoticeBloc>();
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return BlocProvider<NoticeBloc>.value(
          value: bloc,
          child: BlocBuilder<NoticeBloc, NoticeModel>(
            builder: (context, state) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText: WMSLocalizations.i18n(context)!.want_to_delete_it,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedLeft: () {
                  // 关闭弹窗
                  Navigator.pop(context);
                },
                onPressedRight: () {
                  //删除方法
                  context
                      .read<NoticeBloc>()
                      .add(DelNoticeEvent(state.noticeContent));
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

  _noticeList(BuildContext context, NoticeModel state) {
    List<Widget> _list = [];
    //获取消息列表内容
    List<dynamic> noticeList = state.noticeList;
    if (noticeList.length > 0) {
      // 列表内容
      for (var i = 0; i < noticeList.length; i++) {
        _list.add(Container(
          key: GlobalKey(),
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
            border: Border(
              top: i == 0
                  ? BorderSide(
                      width: 1,
                      color: Color.fromRGBO(224, 224, 224, 1),
                    )
                  : BorderSide.none,
              bottom: BorderSide(
                width: 1,
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
          ),
          child: new Container(
            width: 298,
            height: 66,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: state.index == i
                  ? Color.fromRGBO(255, 255, 255, 1)
                  : Color.fromRGBO(255, 255, 255, 0),
            ),
            child: new ListTile(
              dense: true,
              contentPadding: EdgeInsets.all(-10), // content 内间距
              leading: noticeList[i]['message_kbn'] == 'ytb'
                  ? new Image(
                      image:
                          new AssetImage(WMSICons.HOME_head_NOTICE_PAGE_IMG2),
                      width: 25.0,
                      height: 25.0,
                    )
                  : new Image(
                      image:
                          new AssetImage(WMSICons.HOME_head_NOTICE_PAGE_IMG1),
                      width: 25.0,
                      height: 25.0,
                    ),
              title: Transform.translate(
                offset: Offset(-15, 0), // 控制水平偏移量
                child: new Text(
                  noticeList[i]['title'].toString(),
                  style: TextStyle(
                    color: Color.fromRGBO(6, 14, 15, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              subtitle: Transform.translate(
                offset: Offset(-15, 0), // 控制水平偏移量
                child: new Text(
                  noticeList[i]['message'].toString(),
                  style: TextStyle(
                    color: Color.fromRGBO(156, 156, 156, 1),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
              trailing: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 22, 0, 0),
                    child: new Text(
                      noticeList[i]['left_date'].toString(),
                      style: TextStyle(
                        color: Color.fromRGBO(44, 167, 176, 1),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: noticeList[i]['read_status'] == '2',
                    child: Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(255, 51, 51, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                //赋值 判断背景色
                context.read<NoticeBloc>().add(RightShowNoticeEvent(i));
              },
            ),
          ),
        ));
      }
    } else {
      _list.add(Container(
        height: MediaQuery.of(context).size.height - 380,
        alignment: Alignment.center,
        child: Text(
          WMSLocalizations.i18n(context)!.no_items_found,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ));
    }

    return _list;
  }
}
