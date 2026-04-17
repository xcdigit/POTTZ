import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/check_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../model/base_info.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'information_management_model.dart';

/**
 * 内容：運用基本情報管理-BLOC
 * 作者：王光顺
 * 时间：2023/09/12
 */
// 事件
abstract class InformationManagementEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends InformationManagementEvent {
  // 初始化事件
  InitEvent();
}

// 设置更新数据
class SetInformationValueEvent extends InformationManagementEvent {
  String key;
  String value;
  SetInformationValueEvent(this.key, this.value);
}

// 更新表
class UpdataInformEvent extends InformationManagementEvent {
  // 结构树
  BuildContext context;
  // 初始化事件
  UpdataInformEvent(this.context);
}

// 自定义事件 - 终

class InformationManagementBloc
    extends WmsTableBloc<InformationManagementModel> {
  // 刷新补丁
  @override
  InformationManagementModel clone(InformationManagementModel src) {
    return InformationManagementModel.clone(
      src,
    );
  }

  InformationManagementBloc(InformationManagementModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询運用基本情報明细
      List<dynamic> DetailData =
          await SupabaseUtils.getClient().from('ytb_base_info').select('*');
      if (DetailData.length > 0) {
        state.customerList = (DetailData[0]);
      }
      // 刷新补丁
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
      // 查询分页数据事件
    });
    // 设置更新数据
    on<SetInformationValueEvent>((event, emit) async {
      // 情报-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.customerList);
      // 判断key
      if (formTemp[event.key] != null) {
        // 情报-临时
        formTemp[event.key] = event.value;
      } else {
        // 情报-临时
        formTemp.addAll({event.key: event.value});
      }
      // 情报-定制
      state.customerList = formTemp;

      // 更新
      emit(clone(state));
    });

    // 更新表
    on<UpdataInformEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading(); // 刷新补丁
      bool check = checkMustInputColumn(state.customerList, event.context);
      if (!check) {
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      //model用map做成
      Map<String, dynamic> formInfo = changeMap(state.customerList);
      // 仓库master数据
      List<Map<String, dynamic>> formData;
      BaseInfo baseInfo = BaseInfo.fromJson(formInfo);
      if (state.customerList['id'] == null) {
        //填入必须字段
        baseInfo.create_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        baseInfo.create_time = DateTime.now().toString();
        baseInfo.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        baseInfo.update_time = DateTime.now().toString();
        try {
          BotToast.showLoading();
          // 新增菜单
          formData = await SupabaseUtils.getClient()
              .from('ytb_base_info')
              .insert([baseInfo.toJson()]).select('*');
          // 判断菜单数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_99_2 +
                    WMSLocalizations.i18n(event.context)!.create_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_99_2 +
                    WMSLocalizations.i18n(event.context)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_99_2 +
                  WMSLocalizations.i18n(event.context)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        //修正的场合
        //更新者更新时间
        baseInfo.update_id =
            StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
        baseInfo.update_time = DateTime.now().toString();
        try {
          // 开启加载
          BotToast.showLoading();
          // 修改菜单情报
          formData = await SupabaseUtils.getClient()
              .from('ytb_base_info')
              .update(baseInfo.toJson())
              .eq('id', baseInfo.id)
              .select('*');
          // 判断菜单数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_99_2 +
                    WMSLocalizations.i18n(event.context)!.update_success);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(event.context)!.menu_content_99_2 +
                    WMSLocalizations.i18n(event.context)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.menu_content_99_2 +
                  WMSLocalizations.i18n(event.context)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }
      //刷新画面
      add(InitEvent());
    });
    add(InitEvent());
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> customerList, BuildContext context) {
    if (customerList['name'] == null || customerList['name'] == '') {
      //会社名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_2 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }
    if (customerList['corporate_cd'] != null &&
        customerList['corporate_cd'] != '' &&
        CheckUtils.check_Half_Number_13(customerList['corporate_cd'])) {
      // 法人番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_4 +
              WMSLocalizations.i18n(context)!.company_check_2);
      return false;
    }
    if (customerList['qrr_cd'] != null &&
        customerList['qrr_cd'] != '' &&
        CheckUtils.check_Half_Alphanumeric(customerList['qrr_cd'])) {
      // 適格請求登録番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_5 +
              WMSLocalizations.i18n(context)!.check_half_width_alphanumeric);
      return false;
    }
    if (customerList['postal_cd'] != null &&
        customerList['postal_cd'] != '' &&
        CheckUtils.check_Postal(customerList['postal_cd'])) {
      // 郵便番号
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.company_information_6 +
              WMSLocalizations.i18n(context)!.check_postal);
      return false;
    }
    if (customerList['tel'] != null &&
        customerList['tel'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(customerList['tel'])) {
      // 電話番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_10 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    }
    if (customerList['fax'] != null &&
        customerList['fax'] != '' &&
        CheckUtils.check_Half_Number_Hyphen(customerList['fax'])) {
      // FAX番号
      WMSCommonBlocUtils.tipTextToast(WMSLocalizations.i18n(context)!
              .company_information_11 +
          WMSLocalizations.i18n(context)!.check_half_width_numbers_with_hyphen);
      return false;
    }
    if (customerList['email'] != null &&
        customerList['email'] != '' &&
        CheckUtils.check_Email(customerList['email'])) {
      // 自動応答用メール
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.information_management_1 +
              WMSLocalizations.i18n(context)!.check_email);
      return false;
    }
    if (customerList['free_time'] == null || customerList['free_time'] == '') {
      //会社名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.information_management_3 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    }

    return true;
  }

  //model用map做成
  Map<String, dynamic> changeMap(Map<String, dynamic> formInfo) {
    Map<String, dynamic> result = formInfo;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    return result;
  }
}
