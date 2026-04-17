import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wms/page/biz/inbound/stock/bloc/reserve_input_model.dart';
import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../widget/wms_date_widget.dart';
import '../../../../../widget/wms_dropdown_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../../../../../widget/wms_postal_code_widget.dart';
import '../bloc/reserve_input_bloc.dart';

/**
 * 内容：入荷予定入力
 * 作者：王光顺
 * 时间：2023/08/18
 * 作者：luxy
 * 时间：2023/10/17
 */
// 当前下标
int currentIndex = Config.NUMBER_ZERO;
// 当前内容
Widget currentContent = Wrap();

class ReserveInputForm extends StatefulWidget {
  const ReserveInputForm({super.key});

  @override
  State<ReserveInputForm> createState() => _ReserveInputFormState();
}

class _ReserveInputFormState extends State<ReserveInputForm> {
  // 初始化基本情報入力表单
  Widget _initFormBasic(ReserveInputModel state) {
    return BlocBuilder<ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
      return Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Text(
                WMSLocalizations.i18n(context)!
                        .incoming_inspection_expected_id +
                    "：${state.customerList['receive_no'] ?? ''}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  height: .5,
                  color: Color.fromRGBO(44, 167, 176, 1),
                ),
              ),
            ),
            FractionallySizedBox(
                widthFactor: 1,
                child: SizedBox(
                  height: 25,
                )),
            // 入荷予定日
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .home_main_page_table_text1, //1
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
                        text: state.customerList['rcv_sch_date'],
                        dateCallBack: (value) {
                          // 设定出荷指示值事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveValueEvent('rcv_sch_date', value));
                        }),
                  ],
                ),
              ),
            ),
            // 仕入先注文番号
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .menu_content_2_5_7, //2
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
                      text: state.customerList['order_no'],
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<ReserveInputBloc>()
                            .add(SetReserveValueEvent('order_no', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 仕入先名
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!.reserve_input_6, //3
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
                      dataList1: state.supplierList,
                      inputInitialValue: state.customerList['name'].toString(),
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
                          // 设定出荷指示集合事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveMapEvent({
                                'supplier_id': value,
                                'name': value,
                                'name_kana': value,
                                'postal_cd': value,
                                'addr_1': value,
                                'addr_2': value,
                                'addr_3': value,
                                'addr_tel': value,
                                'customer_fax': value,
                                'note1': value,
                              }));
                        } else if (value is String) {
                          // 设定出荷指示值事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveValueEvent('name', value));
                        } else {
                          // 设定出荷指示集合事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveMapEvent({
                                'supplier_id': value['id'],
                                'name': value['name'],
                                'name_kana': value['name_kana'],
                                'postal_cd': value['postal_cd'],
                                'addr_1': value['addr_1'],
                                'addr_2': value['addr_2'],
                                'addr_3': value['addr_3'],
                                'addr_tel': value['tel'],
                                'customer_fax': value['fax'],
                                'note1': value['company_note1'],
                              }));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // カナ名称
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_basic_kana, //3
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
                        text: state.customerList['name_kana'],
                        inputBoxCallBack: (value) {
                          // 设定出荷指示值事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveValueEvent('name_kana', value));
                        }),
                  ],
                ),
              ),
            ),
            // 郵便番号
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_basic_zip_code, //3
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
                    // WMSInputboxWidget(
                    //     text: state.customerList['postal_cd'],
                    //     inputBoxCallBack: (value) {
                    //       // 设定出荷指示值事件
                    //       context
                    //           .read<ReserveInputBloc>()
                    //           .add(SetShipValueEvent('postal_cd', value));
                    //     }),
                    WMSPostalcodeWidget(
                      text: state.customerList['postal_cd'].toString(),
                      country: 'JP',
                      postalCodeCallBack: (value) {
                        context.read<ReserveInputBloc>().add(
                            SetReserveValueEvent(
                                'postal_cd', value['postal_code']));
                        if (value['code'] == '0') {
                          //设定都道府县和市町村
                          context.read<ReserveInputBloc>().add(
                              SetReserveValueEvent(
                                  'addr_1', value['data']['city']));
                          context.read<ReserveInputBloc>().add(
                              SetReserveValueEvent(
                                  'addr_2', value['data']['region']));
                          context.read<ReserveInputBloc>().add(
                              SetReserveValueEvent(
                                  'addr_3', value['data']['addr']));
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            // 都道府県
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_province, //3
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
                      text: state.customerList['addr_1'],
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<ReserveInputBloc>()
                            .add(SetReserveValueEvent('addr_1', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 市区町村
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_villages, //3
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
                      text: state.customerList['addr_2'],
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<ReserveInputBloc>()
                            .add(SetReserveValueEvent('addr_2', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 住所
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_address, //3
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
                      text: state.customerList['addr_3'],
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<ReserveInputBloc>()
                            .add(SetReserveValueEvent('addr_3', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 電話番号
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
                      child: Row(
                        children: [
                          Text(
                            WMSLocalizations.i18n(context)!
                                .supplier_contact_telephone_number, //3
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
                      numberIME: true,
                      text: state.customerList['addr_tel'],
                      inputBoxCallBack: (value) {
                        // 设定出荷指示值事件
                        context
                            .read<ReserveInputBloc>()
                            .add(SetReserveValueEvent('addr_tel', value));
                      },
                    ),
                  ],
                ),
              ),
            ),
            // FAX番号
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
                            .supplier_contact_fax_number, //3
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                        text: state.customerList['customer_fax'],
                        inputBoxCallBack: (value) {
                          // 设定出荷指示值事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveValueEvent('customer_fax', value));
                        }),
                  ],
                ),
              ),
            ),
            // 取込状態
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
                            .display_instruction_ingestion_state, //3
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                        text: state.customerList['importerror_flg'],
                        readOnly: true,
                        inputBoxCallBack: (value) {
                          // 设定出荷指示值事件
                          context.read<ReserveInputBloc>().add(
                              SetReserveValueEvent('importerror_flg', value));
                        }),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //占位
              widthFactor: 0.3,
              child: Container(
                height: 72,
              ),
            ),
            //
            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.reserve_input_7, //4
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    WMSInputboxWidget(
                        text: state.customerList['note1'],
                        height: 136,
                        maxLines: 5,
                        inputBoxCallBack: (value) {
                          // 设定出荷指示值事件
                          context
                              .read<ReserveInputBloc>()
                              .add(SetReserveValueEvent('note1', value));
                        }),
                  ],
                ),
              ),
            ),

            FractionallySizedBox(
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
                        WMSLocalizations.i18n(context)!.reserve_input_8, //5
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ),
                    Expanded(
                      child: WMSInputboxWidget(
                          text: state.customerList['note2'],
                          height: 136,
                          maxLines: 5,
                          inputBoxCallBack: (value) {
                            // 设定出荷指示值事件
                            context
                                .read<ReserveInputBloc>()
                                .add(SetReserveValueEvent('note2', value));
                          }),
                    ),
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              //占位
              widthFactor: 0.3,
              child: Container(
                height: 72,
              ),
            ),
          ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReserveInputBloc, ReserveInputModel>(
        builder: (context, state) {
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
                      child: InstructionInputFormTab(
                        initFormBasic: _initFormBasic,
                        // initFormBefore: _initFormBefore(),
                        // initFormDetail: _initFormDetail(),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: InstructionInputFormButton(),
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
    });
  }
}

// 入荷予定入力-表单Tab
typedef TabContextBuilder = Widget Function(ReserveInputModel state);

// 入荷予定入力-表单Tab
// ignore: must_be_immutable
class InstructionInputFormTab extends StatefulWidget {
  // 初始化基本情報入力表单
  TabContextBuilder initFormBasic;
  InstructionInputFormTab({
    super.key,
    required this.initFormBasic,
  });

  @override
  State<InstructionInputFormTab> createState() =>
      _InstructionInputFormTabState();
}

class _InstructionInputFormTabState extends State<InstructionInputFormTab> {
  // 初始化Tab列表
  List<Widget> _initTabList(tabItemList, ReserveInputModel state) {
    // Tab列表
    List<Widget> tabList = [];
    // 循环Tab单个列表
    for (int i = 0; i < tabItemList.length; i++) {
      // Tab列表
      tabList.add(
        GestureDetector(
          onPanDown: (details) {
            // 判断下标
            if (tabItemList[i]['index'] == Config.NUMBER_ZERO) {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = widget.initFormBasic(state);
              });
            } else if (tabItemList[i]['index'] == Config.NUMBER_ONE) {
              // 状态变更
              setState(() {
                // 当前内容
                // currentContent = widget.initFormBefore;
              });
            } else {
              // 状态变更
              setState(() {
                // 当前内容
                currentContent = Wrap();
              });
            }
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
              color: tabItemList[i]['index'] == currentIndex
                  ? Color.fromRGBO(44, 167, 176, 1)
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
                color: tabItemList[i]['index'] == currentIndex
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(156, 156, 156, 1),
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

    return BlocBuilder<ReserveInputBloc, ReserveInputModel>(
      builder: (context, state) {
        return Row(
          children: _initTabList(_tabItemList, state),
        );
      },
    );
  }
}

// 入荷予定入力-表单按钮
class InstructionInputFormButton extends StatefulWidget {
  const InstructionInputFormButton({super.key});

  @override
  State<InstructionInputFormButton> createState() =>
      _InstructionInputFormButtonState();
}

class _InstructionInputFormButtonState
    extends State<InstructionInputFormButton> {
  // 初始化按钮列表
  List<Widget> _initButtonList(buttonItemList) {
    // 按钮列表
    List<Widget> buttonList = [];

    // 循环按钮单个列表
    for (int i = 0; i < buttonItemList.length; i++) {
      // 按钮列表
      buttonList.add(
        Container(
          height: 36,
          margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Color.fromRGBO(44, 167, 176, 1),
              ),
              minimumSize: MaterialStatePropertyAll(
                Size(120, 36),
              ),
            ), //
            onPressed: () {
              if (buttonItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 保存出荷指示表单事件
                context.read<ReserveInputBloc>().add(SaveReceiveFormEvent(
                    context,
                    context.read<ReserveInputBloc>().state.customerList));
              }
            },
            child: Text(
              buttonItemList[i]['title'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: buttonItemList[i]['index'] == Config.NUMBER_ZERO
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(44, 167, 176, 1),
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
        'title': context.read<ReserveInputBloc>().state.isOk == false
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
