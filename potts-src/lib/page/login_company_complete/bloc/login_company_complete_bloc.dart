import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/wms_common_bloc_utils.dart';
import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/storage/local_storage.dart';
import '../../../common/utils/common_utils.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import 'login_company_complete_model.dart';

/**
 * 内容：登录公司完整性-BLOC
 * 作者：赵士淞
 * 时间：2024/12/16
 */
// 事件
abstract class LoginCompanyCompleteEvent {}

// 初始化事件
class InitEvent extends LoginCompanyCompleteEvent {
  // 初始化事件
  InitEvent();
}

// 选中语言变更事件
class SelectedLanguageChangeEvent extends LoginCompanyCompleteEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 保存公司事件
class SaveCompanyEvent extends LoginCompanyCompleteEvent {
  // 公司单项标识
  int companyItemIndex;
  // 公司内容值
  String companyContentValue;
  // 保存公司事件
  SaveCompanyEvent(this.companyItemIndex, this.companyContentValue);
}

// 提交按钮点击事件
class SubmitButtonClickEvent extends LoginCompanyCompleteEvent {
  // 提交按钮点击事件
  SubmitButtonClickEvent();
}

class LoginCompanyCompleteBloc
    extends Bloc<LoginCompanyCompleteEvent, LoginCompanyCompleteModel> {
  // 刷新补丁
  LoginCompanyCompleteModel clone(LoginCompanyCompleteModel src) {
    return LoginCompanyCompleteModel.clone(src);
  }

  LoginCompanyCompleteBloc(LoginCompanyCompleteModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 判断登录用户
      if (StoreProvider.of<WMSState>(state.rootContext).state.loginUser ==
          null) {
        // 跳转页面
        GoRouter.of(state.rootContext).go('/login');
        return;
      }
      // 打开加载
      BotToast.showLoading();
      // 查询多语言列表
      List<Map<String, dynamic>> languageList =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageList;
      // 查询公司信息
      List<dynamic> companyList = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq(
              'id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id);
      // 公司数据
      state.companyData = companyList[0];
      // 刷新
      emit(LoginCompanyCompleteModel.clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 选中语言变更事件
    on<SelectedLanguageChangeEvent>((event, emit) async {
      // 切换语言
      CommonUtils.changeLocale(StoreProvider.of<WMSState>(state.rootContext),
          event.selectedLanguageId);
      // 本地存储
      LocalStorage.save(Config.LOCALE, event.selectedLanguageId.toString());
      // 选中语言
      state.selectedLanguage = event.selectedLanguageId;
      // 刷新
      emit(LoginCompanyCompleteModel.clone(state));
      // 关闭弹窗
      Navigator.pop(state.rootContext);
    });

    // 保存公司事件
    on<SaveCompanyEvent>((event, emit) async {
      // 判断公司内容值
      if (event.companyContentValue != '') {
        // 查询公司信息
        List<Map<String, dynamic>> companyList = [];
        // 判断公司单项标识
        if (event.companyItemIndex == Config.NUMBER_ZERO) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'name': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_ONE) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'name_short': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_TWO) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'corporate_cd': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_THREE) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'qrr_cd': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_FOUR) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'postal_cd': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_FIVE) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'addr_1': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_SIX) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'addr_2': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_SEVEN) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'addr_3': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_EIGHT) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'tel': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        } else if (event.companyItemIndex == Config.NUMBER_NINE) {
          // 变更公司信息
          companyList = await SupabaseUtils.getClient()
              .from('mtb_company')
              .update({'email': event.companyContentValue})
              .eq(
                  'id',
                  StoreProvider.of<WMSState>(state.rootContext)
                      .state
                      .loginUser
                      ?.company_id)
              .select('*');
        }
        // 公司数据
        state.companyData = companyList[0];
        // 刷新
        emit(LoginCompanyCompleteModel.clone(state));
      }
    });

    // 提交按钮点击事件
    on<SubmitButtonClickEvent>((event, emit) async {
      // 判断公司情报
      if (state.companyData['name'] == null ||
          state.companyData['name'] == '' ||
          state.companyData['name_short'] == null ||
          state.companyData['name_short'] == '' ||
          state.companyData['corporate_cd'] == null ||
          state.companyData['corporate_cd'] == '' ||
          state.companyData['qrr_cd'] == null ||
          state.companyData['qrr_cd'] == '' ||
          state.companyData['postal_cd'] == null ||
          state.companyData['postal_cd'] == '' ||
          state.companyData['addr_1'] == null ||
          state.companyData['addr_1'] == '' ||
          state.companyData['addr_2'] == null ||
          state.companyData['addr_2'] == '' ||
          state.companyData['addr_3'] == null ||
          state.companyData['addr_3'] == '' ||
          state.companyData['tel'] == null ||
          state.companyData['tel'] == '' ||
          state.companyData['email'] == null ||
          state.companyData['email'] == '') {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_company_complete_submit_error);
      } else {
        // 跳转页面
        GoRouter.of(state.rootContext).go('/');
      }
    });

    add(InitEvent());
  }
}
