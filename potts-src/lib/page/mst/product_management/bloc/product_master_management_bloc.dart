import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/common/utils/printer_utils.dart';
import 'package:wms/model/product.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/common_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'product_master_management_model.dart';

/**
 * 内容：商品マスタ管理-BLOC
 * 作者：穆政道
 * 时间：2023/09/21
 */
// 事件
abstract class ProductMasterManagementEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ProductMasterManagementEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends ProductMasterManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends ProductMasterManagementEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定商品情报值事件
class SetProductValueEvent extends ProductMasterManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetProductValueEvent(this.key, this.value);
}

//设定按钮显示状态
class SetStateFlgValueEvent extends ProductMasterManagementEvent {
  // flg
  String flg;
  // 设定值事件
  SetStateFlgValueEvent(this.flg);
}

//清除表单
class ClearFormEvent extends ProductMasterManagementEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends ProductMasterManagementEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//显示form数据
class ShowSelectValueEvent extends ProductMasterManagementEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//消除处理
class DeleteProductEvent extends ProductMasterManagementEvent {
  // 结构树
  BuildContext context;
  //商品主键
  int productId;
  //消除处理
  DeleteProductEvent(this.context, this.productId);
}

//检索处理
class SeletProductEvent extends ProductMasterManagementEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletProductEvent(this.context);
}

//清除检索条件
class ClearSeletProductEvent extends ProductMasterManagementEvent {
  //检索处理
  ClearSeletProductEvent();
}

//标签打印
class PrinterProductEvent extends ProductMasterManagementEvent {
  // 赵士淞 - 始
  // 标签打印
  PrinterProductEvent();
  // 赵士淞 - 终
}

//
class SearchButtonHoveredChangeEvent extends ProductMasterManagementEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class ImportButtonHoveredChangeEvent extends ProductMasterManagementEvent {
  //
  bool flag;
  //
  ImportButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends ProductMasterManagementEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends ProductMasterManagementEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends ProductMasterManagementEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 导入CSV文件事件
class ImportCSVFileEvent extends ProductMasterManagementEvent {
  // 内容
  List<List<Map<String, dynamic>>> content;
  // 导入CSV文件事件
  ImportCSVFileEvent(this.content);
}

// 设置sort字段
class SetSortEvent extends ProductMasterManagementEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}
// 自定义事件 - 终

class ProductMasterManagementBloc
    extends WmsTableBloc<ProductMasterManagementModel> {
  // 刷新补丁
  @override
  ProductMasterManagementModel clone(ProductMasterManagementModel src) {
    return ProductMasterManagementModel.clone(src);
  }

  ProductMasterManagementBloc(ProductMasterManagementModel state)
      : super(state) {
    // 查询分页数据事件
    on<PageQueryEvent>((event, emit) async {
      // 判断加载标记
      if (state.loadingFlag) {
        // 打开加载状态
        BotToast.showLoading();
      } else {
        // 页数
        state.pageNum = 0;
        // 加载标记
        state.loadingFlag = true;
      }
      // 查询商品マスタ
      var query = SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('del_kbn', Config.DELETE_NO);

      query = setSelectConditions(state, query);

      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      //查询会社信息(包含退会会社)
      List<dynamic> mtbCompanyList =
          await SupabaseUtils.getClient().from('mtb_company').select('*');
      // 循环商品数据
      for (int i = 0; i < data.length; i++) {
        dynamic mtbCompany = mtbCompanyList.firstWhere(
            (mtbCompany) => mtbCompany['id'] == data[i]['company_id'],
            orElse: () => null);
        if (mtbCompany != null) {
          data[i]['company_name'] = mtbCompany['name'];
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询商品总数
      var queryCount = SupabaseUtils.getClient()
          .from('mtb_product')
          .select(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          )
          .eq('del_kbn', Config.DELETE_NO);
      //设置检索条件
      queryCount = setSelectConditions(state, queryCount);
      final countResult = await queryCount;
      // 总页数
      state.total = countResult.count;

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定检索条件值事件
    on<SetSearchValueEvent>((event, emit) async {
      // 检索情报-临时
      Map<String, dynamic> searchTemp = Map<String, dynamic>();
      searchTemp.addAll(state.searchInfo);
      // 判断key
      if (searchTemp[event.key] != null) {
        // 检索情报-临时
        searchTemp[event.key] = event.value;
      } else {
        // 检索情报-临时
        searchTemp.addAll({event.key: event.value});
      }
      // 检索情报-定制
      state.searchInfo = searchTemp;

      // 更新
      emit(clone(state));
    });

    // 删除检索条件值事件
    on<DeleteSearchValueEvent>((event, emit) {
      //判断删除检索条件
      dynamic deleteColumn = state.conditionList[event.index];

      if (deleteColumn['key'] == null || deleteColumn['value'] == null) {
        return;
      }
      //清空检索条件
      if ('code' == deleteColumn['key']) {
        state.searchInfo['code'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('name_short' == deleteColumn['key']) {
        state.searchInfo['name_short'] = '';
      } else if ('jan_cd' == deleteColumn['key']) {
        state.searchInfo['jan_cd'] = '';
      } else if ('company_id' == deleteColumn['key']) {
        state.searchInfo['company_id'] = '';
        state.searchInfo['company_name'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 设定商品情报值事件
    on<SetProductValueEvent>((event, emit) async {
      // 商品情报-临时
      Map<String, dynamic> productTemp = Map<String, dynamic>();
      productTemp.addAll(state.productInfo);
      // 判断key
      if (productTemp[event.key] != null) {
        // 商品情报-临时
        productTemp[event.key] = event.value;
      } else {
        // 商品情报-临时
        productTemp.addAll({event.key: event.value});
      }
      // 商品情报-定制
      state.productInfo = productTemp;

      //如果更新的是写真
      if (event.key == 'image1') {
        state.image1Network =
            await WMSCommonFile().previewImageFile(event.value);
      } else if (event.key == 'image2') {
        state.image2Network =
            await WMSCommonFile().previewImageFile(event.value);
      }

      // 更新
      emit(clone(state));
    });

    // 设定按钮显示状态
    on<SetStateFlgValueEvent>((event, emit) {
      //设定flg
      state.stateFlg = event.flg;
      // 更新
      emit(clone(state));
    });

    //表单清除
    on<ClearFormEvent>(
      (event, emit) {
        //初期化表单
        initForm(state);
        // 更新
        emit(clone(state));
      },
    );

    //登录/修改表单
    on<UpdateFormEvent>((event, emit) async {
      //check必须输入项目
      bool checkResult = checkMustInputColumn(state.productInfo, event.context);
      // 判断验证结果
      if (!checkResult) {
        return;
      }
      //判断商品コード不能重复
      if (state.productInfo['code'] != null &&
          state.productInfo['code'] != '') {
        var code = state.productInfo['code'].toString();
        List<dynamic> list = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('code', code)
            .eq('del_kbn', '2');
        if (list.length > 0) {
          if (state.productInfo['id'] != null) {
            var id = state.productInfo['id'];
            if (list[0]['id'] != id) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .product_master_management_product_code_notRepeat);
              return;
            }
          } else {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                    .product_master_management_product_code_notRepeat);
            return;
          }
        }
      }
      // 判断JANCD不能重复
      if (state.productInfo['jan_cd'] != null &&
          state.productInfo['jan_cd'] != '') {
        var janCd = state.productInfo['jan_cd'].toString();
        List<dynamic> list = await SupabaseUtils.getClient()
            .from('mtb_product')
            .select('*')
            .eq('jan_cd', janCd)
            .eq('del_kbn', '2');
        if (list.length > 0) {
          if (state.productInfo['id'] != null) {
            var id = state.productInfo['id'];
            if (list[0]['id'] != id) {
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .product_master_management_product_jan_cd_notRepeat);
              return;
            }
          } else {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!
                    .product_master_management_product_jan_cd_notRepeat);
            return;
          }
        }
      }

      //model用map做成
      Map<String, dynamic> productInfo = changeProductMap(state.productInfo);
      // 商品master数据
      List<Map<String, dynamic>> productData;
      Product product = Product.fromJson(productInfo);
      //判断登录场合
      if (product.id == null) {
        //填入必须字段
        product.stock_limit = Config.NUMBER_ZERO;
        if (Config.ROLE_ID_1 != state.roleId) {
          product.company_id = StoreProvider.of<WMSState>(event.context)
              .state
              .loginUser
              ?.company_id;
        }
        product.del_kbn = Config.DELETE_NO;
        product.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        product.create_time = DateTime.now().toString();
        product.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        product.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 新增商品
          productData = await SupabaseUtils.getClient()
              .from('mtb_product')
              .insert([product.toJson()]).select('*');
          // 判断商品数据
          if (productData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!
                        .product_master_management_tableName +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!
                        .product_master_management_tableName +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!
                      .product_master_management_tableName +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        product.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        product.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 修改商品情报
          productData = await SupabaseUtils.getClient()
              .from('mtb_product')
              .update(product.toJson())
              .eq('id', product.id)
              .select('*');
          // 判断出荷指示数据
          if (productData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!
                        .product_master_management_tableName +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!
                        .product_master_management_tableName +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!
                      .product_master_management_tableName +
                  WMSLocalizations.i18n(event.context)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }

      // 返回上一页
      GoRouter.of(event.context).pop('refresh return');
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    //显示form数据
    on<ShowSelectValueEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //初期化表单
      initForm(state);
      //设定数据
      state.productInfo = event.value;
      state.stateFlg = event.stateflg;
      if (event.value['image1'] != null && event.value['image1'] != "") {
        state.image1Network =
            await WMSCommonFile().previewImageFile(event.value['image1']);
      }
      if (event.value['image2'] != null && event.value['image2'] != "") {
        state.image2Network =
            await WMSCommonFile().previewImageFile(event.value['image2']);
      }
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除商品事件
    on<DeleteProductEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 修改商品消除区分
        List<Map<String, dynamic>> productData = await SupabaseUtils.getClient()
            .from('mtb_product')
            .update({'del_kbn': Config.DELETE_YES})
            .eq('id', event.productId)
            .select('*');
        // 判断出荷指示明细数据
        if (productData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!
                      .product_master_management_tableName +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!
                      .product_master_management_tableName +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(WMSLocalizations.i18n(event.context)!
                .product_master_management_tableName +
            WMSLocalizations.i18n(event.context)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 检索处理
    on<SeletProductEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['code'] != '' && state.searchInfo['code'] != null) {
        if (CheckUtils.check_Half_Alphanumeric_6_50(state.searchInfo['code'])) {
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                  .instruction_input_table_title_3 +
              WMSLocalizations.i18n(state.context)!
                  .input_must_six_number_check);
          // 加载标记
          state.loadingFlag = false;
          // 关闭加载
          BotToast.closeAllLoading();
          // 终止
          return;
        } else {
          state.conditionList
              .add({'key': 'code', 'value': state.searchInfo['code']});
        }
      }
      if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
        state.conditionList
            .add({'key': 'name', 'value': state.searchInfo['name']});
      }
      if (state.searchInfo['name_short'] != '' &&
          state.searchInfo['name_short'] != null) {
        state.conditionList.add(
            {'key': 'name_short', 'value': state.searchInfo['name_short']});
      }
      if (state.searchInfo['jan_cd'] != '' &&
          state.searchInfo['jan_cd'] != null) {
        if (CheckUtils.check_Half_Alphanumeric_Symbol(
            state.searchInfo['jan_cd'])) {
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
                  .product_master_management_junk +
              WMSLocalizations.i18n(state.context)!
                  .input_letter_and_number_and_symbol_check);
          // 加载标记
          state.loadingFlag = false;
          // 关闭加载
          BotToast.closeAllLoading();
          // 终止
          return;
        } else {
          state.conditionList
              .add({'key': 'jan_cd', 'value': state.searchInfo['jan_cd']});
        }
      }
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        state.conditionList.add(
            {'key': 'company_id', 'value': state.searchInfo['company_name']});
      }

      //缩小检索框，显示检索条件
      if (state.searchInfo['code'] != '' ||
          state.searchInfo['name'] != '' ||
          state.searchInfo['name_short'] != '' ||
          state.searchInfo['jan_cd'] != '' ||
          state.searchInfo['company_id'] != '') {
        //
        add(SetSearchDataFlagAndSearchFlagEvent(true, false));
      } else {
        //
        add(SetSearchDataFlagAndSearchFlagEvent(false, false));
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletProductEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    //标签打印
    on<PrinterProductEvent>((event, emit) async {
      // 赵士淞 - 始
      // 打开加载状态
      BotToast.showLoading();

      // 查询商品
      List<dynamic> productData = await SupabaseUtils.getClient()
          .from('mtb_product')
          .select('*')
          .eq('id', state.checkedRecords()[0].data['id']);
      // 判断商品数量
      if (productData.length != 0) {
        // 打印数据
        Map<String, dynamic> printData = {
          'code': productData[0]['code'],
          'name': productData[0]['name_short'],
          'type': productData[0]['packing_type'],
        };
        // 商品ラベル打印
        PrinterUtils.productInfoPrint(1, printData);
      } else {
        // 消息提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.miss_param_unable_print);
      }

      // 关闭加载
      BotToast.closeAllLoading();
      // 赵士淞 - 终
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      //初期化表单
      initForm(state);

      //初期化检索条件
      initSearch(state);

      //初期化角色ID
      state.roleId = StoreProvider.of<WMSState>(state.context)
          .state
          .loginUser!
          .role_id as int;
      //admin的场合检索会社list
      if (Config.ROLE_ID_1 == state.roleId) {
        //设置商品名显示长度
        state.productNameLength = 0.3;
        //设定会社名列表
        List companyList = await SupabaseUtils.getClient()
            .from('mtb_company')
            .select('*')
            .eq('status', Config.WMS_COMPANY_STATUS_1);
        state.companyInfoList = companyList;
      }

      // 自定义事件 - 终
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //
    on<SearchButtonHoveredChangeEvent>((event, emit) async {
      //
      state.searchButtonHovered = event.flag;
      // 更新
      emit(clone(state));
    });

    //
    on<ImportButtonHoveredChangeEvent>((event, emit) async {
      //
      state.importButtonHovered = event.flag;
      // 更新
      emit(clone(state));
    });

    //
    on<SearchOutlinedButtonPressedEvent>((event, emit) async {
      state.searchFlag = !state.searchFlag;
      if (state.searchFlag) {
        state.searchDataFlag = false;
      } else if (state.conditionList.length > 0) {
        state.searchDataFlag = true;
      } else {
        state.searchDataFlag = false;
      }
      // 更新
      emit(clone(state));
    });

    //
    on<SearchInkWellTapEvent>((event, emit) async {
      state.searchFlag = !state.searchFlag;
      if (state.conditionList.length > 0) {
        state.searchDataFlag = true;
      } else {
        state.searchDataFlag = false;
      }
      // 更新
      emit(clone(state));
    });

    //
    on<SetSearchDataFlagAndSearchFlagEvent>((event, emit) async {
      state.searchDataFlag = event.searchDataFlag;
      state.searchFlag = event.searchFlag;
      // 更新
      emit(clone(state));
    });

    // 导入CSV文件事件
    on<ImportCSVFileEvent>((event, emit) async {
      // 判断内容长度
      if (event.content.length == 0) {
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 判断内容长度
      if (event.content.length == 1) {
        // 商品列表
        List<Map<String, dynamic>> productList = event.content[0];
        // 循环商品列表
        for (int i = 0; i < productList.length; i++) {
          // 检查导入数据
          bool flag = checkImportData(productList[i], state.context);
          // 判断
          if (flag) {
            //判断商品コード不能重复
            List<dynamic> list1 = await SupabaseUtils.getClient()
                .from('mtb_product')
                .select('*')
                .eq('code', productList[i]['code'])
                .eq('del_kbn', '2');
            if (list1.length > 0) {
              // 消息提示
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(state.context)!
                      .product_master_management_product_code_notRepeat);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
            //判断JANCD不能重复
            List<dynamic> list2 = await SupabaseUtils.getClient()
                .from('mtb_product')
                .select('*')
                .eq('jan_cd', productList[i]['jan_cd'])
                .eq('del_kbn', '2');
            if (list2.length > 0) {
              // 消息提示
              WMSCommonBlocUtils.tipTextToast(
                  WMSLocalizations.i18n(state.context)!
                      .product_master_management_product_jan_cd_notRepeat);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        }
        // 循环商品列表
        for (int i = 0; i < productList.length; i++) {
          // 格式化
          Map<String, dynamic> productInfo = productList[i];
          productInfo.remove('id');
          productInfo['packing_num'] =
              int.parse(productInfo['packing_num'].toString());
          // 商品
          Product product = Product.fromJson(productInfo);
          product.del_kbn = '2';
          product.company_id = StoreProvider.of<WMSState>(state.context)
              .state
              .loginUser!
              .company_id;
          product.create_time = DateTime.now().toString();
          product.create_id =
              StoreProvider.of<WMSState>(state.context).state.loginUser!.id;
          product.update_time = DateTime.now().toString();
          product.update_id =
              StoreProvider.of<WMSState>(state.context).state.loginUser!.id;
          // 新增商品
          List<Map<String, dynamic>> productData =
              await SupabaseUtils.getClient()
                  .from('mtb_product')
                  .insert([product.toJson()]).select('*');
          // 判断商品数据
          if (productData.length == 0) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.context)!
                        .product_master_management_tableName +
                    WMSLocalizations.i18n(state.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        }
      } else {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.file_type_csv +
                WMSLocalizations.i18n(state.context)!.import_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 成功提示
      WMSCommonBlocUtils.successTextToast(
          WMSLocalizations.i18n(state.context)!.file_type_csv +
              WMSLocalizations.i18n(state.context)!.import_success);
      // 插入操作履历
      CommonUtils().createLogInfo(
          '商品データCSV' +
              Config.OPERATION_TEXT1 +
              Config.OPERATION_BUTTON_TEXT9 +
              Config.OPERATION_TEXT2,
          "ImportCSVFileEvent()",
          StoreProvider.of<WMSState>(state.context).state.loginUser!.company_id,
          StoreProvider.of<WMSState>(state.context).state.loginUser!.id);

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 设置sort字段
    on<SetSortEvent>((event, emit) async {
      state.sortCol = event.sortCol;
      state.ascendingFlg = event.asc;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    add(InitEvent());
  }
  //自定义方法 - 始
  // 检查导入数据
  bool checkImportData(Map<String, dynamic> productInfo, BuildContext context) {
    if (productInfo['name'] == null || productInfo['name'] == '') {
      //商品名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['code'] == null || productInfo['code'] == '') {
      //商品コード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_6_50(productInfo['code'])) {
      //商品コード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_3 +
              WMSLocalizations.i18n(context)!.text_must_six_number_letter);
      return false;
    } else if (productInfo['name_short'] == null ||
        productInfo['name_short'] == '') {
      //商品_略称
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_product_abbreviation +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['jan_cd'] == null || productInfo['jan_cd'] == '') {
      //商品_JANCD
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_junk +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_Symbol(
        productInfo['jan_cd'])) {
      //商品_JANCD
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_junk +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    } else if (productInfo['category_l'] == null ||
        productInfo['category_l'] == '') {
      //商品_大分類
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_major_categories +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['category_m'] == null ||
        productInfo['category_m'] == '') {
      //商品_中分類
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_medium_classification +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['category_s'] == null ||
        productInfo['category_s'] == '') {
      //商品_小分類
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_subclassification +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['size'] == null || productInfo['size'] == '') {
      //商品_規格
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['packing_type'] == null ||
        productInfo['packing_type'] == '') {
      //商品_荷姿
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_form_detail_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['packing_num'] == null ||
        productInfo['packing_num'] == '') {
      //商品_入数
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_quantity +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_In_10(
        state.productInfo['packing_num'])) {
      //商品_入数 半角数字
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_quantity +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
      return false;
    }
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> productInfo, BuildContext context) {
    if (productInfo['name'] == null || productInfo['name'] == '') {
      //商品名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['code'] == null || productInfo['code'] == '') {
      //商品コード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_6_50(productInfo['code'])) {
      //商品コード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_3 +
              WMSLocalizations.i18n(context)!.text_must_six_number_letter);
      return false;
    } else if (productInfo['name_short'] == null ||
        productInfo['name_short'] == '') {
      //商品_略称
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_product_abbreviation +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['jan_cd'] == null || productInfo['jan_cd'] == '') {
      //商品_JANCD
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_junk +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric_Symbol(
        productInfo['jan_cd'])) {
      //商品_JANCD
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_junk +
              WMSLocalizations.i18n(context)!
                  .check_half_width_alphanumeric_with_symbol);
      return false;
    } else if (productInfo['category_l'] == null ||
        productInfo['category_l'] == '') {
      //商品_大分類
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_major_categories +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['category_m'] == null ||
        productInfo['category_m'] == '') {
      //商品_中分類
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_medium_classification +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['category_s'] == null ||
        productInfo['category_s'] == '') {
      //商品_中分類
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .product_master_management_subclassification +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['size'] == null || productInfo['size'] == '') {
      //商品_規格
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_table_title_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['packing_type'] == null ||
        productInfo['packing_type'] == '') {
      //商品_荷姿
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.instruction_input_form_detail_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['packing_num'] == null ||
        productInfo['packing_num'] == '') {
      //商品_入数
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_quantity +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_In_10(
        state.productInfo['packing_num'])) {
      //商品_入数 半角数字
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_quantity +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
      return false;
    } else if (productInfo['image1'] == null || productInfo['image1'] == '') {
      //商品_写真１
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_photo_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (productInfo['image2'] == null || productInfo['image2'] == '') {
      //商品_写真2
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.product_master_management_photo_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    if (productInfo['company_id'] == null || productInfo['company_id'] == '') {
      if (Config.ROLE_ID_1 == state.roleId) {
        //会社名
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.company_information_2 +
                WMSLocalizations.i18n(context)!.can_not_null_text);
        return false;
      }
    }

    return true;
  }

  //model用map做成
  Map<String, dynamic> changeProductMap(Map<String, dynamic> productInfo) {
    Map<String, dynamic> result = productInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    if (result['packing_num'] == null || result['packing_num'] == '') {
      result.remove('packing_num');
    } else {
      result['packing_num'] = int.parse(result['packing_num'].toString());
    }
    //判断不是超管角色
    if (result['company_id'] == null || result['company_id'] == '') {
      result.remove('company_id');
    }
    return result;
  }

  //初期化表单
  void initForm(ProductMasterManagementModel state) {
    // 商品情报初期化
    state.productInfo = {
      'id': '',
      'code': '',
      'name': '',
      'name_short': '',
      'jan_cd': '',
      'category_l': '',
      'category_m': '',
      'category_s': '',
      'size': '',
      'packing_type': '',
      'packing_num': '',
      'image1': '',
      'image2': '',
      'company_note1': '',
      'company_note2': '',
      'notice_note1': '',
      'notice_note2': '',
      'company_id': '',
      'company_name': ''
    };
    //写真路径初期化
    state.image1Network = '';
    state.image2Network = '';
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(ProductMasterManagementModel state) {
    state.searchInfo = {
      'code': '',
      'name': '',
      'name_short': '',
      'jan_cd': '',
      'company_id': '',
      'company_name': ''
    };
    state.conditionList = [];
  }

  PostgrestFilterBuilder setSelectConditions(
      ProductMasterManagementModel state, PostgrestFilterBuilder query) {
    var result = query;
    //判断登录角色
    if (Config.ROLE_ID_1 == state.roleId) {
      //超级管理员的场合
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        query = query.eq('company_id', state.searchInfo['company_id']);
      }
    } else {
      //其他角色的场合
      query = query.eq(
          'company_id',
          StoreProvider.of<WMSState>(state.context).state.loginUser!.company_id
              as int);
    }
    if (state.searchInfo['code'] != '' && state.searchInfo['code'] != null) {
      query = query.eq('code', state.searchInfo['code'].toString());
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameTemp.toString());
    }
    if (state.searchInfo['name_short'] != '' &&
        state.searchInfo['name_short'] != null) {
      String nameShotTemp = '%' + state.searchInfo['name_short'] + '%';
      query = query.like('name_short', nameShotTemp.toString());
    }
    if (state.searchInfo['jan_cd'] != '' &&
        state.searchInfo['jan_cd'] != null) {
      query = query.eq('jan_cd', state.searchInfo['jan_cd'].toString());
    }
    return result;
  }
  //自定义方法 - 终
}
