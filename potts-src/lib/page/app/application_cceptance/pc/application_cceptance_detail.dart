import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/bloc/wms_common_bloc_utils.dart';
import 'package:wms/common/config/config.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_bloc.dart';
import 'package:wms/page/app/application_cceptance/bloc/application_cceptance_model.dart';
import 'package:wms/widget/wms_dropdown_widget.dart';
import 'package:wms/widget/wms_inputbox_widget.dart';

/**
 * 内容：申込受付 -详细
 * 作者：cuihr
 * 时间：2023/12/18
 */
// ignore_for_file: must_be_immutable
class ApplicationCceptanceDetail extends StatefulWidget {
  int appId = 0;
  ApplicationCceptanceDetail({super.key, this.appId = 0});

  @override
  State<ApplicationCceptanceDetail> createState() =>
      _ApplicationCceptanceDetailState();
}

class _ApplicationCceptanceDetailState
    extends State<ApplicationCceptanceDetail> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationCceptanceBloc>(
      create: (context) {
        return ApplicationCceptanceBloc(
          ApplicationCceptanceModel(context: context, appId: widget.appId),
        );
      },
      child: BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
        builder: (context, state) {
          return FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 40),
                child: ListView(
                  children: [
                    // 表单标题
                    ApplicationCceptanceDetailFormTitle(),
                    // 表单内容
                    ApplicationCceptanceDetailFormContent(),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

// 表单标题
class ApplicationCceptanceDetailFormTitle extends StatefulWidget {
  const ApplicationCceptanceDetailFormTitle({super.key});

  @override
  State<ApplicationCceptanceDetailFormTitle> createState() =>
      _ApplicationCceptanceDetailFormTitleState();
}

class _ApplicationCceptanceDetailFormTitleState
    extends State<ApplicationCceptanceDetailFormTitle> {
// 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = buttonItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              _currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onTap: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // // 返回上一页

                GoRouter.of(context).pop('refresh');
              }
            },
            child: Container(
              height: 34,
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              decoration: BoxDecoration(
                color: _currentHoverIndex == buttonItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, .6)
                    : Colors.white,
                border: Border.all(
                  color: _currentHoverIndex == buttonItemList[i]['index']
                      ? Color.fromRGBO(44, 167, 176, .6)
                      : Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                buttonItemList[i]['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _currentHoverIndex == buttonItemList[i]['index']
                      ? Colors.white
                      : Color.fromRGBO(44, 167, 176, 1),
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // 按钮列表
    return buttonList;
  }

  @override
  Widget build(BuildContext context) {
    // 右侧按钮单个列表
    List _buttonRightItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.error_return,
      },
    ];

    return BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
      builder: (context, state) {
        return Container(
          height: 104,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Text(
                  WMSLocalizations.i18n(context)!.menu_content_60_98_25,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    height: 1.0,
                    color: Color.fromRGBO(44, 167, 176, 1),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
                child: Row(
                  children: _initButtonRightList(_buttonRightItemList),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 表单内容
class ApplicationCceptanceDetailFormContent extends StatefulWidget {
  const ApplicationCceptanceDetailFormContent({super.key});

  @override
  State<ApplicationCceptanceDetailFormContent> createState() =>
      _ApplicationCceptanceDetailFormContentState();
}

class _ApplicationCceptanceDetailFormContentState
    extends State<ApplicationCceptanceDetailFormContent> {
  selectDialog() {
    ApplicationCceptanceBloc bloc = context.read<ApplicationCceptanceBloc>();
    showDialog(
        context: context,
        builder: (context) {
          return BlocProvider<ApplicationCceptanceBloc>.value(
              value: bloc,
              child: BlocBuilder<ApplicationCceptanceBloc,
                  ApplicationCceptanceModel>(
                builder: (context, state) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.zero, // 设置为零边距
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    content: Container(
                      height: 350,
                      width: 600,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                ),
                                //标题
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .app_error_text_2,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                          SizedBox(height: 60),
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(40, 0, 0, 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 24,
                                    child: Text(WMSLocalizations.i18n(context)!
                                        .app_cceptance_status),
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 16)),
                                  WMSDropdownWidget(
                                    dataList1:
                                        state.applicationStatusDetailList,
                                    inputInitialValue:
                                        state.application_status_name,
                                    inputRadius: 4,
                                    inputSuffixIcon: Container(
                                      width: 24,
                                      height: 24,
                                      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                      ),
                                    ),
                                    inputFontSize: 14,
                                    dropdownRadius: 4,
                                    dropdownTitle: 'name',
                                    selectedCallBack: (value) {
                                      // 判断数值
                                      if (value == '') {
                                        context
                                            .read<ApplicationCceptanceBloc>()
                                            .add(SetStatusValueEvent(
                                                'application_status', '', ''));
                                      } else {
                                        context
                                            .read<ApplicationCceptanceBloc>()
                                            .add(SetStatusValueEvent(
                                                'application_status',
                                                value['id'],
                                                value['name']));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              padding: EdgeInsets.only(right: 48),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  //左边按钮 默认显示
                                  Visibility(
                                    visible: true,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      height: 36,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        child: Text(
                                          WMSLocalizations.i18n(context)!
                                              .app_cancel,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {
                                          // 关闭弹窗
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                  //右边按钮 默认显示
                                  Visibility(
                                    visible: true,
                                    child: Container(
                                      height: 36,
                                      // margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              44, 167, 176, 1),
                                        ),
                                        child: Text(
                                          WMSLocalizations.i18n(context)!
                                              .table_tab_confirm,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (state.application_status == '2' ||
                                              state.application_status == '1') {
                                            context
                                                .read<
                                                    ApplicationCceptanceBloc>()
                                                .add(
                                                    UpdateStatusEvent(context));
                                          } else {
                                            //未选择提示
                                            WMSCommonBlocUtils.errorTextToast(
                                                WMSLocalizations.i18n(context)!
                                                    .register_choose_status);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
        });
  }

  // 初始化按钮部件列表
  List<Widget> _initButtonWidgetList() {
    // 按钮列表
    List<Map<String, dynamic>> buttonList = [
      {
        'index': 1,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_required_button_1,
      },
      {
        'index': 2,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_required_button_2,
      },
      {
        'index': 3,
        'title': WMSLocalizations.i18n(context)!
            .login_application_choose_required_button_3,
      },
    ];
    // 按钮部件列表
    List<Widget> buttonWidgetList = [];
    // 循环按钮列表
    for (var i = 0; i < buttonList.length; i++) {
      // 按钮部件列表
      buttonWidgetList.add(
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: (buttonList[i]['index'] == 1 &&
                          context
                                  .read<ApplicationCceptanceBloc>()
                                  .state
                                  .formInfo['base_ship']
                                  .toString() ==
                              '1') ||
                      (buttonList[i]['index'] == 2 &&
                          context
                                  .read<ApplicationCceptanceBloc>()
                                  .state
                                  .formInfo['base_receive']
                                  .toString() ==
                              '1') ||
                      (buttonList[i]['index'] == 3 &&
                          context
                                  .read<ApplicationCceptanceBloc>()
                                  .state
                                  .formInfo['base_store']
                                  .toString() ==
                              '1')
                  ? Color.fromRGBO(255, 175, 19, 1)
                  : Color.fromRGBO(125, 125, 125, 0.1),
              border: Border.all(
                color: (buttonList[i]['index'] == 1 &&
                            context
                                    .read<ApplicationCceptanceBloc>()
                                    .state
                                    .formInfo['base_ship']
                                    .toString() ==
                                '1') ||
                        (buttonList[i]['index'] == 2 &&
                            context
                                    .read<ApplicationCceptanceBloc>()
                                    .state
                                    .formInfo['base_receive']
                                    .toString() ==
                                '1') ||
                        (buttonList[i]['index'] == 3 &&
                            context
                                    .read<ApplicationCceptanceBloc>()
                                    .state
                                    .formInfo['base_store']
                                    .toString() ==
                                '1')
                    ? Colors.transparent
                    : Color.fromRGBO(125, 125, 125, 1),
              ),
              borderRadius: BorderRadius.circular(9),
            ),
            width: 125,
            height: 42,
            margin: EdgeInsets.only(
              left: i == 0 ? 0 : 30,
            ),
            child: Center(
              child: Text(
                buttonList[i]['title'],
                style: TextStyle(
                  color: (buttonList[i]['index'] == 1 &&
                              context
                                      .read<ApplicationCceptanceBloc>()
                                      .state
                                      .formInfo['base_ship']
                                      .toString() ==
                                  '1') ||
                          (buttonList[i]['index'] == 2 &&
                              context
                                      .read<ApplicationCceptanceBloc>()
                                      .state
                                      .formInfo['base_receive']
                                      .toString() ==
                                  '1') ||
                          (buttonList[i]['index'] == 3 &&
                              context
                                      .read<ApplicationCceptanceBloc>()
                                      .state
                                      .formInfo['base_store']
                                      .toString() ==
                                  '1')
                      ? Color.fromRGBO(251, 251, 251, 1)
                      : Color.fromRGBO(125, 125, 125, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return buttonWidgetList;
  }

  // 初始化表单
  Widget _initForm(List buttonDialogOptions) {
    return BlocBuilder<ApplicationCceptanceBloc, ApplicationCceptanceModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 37,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 6.5, 0, 6.5),
                      //申込情報
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_info_1,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                        height: 37,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(44, 167, 176, 1),
                            ),
                          ),
                          onPressed: () {
                            //受付按钮
                            if (state.formInfo['application_status'] == '1' ||
                                state.formInfo['application_status'] == '2') {
                              WMSCommonBlocUtils.tipTextToast(
                                  WMSLocalizations.i18n(context)!
                                      .app_error_text_1);
                              return;
                            }
                            context.read<ApplicationCceptanceBloc>().add(
                                SetStatusValueEvent(
                                    'application_status', '', ''));
                            selectDialog();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //受付
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .app_cceptance_btn,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //1、 メールアドレス
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .app_cceptance_user_email,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_email'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 2、担当者名
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_user_name,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 3、電話番号
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .app_cceptance_user_phone,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_phone'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            //4、会社名
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .app_cceptance_company_name,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['company_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 5、申込状態
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_status,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(0, 176, 240, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text:
                          state.formInfo['application_status_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 6、申込時間
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_time,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['create_time'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // プラン情報
              widthFactor: 1,
              child: Container(
                height: 37,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 6.5, 0, 6.5),
                      //申込情報
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_info_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //1、必要な機能
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .login_application_choose_required,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 12,
                      ),
                      child: Row(
                        children: _initButtonWidgetList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //2、従量課金
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_plan,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['plan_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            //3、アカウント数
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .app_cceptance_account_num,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['account_num'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            //4、オプション
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_option,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['option_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            //5、お支払いサイクル
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_pay_cycle,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['pay_cycle_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 支払情報
              widthFactor: 1,
              child: Container(
                height: 37,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 6.5, 0, 6.5),
                      //申込情報
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_info_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(44, 167, 176, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //1、支払金額
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.app_cceptance_pay_total,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['pay_total'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            //2、支払状態
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.account_license_payment,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(0, 176, 240, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['pay_status_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            //3、オーダー番号
            FractionallySizedBox(
              widthFactor: 0.3,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .user_license_management_detail_table_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['pay_no'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 按钮弹窗选项
    List _buttonDialogOptions = [
      {
        'index': Config.NUMBER_ZERO,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_update
      },
      {
        'index': Config.NUMBER_ONE,
        'title': WMSLocalizations.i18n(context)!
            .user_license_management_detail_form_2
      },
    ];

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(224, 224, 224, 1),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: _initForm(_buttonDialogOptions),
      ),
    );
  }
}
