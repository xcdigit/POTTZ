import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wms/page/app/contract/pc/contract_page.dart';
import 'package:intl/intl.dart';

import '../../redux/wms_state.dart';
import '../common/config/config.dart';
import '../common/localization/default_localizations.dart';
import '../common/storage/local_storage.dart';
import '../common/utils/common_utils.dart';
import '../common/utils/statistics_utils.dart';
import '../common/utils/supabase_untils.dart';
import '../common/utils/timeout_utils_other.dart'
    if (dart.library.html) '../common/utils/timeout_utils_web.dart';
import '../model/login.dart';
import '../model/user.dart';
import '../page/home_main/sp/home_main_page.dart'
    if (dart.library.html) '../page/home_main/pc/home_main_page.dart';
import '../page/login_verification_code/sp/login_verification_code_page.dart'
    if (dart.library.html) '../page/login_verification_code/pc/login_verification_code_page.dart';
import '../widget/wms_dialog_widget.dart';
import 'middleware/epic_store.dart';
import 'user_redux.dart';

final LoginReducer = combineReducers<bool?>([
  TypedReducer<bool?, LoginSuccessAction>(_loginResult),
  TypedReducer<bool?, LogoutAction>(_logoutResult),
]);

bool? _loginResult(bool? result, LoginSuccessAction action) {
  if (action.success == true) {
    //解约页面场合，跳转回去
    if (StoreProvider.of<WMSState>(action.context).state.contractFlag) {
      action.context.goNamed(ContractPage.sName);
    } else if (action.loginRoleId == 1 || action.loginRoleId == 2) {
      action.context.goNamed(LoginVerificationCodePage.sName);
    } else {
      action.context.goNamed(HomeMainPage.sName);
    }
  }
  return action.success;
}

bool? _logoutResult(bool? result, LogoutAction action) {
  return false;
}

class LoginSuccessAction {
  final BuildContext context;
  final bool success;
  final int loginRoleId;

  LoginSuccessAction(this.context, this.success, this.loginRoleId);
}

class LogoutAction {
  final BuildContext context;

  LogoutAction(this.context);
}

class LoginAction {
  final BuildContext context;
  final String? username;
  final String? password;
  final bool remember;
  final String? loginRoleFlag;
  final ValueChanged<bool>? callback;
  LoginAction(this.context, this.username, this.password, this.remember,
      this.loginRoleFlag, this.callback);
}

class LoginMiddleware implements MiddlewareClass<WMSState> {
  @override
  void call(Store<WMSState> store, dynamic action, NextDispatcher next) {
    if (action is LogoutAction) {
      SupabaseUtils.logout();
      action.context.replace('/login');
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

Stream<dynamic> loginEpic(Stream<dynamic> actions, EpicStore<WMSState> store) {
  Stream<dynamic> _loginIn(
      LoginAction action, EpicStore<WMSState> store) async* {
    // showLoadingDialog
    var res = await SupabaseUtils.loginByMail(
        action.username!.trim(), action.password!.trim(), action.remember);

    if (action.context.canPop()) {
      action.context.pop();
    }

    // 登录角色ID
    int loginRoleId = 0;

    if (res) {
      // 赵士淞 - 始
      // 当前时间
      String nowDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // Supabase登录信息
      Login? login = await SupabaseUtils.getCurrentUser();
      // Supabase信息存储
      store.dispatch(
        new UpdateUserAction(login),
      );
      // 查询登录用户
      List<dynamic> userData = await SupabaseUtils.getClient()
          .from('mtb_user')
          .select('*')
          .eq('code', login?.id);
      // 判断登录用户数量
      if (userData.length != 0) {
        // 登录角色ID
        loginRoleId = userData[0]['role_id'];

        // 判断登录页面标记与登录用户角色
        if (action.loginRoleFlag == Config.LOGIN_ROLE_1 &&
            (userData[0]['role_id'] == Config.ROLE_ID_2 ||
                userData[0]['role_id'] == Config.ROLE_ID_3)) {
          // 状态
          res = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(action.context).state.login = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(action.context).state.userInfo = null;
          // 持久化状态
          StoreProvider.of<WMSState>(action.context).state.loginUser =
              User.empty();
          // 持久化状态
          StoreProvider.of<WMSState>(action.context).state.loginAuthority = [];
          // 提示弹窗
          showDialog(
            context: action.context,
            builder: (context) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText:
                    WMSLocalizations.i18n(context)!.login_role_error_admin,
                buttonLeftFlag: false,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedRight: () {
                  // 关闭对话框并返回true
                  action.callback!(false);
                  Navigator.of(context).pop(true);
                },
              );
            },
          );
        } else if (action.loginRoleFlag == Config.LOGIN_ROLE_2 &&
            userData[0]['role_id'] == Config.ROLE_ID_1) {
          // 状态
          res = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(action.context).state.login = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(action.context).state.userInfo = null;
          // 持久化状态
          StoreProvider.of<WMSState>(action.context).state.loginUser =
              User.empty();
          // 持久化状态
          StoreProvider.of<WMSState>(action.context).state.loginAuthority = [];
          // 提示弹窗
          showDialog(
            context: action.context,
            builder: (context) {
              return WMSDiaLogWidget(
                titleText: WMSLocalizations.i18n(context)!
                    .login_tip_title_modify_pwd_text,
                contentText:
                    WMSLocalizations.i18n(context)!.login_role_error_user,
                buttonLeftFlag: false,
                buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                onPressedRight: () {
                  // 关闭对话框并返回true
                  action.callback!(false);
                  Navigator.of(context).pop(true);
                },
              );
            },
          );
        }
        // 判断登录用户会社ID
        if (userData[0]['company_id'] == Config.NUMBER_ZERO) {
          // 持久化状态
          StoreProvider.of<WMSState>(action.context).state.loginUser =
              User.fromJson(userData[0]);

          // 查询权限
          List<dynamic> authorityData = await SupabaseUtils.getClient().rpc(
              'func_zhaoss_query_login_mtb_authority',
              params: {'role_id': userData[0]['role_id']}).select('*');
          // 持久化状态
          StoreProvider.of<WMSState>(action.context).state.loginAuthority =
              authorityData;

          // 切换语言
          CommonUtils.changeLocale(StoreProvider.of<WMSState>(action.context),
              userData[0]['language_id']);
          // 本地存储
          LocalStorage.save(
              Config.LOCALE, userData[0]['language_id'].toString());

          // 超时工具类-初始化
          TimeoutUtils.init();
        } else {
          // 查询会社情报
          List<dynamic> companyData = await SupabaseUtils.getClient()
              .from('mtb_company')
              .select('*')
              .eq('id', userData[0]['company_id']);
          // 判断会社情报数量
          if (companyData.length != 0) {
            // 判断会社状态
            if (companyData[0]['status'] == Config.NUMBER_FOUR.toString()) {
              // 状态
              res = false;
              // 持久化状态更新
              StoreProvider.of<WMSState>(action.context).state.login = false;
              // 持久化状态更新
              StoreProvider.of<WMSState>(action.context).state.userInfo = null;
              // 持久化状态
              StoreProvider.of<WMSState>(action.context).state.loginUser =
                  User.empty();
              // 持久化状态
              StoreProvider.of<WMSState>(action.context).state.loginAuthority =
                  [];
              // 提示弹窗
              showDialog(
                context: action.context,
                builder: (context) {
                  return WMSDiaLogWidget(
                    titleText: WMSLocalizations.i18n(context)!
                        .login_tip_title_modify_pwd_text,
                    contentText:
                        WMSLocalizations.i18n(context)!.company_has_terminated,
                    buttonLeftFlag: false,
                    buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                    onPressedRight: () {
                      // 关闭对话框并返回true
                      action.callback!(false);
                      Navigator.of(context).pop(true);
                    },
                  );
                },
              );
            } else {
              // 查询会社计划情报
              List<dynamic> companyPlanData = await SupabaseUtils.getClient()
                  .from('ytb_company_plan_manage')
                  .select('*')
                  .eq('company_id', userData[0]['company_id'])
                  .eq('pay_status', '1')
                  .order('next_date', ascending: false);
              // 判断会社计划情报数量
              if (companyPlanData.length != 0) {
                // 判断下次付款时间
                if (companyPlanData[0]['next_date']
                        .toString()
                        .compareTo(nowDateTime) <
                    0) {
                  // 状态
                  res = false;
                  // 持久化状态更新
                  StoreProvider.of<WMSState>(action.context).state.login =
                      false;
                  // 持久化状态更新
                  StoreProvider.of<WMSState>(action.context).state.userInfo =
                      null;
                  // 持久化状态
                  StoreProvider.of<WMSState>(action.context).state.loginUser =
                      User.empty();
                  // 持久化状态
                  StoreProvider.of<WMSState>(action.context)
                      .state
                      .loginAuthority = [];
                  // 提示弹窗
                  showDialog(
                    context: action.context,
                    builder: (context) {
                      return WMSDiaLogWidget(
                        titleText: WMSLocalizations.i18n(context)!
                            .login_tip_title_modify_pwd_text,
                        contentText:
                            WMSLocalizations.i18n(context)!.company_has_expired,
                        buttonLeftFlag: false,
                        buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                        onPressedRight: () {
                          // 关闭对话框并返回true
                          action.callback!(false);
                          Navigator.of(context).pop(true);
                        },
                      );
                    },
                  );
                } else {
                  // 统计工具类-初始化
                  StatisticsUtils.init(
                      userData[0]['company_id'], companyPlanData[0]['id']);

                  // 持久化状态
                  StoreProvider.of<WMSState>(action.context).state.loginUser =
                      User.fromJson(userData[0]);

                  // 查询权限
                  List<dynamic> authorityData = await SupabaseUtils.getClient()
                      .rpc('func_zhaoss_query_login_mtb_authority', params: {
                    'role_id': userData[0]['role_id']
                  }).select('*');
                  // 有效权限
                  List<dynamic> validAuthorityData = [];
                  // 循环权限
                  for (var i = 0; i < authorityData.length; i++) {
                    // 权限
                    Map<String, dynamic> authority = authorityData[i];
                    // 判断会社计划基本项与菜单
                    if (authority['menu_path'] == '/instructioninput' ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_5 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_8 ||
                        authority['menu_path'] == '/lackgoodsinvoice' ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_12 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_16 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_21 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_13 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_26 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_3_28) {
                      if (companyPlanData[0]['base_ship'] ==
                          Config.NUMBER_ONE.toString()) {
                        // 有效权限
                        validAuthorityData.add(authority);
                      }
                    } else if (authority['menu_path'] ==
                            '/' + Config.PAGE_FLAG_2_1 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_2_5 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_2_4 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_2_3 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_2_7 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_2_12 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_2_16) {
                      if (companyPlanData[0]['base_receive'] ==
                          Config.NUMBER_ONE.toString()) {
                        // 有效权限
                        validAuthorityData.add(authority);
                      }
                    } else if (authority['menu_path'] ==
                            '/' + Config.PAGE_FLAG_4_1 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_10 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_4 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_8 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_13 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_16 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_17 ||
                        authority['menu_path'] == '/' + Config.PAGE_FLAG_4_18) {
                      if (companyPlanData[0]['base_store'] ==
                          Config.NUMBER_ONE.toString()) {
                        // 有效权限
                        validAuthorityData.add(authority);
                      }
                    } else {
                      // 有效权限
                      validAuthorityData.add(authority);
                    }
                  }
                  // 持久化状态
                  StoreProvider.of<WMSState>(action.context)
                      .state
                      .loginAuthority = validAuthorityData;

                  // 切换语言
                  CommonUtils.changeLocale(
                      StoreProvider.of<WMSState>(action.context),
                      userData[0]['language_id']);
                  // 本地存储
                  LocalStorage.save(
                      Config.LOCALE, userData[0]['language_id'].toString());

                  // 超时工具类-初始化
                  TimeoutUtils.init();
                }
              } else {
                // 状态
                res = false;
                // 持久化状态更新
                StoreProvider.of<WMSState>(action.context).state.login = false;
                // 持久化状态更新
                StoreProvider.of<WMSState>(action.context).state.userInfo =
                    null;
                // 持久化状态
                StoreProvider.of<WMSState>(action.context).state.loginUser =
                    User.empty();
                // 持久化状态
                StoreProvider.of<WMSState>(action.context)
                    .state
                    .loginAuthority = [];
                // 提示弹窗
                showDialog(
                  context: action.context,
                  builder: (context) {
                    return WMSDiaLogWidget(
                      titleText: WMSLocalizations.i18n(context)!
                          .login_tip_title_modify_pwd_text,
                      contentText:
                          WMSLocalizations.i18n(context)!.company_has_expired,
                      buttonLeftFlag: false,
                      buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                      onPressedRight: () {
                        // 关闭对话框并返回true
                        action.callback!(false);
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                );
              }
            }
          } else {
            // 状态
            res = false;
            // 持久化状态更新
            StoreProvider.of<WMSState>(action.context).state.login = false;
            // 持久化状态更新
            StoreProvider.of<WMSState>(action.context).state.userInfo = null;
            // 持久化状态
            StoreProvider.of<WMSState>(action.context).state.loginUser =
                User.empty();
            // 持久化状态
            StoreProvider.of<WMSState>(action.context).state.loginAuthority =
                [];
            // 提示弹窗
            showDialog(
              context: action.context,
              builder: (context) {
                return WMSDiaLogWidget(
                  titleText: WMSLocalizations.i18n(context)!
                      .login_tip_title_modify_pwd_text,
                  contentText:
                      WMSLocalizations.i18n(context)!.company_not_exist,
                  buttonLeftFlag: false,
                  buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
                  onPressedRight: () {
                    //关闭对话框并返回true
                    action.callback!(false);
                    Navigator.of(context).pop(true);
                  },
                );
              },
            );
          }
        }
      } else {
        // 状态
        res = false;
        // 持久化状态更新
        StoreProvider.of<WMSState>(action.context).state.login = false;
        // 持久化状态更新
        StoreProvider.of<WMSState>(action.context).state.userInfo = null;
        // 持久化状态
        StoreProvider.of<WMSState>(action.context).state.loginUser =
            User.empty();
        // 持久化状态
        StoreProvider.of<WMSState>(action.context).state.loginAuthority = [];
        // 提示弹窗
        showDialog(
          context: action.context,
          builder: (context) {
            return WMSDiaLogWidget(
              titleText: WMSLocalizations.i18n(context)!
                  .login_tip_title_modify_pwd_text,
              contentText: WMSLocalizations.i18n(context)!.login_user_error,
              buttonLeftFlag: false,
              buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
              onPressedRight: () {
                // 关闭对话框并返回true
                action.callback!(false);
                Navigator.of(context).pop(true);
              },
            );
          },
        );
      }
      // 赵士淞 - 终
    } else {
      // 状态
      res = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(action.context).state.login = false;
      // 持久化状态更新
      StoreProvider.of<WMSState>(action.context).state.userInfo = null;
      // 持久化状态
      StoreProvider.of<WMSState>(action.context).state.loginUser = User.empty();
      // 持久化状态
      StoreProvider.of<WMSState>(action.context).state.loginAuthority = [];
      // 提示弹窗
      showDialog(
        context: action.context,
        builder: (context) {
          return WMSDiaLogWidget(
            titleText:
                WMSLocalizations.i18n(context)!.login_tip_title_modify_pwd_text,
            contentText: WMSLocalizations.i18n(context)!.login_error,
            buttonLeftFlag: false,
            buttonRightText: WMSLocalizations.i18n(context)!.app_ok,
            onPressedRight: () {
              //关闭对话框并返回true
              action.callback!(false);
              Navigator.of(context).pop(true);
            },
          );
        },
      );
    }
    yield LoginSuccessAction(action.context, res, loginRoleId);
  }

  return actions
      .whereType<LoginAction>()
      .switchMap((action) => _loginIn(action, store));
}
