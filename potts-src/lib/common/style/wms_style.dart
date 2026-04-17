import 'package:flutter/material.dart';

///颜色
class WMSColors {
  static const int primaryIntValue = 0xFF24292E;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryIntValue,
    const <int, Color>{
      50: const Color(primaryIntValue),
      100: const Color(primaryIntValue),
      200: const Color(primaryIntValue),
      300: const Color(primaryIntValue),
      400: const Color(primaryIntValue),
      500: const Color(primaryIntValue),
      600: const Color(primaryIntValue),
      700: const Color(primaryIntValue),
      800: const Color(primaryIntValue),
      900: const Color(primaryIntValue),
    },
  );

  static const String primaryValueString = "#24292E";
  static const String primaryLightValueString = "#42464b";
  static const String primaryDarkValueString = "#121917";
  static const String miWhiteString = "#ececec";
  static const String actionBlueString = "#267aff";
  static const String webDraculaBackgroundColorString = "#282a36";

  static const Color primaryValue = Color(0xFF24292E);
  static const Color primaryLightValue = Color(0xFF42464b);
  static const Color primaryDarkValue = Color(0xFF121917);

  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color miWhite = Color(0xffececec);
  static const Color white = Color(0xFFFFFFFF);
  static const Color actionBlue = Color(0xff267aff);
  static const Color subTextColor = Color(0xff959595);
  static const Color subLightTextColor = Color(0xffc4c4c4);

  static const Color mainBackgroundColor = miWhite;

  static const Color mainTextColor = primaryDarkValue;
  static const Color textColorWhite = white;
}

///文本样式
class WMSConstant {
  static const lagerTextSize = 30.0;
  static const bigTextSize = 23.0;
  static const normalTextSize = 18.0;
  static const middleTextWhiteSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;

  static const minText = TextStyle(
    color: WMSColors.subLightTextColor,
    fontSize: minTextSize,
  );

  static const smallTextWhite = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: smallTextSize,
  );

  static const smallText = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: smallTextSize,
  );

  static const smallTextBold = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: smallTextSize,
    fontWeight: FontWeight.bold,
  );

  static const smallSubLightText = TextStyle(
    color: WMSColors.subLightTextColor,
    fontSize: smallTextSize,
  );

  static const smallActionLightText = TextStyle(
    color: WMSColors.actionBlue,
    fontSize: smallTextSize,
  );

  static const smallMiLightText = TextStyle(
    color: WMSColors.miWhite,
    fontSize: smallTextSize,
  );

  static const smallSubText = TextStyle(
    color: WMSColors.subTextColor,
    fontSize: smallTextSize,
  );

  static const middleText = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: middleTextWhiteSize,
  );

  static const middleTextWhite = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: middleTextWhiteSize,
  );

  static const middleSubText = TextStyle(
    color: WMSColors.subTextColor,
    fontSize: middleTextWhiteSize,
  );

  static const middleSubLightText = TextStyle(
    color: WMSColors.subLightTextColor,
    fontSize: middleTextWhiteSize,
  );

  static const middleTextBold = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );

  static const middleTextWhiteBold = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );

  static const middleSubTextBold = TextStyle(
    color: WMSColors.subTextColor,
    fontSize: middleTextWhiteSize,
    fontWeight: FontWeight.bold,
  );

  static const normalText = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: normalTextSize,
  );

  static const normalTextBold = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  static const normalSubText = TextStyle(
    color: WMSColors.subTextColor,
    fontSize: normalTextSize,
  );

  static const normalTextWhite = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: normalTextSize,
  );

  static const normalTextMitWhiteBold = TextStyle(
    color: WMSColors.miWhite,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  static const normalTextActionWhiteBold = TextStyle(
    color: WMSColors.actionBlue,
    fontSize: normalTextSize,
    fontWeight: FontWeight.bold,
  );

  static const normalTextLight = TextStyle(
    color: WMSColors.primaryLightValue,
    fontSize: normalTextSize,
  );

  static const largeText = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: bigTextSize,
  );

  static const largeTextBold = TextStyle(
    color: WMSColors.mainTextColor,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
  );

  static const largeTextWhite = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: bigTextSize,
  );

  static const largeTextWhiteBold = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: bigTextSize,
    fontWeight: FontWeight.bold,
  );

  static const largeLargeTextWhite = TextStyle(
    color: WMSColors.textColorWhite,
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
  );

  static const largeLargeText = TextStyle(
    color: WMSColors.primaryValue,
    fontSize: lagerTextSize,
    fontWeight: FontWeight.bold,
  );
}

class WMSICons {
  static const String FONT_FAMILY = 'wxcIconFont';

  static const String DEFAULT_ERROR = 'assets/images/error.png';
  static const String DEFAULT_USER_ICON = 'assets/images/logo.png';
  static const String DEFAULT_LOFIN_LETTER = 'assets/images/login_letter.png';
  static const String DEFAULT_EYE_OPEN_ICON = 'assets/images/eye_open.png';
  static const String DEFAULT_EYE_CLOSE_ICON = 'assets/images/eye_close.png';
  static const String DEFAULT_IMAGE = 'assets/images/default_img.png';
  static const String REGRET_IMAGE = 'assets/images/regret.png';

  static const IconData HOME =
      const IconData(0xe624, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData MORE =
      const IconData(0xe674, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData SEARCH =
      const IconData(0xe61c, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData MAIN_DT =
      const IconData(0xe684, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData MAIN_QS =
      const IconData(0xe818, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData MAIN_MY =
      const IconData(0xe6d0, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData MAIN_SEARCH =
      const IconData(0xe61c, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData LOGIN_USER =
      const IconData(0xe666, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData LOGIN_PW =
      const IconData(0xe60e, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData REPOS_ITEM_USER =
      const IconData(0xe63e, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_STAR =
      const IconData(0xe643, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_FORK =
      const IconData(0xe67e, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_ISSUE =
      const IconData(0xe661, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData REPOS_ITEM_STARED =
      const IconData(0xe698, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_WATCH =
      const IconData(0xe681, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_WATCHED =
      const IconData(0xe629, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_DIR = Icons.folder;
  static const IconData REPOS_ITEM_FILE =
      const IconData(0xea77, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData REPOS_ITEM_NEXT =
      const IconData(0xe610, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData USER_ITEM_COMPANY =
      const IconData(0xe63e, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData USER_ITEM_LOCATION =
      const IconData(0xe7e6, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData USER_ITEM_LINK =
      const IconData(0xe670, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData USER_NOTIFY =
      const IconData(0xe600, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData ISSUE_ITEM_ISSUE =
      const IconData(0xe661, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData ISSUE_ITEM_COMMENT =
      const IconData(0xe6ba, fontFamily: WMSICons.FONT_FAMILY);
  static const IconData ISSUE_ITEM_ADD =
      const IconData(0xe662, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData ISSUE_EDIT_H1 = Icons.filter_1;
  static const IconData ISSUE_EDIT_H2 = Icons.filter_2;
  static const IconData ISSUE_EDIT_H3 = Icons.filter_3;
  static const IconData ISSUE_EDIT_BOLD = Icons.format_bold;
  static const IconData ISSUE_EDIT_ITALIC = Icons.format_italic;
  static const IconData ISSUE_EDIT_QUOTE = Icons.format_quote;
  static const IconData ISSUE_EDIT_CODE = Icons.format_shapes;
  static const IconData ISSUE_EDIT_LINK = Icons.insert_link;

  static const IconData NOTIFY_ALL_READ =
      const IconData(0xe62f, fontFamily: WMSICons.FONT_FAMILY);

  static const IconData PUSH_ITEM_EDIT = Icons.mode_edit;
  static const IconData PUSH_ITEM_ADD = Icons.add_box;
  static const IconData PUSH_ITEM_MIN = Icons.indeterminate_check_box;

  //luxy-start
  static const String HOME_MAIN_PAGE_ELLIPSIS_1 =
      'assets/images/home_main_page_ellipsis1.png';

  static const String HOME_MAIN_PAGE_ELLIPSIS_2 =
      'assets/images/home_main_page_ellipsis2.png';

  static const String HOME_head_NOTICE_PAGE_IMG1 =
      'assets/images/head_notice.png';
  static const String HOME_head_NOTICE_PAGE_IMG2 =
      'assets/images/head_notice1.png';

  static const String HOME_HEAD_NOTICE_PAGE_DEL_IMG =
      'assets/images/head_notice_del.png';

  static const String HOME_HEAD_NOTICE_PAGE_JUMP_IMG =
      'assets/images/head_notice_jump.png';

  //luxy-end

  // 赵士淞 - 始
  // 首页底部搜索
  static const String HOME_BOTTOM_SEARCH =
      'assets/images/home_bottom_search.png';
  // 首页头部LOGO
  static const String HOME_HEAD_LOGO = 'assets/images/home_head_logo.png';
  // 申请首页头部LOGO
  static const String HOME_HEAD_REGISTER_LOGO =
      'assets/images/home_head_register_logo.png';
  // 首页头部LOGO（黑色）
  static const String HOME_HEAD_LOGO_BLACK =
      'assets/images/home_head_logo_black.png';

  // 首页头部搜索
  static const String HOME_HEAD_SEARCH = 'assets/images/home_head_search.png';
  // 首页头部提示
  static const String HOME_HEAD_NOTICE = 'assets/images/home_head_notice.png';
  // 首页头部用户
  static const String HOME_HEAD_USER = 'assets/images/home_head_user.png';
  // 首页头部更多
  static const String HOME_HEAD_MORE = 'assets/images/home_head_more.png';
  // 首页头部语言
  static const String HOME_HEAD_LANGUAGE =
      'assets/images/home_head_language.png';
  // 首页菜单关闭
  static const String HOME_MENU_CLOSE = 'assets/images/home_menu_close.png';
  // 首页菜单打开
  static const String HOME_MENU_OPEN = 'assets/images/home_menu_open.png';
  // 出荷指示入力文件CSV
  static const String INSTRUCTION_INPUT_FILE_CSV =
      'assets/images/instruction_input_file_csv.png';
  // 出荷指示入力文件API
  static const String INSTRUCTION_INPUT_FILE_API =
      'assets/images/instruction_input_file_api.png';
  // 出荷指示入力表格更多
  static const String INSTRUCTION_INPUT_TABLE_MORE =
      'assets/images/instruction_input_table_more.png';
  // 出荷指示入力表格关闭
  static const String INSTRUCTION_INPUT_TABLE_CLOSE =
      'assets/images/instruction_input_table_close.png';
  // 账户用户默认
  static const String ACCOUNT_CONTENT_USER_DEFAULT =
      'assets/images/account_content_user_default.png';
  // 账户简介用户
  static const String ACCOUNT_CONTENT_PROFILE_USER =
      'assets/images/account_content_profile_user.png';
  // 账户简介邮箱
  static const String ACCOUNT_CONTENT_PROFILE_EMAIL =
      'assets/images/account_content_profile_email.png';
  // 账户简介地址
  static const String ACCOUNT_CONTENT_PROFILE_ADDRESS =
      'assets/images/account_content_profile_address.png';
  // 账户简介昵称
  static const String ACCOUNT_CONTENT_PROFILE_RENAME =
      'assets/images/account_content_profile_rename.png';
  // 账户简介多语言
  static const String ACCOUNT_CONTENT_PROFILE_LANGUAGE =
      'assets/images/account_content_profile_language.png';
  // 账户简介公司
  static const String ACCOUNT_CONTENT_PROFILE_COMPANY =
      'assets/images/account_content_profile_company.png';
  // 账户简介角色
  static const String ACCOUNT_CONTENT_PROFILE_ROLE =
      'assets/images/account_content_profile_role.png';
  // 账户简介状态
  static const String ACCOUNT_CONTENT_PROFILE_STATE =
      'assets/images/account_content_profile_state.png';
  // 账户简介计划
  static const String ACCOUNT_CONTENT_PROFILE_PLAN =
      'assets/images/account_content_profile_plan.png';
  // 账户简介付款
  static const String ACCOUNT_CONTENT_PROFILE_PAYMENT =
      'assets/images/account_content_profile_payment.png';
  // 账户简介日期
  static const String ACCOUNT_CONTENT_PROFILE_DATE =
      'assets/images/account_content_profile_date.png';
  // 账户安全密码
  static const String ACCOUNT_CONTENT_SECURITY_PASSWORD =
      'assets/images/account_content_security_password.png';

  // 计划图标
  static const String PLAN_ICON = 'assets/images/plan_icon.png';

  // 打印头部LOGO
  static const String PRINT_HEAD_LOGO = 'assets/images/home_head_logo.svg';
  // 打印字体
  static const String PRINT_FONT = 'assets/font/stkaiti.ttf';
  // 打印表格表头背景
  static const String PRINT_TABLE_HEADER_BACKGROUND =
      'assets/images/print_table_header_background.svg';
  // 打印LOGO
  static const String PRINT_LOGO = 'assets/images/logo.svg';

  // 许可证
  static const String ACCOUNT_CONTENT_PERMIT_ICON =
      'assets/images/account_content_permit_icon.png';
  // 注销
  static const String ACCOUNT_CONTENT_QUIT_ICON =
      'assets/images/account_content_quit_icon.png';

  // 利用内容・アカウント管理
  static const String ACCOUNT_OTHER_CONTENTS_ACCOUNT =
      'assets/images/account_other_contents_account.png';
  // 赵士淞 - 终

  // 无图片图片
  static const String NO_IMAGE = 'assets/images/no_image.png';

  // 菜单图标 - 始
  static const String MENU_ICON_1 = 'assets/images/menu_icon_1.png';
  static const String MENU_ICON_2 = 'assets/images/menu_icon_2.png';
  static const String MENU_ICON_2_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_2_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_2_6 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_7 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_9 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_2_10 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_12 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_2_13 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_14 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_15 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_16 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_2_17 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3 = 'assets/images/menu_icon_3.png';
  static const String MENU_ICON_3_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_3_2 = 'assets/images/menu_icon_3_2.png';
  static const String MENU_ICON_3_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_3_6 = 'assets/images/menu_icon_3_6.png';
  static const String MENU_ICON_3_7 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_9 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_3_10 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_3_11 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_3_12 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_3_13 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_14 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_15 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_16 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_17 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_18 = 'assets/images/menu_icon_3_2.png';
  static const String MENU_ICON_3_19 = 'assets/images/menu_icon_3_2.png';
  static const String MENU_ICON_3_20 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_21 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_22 = 'assets/images/menu_icon_3_6.png';
  static const String MENU_ICON_3_23 = 'assets/images/menu_icon_3_6.png';
  static const String MENU_ICON_3_24 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_25 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_26 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_3_27 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_28 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_3_29 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4 = 'assets/images/menu_icon_4.png';
  static const String MENU_ICON_4_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_4_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_4_6 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_7 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_9 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_4_10 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_4_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_12 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_13 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_14 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_4_15 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_16 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_17 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_18 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_19 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_4_20 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5 = 'assets/images/menu_icon_5.png';
  static const String MENU_ICON_5_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_5_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5_3 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_5_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_5_6 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5_7 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_5_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5_9 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5_10 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_5_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6 = 'assets/images/menu_icon_6.png';
  static const String MENU_ICON_6_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_6_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_6_6 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_6_7 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_6_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6_9 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6_10 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_6_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_7 = 'assets/images/menu_icon_7.png';
  static const String MENU_ICON_7_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_7_2 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_7_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8 = 'assets/images/menu_icon_8.png';
  static const String MENU_ICON_8_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_8_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_8_6 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_7 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_9 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_8_10 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_8_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_12 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_13 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_8_14 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_15 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_16 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_17 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_18 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_19 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_20 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_21 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_22 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_23 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_8_24 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_9 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_50 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_50_1 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_50_1_1 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_50_1_2 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_50_1_3 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_50_2 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_2_5 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_3_11 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_3_26 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_2_12_1 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_2_12_2 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_3_21 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_5_9 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_3_5 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_5_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_60_5_2 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_60_98_25 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_98 = 'assets/images/menu_icon_98.png';
  static const String MENU_ICON_98_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_98_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_3 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_98_6 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_7 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_8 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_9 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_98_10 = 'assets/images/menu_icon_2_9.png';
  static const String MENU_ICON_98_11 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_12 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_13 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_14 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_98_15 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_16 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_17 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_18 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_19 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_20 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_21 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_22 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_23 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_24 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_25 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_98_26 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_99 = 'assets/images/menu_icon_99.png';
  static const String MENU_ICON_99_1 = 'assets/images/menu_icon_2_1.png';
  static const String MENU_ICON_99_2 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_99_3 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_99_4 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_99_5 = 'assets/images/menu_icon_2_2.png';
  static const String MENU_ICON_99_6 = 'assets/images/menu_icon_2_2.png';

  static const String MENU_ICON_ADMIN_1 = 'assets/images/menu_icon_1.png';
  static const String MENU_ICON_ADMIN_2 = 'assets/images/menu_icon_999_2.png';
  static const String MENU_ICON_ADMIN_3 = 'assets/images/menu_icon_999_3.png';
  static const String MENU_ICON_ADMIN_4 = 'assets/images/menu_icon_999_4.png';
  static const String MENU_ICON_ADMIN_5 = 'assets/images/menu_icon_2_5.png';
  static const String MENU_ICON_ADMIN_6 = 'assets/images/menu_icon_2_9.png';

  // 菜单图标 - 终

  // xcy - 始
  // 纳品书api图标
  static const String WAREHOUSE_API_ICON = 'assets/images/api_icon.png';
  // 纳品书csv图标
  static const String WAREHOUSE_CSV_ICON = 'assets/images/csv_icon.png';
  // 纳品书明细图标
  static const String WAREHOUSE_DETAILS_ICON = 'assets/images/details_icon.png';
  // 纳品书印刷图标
  static const String WAREHOUSE_PRINTING_ICON =
      'assets/images/printing_icon.png';
  // 纳品书搜索图标
  static const String WAREHOUSE_SEARCH_ICON = 'assets/images/search_icon.png';
  // 纳品书菜单选项图标
  static const String WAREHOUSE_MENU_ICON = 'assets/images/menu_icon.png';
  // 纳品书信息图标
  static const String WAREHOUSE_CHAT_ICON = 'assets/images/chat_icon.png';
  //マスタSP端登录图标
  static const String MASTER_LOGIN_ICON = 'assets/images/master_login_icon.png';
  // xcy -终

  // 出荷检品  xcy - 始
  // 扫描图标
  static const String SHIPMENT_INSPECTION_SCAN_ICON =
      'assets/images/shipment_inspection_scan.png';
  // 出荷检品  xcy - 终
}
