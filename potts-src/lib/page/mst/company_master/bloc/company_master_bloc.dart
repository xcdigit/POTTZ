import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/model/company.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'company_master_model.dart';

/**
 * 内容：会社マスタ管理-BLOC
 * 作者：穆政道
 * 时间：2023/09/26
 */
// 事件
abstract class CompanyMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends CompanyMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends CompanyMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends CompanyMasterEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定会社情报值事件
class SetCompanyValueEvent extends CompanyMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetCompanyValueEvent(this.key, this.value);
}

// 设定下拉框情报值事件
class SetDropdownValueEvent extends CompanyMasterEvent {
  // Key
  String type;
  // id
  String id;
  // name
  String name;
  // 设定值事件
  SetDropdownValueEvent(this.type, this.id, this.name);
}

//设定按钮显示状态
class SetStateFlgValueEvent extends CompanyMasterEvent {
  // flg
  String flg;
  // 设定值事件
  SetStateFlgValueEvent(this.flg);
}

//清除表单
class ClearFormEvent extends CompanyMasterEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends CompanyMasterEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//显示form数据
class ShowSelectValueEvent extends CompanyMasterEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//检索处理
class SeletCompanyEvent extends CompanyMasterEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletCompanyEvent(this.context);
}

//清除检索条件
class ClearSeletCompanyEvent extends CompanyMasterEvent {
  //检索处理
  ClearSeletCompanyEvent();
}

//
class SearchButtonHoveredChangeEvent extends CompanyMasterEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends CompanyMasterEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends CompanyMasterEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends CompanyMasterEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends CompanyMasterEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class CompanyMasterBloc extends WmsTableBloc<CompanyMasterModel> {
  // 刷新补丁
  @override
  CompanyMasterModel clone(CompanyMasterModel src) {
    return CompanyMasterModel.clone(src);
  }

  CompanyMasterBloc(CompanyMasterModel state) : super(state) {
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
      // 查询出荷指示
      var query = SupabaseUtils.getClient().from('mtb_company').select('*');

      query = setSelectConditions(state, query);

      List<dynamic> data;
      if (state.onlyMyselfData) {
        data = await query
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id)
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
      } else {
        data = await query
            .order(state.sortCol, ascending: state.ascendingFlg)
            .range(state.pageNum * state.pageSize,
                (state.pageNum + 1) * state.pageSize - 1);
      }
      // 列表数据清空
      state.records.clear();
      // 循环商品数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        data[i]['status_name'] =
            getNamefromList(data[i]['status'], state.statusList);
        data[i]['forced_shipment_flag_name'] =
            getNamefromList(data[i]['forced_shipment_flag'], state.forcedList);
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 查询会社总数
      var queryCount;
      if (state.onlyMyselfData) {
        queryCount = SupabaseUtils.getClient()
            .from('mtb_company')
            .select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            )
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.context)
                    .state
                    .loginUser
                    ?.company_id);
      } else {
        queryCount = SupabaseUtils.getClient().from('mtb_company').select(
              '*',
              const FetchOptions(
                count: CountOption.exact,
              ),
            );
      }
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
      if ('id' == deleteColumn['key']) {
        state.searchInfo['id'] = '';
      } else if ('name' == deleteColumn['key']) {
        state.searchInfo['name'] = '';
      } else if ('name_short' == deleteColumn['key']) {
        state.searchInfo['name_short'] = '';
      } else if ('corporate_cd' == deleteColumn['key']) {
        state.searchInfo['corporate_cd'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    // 设定会社情报值事件
    on<SetCompanyValueEvent>((event, emit) async {
      // 会社情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // 会社情报-临时
        formTemp[event.key] = event.value;
      } else {
        // 会社情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 会社情报-定制
      state.formInfo = formTemp;

      // 更新
      emit(clone(state));
    });

    // 设定下拉框情报值事件
    on<SetDropdownValueEvent>((event, emit) async {
      if (event.type == '1') {
        state.formInfo['status'] = event.id;
        state.formInfo['status_name'] = event.name;
      } else if (event.type == '2') {
        state.formInfo['forced_shipment_flag'] = event.id;
        state.formInfo['forced_shipment_flag_name'] = event.name;
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
      bool checkResult = checkMustInputColumn(state.formInfo, event.context);
      // 判断验证结果
      if (!checkResult) {
        return;
      }
      //model用map做成
      Map<String, dynamic> formInfo = changeCompanyMap(state.formInfo);
      // 商品master数据
      List<Map<String, dynamic>> formData;
      Company company = Company.fromJson(formInfo);
      //判断登录场合
      if (company.id == null) {
        //填入必须字段
        company.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        company.create_time = DateTime.now().toString();
        company.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        company.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 赵士淞 - 始
          // 创建或更新会社表单处理
          bool checkFlag = await createOrUpdateCompanyFormHandle(company);
          // 判断处理结果
          if (checkFlag == false) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!
                    .company_abbreviation_exists);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          // 赵士淞 - 终
          // 新增商品
          formData = await SupabaseUtils.getClient()
              .from('mtb_company')
              .insert([company.toJson()]).select('*');
          // 判断商品数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_1 +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_1 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_1 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        company.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        company.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 赵士淞 - 始
          // 创建或更新会社表单处理
          bool checkFlag = await createOrUpdateCompanyFormHandle(company);
          // 判断处理结果
          if (checkFlag == false) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!
                    .company_abbreviation_exists);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
          // 赵士淞 - 终
          // 修改商品情报
          formData = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update(company.toJson())
              .eq('id', company.id)
              .select('*');
          // 判断出荷指示数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_1 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_1 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_1 +
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
      state.formInfo = event.value;
      state.stateFlg = event.stateflg;
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 检索处理
    on<SeletCompanyEvent>((event, emit) async {
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
      if (state.searchInfo['name_short'] != '' &&
          state.searchInfo['name_short'] != null) {
        state.conditionList.add(
            {'key': 'name_short', 'value': state.searchInfo['name_short']});
      }
      if (state.searchInfo['corporate_cd'] != '' &&
          state.searchInfo['corporate_cd'] != null) {
        state.conditionList.add(
            {'key': 'corporate_cd', 'value': state.searchInfo['corporate_cd']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSeletCompanyEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 判断登录用户角色
      if (StoreProvider.of<WMSState>(state.context).state.loginUser?.role_id !=
          1) {
        // 仅自己数据
        state.onlyMyselfData = true;
      } else {
        // 仅自己数据
        state.onlyMyselfData = false;
      }
      //设定状态列表
      state.statusList = [
        {'id': '1', 'name': '存続'},
        {'id': '2', 'name': '申込'},
        {'id': '3', 'name': '退会'}
      ];
      //设定強制出荷列表
      state.forcedList = [
        {'id': '0', 'name': '通常出荷'},
        {'id': '1', 'name': '強制出荷'}
      ];
      // 加载标记
      state.loadingFlag = false;
      // 自定义事件 - 始
      //初期化表单
      initForm(state);

      //初期化检索条件
      initSearch(state);

      // 自定义事件 - 终

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
  bool selectCompanyEventBeforeCheck(
      BuildContext context, CompanyMasterModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 半角数字 9位
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.company_information_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    //检索条件法人番号
    if (state.searchInfo['corporate_cd'] != '' &&
        state.searchInfo['corporate_cd'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number(state.searchInfo['corporate_cd'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.company_information_4 +
                WMSLocalizations.i18n(context)!.input_int_check);
        return false;
      }
    }
    add(SeletCompanyEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //会社名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['name_short'] == null || formInfo['name_short'] == '') {
      //略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_AZ4(formInfo['name_short'])) {
      //略称A~Z
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_3 +
              WMSLocalizations.i18n(context)!.company_check_1);
      return false;
    } else if (formInfo['corporate_cd'] == null ||
        formInfo['corporate_cd'] == '') {
      //法人番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_13(formInfo['corporate_cd'])) {
      //13位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_4 +
              WMSLocalizations.i18n(context)!.company_check_2);
      return false;
    } else if (formInfo['qrr_cd'] == null || formInfo['qrr_cd'] == '') {
      //適格請求登録番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric(formInfo['qrr_cd'])) {
      //適格請求登録番号 半角英数
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_5 +
              WMSLocalizations.i18n(context)!.check_half_width_alphanumeric);
      return false;
    } else if (formInfo['postal_cd'] == null || formInfo['postal_cd'] == '') {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_6 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号 3位半角数字-4位半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_6 +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    } else if (formInfo['addr_1'] == null || formInfo['addr_1'] == '') {
      //都道府県
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_7 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_2'] == null || formInfo['addr_2'] == '') {
      //市区町村
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_8 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['addr_3'] == null || formInfo['addr_3'] == '') {
      //住所
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_9 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['tel'] == null || formInfo['tel'] == '') {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_10 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(formInfo['tel'])) {
      //電話番号 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_10 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //Fax 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_11 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['email'] == null || formInfo['email'] == '') {
      //email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_13 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(formInfo['email'])) {
      //email check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_13 +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    } else if (formInfo['status'] == null || formInfo['status'] == '') {
      //状態
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_14 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['forced_shipment_flag'] == null ||
        formInfo['forced_shipment_flag'] == '') {
      //強制出荷フラグ
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_15 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }

    return true;
  }

  //model用map做成
  Map<String, dynamic> changeCompanyMap(Map<String, dynamic> formInfo) {
    Map<String, dynamic> result = formInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    return result;
  }

  //初期化表单
  void initForm(CompanyMasterModel state) {
    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'name': '',
      'name_short': '',
      'corporate_cd': '',
      'qrr_cd': '',
      'postal_cd': '',
      'addr_1': '',
      'addr_2': '',
      'addr_3': '',
      'tel': '',
      'fax': '',
      'url': '',
      'email': '',
      'status': '',
      'status_name': '',
      'forced_shipment_flag': '',
      'forced_shipment_flag_name': ''
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(CompanyMasterModel state) {
    state.searchInfo = {
      'id': '',
      'name': '',
      'name_short': '',
      'corporate_cd': ''
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

  PostgrestFilterBuilder setSelectConditions(
      CompanyMasterModel state, PostgrestFilterBuilder query) {
    var result = query;
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
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
    if (state.searchInfo['corporate_cd'] != '' &&
        state.searchInfo['corporate_cd'] != null) {
      query =
          query.eq('corporate_cd', state.searchInfo['corporate_cd'].toString());
    }
    return result;
  }

  // 赵士淞 - 始
  // 创建或更新会社表单处理
  Future<bool> createOrUpdateCompanyFormHandle(Company company) async {
    // 查询会社
    List<dynamic> companyData = await SupabaseUtils.getClient()
        .from('mtb_company')
        .select('*')
        .eq('name_short', company.name_short);
    // 判断出荷指示明细长度
    if (companyData.length == 0 || companyData[0]['id'] == company.id) {
      // 返回
      return true;
    } else {
      // 返回
      return false;
    }
  }
  // 赵士淞 - 终
  //自定义方法 - 终
}
