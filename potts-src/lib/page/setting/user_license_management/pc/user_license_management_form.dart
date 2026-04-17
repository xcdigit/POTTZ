import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wms/widget/wms_date_widget.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/user_license_management_bloc.dart';
import '../bloc/user_license_management_model.dart';
import 'user_license_management_title.dart';

/**
 * 内容：ユーザーライセンス管理-表单
 * 作者：熊草云
 * 时间：2023/12/07
 */
class UserLicenseManagementForm extends StatefulWidget {
  const UserLicenseManagementForm({super.key});

  @override
  State<UserLicenseManagementForm> createState() =>
      _UserLicenseManagementFormState();
}

class _UserLicenseManagementFormState extends State<UserLicenseManagementForm> {
  @override
  Widget build(BuildContext context) {
    int companyId = 0;
    int roleId = StoreProvider.of<WMSState>(context).state.loginUser!.role_id!;
    if (roleId != 1) {
      //获取当前登录用户会社ID
      companyId =
          StoreProvider.of<WMSState>(context).state.loginUser!.company_id!;
    }
    return BlocProvider<UserLicenseManagementBloc>(
      create: (context) {
        return UserLicenseManagementBloc(
          UserLicenseManagementModel(
            context: context,
            companyId: companyId,
            roleId: roleId,
          ),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 头部
              UserLicenseManagementTitle(
                flag: 'change',
              ),
              // 表单内容
              UserLicenseManagementFormContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserLicenseManagementFormContent extends StatefulWidget {
  const UserLicenseManagementFormContent({super.key});

  @override
  State<UserLicenseManagementFormContent> createState() =>
      _UserLicenseManagementFormContentState();
}

class _UserLicenseManagementFormContentState
    extends State<UserLicenseManagementFormContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLicenseManagementBloc, UserLicenseManagementModel>(
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
                .read<UserLicenseManagementBloc>()
                .add(SetUserFormValueEvent('avatar_image', content));
          }
          // 关闭加载
          BotToast.closeAllLoading();
        }

        // 初始化基本情報入力表单
        List<Widget> _initFormBasic() {
          return [
            FractionallySizedBox(
              //1 Email
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
                            'Email',
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
                      text: state.formInfo['email'].toString(),
                      inputBoxCallBack: (value) {
                        context
                            .read<UserLicenseManagementBloc>()
                            .add(SetUserFormValueEvent('email', value.trim()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //2 パスワード
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
                                .account_security_password,
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
                      text: state.formInfo['password'].toString(),
                      obscureText: true,
                      inputBoxCallBack: (value) {
                        context.read<UserLicenseManagementBloc>().add(
                            SetUserFormValueEvent('password', value.trim()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //3 ユーザー_名称
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
                        context.read<UserLicenseManagementBloc>().add(
                            SetUserFormValueEvent('user_name', value.trim()));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //4 ロール
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
                                context.read<UserLicenseManagementBloc>().add(
                                    SetUserFormValueEvent(
                                        'role_name', value['name']));
                                context.read<UserLicenseManagementBloc>().add(
                                    SetNowRoleIDEvent(
                                        int.parse(value['id'].toString())));
                              } else {
                                context.read<UserLicenseManagementBloc>().add(
                                    SetUserFormValueEvent('role_name', null));
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
              //5 会社名
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
                                .company_information_2,
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
                    state.roleId != 1
                        ? WMSInputboxWidget(
                            text: state.companyName.toString(),
                            readOnly: true,
                          )
                        : WMSDropdownWidget(
                            saveInput: true,
                            inputInitialValue:
                                state.formInfo['company_name'] == null
                                    ? ''
                                    : state.formInfo['company_name'].toString(),
                            dropdownKey: 'name',
                            dropdownTitle: 'name',
                            dataList1: state.salesCompanyInfoList,
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
                                context.read<UserLicenseManagementBloc>().add(
                                    SetUserFormValueEvent(
                                        'company_name', value['name']));
                                context.read<UserLicenseManagementBloc>().add(
                                    SetNowCompanyIDEvent(
                                        int.parse(value['id'].toString())));
                                context.read<UserLicenseManagementBloc>().add(
                                    SetNowOrganizationListEvent(value['id']));
                              } else {
                                context.read<UserLicenseManagementBloc>().add(
                                    SetUserFormValueEvent(
                                        'company_name', null));
                                context
                                    .read<UserLicenseManagementBloc>()
                                    .add(SetNowOrganizationListEvent(0));
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
              //6 組織名
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
                          context.read<UserLicenseManagementBloc>().add(
                              SetUserFormValueEvent(
                                  'organization_name', value['name']));
                          context.read<UserLicenseManagementBloc>().add(
                              SetNowOrganizationIDEvent(
                                  int.parse(value['id'].toString())));
                        } else {
                          context.read<UserLicenseManagementBloc>().add(
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
              //7 状態
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
                    WMSInputboxWidget(
                      text: (state.formInfo['status_name'] == '' ||
                              state.formInfo['status_name'] == null)
                          ? ''
                          : state.formInfo['status_name'].toString(),
                      readOnly: true,
                      inputBoxCallBack: null,
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //8 開始日
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
                            WMSLocalizations.i18n(context)!.menu_content_4_10_3,
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
                    WMSDateWidget(
                      text: state.formInfo['start_date'].toString(),
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<UserLicenseManagementBloc>()
                            .add(SetUserFormValueEvent('start_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //9 終了日
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
                            WMSLocalizations.i18n(context)!.menu_content_4_10_4,
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
                    WMSDateWidget(
                      text: state.formInfo['end_date'].toString(),
                      dateCallBack: (value) {
                        // 设定值
                        context
                            .read<UserLicenseManagementBloc>()
                            .add(SetUserFormValueEvent('end_date', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //10 言語
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
                          context.read<UserLicenseManagementBloc>().add(
                              SetUserFormValueEvent(
                                  'language_name', value['name']));
                          context.read<UserLicenseManagementBloc>().add(
                              SetNowLanguageIDEvent(
                                  int.parse(value['id'].toString())));
                        } else {
                          context.read<UserLicenseManagementBloc>().add(
                              SetUserFormValueEvent('language_name', null));
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
              //11 アイコン
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
                      child: (state.formInfo['avatar_image'] == '' ||
                              state.formInfo['avatar_image'] == null)
                          ? Image.asset(
                              WMSICons.NO_IMAGE,
                              width: 136,
                              height: 136,
                            )
                          : Image.network(
                              state.formInfo['avatar_image'],
                              width: 136,
                              height: 136,
                            ),
                    )
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //12 備考
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
                        context.read<UserLicenseManagementBloc>().add(
                            SetUserFormValueEvent('description', value.trim()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ];
        }

        return Container(
          margin: EdgeInsets.only(
            bottom: 40,
          ),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.6,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: UserLicenseManagementFormTab(),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: UserLicenseManagementFormButton(state: state),
                      ),
                    ),
                  ],
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.spaceBetween,
                    children: _initFormBasic(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 出荷指示入力-表单Tab
// ignore: must_be_immutable
class UserLicenseManagementFormTab extends StatefulWidget {
  UserLicenseManagementFormTab({super.key});

  @override
  State<UserLicenseManagementFormTab> createState() =>
      _UserLicenseManagementFormTabState();
}

class _UserLicenseManagementFormTabState
    extends State<UserLicenseManagementFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList) {
    // Tab列表
    List<Widget> tabList = [];
    tabList.add(
      Container(
        child: Container(
          height: 46,
          padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
          margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
          decoration: BoxDecoration(
            color: Color.fromRGBO(44, 167, 176, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          constraints: BoxConstraints(
            minWidth: 160,
          ),
          child: Text(
            tabItemList[0]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
      ),
    );
    return tabList;
  }

  @override
  Widget build(BuildContext context) {
    // Tab单个列表
    List _tabItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.reserve_input_2,
      },
    ];

    return Row(
      children: _initTabList(_tabItemList),
    );
  }
}

// 会社-表单按钮
// ignore: must_be_immutable
class UserLicenseManagementFormButton extends StatefulWidget {
  UserLicenseManagementModel state;
  UserLicenseManagementFormButton({super.key, required this.state});

  @override
  State<UserLicenseManagementFormButton> createState() =>
      _UserLicenseManagementFormButtonState();
}

class _UserLicenseManagementFormButtonState
    extends State<UserLicenseManagementFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        GestureDetector(
          // onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 20),
            height: 37,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(44, 167, 176, 1),
                ), // 设置按钮背景颜色
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white), // 设置按钮文本颜色
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(80, 37),
                ), // 设置按钮宽度和高度
              ),
              onPressed: () {
                // 判断循环下标
                if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                  //清除表单数据
                  context
                      .read<UserLicenseManagementBloc>()
                      .add(ClearFormEvent());
                } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                  //新增/修改数据
                  context
                      .read<UserLicenseManagementBloc>()
                      .add(UpdateFormEvent(context));
                }
              },
              child: Text(
                buttonItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.28,
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
    // 按钮单个列表
    List _buttonItemList = [
      {
        'index': Config.NUMBER_ZERO,
        'title': WMSLocalizations.i18n(context)!.exit_input_form_button_clear,
      },
      {
        'index': Config.NUMBER_ONE,
        'title':
            WMSLocalizations.i18n(context)!.instruction_input_tab_button_add,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
