import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/localization/default_localizations.dart';
import '../bloc/product_information_bloc.dart';

/**
 * 内容：商品情报-标题
 * 作者：赵士淞
 * 时间：2024/10/28
 */
// ignore: must_be_immutable
class ProductInformationTitle extends StatefulWidget {
  // 下标
  int index;
  // 标题文本
  String titleText;
  // 可以跳转页面
  bool canJumpPage;

  ProductInformationTitle({
    super.key,
    this.index = 0,
    this.titleText = '',
    this.canJumpPage = false,
  });

  @override
  State<ProductInformationTitle> createState() =>
      _ProductInformationTitleState();
}

class _ProductInformationTitleState extends State<ProductInformationTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            widget.titleText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              height: 1.0,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
          Visibility(
            visible: widget.canJumpPage,
            child: GestureDetector(
              onTap: () {
                if (widget.index == 3) {
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenInventoryInquiryPageEvent());
                }
              },
              child: Text(
                WMSLocalizations.i18n(context)!.home_main_page_text7,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.0,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
