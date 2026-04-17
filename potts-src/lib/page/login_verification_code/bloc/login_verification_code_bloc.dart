import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otp/otp.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

import '../../../bloc/wms_common_bloc_utils.dart';
import '../../../common/config/config.dart';
import '../../../common/localization/default_localizations.dart';
import '../../../common/storage/local_storage.dart';
import '../../../common/utils/common_utils.dart';
import '../../../common/utils/mail_utils.dart';
import '../../../common/utils/supabase_untils.dart';
import '../../../redux/wms_state.dart';
import 'login_verification_code_model.dart';

/**
 * 内容：登录验证码-BLOC
 * 作者：赵士淞
 * 时间：2024/12/13
 */
// 事件
abstract class LoginVerificationCodeEvent {}

// 初始化事件
class InitEvent extends LoginVerificationCodeEvent {
  // 初始化事件
  InitEvent();
}

// 选中语言变更事件
class SelectedLanguageChangeEvent extends LoginVerificationCodeEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 设置验证指数事件
class SetVerifyIndexEvent extends LoginVerificationCodeEvent {
  // 值
  int value;
  // 设置验证指数事件
  SetVerifyIndexEvent(this.value);
}

// 发送邮件点击事件
class SendMailClickEvent extends LoginVerificationCodeEvent {
  // 发送邮件点击事件
  SendMailClickEvent();
}

// 设置验证码事件
class SetVerifyCodeEvent extends LoginVerificationCodeEvent {
  // 值
  String value;
  // 设置验证码事件
  SetVerifyCodeEvent(this.value);
}

// 发送按钮点击事件
class SendButtonClickEvent extends LoginVerificationCodeEvent {
  // 发送按钮点击事件
  SendButtonClickEvent();
}

class LoginVerificationCodeBloc
    extends Bloc<LoginVerificationCodeEvent, LoginVerificationCodeModel> {
  // 刷新补丁
  LoginVerificationCodeModel clone(LoginVerificationCodeModel src) {
    return LoginVerificationCodeModel.clone(src);
  }

  LoginVerificationCodeBloc(LoginVerificationCodeModel state) : super(state) {
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
      // 查询用户列表
      List<dynamic> userList = await SupabaseUtils.getClient()
          .from('mtb_user')
          .select('*')
          .eq(
              'id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.id);
      // 用户数据
      state.userData = userList[0];
      // 判断验证Key是否为空
      if (state.userData['authenticator_key'] == null ||
          state.userData['authenticator_key'] == '') {
        // 更新用户列表
        List<Map<String, dynamic>> userList2 = await SupabaseUtils.getClient()
            .from('mtb_user')
            .update({
              'authenticator_key': OTP.randomSecret(),
              'update_id': StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.id,
              'update_time': DateTime.now().toString()
            })
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id)
            .select('*');
        // 用户数据
        state.userData = userList2[0];
      }
      // 查询多语言列表
      List<Map<String, dynamic>> languageList =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageList;
      // 刷新
      emit(LoginVerificationCodeModel.clone(state));
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
      emit(LoginVerificationCodeModel.clone(state));
      // 关闭弹窗
      Navigator.pop(state.rootContext);
    });

    // 设置验证指数事件
    on<SetVerifyIndexEvent>((event, emit) async {
      // 验证指数
      state.verifyIndex = event.value;
      // 刷新
      emit(LoginVerificationCodeModel.clone(state));
    });

    // 发送邮件点击事件
    on<SendMailClickEvent>((event, emit) async {
      // 判断上次发送时间是否在五分钟内
      if (state.userData['send_time'] == null ||
          state.userData['send_time'].toString() == '' ||
          DateTime.now().millisecondsSinceEpoch -
                  DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
                      .parse(state.userData['send_time'])
                      .millisecondsSinceEpoch >=
              1 * 60 * 1000) {
        // 随机数
        var random = Random();
        // 生成匹配验证码
        var randomCode = random.nextInt(900000) + 100000;
        // 更新用户列表
        List<Map<String, dynamic>> userList = await SupabaseUtils.getClient()
            .from('mtb_user')
            .update({
              'send_time': DateTime.now().toString(),
              'mail_code': randomCode,
              'update_id': StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.id,
              'update_time': DateTime.now().toString()
            })
            .eq(
                'id',
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser
                    ?.id)
            .select('*');
        // 用户数据
        state.userData = userList[0];
        // 发送邮件
        String h1 = WMSLocalizations.i18n(state.rootContext)!
            .login_application_mail_send_text_1;
        String p2 = WMSLocalizations.i18n(state.rootContext)!
                .login_application_mail_send_text_2 +
            randomCode.toString();
        String content = '<h2>$h1</h2><p>$p2</p>';
        bool res = await MailUtils.sendEmailWithSMTP(
            state.userData['email'],
            WMSLocalizations.i18n(state.rootContext)!
                .login_application_mail_subject,
            content);
        if (res) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_confirm_text_success);
        } else {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_confirm_text_error);
        }
      } else {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .login_application_verify_tab_2_error_text);
      }
    });

    // 设置验证码事件
    on<SetVerifyCodeEvent>((event, emit) async {
      // 验证码
      state.verifyCode = event.value;
    });

    // 发送按钮点击事件
    on<SendButtonClickEvent>((event, emit) async {
      // 打开加载
      BotToast.showLoading();
      // 判断验证指数
      if (state.verifyIndex == 1) {
        // 生成匹配验证码
        final now = DateTime.now();
        timezone.initializeTimeZones();
        final pacificTimeZone = timezone.getLocation('America/Los_Angeles');
        final date = timezone.TZDateTime.from(now, pacificTimeZone);
        String otpCode = OTP.generateTOTPCodeString(
          state.userData['authenticator_key'],
          date.millisecondsSinceEpoch,
          algorithm: Algorithm.SHA1,
          isGoogle: true,
        );
        // 判断验证码是否一致
        if (state.verifyCode != otpCode) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_application_button_2_error_1);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else if (state.verifyIndex == 2) {
        // 判断验证码是否一致
        if (state.verifyCode != state.userData['mail_code']) {
          // 错误提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!
                  .login_application_button_2_error_1);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      // 判断用户数据
      if (state.userData['role_id'] == Config.ROLE_ID_2) {
        // 查询会社情报
        List<dynamic> mtbCompanyList = await SupabaseUtils.getClient()
            .from('mtb_company')
            .select('*')
            .eq('id', state.userData['company_id']);
        // 判断会社情报内容
        if (mtbCompanyList.length != 1 ||
            mtbCompanyList[0]['name_short'] == null ||
            mtbCompanyList[0]['name_short'] == '' ||
            mtbCompanyList[0]['corporate_cd'] == null ||
            mtbCompanyList[0]['corporate_cd'] == '' ||
            mtbCompanyList[0]['qrr_cd'] == null ||
            mtbCompanyList[0]['qrr_cd'] == '' ||
            mtbCompanyList[0]['postal_cd'] == null ||
            mtbCompanyList[0]['postal_cd'] == '' ||
            mtbCompanyList[0]['addr_1'] == null ||
            mtbCompanyList[0]['addr_1'] == '' ||
            mtbCompanyList[0]['addr_2'] == null ||
            mtbCompanyList[0]['addr_2'] == '' ||
            mtbCompanyList[0]['addr_3'] == null ||
            mtbCompanyList[0]['addr_3'] == '' ||
            mtbCompanyList[0]['tel'] == null ||
            mtbCompanyList[0]['tel'] == '' ||
            mtbCompanyList[0]['email'] == null ||
            mtbCompanyList[0]['email'] == '') {
          // 跳转页面
          GoRouter.of(state.rootContext).go('/loginCompanyComplete');
        } else {
          // 跳转页面
          GoRouter.of(state.rootContext).go('/');
        }
      } else {
        // 跳转页面
        GoRouter.of(state.rootContext).go('/');
      }
      // 关闭加载
      BotToast.closeAllLoading();
    });

    add(InitEvent());
  }
}
