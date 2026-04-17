import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/model/customer_address.dart';
import 'package:wms/page/mst/delivery/bloc/delivery_model.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';

/**
 * 内容：纳入先マスタ管理-BLOC
 * 作者：cuihr
 * 时间：2023/10/9
 */
// 事件
abstract class DeliveryEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends DeliveryEvent {
  // 初始化事件
  InitEvent();
}
// 自定义事件 - 始

// 设定纳入先情报值事件
class SetDeliveryValueEvent extends DeliveryEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetDeliveryValueEvent(this.key, this.value);
}

// 设定检索条件值事件
class SetSearchValueEvent extends DeliveryEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

//检索处理
class SelectDeliveryEvent extends DeliveryEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectDeliveryEvent(this.context);
}

//清除检索条件
class ClearSelectDeliveryEvent extends DeliveryEvent {
  ClearSelectDeliveryEvent();
}

class DeleteSearchValueEvent extends DeliveryEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends DeliveryEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除表单
class ClearFormEvent extends DeliveryEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends DeliveryEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//删除数据
class DeleteDeliveryDataEvent extends DeliveryEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteDeliveryDataEvent(this.context, this.Id);
}

// 表格Tab切换事件
class TableTabSwitchEvent extends DeliveryEvent {
  // 表格Tab下标
  int tableTabIndex;
  // 表格Tab切换事件
  TableTabSwitchEvent(this.tableTabIndex);
}

//
class SearchButtonHoveredChangeEvent extends DeliveryEvent {
  //
  bool flag;
  //
  SearchButtonHoveredChangeEvent(this.flag);
}

//
class SearchOutlinedButtonPressedEvent extends DeliveryEvent {
  //
  SearchOutlinedButtonPressedEvent();
}

//
class SearchInkWellTapEvent extends DeliveryEvent {
  //
  SearchInkWellTapEvent();
}

//
class SetSearchDataFlagAndSearchFlagEvent extends DeliveryEvent {
  //
  bool searchDataFlag;
  //
  bool searchFlag;
  //
  SetSearchDataFlagAndSearchFlagEvent(this.searchDataFlag, this.searchFlag);
}

// 设置sort字段
class SetSortEvent extends DeliveryEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}
// 自定义事件 - 终

class DeliveryBloc extends WmsTableBloc<DeliveryModel> {
  // 刷新补丁
  @override
  DeliveryModel clone(DeliveryModel src) {
    return DeliveryModel.clone(src);
  }

  Future<void> initCompany(DeliveryModel state) async {
    List<Map<String, dynamic>> formData;
    formData = await SupabaseUtils.getClient()
        .from('mtb_company')
        .select('*')
        .eq('status', Config.NUMBER_ONE)
        .select('*');
    state.companyList = formData;
  }

  DeliveryBloc(DeliveryModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      //初期化表单
      initForm(state);
      // 初期化会社情报集合
      // 查询位置
      List<dynamic> companyList = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('status', Config.NUMBER_ONE)
          .select('*');
      // 位置列表
      state.companyList = companyList;
      //初期化检索条件
      initSearch(state);
      // 自定义事件 - 终
      // 加载标记
      state.loadingFlag = false;
      emit(clone(state));
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
      // 查询纳入先指示
      var query =
          SupabaseUtils.getClient().from('mtb_customer_address').select('*');
      query =
          setSelectConditions(state, query, state.roleId != 1 ? true : false);
      List<dynamic> data = await query
          .eq('del_kbn', Config.NUMBER_TWO.toString())
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环商品数据
      for (int i = 0; i < data.length; i++) {
        // 列表数据增加
        if (data[i]['company_id'] != null && data[i]['company_id'] != '') {
          data[i]['company_name'] =
              getNamefromList(data[i]['company_id'], state.companyList);
        }
        state.records.add(WmsRecordModel(i, data[i]));
      }
      //一览总个数
      var query2 =
          SupabaseUtils.getClient().from('mtb_customer_address').select('*');
      query2 =
          setSelectConditions(state, query2, state.roleId != 1 ? true : false);
      List<dynamic> data2 = await query2
          .eq('del_kbn', Config.NUMBER_TWO.toString())
          .order(state.sortCol, ascending: state.ascendingFlg);
      //总个数
      state.total = data2.length;

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
    on<SelectDeliveryEvent>((event, emit) async {
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
      //納入先_略称
      if (state.searchInfo['name_short'] != '' &&
          state.searchInfo['name_short'] != null) {
        state.conditionList.add(
            {'key': 'name_short', 'value': state.searchInfo['name_short']});
      }
      //納入先_担当者
      if (state.searchInfo['person'] != '' &&
          state.searchInfo['person'] != null) {
        state.conditionList
            .add({'key': 'person', 'value': state.searchInfo['person']});
      }
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        state.conditionList.add(
            {'key': 'company_id', 'value': state.searchInfo['company_id']});
      }
      if (state.searchInfo['company_name'] != '' &&
          state.searchInfo['company_name'] != null) {
        state.conditionList.add(
            {'key': 'company_name', 'value': state.searchInfo['company_name']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    //清除检索条件
    on<ClearSelectDeliveryEvent>(
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
      } else if ('name_short' == deleteColumn['key']) {
        state.searchInfo['name_short'] = '';
      } else if ('person' == deleteColumn['key']) {
        state.searchInfo['person'] = '';
      } else if ('company_name' == deleteColumn['key']) {
        state.searchInfo['company_id'] = '';
        state.searchInfo['company_name'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });
    //采用逻辑删除收货商数据
    on<DeleteDeliveryDataEvent>(
      (event, emit) async {
        // 打开加载状态
        BotToast.showLoading();
        try {
          // 修改
          await SupabaseUtils.getClient()
              .from('mtb_customer_address')
              .update({'del_kbn': Config.DELETE_YES}).eq('id', event.Id);
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
                  WMSLocalizations.i18n(event.context)!.delete_success);
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
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
    // 设定收货商情报值事件
    on<SetDeliveryValueEvent>((event, emit) async {
      // 收货商情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // 收货商情报-临时
        formTemp[event.key] = event.value;
      } else {
        // 收货商情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 收货商情报-定制
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
        if (state.roleId != Config.NUMBER_ONE) {
          state.formInfo['company_id'] = state.companyId;
        } else {
          //admin的场合，company_id必须入力
          if (state.formInfo['company_id'] == null ||
              state.formInfo['company_id'] == '') {
            //納入先名称
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(event.context)!.delivery_search_company +
                    WMSLocalizations.i18n(event.context)!.can_not_null_text);
            return;
          }
        }
        //model用map做成
        Map<String, dynamic> formInfo = changeDeliveryMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;
        CustomerAddress delivery = CustomerAddress.fromJson(formInfo);
        if (delivery.id == null) {
          if (state.roleId != 1) {
            //填入必须字段
            delivery.company_id = StoreProvider.of<WMSState>(event.context)
                .state
                .loginUser
                ?.company_id;
          }
          delivery.del_kbn = '2';
          delivery.create_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          delivery.create_time = DateTime.now().toString();
          delivery.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          delivery.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 新增仕入先
            formData = await SupabaseUtils.getClient()
                .from('mtb_customer_address')
                .insert([delivery.toJson()]).select('*');
            // 判断商品数据
            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
                      WMSLocalizations.i18n(event.context)!.create_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
                      WMSLocalizations.i18n(event.context)!.create_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } else {
          //修正的场合
          //更新者更新时间
          delivery.update_id =
              StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
          delivery.update_time = DateTime.now().toString();
          try {
            BotToast.showLoading();
            // 修改商品情报
            formData = await SupabaseUtils.getClient()
                .from('mtb_customer_address')
                .update(delivery.toJson())
                .eq('id', delivery.id)
                .select('*');

            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
                      WMSLocalizations.i18n(event.context)!.update_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_8_23 +
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
  bool selectDeliveryEventBeforeCheck(
      BuildContext context, DeliveryModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.delivery_table_id +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SelectDeliveryEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['name'] == null || formInfo['name'] == '') {
      //納入先名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_name +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['name_kana'] == null || formInfo['name_kana'] == '') {
      //カナ名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_canaName +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Kana(formInfo['name_kana'])) {
      //カナ入力check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_canaName +
              WMSLocalizations.i18n(context)!.check_kana);
      return false;
    } else if (formInfo['name_short'] == null || formInfo['name_short'] == '') {
      //略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_abbreviation +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['postal_cd'] == null || formInfo['postal_cd'] == '') {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_zipCode +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(formInfo['postal_cd'])) {
      //郵便番号 3位半角数字-4位半角数字
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
      //電話番号 半角数字，ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .delivery_table_tel +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['fax'] != null &&
        formInfo['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(formInfo['fax'])) {
      //Fax 半角数字和ハイフン
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .delivery_table_fax +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (formInfo['person'] == null || formInfo['person'] == '') {
      //担当者名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_table_chargePerson +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    return true;
  }

  //model用map做成
  Map<String, dynamic> changeDeliveryMap(Map<String, dynamic> formInfo) {
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
  void initForm(DeliveryModel state) {
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
      'person': '',
      'company_id': '',
      'company_name': '',
      'company_note1': '',
      'company_note2': '',
      'del_kbn': '2',
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(DeliveryModel state) {
    state.searchInfo = {
      'id': '',
      'name': '',
      'name_short': '',
      'person': '',
      'company_id': '',
      'company_name': ''
    };
    state.conditionList = [];
  }

  PostgrestFilterBuilder setSelectConditions(
      DeliveryModel state, PostgrestFilterBuilder query, bool flag) {
    //会社管理员的场合
    if (flag) {
      query = query.eq('company_id', state.companyId);
    } else {
      //超级管理员的场合
      if (state.searchInfo['company_id'] != '' &&
          state.searchInfo['company_id'] != null) {
        query = query.eq('company_id', state.searchInfo['company_id']);
      }
    }
    var result = query;
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      query = query.eq('id', int.parse(state.searchInfo['id'].toString()));
    }
    if (state.searchInfo['name'] != '' && state.searchInfo['name'] != null) {
      String nameTemp = '%' + state.searchInfo['name'] + '%';
      query = query.like('name', nameTemp.toString());
    }
    //納入先_略称
    if (state.searchInfo['name_short'] != '' &&
        state.searchInfo['name_short'] != null) {
      String nameShotTemp = '%' + state.searchInfo['name_short'] + '%';
      query = query.like('name_short', nameShotTemp.toString());
    }
    //納入先_担当者
    if (state.searchInfo['person'] != '' &&
        state.searchInfo['person'] != null) {
      String nameShotTemp = '%' + state.searchInfo['person'] + '%';
      query = query.like('person', nameShotTemp.toString());
    }
    return result;
  }

  //取得list中name
  String getNamefromList(int id, List<dynamic> nameList) {
    String name = '';
    if (nameList.isNotEmpty) {
      for (dynamic item in nameList) {
        if (item['id'] == id) {
          name = item['name'];
          break;
        }
      }
    }
    return name;
  }
}
