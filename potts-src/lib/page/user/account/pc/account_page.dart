import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/account_bloc.dart';
import '../bloc/account_model.dart';
import 'account_content.dart';
import 'account_title.dart';

/**
 * 内容：账户
 * 作者：赵士淞
 * 时间：2023/08/14
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
      child: Scrollbar(
        thumbVisibility: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(100, 21, 20, 21),
            child: ListView(
              children: [
                // 账户-标题
                AccountTitle(),
                // 账户-内容
                AccountContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
