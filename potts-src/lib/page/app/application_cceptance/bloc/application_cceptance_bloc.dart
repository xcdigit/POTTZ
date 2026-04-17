import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/utils/encryption_utils.dart';
import 'package:wms/common/utils/mail_utils.dart';
import 'package:wms/env/dev.dart';
import 'package:wms/env/env_config.dart';
import 'package:wms/model/company_manage.dart';
import 'package:wms/model/company_plan_manage.dart';
import 'package:wms/model/form_detail.dart';
import 'package:wms/model/number.dart';
import 'package:wms/model/user.dart' as Wms;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:wms/widget/table/bloc/wms_table_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../model/company.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import 'package:wms/model/form.dart' as Form;

/**
 * 内容：申込受付-BLOC
 * 作者：cuihr
 * 时间：2023/12/18
 */
// 事件
abstract class ApplicationCceptanceEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends ApplicationCceptanceEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始

// 设定检索条件值事件
class SetSearchValueEvent extends ApplicationCceptanceEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // Value
  dynamic name;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value, this.name);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends ApplicationCceptanceEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

//检索处理
class SeletAppEvent extends ApplicationCceptanceEvent {
  //检索处理
  SeletAppEvent();
}

//清除检索条件
class ClearSeletAppEvent extends ApplicationCceptanceEvent {
  ClearSeletAppEvent();
}

class SelectFormEvent extends ApplicationCceptanceEvent {
  SelectFormEvent();
}

// 设定下拉框值事件
class SetStatusValueEvent extends ApplicationCceptanceEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // Value
  dynamic name;
  // 设定值事件
  SetStatusValueEvent(this.key, this.value, this.name);
}

//更新申请状态
class UpdateStatusEvent extends ApplicationCceptanceEvent {
  BuildContext context;
  UpdateStatusEvent(this.context);
}

// 设置sort字段
class SetSortEvent extends ApplicationCceptanceEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

//自定义事件 -结束
class ApplicationCceptanceBloc extends WmsTableBloc<ApplicationCceptanceModel> {
  // 刷新补丁
  @override
  ApplicationCceptanceModel clone(ApplicationCceptanceModel src) {
    return ApplicationCceptanceModel.clone(src);
  }

  ApplicationCceptanceBloc(ApplicationCceptanceModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定オプション列表
      state.optionList = [
        {'id': '1', 'name': '標準'},
        {'id': '2', 'name': '連携オプション'},
        {'id': '3', 'name': '文書管理オプション'},
        {'id': '4', 'name': '取引先公開オプション'}
      ];
      //设定お支払いサイクル列表
      state.payCycleList = [
        {'id': '1', 'name': '月払い'},
        {'id': '2', 'name': '年払い'}
      ];
      //设定支払状態列表
      state.payStatusList = [
        {'id': '0', 'name': '未支払'},
        {'id': '1', 'name': '支払済み'}
      ];
      //设定申込状態列表
      state.applicationStatusList = [
        {'id': '0', 'name': '未受付'},
        {'id': '1', 'name': '受付済み'},
        {'id': '2', 'name': '却下'}
      ];
      //设定申込状態列表
      state.applicationStatusDetailList = [
        {'id': '1', 'name': '受付済み'},
        {'id': '2', 'name': '却下'}
      ];
      // 加载标记
      state.loadingFlag = false;
      // 自定义事件 - 始
      if (state.appId != 0) {
        // 详细页面数据检索
        add(SelectFormEvent());
        // 刷新补丁
        emit(clone(state));

        // 关闭加载
        BotToast.closeAllLoading();
      } else {
        //初期化检索条件
        await initUseType(state);
        initSearch(state);
        // 查询分页数据事件
        add(PageQueryEvent());
      }
      // 自定义事件 - 终
    });

    on<SelectFormEvent>((event, emit) async {
      List<dynamic> formList = await SupabaseUtils.getClient()
          .rpc('func_query_applicationtmp_usetype', params: {
        'id': state.appId,
      }).select("*");

      if (formList.length > 0) {
        if (formList[0]['account_type'] != null) {
          if (formList[0]['account_type'].toString() == '1') {
            formList[0]['account_num'] = 3;
          } else {
            formList[0]['account_num'] = formList[0]['account_num'] + 3;
          }
        }
        if (formList[0]['option'] != null) {
          formList[0]['option_name'] = getNamefromOtherList(
              formList[0]['option'].toString(), state.optionList);
        }
        if (formList[0]['pay_cycle'] != null) {
          formList[0]['pay_cycle_name'] = getNamefromOtherList(
              formList[0]['pay_cycle'].toString(), state.payCycleList);
        }
        if (formList[0]['pay_status'] != null) {
          formList[0]['pay_status_name'] = getNamefromOtherList(
              formList[0]['pay_status'].toString(), state.payStatusList);
        }
        if (formList[0]['application_status'] != null) {
          formList[0]['application_status_name'] = getNamefromOtherList(
              formList[0]['application_status'].toString(),
              state.applicationStatusList);
        }

        state.formInfo = formList[0] as Map<String, dynamic>;
        DateTime date = DateTime.parse(state.formInfo['create_time']);
        String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
        state.formInfo['create_time'] = time;
        // 刷新补丁
        emit(clone(state));
      }
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

      // 查询 申込受付
      var query =
          SupabaseUtils.getClient().from('ytb_application_tmp').select('*');

      query = setSelectConditions(state, query);

      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      for (int i = 0; i < data.length; i++) {
        data[i]['type_name'] = getNamefromList(
            data[i]['use_type_id'].toString(), state.useTypeList);
        data[i]['pay_status_name'] = getNamefromOtherList(
            data[i]['pay_status'].toString(), state.payStatusList);
        data[i]['application_status_name'] = getNamefromOtherList(
            data[i]['application_status'].toString(),
            state.applicationStatusList);
        data[i]['create_time'] = data[i]['create_time'].substring(0, 10);
        state.records.add(WmsRecordModel(i, data[i]));
      }
      // 查询总数
      var queryCount =
          SupabaseUtils.getClient().from('ytb_application_tmp').select(
                '*',
                const FetchOptions(
                  count: CountOption.exact,
                ),
              );
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
      if (event.key == 'use_type_id') {
        // 检索情报-临时
        searchTemp['use_type_name'] = event.name;
      }
      if (event.key == 'pay_status') {
        // 检索情报-临时
        searchTemp['pay_status_name'] = event.name;
      }
      if (event.key == 'application_status') {
        // 检索情报-临时
        searchTemp['application_status_name'] = event.name;
      }
      // 检索情报-定制
      state.searchInfo = searchTemp;
      // 更新
      emit(clone(state));
    });

    // 检索处理
    on<SeletAppEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['user_email'] != '' &&
          state.searchInfo['user_email'] != null) {
        state.conditionList.add(
            {'key': 'user_email', 'value': state.searchInfo['user_email']});
      }
      if (state.searchInfo['user_name'] != '' &&
          state.searchInfo['user_name'] != null) {
        state.conditionList
            .add({'key': 'user_name', 'value': state.searchInfo['user_name']});
      }
      if (state.searchInfo['user_phone'] != '' &&
          state.searchInfo['user_phone'] != null) {
        state.conditionList.add(
            {'key': 'user_phone', 'value': state.searchInfo['user_phone']});
      }
      if (state.searchInfo['company_name'] != '' &&
          state.searchInfo['company_name'] != null) {
        state.conditionList.add(
            {'key': 'company_name', 'value': state.searchInfo['company_name']});
      }
      if (state.searchInfo['company_name_short'] != '' &&
          state.searchInfo['company_name_short'] != null) {
        state.conditionList.add({
          'key': 'company_name_short',
          'value': state.searchInfo['company_name_short']
        });
      }
      if (state.searchInfo['use_type_id'] != '' &&
          state.searchInfo['use_type_id'] != null) {
        state.conditionList.add(
            {'key': 'use_type_id', 'value': state.searchInfo['use_type_name']});
      }
      if (state.searchInfo['pay_status'] != '' &&
          state.searchInfo['pay_status'] != null) {
        state.conditionList.add({
          'key': 'pay_status',
          'value': state.searchInfo['pay_status_name']
        });
      }
      if (state.searchInfo['application_status'] != '' &&
          state.searchInfo['application_status'] != null) {
        state.conditionList.add({
          'key': 'application_status',
          'value': state.searchInfo['application_status_name']
        });
      }
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    //清除检索条件
    on<ClearSeletAppEvent>(
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
      if ('user_email' == deleteColumn['key']) {
        state.searchInfo['user_email'] = '';
      } else if ('user_name' == deleteColumn['key']) {
        state.searchInfo['user_name'] = '';
      } else if ('user_phone' == deleteColumn['key']) {
        state.searchInfo['user_phone'] = '';
      } else if ('company_name' == deleteColumn['key']) {
        state.searchInfo['company_name'] = '';
      } else if ('company_name_short' == deleteColumn['key']) {
        state.searchInfo['company_name_short'] = '';
      } else if ('use_type_id' == deleteColumn['key']) {
        state.searchInfo['use_type_id'] = null;
        state.searchInfo['use_type_name'] = '';
      } else if ('pay_status' == deleteColumn['key']) {
        state.searchInfo['pay_status'] = '';
        state.searchInfo['pay_status_name'] = '';
      } else if ('application_status' == deleteColumn['key']) {
        state.searchInfo['application_status'] = '';
        state.searchInfo['application_status_name'] = '';
      }

      //删除显示检索条件
      state.conditionList.removeAt(event.index);

      // 更新
      emit(clone(state));
    });

    on<SetStatusValueEvent>(
      (event, emit) {
        state.application_status = event.value;
        state.application_status_name = event.name;
        emit(clone(state));
      },
    );
    //更新申请状态
    on<UpdateStatusEvent>(
      (event, emit) async {
        int updateId =
            StoreProvider.of<WMSState>(event.context).state.loginUser!.id!;
        String updateTime = DateTime.now().toString();
        BotToast.showLoading();
        try {
          if (state.application_status == '2') {
            // 「申込状態」＝「２：却下」
            await SupabaseUtils.getClient().from('ytb_application_tmp').update({
              'application_status': '2',
              'update_id': updateId,
              'update_time': updateTime
            }).eq('id', state.appId);
            state.appId = 0;
            emit(clone(state));
            var p1 = WMSLocalizations.i18n(event.context)!.app_send_text_1;
            var p2 = WMSLocalizations.i18n(event.context)!.app_send_text_4;
            var p3 = WMSLocalizations.i18n(event.context)!.app_send_text_5;
            var p4 = WMSLocalizations.i18n(event.context)!.app_send_text_6;
            var p5 = WMSLocalizations.i18n(event.context)!.app_send_text_7;
            var userEmail = state.formInfo['user_email'];
            String content =
                "<p>$p1 $userEmail $p2</p><p>$p3</p><p>$p4</p><p>$p5</p>";

            bool res = await MailUtils.sendEmailWithSMTP(
                userEmail,
                WMSLocalizations.i18n(event.context)!.app_send_text_12,
                content);
            //发送邮箱成功
            if (res) {
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .login_confirm_text_success);
              // 关闭弹窗
              Navigator.pop(event.context);
              GoRouter.of(event.context).pop('refresh return');
            } else {
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .login_confirm_text_error);
              // 关闭弹窗
              Navigator.pop(event.context);
            }
          } else if (state.application_status == '1') {
            // 申込状態は「１：受付済み」  check 支払状態は「0：未支払」
            if (state.formInfo['pay_status'] == '0') {
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(state.context)!.app_error_text_3);
              // 关闭加载状态
              BotToast.closeAllLoading();
              return;
            }

            if (state.formInfo['user_email'] != null &&
                state.formInfo['user_email'] != '') {
              List<dynamic> userList = await SupabaseUtils.getClient()
                  .from('mtb_user')
                  .select("*")
                  .eq("email", state.formInfo['user_email']);
              if (userList.length > 0) {
                WMSCommonBlocUtils.errorTextToast(
                    WMSLocalizations.i18n(state.context)!.app_error_text_4);
                // 关闭加载状态
                BotToast.closeAllLoading();
                return;
              }
            }
            Map<String, dynamic> result = {};
            result['name'] = state.formInfo['company_name'];

            // 挿入表「mtb_company(会社情報マスタ)」
            List<Map<String, dynamic>> formCompanyData = [];
            Company company = new Company.fromJson(result);
            company.create_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            company.create_time = DateTime.now().toString();
            company.update_id = updateId;
            company.update_time = updateTime;
            company.status = '1';
            company.forced_shipment_flag = '0';
            formCompanyData = await SupabaseUtils.getClient()
                .from('mtb_company')
                .insert([company.toJson()]).select('*');

            bool _flag = await signUpNewUser(state);
            if (!_flag) {
              // 关闭加载
              BotToast.closeAllLoading();
              return;
            }
            List<Map<String, dynamic>> formUserData = [];
            // 挿入表「mtb_user(ユーザーマスタ)」
            Wms.User user = Wms.User.empty();
            user.code = state.userCode;
            user.name = state.formInfo['user_name'];
            user.role_id = 2;
            user.company_id = formCompanyData[0]['id'];
            user.email = state.formInfo['user_email'];
            user.language_id = 2; //默认日语
            user.authenticator_key = state.formInfo['authenticator_key'];
            user.status = '1';
            user.start_date = DateTime.now().toString();
            user.end_date = '20991231';
            user.create_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            user.create_time = DateTime.now().toString();
            user.update_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            user.update_time = DateTime.now().toString();
            formUserData = await SupabaseUtils.getClient()
                .from('mtb_user')
                .insert([user.toJson()]).select('*');

            //挿入表「ytb_company_plan_manage(運用会社けいかく管理)」
            CompanyPlanManage companyPlanManage = CompanyPlanManage.empty();
            companyPlanManage.company_id = formCompanyData[0]['id'];
            companyPlanManage.promotion_code = state.formInfo['promotion_code'];
            companyPlanManage.base_ship = state.formInfo['base_ship'];
            companyPlanManage.base_receive = state.formInfo['base_receive'];
            companyPlanManage.base_store = state.formInfo['base_store'];
            companyPlanManage.plan_id = state.formInfo['plan_id'];
            companyPlanManage.account_type = state.formInfo['account_type'];
            companyPlanManage.account_num = state.formInfo['account_num'];
            companyPlanManage.option = state.formInfo['option'];
            companyPlanManage.pay_cycle = state.formInfo['pay_cycle'];
            // 获取当前时间
            DateTime now = DateTime.now();
            companyPlanManage.start_date = now.toString();

            // 计算下个月的时间
            DateTime nextMonth;
            // 处理年份和月份的变化
            if (now.month == 12) {
              nextMonth = DateTime(now.year + 1, 1, now.day);
            } else {
              nextMonth = DateTime(now.year, now.month + 1, now.day);
            }
            // 检查下个月的日期是否有效
            if (nextMonth.month != (now.month + 1) % 12) {
              // 如果无效，设置为下个月的最后一天
              nextMonth = DateTime(nextMonth.year, nextMonth.month + 1, 0);
            }
            companyPlanManage.next_date = nextMonth.toString();
            if (state.formInfo['pay_cycle'].toString() == '2') {
              // 计算一年后的时间
              companyPlanManage.end_date =
                  DateTime(now.year + 1, now.month, now.day).toString();
            } else {
              companyPlanManage.end_date = nextMonth.toString();
            }
            companyPlanManage.pay_status = state.formInfo['pay_status'];
            companyPlanManage.pay_no = state.formInfo['pay_no'];
            companyPlanManage.pay_total = state.formInfo['pay_total'];
            companyPlanManage.create_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            companyPlanManage.create_time = DateTime.now().toString();
            companyPlanManage.update_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            companyPlanManage.update_time = DateTime.now().toString();
            await SupabaseUtils.getClient()
                .from('ytb_company_plan_manage')
                .insert([companyPlanManage.toJson()]).select('*');

            // 临时更新
            //挿入表「ytb_company_manage(運用会社管理)」
            CompanyManage companyManage = CompanyManage.empty();
            companyManage.company_id = formCompanyData[0]['id'];
            companyManage.start_date = DateTime.now().toString();
            companyManage.end_date = nextMonth.toString();
            companyManage.user_id = formUserData[0]['id'];
            companyManage.note = '';
            companyManage.create_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            companyManage.create_time = DateTime.now().toString();
            companyManage.update_id =
                StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
            companyManage.update_time = DateTime.now().toString();
            await SupabaseUtils.getClient()
                .from('ytb_company_manage')
                .insert([companyManage.toJson()]).select('*');

            // 系统账票列表
            List<dynamic> systemFormList = await SupabaseUtils.getClient()
                .from('mtb_form')
                .select('*')
                .eq('company_id', 0);
            // 临时账票列表
            List<Map<String, dynamic>> tempFormList = [];
            // 循环系统账票列表
            for (int i = 0; i < systemFormList.length; i++) {
              // 系统账票
              Map<String, dynamic> systemForm = systemFormList[i];
              // 账票
              Form.Form form = Form.Form.empty();
              form.form_kbn = systemForm['form_kbn'];
              form.form_picture = systemForm['form_picture'];
              form.form_direction = systemForm['form_direction'];
              form.description = systemForm['description'];
              form.company_id = formCompanyData[0]['id'];
              form.create_time = DateTime.now().toString();
              form.create_id = 1;
              form.update_time = DateTime.now().toString();
              form.update_id = 1;
              // 临时账票列表
              tempFormList.add(form.toJson());
            }
            // 新账票列表
            List<dynamic> newFormList = await SupabaseUtils.getClient()
                .from('mtb_form')
                .insert(tempFormList)
                .select('*');
            // 系统账票明细列表
            List<dynamic> systemFormDetailList = await SupabaseUtils.getClient()
                .from('mtb_form_detail')
                .select('*')
                .eq('company_id', 0);
            // 临时账票明细列表
            List<Map<String, dynamic>> tempFormDetailList = [];
            // 循环系统账票明细列表
            for (int i = 0; i < systemFormDetailList.length; i++) {
              // 系统账票明细
              Map<String, dynamic> systemFormDetail = systemFormDetailList[i];
              // 循环系统账票列表
              for (int j = 0; j < systemFormList.length; j++) {
                // 判断是否相等
                if (systemFormList[j]['id'] == systemFormDetail['form_id']) {
                  // 循环新账票列表
                  for (int x = 0; x < newFormList.length; x++) {
                    // 判断是否相等
                    if (newFormList[x]['form_kbn'] ==
                        systemFormList[j]['form_kbn']) {
                      // 账票明细
                      FormDetail formDetail = FormDetail.empty();
                      formDetail.form_id = newFormList[x]['id'];
                      formDetail.location = systemFormDetail['location'];
                      formDetail.sequence_number =
                          systemFormDetail['sequence_number'];
                      formDetail.assort = systemFormDetail['assort'];
                      formDetail.content_table =
                          systemFormDetail['content_table'];
                      formDetail.content_fields =
                          systemFormDetail['content_fields'];
                      formDetail.calculation_table1 =
                          systemFormDetail['calculation_table1'];
                      formDetail.calculation_fields1 =
                          systemFormDetail['calculation_fields1'];
                      formDetail.calculation_table2 =
                          systemFormDetail['calculation_table2'];
                      formDetail.calculation_fields2 =
                          systemFormDetail['calculation_fields2'];
                      formDetail.calculation_mode =
                          systemFormDetail['calculation_mode'];
                      formDetail.show_field_name =
                          systemFormDetail['show_field_name'];
                      formDetail.prefix_text = systemFormDetail['prefix_text'];
                      formDetail.suffix_text = systemFormDetail['suffix_text'];
                      formDetail.word_size = systemFormDetail['word_size'];
                      formDetail.company_id = formCompanyData[0]['id'];
                      formDetail.create_time = DateTime.now().toString();
                      formDetail.create_id = 1;
                      formDetail.update_time = DateTime.now().toString();
                      formDetail.update_id = 1;
                      // 临时账票列表
                      tempFormDetailList.add(formDetail.toJson());
                      // 中止
                      break;
                    }
                  }
                  // 中止
                  break;
                }
              }
            }
            // 新账票明细列表
            await SupabaseUtils.getClient()
                .from('mtb_form_detail')
                .insert(tempFormDetailList)
                .select('*');

            // 採番マスタ
            for (var i = 1; i < 3; i++) {
              String year = DateTime.now().year.toString();
              String month = DateTime.now().month.toString();
              if (month.length == 1) {
                month = '0' + month;
              }
              Number number = Number.empty();
              number.company_id = formCompanyData[0]['id'];
              number.wms_channel =
                  i == 1 ? Config.WMS_CHANNEL_A : Config.WMS_CHANNEL_B;
              number.year_month = year + month;
              number.seq_no = 1;
              number.create_id =
                  StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
              number.create_time = DateTime.now().toString();
              number.update_id =
                  StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
              number.update_time = DateTime.now().toString();
              await SupabaseUtils.getClient()
                  .from('mtb_number')
                  .insert([number.toJson()]).select('*');
            }

            await SupabaseUtils.getClient().from('ytb_application_tmp').update({
              'application_status': '1',
              'update_id': updateId,
              'update_time': updateTime
            }).eq('id', state.appId);

            var p1 = WMSLocalizations.i18n(event.context)!.app_send_text_8;
            var p2 = WMSLocalizations.i18n(event.context)!.app_send_text_9;
            var p3 = WMSLocalizations.i18n(event.context)!.app_send_text_10;
            var p4 = WMSLocalizations.i18n(event.context)!.app_send_text_11;
            var p5 = WMSLocalizations.i18n(event.context)!.app_send_text_5;
            var p6 = WMSLocalizations.i18n(event.context)!.app_send_text_6;
            var p7 = WMSLocalizations.i18n(event.context)!.app_send_text_7;
            var userEmail = state.formInfo['user_email'];

            String content =
                "<p>$p1 $userEmail $p2</p><p>$p3</p><p><a href='$p4'>$p4</a></p><p>$p5</p><p>$p6</p><p>$p7</p>";
            // 发送邮件
            bool res = await MailUtils.sendEmailWithSMTP(
                userEmail,
                WMSLocalizations.i18n(event.context)!.app_send_text_13,
                content);
            //发送完成
            if (res) {
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .login_confirm_text_success);
              // 关闭弹窗
              Navigator.pop(event.context);
              GoRouter.of(event.context).pop('refresh return');
            } else {
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!
                      .login_confirm_text_error);
              // 关闭弹窗
              Navigator.pop(event.context);
            }
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_98_25 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }

        // 关闭加载状态
        BotToast.closeAllLoading();
      },
    );

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

  //初期化检索条件
  void initSearch(ApplicationCceptanceModel state) {
    state.searchInfo = {
      'user_email': '',
      'user_name': '',
      'user_phone': '',
      'company_name': '',
      'company_name_short': '',
      'use_type_id': null,
      'use_type_name': '',
      'pay_status': '',
      'pay_status_name': '',
      'application_status': '',
      'application_status_name': ''
    };
    state.conditionList = [];
  }

  //初期化下拉框
  Future<void> initUseType(ApplicationCceptanceModel state) async {
    //父菜单检索 会社情报マスタ
    List<dynamic> useTypeInfoList = await SupabaseUtils.getClient()
        .from('ytb_use_type')
        .select('*')
        .eq('role_id', 2);
    state.useTypeList = [];
    if (useTypeInfoList.length > 0) {
      for (int i = 0; i < useTypeInfoList.length; i++) {
        state.useTypeList.add({
          'id': useTypeInfoList[i]['id'].toString(),
          'type': useTypeInfoList[i]['type']
        });
      }
    }
  }

  //取得list中name
  String getNamefromList(String id, List<Map<String, dynamic>> nameList) {
    String typeName = '';
    if (nameList.isNotEmpty) {
      for (Map<String, dynamic> item in nameList) {
        if (item['id'] == id) {
          typeName = item['type'];
          break;
        }
      }
    }
    return typeName;
  }

  String getNamefromOtherList(String id, List<Map<String, dynamic>> nameList) {
    String typeName = '';
    if (nameList.isNotEmpty) {
      for (Map<String, dynamic> item in nameList) {
        if (item['id'] == id) {
          typeName = item['name'];
          break;
        }
      }
    }
    return typeName;
  }

  //设定检索条件
  PostgrestFilterBuilder setSelectConditions(
      ApplicationCceptanceModel state, PostgrestFilterBuilder query) {
    var result = query;
    if (state.searchInfo['user_email'] != '' &&
        state.searchInfo['user_email'] != null) {
      String userEmail = '%' + state.searchInfo['user_email'] + '%';
      query = query.like('user_email', userEmail.toString());
    }
    if (state.searchInfo['user_name'] != '' &&
        state.searchInfo['user_name'] != null) {
      String userName = '%' + state.searchInfo['user_name'] + '%';
      query = query.like('user_name', userName.toString());
    }
    if (state.searchInfo['user_phone'] != '' &&
        state.searchInfo['user_phone'] != null) {
      String userPhone = '%' + state.searchInfo['user_phone'] + '%';
      query = query.like('user_phone', userPhone.toString());
    }
    if (state.searchInfo['company_name'] != '' &&
        state.searchInfo['company_name'] != null) {
      String companyName = '%' + state.searchInfo['company_name'] + '%';
      query = query.like('company_name', companyName.toString());
    }
    if (state.searchInfo['company_name_short'] != '' &&
        state.searchInfo['company_name_short'] != null) {
      String companyNameShort =
          '%' + state.searchInfo['company_name_short'] + '%';
      query = query.like('company_name_short', companyNameShort.toString());
    }
    if (state.searchInfo['use_type_id'] != '' &&
        state.searchInfo['use_type_id'] != null) {
      query = query.eq('use_type_id', state.searchInfo['use_type_id']);
    }
    if (state.searchInfo['pay_status'] != '' &&
        state.searchInfo['pay_status'] != null) {
      query = query.eq('pay_status', state.searchInfo['pay_status'].toString());
    }
    if (state.searchInfo['application_status'] != '' &&
        state.searchInfo['application_status'] != null) {
      query = query.eq('application_status',
          state.searchInfo['application_status'].toString());
    }
    return result;
  }

  // 注册账号
  // Supabase.instance.client.auth.
  Future<bool> signUpNewUser(ApplicationCceptanceModel state) async {
    try {
      // 配置文件
      EnvConfig? envConfig = EnvConfig.fromJson(config);
      // 初始化Supabase
      final supabase =
          SupabaseClient(envConfig.supabase_url, envConfig.supabase_role_key);
      String UserPassword = '';
      //对密码进行解密
      UserPassword = Encryption.decodeBase64(state.formInfo['user_password']);
      // 更新授权
      final response = await supabase.auth.admin.createUser(AdminUserAttributes(
        email: state.formInfo['user_email'],
        password: UserPassword,
        emailConfirm: true,
      ));
      final User? user = response.user;
      final String? userId = user?.id;
      state.userCode = userId;
      return true;
    } catch (e) {
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.context)!.plan_content_text_9 +
              WMSLocalizations.i18n(state.context)!.create_error);
      return false;
    }
  }

  //检索前check处理
  bool selectCceptanceEventBeforeCheck(
      BuildContext context, ApplicationCceptanceModel state) {
    //检索条件check
    if (state.searchInfo['user_email'] != '' &&
        state.searchInfo['user_email'] != null &&
        CheckUtils.check_Email(state.searchInfo['user_email'])) {
      //email check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.app_cceptance_user_email +
              WMSLocalizations.i18n(context)!.input_email_check);
      return false;
    }
    if (state.searchInfo['user_phone'] != '' &&
        state.searchInfo['user_phone'] != null &&
        CheckUtils.check_Half_Number_Hyphen(state.searchInfo['user_phone'])) {
      //email check
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.app_cceptance_user_phone +
              WMSLocalizations.i18n(context)!
                  .input_half_width_numbers_with_hyphen_check);
      return false;
    }
    return true;
  }
}
