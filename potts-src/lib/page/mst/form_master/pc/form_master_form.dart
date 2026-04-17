import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/config/config.dart';
import '../../../../common/localization/default_localizations.dart';
import '../../../../common/style/wms_style.dart';
import '../../../../file/wms_common_file.dart';
import '../../../../redux/current_flag_reducer.dart';
import '../../../../redux/wms_state.dart';
import '../../../../widget/wms_dropdown_widget.dart';
import '../../../../widget/wms_inputbox_widget.dart';
import '../bloc/form_master_bloc.dart';
import '../bloc/form_master_model.dart';
import 'form_master_title.dart';

/**
 * 内容：帳票マスタ-表单
 * 作者：赵士淞
 * 时间：2023/12/22
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前悬停下标
int currentHoverIndex = Config.NUMBER_NEGATIVE;
// 当前内容
Widget currentContent = Wrap();

class FormMasterForm extends StatefulWidget {
  const FormMasterForm({super.key});

  @override
  State<FormMasterForm> createState() => _FormMasterFormState();
}

class _FormMasterFormState extends State<FormMasterForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormMasterBloc>(
      create: (context) {
        return FormMasterBloc(
          FormMasterModel(rootContext: context),
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
              FormMasterTitle(
                flag: 'change',
              ),
              // 表单内容
              FormMasterFormContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class FormMasterFormContent extends StatefulWidget {
  const FormMasterFormContent({super.key});

  @override
  State<FormMasterFormContent> createState() => _FormMasterFormContentState();
}

class _FormMasterFormContentState extends State<FormMasterFormContent> {
  // 初始化基本情報表单
  Widget _initFormBasic(FormMasterModel state) {
    return BlocBuilder<FormMasterBloc, FormMasterModel>(
      builder: (context, state) {
        return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            // 区分
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.form_distinguish,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDropdownWidget(
                      dataList1: state.formKbnList,
                      inputInitialValue: state.formCustomize['form_kbn_title'],
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
                      dropdownKey: 'index',
                      dropdownTitle: 'title',
                      selectedCallBack: (value) {
                        // 设定账票值事件
                        context
                            .read<FormMasterBloc>()
                            .add(SetFormValueEvent('form_kbn', value['index']));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 纸张方向
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.form_paper_rotation,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSDropdownWidget(
                      dataList1: state.formDirectionList,
                      inputInitialValue:
                          state.formCustomize['form_direction_title'],
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
                      dropdownKey: 'index',
                      dropdownTitle: 'title',
                      selectedCallBack: (value) {
                        // 设定账票值事件
                        context.read<FormMasterBloc>().add(SetFormValueEvent(
                            'form_direction', value['index']));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 会社图标
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.form_company_icon,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // 打开加载状态
                        BotToast.showLoading();
                        // 上传图片文件
                        WMSCommonFile().uploadImageFile(
                            'form/' +
                                StoreProvider.of<WMSState>(context)
                                    .state
                                    .loginUser!
                                    .company_id
                                    .toString(),
                            '',
                            _uploadImageFileCallBack);
                      },
                      child: state.formCustomize['form_picture_network'] ==
                                  null ||
                              state.formCustomize['form_picture_network'] == ''
                          ? Image.asset(
                              WMSICons.NO_IMAGE,
                              width: 136,
                              height: 136,
                            )
                          : Image.network(
                              state.formCustomize['form_picture_network'],
                              width: 136,
                              height: 136,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            // 説明
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.form_paper_explanation,
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
                      text: state.formCustomize['description'].toString(),
                      inputBoxCallBack: (value) {
                        // 设定账票值事件
                        context
                            .read<FormMasterBloc>()
                            .add(SetFormValueEvent('description', value));
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

  // 上传图片文件回调函数
  void _uploadImageFileCallBack(String content) {
    // 判断内容信息
    if (content == WMSCommonFile.SIZE_EXCEEDS) {
      // 消息提示
      WMSCommonBlocUtils.tipTextToast(
          WMSLocalizations.i18n(context)!.image_size_need_within_2m);
    } else {
      // 设定账票值事件
      context
          .read<FormMasterBloc>()
          .add(SetFormValueEvent('form_picture', content));
    }
    // 关闭加载状态
    BotToast.closeAllLoading();
  }

  @override
  Widget build(BuildContext context) {
    // 数据取出
    Map<String, dynamic> data =
        StoreProvider.of<WMSState>(context).state.currentParam;
    return BlocBuilder<FormMasterBloc, FormMasterModel>(
      builder: (context, state) {
        // 判断参数状态
        if (StoreProvider.of<WMSState>(context).state.currentFlag) {
          // 判断新增还是修改
          if (data['id'] != null && data['id'] != '') {
            // 查询账票定制事件
            context
                .read<FormMasterBloc>()
                .add(QueryFormCustomizeEvent(data['id']));
          }
          // 控制刷新
          StoreProvider.of<WMSState>(context)
              .dispatch(RefreshCurrentFlagAction(false));
        }

        // 判断当前下标
        if (currentIndex == Config.NUMBER_ZERO) {
          // 当前内容
          currentContent = _initFormBasic(state);
        }
        return Container(
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
                        child: FormMasterFormTab(
                          initFormBasic: _initFormBasic,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: FormMasterFormButton(),
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
                  child: currentContent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 帳票マスタ-表单Tab
typedef TabContextBuilder = Widget Function(FormMasterModel state);

// ignore: must_be_immutable
class FormMasterFormTab extends StatefulWidget {
  // 初始化基本情報表单
  TabContextBuilder initFormBasic;

  FormMasterFormTab({
    super.key,
    required this.initFormBasic,
  });

  @override
  State<FormMasterFormTab> createState() => _FormMasterFormTabState();
}

class _FormMasterFormTabState extends State<FormMasterFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, FormMasterModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 判断当前下标
    if (currentIndex == Config.NUMBER_ZERO) {
      // 当前内容
      currentContent = widget.initFormBasic(state);
    } else {
      // 当前内容
      currentContent = Wrap();
    }
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = tabItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onPanDown: (details) {
              // 状态变更
              setState(() {
                // 当前下标
                currentIndex = tabItemList[i]['index'];
              });
            },
            child: Container(
              height: 46,
              padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              decoration: BoxDecoration(
                color: currentIndex == tabItemList[i]['index']
                    ? Color.fromRGBO(44, 167, 176, 1)
                    : currentHoverIndex == tabItemList[i]['index']
                        ? Color.fromRGBO(44, 167, 176, 0.6)
                        : Color.fromRGBO(245, 245, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              constraints: BoxConstraints(
                minWidth: 160,
              ),
              child: Text(
                tabItemList[i]['title'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: currentIndex == tabItemList[i]['index']
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : currentHoverIndex == tabItemList[i]['index']
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Tab列表
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

    return BlocBuilder<FormMasterBloc, FormMasterModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 帳票マスタ-表单按钮
class FormMasterFormButton extends StatefulWidget {
  const FormMasterFormButton({super.key});

  @override
  State<FormMasterFormButton> createState() => _FormMasterFormButtonState();
}

class _FormMasterFormButtonState extends State<FormMasterFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];
    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 37,
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(44, 167, 176, 1),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(80, 37),
              ),
            ),
            onPressed: () {
              // 判断循环下标
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 清除账票定制事件
                context.read<FormMasterBloc>().add(CleanFormCustomizeEvent());
              } else if (buttonItemList[i]['index'] == Config.NUMBER_ONE) {
                // 保存账票定制事件
                context.read<FormMasterBloc>().add(SaveFormCustomizeEvent());
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
        'title': context.read<FormMasterBloc>().state.formCustomize['id'] ==
                    null ||
                context.read<FormMasterBloc>().state.formCustomize['id'] == ''
            ? WMSLocalizations.i18n(context)!.instruction_input_tab_button_add
            : WMSLocalizations.i18n(context)!
                .instruction_input_tab_button_update,
      },
    ];

    return Row(
      children: _initButtonList(_buttonItemList),
    );
  }
}
