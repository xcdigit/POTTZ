import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/application_cancel_bloc.dart';
import '../bloc/application_cancel_model.dart';

/**
 * 内容：解约受付-检索
 * 作者：赵士淞
 * 时间：2025/01/08
 */
class ApplicationCancelSearch extends StatefulWidget {
  const ApplicationCancelSearch({super.key});

  @override
  State<ApplicationCancelSearch> createState() =>
      _ApplicationCancelSearchState();
}

class _ApplicationCancelSearchState extends State<ApplicationCancelSearch> {
  // 当前悬停标记
  bool _currentHoverFlag = false;

  // 构建检索单项
  Widget _buildQueryItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text + '：' + value,
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // 判断下标
              if (index == 1) {
                // 保存检索：公司事件
                context
                    .read<ApplicationCancelBloc>()
                    .add(SaveQueryCompanyEvent(Config.NUMBER_ZERO, ''));
              } else if (index == 2) {
                // 保存检索：用户名称事件
                context
                    .read<ApplicationCancelBloc>()
                    .add(SaveQueryUserNameEvent(''));
              } else if (index == 3) {
                // 保存检索：用户邮箱事件
                context
                    .read<ApplicationCancelBloc>()
                    .add(SaveQueryUserEmailEvent(''));
              }
            },
            child: Icon(
              Icons.close,
              color: Color.fromRGBO(156, 156, 156, 1),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 构建按钮
  _buildButtom(String text, int index) {
    return Container(
      color: Colors.white,
      height: 48,
      width: 220,
      child: OutlinedButton(
        onPressed: () {
          // 判断按钮
          if (index == 0) {
            // 搜索按钮事件
            context.read<ApplicationCancelBloc>().add(SearchButtonEvent());
          } else if (index == 1) {
            // 重置按钮事件
            context.read<ApplicationCancelBloc>().add(ResetButtonEvent());
          } else {}
        },
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(
            Colors.black,
          ),
          side: MaterialStateProperty.all(
            const BorderSide(
              width: 1,
              color: Color.fromRGBO(44, 167, 176, 1),
            ),
          ),
        ),
      ),
    );
  }

  // 构建文本
  _buildText(String title) {
    return Container(
      height: 24,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  // 构建查询单项
  Widget _buildSearchItem(int index, String text, String value) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color.fromRGBO(244, 244, 244, 1),
          width: 1.0,
        ),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text + '：' + value,
            style: TextStyle(
              color: Color.fromRGBO(156, 156, 156, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              // 判断下标
              if (index == 1) {
                // 保存查询：公司事件
                context
                    .read<ApplicationCancelBloc>()
                    .add(SaveSearchCompanyEvent(Config.NUMBER_ZERO, ''));
              } else if (index == 2) {
                // 保存查询：用户名称事件
                context
                    .read<ApplicationCancelBloc>()
                    .add(SaveSearchUserNameEvent(''));
              } else if (index == 3) {
                // 保存查询：用户邮箱事件
                context
                    .read<ApplicationCancelBloc>()
                    .add(SaveSearchUserEmailEvent(''));
              }
            },
            child: Icon(
              Icons.close,
              color: Color.fromRGBO(156, 156, 156, 1),
              size: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 初始化检索列表
  List<Widget> _initSearchList(ApplicationCancelModel state) {
    return [
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          constraints: BoxConstraints(
            minHeight: 48,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Color.fromRGBO(224, 224, 224, 1),
              width: 1.0,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                height: 34,
                child: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_11,
                  style: TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                ),
              ),
              Visibility(
                visible: state.searchCompanyName != '',
                child: _buildSearchItem(
                    1,
                    WMSLocalizations.i18n(context)!.app_cceptance_company_name,
                    state.searchCompanyName),
              ),
              Visibility(
                visible: state.searchUserName != '',
                child: _buildSearchItem(
                    2,
                    WMSLocalizations.i18n(context)!.app_cceptance_user_name,
                    state.searchUserName),
              ),
              Visibility(
                visible: state.searchUserEmail != '',
                child: _buildSearchItem(
                    3,
                    WMSLocalizations.i18n(context)!.app_cceptance_user_email,
                    state.searchUserEmail),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.3,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(
                  WMSLocalizations.i18n(context)!.app_cceptance_company_name),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSDropdownWidget(
                  dataList1: state.companyList,
                  inputInitialValue: state.searchCompanyName,
                  inputRadius: 4,
                  inputSuffixIcon: Container(
                    width: 24,
                    height: 24,
                    margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  dropdownRadius: 4,
                  dropdownTitle: 'name',
                  selectedCallBack: (value) {
                    // 保存查询：公司ID事件
                    context.read<ApplicationCancelBloc>().add(
                        SaveSearchCompanyEvent(value['id'], value['name']));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.3,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(
                  WMSLocalizations.i18n(context)!.app_cceptance_user_name),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchUserName,
                  inputBoxCallBack: (value) {
                    // 保存查询：用户名称事件
                    context
                        .read<ApplicationCancelBloc>()
                        .add(SaveSearchUserNameEvent(value));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.3,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(
                  WMSLocalizations.i18n(context)!.app_cceptance_user_email),
              Container(
                margin: EdgeInsets.only(
                  top: 5,
                ),
                child: WMSInputboxWidget(
                  text: state.searchUserEmail,
                  inputBoxCallBack: (value) {
                    // 保存查询：用户邮箱事件
                    context
                        .read<ApplicationCancelBloc>()
                        .add(SaveSearchUserEmailEvent(value));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: EdgeInsets.only(
            top: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_24,
                0,
              ),
              SizedBox(
                width: 32,
              ),
              _buildButtom(
                WMSLocalizations.i18n(context)!.delivery_note_25,
                1,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // 检索按钮
  _searchButton(ApplicationCancelModel state) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 48,
            child: MouseRegion(
              onEnter: (event) {
                // 状态变更
                setState(() {
                  // 当前悬停标记
                  _currentHoverFlag = true;
                });
              },
              onExit: (event) {
                // 状态变更
                setState(() {
                  // 当前悬停标记
                  _currentHoverFlag = false;
                });
              },
              child: OutlinedButton.icon(
                onPressed: () {
                  // 保存检索按钮标记事件
                  context
                      .read<ApplicationCancelBloc>()
                      .add(SaveQueryButtonFlag(!state.queryButtonFlag));
                  // 状态变更
                  setState(() {
                    // 当前悬停标记
                    _currentHoverFlag = false;
                  });
                },
                icon: ColorFiltered(
                  colorFilter: state.queryButtonFlag
                      ? ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )
                      : _currentHoverFlag
                          ? ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            )
                          : ColorFilter.mode(
                              Color.fromRGBO(0, 122, 255, 1),
                              BlendMode.srcIn,
                            ),
                  child: Image.asset(
                    WMSICons.WAREHOUSE_MENU_ICON,
                    height: 24,
                  ),
                ),
                label: Text(
                  WMSLocalizations.i18n(context)!.delivery_note_1,
                  style: TextStyle(
                    color: state.queryButtonFlag
                        ? Colors.white
                        : _currentHoverFlag
                            ? Colors.white
                            : Color.fromRGBO(0, 122, 255, 1),
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: state.queryButtonFlag
                      ? Color.fromRGBO(0, 122, 255, 1)
                      : _currentHoverFlag
                          ? Color.fromRGBO(0, 122, 255, .6)
                          : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCancelBloc, ApplicationCancelModel>(
      builder: (context, state) {
        return Column(
          children: [
            // 检索按钮
            _searchButton(state),
            // 检索详情
            Visibility(
              visible: state.queryButtonFlag,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 30,
                    ),
                    padding: EdgeInsets.fromLTRB(32, 30, 32, 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        width: 1.0,
                      ),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        children: _initSearchList(state),
                      ),
                    ),
                  ),
                  // 关闭检索窗口按钮
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: Offset(-10, 20),
                      child: InkWell(
                        onTap: () {
                          // 保存检索按钮标记事件
                          context
                              .read<ApplicationCancelBloc>()
                              .add(SaveQueryButtonFlag(false));
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(44, 167, 176, 1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black12,
                              width: 0.5,
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 检索详情
            Visibility(
              visible: state.queryCompanyName != '' ||
                  state.queryUserName != '' ||
                  state.queryUserEmail != '',
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  constraints: BoxConstraints(
                    minHeight: 48,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Color.fromRGBO(224, 224, 224, 1),
                      width: 1.0,
                    ),
                  ),
                  child: Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 6, 0, 6),
                        padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                        height: 34,
                        child: Text(
                          WMSLocalizations.i18n(context)!.delivery_note_11,
                          style:
                              TextStyle(color: Color.fromRGBO(0, 122, 255, 1)),
                        ),
                      ),
                      Visibility(
                        visible: state.queryCompanyName != '',
                        child: _buildQueryItem(
                            1,
                            WMSLocalizations.i18n(context)!
                                .app_cceptance_company_name,
                            state.queryCompanyName),
                      ),
                      Visibility(
                        visible: state.queryUserName != '',
                        child: _buildQueryItem(
                            2,
                            WMSLocalizations.i18n(context)!
                                .app_cceptance_user_name,
                            state.queryUserName),
                      ),
                      Visibility(
                        visible: state.queryUserEmail != '',
                        child: _buildQueryItem(
                            3,
                            WMSLocalizations.i18n(context)!
                                .app_cceptance_user_email,
                            state.queryUserEmail),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
