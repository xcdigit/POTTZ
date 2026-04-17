import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';
import 'package:wms/widget/wms_date_widget.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../../common/config/config.dart';
import '../bloc/inventory_confirmed_bloc.dart';
import '../bloc/inventory_confirmed_model.dart';

/**
 * content：棚卸確定-检索-sp
 * author：熊草云
 * date：2023/11/23
 */
class InventoryConfirmedSearch extends StatefulWidget {
  const InventoryConfirmedSearch({super.key});

  @override
  State<InventoryConfirmedSearch> createState() =>
      _InventoryConfirmedSearchState();
}

class _InventoryConfirmedSearchState extends State<InventoryConfirmedSearch> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryConfirmedBloc, InventoryConfirmedModel>(
      builder: (context, state) {
        return Container(
          child: Wrap(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(WMSLocalizations.i18n(context)!
                            .Inventory_Confirmed_Search_1),
                      ),
                      Wrap(
                        children: [
                          FractionallySizedBox(
                            widthFactor: .45,
                            child: WMSDateWidget(
                              text: state.queryStartDate,
                              dateCallBack: (value) {
                                // 检索日期事件
                                context.read<InventoryConfirmedBloc>().add(
                                    SearchDateEvent(Config.NUMBER_ONE, value));
                              },
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: .1,
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 16),
                              child: Text("~"),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: .45,
                            child: WMSDateWidget(
                              text: state.queryOverDate,
                              dateCallBack: (value) {
                                // 检索日期事件
                                context.read<InventoryConfirmedBloc>().add(
                                    SearchDateEvent(Config.NUMBER_TWO, value));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(WMSLocalizations.i18n(context)!
                            .Inventory_Confirmed_Search_2),
                      ),
                      WMSDropdownWidget(
                        dataList1: state.warehouseList,
                        inputInitialValue: state.queryWarehouseValue.toString(),
                        inputRadius: 4,
                        inputSuffixIcon: Container(
                          width: 24,
                          height: 24,
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                        ),
                        inputFontSize: 14,
                        dropdownRadius: 4,
                        dropdownTitle: 'name',
                        dropdownKey: 'name',
                        selectedCallBack: (value) {
                          // 判断数值
                          if (value == '') {
                            // 检索下拉事件
                            context.read<InventoryConfirmedBloc>().add(
                                SearchDropEvent(value, Config.NUMBER_NEGATIVE));
                          } else {
                            // 检索下拉事件
                            context.read<InventoryConfirmedBloc>().add(
                                SearchDropEvent(value["name"], value["id"]));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 48,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: WMSColors.textWhite,
                            side: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(44, 167, 176, 1),
                            ),
                          ),
                          onPressed: () {
                            // 查询检索事件
                            context
                                .read<InventoryConfirmedBloc>()
                                .add(QuerySearchEvent());
                          },
                          child: Text(
                            WMSLocalizations.i18n(context)!
                                .Inventory_Confirmed_Search_3,
                            style: TextStyle(
                              color: Color.fromRGBO(44, 167, 176, 1),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
