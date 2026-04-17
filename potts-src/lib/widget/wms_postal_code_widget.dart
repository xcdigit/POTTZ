import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/utils/forbidden_utils.dart';
import 'package:http/http.dart' as http;

/**
 * 内容：邮编输入框共通
 * 作者：张博睿
 * 时间：2023/10/12
 */
// ignore: must_be_immutable
class WMSPostalcodeWidget extends StatefulWidget {
  // 高度
  double? height;
  // 背景颜色
  Color? backgroundColor;
  // 边框颜色
  Color? borderColor;
  // 边框圆角
  BorderRadius? borderRadius;
  // 最大行数
  // int? maxLines;
  // 字体大小
  double? fontSize;
  // 字体粗细
  FontWeight? fontWeight;
  // 字体颜色
  Color? fontColor;
  // 字体行高
  double? fontHeight;
  // 国家简称
  String? country;
  // 文本
  String? text;
  // 提示字体大小
  double? hintFontSize;
  // 提示字体粗细
  FontWeight? hintFontWeight;
  // 提示字体颜色
  Color? hintFontColor;
  // 提示字体行高
  double? hintFontHeight;
  // 提示文本
  String? hintText;
  // 只读
  bool? readOnly;
  // 输入框回调函数
  final postalCodeCallBack;

  WMSPostalcodeWidget({
    super.key,
    this.height = 48,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontColor,
    this.fontHeight = 1.5,
    this.country = 'JP',
    this.text = '',
    this.hintFontSize = 14,
    this.hintFontWeight = FontWeight.w400,
    this.hintFontColor,
    this.hintFontHeight = 1.5,
    this.hintText = '',
    this.readOnly = false,
    this.postalCodeCallBack,
  });

  @override
  State<WMSPostalcodeWidget> createState() => _WMSPostalcodeWidgetState();
}

class _WMSPostalcodeWidgetState extends State<WMSPostalcodeWidget> {
  // 输入框操作实例
  TextEditingController _controller = TextEditingController();
  // 输入框焦点控制
  FocusNode _focusNode = FocusNode();

  Map callBackValue = {};

  @override
  void initState() {
    super.initState();
    // 输入框焦点控制
    _focusNode.addListener(() async {
      if (!_focusNode.hasFocus) {
        callBackValue = {};
        // 检查文本
        _controller.text = ForbiddenUtils.checkText(_controller.text);
        var tempPostalCode = _controller.text.toString();
        // 去除 【-】 检索
        if (_controller.text != "") {
          dynamic postalCodeInfo;
          var searchPostalCode = _controller.text.replaceAll('-', '');
          postalCodeInfo = await QueryPostalCodeEvent(searchPostalCode);
          if (postalCodeInfo != null) {
            callBackValue['postal_code'] = tempPostalCode;
            callBackValue['code'] = '0';
            callBackValue['msg'] = 'success';
            callBackValue['data'] = postalCodeInfo;
          } else {
            callBackValue['postal_code'] = tempPostalCode;
            callBackValue['code'] = '1';
            callBackValue['msg'] =
                WMSLocalizations.i18n(context)!.input_postal_code_check;
            callBackValue['data'] = null;
          }
        } else {
          callBackValue['postal_code'] = tempPostalCode;
        }
        // 输入框回调函数
        widget.postalCodeCallBack(callBackValue);
      }
    });
  }

  dynamic QueryPostalCodeEvent(String text) async {
    final response = await http.get(
        Uri.parse('https://zipcloud.ibsnet.co.jp/api/search?zipcode=' + text));
    if (response.statusCode == 200) {
      // 如果服务器返回200 OK，解析数据
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['results'] != null && data['results'][0] != null) {
        var zip = data['results'][0];
        var result = {
          'city': zip['address1'],
          'region': zip['address2'],
          'addr': zip['address3']
        };
        return result;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 判断文本
    if (widget.text != null && widget.text != 'null') {
      // 输入框操作实例
      _controller.text = widget.text!;
    }

    return Container(
      height: widget.height,
      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
      decoration: BoxDecoration(
        color: widget.readOnly!
            ? Color.fromRGBO(240, 240, 240, 1)
            : widget.backgroundColor != null
                ? widget.backgroundColor
                : Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: widget.borderColor != null
              ? widget.borderColor!
              : Color.fromRGBO(224, 224, 224, 1),
        ),
        borderRadius: widget.borderRadius != null
            ? widget.borderRadius
            : BorderRadius.circular(4),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _controller,
        maxLines: 1,
        readOnly: widget.readOnly!,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.fontColor != null
              ? widget.fontColor
              : Color.fromRGBO(6, 14, 15, 1),
          height: widget.fontHeight,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: widget.hintFontSize,
            fontWeight: widget.hintFontWeight,
            color: widget.hintFontColor != null
                ? widget.hintFontColor
                : Color.fromRGBO(146, 146, 146, 1),
            height: widget.hintFontHeight,
          ),
          hintText: widget.hintText,
        ),
        focusNode: _focusNode,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 输入框焦点控制
    _focusNode.dispose();
  }
}
