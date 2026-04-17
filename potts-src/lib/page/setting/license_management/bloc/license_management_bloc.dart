import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/config/config.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/use_type.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'license_management_model.dart';

/**
 * 内容：ライセンス管理-BLOC
 * 作者：王光顺
 * 时间：2023/12/05
 */

// 事件
abstract class LicenseManagementEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends LicenseManagementEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定表单情报值事件
class SetMessageValueEvent extends LicenseManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetMessageValueEvent(this.key, this.value);
}

//清除表单
class ClearFormEvent extends LicenseManagementEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends LicenseManagementEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

// 设定检索条件值事件
class SetSearchValueEvent extends LicenseManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

class DeleteSearchValueEvent extends LicenseManagementEvent {
  int index;
  //设定值事件
  DeleteSearchValueEvent(this.index);
}

//form表单回显
class ShowSelectValueEvent extends LicenseManagementEvent {
  // Value
  dynamic value;
  //状态flg
  String stateflg;
  ShowSelectValueEvent(this.value, this.stateflg);
}

//清除检索条件
class ClearSelectMessageEvent extends LicenseManagementEvent {
  ClearSelectMessageEvent();
}

//检索处理
class SelectMessageEvent extends LicenseManagementEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SelectMessageEvent(this.context);
}

//删除数据
class DeleteMessageDataEvent extends LicenseManagementEvent {
  // 结构树
  BuildContext context;
  int Id;
  DeleteMessageDataEvent(this.context, this.Id);
}

// 设置当前角色ID
class SetNowRoleDEvent extends LicenseManagementEvent {
  int nowRoleId;
  SetNowRoleDEvent(this.nowRoleId);
}
// 自定义事件 - 终

class LicenseManagementBloc extends WmsTableBloc<LicenseManagementModel> {
  // 刷新补丁
  @override
  LicenseManagementModel clone(LicenseManagementModel src) {
    return LicenseManagementModel.clone(src);
  }

  LicenseManagementBloc(LicenseManagementModel state) : super(state) {
    //设置会社id
    on<SetNowRoleDEvent>((event, emit) async {
      state.nowRoleId = event.nowRoleId == 0 ? null : event.nowRoleId;
      emit(clone(state));
    });
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 加载标记
      state.loadingFlag = false;

      //初期化表单
      initForm(state);

      List companyList = await SupabaseUtils.getClient()
          .from('mtb_role')
          .select('*')
          .neq('id', Config.ROLE_ID_1);
      state.salesRoleInfoList = companyList;

      // 赵士淞 - 始
      // 完整角色列表
      List<dynamic> completeRoleList =
          await SupabaseUtils.getClient().from('mtb_role').select('*');
      // 完整角色列表
      state.completeRoleList = completeRoleList;
      // 赵士淞 - 终

      // SP端跳转页面 保留 避免SP端开发备用
      if (state.flag_num == '2') {
        add(ShowSelectValueEvent(state.flag_data, "2"));
      } else if (state.flag_num == '0' || state.flag_num == '1') {
        add(ShowSelectValueEvent(state.flag_data, "1"));
      }
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

      // 查询指示
      var query = SupabaseUtils.getClient().from('ytb_use_type').select('*');

      query = setSelectConditions(state, query, false);

      List<dynamic> data = await query.order('id', ascending: false).range(
          state.pageNum * state.pageSize,
          (state.pageNum + 1) * state.pageSize - 1);

      // 列表数据清空
      state.records.clear();
      // 循环数据 查询角色信息
      for (int i = 0; i < data.length; i++) {
        // 赵士淞 - 始
        for (int j = 0; j < state.completeRoleList.length; j++) {
          if (data[i]['role_id'] == state.completeRoleList[j]['id']) {
            data[i]['role'] = state.completeRoleList[j]['name'];
            break;
          }
        }
        // 赵士淞 - 终
      }

      // 查询总数
      var queryCount = SupabaseUtils.getClient().from('ytb_use_type').select(
            '*',
            const FetchOptions(
              count: CountOption.exact,
            ),
          );

      //设置检索条件
      queryCount = setSelectConditions(state, queryCount, false);
      final countResult = await queryCount;
      // 总页数
      state.total = countResult.count;
      // 单独对权限的检索数据筛选，避免写多表查询sql
      for (int i = 0; i < data.length; i++) {
        if (data[i]['role']
                .toString()
                .contains(state.searchInfo['role'].toString()) ||
            (state.searchInfo['role'].toString() == '') ||
            (state.searchInfo['role'] == null)) {
          state.records.add(WmsRecordModel(i, data[i]));
        } else {
          state.total -= 1; // 如果数据不符合就不加入表中，总数减一
        }
      }

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定表单情报值事件
    on<SetMessageValueEvent>(
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
      state.searchKbn = event.value;
      // 更新
      emit(clone(state));
    });

    // 检索处理
    on<SelectMessageEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['role'] != '' && state.searchInfo['role'] != null) {
        state.conditionList
            .add({'key': 'role', 'value': state.searchInfo['role']});
      }
      if (state.searchInfo['type'] != '' && state.searchInfo['type'] != null) {
        state.conditionList
            .add({'key': 'type', 'value': state.searchInfo['type']});
      }
      if (state.searchInfo['start_date'] != '' &&
          state.searchInfo['start_date'] != null) {
        state.conditionList.add(
            {'key': 'start_date', 'value': state.searchInfo['start_date']});
      }
      if (state.searchInfo['end_date'] != '' &&
          state.searchInfo['end_date'] != null) {
        state.conditionList
            .add({'key': 'end_date', 'value': state.searchInfo['end_date']});
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //清除检索条件
    on<ClearSelectMessageEvent>(
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
      if ('role' == deleteColumn['key']) {
        state.searchInfo['role'] = '';
      } else if ('type' == deleteColumn['key']) {
        state.searchInfo['type'] = '';
      } else if ('start_date' == deleteColumn['key']) {
        state.searchInfo['start_date'] = '';
      } else if ('end_date' == deleteColumn['key']) {
        state.searchInfo['end_date'] = '';
      }
      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
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
        Map<String, dynamic> formInfo = changeMessageMap(state.formInfo);
        // 商品master数据
        List<Map<String, dynamic>> formData;

        {
          BotToast.showLoading();
          //登录/修改
          UseType message = UseType.fromJson(formInfo);
          //设置角色
          message.role_id = state.nowRoleId == null
              ? state.formInfo['role_id']
              : state.nowRoleId;
          if (message.id == null) {
            //填入必须字段
            message.create_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.create_time = DateTime.now().toString();
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();

            try {
              // 新增
              formData = await SupabaseUtils.getClient()
                  .from('ytb_use_type')
                  .insert([message.toJson()]).select('*');
              // 判断数据
              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_98_23 +
                        WMSLocalizations.i18n(event.context)!.create_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_98_23 +
                        WMSLocalizations.i18n(event.context)!.create_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_98_23 +
                      WMSLocalizations.i18n(event.context)!.create_error);

              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
          } else {
            //修正的场合
            // check id
            BotToast.showLoading();
            if (state.formInfo['id'] != null && state.formInfo['id'] != '') {
              state.formInfo['id'] = '';
              // 更新
              emit(clone(state));
            }
            message.role_id = state.nowRoleId == null
                ? state.formInfo['role_id']
                : state.nowRoleId;
            //更新者更新时间
            message.update_id =
                StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
            message.update_time = DateTime.now().toString();
            try {
              // 修改
              formData = await SupabaseUtils.getClient()
                  .from('ytb_use_type')
                  .update(message.toJson())
                  .eq('id', message.id)
                  .select('*');

              if (formData.length != 0) {
                // 成功提示
                WMSCommonBlocUtils.successTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_98_23 +
                        WMSLocalizations.i18n(event.context)!.update_success);
              } else {
                // 失败提示
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(event.context)!.menu_content_98_23 +
                        WMSLocalizations.i18n(event.context)!.update_error);
                // 关闭加载
                BotToast.closeAllLoading();
                return;
              }
            } catch (e) {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.menu_content_98_23 +
                      WMSLocalizations.i18n(event.context)!.update_error);
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
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
    // 初始化判断
    add(InitEvent());
  }

  //自定义方法 - 始
  //检索前check处理
  bool selectMessageEventBeforeCheck(
      BuildContext context, LicenseManagementModel state) {
    //检索条件check
    if (state.searchInfo['id'] != '' && state.searchInfo['id'] != null) {
      // 验证是否全数字
      if (CheckUtils.check_Half_Number_In_10(state.searchInfo['id'])) {
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(context)!.shipping_master_form_1 +
                WMSLocalizations.i18n(context)!.input_int_in_10_check);
        return false;
      }
    }
    add(SelectMessageEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['role'] == null || formInfo['role'] == '') {
      // ロール
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_profile_roll +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['type'] == null || formInfo['type'] == '') {
      // ライセンスの種類
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_license_type +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['support_cotent'] == null ||
        formInfo['support_cotent'] == '') {
      // サポート内容
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.license_management_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['amount'] == null ||
        formInfo['amount'].toString() == '') {
      // 金額
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_note_43 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number(formInfo['amount'])) {
      // 金額
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.delivery_note_43 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers);
      return false;
    } else if (formInfo['start_date'] == null || formInfo['start_date'] == '') {
      // 開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_content_4_10_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['end_date'] == null || formInfo['end_date'] == '') {
      // 終了日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_content_4_10_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } //三个有效期日期中必须输入1个
    else if ((formInfo['expiration_year'] == null ||
            formInfo['expiration_year'] == '') &&
        (formInfo['expiration_month'] == null ||
            formInfo['expiration_month'] == '') &&
        (formInfo['expiration_day'] == null ||
            formInfo['expiration_day'] == '')) {
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.license_management_2 +
              ',' +
              WMSLocalizations.i18n(context)!.license_management_3 +
              ',' +
              WMSLocalizations.i18n(context)!.license_management_4 +
              ',' +
              WMSLocalizations.i18n(context)!.license_management_5);
      return false;
    } else if (formInfo['expiration_year'] != null &&
        formInfo['expiration_year'] != '' &&
        CheckUtils.check_Half_Number_In_10(formInfo['expiration_year'])) {
      // 有効期間(年)
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.license_management_2 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
      return false;
    } else if (formInfo['expiration_month'] != null &&
        formInfo['expiration_month'] != '' &&
        CheckUtils.check_Half_Number_In_10(formInfo['expiration_month'])) {
      // 有効期間(月)
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.license_management_3 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
      return false;
    } else if (formInfo['expiration_day'] != null &&
        formInfo['expiration_day'] != '' &&
        CheckUtils.check_Half_Number_In_10(formInfo['expiration_day'])) {
      // 有効期間(日)
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.license_management_4 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers_in_10);
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

    formInfo['amount'] = double.parse(formInfo['amount'].toString());
    if (formInfo['expiration_year'] != null &&
        formInfo['expiration_year'].toString() != '') {
      formInfo['expiration_year'] =
          int.parse(formInfo['expiration_year'].toString());
    } else {
      formInfo['expiration_year'] = 0;
    }
    if (formInfo['expiration_month'] != null &&
        formInfo['expiration_month'].toString() != '') {
      formInfo['expiration_month'] =
          int.parse(formInfo['expiration_month'].toString());
    } else {
      formInfo['expiration_month'] = 0;
    }
    if (formInfo['expiration_day'] != null &&
        formInfo['expiration_day'].toString() != '') {
      formInfo['expiration_day'] =
          int.parse(formInfo['expiration_day'].toString());
    } else {
      formInfo['expiration_day'] = 0;
    }

    return true;
  }

  //model用map做成
  Map<String, dynamic> changeMessageMap(Map<String, dynamic> formInfo) {
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
  void initForm(LicenseManagementModel state) {
    // 情报初期化
    state.formInfo = {
      'id': '',
      'role': '',
      'type': '',
      'support_cotent': '',
      'amount': '',
      'expiration_year': '',
      'expiration_month': '',
      'expiration_day': '',
      'start_date': '',
      'end_date': '',
    };
    //状态初期化
    state.stateFlg = '1';
  }

  //初期化检索条件
  void initSearch(LicenseManagementModel state) {
    state.searchInfo = {
      'role': '',
      'type': '',
      'start_date': '',
      'end_date': '',
    };
    state.searchKbn = '';
    state.conditionList = [];
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      LicenseManagementModel state, PostgrestFilterBuilder query, bool flag) {
    if (state.searchInfo['type'] != '' && state.searchInfo['type'] != null) {
      String nameShotTemp = '%' + state.searchInfo['type'] + '%';
      query = query.like('type', nameShotTemp.toString());
    }
    if (state.searchInfo['start_date'] != '' &&
        state.searchInfo['start_date'] != null) {
      String nameShotTemp = '%' + state.searchInfo['start_date'] + '%';
      query = query.gte('start_date', nameShotTemp.toString());
    }
    if (state.searchInfo['end_date'] != '' &&
        state.searchInfo['end_date'] != null) {
      String nameShotTemp = '%' + state.searchInfo['end_date'] + '%';
      query = query.lte('end_date', nameShotTemp.toString());
    }
    var result = query;
    return result;
  }
}
