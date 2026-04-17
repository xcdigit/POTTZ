import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/stocktaking/inventory_output/bloc/inventory_output_bloc.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/table/bloc/wms_table_bloc.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../bloc/inventory_output_model.dart';

/**
 * 内容：棚卸データ出力
 * 作者：王光顺
 * 时间：2023/08/30
 */
class InventoryOutputRetrieval extends StatefulWidget {
  const InventoryOutputRetrieval({super.key});

  @override
  State<InventoryOutputRetrieval> createState() =>
      _InventoryOutputRetrievalState();
}

class _InventoryOutputRetrievalState extends State<InventoryOutputRetrieval> {
  // String _datetime = 'yyyy/mm/dd';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryOutputBloc, InventoryOutputModel>(
        builder: (context, state) {
      return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 24,
              child: Text(
                WMSLocalizations.i18n(context)!.start_inventory_date,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 300,
                  child: WMSDateWidget(
                    text: state.startDate.toString(),
                    borderColor: Color.fromRGBO(224, 224, 224, 1),
                    dateCallBack: (value) {
                      // 设定出荷指示值事件
                      state.startDate = value;
                      context
                          .read<InventoryOutputBloc>()
                          .add(SetValueEvent(value));
                    },
                  ),
                ),
                SizedBox(width: 120),
                Row(
                  children: [
                    BuildButtom(),
                  ],
                ),
              ],
            ),
            SizedBox(width: 50),
          ],
        ),
      );
    });
  }

// 底部检索和解除按钮
  Widget BuildButtom() {
    return BlocBuilder<InventoryOutputBloc, InventoryOutputModel>(
        builder: (context, state) {
      return Container(
        width: 140,
        height: 48,
        margin: EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: Color.fromARGB(255, 61, 174, 182),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: OutlinedButton(
          onPressed: () {
            context.read<InventoryOutputBloc>().add(PageQueryEvent());
          },
          child: Text(
            WMSLocalizations.i18n(context)!.delivery_note_24,
            style: TextStyle(
              color: Color.fromARGB(255, 61, 174, 182),
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide.none,
            ),
          ),
        ),
      );
    });
  }
}
