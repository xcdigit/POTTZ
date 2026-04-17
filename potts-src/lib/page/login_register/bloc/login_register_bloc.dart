import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/storage/local_storage.dart';
import 'package:wms/common/utils/common_utils.dart';
import 'package:wms/common/utils/encryption_utils.dart';
import 'package:wms/common/utils/stripe_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/file/wms_common_file.dart';
import 'package:wms/model/application_tmp.dart';
import 'package:wms/page/login_register/bloc/login_register_model.dart';
import 'package:wms/redux/wms_state.dart';
import 'package:intl/intl.dart';

import '../../../common/utils/check_utils.dart';

/**
 * 内容：申込 -bloc
 * 作者：cuihr
 * 时间：2023/12/06 
 * 
 * 废止 2025/02/20
 */
abstract class LoginRegisterEvent {}

class InitEvent extends LoginRegisterEvent {
  // 初始化事件
  InitEvent();
}

class SelectedLanguageChangeEvent extends LoginRegisterEvent {
  // 选中语言ID
  int selectedLanguageId;
  // 选中语言变更事件
  SelectedLanguageChangeEvent(this.selectedLanguageId);
}

// 设定表单情报值事件
class SetRegisterValueEvent extends LoginRegisterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定值事件
  SetRegisterValueEvent(this.key, this.value);
}

//点击选择按钮改变表格列颜色
class SetTableSelectEvent extends LoginRegisterEvent {
  // 选中行
  String key;
  dynamic value;
  // 选中事件
  SetTableSelectEvent(this.key, this.value);
}

//插入申込管理
class insertTmpEvent extends LoginRegisterEvent {
  // 选中行
  String key;
  BuildContext context;
  // 选中事件
  insertTmpEvent(this.key, this.context);
}

class LoginRegisterBLoc extends Bloc<LoginRegisterEvent, LoginRegisterModel> {
  LoginRegisterBLoc(LoginRegisterModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      BotToast.showLoading();
      // 查询多语言信息
      List<Map<String, dynamic>> languageData =
          await SupabaseUtils.getClient().from('mtb_language').select('*');
      // 多语言列表
      state.languageList = languageData;

      state.languageFormList = [];
      if (languageData.length > 0) {
        for (int i = 0; i < languageData.length; i++) {
          state.languageFormList.add({
            'id': languageData[i]['id'].toString(),
            'name': languageData[i]['name']
          });
        }
      }
      //ライセンス情報取得
      String nowDate = DateFormat('yyyy/MM/dd').format(DateTime.now());
      List<dynamic> userTypeData = await SupabaseUtils.getClient()
          .from('ytb_use_type')
          .select('*')
          .eq('role_id', Config.ROLE_ID_2)
          .lte('start_date', nowDate)
          .gte('end_date', nowDate)
          .order('id', ascending: false);
      List<Map<String, dynamic>> userTypeList = [];
      for (var i = 0; i < userTypeData.length; i++) {
        userTypeList.add(userTypeData[i]);
      }
      state.useTypeTableList = userTypeList;

      //获取超级管理员邮箱
      if (Config.ADMIN_EMAIL != '') {
        state.superAdminEmail = Config.ADMIN_EMAIL;
      } else {
        List<dynamic> adminData = await SupabaseUtils.getClient()
            .from('mtb_user')
            .select('*')
            .eq('role_id', Config.ROLE_ID_1);
        if (adminData.length > 0) {
          state.superAdminEmail = adminData[0]['email'];
        }
      }
      initForm(state);
      // 更新
      emit(LoginRegisterModel.copy(state));
      // 关闭加载状态
      BotToast.closeAllLoading();
    });

    // 设定表单情报值事件
    on<SetRegisterValueEvent>(
      (event, emit) async {
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

        //如果更新的是写真
        if (event.key == 'user_avatar') {
          state.image1Network =
              await WMSCommonFile().previewImageFile(event.value);
        }
        // 更新
        emit(LoginRegisterModel.copy(state));
      },
    );

    // 选中语言变更事件
    on<SelectedLanguageChangeEvent>((event, emit) async {
      // 切换语言
      CommonUtils.changeLocale(
          StoreProvider.of<WMSState>(state.context), event.selectedLanguageId);
      // 本地存储
      LocalStorage.save(Config.LOCALE, event.selectedLanguageId.toString());
      // 选中语言
      state.selectedLanguage = event.selectedLanguageId;
      // 刷新
      emit(LoginRegisterModel.copy(state));
      // 关闭弹窗
      Navigator.pop(state.context);
    });
    //点击选择按钮改变表格列颜色
    on<SetTableSelectEvent>(
      (event, emit) {
        state.selected = event.key;
        state.appTmpMap = event.value;
        emit(LoginRegisterModel.copy(state));
      },
    );
    //插入表
    on<insertTmpEvent>(
      (event, emit) async {
        //跳转支付页面 并返回 オーダー番号
        String? orderNo = await StripeUtils.createCheckoutSessions(
            event.context, state.appTmpMap['id'], 1);
        //model用map做成
        Map<String, dynamic> formInfo = changeTmpMap(state.formInfo);
        // 申込管理数据
        List<Map<String, dynamic>> formData;

        ApplicationTmp tmp = ApplicationTmp.fromJson(formInfo);

        if (tmp.id == null) {
          String password = '';
          //对输入的密码进行加密
          password = Encryption.encodeBase64(state.formInfo['user_password']);
          tmp.user_password = password;
          tmp.create_time = DateTime.now().toString();
          tmp.update_time = DateTime.now().toString();
          tmp.create_id = 1;
          tmp.update_id = 1;
          //支払状態(0：未支払、１：支払済み)
          tmp.pay_status = '0';
          tmp.application_status = '0';
          tmp.use_type_id = state.appTmpMap['id'];
          tmp.expiration_day = state.appTmpMap['expiration_day'];
          tmp.expiration_month = state.appTmpMap['expiration_month'];
          tmp.expiration_year = state.appTmpMap['expiration_year'];
          tmp.pay_no = orderNo;
          tmp.pay_total = state.appTmpMap['amount'];
          try {
            BotToast.showLoading();
            formData = await SupabaseUtils.getClient()
                .from('ytb_application_tmp')
                .insert([tmp.toJson()]).select('*');
            if (formData.length != 0) {
              // 成功提示
              WMSCommonBlocUtils.successTextToast(
                  WMSLocalizations.i18n(event.context)!.register_sub_success);
            } else {
              // 失败提示
              WMSCommonBlocUtils.errorTextToast(
                  WMSLocalizations.i18n(event.context)!.register_sub_error);
              // 关闭加载
              BotToast.closeAllLoading();
            }
          } catch (e) {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.register_sub_error);
            // 关闭加载
            BotToast.closeAllLoading();
          }
        }
        // 关闭加载状态
        BotToast.closeAllLoading();

        initForm(state);

        // 更新
        emit(LoginRegisterModel.copy(state));
      },
    );
    add(InitEvent());
  }
  //model用map做成
  Map<String, dynamic> changeTmpMap(Map<String, dynamic> formInfo) {
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
  void initForm(LoginRegisterModel state) {
    // 初期化
    state.formInfo = {
      'id': '',
      'user_email': '',
      'user_password': '',
      'user_name': '',
      'user_phone': '',
      'user_language_id': null,
      'user_language_name': '',
      'user_avatar': '',
      'company_name': '',
      'company_name_short': '',
      'company_corporate_cd': '',
      'company_qrr_cd': '',
      'company_postal_cd': '',
      'company_addr_1': '',
      'company_addr_2': '',
      'company_addr_3': '',
      'company_tel': '',
      'company_fax': '',
      'company_url': '',
      'company_email': '',
      'use_type_id': null,
      'pay_status': '',
      'pay_total': null,
      'pay_no': '',
      'expiration_year': null,
      'expiration_month': null,
      'expiration_day': null,
      'application_status': null,
    };
    //状态初期化
    state.selected = '';
    state.image1Network = '';
  }

  //表单必入力
  Future<bool> selectRegisterCheck(
      BuildContext context, LoginRegisterModel state) async {
    if (state.formInfo['user_email'] == null ||
        state.formInfo['user_email'] == '') {
      //Email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_user_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(state.formInfo['user_email'])) {
      //Email
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_user_1 +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    } else if (state.formInfo['user_password'] == null ||
        state.formInfo['user_password'] == '') {
      // パスワード
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.account_security_password +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['user_name'] == null ||
        state.formInfo['user_name'] == '') {
      //ユーザー名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.message_master_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['user_phone'] == null ||
        state.formInfo['user_phone'] == '') {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_10 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(
        state.formInfo['user_phone'])) {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_10 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (state.formInfo['user_language_id'] == null ||
        state.formInfo['user_language_id'] == '') {
      //言語
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_user_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.image1Network == '') {
      //头像
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_user_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['company_name'] == null ||
        state.formInfo['company_name'] == '') {
      //会社名名称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_company_1 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['company_name_short'] == null ||
        state.formInfo['company_name_short'] == '') {
      //会社名略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_company_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_AZ4(state.formInfo['company_name_short'])) {
      //会社名略称
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_company_2 +
              WMSLocalizations.i18n(context)!.company_check_1);
      return false;
    } else if (state.formInfo['company_corporate_cd'] == null ||
        state.formInfo['company_corporate_cd'] == '') {
      //法人番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_13(
        state.formInfo['company_corporate_cd'])) {
      //法人番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_4 +
              WMSLocalizations.i18n(context)!.company_check_2);
      return false;
    } else if (state.formInfo['company_qrr_cd'] == null ||
        state.formInfo['company_qrr_cd'] == '') {
      //適格請求登録番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_5 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Alphanumeric(
        state.formInfo['company_qrr_cd'])) {
      //適格請求登録番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_5 +
              WMSLocalizations.i18n(context)!.check_half_width_alphanumeric);
      return false;
    } else if (state.formInfo['company_postal_cd'] == null ||
        state.formInfo['company_postal_cd'] == '') {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_6 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Postal(state.formInfo['company_postal_cd'])) {
      //郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_6 +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    } else if (state.formInfo['company_addr_1'] == null ||
        state.formInfo['company_addr_1'] == '') {
      //都道府県
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_7 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['company_addr_2'] == null ||
        state.formInfo['company_addr_2'] == '') {
      //市区町村
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_8 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['company_addr_3'] == null ||
        state.formInfo['company_addr_3'] == '') {
      //住所
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_9 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (state.formInfo['company_tel'] == null ||
        state.formInfo['company_tel'] == '') {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_user_4 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Half_Number_Hyphen(
        state.formInfo['company_tel'])) {
      //電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .register_user_4 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (state.formInfo['company_fax'] != null &&
        state.formInfo['company_fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(state.formInfo['company_fax'])) {
      //FAX番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .register_company_6 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    } else if (state.formInfo['company_email'] == null ||
        state.formInfo['company_email'] == '') {
      //E-MAIL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_13 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (CheckUtils.check_Email(state.formInfo['company_email'])) {
      //E-MAIL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_13 +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    }

    if (state.appTmpMap.isEmpty) {
      //ライセンスの種類
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.register_choose_type);
      return false;
    }
    if (state.formInfo['user_email'] != null ||
        state.formInfo['user_email'] != '') {
      // 查询多语言信息
      List<dynamic> tmp = await SupabaseUtils.getClient()
          .from('ytb_application_tmp')
          .select('*')
          .eq('user_email', state.formInfo['user_email']);
      if (tmp.length > 0) {
        //郵便番号
        WMSCommonBlocUtils.tipTextToast(
            WMSLocalizations.i18n(context)!.register_error_1);
        return false;
      } else {
        return true;
      }
    }
    return true;
  }
}
