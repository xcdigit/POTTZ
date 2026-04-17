import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/customer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'customer_master_model.dart';

/**
 * 内容：得意先マスタ管理-BLOC
 * 作者：cuihr
 * 时间：2023/10/9
 */
// 事件
abstract class CustomerMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends CustomerMasterEvent {
  // 初始化事件
  InitEvent();
}
// 自定义事件 - 始

// 设定得意先情报值事件
class SetCustomerValueEvent extends CustomerMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetCustomerValueEvent(this.key, this.value);
}

// 设定检索条件值事件
class SetSearchValueEvent extends CustomerMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

//检索处理
class SelectCustomerEvent extends CustomerMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectCustomerEvent(this.context);
}

//清除检索条件
class ClearSelectCustomerEvent extends CustomerMasterEvent {
  ClearSelectCustomerEvent();
}

//登录/修改表单
class UpdateFormEvent extends CustomerMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

class DeleteSearchValueEvent extends CustomerMasterEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends CustomerMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除表单
class ClearFormEvent extends CustomerMasterEvent {
  // 清除表单
  ClearFormEvent();
}

// 表格Tab切换事件
class TableTabSwitchEvent extends CustomerMasterEvent {
  // 表格Tab下标
  int tableTabIndex;
  // 表格Tab切换事件
  TableTabSwitchEvent(this.tableTabIndex);
}

//删除数据
class DeleteCustomerDataEvent extends CustomerMasterEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteCustomerDataEvent(this.context, this.Id);
}

//
class SearchButtonHoveredChangeEvent extends CustomerMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends CustomerMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends CustomerMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends CustomerMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends CustomerMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class CustomerMasterBloc extends WmsTableBloc<CustomerMasterModel> {
  // 刷新补丁
  @override
  CustomerMasterModel clone(CustomerMasterModel src) {
    return CustomerMasterModel.clone(src);
  }

  CustomerMasterBloc(CustomerMasterModel state) : super(state) {
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

    //查询分页数据事件
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
      // 查询得意先指示
      var query = SupabaseUtils.getClient().from('mtb_customer').select('*');

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
        //消費期限制御
        data[i]['limit_date_flg_name'] =
            data[i]['limit_date_flg'].toString() == '0'
                ? 'OFF'
                : data[i]['limit_date_flg'].toString() == '1'
                    ? '出荷エラー'
                    : data[i]['limit_date_flg'].toString() == '2'
                        ? '出荷ワーニング'
                        : '';
        state.records.add(WmsRecordModel(i, data[i]));
      }
      //一览总个数
      List<dynamic> customerCount = await SupabaseUtils.getClient()
          .from("mtb_customer")
          .select('*')
          .eq('del_kbn', '2')
          .eq('company_id', state.companyId);
      //总个数
      state.count = customerCount.length;
      // 查询会社总数
      var queryCount = SupabaseUtils.getClient().from('mtb_customer').select(
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
    on<SelectCustomerEvent>((event, emit) async {
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
    on<ClearSelectCustomerEvent>(
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
    //采用逻辑删除客户数据
    on<DeleteCustomerDataEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        try {
          // 修改
          await SupabaseUtils.getClient()
              .from('mtb_customer')
              .update({'del_kbn': Config.DELETE_YES}).eq('id', event.Id);
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                  WMSLocalizations.i18n(event.context)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
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
    // 设定客户情报值事件
    on<SetCustomerValueEvent>((event, emit) async {
      // 客户情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // 客户情报-临时
        formTemp[event.key] = event.value;
      } else {
        // 客户情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 客户情报-定制
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
        Map<String, dynamic> formInfo = changeCustomerMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;
        Customer customer = Customer.fromJson(formInfo);
        if (customer.id == null) {
          //填入必须字段
          if (state.roleId != 1) {
            customer.company_id = StoreProvider.of<WMSState>(event.context)
                .state
                .loginUser
                ?.company_id;
            ;
          }
          //设定消費期限制御默认值
          if (customer.limit_date_flg == null) {
            customer.limit_date_flg = '0';
          }
          customer.del_kbn = '2';
          customer.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          customer.create_time = DateTime.now().toString();
          customer.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          customer.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 新增仕入先
            formData = await SupabaseUtils.getClient()
                .from('mtb_customer')
                .insert([customer.toJson()]).select('*');
            // 判断商品数据
            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                      WMSLocalizations.i18n(event.context)!.create_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                      WMSLocalizations.i18n(event.context)!.create_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } else {
          //修正的场合
          //更新者更新时间
          customer.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          customer.update_time = DateTime.now().toString();
          //设定消費期限制御默认值
          if (customer.limit_date_flg == null) {
            customer.limit_date_flg = '0';
          }
          try {
            BotToast.showLoading();
            // 修改商品情报
            formData = await SupabaseUtils.getClient()
                .from('mtb_customer')
                .update(customer.toJson())
                .eq('id', customer.id)
                .select('*');

            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                      WMSLocalizations.i18n(event.context)!.update_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_6 +
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
  bool selectCustomerEventBeforeCheck(
      BuildContext context, CustomerMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.customer_master_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SelectCustomerEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['name_kana'] == null || formInfo['name_kana'] == '') {
      //カナ名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Kana(formInfo['name_kana'])) {
      //カナ入力check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_3 +
              WMSLocalizations.i18n(context)!.check_kana);
      return false;
    } else if (formInfo['name_short'] == null || formInfo['name_short'] == '') {
      //略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['corporation_number'] == null ||
        formInfo['corporation_number'] == '') {
      // 法人番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_20 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['postal_cd'] == null || formInfo['postal_cd'] == '') {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号 3位半角数字-4位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_5 +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    } else if (formInfo['classify_1'] == null || formInfo['classify_1'] == '') {
      // 大分類
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_21 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['classify_2'] == null || formInfo['classify_2'] == '') {
      // 中分類
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_22 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['classify_3'] == null || formInfo['classify_3'] == '') {
      // 小分類
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_23 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['country'] == null || formInfo['country'] == '') {
      // 国
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_24 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['region'] == null || formInfo['region'] == '') {
      // 地域
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_25 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_1'] == null || formInfo['addr_1'] == '') {
      //都道府県
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_6 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_2'] == null || formInfo['addr_2'] == '') {
      //市区町村
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_7 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_3'] == null || formInfo['addr_3'] == '') {
      //住所
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_29 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_4'] == null || formInfo['addr_4'] == '') {
      // 住所詳細2
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_26 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['tel'] == null || formInfo['tel'] == '') {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_9 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['tel'])) {
      //電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .customer_master_9 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //Fax 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .customer_master_10 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['owner_name'] == null || formInfo['owner_name'] == '') {
      //代表者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_11 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact'] == null || formInfo['contact'] == '') {
      //担当者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_12 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact_tel'] == null ||
        formInfo['contact_tel'] == '') {
      //担当者名 -電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_13 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['contact_tel'])) {
      //担当者名 -電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .customer_master_13 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_fax'] != null &&
        formInfo['contact_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['contact_fax'])) {
      //Fax 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .customer_master_14 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_email'] == null ||
        formInfo['contact_email'] == '') {
      //担当者名 -email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_15 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(formInfo['contact_email'])) {
      //担当者名 -email check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_15 +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    } else if (formInfo['application_start_date'] == null ||
        formInfo['application_start_date'] == '') {
      // 適用開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_27 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['application_end_date'] == null ||
        formInfo['application_end_date'] == '') {
      // 適用終了日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_28 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (DateFormat('yyyy/MM/dd')
        .parse(formInfo['application_end_date'].toString().replaceAll('-', '/'))
        .isBefore(DateFormat('yyyy/MM/dd').parse(
            formInfo['application_start_date']
                .toString()
                .replaceAll('-', '/')))) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_30);
      return false;
    } else if (formInfo['limit_date'] == null || formInfo['limit_date'] == '') {
      // 消費期限
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_31 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_In_3(formInfo['limit_date'])) {
      //消費期限 半角数字 3桁以内
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.customer_master_31 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_3);
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
  Map<String, dynamic> changeCustomerMap(Map<String, dynamic> formInfo) {
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
  void initForm(CustomerMasterModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'name': '',
      'name_kana': '',
      'name_short': '',
      'corporation_number': '',
      'postal_cd': '',
      'classify_1': '',
      'classify_2': '',
      'classify_3': '',
      'country': '',
      'region': '',
      'addr_1': '',
      'addr_2': '',
      'addr_3': '',
      'addr_4': '',
      'tel': '',
      'fax': '',
      'owner_name': '',
      'contact': '',
      'contact_tel': '',
      'contact_fax': '',
      'contact_email': '',
      'application_start_date': '',
      'application_end_date': '',
      'company_note1': '',
      'company_note2': '',
      'del_kbn': '2',
      'company_name': '',
      'limit_date': '',
      'limit_date_flg': '0',
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(CustomerMasterModel state) {
    state.searchInfo = {
      'id': '',
      'name': '',
      'owner_name': '',
      'contact': '',
      'company_id': '',
      'company_name': ''
    };
    state.conditionList = [];
  } //设定检索条件

  //初期化下拉框
  Future<void> initCompany(CustomerMasterModel state) async {
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

  PostgrestFilterBuilder setSelectConditions(
      CustomerMasterModel state, PostgrestFilterBuilder query, bool flag) {
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
      query = query.eq('contact', state.searchInfo['contact'].toString());
    }
    if (state.searchInfo['company_id'] != '' &&
        state.searchInfo['company_id'] != null) {
      query = query.eq('company_id', state.searchInfo['company_id'].toString());
    }
    return result;
  }
}
