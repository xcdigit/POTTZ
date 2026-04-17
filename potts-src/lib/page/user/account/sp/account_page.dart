import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';
import 'account_content.dart';

/**
 * 内容：账户-SP
 * 作者：熊草云
 * 时间：2023/11/01
 */
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) {
        return AccountBloc(
          AccountModel(
            rootContext: context,
          ),
        );
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          color: Color.fromRGBO(102, 199, 206, 0.1),
          // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ListView(
            children: [
              // 账户-内容
              AccountContent(),
            ],
          ),
        ),
      ),
    );
  }
}
