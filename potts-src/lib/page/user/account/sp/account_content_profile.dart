import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../../../home/bloc/home_menu_bloc.dart' as ds_home_menu_bloc;
import '../../../home/bloc/home_menu_model.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';

/**
 * 内容：账户-内容简介-SP
 * 作者：熊草云
 * 时间：2023/11/01
 */
class AccountContentProfile extends StatefulWidget {
  const AccountContentProfile({super.key});

  @override
  State<AccountContentProfile> createState() => _AccountContentProfileState();
}

class _AccountContentProfileState extends State<AccountContentProfile> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) {
        return AccountBloc(
          AccountModel(
            rootContext: context,
          ),
        );
      },
      child: BlocBuilder<AccountBloc, AccountModel>(
        builder: (context, state) {
          // 判断切换标记
          if (state.switchFlag) {
            // 切换标记
            state.switchFlag = false;
            // 保存位置标记和位置下标
            context.read<AccountBloc>().add(
                SaveLocationFlagAndLocationIndexEvent(
                    false, Config.NUMBER_ZERO));
          }

          return Scaffold(
            backgroundColor: Color.fromRGBO(102, 199, 206, 0.1),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: AccountContentProfileList(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// 账户-内容简介-列表
class AccountContentProfileList extends StatefulWidget {
  const AccountContentProfileList({super.key});

  @override
  State<AccountContentProfileList> createState() =>
      _AccountContentProfileListState();
}

class _AccountContentProfileListState extends State<AccountContentProfileList> {
  // 初始化简介列表
  List<Widget> _initProfileList(List profileItemList, AccountModel state) {
    // 简介列表
    List<Widget> profileList = [];
    // 循环简介单个列表
    for (int i = 0; i < profileItemList.length; i++) {
      // 简介列表
      profileList.add(
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        profileItemList[i]['icon'],
                        width: 44,
                        height: 44,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileItemList[i]['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(6, 14, 15, 1),
                                height: 1.12,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              constraints: BoxConstraints(
                                maxWidth: 197,
                              ),
                              child: Text(
                                profileItemList[i]['content'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(6, 14, 15, 1),
                                  height: 1.28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: Visibility(
                      visible: profileItemList[i]['button'],
                      maintainState: true,
                      child: GestureDetector(
                        onPanDown: (details) {
                          if (profileItemList[i]['index'] ==
                              Config.NUMBER_FIVE) {
                            GoRouter.of(context)
                                .push('/' +
                                    Config.PAGE_FLAG_50_1 +
                                    '/profile/detail/' +
                                    Config.NUMBER_FIVE.toString())
                                .then((value) {
                              // 判断返回值
                              if (value == 'refresh return') {
                                // 初始化事件
                                context
                                    //重新加载页面
                                    .read<AccountBloc>()
                                    .add(InitEvent());
                              }
                            });
                            // context.read<ds_home_menu_bloc.HomeMenuBloc>().add(
                            //       ds_home_menu_bloc.PageJumpEvent('/' +
                            //           Config.PAGE_FLAG_50_1 +
                            //           '/profile/detail/' +
                            //           Config.NUMBER_FIVE.toString()),
                            //     );
                          } else if (profileItemList[i]['index'] ==
                              Config.NUMBER_TWO) {
                            GoRouter.of(context)
                                .push('/' +
                                    Config.PAGE_FLAG_50_1 +
                                    '/profile/detail/' +
                                    Config.NUMBER_TWO.toString())
                                .then((value) {
                              // 判断返回值
                              if (value == 'refresh return') {
                                // 初始化事件
                                context
                                    //重新加载页面
                                    .read<AccountBloc>()
                                    .add(InitEvent());
                              }
                            });
                            // context.read<ds_home_menu_bloc.HomeMenuBloc>().add(
                            //       ds_home_menu_bloc.PageJumpEvent('/' +
                            //           Config.PAGE_FLAG_50_1 +
                            //           '/profile/detail/' +
                            //           Config.NUMBER_TWO.toString()),
                            //     );
                          } else {
                            GoRouter.of(context)
                                .push('/' +
                                    Config.PAGE_FLAG_50_1 +
                                    '/profile/detail/' +
                                    Config.NUMBER_ONE.toString())
                                .then((value) {
                              // 判断返回值
                              if (value == 'refresh return') {
                                // 初始化事件
                                context
                                    //重新加载页面
                                    .read<AccountBloc>()
                                    .add(InitEvent());
                              }
                            });
                          }
                        },
                        child: Text(
                          profileItemList[i]['index'] == Config.NUMBER_FIVE
                              ? WMSLocalizations.i18n(context)!
                                  .contract_cancel_1
                              : WMSLocalizations.i18n(context)!
                                  .account_profile_edit,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 122, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // 简介列表
    return profileList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountModel>(
      builder: (context, state) {
        // 简介单个列表
        List _profileItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_USER,
            'title': WMSLocalizations.i18n(context)!.account_profile_user,
            'content':
                StoreProvider.of<WMSState>(context).state.userInfo?.login ?? '',
            'button': false,
          },
          {
            'index': Config.NUMBER_ONE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_RENAME,
            'title': WMSLocalizations.i18n(context)!.account_profile_display,
            'content': state.userCustomize['name'] ?? '',
            'button': true,
          },
          {
            'index': Config.NUMBER_TWO,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_LANGUAGE,
            'title': WMSLocalizations.i18n(context)!.account_profile_language,
            'content': state.userCustomize['language_name'] ?? '',
            'button': true,
          },
          {
            'index': Config.NUMBER_THREE,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_COMPANY,
            'title': WMSLocalizations.i18n(context)!.account_profile_company,
            'content': state.userCustomize['company_name'] ?? '',
            'button': false,
          },
          {
            'index': Config.NUMBER_FOUR,
            'icon': WMSICons.ACCOUNT_CONTENT_PROFILE_ROLE,
            'title': WMSLocalizations.i18n(context)!.account_profile_roll,
            'content': state.userCustomize['role_name'] ?? '',
            'button': false,
          },
        ];

        return BlocBuilder<ds_home_menu_bloc.HomeMenuBloc, HomeMenuModel>(
          builder: (menuBloc, menuState) {
            return Column(
              children: _initProfileList(_profileItemList, state),
            );
          },
        );
      },
    );
  }
}

// 账户-内容简介-表单
class AccountContentProfileForm extends StatefulWidget {
  final int action;
  const AccountContentProfileForm({super.key, required this.action});

  @override
  State<AccountContentProfileForm> createState() =>
      _AccountContentProfileFormState();
}

class _AccountContentProfileFormState extends State<AccountContentProfileForm> {
  // 初始化表单内容
  Widget _initFormContent(AccountModel state) {
    if (state.switchFlag) {
      // 切换标记
      state.switchFlag = false;
      // 保存位置标记和位置下标
      context.read<AccountBloc>().add(
          SaveLocationFlagAndLocationIndexEvent(false, Config.NUMBER_ZERO));
    }

    // 判断下标
    if (widget.action == Config.NUMBER_FIVE) {
      return Container();
    } else if (widget.action == Config.NUMBER_TWO) {
      // 多语言下拉
      return Container(
        margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: WMSDropdownWidget(
          dataList1: state.languageList,
          inputInitialValue: state.userCustomize['language_name'].toString(),
          inputHeight: 52,
          inputBorderColor: Color.fromRGBO(255, 255, 255, 1),
          inputHintText:
              WMSLocalizations.i18n(context)!.account_profile_language_new,
          inputHintFontColor: Color.fromRGBO(156, 156, 156, 1),
          dropdownRadius: 5,
          dropdownTitle: 'name',
          selectedCallBack: (value) {
            // 临时值
            state.tempValue = value;
          },
        ),
      );
    } else {
      // 输入框系列
      return Container(
        margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: WMSInputboxWidget(
          text: widget.action == Config.NUMBER_ONE
              ? state.userCustomize['name']
              : '',
          height: 52,
          borderColor: Color.fromRGBO(255, 255, 255, 1),
          hintText: widget.action == Config.NUMBER_ONE
              ? WMSLocalizations.i18n(context)!.account_profile_display_new
              : '',
          hintFontColor: Color.fromRGBO(156, 156, 156, 1),
          inputBoxCallBack: (value) {
            // 临时值
            state.tempValue = value;
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) {
        return AccountBloc(
          AccountModel(
            rootContext: context,
          ),
        );
      },
      child: BlocBuilder<AccountBloc, AccountModel>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Color.fromRGBO(102, 199, 206, 0.1),
            body: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.action == Config.NUMBER_ONE
                              ? WMSLocalizations.i18n(context)!
                                  .account_profile_display_change
                              : widget.action == Config.NUMBER_TWO
                                  ? WMSLocalizations.i18n(context)!
                                      .account_profile_language_change
                                  : widget.action == Config.NUMBER_FIVE
                                      ? WMSLocalizations.i18n(context)!
                                          .contract_cancel_2
                                      : '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(6, 14, 15, 1),
                          ),
                        ),
                        _initFormContent(state),
                        SizedBox(height: 60),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onPanDown: (details) {
                                // 保存位置标记和位置下标
                                context.read<AccountBloc>().add(
                                    SaveLocationFlagAndLocationIndexEvent(
                                        false, Config.NUMBER_ZERO));
                                //返回上一页
                                GoRouter.of(context).pop();
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromRGBO(44, 167, 176, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                                child: Center(
                                  child: Text(
                                    WMSLocalizations.i18n(context)!
                                        .account_profile_cancel,
                                    style: TextStyle(
                                      color: Color.fromRGBO(44, 167, 176, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // 判断位置下标
                                if (widget.action == Config.NUMBER_ONE) {
                                  // 保存账户事件
                                  context.read<AccountBloc>().add(
                                      SaveUserEvent({'name': state.tempValue}));
                                } else if (widget.action == Config.NUMBER_TWO) {
                                  // 保存账户事件
                                  context.read<AccountBloc>().add(SaveUserEvent(
                                      {'language_id': state.tempValue['id']}));
                                } else if (widget.action ==
                                    Config.NUMBER_FIVE) {
                                  // 送信->解約
                                  context
                                      .read<AccountBloc>()
                                      .add(SendCancellationMailEvent());
                                }
                              },
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color.fromRGBO(44, 167, 176, 1),
                                ),
                                margin: EdgeInsets.fromLTRB(20, 16, 20, 16),
                                child: Center(
                                  child: Text(
                                    widget.action == Config.NUMBER_FIVE
                                        ? WMSLocalizations.i18n(context)!
                                            .login_confirm_text
                                        : WMSLocalizations.i18n(context)!
                                            .account_profile_registration,
                                    style: TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
