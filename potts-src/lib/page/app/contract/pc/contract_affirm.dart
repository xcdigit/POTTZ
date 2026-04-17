import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/model/user.dart';
import 'package:wms/redux/wms_state.dart';
import '../../../../bloc/wms_common_bloc_utils.dart';
import '../../../../common/localization/default_localizations.dart';
import '../bloc/contract_affirm_bloc.dart';
import '../bloc/contract_affirm_model.dart';

/**
 * 内容：サービス解約-表单
 * 作者：王光顺
 * 时间：2023/12/07
 */
class ContractAffirm extends StatefulWidget {
  const ContractAffirm({super.key});

  @override
  State<ContractAffirm> createState() => _InformationSocietyFormtate();
}

// 单选框的选中状态
bool isChecked = false;

class _InformationSocietyFormtate extends State<ContractAffirm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractAffirmBloc, ContractAffirmModel>(
      builder: (context, state) {
        return Container(
          child: Wrap(
            children: [
              // 标题
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 30),
                  child: Text(
                    WMSLocalizations.i18n(context)!.contract_text_6,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                      height: 1.0,
                      color: Color.fromRGBO(44, 167, 176, 1),
                    ),
                  ),
                ),
              ),
              FractionallySizedBox(widthFactor: .2),
              FractionallySizedBox(
                  //会社名名称
                  widthFactor: .8,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      WMSLocalizations.i18n(context)!.contract_text_3 +
                          ": " +
                          state.DateList[0]['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    ),
                  )),
              FractionallySizedBox(widthFactor: .2),
              FractionallySizedBox(
                //運用開始日
                widthFactor: .8,
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text(
                      WMSLocalizations.i18n(context)!.account_license_start +
                          ": " +
                          state.DateList[1]['start_date'],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color.fromRGBO(6, 14, 15, 1),
                      ),
                    )),
              ),
              FractionallySizedBox(widthFactor: .2),
              FractionallySizedBox(
                //運用終了日
                widthFactor: .8,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    WMSLocalizations.i18n(context)!.account_license_end +
                        ": " +
                        state.DateList[1]['end_date'],
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
              ),
              FractionallySizedBox(widthFactor: .2),
              FractionallySizedBox(
                widthFactor: .8,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    WMSLocalizations.i18n(context)!.contract_text_7,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color.fromRGBO(6, 14, 15, 1),
                    ),
                  ),
                ),
              ),
              FractionallySizedBox(widthFactor: .2),

              FractionallySizedBox(
                widthFactor: 0.6,
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
                  color: Color.fromARGB(255, 255, 239, 215), // 设置背景颜色为淡橙色
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChecked, // 将单选框的值与布尔变量关联起来
                        onChanged: (bool? value) {
                          // 更新布尔变量来反映单选框的选中状态
                          setState(() {
                            isChecked = value ?? false;
                          });
                        },
                      ),
                      Text(
                        WMSLocalizations.i18n(context)!.contract_text_8,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color.fromRGBO(6, 14, 15, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              FractionallySizedBox(widthFactor: .2),
              //按钮
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //キャンセル按钮
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildButtom(
                              WMSLocalizations.i18n(context)!
                                  .account_profile_cancel,
                              0,
                              state,
                              context),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    //次へ按钮
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BuildButtom(
                              WMSLocalizations.i18n(context)!.contract_text_9,
                              1,
                              state,
                              context)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 底部检索和解除按钮
Container BuildButtom(
    String text, int differ, ContractAffirmModel state, BuildContext context) {
  return Container(
    color: Colors.white,
    height: 48,
    width: 180,
    child: OutlinedButton(
      onPressed: () async {
        if (differ == 0) {
          //恢复迁移元
          StoreProvider.of<WMSState>(context).state.contractFlag = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(context).state.login = false;
          // 持久化状态更新
          StoreProvider.of<WMSState>(context).state.userInfo = null;
          // 持久化状态
          StoreProvider.of<WMSState>(context).state.loginUser = User.empty();
          // キャンセル按钮跳转登录页面
          GoRouter.of(context).go("/login");
        } else {
          if (isChecked == true) {
            //改变db状态 开启解约流程
            context.read<ContractAffirmBloc>().add(UpdateFormEvent(context));
            isChecked = false; //还原状态
          } else {
            //未同意
            WMSCommonBlocUtils.successTextToast(
              WMSLocalizations.i18n(context)!.contract_text_10,
            );
          }
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: differ == 0 ? Color.fromRGBO(44, 167, 176, 1) : Colors.white,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: differ == 0
            ? MaterialStateProperty.all(Colors.white)
            : MaterialStateProperty.all(Color.fromRGBO(44, 167, 176, 1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        side: MaterialStateProperty.all(
          const BorderSide(
            width: 1,
            color: Color.fromRGBO(44, 167, 176, 1),
          ),
        ),
      ),
    ),
  );
}
