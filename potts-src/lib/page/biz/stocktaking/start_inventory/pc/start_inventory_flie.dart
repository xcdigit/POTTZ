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
 * 时间：2023/08/28
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
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Wrap(
            children: [
              FractionallySizedBox(
                widthFactor: .3,
                child: Container(
                  height: 80,
                  width: 300,
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
                widthFactor: .3,
                child: Container(
                  padding: EdgeInsets.only(left: 20),
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
                            //校验Value是否为空，不为空才执行查询，否则空值放入会造成异常
                            if (value != "") {
                              dynamic id = value['id']; //对value['id']进行int类型校验
                              int convertedId = id is int
                                  ? id
                                  : (id is String ? int.tryParse(id) ?? 0 : 0);
                              context.read<StartInventoryBloc>().add(
                                  SearchDropEvent(value['name'], convertedId));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              FractionallySizedBox(widthFactor: .3),
            ],
          ),
        );
      },
    );
  }
}
