import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/widget/wms_date_widget.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/user_license_management_detail_bloc.dart';
import '../bloc/user_license_management_detail_model.dart';

/**
 * 内容：ユーザーライセンス管理明细-表单
 * 作者：熊草云
 * 时间：2023/12/07
 */
class UserLicenseManagementDetailForm extends StatefulWidget {
  const UserLicenseManagementDetailForm({super.key});

  @override
  State<UserLicenseManagementDetailForm> createState() =>
      _UserLicenseManagementDetailFormState();
}

class _UserLicenseManagementDetailFormState
    extends State<UserLicenseManagementDetailForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLicenseManagementDetailBloc,
        UserLicenseManagementDetailModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 表单标题
            UserLicenseManagementDetailFormTitle(),
            // 表单内容
            UserLicenseManagementDetailFormContent(),
          ],
        );
      },
    );
  }
}

// 表单标题
class UserLicenseManagementDetailFormTitle extends StatefulWidget {
  const UserLicenseManagementDetailFormTitle({super.key});

  @override
  State<UserLicenseManagementDetailFormTitle> createState() =>
      _UserLicenseManagementDetailFormTitleState();
}

class _UserLicenseManagementDetailFormTitleState
    extends State<UserLicenseManagementDetailFormTitle> {
  // 当前悬停下标
  int _currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化右侧按钮列表
  _initButtonRightList(List buttonItemList, refresh) {
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
                // 返回上一页
                if (refresh) {
                  GoRouter.of(context).pop('refresh');
                } else {
                  GoRouter.of(context).pop();
                }
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

    return BlocBuilder<UserLicenseManagementDetailBloc,
        UserLicenseManagementDetailModel>(
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
                  WMSLocalizations.i18n(context)!
                      .user_license_management_detail_form_1,
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
                  children: _initButtonRightList(
                      _buttonRightItemList, state.updateForm),
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
class UserLicenseManagementDetailFormContent extends StatefulWidget {
  const UserLicenseManagementDetailFormContent({super.key});

  @override
  State<UserLicenseManagementDetailFormContent> createState() =>
      _UserLicenseManagementDetailFormContentState();
}

class _UserLicenseManagementDetailFormContentState
    extends State<UserLicenseManagementDetailFormContent> {
  // 初始化按钮弹窗单条
  List<Widget> _initButtonDialogItem(
      BuildContext context, List buttonDialogOptions) {
    // 按钮弹窗单条列表
    List<Widget> buttonDialogItemList = [];
    // 循环按钮弹窗选项
    for (int i = 0; i < buttonDialogOptions.length; i++) {
      // 按钮弹窗单条列表
      buttonDialogItemList.add(
        GestureDetector(
          onTap: () {
            // 判断下标
            if (buttonDialogOptions[i]['index'] == Config.NUMBER_ZERO) {
              // 关闭
              Navigator.pop(context);
              context
                  .read<UserLicenseManagementDetailBloc>()
                  .add(UpdateFormEvent());
            } else if (buttonDialogOptions[i]['index'] == Config.NUMBER_ONE) {
              // 关闭
              Navigator.pop(context);
              _passwordesetDialog();
            }
          },
          child: Container(
            width: 170,
            height: 37,
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              buttonDialogOptions[i]['title'],
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(44, 167, 176, 1),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      );
    }
    // 按钮弹窗单条列表
    return buttonDialogItemList;
  }

  // 初始化按钮弹窗
  _initButtonDialog(List buttonDialogOptions) {
    UserLicenseManagementDetailBloc bloc =
        context.read<UserLicenseManagementDetailBloc>();
    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(255, 255, 255, 0),
      builder: (context) {
        return BlocProvider<UserLicenseManagementDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<UserLicenseManagementDetailBloc,
              UserLicenseManagementDetailModel>(
            builder: (context, state) {
              return Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned(
                      top: 270,
                      right: 44,
                      child: Container(
                        width: 170,
                        height: 134,
                        padding: EdgeInsets.fromLTRB(0, 22, 0, 22),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(156, 156, 156, 0.36),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: _initButtonDialogItem(
                              context, buttonDialogOptions),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // 初始化表单
  Widget _initForm(List buttonDialogOptions) {
    return BlocBuilder<UserLicenseManagementDetailBloc,
        UserLicenseManagementDetailModel>(
      builder: (context, state) {
        // 上传图片文件回调函数
        void _uploadImageFileCallBack(String content) {
          // 判断内容信息
          if (content == WMSCommonFile.SIZE_EXCEEDS) {
            // 消息提示
            WMSCommonBlocUtils.tipTextToast(
                WMSLocalizations.i18n(context)!.image_size_need_within_2m);
          } else {
            // 保存写真路径
            context
                .read<UserLicenseManagementDetailBloc>()
                .add(SetUserFormValueEvent('image', content));
          }
          // 关闭加载
          BotToast.closeAllLoading();
        }

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
                      child: Text(
                        WMSLocalizations.i18n(context)!.account_profile_user +
                            "： ${state.formInfo['email'] == null ? '' : state.formInfo['email'].toString()}",
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
                            // 初始化按钮弹窗
                            _initButtonDialog(buttonDialogOptions);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                WMSLocalizations.i18n(context)!
                                    .delivery_note_32,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                size: 14,
                              )
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
              // ユーザー_名称
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .user_license_management_form_1,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['user_name'].toString(),
                      inputBoxCallBack: (value) {
                        context.read<UserLicenseManagementDetailBloc>().add(
                            SetUserFormValueEvent('user_name', value.trim()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // ロール
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .account_profile_roll,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    state.roleId == 1
                        ? WMSDropdownWidget(
                            saveInput: true,
                            inputInitialValue:
                                state.formInfo['role_name'] == null
                                    ? ''
                                    : state.formInfo['role_name'].toString(),
                            dropdownKey: 'name',
                            dropdownTitle: 'name',
                            dataList1: state.salesRoleInfoList,
                            inputRadius: 4,
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            selectedCallBack: (value) {
                              // 设定值
                              if (value is! String) {
                                context
                                    .read<UserLicenseManagementDetailBloc>()
                                    .add(SetUserFormValueEvent(
                                        'role_name', value['name']));
                                context
                                    .read<UserLicenseManagementDetailBloc>()
                                    .add(SetUserFormValueEvent(
                                        'role_id', value['id']));
                              } else {
                                context
                                    .read<UserLicenseManagementDetailBloc>()
                                    .add(SetUserFormValueEvent(
                                        'role_name', null));
                                // ignore: unnecessary_null_comparison
                                if (value.trim() != '' && value != null) {
                                  WMSCommonBlocUtils.errorTextToast(
                                      WMSLocalizations.i18n(context)!
                                          .organization_master_tip_5);
                                }
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            text: state.formInfo['role_name'] == null
                                ? ''
                                : state.formInfo['role_name'].toString(),
                            readOnly: true,
                          ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 会社名
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.company_information_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      text: state.formInfo['company_name'] == null
                          ? ''
                          : state.formInfo['company_name'].toString(),
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 組織名
              widthFactor: 0.4,
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
                            .organization_master_form_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDropdownWidget(
                      saveInput: true,
                      inputInitialValue:
                          state.formInfo['organization_name'] == null
                              ? ''
                              : state.formInfo['organization_name'].toString(),
                      dropdownKey: 'name',
                      dropdownTitle: 'name',
                      dataList1: state.salesOrganizationfoList,
                      inputRadius: 4,
                      inputSuffixIcon: Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                      ),
                      selectedCallBack: (value) {
                        // 设定值
                        if (value is! String) {
                          context.read<UserLicenseManagementDetailBloc>().add(
                              SetUserFormValueEvent(
                                  'organization_name', value['name']));
                          context.read<UserLicenseManagementDetailBloc>().add(
                              SetNowOrganizationIDEvent(
                                  int.parse(value['id'].toString())));
                        } else {
                          context.read<UserLicenseManagementDetailBloc>().add(
                              SetUserFormValueEvent('organization_name', null));
                          // ignore: unnecessary_null_comparison
                          if (value.trim() != '' && value != null) {
                            WMSCommonBlocUtils.errorTextToast(
                                WMSLocalizations.i18n(context)!
                                    .organization_master_tip_5);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 状態
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .account_profile_state,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    state.roleId == 1
                        ? WMSDropdownWidget(
                            saveInput: true,
                            inputInitialValue: (state.formInfo['status_name'] ==
                                        null ||
                                    int.tryParse(
                                            state.formInfo['status_name']) !=
                                        null)
                                ? ''
                                : state.formInfo['status_name'].toString(),
                            dropdownKey: 'status_name',
                            dropdownTitle: 'status_name',
                            dataList1: state.salesStatusInfoList,
                            inputRadius: 4,
                            inputSuffixIcon: Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                            ),
                            selectedCallBack: (value) {
                              // 设定状态
                              if (value is! String) {
                                context
                                    .read<UserLicenseManagementDetailBloc>()
                                    .add(SetUserFormValueEvent(
                                        'status_name', value['status_name']));
                                state.formInfo['status'] = value['id'];
                              } else {
                                context
                                    .read<UserLicenseManagementDetailBloc>()
                                    .add(SetUserFormValueEvent(
                                        'status_name', ''));
                              }
                            },
                          )
                        : WMSInputboxWidget(
                            text: state.formInfo['status_name'] == null
                                ? ''
                                : state.formInfo['status_name'].toString(),
                            readOnly: true,
                          ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 開始日
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.menu_content_4_10_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDateWidget(
                      text: state.formInfo['start_date'].toString(),
                      readOnly: true,
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<UserLicenseManagementDetailBloc>()
                            .add(SetUserFormValueEvent('start_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 終了日
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!.menu_content_4_10_4,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDateWidget(
                      text: state.formInfo['end_date'].toString(),
                      readOnly: true,
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<UserLicenseManagementDetailBloc>()
                            .add(SetUserFormValueEvent('end_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 言語
              widthFactor: 0.4,
              child: Container(
                height: 72,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .user_license_management_form_2,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(6, 14, 15, 1),
                            ),
                          ),
                          Text(
                            "*",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color.fromRGBO(255, 0, 0, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WMSDropdownWidget(
                      saveInput: true,
                      inputInitialValue: state.formInfo['language_name'] == null
                          ? ''
                          : state.formInfo['language_name'].toString(),
                      dropdownKey: 'name',
                      dropdownTitle: 'name',
                      dataList1: state.salesLanguageInfoList,
                      inputRadius: 4,
                      inputSuffixIcon: Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                        ),
                      ),
                      selectedCallBack: (value) {
                        // 设定值
                        if (value is! String) {
                          context.read<UserLicenseManagementDetailBloc>().add(
                              SetUserFormValueEvent(
                                  'language_name', value['name']));
                          state.formInfo['language_id'] = value['id'];
                        } else {
                          context
                              .read<UserLicenseManagementDetailBloc>()
                              .add(SetUserFormValueEvent('language_name', ''));
                          // ignore: unnecessary_null_comparison
                          if (value.trim() != '' && value != null) {
                            WMSCommonBlocUtils.errorTextToast(
                                WMSLocalizations.i18n(context)!
                                    .organization_master_tip_5);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // アイコン
              widthFactor: 0.3,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .user_license_management_form_3,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        BotToast.showLoading();
                        // 上传图片
                        WMSCommonFile().uploadImageFile(
                            'product/' +
                                StoreProvider.of<WMSState>(context)
                                    .state
                                    .loginUser!
                                    .company_id
                                    .toString(),
                            '',
                            _uploadImageFileCallBack);
                      },
                      child: (state.formInfo['image'] == '' ||
                              state.formInfo['image'] == null)
                          ? Image.asset(
                              WMSICons.NO_IMAGE,
                              width: 136,
                              height: 136,
                            )
                          : Image.network(
                              state.formInfo['image'],
                              width: 136,
                              height: 136,
                            ),
                    )
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              // 備考
              widthFactor: 0.4,
              child: Container(
                height: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      child: Text(
                        WMSLocalizations.i18n(context)!
                            .charge_management_form_2,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                      height: 136,
                      maxLines: 5,
                      text: state.formInfo['description'].toString(),
                      inputBoxCallBack: (value) {
                        context.read<UserLicenseManagementDetailBloc>().add(
                            SetUserFormValueEvent('description', value.trim()));
                      },
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

  String? _newpassWord;
  _passwordesetDialog() {
    UserLicenseManagementDetailBloc bloc =
        context.read<UserLicenseManagementDetailBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider<UserLicenseManagementDetailBloc>.value(
          value: bloc,
          child: BlocBuilder<UserLicenseManagementDetailBloc,
              UserLicenseManagementDetailModel>(
            builder: (context, state) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero, // 设置为零边距
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Container(
                  height: 350,
                  width: 600,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 40),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Color.fromRGBO(44, 167, 176, 1),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .user_license_management_detail_form_2,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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
                                  child: Row(
                                    children: [
                                      Text(WMSLocalizations.i18n(context)!
                                          .login_password_new_hint_text),
                                      Text(
                                        "*",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color.fromRGBO(255, 0, 0, 1.0),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(padding: EdgeInsets.only(bottom: 16)),
                              WMSInputboxWidget(
                                text: _newpassWord,
                                inputBoxCallBack: (value) {
                                  setState(() {
                                    _newpassWord = value.trim();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          // padding: EdgeInsets.only(right: 48),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(
                                              44, 167, 176, 1)), // 设置按钮背景颜色
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white), // 设置按钮文本颜色
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(120, 48)), // 设置按钮宽度和高度
                                ),
                                child: Text(
                                    WMSLocalizations.i18n(context)!.app_ok),
                                onPressed: () {
                                  if (_newpassWord == '' ||
                                      _newpassWord == null) {
                                    WMSCommonBlocUtils.errorTextToast(
                                        WMSLocalizations.i18n(context)!
                                                .account_security_password +
                                            WMSLocalizations.i18n(context)!
                                                .can_not_null_text);
                                    return;
                                  }
                                  Navigator.of(context).pop(); //
                                  context
                                      .read<UserLicenseManagementDetailBloc>()
                                      .add(ResetPasswordEvent(_newpassWord!));
                                  setState(() {
                                    _newpassWord = '';
                                  });
                                },
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
          ),
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
