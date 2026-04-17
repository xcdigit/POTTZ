import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../bloc/start_inventory_bloc.dart';
import '../bloc/start_inventory_model.dart';

/**
 * 内容：棚卸開始-文件
 * 作者：熊草云
 * 时间：2023/11/23
 */

class StartInventoryFile extends StatefulWidget {
  const StartInventoryFile({super.key});

  @override
  State<StartInventoryFile> createState() => _StartInventoryFileState();
}

class _StartInventoryFileState extends State<StartInventoryFile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartInventoryBloc, StartInventoryModel>(
      builder: (context, state) {
        return Container(
          child: Wrap(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!.start_inventory_date,
                        ),
                      ),
                      Container(
                        height: 48,
                        child: WMSDateWidget(
                          text: state.queryDateTime,
                          dateCallBack: (value) {
                            context
                                .read<StartInventoryBloc>()
                                .add(SearchDateEvent(value));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 24,
                        child: Text(
                          WMSLocalizations.i18n(context)!
                              .home_main_page_table_text3,
                        ),
                      ),
                      Container(
                        height: 48,
                        child: WMSDropdownWidget(
                          dataList1: state.warehouseList,
                          inputInitialValue: state.queryWarehouseValue,
                          inputRadius: 4,
                          inputSuffixIcon: Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
                          ),
                          inputFontSize: 14,
                          dropdownRadius: 4,
                          dropdownTitle: 'name',
                          dropdownKey: 'name',
                          selectedCallBack: (value) {
                            context.read<StartInventoryBloc>().add(
                                SearchDropEvent(value['name'], value['id']));
                          },
                        ),
                      )
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
