import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../redux/wms_state.dart';
import '../../../../../widget/table/pc/wms_table_widget.dart';
import '../../../../../widget/wms_inputbox_widget.dart';
import '../bloc/lack_goods_invoice_detail_bloc.dart';
import '../bloc/lack_goods_invoice_detail_model.dart';

/**
 * 内容：欠品伝票照会-明细
 * 作者：luxy
 * 时间：2023/08/16
 */
// 当前下标
int currentIndex = 0;
// 通信数据
List commData = [];
// 当前选择内容
List currentCheckContent = [];
// 全局主键-表格共通

class LackGoodsInvoiceDetails extends StatefulWidget {
  const LackGoodsInvoiceDetails({super.key});

  @override
  State<LackGoodsInvoiceDetails> createState() =>
      _LackGoodsInvoiceDetailsState();
}

class _LackGoodsInvoiceDetailsState extends State<LackGoodsInvoiceDetails> {
  Map<String, dynamic> currentParam = {};
  _detailsText(String _text) {
    return Container(
      height: 24,
      child: Text(
        _text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  _detailsContainerText(String _text, double _height) {
    return WMSInputboxWidget(
      readOnly: true,
      text: _text,
      height: _height,
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //接收传过来的参数
      currentParam = StoreProvider.of<WMSState>(context).state.currentParam;
      currentCheckContent.add(currentParam);
    });
    return BlocProvider<LackGoodsInvoiceDetailBloc>(
      create: (context) {
        return LackGoodsInvoiceDetailBloc(
          LackGoodsInvoiceDetailModel(
              shipno: currentParam['id'], context: context),
        );
      },
      child:
          BlocBuilder<LackGoodsInvoiceDetailBloc, LackGoodsInvoiceDetailModel>(
              builder: (context, state) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 20, 0), // xcy
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //第二行 欠品明細-标题
                      Stack(
                        children: [
                          Container(
                            height: 84,
                            padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                            child: Text(
                              WMSLocalizations.i18n(context)!
                                  .menu_content_3_11_2,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                                height: 1.0,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // 返回按钮  xcy
                      Container(
                        color: Colors.white,
                        height: 37,
                        width: 80,
                        margin: EdgeInsets.only(top: 10, right: 10),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(
                              () {
                                // 持久化状态更新
                                Navigator.pop(context, 'return');
                              },
                            );
                          },
                          child: Text(
                              WMSLocalizations.i18n(context)!
                                  .menu_content_3_11_11,
                              style: TextStyle(
                                  color: Color.fromRGBO(44, 167, 176, 1))),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.black),
                            side: MaterialStateProperty.all(
                              const BorderSide(
                                width: 1,
                                color: Color.fromRGBO(44, 167, 176, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //第三行 欠品明細-内容
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        // children: _initDetails(context),
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: Container(
                              height: 37,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 37,
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                              .instruction_input_form_basic_1 +
                                          ':' +
                                          currentParam['ship_no'].toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color.fromRGBO(44, 167, 176, 1),
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromRGBO(44, 167, 176, 1)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromRGBO(255, 255, 255, 1)),
                                    ),
                                    onPressed: () {
                                      context
                                          .read<LackGoodsInvoiceDetailBloc>()
                                          .add(ReservationShipLineEvent([
                                            currentParam['id'],
                                            currentParam['ship_no']
                                          ], context));
                                    },
                                    child: Text(
                                      WMSLocalizations.i18n(context)!
                                          .menu_content_3_11_1,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
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
                                  _detailsText(WMSLocalizations.i18n(context)!
                                      .instruction_input_form_basic_3),
                                  _detailsContainerText(
                                      currentParam['rcv_sch_date'].toString(),
                                      48),
                                  new Padding(
                                      padding: EdgeInsets.only(top: 16)),
                                  _detailsText(WMSLocalizations.i18n(context)!
                                      .delivery_note_18),
                                  _detailsContainerText(
                                      currentParam['cus_rev_date'].toString(),
                                      48),
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
                                  _detailsText(WMSLocalizations.i18n(context)!
                                      .delivery_note_27),
                                  _detailsContainerText(
                                      currentParam['note1'].toString(),
                                      136), // xcy
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
                                  _detailsText(WMSLocalizations.i18n(context)!
                                      .delivery_note_28),
                                  _detailsContainerText(
                                      currentParam['note2'].toString(),
                                      136), // xcy
                                ],
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.3,
                            child: Container(
                              height: 72,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _detailsText(WMSLocalizations.i18n(context)!
                                      .instruction_input_form_basic_4),
                                  _detailsContainerText(
                                      currentParam['customer_name'].toString(),
                                      48),
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
                                  _detailsText(WMSLocalizations.i18n(context)!
                                      .delivery_note_17),
                                  _detailsContainerText(
                                      currentParam['name'].toString(), 48),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //欠品行 欠品明細-标题
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Stack(
                      children: [
                        Container(
                          height: 84,
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                          child: Text(
                            WMSLocalizations.i18n(context)!.menu_content_3_11_3,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              height: 1.0,
                              color: Color.fromRGBO(44, 167, 176, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //欠品行-内容
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(224, 224, 224, 1),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          //表格内容
                          LackGoodsInvoiceTableContent(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

// 欠品伝票照会明細-表格内容
class LackGoodsInvoiceTableContent extends StatefulWidget {
  const LackGoodsInvoiceTableContent({super.key});

  @override
  State<LackGoodsInvoiceTableContent> createState() =>
      _LackGoodsInvoiceTableContentState();
}

class _LackGoodsInvoiceTableContentState
    extends State<LackGoodsInvoiceTableContent> {
  var data = [];

  @override
  Widget build(BuildContext context) {
    return WMSTableWidget<LackGoodsInvoiceDetailBloc,
        LackGoodsInvoiceDetailModel>(
      columns: [
        {
          'key': 'id',
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_1,
        },
        {
          'key': 'warehouse_no',
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_2,
        },
        {
          'key': 'code',
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_3,
        },
        {
          'key': 'name',
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_4,
        },
        {
          'key': 'product_price',
          'title': WMSLocalizations.i18n(context)!.menu_content_3_11_4,
        },
        {
          'key': 'ship_num',
          'title': WMSLocalizations.i18n(context)!.menu_content_3_11_6,
        },
        {
          'key': 'size',
          'title':
              WMSLocalizations.i18n(context)!.instruction_input_table_title_5,
        },
        {
          'key': 'lock_kbn',
          'title':
              WMSLocalizations.i18n(context)!.delivery_note_reservation_status,
        },
        {
          'key': 'sum',
          'title': WMSLocalizations.i18n(context)!.menu_content_3_11_5,
        },
      ],
      operatePopupHeight: 100,
      showCheckboxColumn: false,
      operatePopupOptions: [
        {
          'title': WMSLocalizations.i18n(context)!.delivery_note_8,
          'callback': (_, value) {
            _showDialog(value);
          }
        }
      ],
    );
  }

  _showDialog(Map value) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          // xcy
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                WMSLocalizations.i18n(context)!.delivery_note_8,
                style: TextStyle(
                    color: Color.fromRGBO(44, 167, 176, 1), fontSize: 24),
              ),
              Container(
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(44, 167, 176, 1)),
                  child: Text(
                    WMSLocalizations.i18n(context)!.delivery_note_close,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); //关闭对话框
                  },
                ),
              ),
            ],
          ),
          content: Container(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color.fromRGBO(224, 224, 224, 1),
              ),
            ),
            width: MediaQuery.of(context).size.width * .8,
            child: ListView(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _showDialogContent(value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//弹框中间内容
  _showDialogContent(Map value) {
    return [
      Expanded(
        flex: 1,
        child: Container(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //No
              _detailsText(WMSLocalizations.i18n(context)!.pink_list_47),
              _detailsContainerText(value['ship_line_no'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //引当状态
              _detailsText(WMSLocalizations.i18n(context)!
                  .delivery_note_reservation_status),
              _detailsContainerText(value['lock_kbn'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //出荷仓库
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_2),
              _detailsContainerText(value['warehouse_no'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品コード
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_3),
              _detailsContainerText(value['code'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品名
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_4),
              _detailsContainerText(value['name'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //単価
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_3_11_4),
              _detailsContainerText(value['product_price'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //出荷指示数
              _detailsText(WMSLocalizations.i18n(context)!.menu_content_3_11_6),
              _detailsContainerText(value['ship_num'].toString(), 48),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //规格
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_table_title_5),
              _detailsContainerText(value['size'].toString(), 48),
            ],
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(right: 24)),
      Expanded(
        flex: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //商品写真1
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_5),
              // _detailsContainerText(value['image1'].toString(), 224),
              Container(
                height: 224,
                // ignore: unnecessary_null_comparison
                child: value['image1'] != null && value['image1'] != ''
                    ? Image.network(
                        value['image1'],
                        height: 216,
                      )
                    : Image.asset(
                        WMSICons.NO_IMAGE,
                        height: 224,
                      ),
              ),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品_社内備考１
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_8),
              _detailsContainerText(value['company_note1'].toString(), 136),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品_社内備考2
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_11),
              _detailsContainerText(value['company_note2'].toString(), 136),
            ],
          ),
        ),
      ),
      Padding(padding: EdgeInsets.only(right: 24)),
      Expanded(
        flex: 1,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //商品_写真2
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_form_detail_6),
              Container(
                height: 224,
                // ignore: unnecessary_null_comparison
                child: value['image2'] != null && value['image2'] != ''
                    ? Image.network(
                        value['image2'],
                        height: 216,
                      )
                    : Image.asset(
                        WMSICons.NO_IMAGE,
                        height: 224,
                      ),
              ),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品_注意備考１
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_form_basic_9),
              _detailsContainerText(value['notice_note1'].toString(), 136),
              new Padding(padding: EdgeInsets.only(top: 16)),
              //商品_注意備考2
              _detailsText(WMSLocalizations.i18n(context)!
                  .instruction_input_form_basic_10),
              _detailsContainerText(value['notice_note2'].toString(), 136),
            ],
          ),
        ),
      ),
    ];
  }

  _detailsText(String _text) {
    return Container(
      height: 24,
      child: Text(
        _text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Color.fromRGBO(6, 14, 15, 1),
        ),
      ),
    );
  }

  _detailsContainerText(String _text, double _height) {
    return WMSInputboxWidget(
      height: _height,
      text: _text,
      readOnly: true,
    );
  }
}
