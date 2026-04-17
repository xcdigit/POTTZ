import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/corporate_management_bloc.dart';
import '../bloc/corporate_management_model.dart';

/**
 * 内容：法人管理-契約内容の確認
 * 作者：muzd
 * 时间：2024/06/25
 */
class CorporateManagementConfirm extends StatefulWidget {
  const CorporateManagementConfirm({super.key});

  @override
  State<CorporateManagementConfirm> createState() =>
      _CorporateManagementConfirmState();
}

class _CorporateManagementConfirmState
    extends State<CorporateManagementConfirm> {
  // 初始化搜索列表
  List<Widget> _initSearchList() {
    // 搜索列表
    List<Widget> searchList = [];

    searchList.add(
      Container(
        width: 464,
        child: WMSInputboxWidget(
          backgroundColor: Color.fromRGBO(251, 251, 251, 1),
          borderColor: Color.fromRGBO(224, 224, 224, 1),
          text: context
              .read<CorporateManagementBloc>()
              .state
              .searchContent
              .toString(),
          hintText:
              WMSLocalizations.i18n(context)!.corporate_management_text_14,
          prefixIcon: Image.asset(
            WMSICons.HOME_HEAD_SEARCH,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
          ),
          inputBoxCallBack: (value) {
            // 设置搜索内容事件
            context
                .read<CorporateManagementBloc>()
                .add(SetSearchContentEvent(value));
          },
        ),
      ),
    );

    searchList.add(
      GestureDetector(
        onPanDown: (details) {
          // 显示用户类型弹窗
          _showUserTypeDialog();
        },
        child: Container(
          width: 94,
          height: 37,
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context
                            .read<CorporateManagementBloc>()
                            .state
                            .searchUserTypeIndex ==
                        Config.NUMBER_NEGATIVE
                    ? '絞り込み'
                    : context
                            .read<CorporateManagementBloc>()
                            .state
                            .userTypeList[
                        context
                            .read<CorporateManagementBloc>()
                            .state
                            .searchUserTypeIndex]['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
              Image.asset(
                WMSICons.HOME_HEAD_MORE,
                width: 20,
                height: 32,
                fit: BoxFit.contain,
                repeat: ImageRepeat.noRepeat,
              ),
            ],
          ),
        ),
      ),
    );

    return searchList;
  }

  // 显示用户类型弹窗
  _showUserTypeDialog() {
    // 初始化用户类型列表
    List<Widget> _initUserTypeList(
        BuildContext dialogContext, List userTypeItemList) {
      // 用户类型列表
      List<Widget> userTypeList = [];

      // 循环用户列表
      for (int i = 0; i < userTypeItemList.length; i++) {
        // 用户类型列表
        userTypeList.add(
          GestureDetector(
            onPanDown: (details) {
              // 变更搜索用户类型下标事件
              context.read<CorporateManagementBloc>().add(
                  ChangeSearchUserTypeIndexEvent(
                      dialogContext, userTypeItemList[i]['index']));
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Text(
                userTypeItemList[i]['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
            ),
          ),
        );
      }

      return userTypeList;
    }

    showDialog(
      context: context,
      barrierColor: Color.fromRGBO(255, 255, 255, 0),
      builder: (dialogContext) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: 256,
                left: 1080,
                child: Stack(
                  children: [
                    Container(
                      width: 148,
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(156, 156, 156, 0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _initUserTypeList(
                            dialogContext,
                            context
                                .read<CorporateManagementBloc>()
                                .state
                                .userTypeList),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 初始化用户列表
  List<Widget> _initUserList(List userItemList) {
    // 用户列表
    List<Widget> userList = [];

    // 循环用户列表
    for (int i = 0; i < userItemList.length; i++) {
      // 用户列表
      userList.add(
        Container(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                WMSICons.PLAN_ICON,
                width: 30,
                height: 30,
              ),
              Text(
                userItemList[i]['company_name'] != null
                    ? userItemList[i]['company_name']
                    : '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Text(
                userItemList[i]['user_email'] != null
                    ? userItemList[i]['user_email']
                    : '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              Text(
                (userItemList[i]['postal_cd'] != null
                        ? ('〒' + userItemList[i]['postal_cd'] + ' ')
                        : '') +
                    (userItemList[i]['addr_1'] != null
                        ? userItemList[i]['addr_1']
                        : '') +
                    (userItemList[i]['addr_2'] != null
                        ? userItemList[i]['addr_2']
                        : '') +
                    (userItemList[i]['addr_3'] != null
                        ? userItemList[i]['addr_3']
                        : ''),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(6, 14, 15, 1),
                ),
              ),
              GestureDetector(
                onPanDown: (details) {
                  // 账户确认事件
                  context
                      .read<CorporateManagementBloc>()
                      .add(AccountConfirmEvent(i));
                },
                child: Text(
                  WMSLocalizations.i18n(context)!.corporate_management_button_3,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(0, 122, 255, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CorporateManagementBloc, CorporateManagementModel>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: 954,
              height: 48,
              child: Row(
                children: _initSearchList(),
              ),
            ),
            Container(
              width: 1024,
              height: 32,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(224, 224, 224, 1),
                  ),
                ),
              ),
            ),
            Container(
              width: 954,
              child: Column(
                children: _initUserList(
                    context.read<CorporateManagementBloc>().state.userList),
              ),
            ),
          ],
        );
      },
    );
  }
}
