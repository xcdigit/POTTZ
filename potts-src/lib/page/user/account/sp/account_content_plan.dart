import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../home/bloc/home_menu_bloc.dart';
import '../../../home/bloc/home_menu_model.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-内容计划
 * 作者：赵士淞
 * 时间：2025/01/10
 */
class AccountContentPlan extends StatefulWidget {
  const AccountContentPlan({super.key});

  @override
  State<AccountContentPlan> createState() => _AccountContentPlanState();
}

class _AccountContentPlanState extends State<AccountContentPlan> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) {
        return AccountBloc(
          AccountModel(
            rootContext: context,
          ),
        );
      },
      child: BlocBuilder<AccountBloc, AccountModel>(
        builder: (context, state) {
          // 判断切换标记
          if (state.switchFlag) {
            // 切换标记
            state.switchFlag = false;
            // 保存位置标记和位置下标
            context.read<AccountBloc>().add(
                SaveLocationFlagAndLocationIndexEvent(
                    false, Config.NUMBER_ZERO));
          }

          return Scaffold(
            backgroundColor: Color.fromRGBO(102, 199, 206, 0.1),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: AccountContentPlanList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 账户-内容计划-列表
class AccountContentPlanList extends StatefulWidget {
  const AccountContentPlanList({super.key});

  @override
  State<AccountContentPlanList> createState() => _AccountContentPlanListState();
}

class _AccountContentPlanListState extends State<AccountContentPlanList> {
  // 初始化计划列表
  List<Widget> _initPlanList(List planItemList, AccountModel state) {
    // 计划列表
    List<Widget> planList = [];
    // 循环计划单个列表
    for (int i = 0; i < planItemList.length; i++) {
      // 计划列表
      planList.add(
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        planItemList[i]['icon'],
                        width: 44,
                        height: 44,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              planItemList[i]['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(6, 14, 15, 1),
                                height: 1.12,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              constraints: BoxConstraints(
                                maxWidth: 197,
                              ),
                              child: Text(
                                planItemList[i]['content'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  height: 1.28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: Visibility(
                      visible: planItemList[i]['button'],
                      maintainState: true,
                      child: GestureDetector(
                        onPanDown: (details) {
                          // 跳转页面
                          context.read<HomeMenuBloc>().add(PageJumpEvent('/' +
                              Config.PAGE_FLAG_50_1 +
                              '/plan/formDetail'));
                        },
                        child: Text(
                          WMSLocalizations.i18n(context)!.account_confirm,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // 计划列表
    return planList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 计划单个列表
        List _planItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_PLAN,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_11,
            'content': state.planData['plan_name'] != null
                ? state.planData['plan_name']
                : '',
            'button': false,
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.ACCOUNT_OTHER_CONTENTS_ACCOUNT,
            'title': WMSLocalizations.i18n(context)!
                .account_contents_account_management,
            'content': state.planData['order_create_time'] != null
                ? state.planData['order_create_time']
                    .toString()
                    .substring(0, 10)
                : '',
            'button': true,
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_DATE,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_14,
            'content': state.planData['next_date'] != null
                ? state.planData['next_date'].toString().substring(0, 10)
                : '',
            'button': false,
          },
        ];

        return BlocBuilder<HomeMenuBloc, HomeMenuModel>(
          builder: (menuBloc, menuState) {
            return Column(
              children: _initPlanList(_planItemList, state),
            );
          },
        );
      },
    );
  }
}
