import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_dialog_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_scan_widget.dart';
import '../bloc/product_information_bloc.dart';
import '../bloc/product_information_model.dart';

/**
 * 内容：商品情报-基本信息
 * 作者：赵士淞
 * 时间：2024/10/30
 */
class ProductInformationBasic extends StatefulWidget {
  const ProductInformationBasic({super.key});

  @override
  State<ProductInformationBasic> createState() =>
      _ProductInformationBasicState();
}

class _ProductInformationBasicState extends State<ProductInformationBasic> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInformationBloc, ProductInformationModel>(
      builder: (context, state) {
        // 显示提示对话框
        _showTipDialog(String text) {
          return showDialog(
            context: context,
            builder: (builderContext) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText: text,
                buttonLeftText: WMSLocalizations.i18n(context)!.app_cancel,
                onPressedLeft: () {
                  // 关闭对话框
                  Navigator.of(builderContext).pop();
                },
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedRight: () {
                  // 关闭对话框
                  Navigator.of(builderContext).pop();
                  // 打开商品管理页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenProductMasterManagementPageEvent());
                },
              );
            },
          );
        }

        // 初始化商品信息表单
        List<Widget> _initBasicForm() {
          return [
            // 商品コード
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_table_title_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: WMSInputboxWidget(
                            text: state.productInfo['code'].toString(),
                            inputBoxCallBack: (value) async {
                              // 判断值是否为空
                              if (value == null || value == '') {
                                // 消息提示
                                WMSCommonBlocUtils.tipTextToast(
                                    WMSLocalizations.i18n(context)!
                                            .outbound_adjust_table_title_3 +
                                        WMSLocalizations.i18n(context)!
                                            .can_not_null_text);
                                // 刷新数据事件
                                context
                                    .read<ProductInformationBloc>()
                                    .add(RefreshDataEvent(state));
                                return;
                              }
                              // 设定商品情报值事件
                              bool mark = await context
                                  .read<ProductInformationBloc>()
                                  .setProductInfoValue('code', value, state);
                              // 判断标记
                              if (!mark) {
                                _showTipDialog(WMSLocalizations.i18n(context)!
                                    .did_you_find_the_item_master);
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 48,
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (builderContext) {
                                    return WMSScanWidget(
                                      scanCallBack: (value) async {
                                        // 判断值是否为空
                                        if (value == null || value == '') {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                      .outbound_adjust_table_title_3 +
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .can_not_null_text);
                                          // 刷新数据事件
                                          context
                                              .read<ProductInformationBloc>()
                                              .add(RefreshDataEvent(state));
                                          return;
                                        }
                                        // 设定商品情报值事件
                                        bool mark = await context
                                            .read<ProductInformationBloc>()
                                            .setProductInfoValue(
                                                'code', value.trim(), state);
                                        // 判断标记
                                        if (!mark) {
                                          _showTipDialog(WMSLocalizations.i18n(
                                                  context)!
                                              .did_you_find_the_item_master);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Image.asset(
                                WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                                height: 44,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // JANCD
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .product_master_management_junk,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: WMSInputboxWidget(
                            text: state.productInfo['jan_cd'].toString(),
                            inputBoxCallBack: (value) async {
                              // 判断值是否为空
                              if (value == null || value == '') {
                                // 消息提示
                                WMSCommonBlocUtils.tipTextToast(
                                    WMSLocalizations.i18n(context)!
                                            .product_master_management_junk +
                                        WMSLocalizations.i18n(context)!
                                            .can_not_null_text);
                                // 刷新数据事件
                                context
                                    .read<ProductInformationBloc>()
                                    .add(RefreshDataEvent(state));
                                return;
                              }
                              // 设定商品情报值事件
                              bool mark = await context
                                  .read<ProductInformationBloc>()
                                  .setProductInfoValue('jan_cd', value, state);
                              // 判断标记
                              if (!mark) {
                                _showTipDialog(WMSLocalizations.i18n(context)!
                                    .did_you_find_the_item_master);
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 48,
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (builderContext) {
                                    return WMSScanWidget(
                                      scanCallBack: (value) async {
                                        // 判断值是否为空
                                        if (value == null || value == '') {
                                          // 消息提示
                                          WMSCommonBlocUtils.tipTextToast(
                                              WMSLocalizations.i18n(context)!
                                                      .product_master_management_junk +
                                                  WMSLocalizations.i18n(
                                                          context)!
                                                      .can_not_null_text);
                                          // 刷新数据事件
                                          context
                                              .read<ProductInformationBloc>()
                                              .add(RefreshDataEvent(state));
                                          return;
                                        }
                                        // 设定商品情报值事件
                                        bool mark = await context
                                            .read<ProductInformationBloc>()
                                            .setProductInfoValue(
                                                'jan_cd', value.trim(), state);
                                        // 判断标记
                                        if (!mark) {
                                          _showTipDialog(WMSLocalizations.i18n(
                                                  context)!
                                              .did_you_find_the_item_master);
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Image.asset(
                                WMSICons.SHIPMENT_INSPECTION_SCAN_ICON,
                                height: 44,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 商品名
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_table_title_4,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 規格
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_table_title_5,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['size'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 荷姿
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_1,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['packing_type'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 商品大分類
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['category_l'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 商品中分類
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['category_m'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 商品小分類
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_4,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['category_s'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 入数
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .product_master_management_quantity,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.productInfo['packing_num'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            // 商品写真１
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .instruction_input_form_detail_5,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    (state.image1Network == '')
                        ? Image.asset(
                            WMSICons.NO_IMAGE,
                            width: 136,
                            height: 136,
                          )
                        : Image.network(
                            state.image1Network,
                            width: 136,
                            height: 136,
                          ),
                  ],
                ),
              ),
            ),
            // 按钮
            FractionallySizedBox(
              widthFactor: 1,
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(44, 167, 176, 1),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                onPressed: () {
                  // 打开商品管理页面事件
                  context
                      .read<ProductInformationBloc>()
                      .add(OpenProductMasterManagementPageEvent());
                },
                child: Text(
                  WMSLocalizations.i18n(context)!
                      .product_information_look_at_details,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(255, 255, 255, 1),
                    height: 1.28,
                  ),
                ),
              ),
            ),
          ];
        }

        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(
            bottom: 32,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: _initBasicForm(),
          ),
        );
      },
    );
  }
}
