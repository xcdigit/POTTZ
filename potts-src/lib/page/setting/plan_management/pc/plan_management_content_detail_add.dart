import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';

/**
 * 内容：方案管理-内容追加（详情）
 * 作者：穆政道
 * 时间：2025/01/22
 */
class PlanManagementContentDetailAdd extends StatefulWidget {
  const PlanManagementContentDetailAdd({super.key});

  @override
  State<PlanManagementContentDetailAdd> createState() =>
      _PlanManagementContentDetailAddState();
}

class _PlanManagementContentDetailAddState
    extends State<PlanManagementContentDetailAdd> {
  // 初始化详细列表
  List<Widget> _initDetailList(List detailItemList) {
    // 详细列表
    List<Widget> detailList = [];

    // 循环详细列表
    for (int i = 0; i < detailItemList.length; i++) {
      // 详细列表
      detailList.add(
        Container(
          margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Container(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(240, 250, 250, 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      detailItemList[i]['icon'],
                      width: 44,
                      height: 44,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailItemList[i]['title'],
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
                              maxWidth: 300,
                            ),
                            child: WMSInputboxWidget(
                              text: context
                                  .read<PlanManagementBloc>()
                                  .state
                                  .selectPlan[detailItemList[i]['itemName']],
                              height: 52,
                              borderColor: Color.fromRGBO(255, 255, 255, 1),
                              inputBoxCallBack: (value) {
                                // 设置弹窗临时值事件
                                context.read<PlanManagementBloc>().add(
                                    SetAddItemValueEvent(
                                        detailItemList[i]['itemName'], value));
                              },
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
        ),
      );
    }
    detailList.add(
      Container(
        height: 36,
        margin: EdgeInsets.fromLTRB(16, 20, 16, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromRGBO(44, 167, 176, 1),
            ),
            minimumSize: MaterialStatePropertyAll(
              Size(120, 36),
            ),
          ),
          onPressed: () {
            // 新增方案事件
            context.read<PlanManagementBloc>().add(
                  AddPlanEvent(context),
                );
          },
          child: Text(
            WMSLocalizations.i18n(context)!.account_profile_registration,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
      ),
    );

    return detailList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanManagementBloc, PlanManagementModel>(
      builder: (context, state) {
        // 详细单个列表
        List _detailItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_PLAN,
            'title': WMSLocalizations.i18n(context)!.plan_content_text_21,
            'required': true,
            'itemName': 'plan_name'
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_15 + "（G）",
            'required': false,
            'itemName': 'db_capacity'
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_16 + "（G）",
            'required': false,
            'itemName': 'storage'
          },
          {
            'index': Config.NUMBER_THREE,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_17 + "（G）",
            'required': false,
            'itemName': 'db_dl'
          },
          {
            'index': Config.NUMBER_FOUR,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_18 + "（G）",
            'required': false,
            'itemName': 'storage_dl'
          },
          {
            'index': Config.NUMBER_FIVE,
            'icon': WMSICons.MENU_ICON_8,
            'title':
                WMSLocalizations.i18n(context)!.plan_content_text_22 + "（円）",
            'required': false,
            'itemName': 'plan_amount'
          },
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text(
                WMSLocalizations.i18n(context)!.plan_menu_text_2,
                style: TextStyle(
                  color: Color.fromRGBO(44, 167, 176, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 560,
                  margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 32),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(102, 199, 206, 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: _initDetailList(_detailItemList),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
