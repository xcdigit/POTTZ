import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../../widget/wms_scan_widget.dart';
import '../../../../widget/wms_upload_image_widget.dart';
import '../bloc/product_master_management_bloc.dart';
import '../bloc/product_master_management_model.dart';

/**
 * 内容：商品マスタ管理-表单
 * 作者：熊草云
 * 时间：2023/09/05
 */
// ignore: must_be_immutable
class ProductMasterManagementForm extends StatefulWidget {
  int productId;
  int flag;
  ProductMasterManagementForm({super.key, this.productId = 0, this.flag = 0});

  @override
  State<ProductMasterManagementForm> createState() =>
      _ProductMasterManagementFormState();
}

class _ProductMasterManagementFormState
    extends State<ProductMasterManagementForm> {
  @override
  Widget build(BuildContext context) {
    //商品数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    //控制页面刷新
    bool currentFlag = StoreProvider.of<WMSState>(context).state.currentFlag;
    return BlocProvider<ProductMasterManagementBloc>(
      create: (context) {
        return ProductMasterManagementBloc(
          ProductMasterManagementModel(context: context),
        );
      },
      child: BlocBuilder<ProductMasterManagementBloc,
          ProductMasterManagementModel>(
        builder: (context, state) {
          if (currentFlag) {
            //明细按钮输入框不可输入
            if (widget.flag == 0) {
              context
                  .read<ProductMasterManagementBloc>()
                  .add(ShowSelectValueEvent(data, "2"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            } else {
              //登录和修正按钮，输入框可以输入
              context
                  .read<ProductMasterManagementBloc>()
                  .add(ShowSelectValueEvent(data, "1"));
              //控制刷新
              StoreProvider.of<WMSState>(context)
                  .dispatch(RefreshCurrentFlagAction(false));
            }
          }

          // 上传图片1文件回调函数
          void _uploadImage1FileCallBack(String content) {
            // 判断内容信息
            if (content == WMSCommonFile.SIZE_EXCEEDS) {
              // 消息提示
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.image_size_need_within_2m);
            } else if (content != "") {
              // 保存写真路径
              context
                  .read<ProductMasterManagementBloc>()
                  .add(SetProductValueEvent('image1', content));
            }
          }

          // 上传图片2文件回调函数
          void _uploadImage2FileCallBack(String content) {
            // 判断内容信息
            if (content == WMSCommonFile.SIZE_EXCEEDS) {
              // 消息提示
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(context)!.image_size_need_within_2m);
            } else if (content != "") {
              // 保存写真路径
              context
                  .read<ProductMasterManagementBloc>()
                  .add(SetProductValueEvent('image2', content));
            }
          }

          // 初始化基本情報入力表单
          List<Widget> _initFormBasic() {
            return [
              //ID
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
                          "ID",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['id'].toString(),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
              //商品名称
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .instruction_input_table_title_4,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['name'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('name', value));
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
                  widthFactor: 1,
                  child: Container(
                    height: 72,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 24,
                          child: Row(
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .company_information_2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                ),
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color.fromRGBO(255, 0, 0, 1.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        state.productInfo['id'] != null &&
                                state.productInfo['id'] != ''
                            ? WMSInputboxWidget(
                                text: state.productInfo['company_name']
                                    .toString(),
                                readOnly: true,
                                inputBoxCallBack: (value) {},
                              )
                            : WMSDropdownWidget(
                                inputInitialValue:
                                    state.productInfo['company_name'] == null
                                        ? ''
                                        : state.productInfo['company_name']
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
                                        .add(SetProductValueEvent(
                                            'company_id', value['id']));
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(SetProductValueEvent(
                                            'company_name', value['name']));
                                  } else {
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(SetProductValueEvent(
                                            'company_id', null));
                                    context
                                        .read<ProductMasterManagementBloc>()
                                        .add(SetProductValueEvent(
                                            'company_name', null));
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              //商品コード
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .instruction_input_table_title_3,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['code'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('code', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_略称
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_product_abbreviation,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['name_short'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('name_short', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_JANCD
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_junk,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(224, 224, 224, 1),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: WMSInputboxWidget(
                                borderColor: Colors.transparent,
                                text: state.productInfo['jan_cd'].toString(),
                                readOnly: state.stateFlg == '2',
                                inputBoxCallBack: (value) {
                                  // 设定商品_名称
                                  context
                                      .read<ProductMasterManagementBloc>()
                                      .add(SetProductValueEvent(
                                          'jan_cd', value));
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
                                          scanCallBack: (value) {
                                            // 设定商品_名称
                                            context
                                                .read<
                                                    ProductMasterManagementBloc>()
                                                .add(SetProductValueEvent(
                                                    'jan_cd', value));
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
                      ),
                    ],
                  ),
                ),
              ),
              //大分類
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_major_categories,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['category_l'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('category_l', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_中分類
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_medium_classification,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['category_m'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('category_m', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_小分類
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_subclassification,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['category_s'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('category_s', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_規格
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .instruction_input_table_title_5,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['size'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('size', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_荷姿
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .instruction_input_form_detail_1,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['packing_type'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('packing_type', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_入数
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_quantity,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WMSInputboxWidget(
                        text: state.productInfo['packing_num'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          // 设定商品_名称
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('packing_num', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_写真１
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_photo_1,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (state.stateFlg != '2') {
                            //admin登录的场合 上传图片之前需要
                            if (Config.ROLE_ID_1 == state.roleId) {
                              if (state.productInfo['company_id'] == null ||
                                  state.productInfo['company_id'] == '') {
                                WMSCommonBlocUtils.tipTextToast(
                                    WMSLocalizations.i18n(context)!
                                            .company_information_2 +
                                        WMSLocalizations.i18n(context)!
                                            .can_not_null_text);
                                return;
                              } else {
                                // 弹窗
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return WMSUploadImageWidget(
                                      folderName: 'product/' +
                                          state.productInfo['company_id']
                                              .toString(),
                                      uploadImageCallBack:
                                          _uploadImage1FileCallBack,
                                    );
                                  },
                                );
                              }
                            } else {
                              // 弹窗
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return WMSUploadImageWidget(
                                    folderName: 'product/' +
                                        StoreProvider.of<WMSState>(context)
                                            .state
                                            .loginUser!
                                            .company_id
                                            .toString(),
                                    uploadImageCallBack:
                                        _uploadImage1FileCallBack,
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: (state.image1Network == '')
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
                      )
                    ],
                  ),
                ),
              ),
              //商品_写真2
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
                        child: Row(
                          children: [
                            Text(
                              WMSLocalizations.i18n(context)!
                                  .product_master_management_photo_2,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(6, 14, 15, 1),
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 0, 0, 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (state.stateFlg != '2') {
                            // 弹窗
                            showDialog(
                              context: context,
                              builder: (context) {
                                return WMSUploadImageWidget(
                                  folderName: 'product/' +
                                      StoreProvider.of<WMSState>(context)
                                          .state
                                          .loginUser!
                                          .company_id
                                          .toString(),
                                  uploadImageCallBack:
                                      _uploadImage2FileCallBack,
                                );
                              },
                            );
                          }
                        },
                        child: (state.image2Network == '')
                            ? Image.asset(
                                WMSICons.NO_IMAGE,
                                width: 136,
                                height: 136,
                              )
                            : Image.network(
                                state.image2Network,
                                width: 136,
                                height: 136,
                              ),
                      )
                    ],
                  ),
                ),
              ),
              //商品_社内備考１
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
                              .instruction_input_form_detail_8,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        height: 136,
                        maxLines: 5,
                        text: state.productInfo['company_note1'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          context.read<ProductMasterManagementBloc>().add(
                              SetProductValueEvent('company_note1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_社内備考2
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
                              .instruction_input_form_detail_11,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        height: 136,
                        maxLines: 5,
                        text: state.productInfo['company_note2'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          context.read<ProductMasterManagementBloc>().add(
                              SetProductValueEvent('company_note2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_注意備考１
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
                              .instruction_input_form_basic_9,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        height: 136,
                        maxLines: 5,
                        text: state.productInfo['notice_note1'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('notice_note1', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //商品_注意備考2
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
                              .instruction_input_form_basic_10,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                      ),
                      WMSInputboxWidget(
                        height: 136,
                        maxLines: 5,
                        text: state.productInfo['notice_note2'].toString(),
                        readOnly: state.stateFlg == '2',
                        inputBoxCallBack: (value) {
                          context
                              .read<ProductMasterManagementBloc>()
                              .add(SetProductValueEvent('notice_note2', value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              //表单按钮
              Visibility(
                visible: widget.flag == 1,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ProductMasterManagementFormButton(
                      state: state,
                      productId: widget.productId,
                    ),
                  ),
                ),
              ),
            ];
          }

          return Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: ListView(
              children: [
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ProductMasterManagementFormTab(),
                        ),
                      ),
                    ],
                  ),
                ),
                //表单内容
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(224, 224, 224, 1),
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      children: _initFormBasic(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 商品マスタ-表单Tab
// ignore: must_be_immutable
class ProductMasterManagementFormTab extends StatefulWidget {
  ProductMasterManagementFormTab({super.key});

  @override
  State<ProductMasterManagementFormTab> createState() =>
      _ProductMasterManagementFormTabState();
}

class _ProductMasterManagementFormTabState
    extends State<ProductMasterManagementFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 40,
          padding: EdgeInsets.fromLTRB(24, 10, 24, 10),
          margin: EdgeInsets.fromLTRB(0, 10, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 108,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    );
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 商品マスタ-表单按钮
// ignore: must_be_immutable
class ProductMasterManagementFormButton extends StatefulWidget {
  ProductMasterManagementModel state;
  int productId;
  ProductMasterManagementFormButton(
      {super.key, required this.state, required this.productId});

  @override
  State<ProductMasterManagementFormButton> createState() =>
      _ProductMasterManagementFormButtonState();
}

class _ProductMasterManagementFormButtonState
    extends State<ProductMasterManagementFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          child: Container(
            height: 37,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonItemList[i]['index'] == Config.NUMBER_ZERO
                      ? Color.fromRGBO(44, 167, 176, 1)
                      : (widget.state.stateFlg == '2'
                          ? Color.fromRGBO(95, 97, 97, 1)
                          : Color.fromRGBO(44, 167, 176, 1)),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {
                if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                  //新增/修改数据
                  context
                      .read<ProductMasterManagementBloc>()
                      .add(UpdateFormEvent(context));
                }
              },
              child: Text(
                buttonItemList[i]['title'],
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
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 按钮单个列表
    List _buttonItemList = [
      // {
      //   'index': Config.NUMBER_ZERO,
      //   'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      // },
      {
        'index': Config.NUMBER_ONE,
        'title': widget.productId == 0
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      }
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _initButtonList(_buttonItemList),
    );
  }
}
