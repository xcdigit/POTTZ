import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/model/user.dart' as Wms;
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../env/dev.dart';
import '../../../../env/env_config.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'user_license_management_model.dart';

/**
 * 内容：ユーザーライセンス管理-BLOC
 * 作者：熊草云
 * 时间：2023/12/07
 */
// 事件
abstract class UserLicenseManagementEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends UserLicenseManagementEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定检索条件值事件
class SetSearchValueEvent extends UserLicenseManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetSearchValueEvent(this.key, this.value);
}

// 设置检索ロールID
class SetSearchRoleIdValueEvent extends UserLicenseManagementEvent {
  int roleId;
  SetSearchRoleIdValueEvent(this.roleId);
}

// 设置检索状态ID
class SetSearchStatusIDEvent extends UserLicenseManagementEvent {
  String nowStatus;
  SetSearchStatusIDEvent(this.nowStatus);
}

// 删除检索条件值事件
class DeleteSearchValueEvent extends UserLicenseManagementEvent {
  // index
  int index;

  // 设定值事件
  DeleteSearchValueEvent(this.index);
}

// 设定表单情报值事件
class SetUserFormValueEvent extends UserLicenseManagementEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetUserFormValueEvent(this.key, this.value);
}

// 设置当前组织列表
class SetNowOrganizationListEvent extends UserLicenseManagementEvent {
  int companyId;
  SetNowOrganizationListEvent(this.companyId);
}

//清除表单
class ClearFormEvent extends UserLicenseManagementEvent {
  // 清除表单
  ClearFormEvent();
}

//登录/修改表单
class UpdateFormEvent extends UserLicenseManagementEvent {
  // 结构树
  BuildContext context;
  UpdateFormEvent(this.context);
}

//删除账号
class DeleteUserEvent extends UserLicenseManagementEvent {
  // 结构树
  BuildContext context;
  int userId;
  String code;
  DeleteUserEvent(this.context, this.userId, this.code);
}

//检索处理
class SeletUserEvent extends UserLicenseManagementEvent {
  // 结构树
  BuildContext context;
  //检索处理
  SeletUserEvent(this.context);
}

//清除检索条件
class ClearSeletUserEvent extends UserLicenseManagementEvent {
  //检索处理
  ClearSeletUserEvent();
}

// 设置当前会社ID
class SetNowCompanyIDEvent extends UserLicenseManagementEvent {
  int nowCompanyId;
  SetNowCompanyIDEvent(this.nowCompanyId);
}

// 设置当前ロールID
class SetNowRoleIDEvent extends UserLicenseManagementEvent {
  int nowRoleId;
  SetNowRoleIDEvent(this.nowRoleId);
}

// 设置当前组织ID
class SetNowOrganizationIDEvent extends UserLicenseManagementEvent {
  int nowOrganizationId;
  SetNowOrganizationIDEvent(this.nowOrganizationId);
}

// 设置当前语言ID
class SetNowLanguageIDEvent extends UserLicenseManagementEvent {
  int nowLanguageId;
  SetNowLanguageIDEvent(this.nowLanguageId);
}

// 设置sort字段
class SetSortEvent extends UserLicenseManagementEvent {
  // 排序字段
  String sortCol;
  // 排序方式
  bool asc;
  SetSortEvent(this.sortCol, this.asc);
}

// 自定义事件 - 终

class UserLicenseManagementBloc
    extends WmsTableBloc<UserLicenseManagementModel> {
  // 刷新补丁
  @override
  UserLicenseManagementModel clone(UserLicenseManagementModel src) {
    return UserLicenseManagementModel.clone(src);
  }

  UserLicenseManagementBloc(UserLicenseManagementModel state) : super(state) {
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
      // 查询用户列表
      var query = SupabaseUtils.getClient()
          .rpc('func_xiongcy_query_table_mtb_user_list', params: {
        'p_email':
            state.searchInfo['email'] == '' ? null : state.searchInfo['email'],
        'p_user_name': state.searchInfo['user_name'] == ''
            ? null
            : state.searchInfo['user_name'],
        'p_role_id': state.searchRoleId,
        'p_company_name': state.searchInfo['company_name'] == ''
            ? null
            : state.searchInfo['company_name'],
        'p_organization_name': state.searchInfo['organization_name'] == ''
            ? null
            : state.searchInfo['organization_name'],
        'p_status': state.searchStatusId == '' ? null : state.searchStatusId,
        'p_start_date': state.searchInfo['start_date'] == ''
            ? null
            : state.searchInfo['start_date'],
        'p_end_date': state.searchInfo['end_date'] == ''
            ? null
            : state.searchInfo['end_date'],
        'p_company_id': state.companyId,
        'p_role_id_main': state.roleId,
      }).select('*');

      // 总页数
      List<dynamic> result = await query;
      state.total = result.length;
      List<dynamic> data = await query
          .order(state.sortCol, ascending: state.ascendingFlg)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环数据
      for (int i = 0; i < data.length; i++) {
        if (data[i]['status'] == '1') {
          data[i]['status_name'] =
              WMSLocalizations.i18n(state.context)!.user_status_text_1;
        } else if (data[i]['status'] == '2') {
          data[i]['status_name'] =
              WMSLocalizations.i18n(state.context)!.user_status_text_2;
        } else if (data[i]['status'] == '3') {
          data[i]['status_name'] =
              WMSLocalizations.i18n(state.context)!.user_status_text_3;
        } else if (data[i]['status'] == '4') {
          data[i]['status_name'] =
              WMSLocalizations.i18n(state.context)!.exit_input_table_delete;
        } else {
          data[i]['status_name'] = '';
        }
        // 列表数据增加
        state.records.add(WmsRecordModel(i, data[i]));
      }
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
    // 设置检索角色id
    on<SetSearchRoleIdValueEvent>((event, emit) {
      state.searchRoleId = event.roleId;
      // 更新
      emit(clone(state));
    });
    // 设置检索状态id
    on<SetSearchStatusIDEvent>((event, emit) {
      state.searchStatusId = event.nowStatus;
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
      if ('email' == deleteColumn['key']) {
        state.searchInfo['email'] = '';
      } else if ('user_name' == deleteColumn['key']) {
        state.searchInfo['user_name'] = '';
      } else if ('role_name' == deleteColumn['key']) {
        state.searchInfo['role_name'] = '';
        state.searchRoleId = null;
      } else if ('company_name' == deleteColumn['key']) {
        state.searchInfo['company_name'] = '';
      } else if ('organization_name' == deleteColumn['key']) {
        state.searchInfo['organization_name'] = '';
      } else if ('status_name' == deleteColumn['key']) {
        state.searchInfo['status_name'] = '';
        state.searchStatusId = null;
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

    // 设定表单情报值事件
    on<SetUserFormValueEvent>((event, emit) async {
      // 会社情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formInfo);
      // 判断key
      if (formTemp[event.key] != null) {
        // 会社情报-临时
        formTemp[event.key] = event.value;
        //如果更新的是图标
        if (event.key == 'avatar_image') {
          formTemp['avatar'] = event.value;
          formTemp['avatar_image'] =
              await WMSCommonFile().previewImageFile(event.value);
        }
      } else {
        // 会社情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 会社情报-定制
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

    //登录表单
    on<UpdateFormEvent>((event, emit) async {
      //check必须输入项目
      bool checkResult = checkMustInputColumn(state.formInfo, event.context);
      // 判断验证结果
      if (!checkResult) {
        return;
      }

      List<dynamic> emailList = await SupabaseUtils.getClient()
          .from('mtb_user')
          .select()
          .eq('email', state.formInfo['email']);
      if (emailList.length > 0) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(WMSLocalizations.i18n(state.context)!
            .user_license_management_tip_1);
        return;
      }
      BotToast.showLoading();
      //model用map做成
      Map<String, dynamic> formInfo = changeCompanyMap(state.formInfo);
      // 数据
      List<Map<String, dynamic>> formData;
      Wms.User userManage = Wms.User.fromJson(formInfo);
      //判断登录场合
      userManage.name = state.formInfo['user_name'];
      userManage.language_id = state.nowLanguageId;
      userManage.organization_id = state.nowOrganizationId;
      userManage.role_id = state.nowRoleId;
      userManage.company_id = state.nowCompanyId;
      userManage.create_id =
          StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
      userManage.create_time = DateTime.now().toString();
      userManage.update_id =
          StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
      userManage.update_time = DateTime.now().toString();
      bool _flag = await signUpNewUser(state);
      if (!_flag) {
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      userManage.code = state.userCode;
      try {
        // 新增商品
        formData = await SupabaseUtils.getClient()
            .from('mtb_user')
            .insert([userManage.toJson()]).select('*');
        // 判断user数据
        if (formData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_98_24 +
                  WMSLocalizations.i18n(event.context)!.create_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_98_24 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.context)!.menu_content_98_24 +
                WMSLocalizations.i18n(event.context)!.create_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 返回上一页
      GoRouter.of(event.context).pop('refresh return');
      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    //删除用户
    on<DeleteUserEvent>((event, emit) async {
      // 判断是否是法人
      List<dynamic> companyManageList = await SupabaseUtils.getClient()
          .from('ytb_company_manage')
          .select()
          .eq('user_id', event.userId);
      // 判断课金法人数量
      if (companyManageList.length > 0) {
        // 失败提示
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(state.context)!.user_is_legal_cannot_delete);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      BotToast.showLoading();

      try {
        // // 删除账号
        List<Map<String, dynamic>> userData = await SupabaseUtils.getClient()
            .from('mtb_user')
            .delete()
            .eq('id', event.userId)
            .select('*');
        if (userData.length != 0) {
          await deleteUser(event.code);
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                  WMSLocalizations.i18n(state.context)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                  WMSLocalizations.i18n(state.context)!.delete_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
                WMSLocalizations.i18n(state.context)!.delete_error);
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
    on<SeletUserEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      //设定显示检索条件
      state.conditionList = [];
      if (state.searchInfo['email'] != '' &&
          state.searchInfo['email'] != null) {
        state.conditionList
            .add({'key': 'email', 'value': state.searchInfo['email']});
      }
      if (state.searchInfo['user_name'] != '' &&
          state.searchInfo['user_name'] != null) {
        state.conditionList
            .add({'key': 'user_name', 'value': state.searchInfo['user_name']});
      }
      if (state.searchInfo['role_name'] != '' &&
          state.searchInfo['role_name'] != null) {
        state.conditionList
            .add({'key': 'role_name', 'value': state.searchInfo['role_name']});
      }
      if (state.searchInfo['company_name'] != '' &&
          state.searchInfo['company_name'] != null) {
        state.conditionList.add(
            {'key': 'company_name', 'value': state.searchInfo['company_name']});
      }
      if (state.searchInfo['organization_name'] != '' &&
          state.searchInfo['organization_name'] != null) {
        state.conditionList.add({
          'key': 'organization_name',
          'value': state.searchInfo['organization_name']
        });
      }
      if (state.searchInfo['status_name'] != '' &&
          state.searchInfo['status_name'] != null) {
        state.conditionList.add(
            {'key': 'status_name', 'value': state.searchInfo['status_name']});
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
    on<ClearSeletUserEvent>((event, emit) {
      // 打开加载状态
      BotToast.showLoading();
      //初期化检索条件
      initSearch(state);
      // 更新
      emit(clone(state));

      state.searchRoleId = null;
      state.searchStatusId = null;

      // 关闭加载
      BotToast.closeAllLoading();
    });
    // 当前表单的会社id
    on<SetNowCompanyIDEvent>((event, emit) async {
      state.nowCompanyId = event.nowCompanyId == 0 ? null : event.nowCompanyId;
      emit(clone(state));
    });
    // 当前表单的角色id
    on<SetNowRoleIDEvent>((event, emit) async {
      state.nowRoleId = event.nowRoleId == 0 ? null : event.nowRoleId;
      emit(clone(state));
    });
    // 当前表单的组织id
    on<SetNowOrganizationIDEvent>((event, emit) async {
      state.nowOrganizationId =
          event.nowOrganizationId == 0 ? null : event.nowOrganizationId;
      emit(clone(state));
    });
    // 当前表单的语言id
    on<SetNowLanguageIDEvent>((event, emit) async {
      state.nowLanguageId =
          event.nowLanguageId == 0 ? null : event.nowLanguageId;
      emit(clone(state));
    });
// 设置当前组织列表
    on<SetNowOrganizationListEvent>((event, emit) async {
      //设定管理员列表
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
        // if (state.salesOrganizationfoList.length == 0) {
        //   state.formInfo['organization_name'] = '';
        //   WMSCommonBlocUtils.tipTextToast(
        //       WMSLocalizations.i18n(state.context)!.charge_management_tip_2);
        // }
      }

      emit(clone(state));
    });
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (state.roleId != 1) {
        // 会社管理员
        List companyName = await SupabaseUtils.getClient()
            .from('mtb_company')
            .select('*')
            .eq('id', state.companyId);
        state.companyName = companyName[0]['name'];
        add(SetNowCompanyIDEvent(state.companyId));
        add(SetNowRoleIDEvent(3));
        add(SetNowOrganizationListEvent(state.companyId));
        // ロール列表
        List roleList =
            await SupabaseUtils.getClient().from('mtb_role').select('*');
        state.salesRoleInfoList = roleList;
      } else {
        //设定会社名列表
        List companyList = await SupabaseUtils.getClient()
            .from('mtb_company')
            .select('*')
            .eq('status', Config.WMS_COMPANY_STATUS_1);
        state.salesCompanyInfoList = companyList;
        // ロール列表
        List roleList = await SupabaseUtils.getClient()
            .from('mtb_role')
            .select('*')
            .not('id', 'eq', 1);
        state.salesRoleInfoList = roleList;
      }

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
      // 言語列表
      List languageList =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      state.salesLanguageInfoList = languageList;
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
      BuildContext context, UserLicenseManagementModel state) {
    //检索条件check
    if (state.searchInfo['email'] != null &&
        state.searchInfo['email'] != '' &&
        CheckUtils.check_Email(state.searchInfo['email'])) {
      // Email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_profile_user +
              WMSLocalizations.i18n(context)!.input_email_check);
      return false;
    }

    add(SeletUserEvent(context));
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> formInfo, BuildContext context) {
    if (formInfo['email'] == null || formInfo['email'] == '') {
      //Email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_profile_user +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(formInfo['email'])) {
      //Email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_profile_user +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    } else if (formInfo['password'] == null || formInfo['password'] == '') {
      //パスワード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_security_password +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Password(formInfo['password'])) {
      //パスワード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_security_password +
              WMSLocalizations.i18n(context)!.check_password);
      return false;
    } else if (formInfo['user_name'] == null || formInfo['user_name'] == '') {
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
    if (formInfo['password'] != null || formInfo['password'] != '') {
      if (formInfo['password'].length < 6) {
        //パスワード
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.user_license_management_tip_8);
        return false;
      }
    }
    //開始日
    String date1 = formInfo['start_date'].toString().replaceAll("/", "-");
    //終了日
    String date2 = formInfo['end_date'].toString().replaceAll("/", "-");
    //日期转换
    DateTime startDate = DateTime.parse(date1);
    DateTime endDate = DateTime.parse(date2);
    // 比较两个日期
    if (startDate.isAfter(endDate)) {
      //終了日不能大于開始日
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.operator_text_5);
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
  Future<void> initForm(UserLicenseManagementModel state) async {
    String rolename = '';
    if (state.roleId != 1) {
      List roleName = await SupabaseUtils.getClient()
          .from('mtb_role')
          .select('*')
          .eq('id', 3);
      rolename = roleName[0]['name'];
    }

    // 会社情报初期化
    state.formInfo = {
      'id': '',
      'email': '',
      'password': '',
      'user_name': '',
      'role_name': state.roleId != 1 ? rolename : '',
      'company_name': state.roleId != 1 ? state.companyName : '',
      'organization_name': '',
      'status': '2',
      'status_name': WMSLocalizations.i18n(state.context)!.user_status_text_2,
      'start_date': '',
      'end_date': '',
      'language_name': '',
      'avatar_image': '',
      'avatar': '',
      'description': '',
    };
  }

  //初期化检索条件
  void initSearch(UserLicenseManagementModel state) {
    state.searchInfo = {
      'email': '',
      'user_name': '',
      'role_name': '',
      'company_name': '',
      'organization_name': '',
      'status': '',
      'status_name': '',
      'start_date': '',
      'end_date': '',
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

  // 注册账号
  // Supabase.instance.client.auth.
  Future<bool> signUpNewUser(UserLicenseManagementModel state) async {
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
      final response = await supabase.auth.admin.createUser(AdminUserAttributes(
        email: state.formInfo['email'],
        password: state.formInfo['password'],
        emailConfirm: true,
      ));
      // 赵士淞 - 终
      final User? user = response.user;
      final String? userId = user?.id;
      state.userCode = userId;
      return true;
    } catch (e) {
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
              WMSLocalizations.i18n(state.context)!.create_error);
      return false;
    }
  }

  // 删除账号
  // Supabase.instance.client.auth.
  Future<bool> deleteUser(String UID) async {
    // 赵士淞 - 始
    // 配置文件
    EnvConfig? envConfig = EnvConfig.fromJson(config);
    // 初始化Supabase
    final supabase =
        SupabaseClient(envConfig.supabase_url, envConfig.supabase_role_key);
    try {
      // 删除账号
      await supabase.auth.admin.deleteUser(UID);
      return true;
    } catch (e) {
      // 失败提示
      WMSCommonBlocUtils.errorTextToast(
          WMSLocalizations.i18n(state.context)!.menu_content_98_24 +
              WMSLocalizations.i18n(state.context)!.delete_error);
      // 关闭加载
      BotToast.closeAllLoading();
      return false;
    }
  }
  //自定义方法 - 终
}
