import 'package:flutter/material.dart';

import '../../../common/style/wms_style.dart';

/**
 * 内容：续费-底部
 * 作者：赵士淞
 * 时间：2025/01/10
 */
class LoginRenewalBottom extends StatefulWidget {
  const LoginRenewalBottom({super.key});

  @override
  State<LoginRenewalBottom> createState() => _LoginRenewalBottomState();
}

class _LoginRenewalBottomState extends State<LoginRenewalBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 283,
      color: Color.fromRGBO(44, 167, 176, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 续费底部左部
          LoginRenewalBottomLeft(),
          // 续费底部右部
          LoginRenewalBottomRight(),
        ],
      ),
    );
  }
}

// 续费底部左部
class LoginRenewalBottomLeft extends StatefulWidget {
  const LoginRenewalBottomLeft({super.key});

  @override
  State<LoginRenewalBottomLeft> createState() => _LoginRenewalBottomLeftState();
}

class _LoginRenewalBottomLeftState extends State<LoginRenewalBottomLeft> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 24,
            left: 84,
          ),
          child: Image.asset(
            WMSICons.HOME_HEAD_LOGO,
            width: 284,
            height: 90,
            color: Colors.white,
            fit: BoxFit.contain,
            repeat: ImageRepeat.noRepeat,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 128,
          ),
          child: Text(
            '株式会社ＢＸ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 12,
            left: 128,
          ),
          child: Text(
            '東京都港区西麻布1-15-1森口ビル10F',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 77,
            left: 122,
          ),
          child: Text(
            '© BIZ-X POTTZ, Inc.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

// 续费底部右部
class LoginRenewalBottomRight extends StatefulWidget {
  const LoginRenewalBottomRight({super.key});

  @override
  State<LoginRenewalBottomRight> createState() =>
      _LoginRenewalBottomRightState();
}

class _LoginRenewalBottomRightState extends State<LoginRenewalBottomRight> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
