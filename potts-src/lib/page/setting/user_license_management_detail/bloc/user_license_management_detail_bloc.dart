import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/model/user.dart' as WMS;
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../env/dev.dart';
import '../../../../env/env_config.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../model/user_manage.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'user_license_management_detail_model.dart';

/**
 * 内容：ユーザーライセンス管理明细-BLOC
 * 作者：熊草云
 * 时间：2023/12/07
 */
// 事件
abstract class UserLicenseManagementDetailEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends UserLicenseManagementDetailEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定事件
class SetUserFormValueEvent extends UserLicenseManagementDetailEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetUserFormValueEvent(this.key, this.value);
}

//修正表单
class UpdateFormEvent extends UserLicenseManagementDetailEvent {
  UpdateFormEvent();
}

// 重置密码
class ResetPasswordEvent extends UserLicenseManagementDetailEvent {
  String newPassword;
  ResetPasswordEvent(this.newPassword);
}

// 设置当前组织列表
class SetNowOrganizationListEvent extends UserLicenseManagementDetailEvent {
  int companyId;
  SetNowOrganizationListEvent(this.companyId);
}

// 设置当前组织ID
class SetNowOrganizationIDEvent extends UserLicenseManagementDetailEvent {
  int nowOrganizationId;
  SetNowOrganizationIDEvent(this.nowOrganizationId);
}

// 设置明細表單
class SetDetailTypeFormEvent extends UserLicenseManagementDetailEvent {
  Map<String, dynamic> detailFrom;
  bool flag;
  SetDetailTypeFormEvent(this.detailFrom, this.flag);
}

// 设置明細表單
class SetDetailManageFormEvent extends UserLicenseManagementDetailEvent {
  Map<String, dynamic> detailFrom;
  bool flag;
  SetDetailManageFormEvent(this.detailFrom, this.flag);
}

// 设定明细值事件
class SetDetailValueEvent extends UserLicenseManagementDetailEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetDetailValueEvent(this.key, this.value);
}

//
class SetDetailFormIDEvent extends UserLicenseManagementDetailEvent {
  String key;
  String value;
  SetDetailFormIDEvent(this.key, this.value);
}

// 设置订单号
class SetDetailPayNotEvent extends UserLicenseManagementDetailEvent {
  String payNo;
  SetDetailPayNotEvent(this.payNo);
}

// 更新/插入数据
class UpdataDetailListEvent extends UserLicenseManagementDetailEvent {
  bool flag;
  UpdataDetailListEvent(this.flag);
}

// 赵士淞 - 始
// 免费支付事件
class FreeOfPaymentEvent extends UserLicenseManagementDetailEvent {
  // 免费支付事件
  FreeOfPaymentEvent();
}
// 赵士淞 - 终
// 自定义事件 - 终

class UserLicenseManagementDetailBloc
    extends WmsTableBloc<UserLicenseManagementDetailModel> {
  // 刷新补丁
  @override
  UserLicenseManagementDetailModel clone(UserLicenseManagementDetailModel src) {
    return UserLicenseManagementDetailModel.clone(src);
  }

  UserLicenseManagementDetailBloc(UserLicenseManagementDetailModel state)
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
      // 查询出荷指示
      var query = SupabaseUtils.getClient()
          .rpc('func_xiongcy_query_table_ytb_user_manage_detail', params: {
        'p_user_id': state.formInfo['id'],
        'p_company_id': state.formInfo['company_id'],
      }).select('*');

      // 总页数
      List<dynamic> result = await query;
      state.total = result.length;
      List<dynamic> data = await query.order('id', ascending: false).range(
          state.pageNum * state.pageSize,
          (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      for (int i = 0; i < data.length; i++) {
        if (data[i]['pay_status'] == '0') {
          data[i]['pay_status_name'] =
              WMSLocalizations.i18n(state.context)!.manage_pay_status_text_1;
        } else if (data[i]['pay_status'] == '1') {
          data[i]['pay_status_name'] =
              WMSLocalizations.i18n(state.context)!.manage_pay_status_text_2;
          WMSLocalizations.i18n(state.context)!.exit_input_table_delete;
        } else {
          data[i]['pay_status_name'] = '';
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }

      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设定事件
    on<SetUserFormValueEvent>((event, emit) async {
      //-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // -临时
        formTemp[event.key] = event.value;
      } else {
        // -临时
        formTemp.addAll({event.key: event.value});
      }
      // -定制
      state.formInfo = formTemp;
      //如果更新的是写真
      if (event.key == 'image') {
        state.formInfo['avatar'] = event.value;
        state.formInfo['image'] =
            await WMSCommonFile().previewImageFile(event.value);
      }
      // 更新
      emit(clone(state));
    });

    //登录/修改表单
    on<UpdateFormEvent>((event, emit) async {
      //check必须输入项目
      bool checkResult = checkMustInputColumn(state.formInfo, state.context);
      // 判断验证结果
      if (!checkResult) {
        return;
      }
      //model用map做成
      Map<String, dynamic> formInfo = changeCompanyMap(state.formInfo);
      // 商品master数据
      List<Map<String, dynamic>> formData;
      WMS.User userManage = WMS.User.fromJson(formInfo);
      //填入必须字段
      userManage.organization_id = state.nowOrganizationId;
      userManage.name = state.formInfo['user_name'];
      userManage.update_id =
          StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
      userManage.update_time = DateTime.now().toString();

      // 赵士淞 - 始
      // 判断新的用户角色
      if (userManage.role_id != Config.ROLE_ID_2) {
        // 查询课金法人
        List<dynamic> companyManageList = await SupabaseUtils.getClient()
            .from('ytb_company_manage')
            .select()
            .eq('company_id', userManage.company_id)
            .eq('user_id', userManage.id);
        // 判断课金法人数量
        if (companyManageList.length > 0) {
          // 失败提示
          WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(state.context)!
              .user_is_legal_role_cannot_changed);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      // 赵士淞 - 终

      try {
        BotToast.showLoading();
        // 新增商品
        formData = await SupabaseUtils.getClient()
            .from('mtb_user')
            .update(userManage.toJson())
            .eq('id', state.formInfo['id'])
            .select('*');
        // 判断数据
        if (formData.length != 0) {
          state.updateForm = true;
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                  WMSLocalizations.i18n(state.context)!.update_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                  WMSLocalizations.i18n(state.context)!.update_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                WMSLocalizations.i18n(state.context)!.update_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 重置密码
    on<ResetPasswordEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 赵士淞 - 始
      // 配置文件
      EnvConfig? envConfig = EnvConfig.fromJson(config);
      // 初始化Supabase
      final supabase =
          SupabaseClient(envConfig.supabase_url, envConfig.supabase_role_key);
      // 赵士淞 - 终
      try {
        // 赵士淞 - 始
        // 更新授权
        await supabase.auth.admin.updateUserById(state.formInfo['code'],
            attributes: AdminUserAttributes(password: event.newPassword));
        // 赵士淞 - 终
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                WMSLocalizations.i18n(state.context)!.update_success);
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                WMSLocalizations.i18n(state.context)!.update_error);
      }
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置明細表單
    on<SetDetailTypeFormEvent>((event, emit) async {
      if (event.flag) {
        state.detailFormTypeInfo = event.detailFrom;
        final Map<String, dynamic> newMap =
            Map.from(state.detailFormManageInfo);
        // 修改 Map
        // 将字符串类型的日期转换为 DateTime 类型
        final DateTime startDate =
            DateTime.parse(state.detailFormManageInfo['start_date']);
        // 将年/月/日转换为 int 类型
        final int year =
            int.parse(event.detailFrom['expiration_year'].toString());
        final int month =
            int.parse(event.detailFrom['expiration_month'].toString());
        final int day =
            int.parse(event.detailFrom['expiration_day'].toString());
        // 将年/月/日添加到日期中
        final DateTime endDate = DateTime(startDate.year + year,
            startDate.month + month, startDate.day + day);
        // 将 endDate 转换为字符串类型
        final String endDateString = endDate.toString().split(' ')[0];

        // 将 endDate 添加到 newMap 中
        newMap['end_date'] = endDateString;
        //
        state.detailFormManageInfo = newMap;
        final Map<String, dynamic> newTypeMap =
            Map.from(state.detailFormTypeInfo);
        newTypeMap['use_type_id'] = (event.detailFrom['use_type_id'] == '' ||
                event.detailFrom['use_type_id'] == null)
            ? event.detailFrom['id']
            : event.detailFrom['use_type_id'];
        state.detailFormTypeInfo = newTypeMap;
      } else {
        initDetailTypeForm(state);
      }
      emit(clone(state));
    });
    // 设置明細表單
    on<SetDetailManageFormEvent>((event, emit) async {
      if (event.flag) {
        state.detailFormManageInfo = event.detailFrom;
      } else {
        final Map<String, dynamic> newMap =
            Map.from(state.detailFormManageInfo);

        // 赵士淞 - 始
        // 運用会社ユーザー列表
        List userManageList = await SupabaseUtils.getClient()
            .from('ytb_user_manage')
            .select('*')
            .eq('company_id', state.formInfo['company_id'])
            .eq('user_id', state.formInfo['id'])
            .eq('pay_status', Config.NUMBER_ONE.toString())
            .order('id', ascending: false);
        // 判断運用会社ユーザー列表数量
        if (userManageList.length == 0 ||
            userManageList[0]['end_date']
                    .compareTo(DateTime.now().toString().split(' ')[0]) <
                0) {
          // 運用開始日
          newMap['start_date'] = DateTime.now().toString().split(' ')[0];
        } else {
          // 運用開始日
          newMap['start_date'] = DateTime.parse(userManageList[0]['end_date'])
              .add(Duration(days: 1))
              .toString()
              .split(' ')[0];
        }
        // 赵士淞 - 终

        if (state.roleId != 1) {
          newMap['pay_status'] = '0';
          newMap['pay_status_name'] =
              WMSLocalizations.i18n(state.context)!.manage_pay_status_text_1;
        }
        state.detailFormManageInfo = newMap;
      }
      emit(clone(state));
    });
    on<SetNowOrganizationIDEvent>((event, emit) async {
      state.nowOrganizationId =
          event.nowOrganizationId == 0 ? null : event.nowOrganizationId;
      emit(clone(state));
    });
    // 设置当前組織列表
    on<SetNowOrganizationListEvent>((event, emit) async {
      //设定組織列表
      if (event.companyId == 0) {
        state.salesOrganizationfoList = [];
        state.formInfo['organization_name'] = '';
      } else {
        // 組織名列表
        List organizationList = await SupabaseUtils.getClient()
            .from('mtb_organization')
            .select('*')
            .eq('company_id', event.companyId);
        state.salesOrganizationfoList = organizationList;
      }
      emit(clone(state));
    });

    // 设定事件
    on<SetDetailValueEvent>((event, emit) async {
      //-临时
      Map<String, dynamic> formDetailTemp = Map<String, dynamic>();
      formDetailTemp.addAll(state.detailFormManageInfo);
      // 判断key
      if (formDetailTemp[event.key] != null) {
        // -临时
        formDetailTemp[event.key] = event.value;
      } else {
        // -临时
        formDetailTemp.addAll({event.key: event.value});
      }
      // -定制
      state.detailFormManageInfo = formDetailTemp;
      // 更新
      emit(clone(state));
    });
    //
    on<SetDetailFormIDEvent>((event, emit) async {
      Map<String, dynamic> formDetailTemp = Map<String, dynamic>();
      formDetailTemp.addAll(state.detailFormManageInfo);
      if (event.value == '-1') {
        formDetailTemp[event.key] = '';
      } else {
        formDetailTemp[event.key] = event.value;
      }
      state.detailFormManageInfo = formDetailTemp;
      // 更新
      emit(clone(state));
    });

    // 设置订单号
    on<SetDetailPayNotEvent>((event, emit) async {
      state.detailFormManageInfo['pay_no'] = event.payNo;
    });

    // 更新/插入明细数据
    on<UpdataDetailListEvent>((event, emit) async {
      BotToast.showLoading();
      //model用map做成
      Map<String, dynamic> formInfo =
          changeCompanyMap(state.detailFormManageInfo);
      // 商品master数据
      List<Map<String, dynamic>> formData;
      UserManage userManage = UserManage.fromJson(formInfo);
      // 修正
      if (event.flag) {
        //填入必须字段
        userManage.pay_total = (state.detailFormTypeInfo['amount'] +
                state.detailFormTypeInfo['amount'] * .1)
            .toInt();
        userManage.use_type_id = state.detailFormTypeInfo['use_type_id'];
        userManage.update_id =
            StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
        userManage.update_time = DateTime.now().toString();
        try {
          // 新增商品
          formData = await SupabaseUtils.getClient()
              .from('ytb_user_manage')
              .update(userManage.toJson())
              .eq('id', state.detailFormManageInfo['id'])
              .select('*');

          // 判断商品数据
          if (formData.length != 0) {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(state.context)!.account_license_type +
                    WMSLocalizations.i18n(state.context)!.update_success);
          } else {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(state.context)!.account_license_type +
                    WMSLocalizations.i18n(state.context)!.update_error);
          }
        } catch (e) {
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.context)!.account_license_type +
                  WMSLocalizations.i18n(state.context)!.update_error);
        }
      } else {
        // 登录
        //填入必须字段
        userManage.pay_total = (state.detailFormTypeInfo['amount'] +
                state.detailFormTypeInfo['amount'] * .1)
            .toInt();
        userManage.use_type_id =
            int.parse(state.detailFormTypeInfo['use_type_id'].toString());
        userManage.update_id =
            StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
        userManage.update_time = DateTime.now().toString();
        userManage.create_id =
            StoreProvider.of<WMSState>(state.context).state.loginUser?.id;
        userManage.create_time = DateTime.now().toString();
        userManage.company_id =
            int.parse(state.formInfo['company_id'].toString());
        userManage.user_id = int.parse(state.formInfo['id'].toString());
        try {
          formData = await SupabaseUtils.getClient()
              .from('ytb_user_manage')
              .insert([userManage.toJson()]).select('*');
          if (formData.length != 0) {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(state.context)!.account_license_type +
                    WMSLocalizations.i18n(state.context)!.create_success);
          } else {
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(state.context)!.account_license_type +
                    WMSLocalizations.i18n(state.context)!.create_error);
          }
        } catch (e) {
          WMSCommonBlocUtils.tipTextToast(
              WMSLocalizations.i18n(state.context)!.account_license_type +
                  WMSLocalizations.i18n(state.context)!.create_error);
        }
      }
      initDetailManageForm(state);
      initDetailTypeForm(state);
      add(PageQueryEvent());
    });
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // ロール列表
      List roleList = await SupabaseUtils.getClient()
          .from('mtb_role')
          .select('*')
          .not('id', 'eq', 1);
      state.salesRoleInfoList = roleList;
      // 状態列表
      List statusList = [
        {
          'id': '1',
          'status_name':
              WMSLocalizations.i18n(state.context)!.user_status_text_1
        },
        {
          'id': '2',
          'status_name':
              WMSLocalizations.i18n(state.context)!.user_status_text_2
        },
        {
          'id': '3',
          'status_name':
              WMSLocalizations.i18n(state.context)!.user_status_text_3
        },
        {
          'id': '4',
          'status_name':
              WMSLocalizations.i18n(state.context)!.exit_input_table_delete
        },
      ];
      state.salesStatusInfoList = statusList;
      List typeList = [];
      DateTime currentDate = DateTime.now();
      typeList = await SupabaseUtils.getClient()
          .from('ytb_use_type')
          .select('*')
          .eq('role_id', state.formInfo['role_id'])
          .lte('start_date', currentDate)
          .gte('end_date', currentDate);
      state.salesTypeInfoList = typeList;
      add(SetNowOrganizationListEvent(state.formInfo['company_id']));
      // 言語列表
      List languageList =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      state.salesLanguageInfoList = languageList;
      // 支払状態列表
      List paymentStatus = [
        {
          'id': '0',
          'pay_status_name':
              WMSLocalizations.i18n(state.context)!.manage_pay_status_text_1
        },
        {
          'id': '1',
          'pay_status_name':
              WMSLocalizations.i18n(state.context)!.manage_pay_status_text_2
        }
      ];
      state.nowOrganizationId = state.formInfo['organization_id'];
      state.salesPaymentStatusInfoList = paymentStatus;
      // 照片处理
      try {
        if (state.formInfo['avatar'] != '' &&
            state.formInfo['avatar'] != null) {
          state.formInfo['image'] =
              await WMSCommonFile().previewImageFile(state.formInfo['avatar']);
        }
      } catch (e) {
        state.formInfo['image'] = '';
      }
      // 加载标记
      state.loadingFlag = false;
      emit(clone(state));
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 赵士淞 - 始
    on<FreeOfPaymentEvent>((event, emit) async {
      // 更新ユーザー
      List<Map<String, dynamic>> userData = await SupabaseUtils.getClient()
          .from('mtb_user')
          .update({
            'end_date': state.detailFormManageInfo['end_date'],
            'status': Config.NUMBER_ONE.toString()
          })
          .eq('company_id', state.formInfo['company_id'])
          .eq('id', state.formInfo['id'])
          .select('*');
      // 判断ユーザー数量
      if (userData.length == 0) {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.payment_status_update_failed);
        return;
      }

      // 当前ユーザー
      Map<String, dynamic> currentUserData = userData[0];

      // 判断当前ユーザー角色
      if (currentUserData['role_id'] == 2) {
        // 更新運用会社
        List<Map<String, dynamic>> companyManageData =
            await SupabaseUtils.getClient()
                .from('ytb_company_manage')
                .update({'end_date': state.detailFormManageInfo['end_date']})
                .eq('company_id', state.formInfo['company_id'])
                .eq('user_id', state.formInfo['id'])
                .select('*');
        // 判断運用会社数量
        if (companyManageData.length == 0) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!
                  .payment_status_update_failed);
          return;
        }
      }
    });
    // 赵士淞 - 终

    add(InitEvent());
  }
  //自定义方法 - 始
  //初期化明细表单
  void initDetailTypeForm(UserLicenseManagementDetailModel state) {
    // 会社情报初期化
    state.detailFormTypeInfo = {
      'use_type_id': '',
      'type': '',
      'support_cotent': '',
      'amount': '',
      'expiration_year': '',
      'expiration_month': '',
      'expiration_day': '',
    };
  }

  void initDetailManageForm(UserLicenseManagementDetailModel state) {
    // 会社情报初期化
    state.detailFormManageInfo = {
      'id': '',
      'start_date': '',
      'end_date': '',
      'pay_status': '',
      'pay_no': '',
      'pay_status_name': '',
      'create_time': '',
    };
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['user_name'] == null || formInfo['user_name'] == '') {
      //ユーザー_名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.user_license_management_form_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['role_name'] == null || formInfo['role_name'] == '') {
      //ロール
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_profile_roll +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['company_name'] == null ||
        formInfo['company_name'] == '') {
      //会社
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['status_name'] == null ||
        formInfo['status_name'] == '') {
      //状態
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_profile_state +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['start_date'] == null || formInfo['start_date'] == '') {
      //開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_content_4_10_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['end_date'] == null || formInfo['end_date'] == '') {
      //終了日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.menu_content_4_10_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (formInfo['language_name'] == null ||
        formInfo['language_name'] == '') {
      // 言語
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.user_license_management_form_2 +
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
  //自定义方法 - 终
}
