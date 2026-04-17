import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../bloc/plan_management_bloc.dart';
import '../bloc/plan_management_model.dart';

/**
 * 内容：计划管理-内容（变更）
 * 作者：赵士淞
 * 时间：2024/06/27
 */
class PlanManagementContentEdit extends StatefulWidget {
  const PlanManagementContentEdit({super.key});

  @override
  State<PlanManagementContentEdit> createState() =>
      _PlanManagementContentEditState();
}

class _PlanManagementContentEditState extends State<PlanManagementContentEdit> {
  // 初始化计划列表
  List<Widget> _initPlanList(List planItemList) {
    // 计划列表
    List<Widget> planList = [];

    // 循环计划列表
    for (int i = 0; i < planItemList.length; i++) {
      // 计划列表
      planList.add(
        Column(
          children: [
            Container(
              width: 200,
              height: 200,
              padding: EdgeInsets.fromLTRB(34, 34, 34, 0),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 2,
                  color: Color.fromRGBO(192, 192, 192, 0.5),
                ),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Text(
                      planItemList[i]['plan_name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (planItemList[i]['db_capacity'] != null &&
                      planItemList[i]['db_capacity'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_15 +
                          ':' +
                          planItemList[i]['db_capacity'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['storage'] != null &&
                      planItemList[i]['storage'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_16 +
                          ':' +
                          planItemList[i]['storage'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['db_dl'] != null &&
                      planItemList[i]['db_dl'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_17 +
                          ':' +
                          planItemList[i]['db_dl'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['storage_dl'] != null &&
                      planItemList[i]['storage_dl'].toString().isNotEmpty)
                    Text(
                      WMSLocalizations.i18n(context)!.plan_content_text_18 +
                          ':' +
                          planItemList[i]['storage_dl'].toString() +
                          'G',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                  if (planItemList[i]['plan_amount'] != null &&
                      planItemList[i]['plan_amount'].toString().isNotEmpty)
                    Text(
                      planItemList[i]['plan_amount'].toString() +
                          WMSLocalizations.i18n(context)!.plan_content_text_19,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(156, 156, 156, 1),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              height: 36,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromRGBO(255, 255, 255, 1),
                  ),
                  minimumSize: MaterialStatePropertyAll(
                    Size(120, 36),
                  ),
                ),
                onPressed: () {
                  // 详细计划事件
                  context.read<PlanManagementBloc>().add(
                        DetailPlanEvent(planItemList[i]['id'], planItemList[i]),
                      );
                },
                child: Text(
                  WMSLocalizations.i18n(context)!.plan_button_text_3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return planList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanManagementBloc, PlanManagementModel>(
      builder: (context, state) {
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
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              spacing: 83,
              children: _initPlanList(state.planList),
            ),
          ],
        );
      },
    );
  }
}
