import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../common/config/config.dart';
import '../../../common/style/wms_style.dart';
import '../../../redux/other_widget_operate_menu_child_reducer.dart';
import '../../../redux/wms_state.dart';
import '../../login/sp/login_page.dart';
import '../bloc/home_menu_bloc.dart';
import '../bloc/home_menu_model.dart';
import 'home_bottom_page.dart';
import 'home_head_page.dart';
import 'home_menu_page.dart';

/**
 * 内容：首页框架结构
 * 作者：赵士淞
 * 时间：2023/10/03
 */
class HomePage extends StatefulWidget {
  final Widget child;

  const HomePage({super.key, required this.child});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _createMenuList() {
    return [
      {
        "index": Config.MENU_FLAG_1,
        "icon": WMSICons.MENU_ICON_1,
        "route": '', // 首页
        "type": 'Menu',
        "bottomDisplay": true,
      },
      {
        "index": Config.MENU_FLAG_2,
        "icon": WMSICons.MENU_ICON_2,
        "type": 'Menu',
        "bottomDisplay": true,
        "children": [
          {
            "index": Config.MENU_FLAG_2_1,
            "icon": WMSICons.MENU_ICON_2_1,
            "route": Config.PAGE_FLAG_2_1 + '/-1', //入荷予定入力
          },
          {
            "index": Config.MENU_FLAG_2_5,
            "icon": WMSICons.MENU_ICON_2_5,
            "route": Config.PAGE_FLAG_2_5, // 入荷予定照会
          },
          {
            "index": Config.MENU_FLAG_2_4,
            "icon": WMSICons.MENU_ICON_2_4,
            "route": Config.PAGE_FLAG_2_4 // 入荷检品
          },
          {
            "index": Config.MENU_FLAG_2_3,
            "icon": WMSICons.MENU_ICON_2_3,
            "route": Config.PAGE_FLAG_2_3 +
                '/' +
                Config.NUMBER_ZERO.toString(), // 入庫入力
          },
          {
            "index": Config.MENU_FLAG_2_7,
            "icon": WMSICons.MENU_ICON_2_7,
            "route": Config.PAGE_FLAG_2_7 // 入庫照会
          },
          {
            "index": Config.MENU_FLAG_2_12,
            "icon": WMSICons.MENU_ICON_2_12,
            "route": Config.PAGE_FLAG_2_12, // 入荷確定
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_3,
        "icon": WMSICons.MENU_ICON_3,
        "type": 'Menu',
        "bottomDisplay": true,
        "children": [
          {
            "index": Config.MENU_FLAG_3_1,
            "icon": WMSICons.MENU_ICON_3_1,
            "route": "instructioninput" +
                "/" +
                Config.NUMBER_NEGATIVE.toString(), // 出荷指示入力
          },
          {
            "index": Config.MENU_FLAG_3_5,
            "icon": WMSICons.MENU_ICON_3_5,
            "route": Config.PAGE_FLAG_3_5, // 出荷指示照会
          },
          {
            "index": Config.MENU_FLAG_3_11,
            "icon": WMSICons.MENU_ICON_3_11,
            "route": "lackgoodsinvoice", // 欠品伝票照会
          },
          {
            "index": Config.MENU_FLAG_3_8,
            "icon": WMSICons.MENU_ICON_3_8,
            "route": Config.PAGE_FLAG_3_8, // ピッキングリスト （シングル）
          },
          {
            "index": Config.MENU_FLAG_3_12,
            "icon": WMSICons.MENU_ICON_3_12,
            "route": Config.PAGE_FLAG_3_12 +
                '/' +
                Config.NUMBER_ZERO.toString(), // 出庫入力
          },
          {
            "index": Config.MENU_FLAG_3_16,
            "icon": WMSICons.MENU_ICON_3_16,
            "route": Config.PAGE_FLAG_3_16, // 出庫照会
          },
          {
            "index": Config.MENU_FLAG_3_21,
            "icon": WMSICons.MENU_ICON_3_21,
            "route": Config.PAGE_FLAG_3_21, // 納品書
          },
          {
            "index": Config.MENU_FLAG_3_13,
            "icon": WMSICons.MENU_ICON_3_13,
            "route": Config.PAGE_FLAG_3_13, // 出荷検品
          },
          {
            "index": Config.MENU_FLAG_3_26,
            "icon": WMSICons.MENU_ICON_3_26,
            "route": Config.PAGE_FLAG_3_26, // 出荷確定
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_4,
        "icon": WMSICons.MENU_ICON_4,
        "type": 'Menu',
        "bottomDisplay": true,
        "children": [
          {
            "index": Config.MENU_FLAG_4_1,
            "icon": WMSICons.MENU_ICON_4_1,
            "route": Config.PAGE_FLAG_4_1, // 在庫照会
          },
          {
            "index": Config.MENU_FLAG_4_10,
            "icon": WMSICons.MENU_ICON_4_10,
            "route": Config.PAGE_FLAG_4_10, // 受払照会
          },
          {
            "index": Config.MENU_FLAG_4_4,
            "icon": WMSICons.MENU_ICON_4_4,
            "route": Config.PAGE_FLAG_4_4, //返品入力
          },
          {
            "index": Config.MENU_FLAG_4_8,
            "icon": WMSICons.MENU_ICON_4_8,
            "route": Config.PAGE_FLAG_4_8, //返品照会
          },
          {
            "index": Config.MENU_FLAG_4_13,
            "icon": WMSICons.MENU_ICON_4_13,
            "route": Config.PAGE_FLAG_4_13, // 在庫移動入力
          },
          {
            "index": Config.MENU_FLAG_4_16,
            "icon": WMSICons.MENU_ICON_4_16,
            "route": Config.PAGE_FLAG_4_16, // 在庫移動照会
          },
          {
            "index": Config.MENU_FLAG_4_17,
            "icon": WMSICons.MENU_ICON_4_17,
            "route": Config.PAGE_FLAG_4_17, // 在庫調整入力
          },
          {
            "index": Config.MENU_FLAG_4_18,
            "icon": WMSICons.MENU_ICON_4_18,
            "route": Config.PAGE_FLAG_4_18, // 在庫調整照会
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_5,
        "icon": WMSICons.MENU_ICON_5,
        "type": 'Menu',
        "children": [
          {
            "index": Config.MENU_FLAG_5_1,
            "icon": WMSICons.MENU_ICON_5_1,
            "route": Config.PAGE_FLAG_5_1, // 棚卸開始
          },
          {
            "index": Config.MENU_FLAG_5_9,
            "icon": WMSICons.MENU_ICON_5_9,
            "route": Config.PAGE_FLAG_5_9, // 棚卸照会
          },
          {
            "index": Config.MENU_FLAG_5_11,
            "icon": WMSICons.MENU_ICON_5_11,
            "route": Config.PAGE_FLAG_5_11, //棚卸確定
          },
        ]
      },
      // {
      //   "index": Config.MENU_FLAG_6,
      //   "icon": WMSICons.MENU_ICON_6,
      //   "type": 'Menu',
      //   "children": [
      //     {
      //       "index": Config.MENU_FLAG_6_1,
      //       "icon": WMSICons.MENU_ICON_6_1,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_2,
      //       "icon": WMSICons.MENU_ICON_6_2,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_3,
      //       "icon": WMSICons.MENU_ICON_6_3,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_4,
      //       "icon": WMSICons.MENU_ICON_6_4,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_5,
      //       "icon": WMSICons.MENU_ICON_6_5,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_6,
      //       "icon": WMSICons.MENU_ICON_6_6,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_7,
      //       "icon": WMSICons.MENU_ICON_6_7,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_8,
      //       "icon": WMSICons.MENU_ICON_6_8,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_9,
      //       "icon": WMSICons.MENU_ICON_6_9,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_10,
      //       "icon": WMSICons.MENU_ICON_6_10,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_6_11,
      //       "icon": WMSICons.MENU_ICON_6_11,
      //     },
      //   ]
      // },
      // {
      //   "index": Config.MENU_FLAG_7,
      //   "icon": WMSICons.MENU_ICON_7,
      //   "type": 'Menu',
      //   "children": [
      //     {
      //       "index": Config.MENU_FLAG_7_1,
      //       "icon": WMSICons.MENU_ICON_7_1,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_7_2,
      //       "icon": WMSICons.MENU_ICON_7_2,
      //     },
      //     {
      //       "index": Config.MENU_FLAG_7_3,
      //       "icon": WMSICons.MENU_ICON_7_3,
      //     },
      //   ]
      // },
      {
        "index": Config.MENU_FLAG_8,
        "icon": WMSICons.MENU_ICON_8,
        "type": 'Menu',
        "children": [
          {
            "index": Config.MENU_FLAG_8_1,
            "icon": WMSICons.MENU_ICON_8_1,
            "route": 'companyMaster', //会社マスタ
          },
          {
            "index": Config.MENU_FLAG_8_3,
            "icon": WMSICons.MENU_ICON_8_3,
            "route": 'shippingMaster', //荷主マスタ
          },
          {
            "index": Config.MENU_FLAG_8_4,
            "icon": WMSICons.MENU_ICON_8_4,
            "route": "productMaster", //商品マスタ管理
          },
          {
            "index": Config.MENU_FLAG_8_5,
            "icon": WMSICons.MENU_ICON_8_5,
            "route": "organizationMaster", //組織マスタ管理
          },
          {
            "index": Config.MENU_FLAG_8_6,
            "icon": WMSICons.MENU_ICON_8_6,
            "route": Config.PAGE_FLAG_8_6, //得意先マスタ管理
          },
          {
            "index": Config.MENU_FLAG_8_10,
            "icon": WMSICons.MENU_ICON_8_10,
            "route": Config.PAGE_FLAG_8_10, //仕入先マスタ
          },
          {
            "index": Config.MENU_FLAG_8_16,
            "icon": WMSICons.MENU_ICON_8_16,
            "route": Config.PAGE_FLAG_8_16, //ロケーションマスタ
          },
          {
            "index": Config.MENU_FLAG_8_19,
            "icon": WMSICons.MENU_ICON_8_19,
            "route": Config.PAGE_FLAG_8_19, //倉庫マスタ
          },
          {
            "index": Config.MENU_FLAG_8_21,
            "icon": WMSICons.MENU_ICON_8_21,
            "route": Config.PAGE_FLAG_8_21, // カレンダーマスタ
          },
          {
            "index": Config.MENU_FLAG_8_22,
            "icon": WMSICons.MENU_ICON_8_22,
            "route": 'roleMaster', // ロールマスタ
          },
          {
            "index": Config.MENU_FLAG_8_23,
            "icon": WMSICons.MENU_ICON_8_23,
            "route": Config.PAGE_FLAG_8_23, // 納入先マスタ管理
          },
          {
            "index": Config.MENU_FLAG_8_7,
            "icon": WMSICons.MENU_ICON_8_7,
            "route": Config.PAGE_FLAG_8_7, // 配送業者マスタ
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_9,
        "icon": WMSICons.MENU_ICON_9,
        "type": 'Menu',
        "route": Config.PAGE_FLAG_9,
      },
      {
        "index": Config.MENU_FLAG_50,
        "icon": WMSICons.MENU_ICON_50,
        "type": 'None',
        "children": [
          {
            "index": Config.MENU_FLAG_50_1,
            "icon": WMSICons.MENU_ICON_50_1,
            "route": Config.PAGE_FLAG_50_1, // アカウント
          },
          {
            "index": Config.MENU_FLAG_50_2,
            "icon": WMSICons.MENU_ICON_50_2,
            "route": Config.PAGE_FLAG_50_2, // 新着通知
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_60,
        "icon": WMSICons.MENU_ICON_60,
        "type": 'None',
        "visiable": false,
        "children": [
          {
            "index": Config.MENU_FLAG_60_2_5,
            "icon": WMSICons.MENU_ICON_60_2_5,
            "route": Config.PAGE_FLAG_60_2_5, // 入荷予定照会明細
          },
          {
            "index": Config.MENU_FLAG_60_3_11,
            "icon": WMSICons.MENU_ICON_60_3_11,
            "route": 'lackgoodsinvoice/details', // 欠品伝票照会明細
          },
          {
            "index": Config.MENU_FLAG_60_3_26,
            "icon": WMSICons.MENU_ICON_60_3_26,
            "route": Config.PAGE_FLAG_60_3_26, // 出荷确定详细
          },
          {
            "index": Config.MENU_FLAG_60_2_12_1,
            "icon": WMSICons.MENU_ICON_60_2_12_1,
            "route": Config.PAGE_FLAG_60_2_12_1, // 入荷確定明細
          },
          {
            "index": Config.MENU_FLAG_60_2_12_2,
            "icon": WMSICons.MENU_ICON_60_2_12_2,
            "route": Config.PAGE_FLAG_60_2_12_2, // 入荷確定印刷
          },
          {
            "index": Config.MENU_FLAG_60_3_21,
            "icon": WMSICons.MENU_ICON_60_3_21,
            "route": Config.PAGE_FLAG_60_3_21, // 納品明細
          },
          {
            "index": Config.MENU_FLAG_60_5_9,
            "icon": WMSICons.MENU_ICON_60_5_9,
            "route": Config.PAGE_FLAG_60_5_9, // 棚卸照会詳細
          },
          {
            "index": Config.MENU_FLAG_60_3_5,
            "icon": WMSICons.MENU_ICON_60_3_5,
            "route": Config.PAGE_FLAG_60_3_5, // 出荷指示明細
          },
          {
            "index": Config.MENU_FLAG_60_5_2,
            "icon": WMSICons.MENU_ICON_60_5_2,
            "route": Config.PAGE_FLAG_60_5_2, // 実棚明細入力
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_98,
        "icon": WMSICons.MENU_ICON_98,
        "type": 'Setting',
        "children": [
          {
            "index": Config.MENU_FLAG_98_5,
            "icon": WMSICons.MENU_ICON_98_5,
            "route": 'menuMaster', // メニューマスタ
          },
          {
            "index": Config.MENU_FLAG_98_8,
            "icon": WMSICons.MENU_ICON_98_8,
            "route": 'authMaster', //権限マスタ,
          },
          {
            "index": Config.MENU_FLAG_98_11,
            "icon": WMSICons.MENU_ICON_98_11,
            "route": Config.PAGE_FLAG_98_11, // メッセージマスタ
          },
        ]
      },
      {
        "index": Config.MENU_FLAG_99,
        "icon": WMSICons.MENU_ICON_99,
        "type": 'Setting',
        "children": [
          {
            "index": Config.MENU_FLAG_99_2,
            "icon": WMSICons.MENU_ICON_99_2,
            "route": Config.PAGE_FLAG_99_2, // 基本設定
          },
          {
            "index": Config.MENU_FLAG_99_6,
            "icon": WMSICons.MENU_ICON_99_6,
            "route": Config.PAGE_FLAG_99_6, // 操作ログ
          },
        ]
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 未Login的场合，返回Login画面
    if (StoreProvider.of<WMSState>(context).state.login! == false) {
      GoRouter.of(context).goNamed(LoginPage.sName);
    }

    return Material(
      // 整体
      child: BlocProvider<HomeMenuBloc>(
        create: (context) => HomeMenuBloc(
          HomeMenuModel(
            context,
            menuInfoList: _createMenuList(),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Column(
            children: [
              // 顶部内容
              GestureDetector(
                onTap: () {
                  // 持久化状态更新
                  StoreProvider.of<WMSState>(context).dispatch(
                      RefreshOtherWidgetOperateMenuChildAction(
                          !StoreProvider.of<WMSState>(context)
                              .state
                              .otherWidgetOperateMenuChild));
                },
                child: Container(
                  height: 88,
                  child: HomeHeadPage(),
                ),
              ),
              // 中部内容
              Stack(
                children: [
                  // 中部右内容
                  GestureDetector(
                    onTap: () {
                      // 持久化状态更新
                      StoreProvider.of<WMSState>(context).dispatch(
                          RefreshOtherWidgetOperateMenuChildAction(
                              !StoreProvider.of<WMSState>(context)
                                  .state
                                  .otherWidgetOperateMenuChild));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 88 - 72,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: widget.child,
                    ),
                  ),
                  // 中部左内容
                  Positioned(
                    left: 0,
                    child: Transform.translate(
                      offset: Offset(
                          StoreProvider.of<WMSState>(context).state.menuExpand
                              ? 0
                              : -68,
                          0),
                      child: Container(
                        width:
                            StoreProvider.of<WMSState>(context).state.menuExpand
                                ? 68
                                : 0,
                        height: MediaQuery.of(context).size.height - 88 - 72,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: HomeMenuPage(),
                      ),
                    ),
                  ),
                ],
              ),
              // 底部内容
              GestureDetector(
                onTap: () {
                  // 持久化状态更新
                  StoreProvider.of<WMSState>(context).dispatch(
                      RefreshOtherWidgetOperateMenuChildAction(
                          !StoreProvider.of<WMSState>(context)
                              .state
                              .otherWidgetOperateMenuChild));
                },
                child: Container(
                  height: 72,
                  child: HomeBottomPage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
