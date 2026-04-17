import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/localization/default_localizations.dart';

import '../bloc/actual_shelf_bloc.dart';
import '../bloc/actual_shelf_model.dart';

/**
 * 内容：実棚明細入力
 * 作者：王光顺
 * 时间：2023/08/28
 */
class ActualShelfTitle extends StatefulWidget {
  const ActualShelfTitle({super.key});

  @override
  State<ActualShelfTitle> createState() => _ActualShelfState();
}

class _ActualShelfState extends State<ActualShelfTitle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActualShelfBloc, ActualShelfModel>(
        builder: (context, state) {
      return Container(
        height: 104,
        padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              state.actualState == 2
                  ? WMSLocalizations.i18n(context)!.Actual_Shelf_14
                  : WMSLocalizations.i18n(context)!.menu_content_5_2,
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
                  //返回按钮
                  GoRouter.of(context).pop('refresh return');
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
    });
  }
}
