import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/model/delivery.dart';
import 'package:wms/page/mst/delivery_operators_master/bloc/delivery_operators_master_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_record_model.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';

import '../../../../common/utils/check_utils.dart';

/**
 * 内容：配送業者マスタ管理-BLOC
 * 作者：cuihr
 * 时间：2023/12/01
 */
// 事件
abstract class DeliveryOperatorsMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends DeliveryOperatorsMasterEvent {
  // 初始化事件
  InitEvent();
}

// 设定表单情报值事件
class SetOperatorsValueEvent extends DeliveryOperatorsMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetOperatorsValueEvent(this.key, this.value);
}

//清除表单
class ClearFormEvent extends DeliveryOperatorsMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends DeliveryOperatorsMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

// 设定检索条件值事件
class SetSearchValueEvent extends DeliveryOperatorsMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // Value
  dynamic name;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value, this.name);
}

// 设定下拉框情报值事件
class SetDropdownValueEvent extends DeliveryOperatorsMasterEvent {
  // id
  String key;
  // name
  dynamic value;
  // 设定值事件
  SetDropdownValueEvent(this.key, this.value);
}

//检索处理
class SelectOperatorsEvent extends DeliveryOperatorsMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectOperatorsEvent(this.context);
}

//清除检索条件
class ClearSelectOperatorsEvent extends DeliveryOperatorsMasterEvent {
  ClearSelectOperatorsEvent();
}

class DeleteSearchValueEvent extends DeliveryOperatorsMasterEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends DeliveryOperatorsMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//删除数据
class DeleteOperatorsDataEvent extends DeliveryOperatorsMasterEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteOperatorsDataEvent(this.context, this.Id);
}

//
class SearchButtonHoveredChangeEvent extends DeliveryOperatorsMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends DeliveryOperatorsMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends DeliveryOperatorsMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends DeliveryOperatorsMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends DeliveryOperatorsMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

class DeliveryOperatorsMasterBloc
    extends WmsTableBloc<DeliveryOperatorsMasterModel> {
  // 刷新补丁
  @override
  DeliveryOperatorsMasterModel clone(DeliveryOperatorsMasterModel src) {
    return DeliveryOperatorsMasterModel.clone(src);
  }

  DeliveryOperatorsMasterBloc(DeliveryOperatorsMasterModel state)
      : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      // 加载标记
      state.loadingFlag = false;
      //初期化表单
      initForm(state);
      initSearch(state);
      //初期化父菜单list
      await initCompany(state);
      // 自定义事件 - 终

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
      // 查询指示 運送会社マスタ
      var query = SupabaseUtils.getClient().from('mtb_delivery').select('*');
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
            data[i]['company_id'].toString(), state.companyList);
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询总数
      var queryCount = SupabaseUtils.getClient().from('mtb_delivery').select(
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
    // 设定表单情报值事件
    on<SetOperatorsValueEvent>(
      (event, emit) {
        // 表单情报-临时
        Map<String, dynamic> formTemp = Map<String, dynamic>();
        formTemp.addAll(state.formInfo);
        // 判断key
        if (formTemp[event.key] != null) {
          // 表单情报-临时
          formTemp[event.key] = event.value;
        } else {
          // 表单情报-临时
          formTemp.addAll({event.key: event.value});
        }
        // 表单情报-定制
        state.formInfo = formTemp;

        // 更新
        emit(clone(state));
      },
    );
    // 设定下拉框情报值事件
    on<SetDropdownValueEvent>((event, emit) async {
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      if (formTemp[event.key] != null) {
        formTemp[event.key] = event.value;
      } else {
        formTemp.addAll({event.key: event.value});
      }
      state.formInfo = formTemp;
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
    on<UpdateFormEvent>(
      (event, emit) async {
        //check必须输入项目
        bool checkResult =
            await checkMustInputColumn(state.formInfo, event.context);
        // 判断验证结果
        if (!checkResult) {
          return;
        }
        //model用map做成
        Map<String, dynamic> formInfo = changeOperatorsMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;

        Delivery del = Delivery.fromJson(formInfo);
        if (del.id == null) {
          if (state.roleId != 1) {
            //填入必须字段
            del.company_id = StoreProvider.of<WMSState>(event.context)
                .state
                .loginUser
                ?.company_id;
          }
          del.del_kbn = '2';
          del.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          del.create_time = DateTime.now().toString();
          del.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          del.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 新增仕入先
            formData = await SupabaseUtils.getClient()
                .from('mtb_delivery')
                .insert([del.toJson()]).select('*');
            // 判断商品数据
            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
                      WMSLocalizations.i18n(event.context)!.create_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
                      WMSLocalizations.i18n(event.context)!.create_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } else {
          //修正的场合
          //更新者更新时间
          del.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          del.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 修改商品情报
            formData = await SupabaseUtils.getClient()
                .from('mtb_delivery')
                .update(del.toJson())
                .eq('id', del.id)
                .select('*');

            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
                      WMSLocalizations.i18n(event.context)!.update_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
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
      if (event.key == 'company_id') {
        // 检索情报-临时
        searchTemp['company_name'] = event.name;
      }
      // 检索情报-定制
      state.searchInfo = searchTemp;
      // 更新
      emit(clone(state));
    });
    //清除检索条件
    on<ClearSelectOperatorsEvent>(
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

//采用逻辑删除客户数据
    on<DeleteOperatorsDataEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        try {
          // 修改
          await SupabaseUtils.getClient()
              .from('mtb_delivery')
              .update({'del_kbn': Config.DELETE_YES}).eq('id', event.Id);

          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_7 +
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
// 检索处理
    on<SelectOperatorsEvent>((event, emit) async {
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
  bool selectOperatorsEventBeforeCheck(
      BuildContext context, DeliveryOperatorsMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' &&
        state.searchInfo['id'] != null &&
        CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
      // 運送会社ID
      WMSCommonBlocUtils.errorTextToast(
          'ID' + WMSLocalizations.i18n(context)!.input_int_in_10_check);
      return false;
    }
    add(SelectOperatorsEvent(context));
    return true;
  }

//check必须输入项目
  Future<bool> checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) async {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //運送会社名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.operator_text_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['postal_cd'] == null || formInfo['postal_cd'] == '') {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_zipCode +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_zipCode +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    } else if (formInfo['addr_1'] == null || formInfo['addr_1'] == '') {
      //都道府県
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_prefecture +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_2'] == null || formInfo['addr_2'] == '') {
      //市区町村
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_municipal +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_3'] == null || formInfo['addr_3'] == '') {
      //住所
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_address +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['tel'] == null || formInfo['tel'] == '') {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_tel +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['tel'])) {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .delivery_table_tel +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //FAX番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .delivery_table_fax +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact'] == null || formInfo['contact'] == '') {
      //担当者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_chargePerson +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['contact_tel'] == null ||
        formInfo['contact_tel'] == '') {
      //担当者-電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_contact_telephone_number +
          WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['contact_tel'])) {
      //担当者-電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_contact_telephone_number +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_fax'] != null &&
        formInfo['contact_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['contact_fax'])) {
      //担当者名-FAX番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .supplier_basic_contact_fax_number +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['contact_email'] == null ||
        formInfo['contact_email'] == '') {
      //担当者-EMAIL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_contact_email +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(formInfo['contact_email'])) {
      //担当者-EMAIL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.supplier_basic_contact_email +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    } else if (formInfo['start_date'] == null || formInfo['start_date'] == '') {
      //適用開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.operator_text_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['end_date'] == null || formInfo['end_date'] == '') {
      //適用終了日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.operator_text_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    //適用開始日
    String date1 = formInfo['start_date'].toString().replaceAll("/", "-");
    //適用終了日
    String date2 = formInfo['end_date'].toString().replaceAll("/", "-");
    //日期转换
    DateTime startDate = DateTime.parse(date1);
    DateTime endDate = DateTime.parse(date2);
    // 比较两个日期
    if (startDate.isAfter(endDate)) {
      //適用終了日不能大于適用開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.operator_text_5);
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
  Map<String, dynamic> changeOperatorsMap(Map<String, dynamic> formInfo) {
    Map<String, dynamic> result = formInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    return result;
  }

  //初期化下拉框
  Future<void> initCompany(DeliveryOperatorsMasterModel state) async {
    //父菜单检索 会社情报マスタ
    List<dynamic> companyInfoList = await SupabaseUtils.getClient()
        .from('mtb_company')
        .select('*')
        .eq('status', '1');
    state.companyList = [];
    if (companyInfoList.length > 0) {
      for (int i = 0; i < companyInfoList.length; i++) {
        state.companyList.add({
          'id': companyInfoList[i]['id'].toString(),
          'name': companyInfoList[i]['name']
        });
      }
    }
  }

  //初期化表单
  void initForm(DeliveryOperatorsMasterModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'name': '',
      'postal_cd': '',
      'addr_1': '',
      'addr_2': '',
      'addr_3': '',
      'tel': '',
      'fax': '',
      'contact': '',
      'contact_tel': '',
      'contact_fax': '',
      'contact_email': '',
      'start_date': '',
      'end_date': '',
      'company_id': null,
      'company_name': '',
      'company_note1': '',
      'company_note2': '',
      'del_kbn': '2',
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(DeliveryOperatorsMasterModel state) {
    state.searchInfo = {
      'id': '',
      'name': '',
      'contact': '',
      'company_id': '',
      'company_name': ''
    };
    state.conditionList = [];
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
  PostgrestFilterBuilder setSelectConditions(DeliveryOperatorsMasterModel state,
      PostgrestFilterBuilder query, bool flag) {
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
