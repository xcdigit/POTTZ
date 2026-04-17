import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:wms/page/app/application_cceptance/pc/application_cceptance_detail.dart';
import 'package:wms/page/app/application_cceptance/pc/application_cceptance_page.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/sp/goods_transfer_entry_form_detail.dart';
import 'package:wms/page/mst/delivery_operators_master/sp/delivery_operators_master_page.dart'
    if (dart.library.html) 'package:wms/page/mst/delivery_operators_master/pc/delivery_operators_master_page.dart';
import 'package:wms/page/biz/outbound/exit_input/sp/exit_input_details_page.dart';
import 'package:wms/page/biz/inbound/goods_input/sp/goods_receipt_input_details_page.dart';
import 'package:wms/page/biz/store/goods_transfer_entry/sp/goods_transfer_entry_page.dart'
    if (dart.library.html) 'package:wms/page/biz/store/goods_transfer_entry/pc/goods_transfer_entry_page.dart';
import 'package:wms/page/biz/outbound/inspection/sp/shipment_inspection_details_page.dart';
import 'package:wms/page/biz/store/adjust_inquiry/sp/inventory_adjust_inquiry_page.dart'
    if (dart.library.html) 'package:wms/page/biz/store/adjust_inquiry/pc/inventory_adjust_inquiry_page.dart';
import 'package:wms/page/biz/store/transfer_inquiry/sp/inventory_transfer_inquiry_page.dart'
    if (dart.library.html) 'package:wms/page/biz/store/transfer_inquiry/pc/inventory_transfer_inquiry_page.dart';
import 'package:wms/page/mst/delivery/sp/delivery_page.dart'
    if (dart.library.html) 'package:wms/page/mst/delivery/pc/delivery_page.dart';
import 'package:wms/page/biz/store/outbound_adjust/sp/outbound_adjust_form.dart';
import 'package:wms/page/biz/store/outbound_adjust/sp/outbound_adjust_page.dart'
    if (dart.library.html) 'package:wms/page/biz/store/outbound_adjust/pc/outbound_adjust_page.dart';
import 'package:wms/page/biz/store/returns_note/sp/returns_note_page.dart'
    if (dart.library.html) 'package:wms/page/biz/store/returns_note/pc/returns_note_page.dart';
import 'package:wms/page/biz/stocktaking/actual_shelf_items/sp/actual_shelf_page.dart'
    if (dart.library.html) 'package:wms/page/biz/stocktaking/actual_shelf_items/pc/actual_shelf_page.dart';
import 'package:wms/page/biz/inbound/goods_input/sp/goods_receipt_input_page.dart'
    if (dart.library.html) 'package:wms/page/biz/inbound/goods_input/pc/goods_receipt_input_page.dart';
import 'package:wms/page/mst/product_information/sp/product_information_page.dart'
    if (dart.library.html) 'package:wms/page/mst/product_information/pc/product_information_page.dart';
import 'package:wms/page/mst/role_master/sp/role_master_form.dart'
    if (dart.library.html) 'package:wms/page/mst/role_master/pc/role_master_form.dart';
import 'package:wms/page/biz/store/return_product/sp/return_product_page.dart'
    if (dart.library.html) 'package:wms/page/biz/store/return_product/pc/return_product_page.dart';
import 'package:wms/page/mst/warehouse_master/sp/warehouse_master_page.dart'
    if (dart.library.html) 'package:wms/page/mst/warehouse_master/pc/warehouse_master_page.dart';
import 'package:wms/redux/wms_state.dart';
import '../common/config/config.dart';
import '../page/app/application_cancel/pc/application_cancel_page.dart';
import '../page/login_company_complete/sp/login_company_complete_page.dart'
    if (dart.library.html) '../page/login_company_complete/pc/login_company_complete_page.dart';
import '../page/login_renewal/pc/login_renewal_page.dart';
import '../page/login_verification_code/sp/login_verification_code_page.dart'
    if (dart.library.html) '../page/login_verification_code/pc/login_verification_code_page.dart';
import '../page/login_application/pc/login_application_page.dart';
import '../page/login_register/pc/login_register_authentication.dart';
import '../page/login_register/pc/login_register_complete.dart';
import '../page/setting/corporate_management/pc/corporate_management_page.dart';
import '../page/setting/message_master/pc/message_master_page.dart';
import '../page/setting/plan_management/pc/plan_management_page.dart';
import '../page/mst/form_master/pc/form_master_form.dart';
import '../page/mst/form_master_detail/pc/form_master_detail_form.dart';
import '../page/setting/charge_management/pc/charge_management_form.dart';
import '../page/setting/license_management/pc/license_management_form.dart';
import '../page/setting/user_license_management/pc/user_license_management_form.dart';
import '../page/user/account/sp/account_content_code.dart';
import '../page/user/account/sp/account_content_license.dart';
import '../page/user/account/sp/account_content_plan.dart';
import '../page/user/account/sp/account_content_plan_cancel.dart';
import '../page/user/account/sp/account_content_plan_form.dart';
import '../page/user/account/sp/account_content_security.dart';
import '../page/user/account/sp/account_content_profile.dart';
import '../page/mst/calendar_master/sp/calendar_master_form.dart'
    if (dart.library.html) '../page/mst/calendar_master/pc/calendar_master_form.dart';
import '../page/mst/calendar_master/sp/calendar_master_page.dart'
    if (dart.library.html) '../page/mst/calendar_master/pc/calendar_master_page.dart';
import '../page/setting/charge_management/pc/charge_management_page.dart';
import '../page/mst/company_master/sp/company_master_form.dart'
    if (dart.library.html) '../page/mst/company_master/pc/company_master_form.dart';
import '../page/mst/company_master/sp/company_master_page.dart'
    if (dart.library.html) '../page/mst/company_master/pc/company_master_page.dart';
import '../page/user/account/sp/account_page.dart'
    if (dart.library.html) '../page/user/account/pc/account_page.dart';
import '../page/biz/inbound/confirmation/pc/confirmation_data_page.dart';

import '../page/app/contract/pc/contract_affirm_page.dart';
import '../page/app/contract/pc/contract_page.dart';
import '../page/app/contract/pc/contract_thank.dart';
import '../page/mst/customer_master/sp/customer_master_page.dart'
    if (dart.library.html) '../page/mst/customer_master/pc/customer_master_page.dart';
import '../page/mst/customer_master/sp/customer_master_form.dart'
    if (dart.library.html) '../page/mst/customer_master/pc/customer_master_form.dart';
import '../page/mst/delivery_operators_master/sp/delivery_operators_master_form.dart'
    if (dart.library.html) '../page/mst/delivery_operators_master/pc/delivery_operators_master_form.dart';
import '../page/error_page.dart';
import '../page/biz/outbound/exit_input/sp/exit_input_page.dart'
    if (dart.library.html) '../page/biz/outbound/exit_input/pc/exit_input_page.dart';
import '../page/mst/form_master/pc/form_master_page.dart';
import '../page/mst/form_master_detail/pc/form_master_detail_page.dart';
import '../page/home_header_notice/sp/home_head_notice_details.dart';
import '../page/biz/inbound/incoming/sp/incoming_inspection_detail.dart';
import '../page/sys/information_management/sp/information_management_page.dart'
    if (dart.library.html) '../page/sys/information_management/pc/information_management_page.dart';
import '../page/biz/inbound/inquiry_schedule_details/sp/inquiry_schedule_details_page.dart'
    if (dart.library.html) '../page/biz/inbound/inquiry_schedule_details/pc/inquiry_schedule_details_page.dart';
import '../page/biz/stocktaking/inventory_output/pc/inventory_output_page.dart';
import '../page/setting/license_management/pc/license_management_page.dart';
import '../page/mst/location_master/sp/location_master_form.dart'
    if (dart.library.html) '../page/mst/location_master/pc/location_master_form.dart';
import '../page/biz/stocktaking/inventory_query_detail/sp/inventory_query_detail_page.dart'
    if (dart.library.html) '../page/biz/stocktaking/inventory_query_detail/pc/inventory_query_detail_page.dart';
import '../page/login/sp/login_forget_pwd_page.dart'
    if (dart.library.html) '../page/login/pc/login_forget_pwd_page.dart';
import '../page/login/sp/login_modify_pwd_page.dart'
    if (dart.library.html) '../page/login/pc/login_modify_pwd_page.dart';
import '../page/login/sp/login_page.dart'
    if (dart.library.html) '../page/login/pc/login_page.dart';
import '../page/login_admin/pc/login_admin_page.dart';
import '../page/home_header_notice/sp/home_head_notice_page.dart'
    if (dart.library.html) '../page/home_header_notice/pc/home_head_notice_page.dart';
import '../page/home_main/sp/home_main_page.dart'
    if (dart.library.html) '../page/home_main/pc/home_main_page.dart';
import '../page/biz/inbound/income_confirmation/sp/income_confirmation_detail.dart'
    if (dart.library.html) '../page/biz/inbound/income_confirmation/pc/income_confirmation_detail.dart';
import '../page/biz/inbound/income_confirmation/sp/income_confirmation_page.dart'
    if (dart.library.html) '../page/biz/inbound/income_confirmation/pc/income_confirmation_page.dart';
import '../page/biz/inbound/incoming/sp/incoming_inspection_page.dart'
    if (dart.library.html) '../page/biz/inbound/incoming/pc/incoming_inspection_page.dart';
import '../page/biz/outbound/inquiry/sp/display_instruction_packingslip.dart'
    if (dart.library.html) '../page/biz/outbound/inquiry/pc/display_instruction_packingslip.dart';
import '../page/biz/outbound/inquiry/sp/display_instruction_page.dart'
    if (dart.library.html) '../page/biz/outbound/inquiry/pc/display_instruction_page.dart';
import '../page/biz/inbound/inquiry_schedule/sp/inquiry_schedule_page.dart'
    if (dart.library.html) '../page/biz/inbound/inquiry_schedule/pc/inquiry_schedule_page.dart';
import '../page/biz/outbound/inspection/sp/shipment_inspection_page.dart'
    if (dart.library.html) '../page/biz/outbound/inspection/pc/shipment_inspection_page.dart';
import '../page/biz/store/inventory_inquiry/sp/inventory_inquiry_page.dart'
    if (dart.library.html) '../page/biz/store/inventory_inquiry/pc/inventory_inquiry_page.dart';
import '../page/biz/stocktaking/inventory_confirmed/sp/inventory_confirmed_page.dart'
    if (dart.library.html) '../page/biz/stocktaking/inventory_confirmed/pc/inventory_confirmed_page.dart';
import '../page/biz/stocktaking/inventory_query/sp/inventory_query_page.dart'
    if (dart.library.html) '../page/biz/stocktaking/inventory_query/pc/inventory_query_page.dart';
import '../page/biz/outbound/lack_goods_invoice/sp/lack_goods_invoice_details.dart'
    if (dart.library.html) '../page/biz/outbound/lack_goods_invoice/pc/lack_goods_invoice_details.dart';
import '../page/biz/outbound/lack_goods_invoice/sp/lack_goods_invoice_page.dart'
    if (dart.library.html) '../page/biz/outbound/lack_goods_invoice/pc/lack_goods_invoice_page.dart';
import '../page/sys/operate_log/sp/operate_log_page.dart'
    if (dart.library.html) '../page/sys/operate_log/pc/operate_log_page.dart';
import '../page/setting/organization_master/sp/organization_master_form.dart'
    if (dart.library.html) '../page/setting/organization_master/pc/organization_master_form.dart';
import '../page/setting/organization_master/sp/organization_master_page.dart'
    if (dart.library.html) '../page/setting/organization_master/pc/organization_master_page.dart';
import '../page/app/payment/pc/payment_success_page.dart';
import '../page/setting/auth/sp/auth_form.dart'
    if (dart.library.html) '../page/setting/auth/pc/auth_form.dart';
import '../page/mst/delivery/sp/delivery_form.dart'
    if (dart.library.html) '../page/mst/delivery/pc/delivery_form.dart';
import '../page/setting/menu_master/sp/menu_master_form.dart'
    if (dart.library.html) '../page/setting/menu_master/pc/menu_master_form.dart';
import '../page/setting/menu_master/sp/menu_master_page.dart'
    if (dart.library.html) '../page/setting/menu_master/pc/menu_master_page.dart';
import '../page/mst/location_master/sp/location_master_page.dart'
    if (dart.library.html) '../page/mst/location_master/pc/location_master_page.dart';
import '../page/biz/outbound/outbound/sp/outbound_query_commodity.dart'
    if (dart.library.html) '../page/biz/outbound/outbound/pc/outbound_query_commodity.dart';
import '../page/biz/outbound/pick/sp/pick_list_commodity.dart'
    if (dart.library.html) '../page/biz/outbound/pick/pc/pick_list_commodity.dart';
import '../page/biz/outbound/pick/sp/pick_list_packingslip.dart'
    if (dart.library.html) '../page/biz/outbound/pick/pc/pick_list_packingslip.dart';
import '../page/mst/product_management/sp/product_master_management_page.dart'
    if (dart.library.html) '../page/mst/product_management/pc/product_master_management_page.dart';
import '../page/mst/product_management/sp/product_master_management_form.dart'
    if (dart.library.html) '../page/mst/product_management/pc/product_master_management_form.dart';
import '../page/biz/store/revenue_and_expenditure/sp/revenue_and_expenditure_page.dart'
    if (dart.library.html) '../page/biz/store/revenue_and_expenditure/pc/revenue_and_expenditure_page.dart';
import '../page/mst/role_master/sp/role_master_page.dart'
    if (dart.library.html) '../page/mst/role_master/pc/role_master_page.dart';
import '../page/setting/auth/sp/auth_page.dart'
    if (dart.library.html) '../page/setting/auth/pc/auth_page.dart';
import '../page/biz/outbound/shipment_confirmation_export/sp/shipment_confirmation_export_page.dart'
    if (dart.library.html) '../page/biz/outbound/shipment_confirmation_export/pc/shipment_confirmation_export_page.dart';
import '../page/biz/outbound/ship/pc/shipment_determination_detail_page.dart';
import '../page/biz/outbound/shipping/sp/instruction_input_details.dart';
import '../page/biz/outbound/shipping/sp/instruction_input_table.dart';
import '../page/biz/outbound/ship/sp/shipment_determination_page.dart'
    if (dart.library.html) '../page/biz/outbound/ship/pc/shipment_determination_page.dart';
import '../page/biz/outbound/shipping/sp/instruction_input_page.dart'
    if (dart.library.html) '../page/biz/outbound/shipping/pc/instruction_input_page.dart';
import '../page/mst/shipping_master/sp/shipping_master_form.dart'
    if (dart.library.html) '../page/mst/shipping_master/pc/shipping_master_form.dart';
import '../page/mst/shipping_master/sp/shipping_master_page.dart'
    if (dart.library.html) '../page/mst/shipping_master/pc/shipping_master_page.dart';
import '../page/biz/stocktaking/start_inventory/sp/start_inventory_page.dart'
    if (dart.library.html) '../page/biz/stocktaking/start_inventory/pc/start_inventory_page.dart';
import '../page/biz/inbound/stock/sp/reserve_input_details.dart';
import '../page/biz/inbound/stock/sp/reserve_input_page.dart'
    if (dart.library.html) '../page/biz/inbound/stock/pc/reserve_input_page.dart';
import '../page/mst/supplier_master/sp/supplier_master_information.dart'
    if (dart.library.html) '../page/mst/supplier_master/pc/supplier_master_information.dart';
import '../page/mst/supplier_master/sp/supplier_master_page.dart'
    if (dart.library.html) '../page/mst/supplier_master/pc/supplier_master_page.dart';
import '../page/setting/user_license_management/pc/user_license_management_page.dart';
import '../page/setting/user_license_management_detail/pc/user_license_management_detail_page.dart';
import '../page/biz/outbound/warehouse/sp/commodity.dart'
    if (dart.library.html) '../page/biz/outbound/warehouse/pc/commodity.dart';
import '../page/biz/outbound/warehouse/sp/packingslip.dart'
    if (dart.library.html) '../page/biz/outbound/warehouse/pc/packingslip.dart';
import '../page/mst/warehouse_master/sp/warehouse_master_form.dart'
    if (dart.library.html) '../page/mst/warehouse_master/pc/warehouse_master_form.dart';
import '../page/biz/inbound/warehouse_inspection/sp/warehouse_query_commodity.dart'
    if (dart.library.html) '../page/biz/inbound/warehouse_inspection/pc/warehouse_query_commodity.dart';
import '../page/home/sp/home_page.dart'
    if (dart.library.html) '../page/home/pc/home_page.dart';
import '/page/welcome_page.dart';

final GoRouter wmsRouter = GoRouter(
  initialLocation: '/welcome',
  observers: [BotToastNavigatorObserver()],
  debugLogDiagnostics: true,
  routes: <RouteBase>[
    GoRoute(
      path: "/welcome",
      builder: (context, state) => WelcomePage(),
    ),
    GoRoute(
      name: LoginPage.sName,
      path: "/login",
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      name: LoginForgetPwdPage.sName,
      path: "/loginForgetPwd",
      builder: (context, state) => LoginForgetPwdPage(),
    ),
    GoRoute(
      name: LoginModifyPwdPage.sName,
      path: "/loginModifyPwd",
      builder: (context, state) => LoginModifyPwdPage(),
    ),
    GoRoute(
      path: "/paymentSuccess/:sceneNo/:orderNo",
      builder: (context, state) => PaymentSuccessPage(
        sceneNo: int.parse(state.pathParameters['sceneNo'].toString()),
        orderNo: state.pathParameters['orderNo'].toString(),
      ),
    ),
    GoRoute(
      name: LoginApplicationPage.sName,
      path: "/loginApplication/:channelId/:pageFlag",
      builder: (context, state) => LoginApplicationPage(
        channelId: state.pathParameters['channelId'].toString(),
        pageFlag: state.pathParameters['pageFlag'].toString(),
      ),
    ),
    GoRoute(
      name: LoginRenewalPage.sName,
      path: "/loginRenewal/:pageFlag",
      builder: (context, state) => LoginRenewalPage(
        pageFlag: state.pathParameters['pageFlag'].toString(),
      ),
    ),
    GoRoute(
      name: LoginAdminPage.sName,
      path: "/loginAdmin",
      builder: (context, state) => LoginAdminPage(),
    ),
    GoRoute(
      name: LoginVerificationCodePage.sName,
      path: "/loginVerificationCode",
      builder: (context, state) => LoginVerificationCodePage(),
    ),
    GoRoute(
      name: LoginCompanyCompletePage.sName,
      path: "/loginCompanyComplete",
      builder: (context, state) => LoginCompanyCompletePage(),
    ),
    GoRoute(
      name: LoginRegisterAuthentication.sName,
      // 注册页面下一页
      path: "/loginRegisterAuthentication",
      builder: (context, state) => LoginRegisterAuthentication(),
    ),
    GoRoute(
      name: LoginRegisterComplete.sName,
      // 注册页面完成
      path: "/LoginRegisterComplete",
      builder: (context, state) => LoginRegisterComplete(),
    ),
    GoRoute(
      name: ContractPage.sName,
      path: '/contract',
      builder: (BuildContext context, GoRouterState state) {
        if (StoreProvider.of<WMSState>(context).state.loginUser == null ||
            StoreProvider.of<WMSState>(context).state.loginUser!.id == null) {
          //设定迁移元
          StoreProvider.of<WMSState>(context).state.contractFlag = true;
          //跳转到登录页面
          return LoginPage();
        } else {
          return ContractPage(); // 解約
        }
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'affirm',
          builder: (BuildContext context, GoRouterState state) {
            if (StoreProvider.of<WMSState>(context).state.contractParam ==
                    null ||
                StoreProvider.of<WMSState>(context).state.login == false) {
              //跳转到登录页面
              return LoginPage();
            } else {
              return ContractAffirmPage(); // 解約確認
            }
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'thank',
              builder: (BuildContext context, GoRouterState state) {
                return ContractThank(); // ご利用いただきましてありがとうございました-sp
              },
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      pageBuilder: (BuildContext context, GoRouterState state, Widget child) =>
          CustomTransitionPage<void>(
        // key: state.pageKey,
        child: HomePage(child: child),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
      routes: <RouteBase>[
        GoRoute(
          name: HomeMainPage.sName,
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return HomeMainPage(); // 首页
          },
          routes: <RouteBase>[
            GoRoute(
              path: Config.PAGE_FLAG_2_1 + '/:receiveId',
              builder: (BuildContext context, GoRouterState state) {
                return ReserveInputPage(
                  receiveId:
                      int.parse(state.pathParameters['receiveId'].toString()),
                ); // 入荷予定入力
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return ReserveInputDetails(
                      flag: int.parse(state.pathParameters['flag'].toString()),
                      receiveId: int.parse(
                          state.pathParameters['receiveId'].toString()),
                    ); // 入荷予定入力-sp 详细明细跳转
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_2_3 + '/:receiveId',
              builder: (BuildContext context, GoRouterState state) {
                return GoodsReceiptInputPage(
                    receiveId:
                        state.pathParameters['receiveId'].toString()); // 入庫入力
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details' + '/:incomingNumber' + '/:receiveId',
                  builder: (BuildContext context, GoRouterState state) {
                    return GoodsReceiptInputDetailsPage(
                        incomingNumber:
                            state.pathParameters['incomingNumber'].toString(),
                        receiveId: state.pathParameters['receiveId']
                            .toString()); // 入庫入力
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_2_4,
              builder: (BuildContext context, GoRouterState state) {
                return IncomingInspectionPage(); // 入荷检品
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:receiveId/:receiveNo',
                  builder: (BuildContext context, GoRouterState state) {
                    return IncomingInspectionDetail(
                        receiveId: int.parse(
                            state.pathParameters['receiveId'].toString()),
                        receiveNo: state.pathParameters['receiveNo']
                            .toString()); // 入荷检品明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_2_5,
              builder: (BuildContext context, GoRouterState state) {
                return InquirySchedulePage(); // 入荷予定照会
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:receiveId', // Config.PAGE_FLAG_60_2_5
                  builder: (BuildContext context, GoRouterState state) {
                    return InquiryScheduleDetailsPage(
                      receiveId: int.parse(
                          state.pathParameters['receiveId'].toString()),
                    ); // 入荷予定照会明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_2_7,
              builder: (BuildContext context, GoRouterState state) {
                return WarehouseQueryCommodityPage(); // 入庫照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_2_12,
              builder: (BuildContext context, GoRouterState state) {
                return IncomeConfirmationPage(); // 入荷確定
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details', // Config.PAGE_FLAG_60_2_12_1
                  builder: (BuildContext context, GoRouterState state) {
                    return IncomeConfirmationDetail(); // 入荷確定明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_2_16,
              builder: (BuildContext context, GoRouterState state) {
                return ConfirmationDataPage(); // 入荷確定データ出力
              },
            ),
            GoRoute(
              path: 'instructioninput/:shipId', // Config.PAGE_FLAG_3_1
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  CustomTransitionPage<void>(
                // key: state.pageKey,
                child: InstructionInputPage(
                    shipId: int.parse(
                        state.pathParameters['shipId'].toString())), //出荷指示入力
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        FadeTransition(opacity: animation, child: child),
              ),
              routes: <RouteBase>[
                GoRoute(
                  path: 'table', // Config.PAGE_FLAG_3_1
                  builder: (BuildContext context, GoRouterState state) {
                    return InstructionInputTable(
                        shipId: int.parse(state.pathParameters['shipId']
                            .toString())); // 出荷指示table一览-SP
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'details' + '/:flag', // Config.PAGE_FLAG_3_1
                      builder: (BuildContext context, GoRouterState state) {
                        return InstructionInputDetails(
                          shipId: int.parse(
                              state.pathParameters['shipId'].toString()),
                          flag: int.parse(
                              state.pathParameters['flag'].toString()),
                        );
                        // 出荷指示明细-SP
                      },
                    ),
                  ],
                ),
                // GoRoute(
                //   path: 'details/:shipId', // Config.PAGE_FLAG_3_1
                //   builder: (BuildContext context, GoRouterState state) {
                //     return InstructionInputTable(
                //         shipId: int.parse(state.pathParameters['shipId']
                //             .toString())); // 出荷指示明细-SP
                //   },
                // ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_5,
              builder: (BuildContext context, GoRouterState state) {
                return DisplayInstructionPage(); // 出荷指示照会
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:shipId', // Config.PAGE_FLAG_60_3_5
                  builder: (BuildContext context, GoRouterState state) {
                    return const DisplayInstructionPackingslip(); // 出荷指示明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_8,
              builder: (BuildContext context, GoRouterState state) {
                return PickListCommodityPage(); // ピッキングリスト （シングル）
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details', // Config.PAGE_FLAG_60_3_8
                  builder: (BuildContext context, GoRouterState state) {
                    return PickListPackingSlipPage(); // ピッキングリスト（シングル）明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'lackgoodsinvoice', // Config.PAGE_FLAG_3_11
              builder: (BuildContext context, GoRouterState state) {
                return LackGoodsInvoicePage(); // 欠品伝票照会
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:shipId', // Config.PAGE_FLAG_60_3_11
                  builder: (BuildContext context, GoRouterState state) {
                    return LackGoodsInvoiceDetails(); // 欠品伝票照会明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_12 + '/:ckId',
              builder: (BuildContext context, GoRouterState state) {
                return ExitInputPage(
                    shipId: int.parse(
                        state.pathParameters['ckId'].toString())); // 出庫入力
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details' + '/:shipCodeValue' + '/:shipId',
                  builder: (BuildContext context, GoRouterState state) {
                    return exitInputDetailsPage(
                        shipCodeValue:
                            state.pathParameters['shipCodeValue'].toString(),
                        shipId:
                            state.pathParameters['shipId'].toString()); // 出庫入力
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_13,
              builder: (BuildContext context, GoRouterState state) {
                return ShipmentInspectionPage(); // 出荷検品
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details' +
                      '/:shipNo' +
                      '/:shipId' +
                      '/:index' +
                      '/:pageNum',
                  builder: (BuildContext context, GoRouterState state) {
                    return ShipmentInspectionDetailsPage(
                      shipNo: state.pathParameters['shipNo'].toString(),
                      shipId: state.pathParameters['shipId'].toString(),
                      index: state.pathParameters['index'].toString(),
                      pageNum: state.pathParameters['pageNum'].toString(),
                    );
                    // 出荷検品詳細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_16,
              builder: (BuildContext context, GoRouterState state) {
                return OutboundQueryCommodityPage(); // 出庫照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_21,
              builder: (BuildContext context, GoRouterState state) {
                return CommodityPage(); // 納品書
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:shipId', // Config.PAGE_FLAG_60_3_21
                  builder: (BuildContext context, GoRouterState state) {
                    return PackingSlipPage(
                        shipId: int.parse(
                            state.pathParameters['shipId'].toString())); // 納品明細
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_26,
              builder: (BuildContext context, GoRouterState state) {
                return ShipmentDeterminationPage(); // 出荷确定
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details', // Config.PAGE_FLAG_60_3_26
                  builder: (BuildContext context, GoRouterState state) {
                    return ShipmentDeterminationPageDetail(); // 出荷确定详细
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_3_28,
              builder: (BuildContext context, GoRouterState state) {
                return ShipmentConfirmationExportPage(); // 出荷確定データ
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_1,
              builder: (BuildContext context, GoRouterState state) {
                return InventoryInquiryPage(); // 在庫照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_4,
              builder: (BuildContext context, GoRouterState state) {
                return ReturnProductPage(); // 返品入力
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_8,
              builder: (BuildContext context, GoRouterState state) {
                return ReturnsNotePage(); // 返品照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_10,
              builder: (BuildContext context, GoRouterState state) {
                return RevenueAndExpenditurePage(); // 受払照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_13,
              builder: (BuildContext context, GoRouterState state) {
                return GoodsTransferEntryPage(); // 在庫移動入力
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'detail' +
                      '/:locationIdFrom' +
                      '/:locationCodeFrom' +
                      '/:productId' +
                      '/:productCode',
                  builder: (BuildContext context, GoRouterState state) {
                    int locationIdFrom = int.parse(
                        state.pathParameters['locationIdFrom'].toString());
                    String locationCodeFrom =
                        state.pathParameters['locationCodeFrom'].toString();
                    int productId =
                        int.parse(state.pathParameters['productId'].toString());
                    String productCode =
                        state.pathParameters['productCode'].toString();
                    return GoodsTransferEntryFormDetail(
                      locationIdFrom: locationIdFrom,
                      locationCodeFrom: locationCodeFrom,
                      productId: productId,
                      productCode: productCode,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_16,
              builder: (BuildContext context, GoRouterState state) {
                return InventoryTransferInquiryPage(); // 在庫移動照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_17,
              builder: (BuildContext context, GoRouterState state) {
                return OutboundAdjustPage(); // 在库调整入力
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'adjustinput/:id' + '/:pageFlag',
                  builder: (BuildContext context, GoRouterState state) {
                    return OutboundAdjustForm(
                        id: int.parse(state.pathParameters['id'].toString()),
                        pageFlag: int.parse(
                            state.pathParameters['pageFlag'].toString()));
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_4_18,
              builder: (BuildContext context, GoRouterState state) {
                return InventoryAdjustInquiryPage(); // 在庫調整照会
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_5_1,
              builder: (BuildContext context, GoRouterState state) {
                return StartInventoryPage(); // 棚卸開始
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_5_3,
              builder: (BuildContext context, GoRouterState state) {
                return InventoryOutputPage(); // 棚卸データ出力
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_5_9,
              builder: (BuildContext context, GoRouterState state) {
                return InventoryQueryPage(); // 棚卸照会
              },
              routes: <RouteBase>[
                GoRoute(
                    path: 'details/:detailId', // Config.PAGE_FLAG_60_5_9
                    builder: (BuildContext context, GoRouterState state) {
                      return InventoryQueryDetailPage(
                          detailId: int.parse(state.pathParameters['detailId']
                              .toString())); // 棚卸照会詳細
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: Config.PAGE_FLAG_60_5_2 +
                            '/:MactualId' +
                            '/:actualId' +
                            '/:actualState' +
                            '/:actualDate' +
                            '/:warehouse',
                        builder: (BuildContext context, GoRouterState state) {
                          return ActualShelfPage(
                            MactualId: int.parse(
                                state.pathParameters['MactualId'].toString()),
                            actualId: int.parse(
                                state.pathParameters['actualId'].toString()),
                            actualState: int.parse(
                                state.pathParameters['actualState'].toString()),
                            actualDate:
                                state.pathParameters['actualDate'].toString(),
                            warehouse:
                                state.pathParameters['warehouse'].toString(),
                          ); // 実棚明細入力
                        },
                      ),
                    ]),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_5_11,
              builder: (BuildContext context, GoRouterState state) {
                return InventoryConfirmedPage(); // 棚卸確定
              },
            ),
            GoRoute(
              path: 'companyMaster', //Config.PAGE_FLAG_8_1,
              builder: (BuildContext context, GoRouterState state) {
                return CompanyMasterPage(); // 会社情報マスタ管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:companyId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    //companyId 判断是否是登录还是修正（为什么不用一个变量，暂未修正）
                    //flag 判断是否是明细还是登录、修正
                    return CompanyMasterForm(
                        companyId: int.parse(
                            state.pathParameters['companyId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 会社情報マスタ管理明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'shippingMaster',
              builder: (BuildContext context, GoRouterState state) {
                return ShippingMasterPage(); // 荷主マスタ
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'form/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return ShippingMasterForm(
                        flag: state.pathParameters['flag']
                            .toString()); // 荷主マスタ明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'productMaster', //Config.PAGE_FLAG_8_4
              builder: (BuildContext context, GoRouterState state) {
                return ProductMasterManagementPage(); // 商品マスタ管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:productId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return ProductMasterManagementForm(
                        productId: int.parse(
                            state.pathParameters['productId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 商品マスタ管理明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'organizationMaster', // Config.PAGE_FLAG_8_5
              builder: (BuildContext context, GoRouterState state) {
                return OrganizationMasterPage(); // 組織マスタ
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'from/:flag_num',
                  builder: (BuildContext context, GoRouterState state) {
                    return OrganizationMasterForm(
                      flag_num: state.pathParameters['flag_num'].toString(),
                    ); // 組織マスタ
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_6,
              builder: (BuildContext context, GoRouterState state) {
                return CustomerMasterPage(); // 得意先マスタ管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:customerId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return CustomerMasterForm(
                        customerId: int.parse(
                            state.pathParameters['customerId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 倉庫マスタ明细页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_10,
              builder: (BuildContext context, GoRouterState state) {
                return SupplierMasterPage(); //仕入先マスタ -cuihr
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'from/:flag_num',
                  builder: (BuildContext context, GoRouterState state) {
                    return SupplierMasterInformation(
                      flag_num: state.pathParameters['flag_num'].toString(),
                    ); // 仕入先マスタ
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_16,
              builder: (BuildContext context, GoRouterState state) {
                return LocationMasterPage(); // ロケーションマスタ
              },
              // luxy-sp
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:locationId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return LocationMasterForm(
                        locationId: int.parse(
                            state.pathParameters['locationId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // ロケーションマスタ明细页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_19,
              builder: (BuildContext context, GoRouterState state) {
                return WarehouseMasterPage(); // 倉庫マスタ
              },
              // luxy-sp
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:warehouseId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return WarehouseMasterForm(
                        warehouseId: int.parse(
                            state.pathParameters['warehouseId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 倉庫マスタ明细页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'roleMaster', // Config.PAGE_FLAG_8_22,
              builder: (BuildContext context, GoRouterState state) {
                return RoleMasterPage(); // ロールマスタ
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:roleId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return RoleMasterForm(
                        roleId: int.parse(
                            state.pathParameters['roleId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // ロールマスタ管理明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_23,
              builder: (BuildContext context, GoRouterState state) {
                return DeliveryPage(); // 納入先マスタ管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:deliveryId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return DeliveryForm(
                        deliveryId: int.parse(
                            state.pathParameters['deliveryId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 納入先マスタ明细页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_21,
              builder: (BuildContext context, GoRouterState state) {
                return CalendarMasterPage(); // カレンダーマスタ管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:calendarId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return CalendarMasterForm(
                        calendarId: int.parse(
                            state.pathParameters['calendarId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // カレンダーマスタ管理-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'formMaster',
              builder: (BuildContext context, GoRouterState state) {
                return FormMasterPage(); // 帳票マスタ
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'adjust',
                  builder: (BuildContext context, GoRouterState state) {
                    return FormMasterForm(); // 帳票マスタ调整
                  },
                ),
                GoRoute(
                  path: 'details/:formId',
                  builder: (BuildContext context, GoRouterState state) {
                    return FormMasterDetailPage(
                      formId:
                          int.parse(state.pathParameters['formId'].toString()),
                    ); // 帳票マスタ明细
                  },
                ),
                GoRoute(
                  path: 'details/adjust/:formId',
                  builder: (BuildContext context, GoRouterState state) {
                    return FormMasterDetailForm(
                      formId:
                          int.parse(state.pathParameters['formId'].toString()),
                    ); // 帳票マスタ明细调整
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_50_1,
              builder: (BuildContext context, GoRouterState state) {
                return AccountPage(); // アカウント
              },
              // xcy-sp
              routes: <RouteBase>[
                GoRoute(
                  path: 'profile',
                  builder: (BuildContext context, GoRouterState state) {
                    return AccountContentProfile(); // 账户编辑页面-sp
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'detail/:action',
                      builder: (BuildContext context, GoRouterState state) {
                        return AccountContentProfileForm(
                            action: int.parse(state.pathParameters['action']
                                .toString())); // 账户编辑页面-sp
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'security',
                  builder: (BuildContext context, GoRouterState state) {
                    return AccountContentSecurity(); // 安全页面-sp
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'detail',
                      builder: (BuildContext context, GoRouterState state) {
                        return AccountContentSecurityForm(); // 账户编辑页面-sp
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'license',
                  builder: (BuildContext context, GoRouterState state) {
                    return AccountContentLicense(); // 许可证页面-sp
                  },
                ),
                GoRoute(
                  path: 'plan',
                  builder: (BuildContext context, GoRouterState state) {
                    return AccountContentPlan(); // 计划页面-sp
                  },
                  routes: <RouteBase>[
                    GoRoute(
                      path: 'formDetail',
                      builder: (BuildContext context, GoRouterState state) {
                        return AccountContentPlanForm(); // 计划详情页面-sp
                      },
                    ),
                    GoRoute(
                      path: 'cancelDetail',
                      builder: (BuildContext context, GoRouterState state) {
                        return AccountContentPlanCancel(); // 解约详情页面-sp
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: 'code',
                  builder: (BuildContext context, GoRouterState state) {
                    return AccountContentCode(); // 扫码页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_50_2 +
                  '/notice/:index', // Config.PAGE_FLAG_50_2
              builder: (BuildContext context, GoRouterState state) {
                return HomeHeadNoticePage(
                  index: int.parse(state.pathParameters['index'].toString()),
                ); // 新着通知
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details', // Config.PAGE_FLAG_50_2_1
                  builder: (BuildContext context, GoRouterState state) {
                    return HomeHeadNoticeDetails(); // 新着通知详细页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'menuMaster', // Config.PAGE_FLAG_98_5,
              builder: (BuildContext context, GoRouterState state) {
                return MenuMasterPage(); // メニューマスタ管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:menuId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return MenuMasterForm(
                        menuId: int.parse(
                            state.pathParameters['menuId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // メニューマスタ管理明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'authMaster', //Config.PAGE_FLAG_98_8
              builder: (BuildContext context, GoRouterState state) {
                return AuthPage(); // 権限マスタ
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:authId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return AuthForm(
                        authId: int.parse(
                            state.pathParameters['authId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 権限マスタ管理明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_98_11,
              builder: (BuildContext context, GoRouterState state) {
                return MessageMasterPage(); // メッセージマスタ
              },
            ),
            GoRoute(
              path: 'chargeManagement', // Config.PAGE_FLAG_98_22,
              builder: (BuildContext context, GoRouterState state) {
                return ChargeManagementPage(); // 課金法人管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:chargeId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return ChargeManagementForm(
                        chargeId: int.parse(
                            state.pathParameters['chargeId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 課金法人管理明细
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_98_24, // Config.PAGE_FLAG_98_24,
              builder: (BuildContext context, GoRouterState state) {
                return UserLicenseManagementPage(); // ユーザーライセンス管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'adjust',
                  builder: (BuildContext context, GoRouterState state) {
                    return UserLicenseManagementForm(); // ユーザーライセンス管理明细
                  },
                ),
                GoRoute(
                  path: 'details/:detailId',
                  builder: (BuildContext context, GoRouterState state) {
                    return UserLicenseManagementDetailPage(); // ユーザーライセンス管理明细-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'planManagement/:currentMenuIndex',
              builder: (BuildContext context, GoRouterState state) {
                return PlanManagementPage(
                    currentMenuIndex: int.parse(state
                        .pathParameters['currentMenuIndex']
                        .toString())); // プラン管理
              },
            ),
            GoRoute(
              path: 'corporateManagement/:currentMenuIndex',
              builder: (BuildContext context, GoRouterState state) {
                return CorporateManagementPage(
                    currentMenuIndex: int.parse(state
                        .pathParameters['currentMenuIndex']
                        .toString())); // 法人管理
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_8_7,
              builder: (BuildContext context, GoRouterState state) {
                return DeliveryOperatorsMasterPage(); // 配送業者マスタ
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:deliveryId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return DeliveryOperatorsMasterForm(
                        deliveryId: int.parse(
                            state.pathParameters['deliveryId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // 配送業者マスタ明细页面-sp
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_9 + '/:productCodeOrJanCd/:pageKey',
              builder: (BuildContext context, GoRouterState state) {
                return ProductInformationPage(
                  productCodeOrJanCd:
                      state.pathParameters['productCodeOrJanCd'].toString(),
                  pageKey: state.pathParameters['pageKey'].toString(),
                ); // 商品情报
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_99_6,
              builder: (BuildContext context, GoRouterState state) {
                return OperateLogPage(); // 操作ログ
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_99_2,
              builder: (BuildContext context, GoRouterState state) {
                return InformationManagementPage(); // 基本設定
              },
            ),
            GoRoute(
              path: Config.PAGE_FLAG_98_23,
              builder: (BuildContext context, GoRouterState state) {
                return LicenseManagementPage(); // ライセンス管理
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details/:licenseId' + '/:flag',
                  builder: (BuildContext context, GoRouterState state) {
                    return LicenseManagementForm(
                        licenseId: int.parse(
                            state.pathParameters['licenseId'].toString()),
                        flag: int.parse(state.pathParameters['flag']
                            .toString())); // ライセンス管理明细
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_98_25,
              builder: (BuildContext context, GoRouterState state) {
                return ApplicationCceptancePage(); // 申込受付
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'details', // Config.PAGE_FLAG_60_98_25
                  builder: (BuildContext context, GoRouterState state) {
                    return ApplicationCceptanceDetail(); // 申込详细
                  },
                ),
              ],
            ),
            GoRoute(
              path: Config.PAGE_FLAG_98_26,
              builder: (BuildContext context, GoRouterState state) {
                return ApplicationCancelPage(); // 解约受付
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorPage(),
);
