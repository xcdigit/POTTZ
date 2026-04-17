/**
 * Created by yaozc
 * Date: 2023-07-01
 */
abstract class WMSStringBase {
  String get welcomeMessage;

  String get app_name;

  String get app_ok;

  String get app_cancel;

  String get app_crows;

  String get app_empty;

  String get app_licenses;

  String get app_close;

  String get app_version;

  String get app_back_tip;

  String get app_not_new_version;

  String get app_version_title;

  String get nothing_now;

  String get loading_text;

  String get option_web;

  String get option_copy;

  String get option_share;

  String get option_web_launcher_error;

  String get option_share_title;

  String get option_share_copy_success;

  String get login_text;

  String get login_confirm_text;
  String get login_confirm_text_success;
  String get login_confirm_text_error;
  String get login_disUser_text_error;

  String get login_forget_pdw_text;

  String get login_register_text;

  String get login_register_content_text;

  String get oauth_text;

  String get Login_out;

  String get Login_deprecated;

  String get home_reply;

  String get home_change_language;

  String get home_change_grey;

  String get home_about;

  String get home_check_update;

  String get home_history;

  String get home_user_info;

  String get home_change_theme;

  String get home_language_default;

  String get home_language_zh;

  String get home_language_en;

  String get switch_language;

  String get home_theme_default;

  String get home_theme_1;

  String get home_theme_2;

  String get home_theme_3;

  String get home_theme_4;

  String get home_theme_5;

  String get home_theme_6;

  String get login_username_hint_text;

  String get login_password_hint_text;

  String get login_password_new_hint_text;

  String get login_again_pwd_hint_text;

  String get login_pwd_reset_hint_text;

  String get login_pwd_not_again_pwd_hint_text;

  String get login_email_by_forget_pwd_text;

  String get login_email_by_forget_fail_pwd_text;

  String get login_email_by_forget_error_pwd_text;

  String get login_reset_tip_modify_pwd_text;

  String get login_tip_title_modify_pwd_text;

  String get login_reset_error_modify_pwd_text;

  String get login_url_failure_modify_pwd_text;

  String get login_new_pwd_not_old_pwd_text;

  String get login_email_by_forget_pwd_id_error_text;

  String get login_success;

  String get login_error;

  String get login_role_error_admin;

  String get login_role_error_user;

  String get company_not_activated;

  String get company_has_terminated;

  String get network_error_401;

  String get network_error_403;

  String get network_error_404;

  String get network_error_422;

  String get network_error_timeout;

  String get network_error_unknown;

  String get network_error;

  String get github_refused;

  String get load_more_not;

  String get load_more_text;

  String get home_dynamic;

  String get home_trend;

  String get home_my;

  String get error_return;
  String get error_message;

  //首页 主页 luxy-start
  String get home_main_page_text1;
  String get home_main_page_text2;
  String get home_main_page_text3;
  String get home_main_page_text4;
  String get home_main_page_text5;
  String get home_main_page_text6;
  String get home_main_page_text7;
  String get home_main_page_text8;
  String get home_main_page_text9;
  String get home_main_page_text10;
  String get home_main_page_text11;
  String get home_main_page_text12;
  String get home_main_page_text13;
  String get home_main_page_text14;
  String get home_main_page_text15;
  //入/出荷予定
  String get home_main_page_table_text1;
  String get home_main_page_table_text2;
  String get home_main_page_table_text3;
  String get home_main_page_table_text4;
  String get home_main_page_table_text5;
  String get home_main_page_table_text6;
  //首页 主页 luxy-end

  //首页 头部 消息 luxy-start
  String get home_head_notice_text1;
  String get home_head_notice_text2;
  String get home_head_notice_text3;
  String get home_head_notice_text4;
  //首页 头部 消息 luxy-end

  // 赵士淞 - 始
  // 首页头部搜索提示文本
  String get home_head_search_hint_text;
  // 首页头部多语言
  String get home_head_language;
  // 首页头部多语言日文
  String get home_head_language_jp;
  // 首页头部多语言英文
  String get home_head_language_en;
  // 首页头部多语言简体中文
  String get home_head_language_zh;
  // 首页头部多语言繁体中文
  String get home_head_language_tc;

  // 出荷指示入力：CSV下载
  String get instruction_input_csv_download;
  // 出荷指示入力：API下载
  String get instruction_input_api_download;
  // 出荷指示入力：Tab基本情報入力
  String get instruction_input_tab_basic;
  // 出荷指示入力：Tab出荷先情報入力
  String get instruction_input_tab_before;
  String get instruction_input_tab_before_text;
  // 出荷指示入力：Tab詳細情報入力
  String get instruction_input_tab_detail;
  // 出荷指示入力：Tab一覧
  String get instruction_input_tab_list;
  // 出荷指示入力：Tab入金待ち
  String get instruction_input_tab_payment;
  // 出荷指示入力：Tab引当待ち
  String get instruction_input_tab_allowance;
  // 出荷指示入力：Tab出荷待ち
  String get instruction_input_tab_wait;
  // 出荷指示入力：Tab出荷作業中
  String get instruction_input_tab_work;
  // 出荷指示入力：Tab出荷済み
  String get instruction_input_tab_complete;
  // 出荷指示入力：Tab登録
  String get instruction_input_tab_button_add;
  // 出荷指示入力：Tab修正
  String get instruction_input_tab_button_update;
  // 出荷指示入力：Tab全選択
  String get instruction_input_tab_button_choice;
  // 出荷指示入力：Tab全解除
  String get instruction_input_tab_button_cancellation;
  // 出荷指示入力：Tab明細
  String get instruction_input_tab_button_details;
  // 出荷指示入力：Tab明細行を追加
  String get instruction_input_tab_button_details_add;
  // 出荷指示入力：TabCSV
  String get instruction_input_tab_button_csv;
  // 出荷指示入力：TabAPI
  String get instruction_input_tab_button_api;
  // 出荷指示入力：Tab印刷
  String get instruction_input_tab_button_print;
  // 出荷指示入力：基本情報入力-出荷指示番号
  String get instruction_input_form_basic_1;
  // 出荷指示入力：基本情報入力-得意先注文番号
  String get instruction_input_form_basic_2;
  // 出荷指示入力：基本情報入力-出荷指示日
  String get instruction_input_form_basic_3;
  // 出荷指示入力：基本情報入力-得意先名
  String get instruction_input_form_basic_4;
  // 出荷指示入力：基本情報入力-納入日
  String get instruction_input_form_basic_5;
  // 出荷指示入力：基本情報入力-得意先コード
  String get instruction_input_form_basic_6;
  // 出荷指示入力：基本情報入力-指定納期
  String get instruction_input_form_basic_7;
  // 出荷指示入力：基本情報入力-納入先名
  String get instruction_input_form_basic_8;
  // 出荷指示入力：基本情報入力-注意備考1
  String get instruction_input_form_basic_9;
  // 出荷指示入力：基本情報入力-注意備考2
  String get instruction_input_form_basic_10;
  // 出荷指示入力：基本情報入力-納入先コード
  String get instruction_input_form_basic_11;
  // 出荷指示入力：基本情報入力-得意先備考
  String get instruction_input_form_basic_12;
  // 出荷指示入力：基本情報入力-社内備考
  String get instruction_input_form_basic_13;
  // 出荷指示入力：出荷先情報入力-郵便番号
  String get instruction_input_form_before_1;
  // 出荷指示入力：出荷先情報入力-納入先担当者名
  String get instruction_input_form_before_2;
  // 出荷指示入力：出荷先情報入力-都道府県
  String get instruction_input_form_before_3;
  // 出荷指示入力：出荷先情報入力-区市町村
  String get instruction_input_form_before_4;
  // 出荷指示入力：出荷先情報入力-出荷担当者名
  String get instruction_input_form_before_5;
  // 出荷指示入力：出荷先情報入力-住所1
  String get instruction_input_form_before_6;
  // 出荷指示入力：出荷先情報入力-出荷担当者コード
  String get instruction_input_form_before_7;
  // 出荷指示入力：出荷先情報入力-住所2（建物名など）
  String get instruction_input_form_before_8;
  // 出荷指示入力：出荷先情報入力-出荷担当部門名
  String get instruction_input_form_before_9;
  // 出荷指示入力：出荷先情報入力-電話番号
  String get instruction_input_form_before_10;
  // 出荷指示入力：出荷先情報入力-出荷担当部門コード
  String get instruction_input_form_before_11;
  // 出荷指示入力：出荷先情報入力-納入先カナ名称
  String get instruction_input_form_before_12;
  // 出荷指示入力：出荷先情報入力-納入先郵便番号
  String get instruction_input_form_before_13;
  // 出荷指示入力：出荷先情報入力-納入先都道府県
  String get instruction_input_form_before_14;
  // 出荷指示入力：出荷先情報入力-納入先市区町村
  String get instruction_input_form_before_15;
  // 出荷指示入力：出荷先情報入力-納入先住所詳細
  String get instruction_input_form_before_16;
  // 出荷指示入力：出荷先情報入力-納入先電話番号
  String get instruction_input_form_before_17;
  // 出荷指示入力：出荷先情報入力-納入先FAX番号
  String get instruction_input_form_before_18;
  // 出荷指示入力：詳細情報入力-荷姿
  String get instruction_input_form_detail_1;
  // 出荷指示入力：詳細情報入力-商品大分類
  String get instruction_input_form_detail_2;
  // 出荷指示入力：詳細情報入力-商品中分類
  String get instruction_input_form_detail_3;
  // 出荷指示入力：詳細情報入力-商品小分類
  String get instruction_input_form_detail_4;
  // 出荷指示入力：詳細情報入力-商品写真1
  String get instruction_input_form_detail_5;
  // 出荷指示入力：詳細情報入力-商品写真2
  String get instruction_input_form_detail_6;
  // 出荷指示入力：詳細情報入力-注意備考1
  String get instruction_input_form_detail_7;
  // 出荷指示入力：詳細情報入力-社内備考1
  String get instruction_input_form_detail_8;
  // 出荷指示入力：詳細情報入力-得意先明細備考
  String get instruction_input_form_detail_9;
  // 出荷指示入力：詳細情報入力-注意備考2
  String get instruction_input_form_detail_10;
  // 出荷指示入力：詳細情報入力-社内備考2
  String get instruction_input_form_detail_11;
  // 出荷指示入力：詳細情報入力-社内明細備考
  String get instruction_input_form_detail_12;
  // 出荷指示入力：詳細情報入力-出荷指示数
  String get instruction_input_form_detail_13;
  // 出荷指示入力：詳細情報入力-消費期限
  String get instruction_input_form_detail_14;
  // 出荷指示入力：詳細情報入力-ロット番号
  String get instruction_input_form_detail_15;
  // 出荷指示入力：詳細情報入力-シリアル
  String get instruction_input_form_detail_16;
  // 出荷指示入力：詳細情報入力-商品社内備考1
  String get instruction_input_form_detail_17;
  // 出荷指示入力：詳細情報入力-商品社内備考2
  String get instruction_input_form_detail_18;
  // 出荷指示入力：詳細情報入力-商品注意備考1
  String get instruction_input_form_detail_19;
  // 出荷指示入力：詳細情報入力-商品注意備考2
  String get instruction_input_form_detail_20;
  // 出荷指示入力：詳細情報入力-得意先カナ名称
  String get instruction_input_form_detail_21;
  // 出荷指示入力：詳細情報入力-得意先郵便番号
  String get instruction_input_form_detail_22;
  // 出荷指示入力：詳細情報入力-得意先都道府県
  String get instruction_input_form_detail_23;
  // 出荷指示入力：詳細情報入力-得意先市区町村
  String get instruction_input_form_detail_24;
  // 出荷指示入力：詳細情報入力-得意先住所詳細
  String get instruction_input_form_detail_25;
  // 出荷指示入力：詳細情報入力-得意先電話番号
  String get instruction_input_form_detail_26;
  // 出荷指示入力：詳細情報入力-得意先FAX番号
  String get instruction_input_form_detail_27;
  // 出荷指示入力：詳細情報入力-納入先は得意先と同一
  String get instruction_input_form_detail_28;
  // 出荷指示入力：表单-から
  String get instruction_input_form_from;
  // 出荷指示入力：表单-出荷指示日は納入日より前にしなければならない
  String get instruction_input_form_basic_3_less_than_basic_5;
  // 出荷指示入力：表格标题-[空]
  String get instruction_input_table_title_0;
  // 出荷指示入力：表格标题-No.
  String get instruction_input_table_title_1;
  // 出荷指示入力：表格标题-出荷倉庫
  String get instruction_input_table_title_2;
  // 出荷指示入力：表格标题-商品コード
  String get instruction_input_table_title_3;
  // 出荷指示入力：表格标题-商品名
  String get instruction_input_table_title_4;
  // 出荷指示入力：表格标题-規格
  String get instruction_input_table_title_5;
  // 出荷指示入力：表格标题-出荷数量
  String get instruction_input_table_title_6;
  // 出荷指示入力：表格标题-単位
  String get instruction_input_table_title_7;
  // 出荷指示入力：表格标题-ID
  String get instruction_input_table_title_8;
  // 出荷指示入力：表格标题-単価
  String get instruction_input_table_title_9;
  // 出荷指示入力：表格标题-出荷指示
  String get instruction_input_table_title_10;
  // 出荷指示入力：表格操作-出荷明細
  String get instruction_input_table_operate_detail;
  // 出荷指示入力：表格操作-削除
  String get instruction_input_table_operate_delete;

  // 出荷確定データ出力 - 张博睿 始
  // 出荷確定データ出力：检索条件-按钮文本
  String get shipment_confirmation_export_query;
  // 出荷確定データ出力：检索条件-字段文本
  String get shipment_confirmation_export_query_1;
  // 出荷確定データ出力：表格标题-[空]
  String get shipment_confirmation_export_table_title_0;
  // 出荷確定データ出力：表格标题-No.
  String get shipment_confirmation_export_table_title_1;
  // 出荷確定データ出力：表格标题-出荷指示番号
  String get shipment_confirmation_export_table_title_2;
  // 出荷確定データ出力：表格标题-出荷指示日
  String get shipment_confirmation_export_table_title_3;
  // 出荷確定データ出力：表格标题-納入日
  String get shipment_confirmation_export_table_title_4;
  // 出荷確定データ出力：表格标题-得意先
  String get shipment_confirmation_export_table_title_5;
  // 出荷確定データ出力：表格标题-納入先
  String get shipment_confirmation_export_table_title_6;
  String get shipment_confirmation_1;
  // 出荷確定データ出力 - 张博睿 终

  //入荷确定データ出力 -cuihr 始
  // 入荷确定データ出力：检索条件-按钮文本
  String get shipment_confirmation_data_query;
  // 入荷确定データ出力：检索条件-字段文本
  String get shipment_confirmation_data_query_1;
  //入荷确定データ出力：TabCSV
  String get shipment_confirmation_data_button_csv;
  // 入荷确定データ出力：表格标题-No.
  String get confirmation_data_table_title_1;
  //入荷确定データ出力：表格标题-行番号
  String get confirmation_data_table_title_2;
  // 入荷确定データ出力：表格标题-入荷予定番号
  String get confirmation_data_table_title_3;
  //入荷确定データ出力：表格标题-入荷予定日
  String get confirmation_data_table_title_4;
  //入荷确定データ出力：表格标题-仕入先
  String get confirmation_data_table_title_5;
  //入荷确定データ出力 -cuihr 终

  // 账户：菜单-プロフィール
  String get account_menu_1;
  // 账户：菜单-アカウント切替
  String get account_menu_2;
  // 账户：菜单-セキュリティ
  String get account_menu_3;
  // 账户：菜单-プラン確認
  String get account_menu_4;
  // 账户：菜单-ライセンス
  String get account_menu_5;
  // 账户：菜单-ログアウト
  String get account_menu_6;
  // 账户：菜单-スキャンコード
  String get account_menu_7;
  // 账户：简介-登録名
  String get account_profile_user;
  // 账户：简介-表示名
  String get account_profile_display;
  // 账户：简介-デフォルト言語
  String get account_profile_language;
  // 账户：简介-会社
  String get account_profile_company;
  // 账户：简介-ロール
  String get account_profile_roll;
  // 账户：简介-状態
  String get account_profile_state;
  // 账户：简介-編集
  String get account_profile_edit;
  // 账户：简介-登録名を変更する
  String get account_profile_user_change;
  // 账户：简介-表示名を変更する
  String get account_profile_display_change;
  // 账户：简介-デフォルト言語を変更する
  String get account_profile_language_change;
  // 账户：简介-会社を変更する
  String get account_profile_company_change;
  // 账户：简介-ロールを変更する
  String get account_profile_roll_change;
  // 账户：简介-状態を変更する
  String get account_profile_state_change;
  // 账户：简介-新しい登録名を入力してください
  String get account_profile_user_new;
  // 账户：简介-新しい表示名を入力してください
  String get account_profile_display_new;
  // 账户：简介-新しいデフォルト言語を入力してください
  String get account_profile_language_new;
  // 账户：简介-新しい会社を入力してください
  String get account_profile_company_new;
  // 账户：简介-新しいロールを入力してください
  String get account_profile_roll_new;
  // 账户：简介-新しい状態を入力してください
  String get account_profile_state_new;
  // 账户：简介-キャンセル
  String get account_profile_cancel;
  // 账户：简介-登録
  String get account_profile_registration;
  // 账户：安全性-パスワード
  String get account_security_password;
  // 账户：安全性-パスワードを変更する
  String get account_security_password_change;
  // 账户：安全性-新しいパスワードを入力してください
  String get account_security_password_new;
  // 账户：许可证-ライセンスの種類
  String get account_license_type;
  // 账户：许可证-運用開始日
  String get account_license_start;
  // 账户：许可证-運用終了日
  String get account_license_end;
  // 账户：许可证-支払状態
  String get account_license_payment;
  // 账户：退出-ログアウトでしょうか？
  String get account_logout_text;
  // 账户：计划-利用内容・アカウント管理
  String get account_contents_account_management;
  // 账户：计划-確認する
  String get account_confirm;
  // 账户：计划-解約する
  String get account_cancel;
  // 账户：解约-サービスを解約する
  String get account_cancel_title;
  // 账户：解约-※解約手続きを完了すると、以下のデータが完全に削除され今後ログインができなくなります。データの削除は取り消すことができませんがよろしいですか？
  String get account_cancel_text;
  // 账户：解约-削除するユーザー
  String get account_cancel_user;
  // 账户：解约-登録名：
  String get account_cancel_user_name;
  // 账户：解约-メールアドレス：
  String get account_cancel_user_email;
  // 账户：解约-削除されるデータ
  String get account_cancel_data;
  // 账户：解约-・削除する関連ユーザー
  String get account_cancel_data_content_1;
  // 账户：解约-・削除する関連プラットフォームアカウント
  String get account_cancel_data_content_2;
  // 账户：解约-・削除する関連データベース情報
  String get account_cancel_data_content_3;
  // 账户：解约-・削除する関連アップロードファイル
  String get account_cancel_data_content_4;
  // 账户：解约-解約申請する
  String get account_cancel_button_1;
  // 账户：解约-解約する
  String get account_cancel_button_2;
  // 账户：解约-担当者が解約申請を確認次第ご返信いたします。
  String get account_cancel_prompt_1;
  // 账户：解约-※データを完全に消去するため二度と復元することはできません。
  String get account_cancel_prompt_2;
  // 账户：運用開始日<運用終了日提示
  String get account_license_start_less_end_message;
  // 账户：画像変更はダブルクリックして任意の画像を選択します
  String get account_double_click_any_image_to_change_image;
  // 账户：解約の申し込みがありましたので、管理者の確認をお待ちください
  String get account_application_initiated_please_wait;
  // 账户：解約依頼が送信されました
  String get account_application_has_been_sent;
  // 出庫入力：表单标题-ピッキングリストバーコード
  String get exit_input_form_title_1;
  // 出庫入力：表单标题-出荷指示番号
  String get exit_input_form_title_2;
  // 出庫入力：表单标题-得意先
  String get exit_input_form_title_3;
  // 出庫入力：表单标题-納入先
  String get exit_input_form_title_4;
  // 出庫入力：表单标题-ピッキングリスト明細部のバーコード
  String get exit_input_form_title_5;
  // 出庫入力：表单标题-ロケーション
  String get exit_input_form_title_6;
  // 出庫入力：表单标题-商品ID
  String get exit_input_form_title_7;
  // 出庫入力：表单标题-商品名
  String get exit_input_form_title_8;
  // 出庫入力：表单标题-引当数
  String get exit_input_form_title_9;
  // 出庫入力：表单标题-商品写真
  String get exit_input_form_title_10;
  // 出庫入力：表单标题-ロケーションのバーコード
  String get exit_input_form_title_11;
  // 出庫入力：表单标题-商品ラベルのバーコード
  String get exit_input_form_title_12;
  // 出庫入力：表单标题-合計数
  String get exit_input_form_title_13;
  // 出庫入力：表单标题-カゴ車またはオリコンのバーコード
  String get exit_input_form_title_14;
  // 出庫入力：表单提示-正しいNoのにゅうりょく入力をおねがい願いします。
  String get exit_input_form_Toast_1;
  // 出庫入力：表单提示-ロケーションの入力ミスです
  String get exit_input_form_Toast_2;
  // 出庫入力：表单提示-商品にゅうりょく入力がまちっが間違っています。
  String get exit_input_form_Toast_3;
  // 出庫入力：正しい値の入力をお願いします
  String get exit_input_form_Toast_4;
  String get exit_input_form_Toast_5;
  String get exit_input_form_Toast_6;
  String get exit_input_form_Toast_7;
  // 出庫入力：弹窗标题
  String get exit_input_pop_title;
  // 出庫入力：表单按钮-ラベル発行
  String get exit_input_form_button_issue;
  // 出庫入力：弹窗表单标题-ラベル数量
  String get exit_input_popup_form_title_1;
  // 出庫入力：弹窗表单按钮-印刷
  String get exit_input_popup_form_button;
  // 出庫入力：表单按钮-クリア
  String get exit_input_form_button_clear;
  // 出庫入力：表单按钮-実行
  String get exit_input_form_button_execute;
  // 出庫入力：出庫入力一覧
  String get exit_input_form_overview;
  // 出庫入力：标签发行
  String get exit_input_form_issuance;
  // 出庫入力：表格按钮-削除
  String get exit_input_table_delete;
  // 出庫入力：表格按钮-修改
  String get exit_input_table_update;
  // 出庫入力：表格标题-[空]
  String get exit_input_table_title_0;
  // 出庫入力：表格标题-No.
  String get exit_input_table_title_1;
  // 出庫入力：表格标题-出荷倉庫
  String get exit_input_table_title_2;
  // 出庫入力：表格标题-ロケーションコード
  String get exit_input_table_title_3;
  // 出庫入力：表格标题-商品コード
  String get exit_input_table_title_4;
  // 出庫入力：表格标题-商品名
  String get exit_input_table_title_5;
  // 出庫入力：表格标题-単価
  String get exit_input_table_title_6;
  // 出庫入力：表格标题-出荷数量
  String get exit_input_table_title_7;
  // 出庫入力：表格标题-単位
  String get exit_input_table_title_8;
  // 出庫入力：表格标题-小計
  String get exit_input_table_title_9;
  // 出庫入力：出库按钮（SP画面）
  String get exit_input_button_1;
  // 合计数与引当数不一致
  String get exit_input_text_1;
  // 実行成功
  String get exit_input_text_2;
  // 実行失败
  String get exit_input_text_3;
  // 删除不可
  String get exit_input_text_4;
  // 商品已出库
  String get exit_input_text_5;
  // 表格：分条文本-1ページあたり
  String get table_striping_text_1;
  // 表格：分条文本-本
  String get table_striping_text_2;

  // CSV
  String get file_type_csv;

  // を空白にすることはできません
  String get can_not_null_text;
  // 文字は10桁以上ではいけません
  String get text_can_not_gt_ten;
  // 関連データが見つかりません
  String get no_items_found;
  // ログインユーザ情報が見つかりません
  String get login_user_error;
  // 赵士淞 - 始
  // ログインユーザーが有効期限を過ぎています
  String get login_user_expire;
  // 会社が失効しました
  String get company_has_expired;
  // 赵士淞 - 终
  // の作成に失敗しました
  String get create_error;
  // の作成に成功しました
  String get create_success;
  // の更新に失敗しました
  String get update_error;
  // の更新に成功しました
  String get update_success;
  // の削除に失敗しました
  String get delete_error;
  // の削除に成功しました
  String get delete_success;
  // の取り込みに失敗しました
  String get import_error;
  // の取り込みに成功しました
  String get import_success;
  // は13桁以内の半角数字でなければなりません
  String get text_must_thirteen_number;
  // は6～50桁の数字またはアルファベットでなければなりません
  String get text_must_six_number_letter;
  // は数字またはアルファベットでなければなりません
  String get text_must_number_letter;

  // 選択モードを確認してください
  String get confirm_selection_mode;
  // カメラ
  String get selection_mode_camera;
  // アルバム冊
  String get selection_mode_album;
  // 画像サイズは2 M以内
  String get image_size_need_within_2m;
  // 印刷日時
  String get printing_time;
  // ラベルプ
  String get label_printing;
  // パラメータが見つかりません。印刷できません
  String get miss_param_unable_print;
  // 棚の商品タグ
  String get shelves_product_label;
  // バスケットの商品タグ
  String get baskets_product_label;
  // 赵士淞 - 终
  //数字を入力してください
  String get input_int_check;
  //10桁以内の数字を入力してください
  String get input_int_in_10_check;
  //6桁の数字を入力してください
  String get input_int_6_check;
  //英数字を入力してください
  String get input_letter_and_number_check;
  //邮件を入力してください
  String get input_email_check;
  //英数字、記号を入力してください
  String get input_letter_and_number_and_symbol_check;
  //1～4桁のA~Zを入力してください
  String get input_company_1_check;
  //半角数字、ハイフンを入力してください
  String get input_half_width_numbers_with_hyphen_check;
  //6～50桁の数字を入力してください
  String get input_must_six_number_check;

  String get input_postal_code_check;
  //提示文言
  String get input_text;

  // 菜单内容 - 始
  String get menu_content_1;
  String get menu_content_2;
  String get menu_content_2_1;
  String get menu_content_2_2;
  String get menu_content_2_3;
  String get menu_content_2_4;
  String get menu_content_2_5;
  //luxy -start
  String get menu_content_2_5_1;
  String get menu_content_2_5_2;
  String get menu_content_2_5_3;
  String get menu_content_2_5_4;
  String get menu_content_2_5_5;
  String get menu_content_2_5_6;
  String get menu_content_2_5_7;
  String get menu_content_2_5_8;
  String get menu_content_2_5_9;
  String get menu_content_2_5_10;
  String get menu_content_2_5_11;
  String get menu_content_2_5_12;
  String get menu_content_2_5_13;
  String get menu_content_2_5_14;
  //luxy -end
  String get menu_content_2_6;
  String get menu_content_2_7;
  String get menu_content_2_8;
  String get menu_content_2_9;
  String get menu_content_2_10;
  String get menu_content_2_11;
  String get menu_content_2_12;
  String get menu_content_2_13;
  String get menu_content_2_14;
  String get menu_content_2_15;
  String get menu_content_2_16;
  String get menu_content_2_17;
  String get menu_content_3;
  String get menu_content_3_1;
  String get menu_content_3_2;
  String get menu_content_3_3;
  String get menu_content_3_4;
  String get menu_content_3_5;
  String get menu_content_3_6;
  String get menu_content_3_7;
  String get menu_content_3_8;
  String get menu_content_3_9;
  String get menu_content_3_10;
  String get menu_content_3_11;
  //luxy start
  String get menu_content_3_11_1;
  String get menu_content_3_11_2;
  String get menu_content_3_11_3;
  String get menu_content_3_11_4;
  String get menu_content_3_11_5;
  String get menu_content_3_11_6;
  String get menu_content_3_11_7;
  String get menu_content_3_11_8;
  String get menu_content_3_11_9;
  String get menu_content_3_11_10;
  String get menu_content_3_11_11;
  String get menu_content_3_11_12;
  String get menu_content_3_11_13;
  String get menu_content_3_11_14;
  //luxy end
  String get menu_content_3_12;
  String get menu_content_3_13;
  String get menu_content_3_14;
  String get menu_content_3_15;
  String get menu_content_3_16;
  String get menu_content_3_17;
  String get menu_content_3_18;
  String get menu_content_3_19;
  String get menu_content_3_20;
  String get menu_content_3_21;
  String get menu_content_3_22;
  String get menu_content_3_23;
  String get menu_content_3_24;
  String get menu_content_3_25;
  String get menu_content_3_26;
  String get menu_content_3_27;
  String get menu_content_3_28;
  String get menu_content_3_29;
  String get menu_content_4;
  String get menu_content_4_1;
  String get menu_content_4_2;
  String get menu_content_4_3;
  String get menu_content_4_4;
  String get menu_content_4_5;
  String get menu_content_4_6;
  String get menu_content_4_7;
  String get menu_content_4_8;
  String get menu_content_4_9;
  String get menu_content_4_10;
  //luxy start
  String get menu_content_4_10_1;
  String get menu_content_4_10_2;
  String get menu_content_4_10_3;
  String get menu_content_4_10_4;
  String get menu_content_4_10_5;
  String get menu_content_4_10_6;
  String get menu_content_4_10_7;
  String get menu_content_4_10_8;
  String get menu_content_4_10_9;
  String get menu_content_4_10_10;
  String get menu_content_4_10_11;
  String get menu_content_4_10_12;

  //  luxy end
  String get menu_content_4_11;
  String get menu_content_4_12;
  String get menu_content_4_13;
  // xcy - 改
  // String get menu_content_4_14;
  String get menu_content_4_15;
  String get menu_content_4_16;
  String get menu_content_4_17;
  String get menu_content_4_18;
  String get menu_content_4_19;
  String get menu_content_4_20;
  String get menu_content_5;
  String get menu_content_5_1;
  String get menu_content_5_2;
  String get menu_content_5_3;
  String get menu_content_5_4;
  String get menu_content_5_5;
  String get menu_content_5_6;
  String get menu_content_5_8;
  String get menu_content_5_9;
  String get menu_content_5_10;
  String get menu_content_5_11;
  String get menu_content_6;
  String get menu_content_6_1;
  String get menu_content_6_2;
  String get menu_content_6_3;
  String get menu_content_6_4;
  String get menu_content_6_5;
  String get menu_content_6_6;
  String get menu_content_6_7;
  String get menu_content_6_8;
  String get menu_content_6_9;
  String get menu_content_6_10;
  String get menu_content_6_11;
  String get menu_content_7;
  String get menu_content_7_1;
  String get menu_content_7_2;
  String get menu_content_7_3;
  String get menu_content_8;
  String get menu_content_8_1;
  String get menu_content_8_2;
  String get menu_content_8_3;
  String get menu_content_8_4;
  String get menu_content_8_5;
  String get menu_content_8_6;
  String get menu_content_8_7;
  String get menu_content_8_8;
  String get menu_content_8_9;
  String get menu_content_8_10;
  String get menu_content_8_11;
  String get menu_content_8_12;
  String get menu_content_8_13;
  String get menu_content_8_14;
  String get menu_content_8_15;
  String get menu_content_8_16;
  String get menu_content_8_17;
  String get menu_content_8_18;
  String get menu_content_8_19;
  String get menu_content_8_20;
  String get menu_content_8_21;
  String get menu_content_8_22;
  String get menu_content_8_23;
  String get menu_content_8_24;
  String get menu_content_9;
  String get menu_content_9_s;
  String get menu_content_50;
  String get menu_content_50_1;
  String get menu_content_60;
  String get menu_content_60_2_5;
  String get menu_content_60_3_11;
  //出荷确定明细 -cuihr
  String get menu_content_60_3_26;
  //出荷确定明细一览 -cuihr
  String get menu_content_60_3_26_1;
  // 入荷确定明细 - xcy
  String get menu_content_60_2_12_1;
  //入荷确定明细-入荷确定状态
  String get display_instruction_receive_detail_status;
  //入荷指示明細行No
  String get menu_content_60_2_12_1_1;
  // 入荷确定印刷 - xcy
  String get menu_content_60_2_12_2;
  // 纳品书明细 - xcy
  String get menu_content_60_3_21;
  // 棚卸照会明細 - xcy
  String get menu_content_60_5_9;
  // 出荷指示照会明细 - xcy
  String get menu_content_60_3_5;
  // 棚卸確定 - zhangbr
  String get menu_content_60_5_11;
  String get menu_content_98;
  String get menu_content_98_1;
  String get menu_content_98_2;
  String get menu_content_98_3;
  String get menu_content_98_4;
  String get menu_content_98_5;
  String get menu_content_98_6;
  String get menu_content_98_7;
  String get menu_content_98_8;
  String get menu_content_98_9;
  String get menu_content_98_10;
  String get menu_content_98_11;
  String get menu_content_98_12;
  String get menu_content_98_13;
  String get menu_content_98_14;
  String get menu_content_98_15;
  String get menu_content_98_16;
  String get menu_content_98_17;
  String get menu_content_98_18;
  String get menu_content_98_19;
  String get menu_content_98_20;
  String get menu_content_98_21;
  String get menu_content_98_22;
  String get menu_content_98_23;
  String get menu_content_98_24;
  String get menu_content_98_25;
  String get menu_content_98_26;
  String get menu_content_60_98_25;
  String get menu_content_99;
  String get menu_content_99_1;
  String get menu_content_99_2;
  String get menu_content_99_3;
  String get menu_content_99_4;
  String get menu_content_99_5;
  String get menu_content_99_6;

  // 菜单内容 - 终

  // 纳品书页面内容 xcy - 始

  String get delivery_note_1;
  String get delivery_note_2;
  String get delivery_note_3;
  String get delivery_note_4;
  String get delivery_note_5;
  String get delivery_note_6;
  String get delivery_note_7;
  String get delivery_note_8;
  String get delivery_note_9;
  String get delivery_note_9_tip;
  String get delivery_note_9_info;
  String get delivery_note_10;
  String get delivery_note_11;
  String get delivery_note_12;
  String get delivery_note_13;
  String get delivery_note_14;
  String get delivery_note_15;
  String get delivery_note_16;
  String get delivery_note_17;
  String get delivery_note_18;
  String get delivery_note_19;
  String get delivery_note_20;
  String get delivery_note_21;
  String get delivery_note_22;
  String get delivery_note_23;
  String get delivery_note_24;
  String get delivery_note_25;
  String get delivery_note_26;
  String get delivery_note_27;
  String get delivery_note_28;
  String get delivery_note_29;
  String get delivery_note_30;
  String get delivery_note_31;
  String get delivery_note_32;
  String get delivery_note_33;
  // 纳品书PDF导出
  String get delivery_note_34;
  String get delivery_note_35;
  String get delivery_note_36;
  String get delivery_note_37;
  String get delivery_note_38;
  String get delivery_note_39;
  String get delivery_note_40;
  String get delivery_note_41;
  String get delivery_note_42;
  String get delivery_note_43;
  String get delivery_note_44;
  String get delivery_note_45;
  String get delivery_note_46;
  String get delivery_note_delivery_line;
  String get delivery_note_delivery_until;
  // 納品明細一覧
  String get delivery_note_shipment_details_1;
  String get delivery_note_shipment_details_2;
  String get delivery_note_shipment_details_3;
  String get delivery_note_shipment_details_4;
  String get delivery_note_shipment_details_5;
  String get delivery_note_shipment_details_6;
  String get delivery_note_shipment_details_7;
  String get delivery_note_shipment_details_8;
  String get delivery_note_shipment_details_9;
  String get delivery_note_shipment_details_10;
  String get delivery_note_shipment_details_11;
  String get delivery_note_shipment_details_12;
  String get delivery_note_shipment_details_13;
  String get delivery_note_shipment_details_14;
  String get delivery_note_shipment_details_15;
  String get delivery_note_shipment_details_16;
  String get delivery_note_shipment_details_17;
  String get delivery_note_shipment_details_18;
  String get delivery_note_shipment_details_19;
  // 返回按钮
  String get delivery_note_return;
  String get delivery_note_close;
  String get delivery_note_reservation_status;
  // 纳品书 xcy - 终

  // 出荷指示照会 xcy - 始
  String get display_instruction_ingestion_state;
  String get display_instruction_allowance;
  String get display_instruction_waiting;
  String get display_instruction_work;
  String get display_instruction_complete;
  String get display_instruction_confirm_delete;
  String get display_instruction_delete;
  String get display_instruction_all_delete;
  String get display_instruction_shipment_detail;
  String get display_instruction_detail_line;
  String get display_instruction_shipping_status;
  String get display_instruction_shipping_detail_status;
  String get display_instruction_reservation_success;
  String get display_instruction_reservation_disappearance;
  String get display_instruction_tip1;
  String get display_instruction_tip2;
  String get display_instruction_tip3;
  String get display_instruction_tip4;
  String get display_instruction_message1;
  String get display_instruction_message2;
  String get display_instruction_message3;
  String get display_instruction_button;
  String get display_instruction_reservation_cancel_success;
  // 出荷指示照会 xcy - 终

  // 出荷检品 xcy - 始
  // 納品書バーコード
  String get shipment_inspection_delivery_note_barcode;
  String get shipment_inspection_ship_no;
  String get shipment_inspection_progress;
  String get shipment_inspection_customer;
  String get shipment_inspection_delivery;
  String get shipment_inspection_inspect;
  // ロケーション
  String get shipment_inspection_location;
  // 商品ID
  String get shipment_inspection_product_id;
  // 商品写真
  String get shipment_inspection_product_photos;
  // 出庫数
  String get shipment_inspection_number;
  // 商品ラベルのバーコード
  String get shipment_inspection_product_barcodes;
  // 合計数
  String get shipment_inspection_sum;
  // 検品
  String get shipment_inspection_inspection;
  // 出荷検品確認
  String get shipment_inspection_confirmation;
  // 出荷検品完了
  String get shipment_inspection_completion_title;
  // 出荷検品弹窗-正しい納入書コードの入力をお願いします
  String get shipment_inspection_toast_1;
  // 出荷検品弹窗-データは検品の段階ではありません
  String get shipment_inspection_toast_2;
  // 出荷検品弹窗-入力の値が正しくありません
  String get shipment_inspection_toast_3;
  // 出荷検品弹窗-合計数が正しくありません
  String get shipment_inspection_toast_4;
  // 出荷検品弹窗-当該商品の検査が完了しましたので、自動的に次の項目に遷移します
  String get shipment_inspection_toast_5;
  // 払出先オリコンのバーコード
  String get shipment_inspection_oricon_barcode;
  // 出荷ラベル
  String get shipment_inspection_shipping_label;
  // 完了
  String get shipment_inspection_completion;
  String get shipment_inspection_item;
  String get shipment_inspection_not;
  String get shipment_inspection_not_equal;
  String get shipment_inspection_is_ok;
  String get shipment_inspection_not_equal_to;

  // 出荷检品 xcy - 终

  // 挑货单页面内容 wgs - 始
  String get pink_list_41;
  String get pink_list_42;
  String get pink_list_43;
  String get pink_list_44;
  String get pink_list_45;
  String get pink_list_46;
  String get pink_list_47;
  String get pink_list_48;
  String get pink_list_49;
  String get pink_list_50;
  String get pink_list_51;
  String get pink_list_52;
  String get pink_list_53;
  String get pink_list_54;
  String get pink_list_55;
  String get pink_list_56;
  String get pink_list_57;
  String get pink_list_58;
  String get pink_list_59;
  String get pink_list_60;
  String get pink_list_61;
  String get pink_list_62;
  String get pink_list_63;
  String get pink_list_64;
  // 挑货单页面内容 wgs - 终

  // 出庫照会页面内容 wgs - 始
  String get outbound_notes_1;
  String get outbound_notes_2;
  String get outbound_notes_3;
  String get outbound_notes_4;
  String get outbound_notes_5;
  String get outbound_notes_6;
  String get outbound_notes_toast_1;
  // 出庫照会页面内容 wgs - 终

  //出荷确定一览：行番号 cuihr 始
  String get row_tablebasic_1;
  //tab 确定
  String get table_tab_confirm;
  //tab 取消
  String get table_tab_cancel;
  //未确定
  String get instruction_input_tab_Undetermined;
  // 已确定
  String get instruction_input_tab_Determined;
  //
  //出荷确定一览：行番号 cuihr 终

  // 入荷検品 xcy - 始
  // 入荷予定一覧バーコード
  String get incoming_inspection_expected_barcode;
  // 入荷予定番号
  String get incoming_inspection_expected_id;
  // 仕入先
  String get incoming_inspection_supplier;
  // 入荷予定明細のバーコード
  String get incoming_inspection_receipt_barcode;
  // 入荷予定数
  String get incoming_inspection_expected_number;
  // 商品ラベル
  String get incoming_inspection_product_label;
  // 入荷検品確認
  String get incoming_inspection_confirmation;
  // 入荷検品完了
  String get incoming_inspection_completion;
  // 全て商品は検品されました。
  String get incoming_inspection_all_product;
  String get incoming_inspection_product;
  String get incoming_inspection_product_inspected;
  String get incoming_inspection_amazon_bargaining;
  String get incoming_inspection_number;
  String get incoming_inspection_1;
  String get incoming_inspection_2;
  String get incoming_inspection_3;
  String get incoming_inspection_4;
  String get incoming_inspection_tip_1;
  String get incoming_inspection_num;
  String get incoming_inspection_tip_2;
  String get incoming_inspection_tip_3;
  String get incoming_inspection_tip_4;
  // 入荷検品 xcy - 终

  // 入荷予定入力页面内容 wgs - 始
  String get reserve_input_1;
  String get reserve_input_2;
  String get reserve_input_3;
  String get reserve_input_4;
  String get reserve_input_5;
  String get reserve_input_6;
  String get reserve_input_7;
  String get reserve_input_8;
  String get reserve_input_9;
  String get reserve_input_10;
  String get reserve_input_11;
  String get reserve_input_12;
  String get reserve_input_13;
  String get reserve_input_14;
  String get reserve_input_15;
  String get reserve_input_16;
  String get reserve_input_17;
  String get reserve_input_18; //-luxy
  String get reserve_input_19;
  // 入荷予定入力页面内容 wgs - 终

  // 入庫入力 xcy - 始
  // 入荷予定一覧バーコード
  String get goods_receipt_input_list_bar_code;
  // 入荷予定番号
  String get goods_receipt_input_incoming_number;
  // 仕入先
  String get goods_receipt_input_supplier;
  // 入庫按鈕
  String get goods_receipt_input_button;
  // 提示消息：正しいバーコードを入力をお願いします。
  String get goods_receipt_input_toast_1;
  // 提示消息：現在のデータ状態では入庫できません。
  String get goods_receipt_input_toast_2;
  // 提示消息：入力したバーコードが正しくありません。
  String get goods_receipt_input_toast_3;
  // 提示消息：正確な情報の入力をお願いします。
  String get goods_receipt_input_toast_4;
  // 提示消息：装填完了。
  String get goods_receipt_input_toast_5;
  // 提示消息：削除完了。
  String get goods_receipt_input_toast_6;
  // 提示消息：実行失敗です
  String get goods_receipt_input_toast_execute_fail;
  // 入庫数
  String get goods_receipt_input_number;
  // 表格标题 - ID
  String get goods_receipt_input_table_title_1;
  // 表格标题 - 商品コード
  String get goods_receipt_input_table_title_2;
  // 表格标题 - 商品名
  String get goods_receipt_input_table_title_3;
  // 表格标题 - 単価
  String get goods_receipt_input_table_title_4;
  // 表格标题 - 入庫数
  String get goods_receipt_input_table_title_5;
  // 表格标题 - 規格
  String get goods_receipt_input_table_title_6;
  // 表格标题 - ロケーションのバーコード
  String get goods_receipt_input_table_title_7;
  // 表格标题 - 小計
  String get goods_receipt_input_table_title_8;
  String get goods_receipt_input_lot_no;
  String get goods_receipt_input_serial_no;
  String get goods_receipt_input_information;
  String get goods_receipt_input_list;
  String get goods_receipt_input_label_publishing;
  String get goods_receipt_input_completed_title_1;
  String get goods_receipt_input_completed_title_2;
  String get goods_receipt_input_completed_context_1;
  String get goods_receipt_input_completed_context_2;
  String get goods_receipt_input_completed_Number;
  String get goods_receipt_input_tip_1;
  // 入庫入力 xcy - 终

  // 入庫照会页面内容 wgs - 始
  String get Warehouse_query_1;
  String get Warehouse_query_2;
  String get Warehouse_query_3;
  String get Warehouse_query_4;
  String get Warehouse_query_5;
  String get Warehouse_Query_Button_1;
  String get Warehouse_Query_Commodity_Search_1;
  String get Warehouse_Query_Commodity_Search_2;
  String get Warehouse_Query_Commodity_Search_3;
  // 入庫照会页面内容 wgs - 终

  // 在庫照会页面内容 wgs - 始
  String get Stock_present_1;
  String get Stock_present_2;
  String get Stock_present_3;
  String get Stock_present_4;
  String get Stock_present_5;
  // 在庫照会页面内容 wgs - 终

  // 入荷确定 xcy - 始
  String get income_confirmation_list;
  String get income_confirmation_confirmed;
  String get income_confirmation_composition;
  String get income_confirmation_text_1;
  // 入荷确定 xcy - 终
  // 在庫移動入力 xcy - 始
  String get goods_transfer_entry_location_barcode;
  String get goods_transfer_entry_locke_number;
  String get goods_transfer_entry_stock_count;
  String get goods_transfer_entry_button_move;
  String get goods_transfer_entry_destination_location_barcode;
  String get goods_transfer_entry_number_of_moves;
  String get goods_transfer_entry_reason_for_movement;
  // 在庫移動入力-消息提示：当前输入的ロケーション品物がない
  String get goods_transfer_entry_form_toast_1;
  // 在庫移動入力-消息提示：当前输入的ロケーション不正确
  String get goods_transfer_entry_form_toast_2;
  // 在庫移動入力-消息提示：不在该ロケーション上
  String get goods_transfer_entry_form_toast_3;
  String get goods_transfer_entry_form_toast_4;
  String get goods_transfer_entry_form_toast_5;
  String get goods_transfer_entry_form_toast_6;
  // 在庫移動入力 xcy - 终
  // 返品入力页面内容 wgs - 始
  String get Return_product_1;
  String get Return_product_2;
  String get Return_product_3;
  String get Return_product_4;
  String get Return_product_5;
  String get return_product_form_1;
  String get return_product_form_2;
  String get return_product_form_3;
  String get return_product_form_4;
  String get return_product_form_5;
  String get return_product_toast_1;
  String get return_product_toast_2;
  String get return_product_toast_3;
  String get return_product_must_enter_toast;
  // 返品入力页面内容 wgs - 终

  // 棚卸開始 xcy - 始
  String get start_inventory_list;
  String get start_inventory_date;
  String get start_inventory_location_code;
  String get start_inventory_location_floor;
  String get start_inventory_location_room;
  String get start_inventory_location_zone;
  String get start_inventory_location_column;
  String get start_inventory_location_shelf;
  String get start_inventory_location_stage;

  // 棚卸開始 xcy - 终

  // 棚卸照会 - xcy - 始
  String get inventory_query_in_progress;
  String get inventory_query_confirmed;
  String get inventory_query_id;
  String get inventory_query_completed_number;
  String get inventory_query_different_number;
  String get inventory_query_progress;
  String get inventory_query_quantity;
  String get inventory_query_quantity_in_stock;
  String get inventory_query_variance_quantity;
  String get inventory_query_Inventory_item_id;
  String get inventory_query_reason;
  String get inventory_query_detail;
  String get inventory_query_completion;
  String get inventory_query_difference;
  String get inventory_query_detail_list;
  String get inventory_query_detail_differing;
  String get inventory_query_detail_without;
  String get inventory_query_detail_incomplete;
  String get inventory_query_tip;
  String get inventory_query_tip_1;
  String get inventory_query_tip_2;
  // 棚卸照会 - xcy - 终

  // 在庫移動照会  张博睿 - 始
  String get transfer_inquiry_tab_button_printing;
  String get transfer_inquiry_tab_list;
  String get transfer_inquiry_tab_button_choice;
  String get transfer_inquiry_tab_button_cancellation;
  String get transfer_inquiry_note_1;
  String get transfer_inquiry_note_2;
  String get transfer_inquiry_note_3;
  String get transfer_inquiry_note_4;
  String get transfer_inquiry_note_5;
  String get transfer_inquiry_note_6;
  String get transfer_inquiry_note_7;
  String get transfer_inquiry_note_8;
  String get transfer_inquiry_note_9;
  String get transfer_inquiry_table_1;
  String get transfer_inquiry_table_2;
  String get transfer_inquiry_table_3;
  String get transfer_inquiry_table_4;
  String get transfer_inquiry_table_5;
  String get transfer_inquiry_table_6;
  String get transfer_inquiry_table_7;
  String get transfer_inquiry_table_8;
  // 在庫移動照会  张博睿 - 终

  // 在庫移動照会  张博睿 - 始
  String get adjust_inquiry_tab_button_printing;
  String get adjust_inquiry_tab_list;
  String get adjust_inquiry_tab_button_choice;
  String get adjust_inquiry_tab_button_cancellation;
  String get adjust_inquiry_note_1;
  String get adjust_inquiry_note_2;
  String get adjust_inquiry_note_3;
  String get adjust_inquiry_note_4;
  String get adjust_inquiry_note_5;
  String get adjust_inquiry_note_6;
  String get adjust_inquiry_note_7;
  String get adjust_inquiry_note_8;
  String get adjust_inquiry_table_1;
  String get adjust_inquiry_table_2;
  String get adjust_inquiry_table_3;
  String get adjust_inquiry_table_4;
  String get adjust_inquiry_table_5;
  String get adjust_inquiry_table_6;
  String get adjust_inquiry_table_7;
  String get adjust_inquiry_table_8;
  // 在庫移動照会  张博睿 - 终

  // 実棚明細入力页面内容 wgs - 始
  String get Actual_Shelf_1;
  String get Actual_Shelf_2;
  String get Actual_Shelf_3;
  String get Actual_Shelf_4;
  String get Actual_Shelf_5;
  String get Actual_Shelf_6;
  String get Actual_Shelf_7;
  String get Actual_Shelf_8;
  String get Actual_Shelf_9;
  String get Actual_Shelf_10;
  String get Actual_Shelf_11;
  String get Actual_Shelf_12;
  String get Actual_Shelf_13;
  String get Actual_Shelf_14;
  String get Actual_Shelf_15;
  String get Actual_Shelf_16;
  String get Actual_Shelf_17;
  String get Actual_Shelf_18;
  String get Actual_Shelf_19;
  String get Actual_Shelf_20;
  String get Actual_Shelf_21;
  String get Actual_Shelf_22;

  // 実棚明細入力页面内容 wgs - 终

  //在庫调整入力 cuihr -始
  //按钮 -筛选搜索
  String get outbound_adjust_btn;
  //按钮 -筛选搜索-搜索
  String get outbound_adjust_query_btn_1;
  //按钮 -筛选搜索-解除所有搜索选中
  String get outbound_adjust_query_btn_2;
  //搜索条件 -商品id
  String get outbound_adjust_query_id;
  //搜索条件 -商品名
  String get outbound_adjust_query_name;
  //搜索条件 -ロケーション（商品位置）
  String get outbound_adjust_query_location;
  //按钮 -表格调整
  String get outbound_adjust_table_btn;
  //文本 -在库调整
  String get outbound_adjust_table_text;
  String get outbound_adjust_sure_title;
  String get outbound_adjust_sure_content;
  //调整 -在庫数
  String get outbound_adjust_table_btn_1;
  //调整 -锁定数量
  String get outbound_adjust_table_btn_2;
  //调整 -調整後在庫数
  String get outbound_adjust_table_btn_3;
  //调整 -調整理由
  String get outbound_adjust_table_btn_4;
  //表格标题 -no
  String get outbound_adjust_table_title_1;
  //表格标题 -ID
  String get outbound_adjust_table_title_2;
  //表格标题 -商品id
  String get outbound_adjust_table_title_3;
  //表格标题 -商品名
  String get outbound_adjust_table_title_4;
  //表格标题 -ロケーション(商品位置)
  String get outbound_adjust_table_title_5;
  //表格标题 -在庫数
  String get outbound_adjust_table_title_6;
  //表格标题 -ロック数
  String get outbound_adjust_table_title_7;
  String get outbound_adjust_form_button;
  // 消息提示 -データの更新に失敗します
  String get outbound_adjust_toast_1;
  // 消息提示 -必須入力
  String get outbound_adjust_toast_2;
  // 消息提示 -請調整在庫數
  String get outbound_adjust_toast_3;
  // 消息提示 -調整後在庫数不能小于当前ロック数
  String get outbound_adjust_toast_4;
  // 消息提示 -データの更新に成功します
  String get outbound_adjust_toast_5;
  // 消息提示 -必須入力
  String get outbound_adjust_toast_6;
  // 消息提示 -必須入力
  String get outbound_adjust_toast_7;
  //在庫调整入力 cuihr -终

  // 棚卸データ出力页面内容 wgs - 终
  String get inventory_output_1;
  String get inventory_output_2;
  String get inventory_output_3;
  String get inventory_output_4;
  String get inventory_output_5;
  String get inventory_output_6;
  String get inventory_output_7;
  String get inventory_output_8;
  // 棚卸データ出力页面内容 wgs - 终

  // 棚卸確定 zhangbr - 始
  String get Inventory_Confirmed_Search_1;
  String get Inventory_Confirmed_Search_2;
  String get Inventory_Confirmed_Search_3;
  String get Inventory_Confirmed_Table_1;
  String get Inventory_Confirmed_Table_2;
  String get Inventory_Confirmed_Table_3;
  String get Inventory_Confirmed_Table_4;
  String get Inventory_Confirmed_Table_Tab_1;
  String get Inventory_Confirmed_Table_Tab_2;
  String get Inventory_Confirmed_Table_Tab_3;
  String get Inventory_Confirmed_Table_Buttton_1;
  String get Inventory_Confirmed_Table_Buttton_2;
  String get Inventory_Confirmed_Table_Buttton_3;
  String get Inventory_Confirmed_Table_Buttton_4;
  String get Inventory_Confirmed_tip_1;
  String get Inventory_Confirmed_tip_2;
  String get Inventory_Confirmed_tip_3;
  String get Inventory_Confirmed_tip_4;
  String get Inventory_Confirmed_tip_5;
  String get Inventory_Confirmed_tip_6;
  String get Inventory_Confirmed_tip_7;
  String get Inventory_Confirmed_tip_8;
  String get Inventory_Confirmed_tip_9;
  String get Inventory_Confirmed_tip_10;
  String get Inventory_Confirmed_tip_11;
  String get Inventory_Confirmed_tip_12;
  String get Inventory_Confirmed_tip_13;

  // 棚卸確定 zhangbr - 终

  // 商品マスタ管理  xcy - 终
  String get product_master_management_product_abbreviation;
  String get product_master_management_junk;
  String get product_master_management_major_categories;
  String get product_master_management_medium_classification;
  String get product_master_management_subclassification;
  String get product_master_management_quantity;
  String get product_master_management_photo_1;
  String get product_master_management_photo_2;
  String get product_master_management_view;
  String get product_master_management_tableName;
  String get product_master_management_product_code_notRepeat;
  String get product_master_management_product_jan_cd_notRepeat;
  String get product_master_csv_import;
  // 商品マスタ管理  xcy - 始终

  // 納入先マスタ管理 zhangbr - 始
  // 納入先マスタ画面-Form表单-納入先ID
  String get delivery_form_id;
  // 納入先マスタ画面-Form表单-名称
  String get delivery_form_name;
  // 納入先マスタ画面-Form表单-カナ名称
  String get delivery_form_canaName;
  // 納入先マスタ画面-Form表单-略称
  String get delivery_form_abbreviation;
  // 納入先マスタ画面-Form表单-郵便番号
  String get delivery_form_zipCode;
  // 納入先マスタ画面-Form表单-都道府県
  String get delivery_form_prefecture;
  // 納入先マスタ画面-Form表单-市区町村
  String get delivery_form_municipal;
  // 納入先マスタ画面-Form表单-住所
  String get delivery_form_address;
  // 納入先マスタ画面-Form表单-電話番号
  String get delivery_form_tel;
  // 納入先マスタ画面-Form表单-FAX番号
  String get delivery_form_fax;
  // 納入先マスタ画面-Form表单-担当者名
  String get delivery_form_chargePerson;
  // 納入先マスタ画面-Form表单-社内備考1
  String get delivery_form_company_notes1;
  // 納入先マスタ画面-Form表单-社内備考2
  String get delivery_form_company_notes2;
  // 納入先マスタ画面-Form表单-会社
  String get delivery_form_company;
  // 納入先マスタ画面-检索条件按钮
  String get delivery_search_conditions_button;
  // 納入先マスタ画面-检索按钮
  String get delivery_search_button;
  // 納入先マスタ画面-移除检索条件按钮
  String get delivery_search_remove_button;
  // 納入先マスタ画面-检索条件整合内容
  String get delivery_search_conditions;
  // 納入先マスタ画面-检索条件-納入先ID
  String get delivery_search_id;
  // 納入先マスタ画面-检索条件-名称
  String get delivery_search_name;
  // 納入先マスタ画面-检索条件-略称
  String get delivery_search_abbreviation;
  // 納入先マスタ画面-检索条件-担当者名
  String get delivery_search_chargePerson;
  // 納入先マスタ画面-检索条件-会社名
  String get delivery_search_company;
  // 納入先マスタ画面-table表格-納入先ID
  String get delivery_table_id;
  // 納入先マスタ画面-table表格-名称
  String get delivery_table_name;
  // 納入先マスタ画面-table表格-カナ名称
  String get delivery_table_canaName;
  // 納入先マスタ画面-table表格-略称
  String get delivery_table_abbreviation;
  // 納入先マスタ画面-table表格-郵便番号
  String get delivery_table_zipCode;
  // 納入先マスタ画面-table表格-都道府県
  String get delivery_table_prefecture;
  // 納入先マスタ画面-table表格-市区町村
  String get delivery_table_municipal;
  // 納入先マスタ画面-table表格-住所
  String get delivery_table_address;
  // 納入先マスタ画面-table表格-電話番号
  String get delivery_table_tel;
  // 納入先マスタ画面-table表格-FAX番号
  String get delivery_table_fax;
  // 納入先マスタ画面-table表格-担当者名
  String get delivery_table_chargePerson;
  // 納入先マスタ管理 zhangbr - 终

  // 返品照会 wanggs - 始
  String get returns_note_1;
  String get returns_note_2;
  String get returns_note_3;
  String get returns_note_id;
  // 返品照会 wanggs - 终

  // メニューマスタ管理 xcy - 始
  String get menu_master;
  String get menu_master_form_1;
  String get menu_master_form_2;
  String get menu_master_form_3;
  String get menu_master_form_4;
  String get menu_master_form_5;
  //删除存在check文言（mtb_authority(権限マスタ)）
  String get menu_check_exists;
  // メニューマスタ管理 xcy - 终

  // 設定----------------------------------------------
  // 権限マスタ zhangbr - 始
  // 権限マスタ-Form表单 - 権限ID
  String get auth_Form_1;
  // 権限マスタ-Form表单 - ロール名称
  String get auth_Form_2;
  // 権限マスタ-Form表单 - ロール名称checkk
  String get auth_Form_2_check;
  // 権限マスタ-Form表单 - メニュー名称
  String get auth_Form_3;
  // 権限マスタ-Form表单 - 権限
  String get auth_Form_4;
  // 権限マスタ-Form表单 - 権限全大写check
  String get auth_Form_4_check;
  // 権限マスタ-search - 権限ID
  String get auth_Search_1;
  // 権限マスタ-search - ロール名称
  String get auth_Search_2;
  // 権限マスタ-search - メニュー名称
  String get auth_Search_3;
  // 権限マスタ-search - 権限
  String get auth_Search_4;
  // 権限マスタ-table - 権限ID
  String get auth_Table_1;
  // 権限マスタ-table - ロール名称
  String get auth_Table_2;
  // 権限マスタ-table - メニュー名称
  String get auth_Table_3;
  // 権限マスタ-table - 権限
  String get auth_Table_4;
  // 権限マスタ zhangbr - 终

  //会社マスタ wanggs - 始
  String get company_information_1;
  String get company_information_2;
  String get company_information_3;
  String get company_information_4;
  String get company_information_5;
  String get company_information_6;
  String get company_information_7;
  String get company_information_8;
  String get company_information_9;
  String get company_information_10;
  String get company_information_11;
  String get company_information_12;
  String get company_information_13;
  String get company_information_14;
  String get company_information_15;
  String get company_information_16;
  String get company_information_17;
  String get company_information_18;
  String get company_check_1;
  String get company_check_2;
  String get company_check_3;
  //会社マスタ wanggs - 终

  // メッセージマスタ xiongcy - 始
  String get message_master_1;
  String get message_master_2;
  String get message_master_3;
  String get message_master_4;
  String get message_master_5;
  String get message_master_6;
  String get message_master_7;
  String get message_master_sendMail;
  // メッセージマスタ xiongcy - 终
  // メッセージタイトル
  String get message_title;
  // メッセージの内容
  String get message_content;
  // は30文字以内
  String get message_cannot_exceed_30_characters;
  // 許可確認
  String get message_button_1_1;
  // リンクを共有してアカウント開設をお願いする
  String get message_button_1_2;
  // お客様用のログインURLをコピー
  String get message_button_1_3;
  // 解約確認
  String get message_button_2_1;
  // リンクを共有して解約をお願いする
  String get message_button_2_2;
  // 解約URLをコピー
  String get message_button_2_3;
  //得意先マスタ wanggs - 始
  String get customer_master_1;
  String get customer_master_2;
  String get customer_master_3;
  String get customer_master_4;
  String get customer_master_5;
  String get customer_master_6;
  String get customer_master_7;
  String get customer_master_8;
  String get customer_master_9;
  String get customer_master_10;
  String get customer_master_11;
  String get customer_master_12;
  String get customer_master_13;
  String get customer_master_14;
  String get customer_master_15;
  String get customer_master_16;
  String get customer_master_17;
  String get customer_master_18;
  String get customer_master_19;
  String get customer_master_20;
  String get customer_master_21;
  String get customer_master_22;
  String get customer_master_23;
  String get customer_master_24;
  String get customer_master_25;
  String get customer_master_26;
  String get customer_master_27;
  String get customer_master_28;
  String get customer_master_29;
  String get customer_master_30;
  String get customer_master_31;
  String get customer_master_32;
  String get customer_master_day;
  //得意先マスタ wanggs - 终

  //運用基本情報管理 wanggs - 始
  String get information_management_1;
  String get information_management_2;
  String get information_management_3;
  //運用基本情報管理 wanggs - 终

  //ロールマスタ管理 -cuihr 始
  //ロール
  String get role_basic;
  //基本情报 -id
  String get role_basic_id;
  //基本情报 -名称
  String get role_basic_name;
  //基本情报 -说明
  String get role_basic_explain;
  //检索条件 -id
  String get role_search_id;
  //检索条件 -名称
  String get role_search_name;
  //检索条件 -说明
  String get role_search_explain;
  //明细一览 -id
  String get role_overview_id;
  //明细一览 -名称
  String get role_overview_name;
  //明细一览 -说明
  String get role_overview_explain;
  //删除存在check文言（ytb_use_type(ライセンス・課金管理)）
  String get role_check_exists_1;
  //删除存在check文言（mtb_authority(権限マスタ)）
  String get role_check_exists_2;
  //删除存在check文言（mtb_user(ユーザーマスタ)）
  String get role_check_exists_3;
  //ロールマスタ管理 -cuihr 终

  //倉庫マスタ wanggs - 始
  String get warehouse_master_1;
  String get warehouse_master_2;
  String get warehouse_master_3;
  String get warehouse_master_4;
  String get warehouse_master_5;
  String get warehouse_master_6;
  String get warehouse_master_7;
  //倉庫マスタ wanggs - 终

  // ロケーションマスタ  xiongcy - 始
  String get location_master_1;
  String get location_master_2;
  String get location_master_3;
  String get location_master_4;
  String get location_master_5;
  String get location_master_locCode_check;
  // ロケーションマスタ  xiongcy - 终

  //仕入先マスタ管理 -cuihr 始
  //基本情报 -仕入先id
  String get supplier_basic_id;
  //基本情报 -仕入先名称
  String get supplier_basic_name;
  //基本情报 -カナ名称
  String get supplier_basic_kana;
  //基本情报 -略称
  String get supplier_basic_abbreviation;
  //基本情报 -郵便番号
  String get supplier_basic_zip_code;
  //基本情报 -都道府県
  String get supplier_basic_province;
  //基本情报 -市区町村
  String get supplier_basic_villages;
  //基本情报 -住所
  String get supplier_basic_address;
  //基本情报 -電話番号
  String get supplier_basic_telephone_number;
  //基本情报 -FAX番号
  String get supplier_basic_fax_number;
  //基本情报 -代表者名
  String get supplier_basic_representative_name;
  //基本情报 -担当者名
  String get supplier_basic_contact_name;
  //基本情报 -担当者名 -電話番号
  String get supplier_basic_contact_telephone_number;
  //基本情报 -担当者名 -FAX番号
  String get supplier_basic_contact_fax_number;
  //基本情报 -担当者名 -email
  String get supplier_basic_contact_email;
  //基本情报 -社内備考1
  String get supplier_basic_internal_remarks_1;
  //基本情报 -社内備考2
  String get supplier_basic_internal_remarks_2;
  //基本情报 -会社
  String get supplier_basic_company;

  //检索条件 -仕入先id
  String get supplier_search_id;
  //检索条件 -名称
  String get supplier_search_name;
  //检索条件 -代表者名
  String get supplier_search_representative_name;
  //检索条件 -担当者名
  String get supplier_search_contact_name;

  //明细一览 -仕入先id
  String get supplier_id;
  //明细一览 -名称
  String get supplier_name;
  //明细一览 -カナ名称
  String get supplier_kana;
  //明细一览 -略称
  String get supplier_abbreviation;
  //明细一览 -郵便番号
  String get supplie_zip_code;
  //明细一览 -都道府県
  String get supplier_province;
  //明细一览 -市区町村
  String get supplier_villages;
  //明细一览 -住所
  String get supplier_address;
  //明细一览 -電話番号
  String get supplier_telephone_number;
  //明细一览 -FAX番号
  String get supplier_fax_number;
  //明细一览 -代表者名
  String get supplier_representative_name;
  //明细一览 -担当者名
  String get supplier_contact_name;
  //明细一览 -担当者名 -電話番号
  String get supplier_contact_telephone_number;
  //明细一览 -担当者名 -FAX番号
  String get supplier_contact_fax_number;
  //明细一览 -担当者名 -email
  String get supplier_contact_email;
  //仕入先マスタ管理 -cuihr 终

  // 账户 - 赵士淞 始
  // 用户状態 - 本会員
  String get user_status_text_1;
  // 用户状態 - 仮会員
  String get user_status_text_2;
  // 用户状態 - 退会
  String get user_status_text_3;

  // 支払状態 - 未支払
  String get manage_pay_status_text_1;
  // 支払状態 - 支払済み
  String get manage_pay_status_text_2;

  // 密码发生变更，请重新登录！
  String get password_changed_log_again;

  // 入荷预定照会 - 入荷状態
  String get inquiry_schedule_table_title_5;

  // 入荷状態 - 检品待ち
  String get receive_kbn_text_1;
  // 入荷状態 - 入庫待ち
  String get receive_kbn_text_2;
  // 入荷状態 - 入庫中
  String get receive_kbn_text_3;
  // 入荷状態 - 入荷確定待ち
  String get receive_kbn_text_4;
  // 入荷状態 - 入荷済み
  String get receive_kbn_text_5;

  // 取込状態 - 導入された商品IDは存在しません
  String get importerror_flg_text_1;
  // 取込状態 - インポート時にエラーが発生しました
  String get importerror_flg_text_2;
  // 取込状態 - マスターテーブルのインポート中にエラーが発生しました
  String get importerror_flg_text_3;
  // 取込状態 - サブテーブルのインポート中にエラーが発生しました
  String get importerror_flg_text_4;
  // 取込状態 - インポートされたフィールドの数またはタイプが一致しません
  String get importerror_flg_text_5;

  // 取込状態 - エラーあり
  String get importerror_flg_query_1;
  // 取込状態 - エラーなし
  String get importerror_flg_query_2;

  // 入荷预定照会明细 - 入荷予定明細行No
  String get inquiry_schedule_details_row_no;

  // 在庫照会 - 前月残
  String get inventory_inquiry_last_month;
  // 在庫照会 - 調整数
  String get inventory_inquiry_adjustment_number;
  // 在庫照会 - 棚卸数
  String get inventory_inquiry_inventory;
  // 在庫照会 - 入庫移動数
  String get inventory_inquiry_entry_number;
  // 在庫照会 - 出庫移動数
  String get inventory_inquiry_exit_number;
  // 在庫照会 - 場所明細
  String get inventory_inquiry_location_details;
  // 在庫照会 - 在庫id
  String get inventory_inquiry_stock_id;
  // 在庫照会 - 返品数
  String get inventory_inquiry_return_stock;
  // 账户 - 赵士淞 终
  String get ship_csv_submit;
  String get ship_kbn_cancel;
  String get ship_kbn_cancel_success;
  String get ship_kbn_no_cancel;
  String get warehousing_status;
  String get receive_status;
  String get receive_status_no;
  String get display_message_Confim;
  String get ship_confirm_error;
  String get ship_prompt_error;
  String get ship_prompt_error_2;
  String get ship_cancel_error;
  String get shipdetail_cancel_error;
  String get income_cancel_error;
  String get income_cancel_error_2;
  // 出荷指示照会 - xcy
  //  出荷状態 - 检品待ち
  String get ship_kbn_text_1;
  // 出荷状態 - 入庫待ち
  String get ship_kbn_text_2;
  // 出荷状態 - 入庫中
  String get ship_kbn_text_3;
  // 出荷状態 - 入荷確定待ち
  String get ship_kbn_text_4;
  // 出荷状態 - 入荷済み
  String get ship_kbn_text_5;
  // 出荷状態 - 入荷済み
  String get ship_kbn_text_6;
  // 出荷状態 - 入荷済み
  String get ship_kbn_text_7;
  // 出荷状態 - 入荷済み
  String get ship_kbn_text_8;

  // 引当状态
  // 引当待ち
  String get lock_kbn_text_0;
  // 引当済
  String get lock_kbn_text_1;
  // 引当不足
  String get lock_kbn_text_2;

  // 棚卸开始 - 赵士淞 始
  // 未確定の棚卸日が存在するので、登録が失敗する
  String get start_inventory_text_1;
  // 現在の棚卸日対応倉庫の棚卸が完了しました。入力内容を確認してください
  String get start_inventory_text_2;
  // 入力したデータをクリアしますか？
  String get start_inventory_text_3;
  // 必須入力データを入力してください
  String get start_inventory_text_4;
  // 必須入力データを入力してください
  String get start_inventory_text_5;
  // 現在のシステム実在庫数<在庫ロック数、ご確認ください
  String get inventory_confirmed_text_1;
  // 差異ステータス
  String get inventory_query_search_text_1;
  // 完了ステータス
  String get inventory_query_search_text_2;
  // 棚卸开始 - 赵士淞 终

  // 現在の状態は削除できません
  String get this_status_cannot_delete;
  // 現在の状態を変更できません
  String get this_status_cannot_edit;

  // 操作ログ -start
  String get menu_content_99_6_1;
  String get menu_content_99_6_2;
  String get menu_content_99_6_3;
  String get menu_content_99_6_4;
  String get menu_content_99_6_5;
  String get menu_content_99_6_6;
  String get menu_content_99_6_7;
  // 操作ログ -end

  // 組織マスタ - 熊草云 始
  String get organization_master_form_1;
  String get organization_master_form_2;
  String get organization_master_form_3;
  String get organization_master_form_4;
  String get organization_master_form_5;
  String get organization_master_tip_1;
  String get organization_master_tip_2;
  String get organization_master_tip_3;
  String get organization_master_tip_4;
  String get organization_master_tip_5;
  String get organization_master_tip_6;
  String get organization_master_tip_7;
  String get organization_master_tip_8;
  String get organization_master_tip_9;
  // 組織マスタ - 熊草云 终

  // 営業日マスタ - 赵士淞 始
  // 営業ID
  String get mtb_calendar_text_1;
  // 営業日
  String get mtb_calendar_text_2;
  // 営業種類
  String get mtb_calendar_text_3;
  // 営業種類-自社休日
  String get mtb_calendar_text_3_1;
  // 営業種類-納入先休日
  String get mtb_calendar_text_3_2;
  // 営業種類-仕入先休日
  String get mtb_calendar_text_3_3;
  // 営業備考
  String get mtb_calendar_text_4;
  // 営業日マスタ - 赵士淞 终

  // 荷主マスタ -start
  String get shipping_master_form_1;
  String get shipping_master_form_2;
  String get shipping_master_form_3;
  String get shipping_master_form_4;
  String get shipping_master_form_5;
  String get shipping_master_form_6;
  String get shipping_master_form_7;
  String get shipping_master_form_8;
  String get shipping_master_form_9;
  String get shipping_master_form_10;
  String get shipping_master_form_11;
  String get shipping_master_form_12;
  String get shipping_master_form_13;
  String get shipping_master_form_14;
  String get shipping_master_form_15;
  String get shipping_master_form_16;
  String get shipping_master_form_17;
  // 荷主マスタ -end

  //配送業者マスタ start
  String get operator_text_1;
  String get operator_text_2;
  String get operator_text_3;
  String get operator_text_4;
  String get operator_text_5;
  //配送業者マスタ end

  // 課金法人管理 - 熊草云 始
  String get charge_management_form_1;
  String get charge_management_form_2;
  String get charge_management_tip_1;
  String get charge_management_tip_2;
  // 課金法人管理  - 熊草云 终
  // ライセンス管理 -start
  String get license_management_1;
  String get license_management_2;
  String get license_management_3;
  String get license_management_4;
  String get license_management_5;
  String get license_management_6;
  // ライセンス管理 -end

  // Stripe - start
  // 支払い開始に失敗しました
  String get payment_initiation_failed;
  // ジャンプ支払いに失敗しました
  String get transfer_payment_failed;
  // 支払ステータスの更新に失敗しました
  String get payment_status_update_failed;
  // おめでとう、支払い成功！
  String get congratulations_payment_successful;
  // Stripe - end

  //申込 -cuihr start
  // luxy start
  String get register_header_text_1;
  String get register_header_text_2;
  String get register_header_text_3;
  String get register_header_text_4;
  String get register_header_text_5;
  String get register_header_text_6;
  String get register_text_1;
  String get register_text_2;
  String get register_text_3;
  String get register_text_4;
  String get register_text_5;
  // luxy end
  String get register_title;
  String get register_user_form_1;
  String get register_company_form_1;
  String get register_user_1;
  String get register_user_2;
  String get register_user_3;
  String get register_user_4;
  String get register_company_1;
  String get register_company_2;
  String get register_company_3;
  String get register_company_4;
  String get register_company_5;
  String get register_company_6;
  String get register_btn_1;
  String get register_btn_2;
  String get register_btn_3;
  String get register_btn_4;
  String get register_table_1;
  String get register_table_2;
  String get register_table_3;
  String get register_table_4;
  String get register_error_1;
  String get register_choose;
  String get register_choose_type;
  String get register_choose_status;
  String get register_sub_success;
  String get register_sub_error;
  String get register_send_message;
  String get register_send_message_1;

  //申込 -cuihr end
  //サービス解約 -start
  String get contract_cancel_1;
  String get contract_cancel_2;
  String get contract_text_1;
  String get contract_text_2;
  String get contract_text_3;
  String get contract_text_4;
  String get contract_text_5;
  String get contract_text_6;
  String get contract_text_7;
  String get contract_text_8;
  String get contract_text_9;
  String get contract_text_10;
  String get contract_text_11;
  //サービス解約 -end

  // バーコード
  String get barcode;

  // ユーザーライセンス管理 熊草云 - start
  // ユーザー_名称
  String get user_license_management_form_1;
  // 言語
  String get user_license_management_form_2;
  // アイコン
  String get user_license_management_form_3;
  // ユーザー明細
  String get user_license_management_detail_form_1;
  // パスワードリセット
  String get user_license_management_detail_form_2;
  // 支払金額
  String get user_license_management_detail_table_1;
  // オーダー番号
  String get user_license_management_detail_table_2;
  // 有効期間(年)
  String get user_license_management_detail_table_3;
  // 有効期間(月)
  String get user_license_management_detail_table_4;
  // 有効期間(日)
  String get user_license_management_detail_table_5;
  // サポート内容
  String get user_license_management_detail_table_6;
  // 消費税（10％）
  String get user_license_management_detail_table_7;
  // 追加
  String get user_license_management_detail_table_8;
  // このメールアドレスは登録されています。他のメールアドレスを使用してみてください
  String get user_license_management_tip_1;
  // 成功メッセージ
  String get user_license_management_tip_2;
  // 修正不可
  String get user_license_management_tip_3;
  // ライセンス追加/修正
  String get user_license_management_tip_4;
  // ライセンス追加/修正しました
  String get user_license_management_tip_5;
  // 決済完了の場合、支払ステータスを確認してください
  String get user_license_management_tip_6;
  // ライセンスの種類を入力してください
  String get user_license_management_tip_7;
  // パスワードビット数少なくとも6ビット
  String get user_license_management_tip_8;
  // ユーザーライセンス管理 熊草云 - end

  //申込受付 cuihr -start
  String get app_cceptance_status;
  String get app_cceptance_time;
  String get app_cancel_status;
  String get app_cancel_time;
  String get app_cancel_status_not_confirm;
  String get app_cancel_status_confirm;
  String get app_cancel_confirmed_no_operation;
  String get app_cancel_confirm_finish;
  String get app_cancel_finish;
  String get app_cceptance_btn;
  String get app_error_text_1;
  String get app_error_text_2;
  String get app_error_text_3;
  String get app_error_text_4;
  String get app_send_text_1;
  String get app_send_text_2;
  String get app_send_text_3;
  String get app_send_text_4;
  String get app_send_text_5;
  String get app_send_text_6;
  String get app_send_text_7;
  String get app_send_text_8;
  String get app_send_text_9;
  String get app_send_text_10;
  String get app_send_text_11;
  String get app_send_text_12;
  String get app_send_text_13;
  String get app_cceptance_company_name;
  String get app_cceptance_user_name;
  String get app_cceptance_user_email;
  String get app_cceptance_user_phone;
  String get app_cceptance_pay_total;
  String get app_cceptance_pay_status;
  String get app_cceptance_info_1;
  String get app_cceptance_info_2;
  String get app_cceptance_info_3;
  String get app_cceptance_plan;
  String get app_cceptance_account_num;
  String get app_cceptance_option;
  String get app_cceptance_pay_cycle;
  //申込受付 cuihr -end

  // 帳票マスタ - 赵士淞 - 始
  // 区分
  String get form_distinguish;
  // 会社アイコン
  String get form_company_icon;
  // 用紙の向き
  String get form_paper_rotation;
  // 説明
  String get form_paper_explanation;
  // 横方向
  String get form_paper_transverse;
  // 縦方向
  String get form_paper_direction;
  // 帳票マスタ詳細
  String get form_detail_title;
  // 1行目の左部分
  String get form_location_one_left;
  // 1行目の中間部分
  String get form_location_one_center;
  // 1行目の右部分
  String get form_location_one_right;
  // 2行目の左部分
  String get form_location_two_left;
  // 2行目の中間部分
  String get form_location_two_center;
  // 2行目の右部分
  String get form_location_two_right;
  // テーブル
  String get form_location_table;
  // テキスト
  String get form_assort_text;
  // バーコード
  String get form_assort_bar_code;
  // 計算テキスト
  String get form_assort_calculation_text;
  // かさん
  String get form_mode_calculation_addition;
  // 減算
  String get form_mode_calculation_subtraction;
  // 乗算
  String get form_mode_calculation_multiplication;
  // 除算
  String get form_mode_calculation_division;
  // 表示
  String get form_show_true;
  // 非表示
  String get form_show_false;
  // 位置
  String get form_location;
  // 位置ID
  String get form_location_id;
  // 順序番号
  String get form_sequence_number;
  // 分類
  String get form_assort;
  // 数式
  String get form_formula;
  // フィールド名を表示
  String get form_show_field_name;
  // サイズ
  String get form_word_size;
  // コンテンツテーブル
  String get content_table;
  // コンテンツフィールド
  String get content_fields;
  // 計算表1
  String get calculation_table1;
  // 計算フィールド1
  String get calculation_fields1;
  // 計算表2
  String get calculation_table2;
  // 計算フィールド2
  String get calculation_fields2;
  // 計算モード
  String get calculation_mode;
  // 接頭辞テキスト
  String get form_prefix_text;
  // 接尾辞テキスト
  String get form_suffix_text;
  // 帳票マスタ - 赵士淞 - 终

  // 商品はすでに存在します
  String get product_exists;
  // 会社の略称はすでに存在している
  String get company_abbreviation_exists;
  // メニューにサブレベルが存在して削除できません
  String get menu_have_child_not_delete;

  // 入荷予定照会 muzd start
  // 少なくとも 1 つのデータを選択する
  String get inquiry_schedule_print_select_one;
  // 提示
  String get inquiry_schedule_print_tip;
  // 入荷予定一覧
  String get inquiry_schedule_print_receivelist;
  // オーダー番号
  String get inquiry_schedule_print_head_1;
  // 仕入先名称
  String get inquiry_schedule_print_head_2;
  // 入荷予定番号
  String get inquiry_schedule_print_head_3;
  // 入荷予定日
  String get inquiry_schedule_print_head_4;
  // 入荷予定明細行No
  String get inquiry_schedule_print_table_1;
  // 商品名
  String get inquiry_schedule_print_table_2;
  // 入荷予定数
  String get inquiry_schedule_print_table_3;
  // 仕入単価
  String get inquiry_schedule_print_table_4;
  // 金額
  String get inquiry_schedule_print_table_5;
  // 入荷予定明細
  String get inquiry_schedule_print_table_detail;
  // 入荷予定照会 muzd end

  // 计划管理：プラン管理
  String get plan_title_text;
  // 计划管理：プラン追加・削除
  String get plan_menu_text_1;
  // 计划管理：プラン内容変更
  String get plan_menu_text_2;
  // 计划管理：削除する
  String get plan_button_text_1;
  // 计划管理：追加する
  String get plan_button_text_2;
  // 计划管理：編集する
  String get plan_button_text_3;
  // 计划管理：ユーザーを追加
  String get plan_button_text_4;
  // 计划管理：ストレージ量を変更
  String get plan_button_text_5;
  // 计划管理：無償ライセンスを付与
  String get plan_button_text_6;
  // 计划管理：有償ライセンスを付与
  String get plan_button_text_7;
  // 计划管理：ユーザー数
  String get plan_content_text_1;
  // 计划管理：ストレージ
  String get plan_content_text_2;
  // 计划管理：その他制限事項を記載
  String get plan_content_text_3;
  // 计划管理：現在の最大ユーザー数
  String get plan_content_text_4;
  // 计划管理：現在の最大ストレージ量
  String get plan_content_text_5;
  // 计划管理：ライセンス割り当て
  String get plan_content_text_6;
  // 计划管理：最大10人
  String get plan_content_text_7;
  // 计划管理：最大
  String get plan_content_text_7_1;
  // 计划管理：人
  String get plan_content_text_7_2;
  // 计划管理：最大30GB
  String get plan_content_text_8;
  // 计划管理：最大
  String get plan_content_text_8_1;
  // 计划管理：GB
  String get plan_content_text_8_2;
  // 计划管理：ユーザー
  String get plan_content_text_9;
  // 计划管理：ライセンス
  String get plan_content_text_10;
  // 计划管理：現在のプラン
  String get plan_content_text_11;
  // 计划管理：お支払い方法
  String get plan_content_text_12;
  // 计划管理：利用開始日
  String get plan_content_text_13;
  // 计划管理：次回請求日
  String get plan_content_text_14;
  // 计划管理：DB容量
  String get plan_content_text_15;
  // 计划管理：ストレージ
  String get plan_content_text_16;
  // 计划管理：DBDL
  String get plan_content_text_17;
  // 计划管理：ストレージDL
  String get plan_content_text_18;
  // 计划管理：円/月
  String get plan_content_text_19;
  // 计划管理：プラン
  String get plan_content_text_20;
  // 计划管理：プラン名
  String get plan_content_text_21;
  // 计划管理：プラン金額
  String get plan_content_text_22;
  // 计划管理：新規ユーザー
  String get plan_content_text_23;
  // 计划管理：新規アカウント
  String get plan_content_text_24;
  // 计划管理：数量が上限に達しました
  String get plan_content_text_25;
  // 计划管理：入力値
  String get plan_content_text_26;

  //法人管理 muzd start
  // 法人管理
  String get corporate_management_title;
  // 契約内容の確認
  String get corporate_management_menu_1;
  // アカウント追加
  String get corporate_management_menu_2;
  // アカウント停止
  String get corporate_management_menu_3;
  // 検索文言
  String get corporate_management_search_tip;
  // 契約内容
  String get corporate_management_tab_1;
  // 申込時の内容
  String get corporate_management_tab_2;
  // ユーザー情報
  String get corporate_management_text_1;
  // 契約内容の詳細
  String get corporate_management_text_2;
  // 現在のユーザー数
  String get corporate_management_text_3;
  // 現在のストレージ使用量
  String get corporate_management_text_4;
  // 連携中のアカウント
  String get corporate_management_text_5;
  // アカウント
  String get corporate_management_text_5_1;
  // 会員
  String get corporate_management_text_6;
  // 非会員
  String get corporate_management_text_7;
  // お客様に替わって、お客様用アカウントを管理者が新設することができます。
  String get corporate_management_text_8;
  // ※決済はお客様にて行っていただきます。
  String get corporate_management_text_9;
  // メールアドレスを入力して下さい
  String get corporate_management_text_10;
  // パスワードを入力して下さい
  String get corporate_management_text_11;
  // 会社名（アカウント登録名）
  String get corporate_management_text_12;
  // プランを選ぶ
  String get corporate_management_text_13;
  // ユーザーを検索
  String get corporate_management_text_14;
  // メッセージを検索
  String get corporate_management_text_15;
  // アカウントを切替える
  String get corporate_management_button_1;
  // アカウントを追加
  String get corporate_management_button_2;
  // 確認する
  String get corporate_management_button_3;
  // 停止する
  String get corporate_management_button_4;
  //法人管理 muzd end

  // 消息管理 赵士淞 start
  // メッセージ
  String get message_master_base_title;
  // メッセージ作成
  String get message_master_title;
  // メッセージ一覧
  String get message_master_menu_1;
  // 個別メッセージ
  String get message_master_menu_2;
  // 全体メッセージ
  String get message_master_menu_3;
  // 下書き
  String get message_master_menu_4;
  // 返信
  String get message_master_content_button_1;
  // 転送
  String get message_master_content_button_2;
  // 全体へ送信
  String get message_master_content_button_3;
  // ライセンスある方へ送信
  String get message_master_content_button_4;
  // 消息管理 赵士淞 end

  // 用戸は会社法人、キャラクターは変更できない
  String get user_is_legal_role_cannot_changed;
  // 用戸は会社法人、削除できない
  String get user_is_legal_cannot_delete;
  // 会社には既に関連レコードが存在し、重複追加はできません
  String get company_has_records_cannot_add;
  // データが変更されましたので、再操作してください
  String get data_changed_operate_again;
  // 削除をしますか
  String get want_to_delete_it;
  // すでに解約状態であり、再申請は必要ありません
  String get is_termination_no_apply_again;
  // 会社はすでに解約しており、再度の解約はできません
  String get company_terminated_cannot_again;
  // 会社は存在しません
  String get company_not_exist;

  // 项目check
  // 半角英数字
  String get check_half_width_alphanumeric;
  // 半角数字
  String get check_half_width_numbers;
  // 10位内半角数字
  String get check_half_width_numbers_in_10;
  // 3位内半角数字
  String get check_half_width_numbers_in_3;
  // 半角数字，ハイフン
  String get check_half_width_numbers_with_hyphen;
  // 邮件
  String get check_email;
  // 半角英数記号
  String get check_half_width_alphanumeric_with_symbol;
  // カナ
  String get check_kana;
  // 密码
  String get check_password;
  // 邮编
  String get check_postal;

  // 商品情報
  String get product_information;
  // 仕掛情報
  String get design_information;
  // 在庫情報
  String get inventory_information;
  // トレンド情報
  String get information_trend;
  // 詳細を見る
  String get product_information_look_at_details;
  // 関連商品情報が見つかりませんでした
  String get product_information_no_product_information_found;
  // 関連する複数の商品情報を見つける
  String get product_information_multiple_product_information_found;
  // 出荷指示済数
  String get design_information_shipment_number;
  // 未出荷数
  String get design_information_unshipped_number;
  // 本日出荷指示数
  String get design_information_shipment_number_today;
  // 本日未出荷数
  String get design_information_unshipped_number_today;
  // 未出庫数
  String get design_information_unoutbound_number;
  // 未ピッキング数
  String get design_information_unpicking_number;
  // 未入荷数
  String get design_information_unexpected_number;
  // 本日入荷予定数
  String get design_information_expected_number_today;
  // 本日未入荷数
  String get design_information_unexpected_number_today;
  // 未検品数
  String get design_information_unchecked_number;
  // 未入庫数
  String get design_information_unlisted_number;
  // 棚番
  String get inventory_information_shelf;
  // ロット
  String get inventory_information_lot;
  // 価格
  String get inventory_information_price;
  // 現在庫数
  String get inventory_information_current_inventory;
  // 出荷先（上位５社）
  String get trend_information_shipment_top_five;
  // 出荷先
  String get trend_information_shipment;
  // 入荷元（上位５社）
  String get trend_information_entrance_top_five;
  // 入荷元
  String get trend_information_entrance;
  // 出荷数（月単位）
  String get trend_information_shipment_month;
  // 入荷数（月単位）
  String get trend_information_entrance_month;
  // 商品情報が見つかりませんでした、商品マスタを登録しますか？
  String get did_you_find_the_item_master;

  // ログインしたままにする
  String get login_remember_me;

  // 商品コード / JANCD
  String get home_menu_product_code_or_jan_cd;
  // 関連商品は検索されていませんが、新たに商品を追加しますか？
  String get no_products_found_want_to_add_new;

  // お申し込み
  String get login_application_title;
  // 申込
  String get login_application_step_1;
  // 認証
  String get login_application_step_2;
  // プラン選択
  String get login_application_step_3;
  // 完了
  String get login_application_step_4;
  // 以下のフォームに情報をご入力いただき、確認画面へお進みください。
  String get login_application_enter_form_text;
  // 会社名
  String get login_application_company_name;
  // 担当者名
  String get login_application_person_charge;
  // メールアドレス
  String get login_application_email_address;
  // 電話番号
  String get login_application_phone_number;
  // キャンペーンコード
  String get login_application_campaign_code;
  // パスワード
  String get login_application_password;
  // 必須
  String get login_application_required;
  // 任意
  String get login_application_optional;
  // 申込
  String get login_application_button_1;
  // Eメールが使用されているので、新しいEメールを交換してください
  String get login_application_email_address_error_exist;
  // 複数のアクティビティ例外が見つかりました。管理者に連絡して処理してください。
  String get login_application_campaign_code_error_multiple;
  // アクティビティが存在しないか、アクティビティの有効期間内にありません。
  String get login_application_campaign_code_error_invalid;
  // 複数のメールボックス申請の例外が見つかりました。管理者に連絡して処理してください。
  String get login_application_password_error_multiple;
  // メールボックスが存在しないか、パスワードが正しくありません。
  String get login_application_password_error_invalid;
  // 購買依頼オーダ支払済、管理者確認待ち
  String get login_application_password_error_paid;
  // ２段階認証
  String get login_application_authentication_title;
  // 入力された電話番号に確認コードを送信しました。
  String get login_application_authentication_text_1;
  // 送信された確認コードを入力してください。
  String get login_application_authentication_text_2;
  // スキャンコード検証
  String get login_application_verify_tab_1;
  // メールボックスの検証
  String get login_application_verify_tab_2;
  // Microsoft Authenticator認証APPの使用
  String get login_application_verify_tab_1_text;
  // メールを送信
  String get login_application_verify_tab_2_button;
  // 検証法が送信されました。1分後に再試行してください
  String get login_application_verify_tab_2_error_text;
  // プラン選択へ
  String get login_application_button_2;
  // 認証エラーメッセージ
  String get login_application_button_2_error_1;
  // mail認証タイトル
  String get login_application_mail_subject;
  // mail認証内容1
  String get login_application_mail_send_text_1;
  // mail認証内容2
  String get login_application_mail_send_text_2;
  // プランを選ぶ
  String get login_application_choose_plan;
  // 必要な機能
  String get login_application_choose_required;
  // 必要な機能を選択
  String get login_application_choose_required_text;
  // 出荷管理、入荷管理、在庫管理の3つの機能があります。
  String get login_application_choose_required_text_1;
  // 1機能だけだと19,800円。2機能の場合29,800円。3機能全て選択の場合39,800円。
  String get login_application_choose_required_text_2;
  // 出荷管理
  String get login_application_choose_required_button_1;
  // 入荷管理
  String get login_application_choose_required_button_2;
  // 在庫管理
  String get login_application_choose_required_button_3;
  // アカウント数を選ぶ
  String get login_application_choose_number_accounts;
  // 1.データ容量 ※従量課金部分
  String get login_application_choose_plan_title;
  // ご利用の容量に応じて、ベースプランとは別に以下の従量課金が月単位に発生いたします。締日（各月末日）の翌月に通常のお支払い分に加算してご請求させていただきますので、予めご了承ください。
  String get login_application_choose_plan_text;
  // 上限
  String get login_application_choose_plan_upper_limit;
  // DB容量
  String get login_application_choose_plan_db_capacity;
  // DBDL
  String get login_application_choose_plan_db_dl;
  // ストレージ
  String get login_application_choose_plan_storage;
  // ストレージDL
  String get login_application_choose_plan_storage_dl;
  // 2.アカウント数を選ぶ
  String get login_application_choose_account_title;
  // 標準
  String get login_application_choose_account_option_title_1;
  // 初期設定でアカウントは3つあります
  String get login_application_choose_account_option_text_1;
  // 1アカウント追加
  String get login_application_choose_account_option_title_2;
  // アカウントを新たに１つ追加（合計4つ）
  String get login_application_choose_account_option_text_2;
  // アカウント追加
  String get login_application_choose_account_input_text;
  // 正の整数値を入力する必要があります
  String get login_application_choose_account_input_error;
  // 3.オプションを選ぶ
  String get login_application_choose_supply_title;
  // 標準
  String get login_application_choose_supply_option_title_1;
  // オプション不要
  String get login_application_choose_supply_option_text_1;
  // 連携オプション
  String get login_application_choose_supply_option_title_2;
  // 上位（基幹系）システム、会計システムとのデータ連携をサポート
  String get login_application_choose_supply_option_text_2;
  // 文書管理オプション
  String get login_application_choose_supply_option_title_3;
  // ファイリング可能画面でのファイル保管をサポート
  String get login_application_choose_supply_option_text_3;
  // 取引先公開オプション
  String get login_application_choose_supply_option_title_4;
  // 取引先への在庫情報公開をサポート
  String get login_application_choose_supply_option_text_4;
  // 4.お支払いサイクル
  String get login_application_choose_cycle_title;
  // 月払い
  String get login_application_choose_cycle_month;
  // 年払い
  String get login_application_choose_cycle_year;
  // ※ 従量課金プランは月払いとなります
  String get login_application_choose_cycle_year_text;
  // 選択したプランの合計金額をご確認ください
  String get login_application_choose_amount_text;
  // 初期費用
  String get login_application_choose_amount_initial;
  // ベースプラン
  String get login_application_choose_amount_module;
  // 従量課金
  String get login_application_choose_amount_plan;
  // アカウント
  String get login_application_choose_amount_account;
  // オプション
  String get login_application_choose_amount_option;
  // 合計
  String get login_application_choose_amount_sum;
  // 円(税抜)
  String get login_application_choose_amount_tax;
  // 円(税抜)/月
  String get login_application_choose_amount_tax_month;
  // 日間無料でお試し
  String get login_application_choose_amount_free;
  // 次へ
  String get login_application_step_button_1;
  // 特定商取引法に基づく表記
  String get login_application_step_confirm_item_1;
  // プライバシーポリシー
  String get login_application_step_confirm_item_2;
  // に同意してください
  String get login_application_step_confirm_item_text;
  // 特定商取引法に基づく表記をチェックしてください
  String get login_application_step_button_1_tip_text_1;
  // プライバシーポリシーをチェックしてください
  String get login_application_step_button_1_tip_text_2;
  // ※ 価格は全て税抜表示となります。
  String get login_application_pure_text_title;
  // 1.従量過金部分（データ容量）に関して、サーチャージ等が影響しますので事前の告知なしに変更となる場合があります。
  String get login_application_pure_text_1;
  // 2.年払い選択時の従量課金プランについてベースプランとは別に従量課金部分に関しては月払いのサブスクリプションが発生します。
  String get login_application_pure_text_2;
  // 無料キャンペーンについての注意事項
  String get login_application_pure_text_2_1;
  // 無料期間が終了後、自動的に有料プランへ移行となります。ご継続をご希望されない場合は、期間終了までにマイページよりご解約のお手続きをお願いいたします。ご解約はいつでも可能ですが、期限を過ぎると自動更新となるためお早目のご対応をよろしくお願いいたします。
  String get login_application_pure_text_2_2;
  // ※ お申し込み日から無料期間経過後の23:59までにマイページよりご解約を完了してください。
  String get login_application_pure_text_2_3;
  // 3.無料キャンペーン時の従量課金について無料キャンペーン中の従量課金プランはフリーのみに制限されます。
  String get login_application_pure_text_3;
  // ログインページに戻る
  String get login_application_button_4;
  // 決済完了
  String get login_application_step_4_text_1;
  // お申し込みいただき、ありがとうございます。
  String get login_application_step_4_text_2;
  // 後ほど担当者からアカウント情報をご連絡させていただきます。
  String get login_application_step_4_text_3;
  // 申請通知
  String get login_application_end_email_title;
  // 決済が完了しました。
  String get login_application_end_email_text1;
  // お申し込みいただき、ありがとうごさいます。
  String get login_application_end_email_text2;
  // 2-3営業日以内に、担当者からアカツント情報をご連絡させていただきます。
  String get login_application_end_email_text3;

  // 継続料金
  String get login_renewal_title;
  // メールボックスには複数のアカウントが存在します
  String get email_multiple_accounts;
  // メールボックスは存在しません
  String get email_not_exist;
  // ユーザーは会社購買依頼管理者ではありません
  String get user_not_company_application_admin;
  // 最終支払レコードが見つかりません
  String get last_payment_record_not_found;
  // チャージバック有効期間ではなくオプションを変更できません
  String get option_cannot_changed_text_1;
  // 年間支払期限が切れていない場合はオプションを変更できません
  String get option_cannot_changed_text_2;
  // 使用中のユーザー数が3より大きい場合はオプションを変更できません
  String get users_in_use_than_3_option_cannot_changed;
  // ユーザー数を使用中のユーザー数よりも多く入力してください
  String get users_enter_must_then_users_in_use;

  // 2段階認証
  String get login_verification_code_text_title;
  // 認証コードを入力してください
  String get login_verification_code_text_content;
  // 送信する
  String get login_verification_code_button;

  // 提交
  String get login_company_complete_submit;
  // 存在未填写的信息，无法执行提交操作
  String get login_company_complete_submit_error;

  // POTTZ 申込
  String get legal_person_email_title;
  // お客様
  String get legal_person_email_text1;
  // お客様用アカウントを管理者が新設しました.
  String get legal_person_email_text2;
  // 下記URLにログインして申し込みを完了してください.
  String get legal_person_email_text3;
  // アカウントやパスワードがわからない場合は、管理者にお問い合わせください。
  String get legal_person_email_text4;

  // アカウントの追加に成功しました
  String get legal_person_add_success;

  // データベース領域が不足しています計画をアップグレードしてください
  String get database_space_low_upgrade_plan;
  // ストレージが不足しています計画をアップグレードしてください
  String get storage_space_low_upgrade_plan;

  //-------------------------------- 修正追加start
  // sort
  String get table_sort_column;
  //-------------------------------- 修正追加end
}
