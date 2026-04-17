import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/utils/common_utils.dart';
import '../../../../common/utils/supabase_untils.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../model/form.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/table/bloc/wms_record_model.dart';
import '../../../../widget/table/bloc/wms_table_bloc.dart';
import 'form_master_model.dart';

/**
 * 内容：帳票マスタ-BLOC
 * 作者：赵士淞
 * 时间：2023/12/22
 */
// 事件
abstract class FormMasterEvent extends TableListEvent {}

// 初始化事件
class InitEvent extends FormMasterEvent {
  // 初始化事件
  InitEvent();
}

// 自定义事件 - 始
// 设定账票值事件
class SetFormValueEvent extends FormMasterEvent {
  // Key
  String key;
  // Value
  dynamic value;
  // 设定账票值事件
  SetFormValueEvent(this.key, this.value);
}

// 清除账票定制事件
class CleanFormCustomizeEvent extends FormMasterEvent {
  // 清除账票定制事件
  CleanFormCustomizeEvent();
}

// 保存账票定制事件
class SaveFormCustomizeEvent extends FormMasterEvent {
  // 保存账票定制事件
  SaveFormCustomizeEvent();
}

// 查询账票定制事件
class QueryFormCustomizeEvent extends FormMasterEvent {
  // 账票定制ID
  int formCustomizeId;
  // 查询账票定制事件
  QueryFormCustomizeEvent(this.formCustomizeId);
}

// 删除账票定制事件
class DeleteFormCustomizeEvent extends FormMasterEvent {
  // 账票定制ID
  int formCustomizeId;
  // 删除账票定制事件
  DeleteFormCustomizeEvent(this.formCustomizeId);
}
// 自定义事件 - 终

class FormMasterBloc extends WmsTableBloc<FormMasterModel> {
  // 刷新补丁
  @override
  FormMasterModel clone(FormMasterModel src) {
    return FormMasterModel.clone(src);
  }

  FormMasterBloc(FormMasterModel state) : super(state) {
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

      // 查询账票管理
      List<dynamic> data1 = await SupabaseUtils.getClient()
          .from('mtb_form')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id)
          .order('id', ascending: false)
          .range(state.pageNum * state.pageSize,
              (state.pageNum + 1) * state.pageSize - 1);
      // 列表数据清空
      state.records.clear();
      // 循环账票数据
      for (int i = 0; i < data1.length; i++) {
        // 数据详情
        dynamic dataItem = data1[i];

        // 判断区分
        if (dataItem['form_kbn'] != null && dataItem['form_kbn'] != '') {
          // 循环区分列表
          for (int i = 0; i < state.formKbnList.length; i++) {
            // 区分临时
            Map<String, dynamic> formKbnTemp = state.formKbnList[i];
            // 判断值
            if (formKbnTemp['index'] == dataItem['form_kbn']) {
              // 区分文本
              dataItem['form_kbn_title'] = formKbnTemp['title'];
            }
          }
        }
        // 判断纸张方向
        if (dataItem['form_direction'] != null &&
            dataItem['form_direction'] != '') {
          // 循环纸张方向列表
          for (int i = 0; i < state.formDirectionList.length; i++) {
            // 纸张方向临时
            Map<String, dynamic> formDirectionTemp = state.formDirectionList[i];
            // 判断值
            if (formDirectionTemp['index'] == dataItem['form_direction']) {
              // 纸张方向文本
              dataItem['form_direction_title'] = formDirectionTemp['title'];
            }
          }
        }

        // 列表数据增加
        state.records.add(WmsRecordModel(i, dataItem));
      }

      // 查询账票管理
      List<dynamic> data2 = await SupabaseUtils.getClient()
          .from('mtb_form')
          .select('*')
          .eq(
              'company_id',
              StoreProvider.of<WMSState>(state.rootContext)
                  .state
                  .loginUser
                  ?.company_id);
      // 总页数
      state.total = data2.length;

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 初始化事件
    on<InitEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 自定义事件 - 始
      // 区分列表
      state.formKbnList = [
        {
          'index': Config.NUMBER_ONE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!.menu_content_3_21,
        },
        {
          'index': Config.NUMBER_TWO.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!.menu_content_3_8,
        },
        {
          'index': Config.NUMBER_THREE.toString(),
          'title': WMSLocalizations.i18n(state.rootContext)!
              .inquiry_schedule_print_receivelist,
        },
      ];

      // 纸张方向
      state.formDirectionList = [
        {
          'index': Config.NUMBER_ONE.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_paper_transverse,
        },
        {
          'index': Config.NUMBER_TWO.toString(),
          'title':
              WMSLocalizations.i18n(state.rootContext)!.form_paper_direction,
        },
      ];
      // 自定义事件 - 终

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 自定义事件 - 始
    // 设定账票值事件
    on<SetFormValueEvent>((event, emit) async {
      // 账票-临时
      Map<String, dynamic> formTemp = Map<String, dynamic>();
      formTemp.addAll(state.formCustomize);
      // 判断key
      if (formTemp[event.key] != null) {
        // 账票-临时
        formTemp[event.key] = event.value;
      } else {
        // 账票-临时
        formTemp.addAll({event.key: event.value});
      }
      // 账票-定制
      state.formCustomize = formTemp;

      // 判断key
      if (event.key == 'form_kbn') {
        // 循环区分列表
        for (int i = 0; i < state.formKbnList.length; i++) {
          // 区分临时
          Map<String, dynamic> formKbnTemp = state.formKbnList[i];
          // 判断值
          if (formKbnTemp['index'] == event.value) {
            // 区分文本
            state.formCustomize['form_kbn_title'] = formKbnTemp['title'];
          }
        }
      } else if (event.key == 'form_direction') {
        // 循环纸张方向列表
        for (int i = 0; i < state.formDirectionList.length; i++) {
          // 纸张方向临时
          Map<String, dynamic> formDirectionTemp = state.formDirectionList[i];
          // 判断值
          if (formDirectionTemp['index'] == event.value) {
            // 纸张方向文本
            state.formCustomize['form_direction_title'] =
                formDirectionTemp['title'];
          }
        }
      } else if (event.key == 'form_picture') {
        // 会社图标线上路径
        state.formCustomize['form_picture_network'] =
            await WMSCommonFile().previewImageFile(event.value);
      }

      // 更新
      emit(clone(state));
    });

    // 清除账票定制事件
    on<CleanFormCustomizeEvent>((event, emit) async {
      // 账票-定制
      state.formCustomize = {
        'id': '',
        'form_kbn': '',
        'form_kbn_title': '',
        'form_picture': '',
        'form_picture_network': '',
        'form_direction_title': '',
        'form_direction': '',
        'description': '',
      };

      // 更新
      emit(clone(state));
    });

    // 保存账票定制事件
    on<SaveFormCustomizeEvent>((event, emit) async {
      // 保存账票定制验证
      Map<String, dynamic> formStructure =
          saveFormCustomizeCheck(state.formCustomize);
      // 判断验证结果
      if (formStructure.length == 0) {
        return;
      }

      // 打开加载状态
      BotToast.showLoading();

      // 账票数据
      List<Map<String, dynamic>> formData;
      // 账票
      Form form = Form.fromJson(formStructure);

      // 判断账票ID
      if (form.id == null) {
        // 创建账票定制处理
        form = await createFormCustomizeHandle(form);
        // 判断处理结果
        if (form.create_id == null || form.create_id == '') {
          return;
        }

        try {
          // 新增账票
          formData = await SupabaseUtils.getClient()
              .from('mtb_form')
              .insert([form.toJson()]).select('*');
          // 判断账票数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                    WMSLocalizations.i18n(state.rootContext)!.create_success);

            // 账票-定制
            state.formCustomize = {
              'id': '',
              'form_kbn': '',
              'form_kbn_title': '',
              'form_picture': '',
              'form_picture_network': '',
              'form_direction_title': '',
              'form_direction': '',
              'description': '',
            };

            // 插入操作履历
            CommonUtils().createLogInfo(
                '帳票マスタ（ID：' +
                    formData[0]['id'].toString() +
                    '）' +
                    Config.OPERATION_TEXT1 +
                    Config.OPERATION_BUTTON_TEXT1 +
                    Config.OPERATION_TEXT2,
                "SaveFormCustomizeEvent()",
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .company_id,
                StoreProvider.of<WMSState>(state.rootContext)
                    .state
                    .loginUser!
                    .id);
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                    WMSLocalizations.i18n(state.rootContext)!.create_error);

            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                  WMSLocalizations.i18n(state.rootContext)!.create_error);

          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } else {
        // 更新账票定制处理
        form = updateFormCustomizeHandle(form);
        // 判断处理结果
        if (form.update_id == null || form.update_id == '') {
          return;
        }

        try {
          // 修改账票
          formData = await SupabaseUtils.getClient()
              .from('mtb_form')
              .update(form.toJson())
              .eq('id', form.id)
              .select('*');
          // 判断账票数据
          if (formData.length != 0) {
            // 成功提示
            WMSCommonBlocUtils.successTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                    WMSLocalizations.i18n(state.rootContext)!.update_success);

            // 账票-定制
            state.formCustomize = {
              'id': '',
              'form_kbn': '',
              'form_kbn_title': '',
              'form_picture': '',
              'form_picture_network': '',
              'form_direction_title': '',
              'form_direction': '',
              'description': '',
            };
          } else {
            // 失败提示
            WMSCommonBlocUtils.errorTextToast(
                WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                    WMSLocalizations.i18n(state.rootContext)!.update_error);
            // 关闭加载
            BotToast.closeAllLoading();
            return;
          }
        } catch (e) {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                  WMSLocalizations.i18n(state.rootContext)!.update_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      }

      // 返回上一页
      GoRouter.of(state.rootContext).pop('refresh return');

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });

    // 查询账票定制事件
    on<QueryFormCustomizeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      // 查询账票管理
      List<dynamic> data = await SupabaseUtils.getClient()
          .from('mtb_form')
          .select('*')
          .eq('id', event.formCustomizeId);
      // 判断账票数量
      if (data.length != 0) {
        // 账票-定制
        state.formCustomize = data[0];
        // 判断区分
        if (state.formCustomize['form_kbn'] != null &&
            state.formCustomize['form_kbn'] != '') {
          // 循环区分列表
          for (int i = 0; i < state.formKbnList.length; i++) {
            // 区分临时
            Map<String, dynamic> formKbnTemp = state.formKbnList[i];
            // 判断值
            if (formKbnTemp['index'] == state.formCustomize['form_kbn']) {
              // 区分文本
              state.formCustomize['form_kbn_title'] = formKbnTemp['title'];
            }
          }
        }
        // 判断纸张方向
        if (state.formCustomize['form_direction'] != null &&
            state.formCustomize['form_direction'] != '') {
          // 循环纸张方向列表
          for (int i = 0; i < state.formDirectionList.length; i++) {
            // 纸张方向临时
            Map<String, dynamic> formDirectionTemp = state.formDirectionList[i];
            // 判断值
            if (formDirectionTemp['index'] ==
                state.formCustomize['form_direction']) {
              // 纸张方向文本
              state.formCustomize['form_direction_title'] =
                  formDirectionTemp['title'];
            }
          }
        }
        // 判断会社图像
        if (state.formCustomize['form_picture'] != null &&
            state.formCustomize['form_picture'] != '') {
          // 会社图像线上路径
          state.formCustomize['form_picture_network'] = await WMSCommonFile()
              .previewImageFile(state.formCustomize['form_picture']);
        }
      } else {
        // 账票-定制
        state.formCustomize = {
          'id': '',
          'form_kbn': '',
          'form_kbn_title': '',
          'form_picture': '',
          'form_picture_network': '',
          'form_direction_title': '',
          'form_direction': '',
          'description': '',
        };
      }

      // 更新
      emit(clone(state));
      // 关闭加载
      BotToast.closeAllLoading();
    });

    // 删除账票定制事件
    on<DeleteFormCustomizeEvent>((event, emit) async {
      // 打开加载状态
      BotToast.showLoading();

      try {
        // 删除账票定制
        List<Map<String, dynamic>> data = await SupabaseUtils.getClient()
            .from('mtb_form')
            .delete()
            .eq('id', event.formCustomizeId)
            .select('*');
        // 判断账票定制数据
        if (data.length != 0) {
          // 成功提示
          WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_success);
        } else {
          // 失败提示
          WMSCommonBlocUtils.errorTextToast(
              WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                  WMSLocalizations.i18n(state.rootContext)!.delete_error);
          // 关闭加载
          BotToast.closeAllLoading();
          return;
        }
      } catch (e) {
        // 失败提示
        WMSCommonBlocUtils.errorTextToast(
            WMSLocalizations.i18n(state.rootContext)!.menu_content_8_8 +
                WMSLocalizations.i18n(state.rootContext)!.delete_error);
        // 关闭加载
        BotToast.closeAllLoading();
        return;
      }

      // 加载标记
      state.loadingFlag = false;
      // 查询分页数据事件
      add(PageQueryEvent());
    });
    // 自定义事件 - 终

    add(InitEvent());
  }

  // 保存账票定制验证
  Map<String, dynamic> saveFormCustomizeCheck(
      Map<String, dynamic> formStructure) {
    // 判断是否为空
    if (formStructure['form_kbn'] == null || formStructure['form_kbn'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.form_distinguish +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (formStructure['form_picture'] == null ||
        formStructure['form_picture'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.form_company_icon +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    } else if (formStructure['form_direction'] == null ||
        formStructure['form_direction'] == '') {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(state.rootContext)!.form_paper_rotation +
              WMSLocalizations.i18n(state.rootContext)!.can_not_null_text);
      // 关闭加载
      BotToast.closeAllLoading();
      return {};
    }

    // 处理账票-结构
    if (formStructure['id'] == null || formStructure['id'] == '') {
      formStructure.remove('id');
    } else {
      formStructure['id'] = int.parse(formStructure['id'].toString());
    }

    // 返回
    return formStructure;
  }

  // 创建账票定制处理
  Form createFormCustomizeHandle(Form form) {
    // 账票
    form.company_id = StoreProvider.of<WMSState>(state.rootContext)
        .state
        .loginUser
        ?.company_id;
    form.create_time = DateTime.now().toString();
    form.create_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;
    form.update_time = DateTime.now().toString();
    form.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return form;
  }

  // 更新账票定制处理
  Form updateFormCustomizeHandle(Form form) {
    // 账票
    form.update_time = DateTime.now().toString();
    form.update_id =
        StoreProvider.of<WMSState>(state.rootContext).state.loginUser?.id;

    // 返回
    return form;
  }
}
