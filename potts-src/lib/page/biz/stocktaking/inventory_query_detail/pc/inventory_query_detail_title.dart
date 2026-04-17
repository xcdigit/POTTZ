import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/localization/default_localizations.dart';
import '../bloc/inventory_query_detail_bloc.dart';
import '../bloc/inventory_query_detail_model.dart';

/**
 * 内容：棚卸照会-标题
 * 作者：熊草云
 * 时间：2023/08/29
 * 作者：赵士淞
 * 时间：2023/10/26
 */
class InventoryQueryDetailTitle extends StatefulWidget {
  const InventoryQueryDetailTitle({super.key});

  @override
  State<InventoryQueryDetailTitle> createState() =>
      _InventoryQueryDetailTitleState();
}

class _InventoryQueryDetailTitleState extends State<InventoryQueryDetailTitle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryQueryDetailBloc, InventoryQueryDetailModel>(
      builder: (context, state) {
        return Container(
          height: 104,
          padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WMSLocalizations.i18n(context)!.menu_content_60_5_9,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  height: 1.0,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
              Container(
                color: Colors.white,
                height: 37,
                width: 80,
                child: OutlinedButton(
                  onPressed: () {
                    // 持久化状态更新
                    context.pop();
                  },
                  child: Text(
                      WMSLocalizations.i18n(context)!.menu_content_3_11_11,
                      style: TextStyle(color: Color.fromRGBO(44, 167, 176, 1))),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    side: MaterialStateProperty.all(
                      BorderSide(
                        width: 1,
                        color: Color.fromRGBO(44, 167, 176, 1),
                      ),
                    ),
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
