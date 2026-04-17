import 'package:flutter/material.dart';
import 'package:wms/common/localization/default_localizations.dart';
import 'package:wms/common/style/wms_style.dart';

/**
 * 内容：申込-头部
 * 作者：luxy
 * 时间：2024/06/24
 */
class LoginRegisterHeader extends StatefulWidget {
  const LoginRegisterHeader({super.key});

  @override
  State<LoginRegisterHeader> createState() => _LoginRegisterHeaderState();
}

class _LoginRegisterHeaderState extends State<LoginRegisterHeader> {
  @override
  Widget build(BuildContext context) {
    // 整体
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(50, 30, 0, 0),
                child: Image.asset(
                  WMSICons.HOME_HEAD_REGISTER_LOGO,
                  width: 203,
                  height: 23,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 50, 0),
                child: Row(
                  children: [
                    // 文字1
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        WMSLocalizations.i18n(context)!.register_header_text_1,
                        style: TextStyle(
                          color: Color.fromRGBO(253, 253, 253, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 5,
                      ),
                      height: 20.0, // 线的高度
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Color.fromRGBO(253, 253, 253, 1),
                          ), // 下边框作为线
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    // 文字2
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        WMSLocalizations.i18n(context)!.register_header_text_2,
                        style: TextStyle(
                          color: Color.fromRGBO(253, 253, 253, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 20.0, // 线的高度
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Color.fromRGBO(253, 253, 253, 1),
                          ), // 下边框作为线
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    // 文字3
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        WMSLocalizations.i18n(context)!.register_header_text_3,
                        style: TextStyle(
                          color: Color.fromRGBO(253, 253, 253, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 5,
                      ),
                      height: 20.0, // 线的高度
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Color.fromRGBO(253, 253, 253, 1),
                          ), // 下边框作为线
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    ),
                    // 文字4
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        WMSLocalizations.i18n(context)!.register_header_text_4,
                        style: TextStyle(
                          color: Color.fromRGBO(253, 253, 253, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 145, 0, 0),
            child: Text(
              WMSLocalizations.i18n(context)!.register_header_text_5,
              style: TextStyle(
                color: Color.fromRGBO(253, 253, 253, 1),
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              WMSLocalizations.i18n(context)!.register_header_text_6,
              style: TextStyle(
                color: Color.fromRGBO(253, 253, 253, 1),
                fontSize: 24,
                fontWeight: FontWeight.w500,
                letterSpacing: 4.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
