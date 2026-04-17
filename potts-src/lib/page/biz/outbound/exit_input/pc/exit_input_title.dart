import 'package:flutter/material.dart';

/**
 * 内容：出庫入力-头部
 * 作者：赵士淞
 * 时间：2023/08/17
 */
// ignore: must_be_immutable
class ExitInputTitle extends StatefulWidget {
  // 头部文本
  String titleText;

  ExitInputTitle({super.key, required this.titleText});

  @override
  State<ExitInputTitle> createState() => _ExitInputTitleState();
}

class _ExitInputTitleState extends State<ExitInputTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
      child: Text(
        widget.titleText,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 24,
          height: 1.0,
          color: Color.fromRGBO(44, 167, 176, 1),
        ),
      ),
    );
  }
}
