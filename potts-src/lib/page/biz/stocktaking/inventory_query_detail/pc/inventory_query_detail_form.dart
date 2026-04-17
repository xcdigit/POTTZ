import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/inventory_query_detail_bloc.dart';
import '../bloc/inventory_query_detail_model.dart';

/**
 * 内容：棚卸照会-表单
 * 作者：熊草云
 * 时间：2023/08/29
 * 作者：赵士淞
 * 时间：2023/10/26
 */
class InventoryQueryDetailForm extends StatefulWidget {
  const InventoryQueryDetailForm({super.key});

  @override
  State<InventoryQueryDetailForm> createState() =>
      _InventoryQueryDetailFormState();
}

class _InventoryQueryDetailFormState extends State<InventoryQueryDetailForm> {
  // 初始化信息
  List<Widget> _initInfo(InventoryQueryDetailModel state) {
    return [
      // 棚卸ID
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.inventory_query_id,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Container(
                height: 48,
                child: WMSInputboxWidget(
                  readOnly: true,
                  text: state.inventoryInfo['id'].toString(),
                ),
              ),
            ],
          ),
        ),
      ),
      // 倉庫
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.home_main_page_table_text3,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Container(
                height: 48,
                child: WMSInputboxWidget(
                  readOnly: true,
                  text: state.inventoryInfo['warehouse_name'].toString(),
                ),
              ),
            ],
          ),
        ),
      ),
      // 棚卸日
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.start_inventory_date,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Container(
                height: 48,
                child: WMSInputboxWidget(
                  readOnly: true,
                  text: state.inventoryInfo['start_date'].toString(),
                ),
              ),
            ],
          ),
        ),
      ),
      // 状態
      FractionallySizedBox(
        widthFactor: 0.4,
        child: Container(
          height: 80,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.account_profile_state,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Container(
                height: 48,
                child: WMSInputboxWidget(
                  readOnly: true,
                  text: state.inventoryInfo['confirm_name'].toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // 初始化按钮
  List<Widget> _initButton(InventoryQueryDetailModel state) {
    return [
      OutlinedButton(
        style: ButtonStyle(
          backgroundColor:
              state.inventoryInfo['confirm_flg'] == Config.CONFIRM_KBN_2
                  ? MaterialStateProperty.all<Color>(
                      Color.fromRGBO(44, 167, 176, 1))
                  : MaterialStateProperty.all<Color>(Colors.grey),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          minimumSize: MaterialStateProperty.all<Size>(Size(120, 48)),
        ),
        child: Text(WMSLocalizations.i18n(context)!.menu_content_5_2),
        onPressed: () {
          // 商品ラベル
          if (state.inventoryInfo['confirm_flg'] == Config.CONFIRM_KBN_2)
            GoRouter.of(context)
                .push(
              '/' +
                  Config.PAGE_FLAG_5_9 +
                  '/' +
                  'details/' +
                  state.detailId.toString() +
                  '/' +
                  Config.PAGE_FLAG_60_5_2 +
                  '/' +
                  Config.NUMBER_ZERO.toString() +
                  '/' +
                  state.inventoryInfo['id'].toString() +
                  '/' +
                  Config.NUMBER_ONE.toString() +
                  '/' +
                  state.inventoryInfo['start_date'].toString() +
                  '/' +
                  state.inventoryInfo['warehouse_name'].toString(),
            )
                .then((value) {
              if (value == 'refresh return') {
                context.read<InventoryQueryDetailBloc>().add(InitEvent());
              }
            });
        },
      ),
    ];
  }

  // 初始化进度
  List<Widget> _initProgress(InventoryQueryDetailModel state) {
    return [
      FractionallySizedBox(
        widthFactor: .5,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 24,
                child: Text(
                  WMSLocalizations.i18n(context)!.inventory_query_progress,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color.fromRGBO(6, 14, 15, 1),
                  ),
                ),
              ),
              Container(
                height: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.inventoryInfo['progress'].toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${state.inventoryInfo['total_logic_num'].toString()} / ${state.inventoryInfo['total_all_logic_num'].toString()}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // 调整圆角半径
                      child: LinearProgressIndicator(
                        value: state.inventoryInfo['progress'] / 100,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: .5,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: .3,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_quantity,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      child: Text(
                        state.inventoryInfo['total_real_num'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: .3,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_quantity_in_stock,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      child: Text(
                        state.inventoryInfo['total_logic_num'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: .3,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .inventory_query_variance_quantity,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Container(
                      height: 48,
                      child: Text(
                        state.inventoryInfo['total_diff_num'].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
      builder: (context, state) {
        return Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: _initInfo(state),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(44, 0, 44, 30),
                child: Row(
                  children: _initButton(state),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(44, 0, 44, 30),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: _initProgress(state),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
