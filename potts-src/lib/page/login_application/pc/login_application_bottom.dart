import 'package:flutter/material.dart';

import '../../../common/style/wms_style.dart';

/**
 * 内容：申请-底部
 * 作者：赵士淞
 * 时间：2024/12/04
 */
class LoginApplicationBottom extends StatefulWidget {
  const LoginApplicationBottom({super.key});

  @override
  State<LoginApplicationBottom> createState() => _LoginApplicationBottomState();
}

class _LoginApplicationBottomState extends State<LoginApplicationBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 283,
      color: Color.fromRGBO(44, 167, 176, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 申请底部左部
          LoginApplicationBottomLeft(),
          // 申请底部右部
          LoginApplicationBottomRight(),
        ],
      ),
    );
  }
}

// 申请底部左部
class LoginApplicationBottomLeft extends StatefulWidget {
  const LoginApplicationBottomLeft({super.key});

  @override
  State<LoginApplicationBottomLeft> createState() =>
      _LoginApplicationBottomLeftState();
}

class _LoginApplicationBottomLeftState
    extends State<LoginApplicationBottomLeft> {
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

// 申请底部右部
class LoginApplicationBottomRight extends StatefulWidget {
  const LoginApplicationBottomRight({super.key});

  @override
  State<LoginApplicationBottomRight> createState() =>
      _LoginApplicationBottomRightState();
}

class _LoginApplicationBottomRightState
    extends State<LoginApplicationBottomRight> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
