import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/check_utils.dart';
import 'package:wms/common/utils/supabase_untils.dart';
import 'package:wms/redux/wms_state.dart';

import '../../../../common/config/config.dart';
import 'plan_management_model.dart';

/**
 * 内容：计划管理-BLOC
 * 作者：赵士淞
 * 时间：2024/06/27
 */
// 事件
abstract class PlanManagementEvent {}

// 初始化事件
class InitEvent extends PlanManagementEvent {
  // 初始化事件
  InitEvent();
}

// 设置当前菜单下标事件
class SetCurrentMenuIndexEvent extends PlanManagementEvent {
  // 当前菜单下标
  int currentMenuIndex;

  // 设置当前菜单下标事件
  SetCurrentMenuIndexEvent(this.currentMenuIndex);
}

// 设置选中计划下标事件
class SetSelectPlanIndexEvent extends PlanManagementEvent {
  // 选中计划下标
  int selectPlanIndex;
  // 选中计划名称
  String selectPlanName;

  // 设置选中计划下标事件
  SetSelectPlanIndexEvent(this.selectPlanIndex, this.selectPlanName);
}

// 删除计划事件
class DeletePlanEvent extends PlanManagementEvent {
  // 删除计划事件
  DeletePlanEvent();
}

// 详细计划事件
class DetailPlanEvent extends PlanManagementEvent {
  // 选中计划下标
  int selectPlanIndex;
  // 选中计划
  Map<String, dynamic> selectPlan;

  // 详细计划事件
  DetailPlanEvent(this.selectPlanIndex, this.selectPlan);
}

// 设置新增值事件
class SetAddItemValueEvent extends PlanManagementEvent {
  // 项目名
  String itemName;
  // 值
  String value;

  // 设置新增值事件
  SetAddItemValueEvent(this.itemName, this.value);
}

// 关闭变更弹窗事件
class CloseChangeDialogEvent extends PlanManagementEvent {
  // 上下文
  BuildContext context;

  // 关闭变更弹窗事件
  CloseChangeDialogEvent(this.context);
}

// 设置弹窗临时值事件
class SetDialogTempValueEvent extends PlanManagementEvent {
  // 值
  String value;

  // 设置弹窗临时值事件
  SetDialogTempValueEvent(this.value);
}

// 变更计划事件
class ChangePlanEvent extends PlanManagementEvent {
  // 上下文
  BuildContext context;
  // 变更字段
  String itemName;
  // 变更计划事件
  ChangePlanEvent(this.context, this.itemName);
}

// 创建计划事件
class AddPlanEvent extends PlanManagementEvent {
  // 上下文
  BuildContext context;
  // 创建计划事件
  AddPlanEvent(this.context);
}

class PlanManagementBloc
    extends Bloc<PlanManagementEvent, PlanManagementModel> {
  // 刷新补丁
  PlanManagementModel clone(PlanManagementModel src) {
    return PlanManagementModel.clone(src);
  }

  PlanManagementBloc(PlanManagementModel state) : super(state) {
    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      // 查询计划列表
      List<dynamic> planList = await SupabaseUtils.getClient()
          .from('ytb_plan')
          .select('*')
          .eq('del_kbn', Config.DELETE_NO)
          .order('id', ascending: true);
      // 计划列表
      state.planList =
          planList.map((item) => item as Map<String, dynamic>).toList();
      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 设置当前菜单下标事件
    on<SetCurrentMenuIndexEvent>((event, emit) async {
      // 当前菜单下标
      state.currentMenuIndex = event.currentMenuIndex;
      // 详情页面标记
      state.detailPageSign = Config.NUMBER_NEGATIVE;

      // // 更新
      // emit(clone(state));
      add(InitEvent());
    });

    // 设置选中计划下标事件
    on<SetSelectPlanIndexEvent>((event, emit) async {
      // 选中计划下标
      state.selectPlanIndex = event.selectPlanIndex;
      // 选中计划名称
      state.selectPlanName = event.selectPlanName;
      // 更新
      emit(clone(state));
    });

    // 删除计划事件
    on<DeletePlanEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();
      if (state.selectPlanIndex == -1) {
        // 错误提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!
                .Inventory_Confirmed_tip_1);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      try {
        // 删除计划
        List<Map<String, dynamic>> planData = await SupabaseUtils.getClient()
            .from('ytb_plan')
            .update({'del_kbn': Config.DELETE_YES})
            .eq('id', state.selectPlanIndex)
            .select('*');
        // 判断计划数据
        if (planData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.plan_content_text_20 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.plan_content_text_20 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.plan_content_text_20 +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      add(InitEvent());
    });

    // 详细计划事件
    on<DetailPlanEvent>((event, emit) async {
      // 选中计划下标
      state.selectPlanIndex = event.selectPlanIndex;
      // 选中计划
      if (state.selectPlanIndex != Config.NUMBER_NEGATIVE) {
        state.selectPlan = event.selectPlan;
        // 详情页面标记
        state.detailPageSign = Config.NUMBER_ONE;
      } else {
        state.selectPlan = {};
        // 详情页面标记
        state.detailPageSign = Config.NUMBER_ZERO;
      }

      // 更新
      emit(clone(state));
    });

    // 设置新增值事件
    on<SetAddItemValueEvent>((event, emit) async {
      state.selectPlan[event.itemName] = event.value;
      // 更新
      emit(clone(state));
    });

    // 关闭变更弹窗事件
    on<CloseChangeDialogEvent>((event, emit) async {
      // 关闭变更弹窗
      closeChangeDialog(state, event.context);

      // 更新
      emit(clone(state));
    });

    // 设置弹窗临时值事件
    on<SetDialogTempValueEvent>((event, emit) async {
      // 弹窗临时值
      state.dialogTempValue = event.value;
      // 更新
      emit(clone(state));
    });

    // 变更方案事件
    on<ChangePlanEvent>((event, emit) async {
      // 变更验证
      bool flag = changePlanCheck(state, event.itemName);
      // 判断验证结果
      if (flag) {
        // 打开加载状态
        BotToast.showLoading();

        // 变更方案
        await SupabaseUtils.getClient().from('ytb_plan').update({
          event.itemName:
              state.dialogTempValue == '' ? null : state.dialogTempValue
        }).eq('id', state.selectPlanIndex);
        // 更新选中数据
        state.selectPlan[event.itemName] = state.dialogTempValue;
        // 关闭变更弹窗
        closeChangeDialog(state, event.context);
        // 更新
        emit(clone(state));
        // 关闭加载
        BotToast.closeAllLoading();
      }
    });

    // 创建计划事件
    on<AddPlanEvent>((event, emit) async {
      //check必须输入项目
      bool checkResult = checkMustInputColumn(state.selectPlan, event.context);
      // 判断验证结果
      if (!checkResult) {
        return;
      }
      //model用map做成
      Map<String, dynamic> formInfo = changePlanMap(state.selectPlan);
      // 方案数据
      List<Map<String, dynamic>> formData;

      formInfo['del_kbn'] = '2';
      formInfo['create_id'] =
          StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
      formInfo['create_time'] = DateTime.now().toString();
      formInfo['update_id'] =
          StoreProvider.of<WMSState>(event.context).state.loginUser?.id;
      formInfo['update_time'] = DateTime.now().toString();
      try {
        BotToast.showLoading();
        // 新增方案
        formData = await SupabaseUtils.getClient()
            .from('ytb_plan')
            .insert([formInfo]).select('*');
        // 判断方案数据
        if (formData.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(event.context)!.plan_content_text_20 +
                  WMSLocalizations.i18n(event.context)!.create_success);
          // 详情页面标记
          state.detailPageSign = Config.NUMBER_NEGATIVE;
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(event.context)!.plan_content_text_20 +
                  WMSLocalizations.i18n(event.context)!.create_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(event.context)!.plan_content_text_20 +
                WMSLocalizations.i18n(event.context)!.create_error);

        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }
      add(InitEvent());
    });

    add(InitEvent());
  }

  //model用map做成
  Map<String, dynamic> changePlanMap(Map<String, dynamic> selectPlan) {
    Map<String, dynamic> result = selectPlan;
    // 处理-结构
    if (result['id'] == null || result['id'] == '') {
      result.remove('id');
    } else {
      result['id'] = int.parse(result['id'].toString());
    }
    if (result['db_capacity'] == null || result['db_capacity'] == '') {
      result.remove('db_capacity');
    } else {
      result['db_capacity'] = double.parse(result['db_capacity'].toString());
    }
    if (result['db_dl'] == null || result['db_dl'] == '') {
      result.remove('db_dl');
    } else {
      result['db_dl'] = double.parse(result['db_dl'].toString());
    }
    if (result['storage'] == null || result['storage'] == '') {
      result.remove('storage');
    } else {
      result['storage'] = double.parse(result['storage'].toString());
    }
    if (result['storage_dl'] == null || result['storage_dl'] == '') {
      result.remove('storage_dl');
    } else {
      result['storage_dl'] = double.parse(result['storage_dl'].toString());
    }
    if (result['plan_amount'] == null || result['plan_amount'] == '') {
      result.remove('plan_amount');
    } else {
      result['plan_amount'] = double.parse(result['plan_amount'].toString());
    }
    return result;
  }

  // 关闭变更弹窗
  void closeChangeDialog(PlanManagementModel state, BuildContext context) {
    // 弹窗临时值
    state.dialogTempValue = '';
    // 关闭弹窗
    Navigator.pop(context);
  }

  // 变更验证
  bool changePlanCheck(PlanManagementModel state, String itemName) {
    // 判断是否为空
    if (state.dialogTempValue == '' &&
        (itemName == 'plan_name' || itemName == 'plan_amount')) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.plan_content_text_26 +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      return false;
    }

    // 返回
    return true;
  }

  //check必须输入项目
  bool checkMustInputColumn(
      Map<String, dynamic> selectPlan, BuildContext context) {
    print(selectPlan);
    if (selectPlan['plan_name'] == null || selectPlan['plan_name'] == '') {
      //プラン名
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_21 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (selectPlan['plan_amount'] == null ||
        selectPlan['plan_amount'] == '') {
      //プラン金額
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_22 +
              WMSLocalizations.i18n(context)!.can_not_null_text);
      return false;
    } else if (selectPlan['db_capacity'] != null &&
        selectPlan['db_capacity'] != '' &&
        CheckUtils.check_Half_Number(selectPlan['db_capacity'])) {
      //DB容量
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_15 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers);
      return false;
    } else if (selectPlan['storage'] != null &&
        selectPlan['storage'] != '' &&
        CheckUtils.check_Half_Number(selectPlan['storage'])) {
      //ストレージ
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_16 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers);
      return false;
    } else if (selectPlan['db_dl'] != null &&
        selectPlan['db_dl'] != '' &&
        CheckUtils.check_Half_Number(selectPlan['db_dl'])) {
      //DBDL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_17 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers);
      return false;
    } else if (selectPlan['storage_dl'] != null &&
        selectPlan['storage_dl'] != '' &&
        CheckUtils.check_Half_Number(selectPlan['storage_dl'])) {
      //ストレージDL
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_18 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers);
      return false;
    } else if (CheckUtils.check_Half_Number(selectPlan['plan_amount'])) {
      //プラン金額  半角数字
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.plan_content_text_22 +
              WMSLocalizations.i18n(context)!.check_half_width_numbers);
      return false;
    }
    return true;
  }
}
