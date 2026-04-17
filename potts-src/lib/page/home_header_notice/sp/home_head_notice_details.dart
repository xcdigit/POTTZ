// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../common/localization/default_localizations.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/wms_state.dart';
import '../../../widget/wms_dialog_widget.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_model.dart';

/**
 * 内容：首页通知主要内容-sp
 * 作者：luxy
 * 时间：2023/10/31
 */

class HomeHeadNoticeDetails extends StatefulWidget {
  HomeHeadNoticeDetails({super.key});

  @override
  State<HomeHeadNoticeDetails> createState() => _HomeHeadNoticeDetailsState();
}

class _HomeHeadNoticeDetailsState extends State<HomeHeadNoticeDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoticeBloc>(
      create: (context) {
        return NoticeBloc(
          NoticeModel(
            rootContext: context,
          ),
        );
      },
      child: BlocBuilder<NoticeBloc, NoticeModel>(
        builder: (context, state) {
          bool currentFlag =
              StoreProvider.of<WMSState>(state.rootContext).state.currentFlag;
          if (currentFlag) {
            //每次点击，重新刷新
            context.read<NoticeBloc>().add(QueryNoticeSPEventInit());
          }
          return new Container(
            margin: EdgeInsets.fromLTRB(20, 0, 10, 20),
            child: new ListView(
              children: [
                //第一行 消息标题
                new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new Container(
                        width: MediaQuery.of(context).size.width - 80,
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
                      //删除按钮
                      GestureDetector(
                        onTap: () {
                          _showTipDialog(context);
                        },
                        child: new Container(
                          child: new Image(
                            image: new AssetImage(
                                WMSICons.HOME_HEAD_NOTICE_PAGE_DEL_IMG),
                            width: 26.0,
                            height: 26.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //第二行 时间
                new Container(
                  margin: EdgeInsets.only(top: 10),
                  child: new Text(
                    state.noticeContent.isNotEmpty &&
                            state.noticeContent['left_date'] != null
                        ? state.noticeContent['left_date']
                        : "",
                    style: TextStyle(
                      color: Color.fromRGBO(44, 167, 176, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                //第三行
                new Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: new Text(
                    state.noticeContent.isNotEmpty
                        ? state.noticeContent['message']
                        : "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
                contentText:
                    WMSLocalizations.i18n(context)!.home_head_notice_text4,
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
                      .add(DelNoticeSpEvent(state.noticeContent));
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
}
