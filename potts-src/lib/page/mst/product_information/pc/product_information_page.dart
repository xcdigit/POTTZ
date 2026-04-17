import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../bloc/product_information_bloc.dart';
import '../bloc/product_information_model.dart';
import 'product_information_basic.dart';
import 'product_information_design.dart';
import 'product_information_inventory.dart';
import 'product_information_title.dart';
import 'product_information_trend.dart';

/**
 * 内容：商品情报
 * 作者：赵士淞
 * 时间：2024/10/28
 */
// ignore: must_be_immutable
class ProductInformationPage extends StatefulWidget {
  // 商品编码或JANCD
  String productCodeOrJanCd;
  // 页面Key
  String pageKey;

  ProductInformationPage(
      {required this.productCodeOrJanCd, required this.pageKey})
      : super(key: Key(pageKey));

  @override
  State<ProductInformationPage> createState() => _ProductInformationPageState();
}

class _ProductInformationPageState extends State<ProductInformationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductInformationBloc>(
      create: (context) {
        return ProductInformationBloc(
          ProductInformationModel(
            rootContext: context,
            productCodeOrJanCd: widget.productCodeOrJanCd,
          ),
        );
      },
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            margin: EdgeInsets.only(
              bottom: 20,
            ),
            child: ListView(
              children: [
                // 标题
                ProductInformationTitle(
                    index: 1,
                    titleText:
                        WMSLocalizations.i18n(context)!.product_information),
                // 商品情报
                ProductInformationBasic(),
                // 标题
                ProductInformationTitle(
                    index: 2,
                    titleText:
                        WMSLocalizations.i18n(context)!.design_information),
                // 仕掛情報
                ProductInformationDesign(),
                // 标题
                ProductInformationTitle(
                  index: 3,
                  titleText:
                      WMSLocalizations.i18n(context)!.inventory_information,
                  canJumpPage: true,
                ),
                // 在庫情報
                ProductInformationInventory(),
                // 标题
                ProductInformationTitle(
                    index: 4,
                    titleText:
                        WMSLocalizations.i18n(context)!.information_trend),
                // トレンド情報
                ProductInformationTrend(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
