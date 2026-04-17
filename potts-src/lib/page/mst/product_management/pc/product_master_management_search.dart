import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/product_master_management_bloc.dart';
import '../bloc/product_master_management_model.dart';

/**
 * 内容：商品マスタ管理-主页
 * 作者：熊草云
 * 时间：2023/09/05
 */
class ProductMasterManagementSearch extends StatefulWidget {
  const ProductMasterManagementSearch({super.key});

  @override
  State<ProductMasterManagementSearch> createState() =>
      _ProductMasterManagementSearchState();
}

class _ProductMasterManagementSearchState
    extends State<ProductMasterManagementSearch> {
  // 导入文件回调函数
  void _importFileCallBack(List<List<Map<String, dynamic>>> content) {
    // 导入CSV文件事件
    context
        .read<ProductMasterManagementBloc>()
        .add(ImportCSVFileEvent(content));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductMasterManagementBloc,
        ProductMasterManagementModel>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    height: 48,
                    child: MouseRegion(
                      onEnter: (_) {
                        //
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(SearchButtonHoveredChangeEvent(true));
                      },
                      onExit: (_) {
                        //
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(SearchButtonHoveredChangeEvent(false));
                      },
                      child: OutlinedButton.icon(
                        onPressed: () {
                          //
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SearchOutlinedButtonPressedEvent());
                        },
                        icon: ColorFiltered(
                          colorFilter: state.searchFlag
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                              : state.searchButtonHovered
                                  ? ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn)
                                  : ColorFilter.mode(
                                      Color.fromRGBO(0, 122, 255, 1),
                                      BlendMode.srcIn),
                          child: Image.asset(WMSICons.WAREHOUSE_MENU_ICON,
                              height: 24),
                        ),
                        label: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_1,
                          style: TextStyle(
                              color: state.searchFlag
                                  ? Colors.white
                                  : state.searchButtonHovered
                                      ? Colors.white
                                      : Color.fromRGBO(0, 122, 255, 1),
                              fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: state.searchFlag
                              ? Color.fromRGBO(0, 122, 255, 1)
                              : state.searchButtonHovered
                                  ? Color.fromRGBO(0, 122, 255, .6)
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                    ),
                  ),
                  Container(
                    height: 48,
                    child: MouseRegion(
                      onEnter: (_) {
                        //
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(ImportButtonHoveredChangeEvent(true));
                      },
                      onExit: (_) {
                        //
                        context
                            .read<ProductMasterManagementBloc>()
                            .add(ImportButtonHoveredChangeEvent(false));
                      },
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // 打开加载状态
                          BotToast.showLoading();
                          // 导入CSV文件
                          WMSCommonFile().importCSVFile(_importFileCallBack);
                        },
                        icon: ColorFiltered(
                          colorFilter: state.importButtonHovered
                              ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                              : ColorFilter.mode(Color.fromRGBO(0, 122, 255, 1),
                                  BlendMode.srcIn),
                          child: Image.asset(
                              WMSICons.INSTRUCTION_INPUT_FILE_CSV,
                              height: 24),
                        ),
                        label: Text(
                          WMSLocalizations.i18n(context)!
                              .product_master_csv_import,
                          style: TextStyle(
                              color: state.importButtonHovered
                                  ? Colors.white
                                  : Color.fromRGBO(0, 122, 255, 1),
                              fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: state.importButtonHovered
                              ? Color.fromRGBO(0, 122, 255, .6)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              //检索结果展示
              visible: state.searchDataFlag,
              child: Container(
                height: 50,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      WMSLocalizations.i18n(context)!.delivery_note_11,
                      style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                    ),
                    SizedBox(width: 10),
                    for (int i = 0; i < state.conditionList.length; i++)
                      buildCondition(i, false, state)
                  ],
                ),
              ),
            ),
            Visibility(
              //检索区域
              visible: state.searchFlag,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 32, right: 32, bottom: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color.fromRGBO(245, 245, 245, 89),
                        width: 1.0,
                      ),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        // 检索条件小框
                        Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_11,
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 122, 255, 1)),
                              ),
                              SizedBox(width: 10),
                              for (int i = 0;
                                  i < state.conditionList.length;
                                  i++)
                                buildCondition(i, true, state)
                            ],
                          ),
                        ),
                        // 检索条件主体内容
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
                                    WMSLocalizations.i18n(context)!
                                        .instruction_input_table_title_3,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['code'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定商品_名称
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(
                                            SetSearchValueEvent('code', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                    WMSLocalizations.i18n(context)!
                                        .instruction_input_table_title_4,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['name'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定商品_名称
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(
                                            SetSearchValueEvent('name', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                    WMSLocalizations.i18n(context)!
                                        .product_master_management_product_abbreviation,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text:
                                      state.searchInfo['name_short'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定商品_名称
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(SetSearchValueEvent(
                                            'name_short', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.2,
                        ),
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
                                    WMSLocalizations.i18n(context)!
                                        .product_master_management_junk,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color.fromRGBO(6, 14, 15, 1),
                                    ),
                                  ),
                                ),
                                WMSInputboxWidget(
                                  text: state.searchInfo['jan_cd'].toString(),
                                  inputBoxCallBack: (value) {
                                    // 设定商品_名称
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(SetSearchValueEvent(
                                            'jan_cd', value));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        //会社名
                        Visibility(
                          visible: Config.ROLE_ID_1 == state.roleId,
                          child: FractionallySizedBox(
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
                                      WMSLocalizations.i18n(context)!
                                          .company_information_2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color.fromRGBO(6, 14, 15, 1),
                                      ),
                                    ),
                                  ),
                                  WMSDropdownWidget(
                                    inputInitialValue:
                                        state.searchInfo['company_name'] == null
                                            ? ''
                                            : state.searchInfo['company_name']
                                                .toString(),
                                    dropdownKey: 'id',
                                    dropdownTitle: 'name',
                                    dataList1: state.companyInfoList,
                                    inputRadius: 4,
                                    inputSuffixIcon: Container(
                                      width: 24,
                                      height: 24,
                                      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                      ),
                                    ),
                                    selectedCallBack: (value) {
                                      // 设定值
                                      if (value is! String) {
                                        context
                                            .read<ProductMasterManagementBloc>()
                                            .add(SetSearchValueEvent(
                                                'company_id', value['id']));
                                        context
                                            .read<ProductMasterManagementBloc>()
                                            .add(SetSearchValueEvent(
                                                'company_name', value['name']));
                                      } else {
                                        context
                                            .read<ProductMasterManagementBloc>()
                                            .add(SetSearchValueEvent(
                                                'company_id', ''));
                                        context
                                            .read<ProductMasterManagementBloc>()
                                            .add(SetSearchValueEvent(
                                                'company_name', ''));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: Config.ROLE_ID_1 == state.roleId,
                          child: FractionallySizedBox(
                            widthFactor: 0.4,
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_24,
                                    0,
                                    state),
                                SizedBox(width: 32),
                                BuildButtom(
                                    WMSLocalizations.i18n(context)!
                                        .delivery_note_25,
                                    1,
                                    state),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // 删除检索窗口按钮
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(-10, 10),
                      child: InkWell(
                        onTap: () {
                          //
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SearchInkWellTapEvent());
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(44, 167, 176, 1),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.black12, width: 0.5),
                          ),
                          child:
                              Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  // 底部检索和解除按钮
  Container BuildButtom(
      String text, int number, ProductMasterManagementModel state) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 224,
      child: OutlinedButton(
        onPressed: () {
          if (number == 0) {
            //检索按钮
            //检索事件执行
            context
                .read<ProductMasterManagementBloc>()
                .add(SeletProductEvent(context));
          } else {
            //解除检索条件
            context
                .read<ProductMasterManagementBloc>()
                .add(ClearSeletProductEvent());
          }
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 1,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }

  // 检索条件内部数据
  Container buildCondition(
      int index, bool flg, ProductMasterManagementModel state) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(left: 10, right: 10),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getSearchName(state.conditionList[index]),
            style: TextStyle(color: Colors.black12),
          ),
          InkWell(
            onTap: () {
              context
                  .read<ProductMasterManagementBloc>()
                  .add(DeleteSearchValueEvent(index));
            },
            child: Text(
              flg ? 'x' : '',
              style: TextStyle(color: Colors.black12),
            ),
          ),
        ],
      ),
    );
  }

  //取得检索条件名称
  String _getSearchName(dynamic condition) {
    String searchName = "";
    if (condition['key'] == null || condition['value'] == null) {
      return searchName;
    }
    if ('code' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.instruction_input_table_title_3 +
              "：" +
              condition['value'];
    } else if ('name' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.instruction_input_table_title_4 +
              "：" +
              condition['value'];
    } else if ('name_short' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!
              .product_master_management_product_abbreviation +
          "：" +
          condition['value'];
    } else if ('jan_cd' == condition['key']) {
      searchName =
          WMSLocalizations.i18n(context)!.product_master_management_junk +
              "：" +
              condition['value'];
    } else if ('company_id' == condition['key']) {
      searchName = WMSLocalizations.i18n(context)!.company_information_2 +
          "：" +
          condition['value'];
    }
    return searchName;
  }
}
