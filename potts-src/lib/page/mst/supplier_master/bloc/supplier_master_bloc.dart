import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/model/supplier.dart';
import 'package:wms/page/mst/supplier_master/bloc/supplier_master_model.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：仕入先マスタ管理-BLOC
 * 作者：cuihr
 * 时间：2023/10/7
 */

// 事件
abstract class SupplierMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends SupplierMasterEvent {
  // 初始化事件
  InitEvent();
}
// 自定义事件 - 始

// 设定仕入先情报值事件
class SetSupplierValueEvent extends SupplierMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSupplierValueEvent(this.key, this.value);
}

// 设定检索条件值事件
class SetSearchValueEvent extends SupplierMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

//检索处理
class SelectSupplierEvent extends SupplierMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectSupplierEvent(this.context);
}

//清除检索条件
class ClearSelectSupplierEvent extends SupplierMasterEvent {
  ClearSelectSupplierEvent();
}

class DeleteSearchValueEvent extends SupplierMasterEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends SupplierMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除表单
class ClearFormEvent extends SupplierMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends SupplierMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//删除数据
class DeleteSupplierDataEvent extends SupplierMasterEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteSupplierDataEvent(this.context, this.Id);
}

// 表格Tab切换事件
class TableTabSwitchEvent extends SupplierMasterEvent {
  // 表格Tab下标
  int tableTabIndex;
  // 表格Tab切换事件
  TableTabSwitchEvent(this.tableTabIndex);
}

//
class SearchButtonHoveredChangeEvent extends SupplierMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends SupplierMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends SupplierMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends SupplierMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends SupplierMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}
// 自定义事件 - 终

class SupplierMasterBloc extends WmsTableBloc<SupplierMasterModel> {
  // 刷新补丁
  @override
  SupplierMasterModel clone(SupplierMasterModel src) {
    return SupplierMasterModel.clone(src);
  }

  SupplierMasterBloc(SupplierMasterModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      //初期化表单
      initForm(state);

      //初期化检索条件
      initSearch(state);

      //初期化下拉框检索内容
      await initCompany(state);
      // 自定义事件 - 终
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
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
      // 查询仕入先指示
      var query = SupabaseUtils.getClient().from('mtb_supplier').select('*');

      //会社管理员
      if (state.roleId != 1) {
        query = setSelectConditions(state, query, true);
      } else {
        query = setSelectConditions(state, query, false);
      }

      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环商品数据
      for (int i = 0; i < data.length; i++) {
        data[i]['company_name'] = getNamefromList(
            data[i]['company_id'].toString(), state.salesCompanyInfoList);
        state.records.add(WmsRecordModel(i, data[i]));
      }
      //一览总个数
      List<dynamic> supplierCount = await SupabaseUtils.getClient()
          .from("mtb_supplier")
          .select('*')
          .eq('del_kbn', '2')
          .eq('company_id', state.companyId);
      //总个数
      state.count = supplierCount.length;
      // 查询会社总数
      var queryCount = SupabaseUtils.getClient().from('mtb_supplier').select(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          );
      //设置检索条件
      //会社管理员
      if (state.roleId != 1) {
        queryCount = setSelectConditions(state, queryCount, true);
      } else {
        queryCount = setSelectConditions(state, queryCount, false);
      }
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

    // 检索处理
    on<SelectSupplierEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
        state.conditionList.add({'key': 'id', 'value': state.searchInfo['id']});
      }
      if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
        state.conditionList
            .add({'key': 'name', 'value': state.searchInfo['name']});
      }
      if (state.searchInfo['owner_name'] != '' &&
          state.searchInfo['owner_name'] != null) {
        state.conditionList.add(
            {'key': 'owner_name', 'value': state.searchInfo['owner_name']});
      }
      if (state.searchInfo['contact'] != '' &&
          state.searchInfo['contact'] != null) {
        state.conditionList
            .add({'key': 'contact', 'value': state.searchInfo['contact']});
      }
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        state.conditionList.add(
            {'key': 'company_id', 'value': state.searchInfo['company_name']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSelectSupplierEvent>(
      (event, emit) {
        // 打开加载状态
        BotToast.showLoading();
        //初期化检索条件
        initSearch(state);
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );

    // 删除检索条件值事件
    on<DeleteSearchValueEvent>((event, emit) {
      //判断删除检索条件
      dynamic deleteColumn = state.conditionList[event.index];

      if (deleteColumn['key'] == null || deleteColumn['value'] == null) {
        return;
      }
      //清空检索条件
      if ('id' == deleteColumn['key']) {
        state.searchInfo['id'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('owner_name' == deleteColumn['key']) {
        state.searchInfo['owner_name'] = '';
      } else if ('contact' == deleteColumn['key']) {
        state.searchInfo['contact'] = '';
      } else if ('company_id' == deleteColumn['key']) {
        state.searchInfo['company_id'] = '';
        state.searchInfo['company_name'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });
    //采用逻辑删除供应商数据
    on<DeleteSupplierDataEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        try {
          // 修改
          await SupabaseUtils.getClient()
              .from('mtb_supplier')
              .update({'del_kbn': Config.DELETE_YES}).eq('id', event.Id);
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // 关闭加载
        BotToast.closeAllLoading();
        // 加载标记
        state.loadingFlag = false;
        // 查询分页数据事件
        add(PageQueryEvent());
      },
    );
    on<ShowSelectValueEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        //初期化表单
        initForm(state);
        //设定数据
        state.formInfo = event.value;
        state.stateFlg = event.stateflg;
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      },
    );
    //表单清除
    on<ClearFormEvent>(
      (event, emit) {
        //初期化表单
        initForm(state);
        // 更新
        emit(clone(state));
      },
    );
    // 设定供应商情报值事件
    on<SetSupplierValueEvent>((event, emit) async {
      // 供应商情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // 供应商情报-临时
        formTemp[event.key] = event.value;
      } else {
        // 供应商情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 供应商情报-定制
      state.formInfo = formTemp;

      // 更新
      emit(clone(state));
    });
    // 表格Tab切换事件
    on<TableTabSwitchEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 表格：Tab下标
      state.tableTabIndex = event.tableTabIndex;
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    //登录/修改表单
    on<UpdateFormEvent>(
      (event, emit) async {
        //check必须输入项目
        bool checkResult = checkMustInputColumn(state.formInfo, event.context);
        // 判断验证结果
        if (!checkResult) {
          return;
        }
        //model用map做成
        Map<String, dynamic> formInfo = changeSupplierMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;
        Supplier supplier = Supplier.fromJson(formInfo);
        if (supplier.id == null) {
          //填入必须字段
          if (state.roleId != 1) {
            supplier.company_id = StoreProvider.of<WMSState>(event.context)
                .state
                .loginUser
                ?.company_id;
          }
          supplier.del_kbn = '2';
          supplier.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          supplier.create_time = DateTime.now().toString();
          supplier.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          supplier.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 新增仕入先
            formData = await SupabaseUtils.getClient()
                .from('mtb_supplier')
                .insert([supplier.toJson()]).select('*');
            // 判断商品数据
            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                      WMSLocalizations.i18n(event.context)!.create_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                      WMSLocalizations.i18n(event.context)!.create_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } else {
          //修正的场合
          //更新者更新时间
          supplier.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          supplier.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 修改商品情报
            formData = await SupabaseUtils.getClient()
                .from('mtb_supplier')
                .update(supplier.toJson())
                .eq('id', supplier.id)
                .select('*');

            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                      WMSLocalizations.i18n(event.context)!.update_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_10 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        }
        // 返回上一页
        GoRouter.of(event.context).pop('refresh return');
      },
    );

    //
    on<SearchButtonHoveredChangeEvent>((event, emit) async {
      //
      state.searchButtonHovered = event.flag;
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
  //检索前check处理
  bool selectSupplierEventBeforeCheck(
      BuildContext context, SupplierMasterModel state) {
//检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.supplier_id +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SelectSupplierEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //仕入先名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_name +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['name_kana'] == null || formInfo['name_kana'] == '') {
      //カナ名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_kana +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Kana(formInfo['name_kana'])) {
      //カナ入力check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_kana +
              WMSLocalizations.i18n(context)!.check_kana);
      return false;
    } else if (formInfo['name_short'] == null || formInfo['name_short'] == '') {
      //略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_abbreviation +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['postal_cd'] == null || formInfo['postal_cd'] == '') {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_zip_code +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号 3位半角数字-4位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_zip_code +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    } else if (formInfo['addr_1'] == null || formInfo['addr_1'] == '') {
      //都道府県
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_province +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_2'] == null || formInfo['addr_2'] == '') {
      //市区町村
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_villages +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_3'] == null || formInfo['addr_3'] == '') {
      //住所
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_address +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['tel'] == null || formInfo['tel'] == '') {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_telephone_number +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['tel'])) {
      //電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_telephone_number +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //FAX番号 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_fax_number +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['owner_name'] == null || formInfo['owner_name'] == '') {
      //代表者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_representative_name +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact'] == null || formInfo['contact'] == '') {
      //担当者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_contact_name +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact_tel'] == null ||
        formInfo['contact_tel'] == '') {
      //担当者名 -電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_contact_telephone_number +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['contact_tel'])) {
      //電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_contact_telephone_number +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_fax'] != null &&
        formInfo['contact_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['contact_fax'])) {
      //担当者名 -FAX番号 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_contact_fax_number +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_email'] == null ||
        formInfo['contact_email'] == '') {
      //担当者名 -email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_contact_email +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(formInfo['contact_email'])) {
      //担当者名 -email check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_contact_email +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    }
    if (state.roleId == 1) {
      if (formInfo['company_name'] == null || formInfo['company_name'] == '') {
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
  Map<String, dynamic> changeSupplierMap(Map<String, dynamic> formInfo) {
    Map<String, dynamic> result = formInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    if (result['company_id'] == null || result['company_id'] == '') {
      result.remove('company_id');
    } else {
      result['company_id'] = int.parse(result['company_id'].toString());
    }
    return result;
  }

  //初期化表单
  void initForm(SupplierMasterModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'name': '',
      'name_kana': '',
      'name_short': '',
      'postal_cd': '',
      'addr_1': '',
      'addr_2': '',
      'addr_3': '',
      'tel': '',
      'fax': '',
      'owner_name': '',
      'contact': '',
      'contact_tel': '',
      'contact_fax': '',
      'contact_email': '',
      'company_note1': '',
      'company_note2': '',
      'del_kbn': '2',
      'company_id': '',
      'company_name': ''
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(SupplierMasterModel state) {
    state.searchInfo = {
      'id': '',
      'name': '',
      'owner_name': '',
      'contact': '',
      'company_id': '',
      'company_name': ''
    };
    state.conditionList = [];
  }

  //初期化下拉框
  Future<void> initCompany(SupplierMasterModel state) async {
    //父菜单检索 会社情报マスタ
    List<dynamic> companyInfoList = await SupabaseUtils.getClient()
        .from('mtb_company')
        .select('*')
        .eq('status', '1');
    state.salesCompanyInfoList = [];
    if (companyInfoList.length > 0) {
      for (int i = 0; i < companyInfoList.length; i++) {
        state.salesCompanyInfoList.add({
          'id': companyInfoList[i]['id'].toString(),
          'name': companyInfoList[i]['name']
        });
      }
    }
  }

  //取得list中name
  String getNamefromList(String id, List<Map<String, dynamic>> nameList) {
    String name = '';
    if (nameList.isNotEmpty) {
      for (Map<String, dynamic> item in nameList) {
        if (item['id'] == id) {
          name = item['name'];
          break;
        }
      }
    }
    return name;
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      SupplierMasterModel state, PostgrestFilterBuilder query, bool flag) {
    if (flag) {
      query = query.eq('company_id', state.companyId).eq('del_kbn', '2');
    } else {
      query = query.eq('del_kbn', '2');
    }
    var result = query;
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameTemp.toString());
    }
    if (state.searchInfo['owner_name'] != '' &&
        state.searchInfo['owner_name'] != null) {
      String nameShotTemp = '%' + state.searchInfo['owner_name'] + '%';
      query = query.like('owner_name', nameShotTemp.toString());
    }
    if (state.searchInfo['contact'] != '' &&
        state.searchInfo['contact'] != null) {
      String nameShotTemp = '%' + state.searchInfo['contact'] + '%';
      query = query.like('contact', nameShotTemp.toString());
    }
    if (state.searchInfo['company_id'] != '' &&
        state.searchInfo['company_id'] != null) {
      query = query.eq('company_id', state.searchInfo['company_id'].toString());
    }
    return result;
  }
}
