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
import '../../home/bloc/home_menu_bloc.dart';
import '../bloc/notice_bloc.dart';
import '../bloc/notice_model.dart';

/**
 * 内容：首页通知主要内容-sp
 * 作者：luxy
 * 时间：2023/10/30
 */

class HomeHeadNoticePage extends StatefulWidget {
  int index;

  HomeHeadNoticePage({this.index = -1, super.key});

  @override
  State<HomeHeadNoticePage> createState() => _HomeHeadNoticePageState();
}

class _HomeHeadNoticePageState extends State<HomeHeadNoticePage> {
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
            context.read<NoticeBloc>().add(QueryNoticeSPEventInit());
          }
          return Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: new ListView(
              children: _noticeList(context, state),
            ),
          );
        },
      ),
    );
  }

  _noticeList(BuildContext context, NoticeModel state) {
    List<Widget> _list = [];
    //获取消息列表内容
    List<dynamic> noticeList = state.noticeList;
    if (noticeList.length > 0) {
      // 列表内容
      for (var i = 0; i < noticeList.length; i++) {
        _list.add(
          Container(
            key: GlobalKey(),
            padding: i == 0
                ? EdgeInsets.fromLTRB(10, 0, 10, 10)
                : EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: new Container(
              // height: 66,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  new ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(-10), // content 内间距
                    leading: noticeList[i]['message_kbn'] == 'ytb'
                        ? new Image(
                            image: new AssetImage(
                                WMSICons.HOME_head_NOTICE_PAGE_IMG2),
                            width: 25.0,
                            height: 25.0,
                          )
                        : new Image(
                            image: new AssetImage(
                                WMSICons.HOME_head_NOTICE_PAGE_IMG1),
                            width: 25.0,
                            height: 25.0,
                          ),
                    title: Transform.translate(
                      offset: Offset(-15, 0), // 控制水平偏移量
                      child: Container(
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
                    ),
                    subtitle: Transform.translate(
                      offset: Offset(-15, 0), // 控制水平偏移量
                      child: Container(
                        height: 27,
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
                    ),
                    trailing: Container(
                      child: Image.asset(
                        WMSICons.HOME_HEAD_NOTICE_PAGE_JUMP_IMG,
                        width: 12,
                        height: 12,
                        fit: BoxFit.contain,
                        repeat: ImageRepeat.noRepeat,
                      ),
                    ),

                    onTap: () {
                      //传入参数，控制消息页面刷新
                      StoreProvider.of<WMSState>(context)
                          .dispatch(RefreshCurrentFlagAction(true));
                      //传入参数：消息下标
                      StoreProvider.of<WMSState>(context)
                          .dispatch(RefreshCurrentIndexAction(i));
                      // 跳转页面
                      context.read<HomeMenuBloc>().add(PageJumpEvent('/' +
                          Config.PAGE_FLAG_50_2 +
                          '/notice/-1' +
                          '/details'));
                    },
                  ),
                  Visibility(
                    visible: noticeList[i]['read_status'] == '2',
                    child: Positioned(
                      top: 8,
                      right: 35,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: Color.fromRGBO(255, 51, 51, 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else {
      _list.add(Container(
        height: MediaQuery.of(context).size.height - 260,
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
