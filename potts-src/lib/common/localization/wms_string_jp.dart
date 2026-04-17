import 'wms_string_base.dart';

/**
 * Created by yaozc
 * Date: 2023-07-01
 */
class WMSStringJp extends WMSStringBase {
  @override
  String welcomeMessage = "Welcome To Flutter";

  @override
  String app_name = "GSYGithubApp";

  @override
  String app_ok = "確認";
  @override
  String app_cancel = "キャンセル";
  @override
  String app_crows = "クローズ";
  @override
  String app_empty = "Empty(oﾟ▽ﾟ)o";
  @override
  String app_licenses = "licenses";
  @override
  String app_close = "close";
  @override
  String app_version = "version";
  @override
  String app_back_tip = "Exit？";

  @override
  String app_not_new_version = "No new version.";
  @override
  String app_version_title = "Update Version";

  @override
  String nothing_now = "Nothing";
  @override
  String loading_text = "Loading···";

  @override
  String option_web = "browser";
  @override
  String option_copy = "copy";
  @override
  String option_share = "share";
  @override
  String option_web_launcher_error = "url error";
  @override
  String option_share_title = "share form GSYGitHubFlutter： ";
  @override
  String option_share_copy_success = "貼り付けボードにコピーしました";

  @override
  String login_text = "ログイン";

  @override
  String login_confirm_text = "送信";
  @override
  String login_confirm_text_success = "送信完了しました";
  @override
  String login_confirm_text_error = "送信失败";
  @override
  String login_disUser_text_error = "会社員が見つかりません";

  @override
  String login_forget_pdw_text = "パスワードを忘れた方はこちら";

  @override
  String login_register_text = "新規登録";

  @override
  String login_register_content_text = "アカウントをお持ちでない場合はこちら";

  @override
  String oauth_text = "OAuth";

  @override
  String Login_out = "Logout";

  @override
  String Login_deprecated =
      "The API via password authentication will remove on November 13, 2020 by Github";

  @override
  String home_reply = "Feedback";
  @override
  String home_change_language = "Language";
  @override
  String home_change_grey = "Grey App";
  @override
  String home_about = "About";
  @override
  String home_check_update = "CheckUpdate";
  @override
  String home_history = "History";
  @override
  String home_user_info = "Profile";
  @override
  String home_change_theme = "Theme";
  @override
  String home_language_default = "Default";
  @override
  String home_language_zh = "中文";
  @override
  String home_language_en = "English";
  @override
  String switch_language = "select language";

  @override
  String home_theme_default = "Default";
  @override
  String home_theme_1 = "Theme1";
  @override
  String home_theme_2 = "Theme2";
  @override
  String home_theme_3 = "Theme3";
  @override
  String home_theme_4 = "Theme4";
  @override
  String home_theme_5 = "Theme5";
  @override
  String home_theme_6 = "Theme6";

  @override
  String login_username_hint_text = "ユーザーIDを入力して下さい";
  @override
  String login_password_hint_text = "パスワードを入力して下さい";
  @override
  String login_password_new_hint_text = "新しいパスワード";
  @override
  String login_again_pwd_hint_text = "新しいパスワードの再入力";
  @override
  String login_pwd_not_again_pwd_hint_text = "2つのパスワードが一致しませんでした、再度ご入力ください";
  @override
  String login_pwd_reset_hint_text = "リセット";
  @override
  String login_email_by_forget_pwd_text = "メールが送信されましたので、ご確認ください";
  @override
  String login_email_by_forget_error_pwd_text = "メールは存在しません、再入力してください";
  @override
  String login_email_by_forget_fail_pwd_text = "メール送信に失敗しました。再試行してください";
  @override
  String login_tip_title_modify_pwd_text = "ヒント";
  @override
  String login_reset_tip_modify_pwd_text = "パスワードをリセットしますか";
  @override
  String login_reset_error_modify_pwd_text = "パスワードのリセットに失敗しました。再試行してください";
  @override
  String login_url_failure_modify_pwd_text = "このリンクは無効です";
  @override
  String login_new_pwd_not_old_pwd_text =
      "以前使ったパスワードと同じ文字列は使えません。新しいパスワードを設定してください";
  @override
  String login_success = "Login Success";
  @override
  String login_error = "ユーザーIDまたはパスワードエラーです";
  @override
  String login_role_error_admin = "管理者アカウントを使用してログインしてください";
  @override
  String login_role_error_user = "一般ユーザーアカウントでログインしてください";
  @override
  String company_not_activated = "会社がアクティブになっていません";
  @override
  String company_has_terminated = "会社は解約しました";
  @override
  String login_email_by_forget_pwd_id_error_text = 'メールは存在しません、再入力してください';

  @override
  String network_error_401 = "Http 401";
  @override
  String network_error_403 = "Http 403";
  @override
  String network_error_404 = "Http 404";
  @override
  String network_error_422 =
      "Request Body Error，Please Check Github ClientId or Account/PW";
  @override
  String network_error_timeout = "Http timeout";
  @override
  String network_error_unknown = "Http unknown error";
  @override
  String network_error = "network error";
  @override
  String github_refused =
      "Github Api Error[OS Error: Connection refused]. Please switch networks or try again later ";
  @override
  String load_more_not = "nothing";
  @override
  String load_more_text = "loading";

  @override
  String home_dynamic = "Dynamic";
  @override
  String home_trend = "Trend";
  @override
  String home_my = "My";

  @override
  String error_return = "戻る";
  @override
  String error_message = "システムエラーが発生しました";

  //luxy-start
  @override
  String home_main_page_text1 = "当日出荷進捗";
  @override
  String home_main_page_text2 = "当日出荷数";
  @override
  String home_main_page_text3 = "引当済み";
  @override
  String home_main_page_text4 = "ピッキング済み";
  @override
  String home_main_page_text5 = "出荷待ち";
  @override
  String home_main_page_text6 = "入荷予定";
  @override
  String home_main_page_text7 = "一覧を見る";
  @override
  String home_main_page_text8 = "出荷指示";
  @override
  String home_main_page_text9 = "操作ログ";
  @override
  String home_main_page_text10 = "過去30日間の売上";
  @override
  String home_main_page_text11 = "過去3ヶ月の売上";
  @override
  String home_main_page_text12 = "本日の売上";
  @override
  String home_main_page_text13 = "本日の閲覧者数";
  @override
  String home_main_page_text14 = "本日の登録者数";
  @override
  String home_main_page_text15 = "本日の解約数";

  @override
  String home_main_page_table_text1 = "入荷予定日";
  @override
  String home_main_page_table_text2 = "指示番号";
  @override
  String home_main_page_table_text3 = "倉庫";
  @override
  String home_main_page_table_text4 = "ステータス";
  @override
  String home_main_page_table_text5 = "数量";
  @override
  String home_main_page_table_text6 = "出荷予定日";

  //luxy-end

  //首页 头部 消息 luxy-start
  @override
  String home_head_notice_text1 = "お知らせを検索";
  @override
  String home_head_notice_text2 = "新着通知";
  @override
  String home_head_notice_text3 = "全てのお知らせを見る";
  @override
  String home_head_notice_text4 = "削除を確認しますか";
  //首页 头部 消息 luxy-end

  // 赵士淞 - 始
  @override
  String home_head_search_hint_text = "検索内容を入力してください";
  // 首页头部多语言
  @override
  String home_head_language = "日本語";
  // 首页头部多语言日文
  @override
  String home_head_language_jp = "日本語";
  // 首页头部多语言英文
  @override
  String home_head_language_en = "English";
  // 首页头部多语言简体中文
  @override
  String home_head_language_zh = "简体中文";
  // 首页头部多语言繁体中文
  @override
  String home_head_language_tc = "繁体中文";

  // 出荷指示入力：CSV下载
  @override
  String instruction_input_csv_download = "CSV 出荷指示取り込み";
  // 出荷指示入力：API下载
  @override
  String instruction_input_api_download = "API 出荷指示取り込み";
  // 出荷指示入力：Tab基本情報入力
  @override
  String instruction_input_tab_basic = "基本情報入力";
  // 出荷指示入力：Tab出荷先情報入力
  @override
  String instruction_input_tab_before = "出荷先情報入力";
  @override
  String instruction_input_tab_before_text = "出荷先情報";
  // 出荷指示入力：Tab詳細情報入力
  @override
  String instruction_input_tab_detail = "詳細情報入力";
  // 出荷指示入力：Tab一覧
  @override
  String instruction_input_tab_list = "一覧";
  // 出荷指示入力：Tab入金待ち
  @override
  String instruction_input_tab_payment = "入金待ち";
  // 出荷指示入力：Tab引当待ち
  @override
  String instruction_input_tab_allowance = "引当待ち";
  // 出荷指示入力：Tab出荷待ち
  @override
  String instruction_input_tab_wait = "出荷待ち";
  // 出荷指示入力：Tab出荷作業中
  @override
  String instruction_input_tab_work = "出荷作業中";
  // 出荷指示入力：Tab出荷済み
  @override
  String instruction_input_tab_complete = "出荷済み";
  // 出荷指示入力：Tab登録
  @override
  String instruction_input_tab_button_add = "登録";
  // 出荷指示入力：Tab修正
  @override
  String instruction_input_tab_button_update = "修正";
  // 出荷指示入力：Tab全選択
  @override
  String instruction_input_tab_button_choice = "全選択";
  // 出荷指示入力：Tab全解除
  @override
  String instruction_input_tab_button_cancellation = "全解除";
  // 出荷指示入力：Tab明細
  @override
  String instruction_input_tab_button_details = "明細";
  // 出荷指示入力：Tab明細行を追加
  @override
  String instruction_input_tab_button_details_add = "明細行を追加";
  // 出荷指示入力：TabCSV
  @override
  String instruction_input_tab_button_csv = "CSV";
  // 出荷指示入力：TabAPI
  @override
  String instruction_input_tab_button_api = "API";
  // 出荷指示入力：Tab印刷
  @override
  String instruction_input_tab_button_print = "印刷";
  // 出荷指示入力：基本情報入力-出荷指示番号
  @override
  String instruction_input_form_basic_1 = "出荷指示番号";
  // 出荷指示入力：基本情報入力-得意先注文番号
  @override
  String instruction_input_form_basic_2 = "得意先注文番号";
  // 出荷指示入力：基本情報入力-出荷指示日
  @override
  String instruction_input_form_basic_3 = "出荷指示日";
  // 出荷指示入力：基本情報入力-得意先名
  @override
  String instruction_input_form_basic_4 = "得意先名";
  // 出荷指示入力：基本情報入力-納入日
  @override
  String instruction_input_form_basic_5 = "納入日";
  // 出荷指示入力：基本情報入力-得意先コード
  @override
  String instruction_input_form_basic_6 = "得意先コード";
  // 出荷指示入力：基本情報入力-指定納期
  @override
  String instruction_input_form_basic_7 = "指定納期";
  // 出荷指示入力：基本情報入力-納入先名
  @override
  String instruction_input_form_basic_8 = "納入先名";
  // 出荷指示入力：基本情報入力-注意備考1
  @override
  String instruction_input_form_basic_9 = "注意備考1";
  // 出荷指示入力：基本情報入力-注意備考2
  @override
  String instruction_input_form_basic_10 = "注意備考2";
  // 出荷指示入力：基本情報入力-納入先コード
  @override
  String instruction_input_form_basic_11 = "納入先コード";
  // 出荷指示入力：基本情報入力-得意先備考
  @override
  String instruction_input_form_basic_12 = "得意先備考";
  // 出荷指示入力：基本情報入力-社内備考
  @override
  String instruction_input_form_basic_13 = "社内備考";
  // 出荷指示入力：出荷先情報入力-郵便番号
  @override
  String instruction_input_form_before_1 = "郵便番号";
  // 出荷指示入力：出荷先情報入力-納入先担当者名
  @override
  String instruction_input_form_before_2 = "納入先担当者名";
  // 出荷指示入力：出荷先情報入力-都道府県
  @override
  String instruction_input_form_before_3 = "都道府県";
  // 出荷指示入力：出荷先情報入力-区市町村
  @override
  String instruction_input_form_before_4 = "区市町村";
  // 出荷指示入力：出荷先情報入力-出荷担当者名
  @override
  String instruction_input_form_before_5 = "出荷担当者名";
  // 出荷指示入力：出荷先情報入力-住所1
  @override
  String instruction_input_form_before_6 = "住所1";
  // 出荷指示入力：出荷先情報入力-出荷担当者コード
  @override
  String instruction_input_form_before_7 = "出荷担当者コード";
  // 出荷指示入力：出荷先情報入力-住所2（建物名など）
  @override
  String instruction_input_form_before_8 = "住所2（建物名など）";
  // 出荷指示入力：出荷先情報入力-出荷担当部門名
  @override
  String instruction_input_form_before_9 = "出荷担当部門名";
  // 出荷指示入力：出荷先情報入力-電話番号
  @override
  String instruction_input_form_before_10 = "電話番号";
  // 出荷指示入力：出荷先情報入力-出荷担当部門コード
  @override
  String instruction_input_form_before_11 = "出荷担当部門コード";
  // 出荷指示入力：出荷先情報入力-納入先カナ名称
  @override
  String instruction_input_form_before_12 = "納入先カナ名称";
  // 出荷指示入力：出荷先情報入力-納入先郵便番号
  @override
  String instruction_input_form_before_13 = "納入先郵便番号";
  // 出荷指示入力：出荷先情報入力-納入先都道府県
  @override
  String instruction_input_form_before_14 = "納入先都道府県";
  // 出荷指示入力：出荷先情報入力-納入先市区町村
  @override
  String instruction_input_form_before_15 = "納入先市区町村";
  // 出荷指示入力：出荷先情報入力-納入先住所詳細
  @override
  String instruction_input_form_before_16 = "納入先住所詳細";
  // 出荷指示入力：出荷先情報入力-納入先電話番号
  @override
  String instruction_input_form_before_17 = "納入先電話番号";
  // 出荷指示入力：出荷先情報入力-納入先FAX番号
  @override
  String instruction_input_form_before_18 = "納入先FAX番号";
  // 出荷指示入力：詳細情報入力-荷姿
  @override
  String instruction_input_form_detail_1 = "荷姿";
  // 出荷指示入力：詳細情報入力-商品大分類
  @override
  String instruction_input_form_detail_2 = "商品大分類";
  // 出荷指示入力：詳細情報入力-商品中分類
  @override
  String instruction_input_form_detail_3 = "商品中分類";
  // 出荷指示入力：詳細情報入力-商品小分類
  @override
  String instruction_input_form_detail_4 = "商品小分類";
  // 出荷指示入力：詳細情報入力-商品写真1
  @override
  String instruction_input_form_detail_5 = "商品写真1";
  // 出荷指示入力：詳細情報入力-商品写真2
  @override
  String instruction_input_form_detail_6 = "商品写真2";
  // 出荷指示入力：詳細情報入力-注意備考1
  @override
  String instruction_input_form_detail_7 = "注意備考1";
  // 出荷指示入力：詳細情報入力-社内備考1
  @override
  String instruction_input_form_detail_8 = "社内備考1";
  // 出荷指示入力：詳細情報入力-得意先明細備考
  @override
  String instruction_input_form_detail_9 = "得意先明細備考";
  // 出荷指示入力：詳細情報入力-注意備考2
  @override
  String instruction_input_form_detail_10 = "注意備考2";
  // 出荷指示入力：詳細情報入力-社内備考2
  @override
  String instruction_input_form_detail_11 = "社内備考2";
  // 出荷指示入力：詳細情報入力-社内明細備考
  @override
  String instruction_input_form_detail_12 = "社内明細備考";
  // 出荷指示入力：詳細情報入力-出荷指示数
  @override
  String instruction_input_form_detail_13 = "出荷指示数";
  // 出荷指示入力：詳細情報入力-消費期限
  @override
  String instruction_input_form_detail_14 = "消費期限";
  // 出荷指示入力：詳細情報入力-ロット番号
  @override
  String instruction_input_form_detail_15 = "ロット番号";
  // 出荷指示入力：詳細情報入力-シリアル
  @override
  String instruction_input_form_detail_16 = "シリアル";
  // 出荷指示入力：詳細情報入力-商品社内備考1
  @override
  String instruction_input_form_detail_17 = "商品社内備考1";
  // 出荷指示入力：詳細情報入力-商品社内備考2
  @override
  String instruction_input_form_detail_18 = "商品社内備考2";
  // 出荷指示入力：詳細情報入力-商品注意備考1
  @override
  String instruction_input_form_detail_19 = "商品注意備考1";
  // 出荷指示入力：詳細情報入力-商品注意備考2
  @override
  String instruction_input_form_detail_20 = "商品注意備考2";
  // 出荷指示入力：詳細情報入力-得意先カナ名称
  @override
  String instruction_input_form_detail_21 = "得意先カナ名称";
  // 出荷指示入力：詳細情報入力-得意先郵便番号
  @override
  String instruction_input_form_detail_22 = "得意先郵便番号";
  // 出荷指示入力：詳細情報入力-得意先都道府県
  @override
  String instruction_input_form_detail_23 = "得意先都道府県";
  // 出荷指示入力：詳細情報入力-得意先市区町村
  @override
  String instruction_input_form_detail_24 = "得意先市区町村";
  // 出荷指示入力：詳細情報入力-得意先住所詳細
  @override
  String instruction_input_form_detail_25 = "得意先住所詳細";
  // 出荷指示入力：詳細情報入力-得意先電話番号
  @override
  String instruction_input_form_detail_26 = "得意先電話番号";
  // 出荷指示入力：詳細情報入力-得意先FAX番号
  @override
  String instruction_input_form_detail_27 = "得意先FAX番号";
  // 出荷指示入力：詳細情報入力-納入先は得意先と同一
  @override
  String instruction_input_form_detail_28 = "納入先は得意先と同一";
  // 出荷指示入力：表单-から
  @override
  String instruction_input_form_from = "から";
  // 出荷指示入力：表单-出荷指示日は納入日より前にしなければならない
  @override
  String instruction_input_form_basic_3_less_than_basic_5 =
      "出荷指示日は納入日より前にしなければならない";
  // 出荷指示入力：表格标题-[空]
  @override
  String instruction_input_table_title_0 = "";
  // 出荷指示入力：表格标题-No.
  @override
  String instruction_input_table_title_1 = "ID";
  // 出荷指示入力：表格标题-出荷倉庫
  @override
  String instruction_input_table_title_2 = "出荷倉庫";
  // 出荷指示入力：表格标题-商品コード
  @override
  String instruction_input_table_title_3 = "商品コード";
  // 出荷指示入力：表格标题-商品名
  @override
  String instruction_input_table_title_4 = "商品名";
  // 出荷指示入力：表格标题-規格
  @override
  String instruction_input_table_title_5 = "規格";
  // 出荷指示入力：表格标题-出荷数量
  @override
  String instruction_input_table_title_6 = "出荷数量";
  // 出荷指示入力：表格标题-単位
  @override
  String instruction_input_table_title_7 = "単位";
  // 出荷指示入力：表格标题-行番号
  @override
  String instruction_input_table_title_8 = "ID";
  // 出荷指示入力：表格标题-単価
  @override
  String instruction_input_table_title_9 = "単価";
  // 出荷指示入力：表格标题-出荷指示
  @override
  String instruction_input_table_title_10 = "出荷指示";
  // 出荷指示入力：表格操作-出荷明細
  @override
  String instruction_input_table_operate_detail = "出荷明細";
  // 出荷指示入力：表格操作-削除
  @override
  String instruction_input_table_operate_delete = "削除";
  // 出荷確定データ出力：检索条件-按钮文本
  @override
  String shipment_confirmation_export_query = "検索";
  // 出荷確定データ出力：检索条件-字段文本
  @override
  String shipment_confirmation_export_query_1 = "出荷確定日";
  // 出荷確定データ出力：表格标题-[空]
  @override
  String shipment_confirmation_export_table_title_0 = "";
  // 出荷確定データ出力：表格标题-No.
  @override
  String shipment_confirmation_export_table_title_1 = "ID";
  // 出荷確定データ出力：表格标题-出荷指示番号
  @override
  String shipment_confirmation_export_table_title_2 = "出荷指示番号";
  // 出荷確定データ出力：表格标题-出荷指示日
  @override
  String shipment_confirmation_export_table_title_3 = "出荷指示日";
  // 出荷確定データ出力：表格标题-納入日
  @override
  String shipment_confirmation_export_table_title_4 = "納入日";
  // 出荷確定データ出力：表格标题-得意先
  @override
  String shipment_confirmation_export_table_title_5 = "得意先";
  // 出荷確定データ出力：表格标题-納入先
  @override
  String shipment_confirmation_export_table_title_6 = "納入先";
  @override
  String shipment_confirmation_1 = '正しい年月日を入力してください。';
  // 账户：菜单-プロフィール
  @override
  String account_menu_1 = "プロフィール";
  // 账户：菜单-アカウント切替
  @override
  String account_menu_2 = "アカウント切替";
  // 账户：菜单-セキュリティ
  @override
  String account_menu_3 = "パスワード変更";
  // 账户：菜单-プラン確認
  @override
  String account_menu_4 = "プラン確認";
  // 账户：菜单-ライセンス
  @override
  String account_menu_5 = "ライセンス";
  // 账户：菜单-ログアウト
  @override
  String account_menu_6 = "ログアウト";
  // 账户：菜单-スキャンコード
  @override
  String account_menu_7 = "スキャンコード";
  // 账户：简介-登録名
  @override
  String account_profile_user = "登録名";
  // 账户：简介-表示名
  @override
  String account_profile_display = "表示名";
  // 账户：简介-デフォルト言語
  @override
  String account_profile_language = "デフォルト言語";
  // 账户：简介-会社
  @override
  String account_profile_company = "会社";
  // 账户：简介-ロール
  @override
  String account_profile_roll = "ロール";
  // 账户：简介-状態
  @override
  String account_profile_state = "状態";
  // 账户：简介-編集
  @override
  String account_profile_edit = "編集";
  // 账户：简介-登録名を変更する
  @override
  String account_profile_user_change = "登録名を変更する";
  // 账户：简介-表示名を変更する
  @override
  String account_profile_display_change = "表示名を変更する";
  // 账户：简介-デフォルト言語を変更する
  @override
  String account_profile_language_change = "デフォルト言語を変更する";
  // 账户：简介-会社を変更する
  @override
  String account_profile_company_change = "会社を変更する";
  // 账户：简介-ロールを変更する
  @override
  String account_profile_roll_change = "ロールを変更する";
  // 账户：简介-状態を変更する
  @override
  String account_profile_state_change = "状態を変更する";
  // 账户：简介-新しい登録名を入力してください
  @override
  String account_profile_user_new = "新しい登録名を入力してください";
  // 账户：简介-新しい表示名を入力してください
  @override
  String account_profile_display_new = "新しい表示名を入力してください";
  // 账户：简介-新しいデフォルト言語を入力してください
  @override
  String account_profile_language_new = "新しいデフォルト言語を入力してください";
  // 账户：简介-新しい会社を入力してください
  @override
  String account_profile_company_new = "新しい会社を入力してください";
  // 账户：简介-新しいロールを入力してください
  @override
  String account_profile_roll_new = "新しいロールを入力してください";
  // 账户：简介-新しい状態を入力してください
  @override
  String account_profile_state_new = "新しい状態を入力してください";
  // 账户：简介-キャンセル
  @override
  String account_profile_cancel = "キャンセル";
  // 账户：简介-登録
  @override
  String account_profile_registration = "登録";
  // 账户：安全性-パスワード
  @override
  String account_security_password = "パスワード";
  // 账户：安全性-パスワードを変更する
  @override
  String account_security_password_change = "パスワードを変更する";
  // 账户：安全性-新しいパスワードを入力してください
  @override
  String account_security_password_new = "新しいパスワードを入力してください";
  // 账户：许可证-ライセンスの種類
  @override
  String account_license_type = "ライセンスの種類";
  // 账户：许可证-運用開始日
  @override
  String account_license_start = "運用開始日";
  // 账户：许可证-運用終了日
  @override
  String account_license_end = "運用終了日";
  // 账户：许可证-支払状態
  @override
  String account_license_payment = "支払状態";
  // 账户：退出-ログアウトでしょうか？
  @override
  String account_logout_text = "ログアウトしますが、よろしいでしょうか？";
  // 账户：计划-利用内容・アカウント管理
  @override
  String account_contents_account_management = "利用内容・アカウント管理";
  // 账户：计划-確認する
  @override
  String account_confirm = "確認する";
  // 账户：计划-解約する
  @override
  String account_cancel = "解約する";
  // 账户：解约-サービスを解約する
  @override
  String account_cancel_title = "サービスを解約する";
  // 账户：解约-※解約手続きを完了すると、以下のデータが完全に削除され今後ログインができなくなります。データの削除は取り消すことができませんがよろしいですか？
  @override
  String account_cancel_text =
      "※解約手続きを完了すると、以下のデータが完全に削除され今後ログインができなくなります。データの削除は取り消すことができませんがよろしいですか？";
  // 账户：解约-削除するユーザー
  @override
  String account_cancel_user = "削除するユーザー";
  // 账户：解约-登録名：
  @override
  String account_cancel_user_name = "登録名：";
  // 账户：解约-メールアドレス：
  @override
  String account_cancel_user_email = "メールアドレス：";
  // 账户：解约-削除されるデータ
  @override
  String account_cancel_data = "削除されるデータ";
  // 账户：解约-・削除する関連ユーザー
  @override
  String account_cancel_data_content_1 = "・削除する関連ユーザー";
  // 账户：解约-・削除する関連プラットフォームアカウント
  @override
  String account_cancel_data_content_2 = "・削除する関連プラットフォームアカウント";
  // 账户：解约-・削除する関連データベース情報
  @override
  String account_cancel_data_content_3 = "・削除する関連データベース情報";
  // 账户：解约-・削除する関連アップロードファイル
  @override
  String account_cancel_data_content_4 = "・削除する関連アップロードファイル";
  // 账户：解约-解約申請する
  @override
  String account_cancel_button_1 = "解約申請する";
  // 账户：解约-解約する
  @override
  String account_cancel_button_2 = "解約する";
  // 账户：解约-担当者が解約申請を確認次第ご返信いたします。
  @override
  String account_cancel_prompt_1 = "担当者が解約申請を確認次第ご返信いたします。";
  // 账户：解约-※データを完全に消去するため二度と復元することはできません。
  @override
  String account_cancel_prompt_2 = "※データを完全に消去するため二度と復元することはできません。";
  // 账户：運用開始日<運用終了日提示
  @override
  String account_license_start_less_end_message = "運用開始日は運用終了日より後にすることはできません";
  // 账户：画像変更はダブルクリックして任意の画像を選択します
  @override
  String account_double_click_any_image_to_change_image =
      "画像変更はダブルクリックして任意の画像を選択します";
  // 账户：解約の申し込みがありましたので、管理者の確認をお待ちください
  @override
  String account_application_initiated_please_wait =
      "解約の申し込みがありましたので、管理者の確認をお待ちください";
  // 账户：解約依頼が送信されました
  @override
  String account_application_has_been_sent = "解約依頼が送信されました";
  // 出庫入力：表单标题-ピッキングリストバーコード
  @override
  String exit_input_form_title_1 = "ピッキングリストバーコード";
  // 出庫入力：表单标题-出荷指示番号
  @override
  String exit_input_form_title_2 = "出荷指示番号";
  // 出庫入力：表单标题-得意先
  @override
  String exit_input_form_title_3 = "得意先";
  // 出庫入力：表单标题-納入先
  @override
  String exit_input_form_title_4 = "納入先";
  // 出庫入力：表单标题-ピッキングリスト明細部のバーコード
  @override
  String exit_input_form_title_5 = "ピッキングリスト明細部のバーコード";
  // 出庫入力：表单标题-ロケーション
  @override
  String exit_input_form_title_6 = "ロケーション";
  // 出庫入力：表单标题-商品ID
  @override
  String exit_input_form_title_7 = "商品コード";
  // 出庫入力：表单标题-商品名
  @override
  String exit_input_form_title_8 = "商品名";
  // 出庫入力：表单标题-引当数
  @override
  String exit_input_form_title_9 = "引当数";
  // 出庫入力：表单标题-商品写真
  @override
  String exit_input_form_title_10 = "商品写真";
  // 出庫入力：表单标题-ロケーションのバーコード
  @override
  String exit_input_form_title_11 = "ロケーションのバーコード";
  // 出庫入力：表单标题-商品ラベルのバーコード
  @override
  String exit_input_form_title_12 = "商品ラベルのバーコード";
  // 出庫入力：表单标题-合計数
  @override
  String exit_input_form_title_13 = "合計数";
  // 出庫入力：表单标题-カゴ車またはオリコンのバーコード
  @override
  String exit_input_form_title_14 = "カゴ車またはオリコンのバーコード";
  // 出庫入力：表单提示-正しいNoのにゅうりょく入力をおねがい願いします。
  @override
  String exit_input_form_Toast_1 = "正しい明細部のバーコードを入力してください";
  // 出庫入力：表单提示-ロケーションの入力ミスです
  @override
  String exit_input_form_Toast_2 = "の入力ミスです";
  // 出庫入力：表单提示-商品にゅうりょく入力がまちっが間違っています。
  @override
  String exit_input_form_Toast_3 = "正しい値を入力してください";
  // 出庫入力：正しい値の入力をお願いします
  @override
  String exit_input_form_Toast_4 = "正しい値の入力をお願いします";
  @override
  String exit_input_form_Toast_5 = "正しいロケーションバーコードを入力してください";
  @override
  String exit_input_form_Toast_6 = "正しい商品ラベルバーコードを入力してください";
  @override
  String exit_input_form_Toast_7 = "正しいカゴ車またはオリコンのバーコードを入力してください";
  // 出庫入力：表单提示-商品にゅうりょく入力がまちっが間違っています。
  // 出庫入力：弹窗标题
  @override
  String exit_input_pop_title = "ラベル発行";
  // 出庫入力：表单按钮-ラベル発行
  @override
  String exit_input_form_button_issue = "ラベル発行";
  // 出庫入力：弹窗表单标题-ラベル数量
  @override
  String exit_input_popup_form_title_1 = 'ラベル数量';
  // 出庫入力：弹窗表单按钮-印刷
  @override
  String exit_input_popup_form_button = '印刷';
  // 出庫入力：表单按钮-クリア
  @override
  String exit_input_form_button_clear = "クリア";
  // 出庫入力：表单按钮-実行
  @override
  String exit_input_form_button_execute = "実行";
  // 出庫入力：出庫入力一覧
  @override
  String exit_input_form_overview = "出庫入力一覧";
  // 出庫入力：标签发行
  @override
  String exit_input_form_issuance = "ラベル発行";
  // 出庫入力：表格按钮-削除
  @override
  String exit_input_table_delete = "削除";
  // 出庫入力：表格按钮-修改
  @override
  String exit_input_table_update = "修正";
  // 出庫入力：表格标题-[空]
  @override
  String exit_input_table_title_0 = "";
  // 出庫入力：表格标题-No.
  @override
  String exit_input_table_title_1 = "No.";
  // 出庫入力：表格标题-出荷倉庫
  @override
  String exit_input_table_title_2 = "出荷倉庫";
  // 出庫入力：表格标题-ロケーションコード
  @override
  String exit_input_table_title_3 = "ロケーションコード";
  // 出庫入力：表格标题-商品コード
  @override
  String exit_input_table_title_4 = "商品コード";
  // 出庫入力：表格标题-商品名
  @override
  String exit_input_table_title_5 = "商品名";
  // 出庫入力：表格标题-単価
  @override
  String exit_input_table_title_6 = "単価";
  // 出庫入力：表格标题-出荷数量
  @override
  String exit_input_table_title_7 = "出荷数量";
  // 出庫入力：表格标题-単位
  @override
  String exit_input_table_title_8 = "単位";
  // 出庫入力：表格标题-小計
  @override
  String exit_input_table_title_9 = "小計";
  // 出庫入力：出库按钮（SP画面）
  @override
  String exit_input_button_1 = "出庫";
  // 合计数与引当数不一致
  @override
  String exit_input_text_1 = '合計数と引当数が一致していません、合計数を確認してください';
  // 実行成功
  @override
  String exit_input_text_2 = '実行成功しました';
  // 実行失败
  @override
  String exit_input_text_3 = '実行失敗しました';
  // 删除不可
  @override
  String exit_input_text_4 = '出荷指示の出荷状態は梱包待ちの場合削除できません';
  // 商品已出库
  @override
  String exit_input_text_5 = '商品は出庫しました';
  // 表格：分条文本-1ページあたり
  @override
  String table_striping_text_1 = "1ページあたり";
  // 表格：分条文本-本
  @override
  String table_striping_text_2 = "行";

  // CSV
  @override
  String file_type_csv = "CSV";

  // を空白にすることはできません
  @override
  String can_not_null_text = "を空白にすることはできません";
  // 文字は10桁以上ではいけません
  @override
  String text_can_not_gt_ten = "文字は10桁以上ではいけません";
  // 関連データが見つかりません
  @override
  String no_items_found = "関連データが見つかりませんでした";
  // ログインユーザ情報が見つかりません
  @override
  String login_user_error = "ログインユーザ情報が見つかりませんでした";
  // 赵士淞 - 始
  // ログインユーザーが有効期限を過ぎています
  @override
  String login_user_expire = "ログインユーザーが有効期限を過ぎています、再度、ログインしてください";
  // 会社が失効しました
  @override
  String company_has_expired = "会社のライセンスは有効期間切れです。ご確認ください";
  // 赵士淞 - 终
  // の作成に失敗しました
  @override
  String create_error = "の作成に失敗しました";
  // の作成に成功しました
  @override
  String create_success = "の作成に成功しました";
  // の更新に失敗しました
  @override
  String update_error = "の更新に失敗しました";
  // の更新に成功しました
  @override
  String update_success = "の更新に成功しました";
  // の削除に失敗しました
  @override
  String delete_error = "の削除に失敗しました";
  // の削除に成功しました
  @override
  String delete_success = "の削除に成功しました";
  // の取り込みに失敗しました
  @override
  String import_error = "の取り込みに失敗しました";
  // の取り込みに成功しました
  @override
  String import_success = "の取り込みに成功しました";
  // は13桁以内の半角数字で入力してください
  @override
  String text_must_thirteen_number = "は13桁以内の半角数字で入力してください";
  // は6～50桁の数字またはアルファベットで入力してください
  @override
  String text_must_six_number_letter = " は6～50桁の数字またはアルファベットで入力してください";
  // は数字またはアルファベットでなければなりません
  @override
  String text_must_number_letter = "は半角英数字で入力してください";

  // 選択モードを確認してください
  String confirm_selection_mode = "選択モードをご確認してください";
  // カメラ
  String selection_mode_camera = "カメラ";
  // アルバム冊
  String selection_mode_album = "アルバム";
  // 画像サイズは2 M以内
  String image_size_need_within_2m = "2MB以上の画像はアップロードできません";
  // 印刷日時
  String printing_time = "印刷日時";
  // ラベルプ
  String label_printing = "ラベル";
  // パラメータが見つかりません。印刷できません
  String miss_param_unable_print = "データが見つかりませんので、印刷できませんでした";
  // 棚の商品タグ
  String shelves_product_label = "棚の商品タグ";
  // バスケットの商品タグ
  String baskets_product_label = "バスケットの商品タグ";
  // 赵士淞 - 终
  // 数字を入力してください
  @override
  String input_int_check = " 、半角数字を入力してください";
  // 10桁以内の数字を入力してください
  @override
  String input_int_in_10_check = " 、9桁以内の半角数字を入力してください";
  //6桁の数字を入力してください
  @override
  String input_int_6_check = " 、6桁の半角数字を入力してください";
  // 英数字を入力してください
  @override
  String input_letter_and_number_check = " 、半角英数字を入力してください";

  // 邮件を入力してください
  @override
  String input_email_check = " 、メールアドレスを入力してください";

  //英数字、記号を入力してください
  @override
  String input_letter_and_number_and_symbol_check = " 、半角英数字または記号を入力してください";

  //1～4桁のA~Zを入力してください
  @override
  String input_company_1_check = "、1～4桁のA~Zを入力してください";

  //半角数字、ハイフンを入力してください
  @override
  String input_half_width_numbers_with_hyphen_check = "、半角数字、ハイフンを入力してください";

  //6～50桁の数字を入力してください
  @override
  String input_must_six_number_check = "、6～50桁の半角数字を入力してください";

  @override
  String input_postal_code_check = "入力された郵便番号が正しくありません";

  //提示文言
  @override
  String input_text = "を入力してください";

  // 菜单内容 - 始
  @override
  String menu_content_1 = "ホーム";
  @override
  String menu_content_2 = "入荷";
  @override
  String menu_content_2_1 = "入荷予定入力";
  @override
  String menu_content_2_2 = "入荷予定データ 取込CSV";
  @override
  String menu_content_2_3 = "入庫入力";
  @override
  String menu_content_2_4 = "入荷検品";
  @override
  String menu_content_2_5 = "入荷予定照会";
  //luxy -start
  @override
  String menu_content_2_5_1 = "検品待ち";
  @override
  String menu_content_2_5_2 = "入庫待ち";
  @override
  String menu_content_2_5_3 = "入荷確定待ち";
  @override
  String menu_content_2_5_4 = "入荷済み";
  @override
  String menu_content_2_5_5 = "仕入先";
  @override
  String menu_content_2_5_6 = "入荷予定番号";
  @override
  String menu_content_2_5_7 = "仕入先注文番号";
  @override
  String menu_content_2_5_8 = "仕入先備考";
  @override
  String menu_content_2_5_9 = "入荷予定数";
  @override
  String menu_content_2_5_10 = "仕入先明細備考";
  @override
  String menu_content_2_5_11 = "入荷明細";
  @override
  String menu_content_2_5_12 = "入荷行";
  @override
  String menu_content_2_5_13 = "最低でも1つのデータを選択してください";
  @override
  String menu_content_2_5_14 = "入庫中";
  //luxy -end
  @override
  String menu_content_2_6 = "入荷予定データ 取込API";
  @override
  String menu_content_2_7 = "入庫照会";
  @override
  String menu_content_2_8 = "入荷一括検品";
  @override
  String menu_content_2_9 = "入荷予定削除";
  @override
  String menu_content_2_10 = "入庫ラベル";
  @override
  String menu_content_2_11 = "入庫削除";
  @override
  String menu_content_2_12 = "入荷確定";
  @override
  String menu_content_2_13 = "入荷確定取消";
  @override
  String menu_content_2_14 = "入荷確定照会";
  @override
  String menu_content_2_15 = "入荷状況照会 （取引先用）";
  @override
  String menu_content_2_16 = "入荷確定データ 出力";
  @override
  String menu_content_2_17 = "入荷確定データ 出力API";
  @override
  String menu_content_3 = "出荷";
  @override
  String menu_content_3_1 = "出荷指示入力";
  @override
  String menu_content_3_2 = "出荷指示データ 取込CSV";
  @override
  String menu_content_3_3 = "引当処理";
  @override
  String menu_content_3_4 = "引当修正";
  @override
  String menu_content_3_5 = "出荷指示照会";
  @override
  String menu_content_3_6 = "出荷指示データ 取込API";
  @override
  String menu_content_3_7 = "ピッキングリスト （トータル）";
  @override
  String menu_content_3_8 = "ピッキングリスト （シングル）";
  @override
  String menu_content_3_9 = "出荷指示削除";
  @override
  String menu_content_3_10 = "欠品明細照会";
  @override
  String menu_content_3_11 = "欠品伝票照会";
  //luxy start
  @override
  String menu_content_3_11_1 = "引当";
  @override
  String menu_content_3_11_2 = "欠品明細";
  @override
  String menu_content_3_11_3 = "欠品行";
  @override
  String menu_content_3_11_4 = "単価";
  @override
  String menu_content_3_11_5 = "小計";
  @override
  String menu_content_3_11_6 = "出荷指示数";
  @override
  String menu_content_3_11_7 = "出荷日";
  @override
  String menu_content_3_11_8 = "消費期限";
  @override
  String menu_content_3_11_9 = "ロット番号";
  @override
  String menu_content_3_11_10 = "シリアル";
  @override
  String menu_content_3_11_11 = "戻る";
  @override
  String menu_content_3_11_12 = "出荷指示一覧";
  @override
  String menu_content_3_11_13 = "商品一覧";
  @override
  String menu_content_3_11_14 = "商品JANCD";
  //luxy end
  @override
  String menu_content_3_12 = "出庫入力";
  @override
  String menu_content_3_13 = "出荷検品";
  @override
  String menu_content_3_14 = "梱包";
  @override
  String menu_content_3_15 = "出荷ラベル";
  @override
  String menu_content_3_16 = "出庫照会";
  @override
  String menu_content_3_17 = "出荷一括検品";
  @override
  String menu_content_3_18 = "送り状データ取込 CSV";
  @override
  String menu_content_3_19 = "送り状データ出力 CSV";
  @override
  String menu_content_3_20 = "出庫削除";
  @override
  String menu_content_3_21 = "納品書";
  @override
  String menu_content_3_22 = "送り状データ取込 API";
  @override
  String menu_content_3_23 = "送り状データ出力 API";
  @override
  String menu_content_3_24 = "出荷確定照会";
  @override
  String menu_content_3_25 = "出荷確定取消";
  @override
  String menu_content_3_26 = "出荷確定";
  @override
  String menu_content_3_27 = "出荷状況照会 （取引先用）";
  @override
  String menu_content_3_28 = "出荷確定データ出力";
  @override
  String menu_content_3_29 = "出荷確定データ 出力API";
  @override
  String menu_content_4 = "在庫";
  @override
  String menu_content_4_1 = "在庫照会";
  @override
  String menu_content_4_2 = "在庫データ 取込CSV";
  @override
  String menu_content_4_3 = "商品構成指示入力";
  @override
  String menu_content_4_4 = "返品入力";
  @override
  String menu_content_4_5 = "在庫照会 取引先用CSV";
  @override
  String menu_content_4_6 = "在庫データ 取込API";
  @override
  String menu_content_4_7 = "商品構成指示書";
  @override
  String menu_content_4_8 = "返品照会";
  @override
  String menu_content_4_9 = "在庫照会 取引先用API";
  @override
  String menu_content_4_10 = "受払照会";
  //luxy start
  @override
  String menu_content_4_10_1 = "アクション";
  @override
  String menu_content_4_10_2 = "倉庫コード";
  @override
  String menu_content_4_10_3 = "開始日";
  @override
  String menu_content_4_10_4 = "終了日";
  @override
  String menu_content_4_10_5 = "入出荷明細行No";
  @override
  String menu_content_4_10_6 = "入出荷区分";
  @override
  String menu_content_4_10_7 = "入出庫区分";
  @override
  String menu_content_4_10_8 = "社内備考1";
  @override
  String menu_content_4_10_9 = "社内備考2";
  @override
  String menu_content_4_10_10 = "登録時間";
  @override
  String menu_content_4_10_11 = "年月";
  @override
  String menu_content_4_10_12 = ' 入/出庫数';
  //luxy end
  @override
  String menu_content_4_11 = "商品構成完了入力";
  @override
  String menu_content_4_12 = "返品削除";
  // 在庫移動入力 - xcy - 改
  @override
  String menu_content_4_13 = "在庫移動入力";
  // @override
  // String menu_content_4_13 = "在庫移動 （入庫）";
  // @override
  // String menu_content_4_14 = "在庫移動 （出庫）";
  @override
  String menu_content_4_15 = "在庫移動指示書";
  @override
  String menu_content_4_16 = "在庫移動照会";
  @override
  String menu_content_4_17 = "在庫調整入力";
  @override
  String menu_content_4_18 = "在庫調整照会";
  @override
  String menu_content_4_19 = "荷姿変更";
  @override
  String menu_content_4_20 = "荷姿変更照会";
  @override
  String menu_content_5 = "棚卸";
  // xcy - 改  将 "棚卸開始処理" 改为 "棚卸開始"
  @override
  String menu_content_5_1 = "棚卸開始";
  // @override
  // String menu_content_5_1 = "棚卸開始処理";
  @override
  String menu_content_5_2 = "実棚明細入力";
  @override
  String menu_content_5_3 = "棚卸データ出力";
  @override
  String menu_content_5_4 = "棚卸仕分データ 出力CSV";
  @override
  String menu_content_5_5 = "棚卸記入表";
  @override
  String menu_content_5_6 = "棚卸確定取消";
  @override
  String menu_content_5_8 = "棚卸仕分データ 出力API";
  @override
  String menu_content_5_9 = "棚卸照会";
  @override
  String menu_content_5_10 = "実棚明細削除";
  @override
  String menu_content_5_11 = "棚卸確定";
  @override
  String menu_content_6 = "分析";
  @override
  String menu_content_6_1 = "ABC分析";
  @override
  String menu_content_6_2 = "発注点割れ";
  @override
  String menu_content_6_3 = "商品追跡照会";
  @override
  String menu_content_6_4 = "担当者別 ピッキング実績";
  @override
  String menu_content_6_5 = "在庫回転率";
  @override
  String menu_content_6_6 = "出荷状況照会";
  @override
  String menu_content_6_7 = "入荷状況照会";
  @override
  String menu_content_6_8 = "商品別予定推移";
  @override
  String menu_content_6_9 = "棚卸状況照会";
  @override
  String menu_content_6_10 = "欠品";
  @override
  String menu_content_6_11 = "返品";
  @override
  String menu_content_7 = "帳票";
  @override
  String menu_content_7_1 = "商品ラベル";
  @override
  String menu_content_7_2 = "ロケーション ラベル";
  @override
  String menu_content_7_3 = "箱ラベル";
  @override
  String menu_content_8 = "マスタデータ";
  @override
  String menu_content_8_1 = "会社マスタ";
  @override
  String menu_content_8_2 = "告知マスタ";
  @override
  String menu_content_8_3 = "荷主マスタ";
  @override
  String menu_content_8_4 = "商品マスタ";
  @override
  String menu_content_8_5 = "組織マスタ";
  @override
  String menu_content_8_6 = "得意先マスタ";
  @override
  String menu_content_8_7 = "配送業者マスタ";
  @override
  String menu_content_8_8 = "帳票マスタ";
  @override
  String menu_content_8_9 = "従業員マスタ";
  @override
  String menu_content_8_10 = "仕入先マスタ";
  @override
  String menu_content_8_11 = "得意先 商品マスタ";
  @override
  String menu_content_8_12 = "仕入先別 商品マスタ";
  @override
  String menu_content_8_13 = "得意先納入先別 商品単価マスタ";
  @override
  String menu_content_8_14 = "仕入先 商品単価マスタ";
  @override
  String menu_content_8_15 = "商品構成マスタ";
  @override
  String menu_content_8_16 = "ロケーション マスタ";
  @override
  String menu_content_8_17 = "セット出荷マスタ";
  @override
  String menu_content_8_18 = "在庫情報マスタ";
  @override
  String menu_content_8_19 = "倉庫マスタ";
  @override
  String menu_content_8_20 = "商品荷姿マスタ";
  @override
  String menu_content_8_21 = "カレンダーマスタ";
  @override
  String menu_content_8_22 = "ロールマスタ";
  @override
  String menu_content_8_23 = "納入先マスタ";
  @override
  String menu_content_8_24 = "営業日マスタ";
  @override
  String menu_content_9 = "バーコード読み取り";
  @override
  String menu_content_9_s = "商品ポータル";
  @override
  String menu_content_50 = "こっそり隠れる";
  @override
  String menu_content_50_1 = "アカウント";
  @override
  String menu_content_60 = "こっそり隠れる";
  @override
  String menu_content_60_2_5 = "入荷予定照会明細";
  @override
  String menu_content_60_3_11 = "欠品伝票照会明細";
  @override
  String menu_content_60_3_26 = "出荷確定明細";
  @override
  String menu_content_60_3_26_1 = "出荷確定明細一覽";
  // 入荷确定明细 - xcy
  @override
  String menu_content_60_2_12_1 = "入荷確定明細";
  @override
  String display_instruction_receive_detail_status = "入荷確定狀態";
  @override
  String menu_content_60_2_12_1_1 = '入荷予定明細行No';
  // 入荷确定印刷 - xcy
  @override
  String menu_content_60_2_12_2 = "入荷確定印刷";
  // 纳品书明细 - xcy
  @override
  String menu_content_60_3_21 = "納品明細";
  // 棚卸照会明細 - xcy
  @override
  String menu_content_60_5_9 = "棚卸照会明細";
  // 出荷指示照会明细 - xcy
  @override
  String menu_content_60_3_5 = "出荷指示明細";

  // 棚卸確定 - zhangbr
  @override
  String menu_content_60_5_11 = "棚卸確定";
  @override
  String menu_content_98 = "設定";
  @override
  String menu_content_98_1 = "帳票紐付け";
  @override
  String menu_content_98_2 = "帳票編集";
  @override
  String menu_content_98_3 = "マスタ編集";
  @override
  String menu_content_98_4 = "ログイン情報";
  @override
  String menu_content_98_5 = "メニューマスタ";
  @override
  String menu_content_98_6 = "画面編集";
  @override
  String menu_content_98_7 = "リポジトリ";
  @override
  String menu_content_98_8 = "権限マスタ";
  @override
  String menu_content_98_9 = "多言語マスタ";
  @override
  String menu_content_98_10 = "アイコン編集";
  @override
  String menu_content_98_11 = "メッセージマスタ";
  @override
  String menu_content_98_12 = "システムマスタ";
  @override
  String menu_content_98_13 = "汎用詳細 マスタ";
  @override
  String menu_content_98_14 = "汎用分類 マスタ";
  @override
  String menu_content_98_15 = "リストア";
  @override
  String menu_content_98_16 = "データ繰越処理";
  @override
  String menu_content_98_17 = "パスワード変更";
  @override
  String menu_content_98_18 = "バックアップ";
  @override
  String menu_content_98_19 = "採番マスタ";
  @override
  String menu_content_98_20 = "月次締処理";
  @override
  String menu_content_98_21 = "月次評価単価";
  @override
  String menu_content_98_22 = "課金法人管理";
  @override
  String menu_content_98_23 = "ライセンス管理";
  @override
  String menu_content_98_24 = "従業員マスタ";
  @override
  String menu_content_98_25 = "申込受付";
  @override
  String menu_content_98_26 = "解約受付";
  @override
  String menu_content_60_98_25 = "申込明細";
  @override
  String menu_content_99 = "ヘルプ";
  @override
  String menu_content_99_1 = "設定ガイド";
  @override
  String menu_content_99_2 = "基本設定";
  @override
  String menu_content_99_3 = "在庫回転率";
  @override
  String menu_content_99_4 = "言語設定";
  @override
  String menu_content_99_5 = "お支払い";
  @override
  String menu_content_99_6 = "操作ログ";
  // 菜单内容 - 终

  // 纳品书页面内容 xcy - 始
  @override
  String delivery_note_1 = '絞り込み検索';
  @override
  String delivery_note_2 = 'キーワード検索';
  @override
  String delivery_note_3 = '一覧';
  @override
  String delivery_note_4 = '未出力';
  @override
  String delivery_note_5 = '出力済';
  @override
  String delivery_note_6 = '全選択';
  @override
  String delivery_note_7 = '全解除';
  @override
  String delivery_note_8 = '明細';
  @override
  String delivery_note_9 = '印刷';
  @override
  String delivery_note_9_tip = '印刷確認';
  @override
  String delivery_note_9_info = '本当に印刷しますか?';
  @override
  String delivery_note_10 = '削除';
  @override
  String delivery_note_11 = '検索条件';
  @override
  String delivery_note_12 = '出力状態';
  @override
  String delivery_note_13 = '得意先注文番号';
  @override
  String delivery_note_14 = '出荷指示番号';
  @override
  String delivery_note_15 = '得意先';
  @override
  String delivery_note_16 = '出荷指示日';
  @override
  String delivery_note_17 = '纳入先';
  @override
  String delivery_note_18 = '納入日';
  @override
  String delivery_note_19 = '担当者';
  @override
  String delivery_note_20 = '商品名';
  @override
  String delivery_note_21 = 'から';
  @override
  String delivery_note_22 = '全て';
  @override
  String delivery_note_23 = '商品コード';
  @override
  String delivery_note_24 = '検索';
  @override
  String delivery_note_25 = '全ての選択を解除';
  @override
  String delivery_note_26 = '納品明細';
  @override
  String delivery_note_27 = '得意先備考';
  @override
  String delivery_note_28 = '社内備考';
  @override
  String delivery_note_29 = '入金持ちにする';
  @override
  String delivery_note_30 = '引当待ちにする';
  @override
  String delivery_note_31 = '出荷所ちにyる';
  @override
  String delivery_note_32 = '操作';
  @override
  String delivery_note_33 = '編集';
  @override
  String delivery_note_34 = '御中';
  @override
  String delivery_note_35 = '再印刷';
  @override
  String delivery_note_36 = 'これ以上のコンテンツはありませんので、ご確認ください';
  @override
  String delivery_note_37 = 'ステーションタワー12階';
  @override
  String delivery_note_38 = '請求書备号';
  @override
  String delivery_note_39 = '実行日';
  @override
  String delivery_note_40 = '合計金額';
  @override
  String delivery_note_41 = '出荷日';
  @override
  String delivery_note_42 = '合計金額';
  @override
  String delivery_note_43 = '金額';
  @override
  String delivery_note_44 = '数量';
  @override
  String delivery_note_45 = '消费税';
  @override
  String delivery_note_46 = '合計';
  @override
  String delivery_note_delivery_line = "納品行";
  @override
  String delivery_note_delivery_until = "まで";
  // 納品明細一覧
  @override
  String delivery_note_shipment_details_1 = "出荷倉庫";
  @override
  String delivery_note_shipment_details_2 = "商品コード";
  @override
  String delivery_note_shipment_details_3 = "商品名";
  @override
  String delivery_note_shipment_details_4 = "単価";
  @override
  String delivery_note_shipment_details_5 = "出荷指示数";
  @override
  String delivery_note_shipment_details_6 = "規格";
  @override
  String delivery_note_shipment_details_7 = "小計";
  @override
  String delivery_note_shipment_details_8 = "商品合計";
  @override
  String delivery_note_shipment_details_9 = "箱";
  @override
  String delivery_note_shipment_details_10 = "出荷指示明細行No";
  @override
  String delivery_note_shipment_details_11 = "消費期限";
  @override
  String delivery_note_shipment_details_12 = "ロット番号";
  @override
  String delivery_note_shipment_details_13 = "シリアル";
  @override
  String delivery_note_shipment_details_14 = "商品_写真１";
  @override
  String delivery_note_shipment_details_15 = "商品_写真2";
  @override
  String delivery_note_shipment_details_16 = "商品_社内備考１";
  @override
  String delivery_note_shipment_details_17 = "商品_社内備考2";
  @override
  String delivery_note_shipment_details_18 = "商品_注意備考１";
  @override
  String delivery_note_shipment_details_19 = "商品_注意備考2";
  @override
  String delivery_note_close = "閉じる";
  @override
  String delivery_note_reservation_status = '引当状態';
  // 纳品书 xcy - 终

// 出荷指示照会 xcy - 始
  @override
  String display_instruction_ingestion_state = "取込状態";
  @override
  String display_instruction_allowance = "引当待ち";
  @override
  String display_instruction_waiting = "出荷待ち";
  @override
  String display_instruction_work = "出荷作業中";
  @override
  String display_instruction_complete = "出荷済み";
  @override
  String display_instruction_delete = "を削除しますか?";
  @override
  String display_instruction_all_delete = "全て削除しますが、よろしいですか。";
  @override
  String display_instruction_confirm_delete = "削除確認";
  @override
  String display_instruction_shipment_detail = "出荷明細";
  @override
  String display_instruction_detail_line = "明細行";
  @override
  String display_instruction_shipping_status = "出荷状態";
  @override
  String display_instruction_shipping_detail_status = "出荷確定状態";
  // 返回按钮
  @override
  String delivery_note_return = "帰る";
  @override
  String display_instruction_reservation_success = "引当成功しました";
  @override
  String display_instruction_reservation_disappearance =
      "在庫不足引当に失敗しました、詳細は欠品伝票照会画面を参照してください";
  @override
  String display_instruction_tip1 = "引当済みのデータは削除できません";
  @override
  String display_instruction_tip2 = "引当済みのデータは削除できません";
  @override
  String display_instruction_tip3 = "引当済みのデータは追加できません";
  @override
  String display_instruction_tip4 = "引当済みのデータは修正できません";
  @override
  String display_instruction_message1 = "データを1つだけ選択してください";
  @override
  String display_instruction_message2 = "消費期間は得意先の設定時間により超えておりますので、出荷不可です";
  @override
  String display_instruction_message3 = "消費期間は得意先の設定時間により超えております";
  @override
  String display_instruction_button = "引当解除";
  @override
  String display_instruction_reservation_cancel_success = "引当解除しました";
  // 出荷指示照会 xcy - 终

// 出荷检品 xcy - 始
  // 納品書バーコード
  @override
  String shipment_inspection_delivery_note_barcode = "納品書バーコード";
  @override
  String shipment_inspection_ship_no = "出荷指示番号";
  @override
  String shipment_inspection_progress = "進捗";
  @override
  String shipment_inspection_customer = "得意先";
  @override
  String shipment_inspection_delivery = "納入先";
  @override
  String shipment_inspection_inspect = "検品";
  // ロケーション
  @override
  String shipment_inspection_location = "ロケーション";
  // 商品ID
  @override
  String shipment_inspection_product_id = "商品ID";
  // 商品写真
  @override
  String shipment_inspection_product_photos = "商品写真";
  // 出庫数
  @override
  String shipment_inspection_number = "出庫数";
  // 商品ラベルのバーコード
  @override
  String shipment_inspection_product_barcodes = "商品ラベルのバーコード";
  // 合計数
  @override
  String shipment_inspection_sum = "合計数";
  // 検品
  @override
  String shipment_inspection_inspection = "検品";
  // 出荷検品確認
  @override
  String shipment_inspection_confirmation = "出荷検品確認";
  // 出荷検品完了
  @override
  String shipment_inspection_completion_title = "出荷検品完了";
  // 出荷検品弹窗-正しい納入書コードを入力してください
  @override
  String shipment_inspection_toast_1 = "正しい納品書のコードを入力してください";
  // 出荷検品弹窗-数据未到检品阶段
  @override
  String shipment_inspection_toast_2 = "このデータはまだ検品段階ではないため検品できません";
  // 出荷検品弹窗-入力の値が正しくありません
  @override
  String shipment_inspection_toast_3 = "入力の値が正しくありません";
  // 出荷検品弹窗-合計数が正しくありません
  @override
  String shipment_inspection_toast_4 = "合計数が正しくありません";
  // 出荷検品弹窗-該当商品の検品が完了し、自動的に次のアイテムにジャンプする
  @override
  String shipment_inspection_toast_5 = "該当商品の検品が完了し、自動的に次のアイテムにジャンプします";
  // 払出先オリコンのバーコード
  @override
  String shipment_inspection_oricon_barcode = "払出先オリコンのバーコード";
  // 出荷ラベル
  @override
  String shipment_inspection_shipping_label = "出荷ラベル";
  // 完了
  @override
  String shipment_inspection_completion = "完了";
  // 件
  @override
  String shipment_inspection_item = "件";

  @override
  String shipment_inspection_not = "このデータはまだ検品段階になっていません";
  @override
  String shipment_inspection_not_equal = "【合計数】と【出庫済数量】は異なる";
  @override
  String shipment_inspection_is_ok = "検品が完了しました";
  @override
  String shipment_inspection_not_equal_to = "等しくない";

  // 出荷检品 xcy - 终

  // 挑货单页面内容 wgs - 始
  @override
  String pink_list_41 = '戻る';
  @override
  String pink_list_42 = '納品行';
  @override
  String pink_list_43 = 'ピッキングリスト一覧';
  @override
  String pink_list_44 = 'ピッキングリスト明細';
  @override
  String pink_list_45 = 'ピッキングリスト明細一覧';
  @override
  String pink_list_46 = 'ピッキングリスト明細一覧ダイアログ';
  @override
  String pink_list_47 = '出荷指示明細行No';
  @override
  String pink_list_48 = '出荷倉庫';
  @override
  String pink_list_49 = '商品コード';
  @override
  String pink_list_50 = '商品名';
  @override
  String pink_list_51 = '単価';
  @override
  String pink_list_52 = '出荷指示数';
  @override
  String pink_list_53 = '規格';
  @override
  String pink_list_54 = '消費期限';
  @override
  String pink_list_55 = 'ロット番号';
  @override
  String pink_list_56 = 'シリアル';
  @override
  String pink_list_57 = '商品_写真１';
  @override
  String pink_list_58 = '商品_写真2';
  @override
  String pink_list_59 = '商品_社内備考１';
  @override
  String pink_list_60 = '商品_社内備考2';
  @override
  String pink_list_61 = '商品_注意備考１';
  @override
  String pink_list_62 = '商品_注意備考2';
  @override
  String pink_list_63 = 'ピッキング明細行No';
  @override
  String pink_list_64 = '以下';
  // 挑货单页面内容 wgs - 终

  // 出庫照会页面内容 wgs - 始
  @override
  String outbound_notes_1 = '出庫照会一覧';
  @override
  String outbound_notes_2 = '出庫状態';
  @override
  String outbound_notes_3 = '未出庫';
  @override
  String outbound_notes_4 = '出庫中';
  @override
  String outbound_notes_5 = '出庫済み';
  @override
  String outbound_notes_6 = '最低でも1つのデータを選択してください';
  // 消息提示-現在の状態では出庫できません
  @override
  String outbound_notes_toast_1 = '出庫できませんでした';

  // 出庫照会页面内容 wgs - 终

  //出荷确定 cuihr - 始
  @override
  String row_tablebasic_1 = 'コード番号';
  //tab 确定
  @override
  String table_tab_confirm = '確定';
  //tab 取消
  @override
  String table_tab_cancel = '取消';
  //tab 未确定
  @override
  String instruction_input_tab_Undetermined = '未確定';
  //tab 已确定
  @override
  String instruction_input_tab_Determined = '確定済';
  //出荷确定 cuihr - 终

  // 入荷検品 xcy - 始
  // 入荷予定一覧バーコード
  @override
  String incoming_inspection_expected_barcode = "入荷予定一覧バーコード";
  // 入荷予定番号
  @override
  String incoming_inspection_expected_id = "入荷予定番号";
  // 仕入先
  @override
  String incoming_inspection_supplier = "仕入先";
  // 入荷予定明細のバーコード
  @override
  String incoming_inspection_receipt_barcode = "入荷予定明細のバーコード";
  // 入荷予定数
  @override
  String incoming_inspection_expected_number = "入荷予定数";
  // 商品ラベル
  @override
  String incoming_inspection_product_label = "商品ラベル";
  // 入荷検品確認
  @override
  String incoming_inspection_confirmation = "入荷検品確認";
  // 入荷検品完了
  @override
  String incoming_inspection_completion = "入荷検品完了";
  // 全て商品は検品されました。
  @override
  String incoming_inspection_all_product = "全て商品は検品されました";
  @override
  String incoming_inspection_product = '商品';
  @override
  String incoming_inspection_product_inspected = 'は検品されました';
  @override
  String incoming_inspection_amazon_bargaining = '商品ラベル発行';
  @override
  String incoming_inspection_number = '枚数';
  @override
  String incoming_inspection_1 = '正しいバーコードを入力してください';
  @override
  String incoming_inspection_2 = 'データは検品できません';
  @override
  String incoming_inspection_3 = '検品数は正しくありません。ご確認ください';
  @override
  String incoming_inspection_4 = '現在の検品数と入出荷予定数が一致しません、検品を継続しますか';
  @override
  String incoming_inspection_tip_1 = '入荷予定明細バーコードを入力してください';
  @override
  String incoming_inspection_num = '検品数';
  @override
  String incoming_inspection_tip_2 = '正しい検品数を入力してください';
  @override
  String incoming_inspection_tip_3 = '当該商品は検品済みです';
  @override
  String incoming_inspection_tip_4 = '検品可能な商品はありません';
  // 入荷検品 xcy - 终

  // 入荷予定入力页面内容 wgs - 始
  @override
  String reserve_input_1 = '入荷予定入力';
  @override
  String reserve_input_2 = '基本情報';
  @override
  String reserve_input_3 = '入荷商品明細一覧';
  @override
  String reserve_input_4 = '入荷商品明細';
  @override
  String reserve_input_5 = '仕入先コード';
  @override
  String reserve_input_6 = '仕入先名';
  @override
  String reserve_input_7 = '仕入先備考';
  @override
  String reserve_input_8 = '社内備考';
  @override
  String reserve_input_9 = '行番号';
  @override
  String reserve_input_10 = '商品コード';
  @override
  String reserve_input_11 = '商品名';
  @override
  String reserve_input_12 = '単価';
  @override
  String reserve_input_13 = '入荷数量';
  @override
  String reserve_input_14 = '規格';
  @override
  String reserve_input_15 = '明細行を追加';
  @override
  String reserve_input_16 = 'CSV 入荷予定取り込み';
  @override
  String reserve_input_17 = '入荷予定入力明細行';
  @override
  String reserve_input_18 = '明細情報'; //-luxy
  @override
  String reserve_input_19 = '基本情報を入力し[登録]ボタンを押してから明細行を追加します';
  // 入荷予定入力页面内容 wgs - 终

  // 入庫入力 xcy - 始
  @override
  String goods_receipt_input_list_bar_code = "入荷予定一覧バーコード";
  @override
  String goods_receipt_input_incoming_number = "入荷予定番号";
  @override
  String goods_receipt_input_supplier = "仕入先";
  @override
  String goods_receipt_input_button = "入庫";
  @override
  String goods_receipt_input_toast_1 = "正しいバーコードを入力してください";
  @override
  String goods_receipt_input_toast_2 = "現在のデータ状態では入庫できません。再度確認してください";
  @override
  String goods_receipt_input_toast_3 = "入力したバーコードが正しくありません";
  @override
  String goods_receipt_input_toast_4 = "正しい情報を入力してください";
  @override
  String goods_receipt_input_toast_5 = "入庫完了しました";
  @override
  String goods_receipt_input_toast_6 = "削除完了しました";
  @override
  String goods_receipt_input_toast_execute_fail = "実行失敗しました";
  // 入庫数
  @override
  String goods_receipt_input_number = "入庫数";
  // 表格标题 - ID
  @override
  String goods_receipt_input_table_title_1 = "ID";
  // 表格标题 - 商品コード
  @override
  String goods_receipt_input_table_title_2 = "商品コード";
  // 表格标题 - 商品名
  @override
  String goods_receipt_input_table_title_3 = "商品名";
  // 表格标题 - 単価
  @override
  String goods_receipt_input_table_title_4 = "単価";
  // 表格标题 - 入庫数
  @override
  String goods_receipt_input_table_title_5 = "入庫数";
  // 表格标题 - 規格
  @override
  String goods_receipt_input_table_title_6 = "規格";
  // 表格标题 - ロケーションのバーコード
  @override
  String goods_receipt_input_table_title_7 = "ロケーションのバーコード";
  // 表格标题 - 小計
  @override
  String goods_receipt_input_table_title_8 = "小計";
  @override
  String goods_receipt_input_lot_no = "ロット番号";
  @override
  String goods_receipt_input_serial_no = "シリアル番号";
  @override
  String goods_receipt_input_information = "補足情報";
  @override
  String goods_receipt_input_list = "入庫入力一覧";
  @override
  String goods_receipt_input_label_publishing = "ラベル発行";
  @override
  String goods_receipt_input_completed_title_1 = "入庫入力が完了しました";
  @override
  String goods_receipt_input_completed_title_2 = "ラベル発行";
  @override
  String goods_receipt_input_completed_context_1 = "商品";
  @override
  String goods_receipt_input_completed_context_2 = "は入庫入力完了しました。";
  @override
  String goods_receipt_input_completed_Number = "枚数";
  @override
  String goods_receipt_input_tip_1 = "商品情報の取得に失敗します";
  // 入庫入力 xcy - 终

  // 入庫照会页面内容 wgs - 始
  @override
  String Warehouse_query_1 = '入庫照会';
  @override
  String Warehouse_query_2 = '入庫照会一覧';
  @override
  String Warehouse_query_3 = '未入庫';
  @override
  String Warehouse_query_4 = '入庫中';
  @override
  String Warehouse_query_5 = '入庫済み';
  @override
  String Warehouse_Query_Button_1 = "印刷";
  @override
  String Warehouse_Query_Commodity_Search_1 = '入荷予定番号';
  @override
  String Warehouse_Query_Commodity_Search_2 = '入荷予定日';
  @override
  String Warehouse_Query_Commodity_Search_3 = '検索';
  // 入庫照会页面内容 wgs - 终

  // 在庫照会页面内容 wgs - 始
  @override
  String Stock_present_1 = '在庫照会';
  @override
  String Stock_present_2 = 'CSV 在庫データ取込';
  @override
  String Stock_present_3 = '在庫照会一覧';
  @override
  String Stock_present_4 = 'ロケーションid';
  @override
  String Stock_present_5 = '消费期限';
  // 在庫照会页面内容 wgs - 终

  // 入荷确定 xcy - 始
  @override
  String income_confirmation_list = "入荷確定明細行";
  @override
  String income_confirmation_confirmed = "確定済";
  @override
  String income_confirmation_composition = "未確定";
  @override
  String income_confirmation_text_1 = "このデータはキャンセル済みです。再度キャンセルはできません";
  // 入荷确定 xcy - 终
  //入荷确定データ出力 -cuihr 始
  //检索条件-按钮文本
  @override
  String shipment_confirmation_data_query = "検索";
  //检索条件-字段文本
  @override
  String shipment_confirmation_data_query_1 = "入荷予定日";
  // 入荷确定データ出力：TabCSV
  @override
  String shipment_confirmation_data_button_csv = 'CSV';
  // 入荷确定データ出力：表格标题-No.
  @override
  String confirmation_data_table_title_1 = 'NO.';
  //入荷确定データ出力：表格标题-行番号
  @override
  String confirmation_data_table_title_2 = '行番号';
  // 入荷确定データ出力：表格标题-入荷予定番号
  @override
  String confirmation_data_table_title_3 = '入荷予定番号';
  //入荷确定データ出力：表格标题-入荷予定日
  @override
  String confirmation_data_table_title_4 = '入荷予定日';
  //入荷确定データ出力：表格标题-仕入先
  @override
  String confirmation_data_table_title_5 = '仕入先';
  //入荷确定データ出力 -cuihr 终

  // 在庫移動入力 xcy - 始
  @override
  String goods_transfer_entry_location_barcode = "移動元ロケーションのバーコード";
  @override
  String goods_transfer_entry_locke_number = "ロック数";
  @override
  String goods_transfer_entry_stock_count = "在庫数";
  @override
  String goods_transfer_entry_button_move = "移動";
  @override
  String goods_transfer_entry_destination_location_barcode = "移動先ロケーションのバーコード";
  @override
  String goods_transfer_entry_number_of_moves = "移動数";
  @override
  String goods_transfer_entry_reason_for_movement = "移動理由";
  // 在庫移動入力-消息提示：当前输入的ロケーション品物がない
  @override
  String goods_transfer_entry_form_toast_1 = "このロケーションには商品はありません。再度ご確認ください";
  // 在庫移動入力-消息提示：当前输入的ロケーション不正确
  @override
  String goods_transfer_entry_form_toast_2 = "正しいロケーションのバーコードを入力してください";
  // 在庫移動入力-消息提示：不在该ロケーション上
  @override
  String goods_transfer_entry_form_toast_3 = "入力された商品は該当ロケーションに存在しません";
  @override
  String goods_transfer_entry_form_toast_4 = "移動成功しました";
  @override
  String goods_transfer_entry_form_toast_5 = "移動数は在庫数とロック数を超えていますので、移動できません";
  @override
  String goods_transfer_entry_form_toast_6 = "移動数を「1」以上の数字で入力してください";
  // 在庫移動入力 xcy - 终

  // 返品入力页面内容 wgs - 始
  @override
  String Return_product_1 = '売上返品';
  @override
  String Return_product_2 = '仕入返品';
  @override
  String Return_product_3 = '返品完了';
  @override
  String Return_product_4 = '枚数';
  @override
  String Return_product_5 = 'は返品完了しました';
  @override
  String return_product_form_1 = '出荷指示番号';
  @override
  String return_product_form_2 = '入荷予定番号';
  @override
  String return_product_form_3 = '商品名';
  @override
  String return_product_form_4 = '返品数量';
  @override
  String return_product_form_5 = 'ロケーションのバーコード';
  @override
  String return_product_toast_1 = '返品する商品を選び続けてください';
  @override
  String return_product_toast_2 = '正しい出荷指示番号を入力してください';
  @override
  String return_product_toast_3 = '正しい入荷予定番号を入力してください';
  @override
  String return_product_must_enter_toast = 'は入力してください';

  // 返品入力页面内容 wgs - 终

  // 棚卸開始 xcy - 始
  @override
  String start_inventory_list = "ロケーション一覧";
  @override
  String start_inventory_date = "棚卸日";
  @override
  String start_inventory_location_code = "ロケーションコード";
  @override
  String start_inventory_location_floor = "フロア";
  @override
  String start_inventory_location_room = "部屋";
  @override
  String start_inventory_location_zone = "ゾーン";
  @override
  String start_inventory_location_column = "列";
  @override
  String start_inventory_location_shelf = "棚";
  @override
  String start_inventory_location_stage = "段";
  // 棚卸開始 xcy - 终

  // 棚卸照会 - xcy - 始
  @override
  String inventory_query_in_progress = "棚卸中";
  @override
  String inventory_query_confirmed = "棚卸確定";
  @override
  String inventory_query_id = "棚卸ID";
  @override
  String inventory_query_completed_number = "入力完了数";
  @override
  String inventory_query_different_number = "差異数";
  @override
  String inventory_query_progress = "進捗";
  @override
  String inventory_query_quantity = "棚卸数量";
  @override
  String inventory_query_quantity_in_stock = "在庫数量";
  @override
  String inventory_query_variance_quantity = "差異数量";
  @override
  String inventory_query_Inventory_item_id = "棚卸明細ID";
  @override
  String inventory_query_reason = "差異理由";
  @override
  String inventory_query_detail = "詳細";
  @override
  String inventory_query_completion = "完了";
  @override
  String inventory_query_difference = "差異";
  @override
  String inventory_query_detail_list = "実棚明細一覧";
  @override
  String inventory_query_detail_differing = "差異あり";
  @override
  String inventory_query_detail_without = "なし";
  @override
  String inventory_query_detail_incomplete = "未完了";
  @override
  String inventory_query_tip = '確定した/入力されていない棚卸詳細は修正できません';
  @override
  String inventory_query_tip_1 = '確定済みの棚卸、棚卸詳細を削除できません';
  @override
  String inventory_query_tip_2 = '入力されていないデータは消去できません';

  // 棚卸照会 - xcy - 终

  // 在庫移動照会  张博睿 - 始
  @override
  String transfer_inquiry_tab_button_printing = "印刷";
  // 在庫移動照会：Tab一覧
  @override
  String transfer_inquiry_tab_list = "一覧";
  // 在庫移動照会：Tab全選択
  @override
  String transfer_inquiry_tab_button_choice = "全選択";
  // 在庫移動照会：Tab全解除
  @override
  String transfer_inquiry_tab_button_cancellation = "全解除";
  @override
  String transfer_inquiry_note_1 = "検索条件";
  @override
  String transfer_inquiry_note_2 = "商品コード";
  @override
  String transfer_inquiry_note_3 = "商品名";
  @override
  String transfer_inquiry_note_4 = "移動元ロケーション";
  @override
  String transfer_inquiry_note_5 = "移動先ロケーション";
  @override
  String transfer_inquiry_note_6 = "移動日付";
  @override
  String transfer_inquiry_note_7 = "検索";
  @override
  String transfer_inquiry_note_8 = "全ての選択を解除";
  @override
  String transfer_inquiry_note_9 = "絞り込み検索";
  @override
  String transfer_inquiry_table_1 = "ID";
  @override
  String transfer_inquiry_table_2 = "商品コード";
  @override
  String transfer_inquiry_table_3 = "移動元ロケーション";
  @override
  String transfer_inquiry_table_4 = "移動先ロケーション";
  @override
  String transfer_inquiry_table_5 = "商品名";
  @override
  String transfer_inquiry_table_6 = "移動数量";
  @override
  String transfer_inquiry_table_7 = "移動日付";
  @override
  String transfer_inquiry_table_8 = "移動理由";
  // 在庫移動照会  张博睿 - 终

  // 在庫調整照会  张博睿 - 始
  @override
  String adjust_inquiry_tab_button_printing = "CSV";
  // 在庫調整照会：Tab一覧
  @override
  String adjust_inquiry_tab_list = "一覧";
  // 在庫調整照会：Tab全選択
  @override
  String adjust_inquiry_tab_button_choice = "全選択";
  // 在庫調整照会：Tab全解除
  @override
  String adjust_inquiry_tab_button_cancellation = "全解除";
  @override
  String adjust_inquiry_note_1 = "検索条件";
  @override
  String adjust_inquiry_note_2 = "商品コード";
  @override
  String adjust_inquiry_note_3 = "商品名";
  @override
  String adjust_inquiry_note_4 = "ロケーション";
  @override
  String adjust_inquiry_note_5 = "調整日付";
  @override
  String adjust_inquiry_note_6 = "検索";
  @override
  String adjust_inquiry_note_7 = "全ての選択を解除";
  @override
  String adjust_inquiry_note_8 = "絞り込み検索";
  @override
  String adjust_inquiry_table_1 = "ID";
  @override
  String adjust_inquiry_table_2 = "商品コード";
  @override
  String adjust_inquiry_table_3 = "商品名";
  @override
  String adjust_inquiry_table_4 = "ロケーション";
  @override
  String adjust_inquiry_table_5 = "調整前数量";
  @override
  String adjust_inquiry_table_6 = "調整後数量";
  @override
  String adjust_inquiry_table_7 = "調整日付";
  @override
  String adjust_inquiry_table_8 = "調整理由";
  // 在庫移動照会  张博睿 - 终
  // 実棚明細入力页面内容 wgs - 始
  @override
  String Actual_Shelf_1 = '進捗';
  @override
  String Actual_Shelf_2 = 'ロケーションのバーコード';
  @override
  String Actual_Shelf_3 = '商品ラベルのバーコード';
  @override
  String Actual_Shelf_4 = '商品名';
  @override
  String Actual_Shelf_5 = '商品写真';
  @override
  String Actual_Shelf_6 = '消費期限';
  @override
  String Actual_Shelf_7 = 'ロット番号';
  @override
  String Actual_Shelf_8 = 'シリアル';
  @override
  String Actual_Shelf_9 = '補足情報';
  @override
  String Actual_Shelf_10 = '在庫数量';
  @override
  String Actual_Shelf_11 = '棚卸数量';
  @override
  String Actual_Shelf_12 = '差異数量';
  @override
  String Actual_Shelf_13 = '差異理由';
  @override
  String Actual_Shelf_14 = '実棚明細修正';
  @override
  String Actual_Shelf_15 = '商品ラベルのバーコードを入力してください';
  @override
  String Actual_Shelf_16 = '正しいロケーションのバーコードと商品ラベルのバーコードを入力してください';
  @override
  String Actual_Shelf_17 = 'ロケーションのバーコードを入力してください';
  @override
  String Actual_Shelf_18 = '修正完了';
  @override
  String Actual_Shelf_19 = '登録完了';
  @override
  String Actual_Shelf_20 = 'は実棚明細修正完了しました';
  @override
  String Actual_Shelf_21 = 'は実棚明細入力完了しました';
  @override
  String Actual_Shelf_22 = '棚卸詳細データが存在しません';

  // 実棚明細入力页面内容 wgs - 终

  //在库调整入力 cuihr 始
  //按钮 -筛选搜索
  @override
  String outbound_adjust_btn = '絞り込み検索';
  //按钮 -筛选搜索-搜索
  @override
  String outbound_adjust_query_btn_1 = '検索';
  //按钮 -筛选搜索-解除所有搜索选中
  @override
  String outbound_adjust_query_btn_2 = '全ての選択を解除';
  //搜索条件 -商品コード
  @override
  String outbound_adjust_query_id = '商品コード';
  //搜索条件 -商品名
  @override
  String outbound_adjust_query_name = '商品名';
  //搜索条件 -ロケーション（商品位置）
  @override
  String outbound_adjust_query_location = 'ロケーション';
  //按钮 -表格调整
  @override
  String outbound_adjust_table_btn = '調整';
  //文本 -在库调整
  @override
  String outbound_adjust_table_text = '在庫調整';
  @override
  String outbound_adjust_sure_title = '調整確定';
  @override
  String outbound_adjust_sure_content = '在庫数を調整します。よろしいでしょうか';

  //调整 -在庫数
  @override
  String outbound_adjust_table_btn_1 = '在庫数';
  //调整 -ロック数
  @override
  String outbound_adjust_table_btn_2 = 'ロック数';
  //调整 -調整後在庫数
  @override
  String outbound_adjust_table_btn_3 = '調整後在庫数';
  //调整 -調整理由
  @override
  String outbound_adjust_table_btn_4 = '調整理由';
  //表格标题 -no
  @override
  String outbound_adjust_table_title_1 = 'No';
  //表格标题 -ID
  @override
  String outbound_adjust_table_title_2 = 'ID';
  //表格标题 -商品コード
  @override
  String outbound_adjust_table_title_3 = '商品コード';
  //表格标题 -商品名
  @override
  String outbound_adjust_table_title_4 = '商品名';
  //表格标题 -ロケーション(商品位置)
  @override
  String outbound_adjust_table_title_5 = 'ロケーション';
  //表格标题 -在庫数
  @override
  String outbound_adjust_table_title_6 = '在庫数';
  //表格标题 -ロック数
  @override
  String outbound_adjust_table_title_7 = 'ロック数';
  @override
  String outbound_adjust_form_button = '調整';
  // 消息提示 -更新数据失败
  @override
  String outbound_adjust_toast_1 = 'データの更新は失敗しました';
  // 消息提示 -必須入力
  @override
  String outbound_adjust_toast_2 = '在庫数と調整理由を入力してください';
  // 消息提示 -請調整在庫數
  @override
  String outbound_adjust_toast_3 = '調整後の在庫数を現在の在庫数と同じにすることはできません';
  // 消息提示 -調整後在庫数不能小于当前ロック数
  @override
  String outbound_adjust_toast_4 = '調整後の在庫数は現在のロック数より小さくすることはできません';
  // 消息提示 -更新数据成功
  @override
  String outbound_adjust_toast_5 = 'データの更新は成功しました';
  // 消息提示 -必須入力
  @override
  String outbound_adjust_toast_6 = '調整後の在庫数を入力してください';
  // 消息提示 -必須入力
  @override
  String outbound_adjust_toast_7 = '調整理由を入力してください';
  //在库调整入力 cuihr 终

  // 棚卸データ出力页面内容 wgs - 终
  @override
  String inventory_output_1 = '一覧';
  @override
  String inventory_output_2 = '棚卸ID';
  @override
  String inventory_output_3 = '倉庫';
  @override
  String inventory_output_4 = '確定状態';
  @override
  String inventory_output_5 = '連携状態';
  @override
  String inventory_output_6 = '未連携';
  @override
  String inventory_output_7 = '連携済';
  @override
  String inventory_output_8 = 'CSV';
  // 棚卸データ出力页面内容 wgs - 终

  // 棚卸確定 zhangbr - 始
  @override
  String Inventory_Confirmed_Search_1 = "棚卸日";
  @override
  String Inventory_Confirmed_Search_2 = "倉庫";
  @override
  String Inventory_Confirmed_Search_3 = "検索";
  @override
  String Inventory_Confirmed_Table_1 = "No.";
  @override
  String Inventory_Confirmed_Table_2 = "倉庫";
  @override
  String Inventory_Confirmed_Table_3 = "棚卸日";
  @override
  String Inventory_Confirmed_Table_4 = "状態";
  @override
  String Inventory_Confirmed_Table_Tab_1 = "一覧";
  @override
  String Inventory_Confirmed_Table_Tab_2 = "未確定";
  @override
  String Inventory_Confirmed_Table_Tab_3 = "確定済";
  @override
  String Inventory_Confirmed_Table_Buttton_1 = "全選択";
  @override
  String Inventory_Confirmed_Table_Buttton_2 = "全解除";
  @override
  String Inventory_Confirmed_Table_Buttton_3 = "確定";
  @override
  String Inventory_Confirmed_Table_Buttton_4 = "キャンセル";
  @override
  String Inventory_Confirmed_tip_1 = '少なくとも 1 つのデータを選択してください';
  @override
  String Inventory_Confirmed_tip_2 = 'ステータスが正しくないため、確認できません';
  @override
  String Inventory_Confirmed_tip_3 = '未処理の在庫データがある為、確認できません';
  @override
  String Inventory_Confirmed_tip_4 = '操作が成功したことを確認する';
  @override
  String Inventory_Confirmed_tip_5 = 'キャンセルするデータを選択してください';
  @override
  String Inventory_Confirmed_tip_6 = '現在の倉庫に未確認のデータがあるため、キャンセル操作を実行できません';
  @override
  String Inventory_Confirmed_tip_7 = '現在選択されているデータは最新のデータではありません';
  @override
  String Inventory_Confirmed_tip_8 = 'キャンセル操作は成功しました';
  @override
  String Inventory_Confirmed_tip_9 = '操作の決定に失敗しました';
  @override
  String Inventory_Confirmed_tip_10 = 'キャンセル操作に失敗しました';
  @override
  String Inventory_Confirmed_tip_11 = '確認操作は成功しました';
  @override
  String Inventory_Confirmed_tip_12 = 'このデータに関する詳細情報は見つかりませんでした。ご確認ください';
  @override
  String Inventory_Confirmed_tip_13 = '既に確定済です';

  // 棚卸確定 zhangbr - 终

  // 商品マスタ管理  xcy - 终
  @override
  String product_master_management_product_abbreviation = "商品略称";
  @override
  String product_master_management_junk = "JANCD";
  @override
  String product_master_management_major_categories = "大分類";
  @override
  String product_master_management_medium_classification = "中分類";
  @override
  String product_master_management_subclassification = "小分類";
  @override
  String product_master_management_quantity = "入数";
  @override
  String product_master_management_photo_1 = "写真 1";
  @override
  String product_master_management_photo_2 = "写真 2";
  @override
  String product_master_management_view = "查看";
  @override
  String product_master_management_tableName = "商品";
  @override
  String product_master_management_product_code_notRepeat =
      "入力された商品コードはすでに存在しますので、再度入力できません";
  @override
  String product_master_management_product_jan_cd_notRepeat =
      "入力されたJANCDはすでに存在しますので、再度入力できません";
  @override
  String product_master_csv_import = "CSV 商品データ取込";
  // 商品マスタ管理  xcy - 终

  // 納入先マスタ管理 zhangbr - 始
  // 納入先マスタ画面-Form表单-納入先ID
  String delivery_form_id = "納入先ID";
  // 納入先マスタ画面-Form表单-名称
  String delivery_form_name = "名称";
  // 納入先マスタ画面-Form表单-カナ名称
  String delivery_form_canaName = "カナ名称";
  // 納入先マスタ画面-Form表单-略称
  String delivery_form_abbreviation = "略称";
  // 納入先マスタ画面-Form表单-郵便番号
  String delivery_form_zipCode = "郵便番号";
  // 納入先マスタ画面-Form表单-都道府県
  String delivery_form_prefecture = "都道府県";
  // 納入先マスタ画面-Form表单-市区町村
  String delivery_form_municipal = "市区町村";
  // 納入先マスタ画面-Form表单-住所
  String delivery_form_address = "住所";
  // 納入先マスタ画面-Form表单-電話番号
  String delivery_form_tel = "電話番号";
  // 納入先マスタ画面-Form表单-FAX番号
  String delivery_form_fax = "FAX番号";
  // 納入先マスタ画面-Form表单-担当者名
  String delivery_form_chargePerson = "担当者名";
  // 納入先マスタ画面-Form表单-社内備考1
  String delivery_form_company_notes1 = "社内備考1";
  // 納入先マスタ画面-Form表单-社内備考2
  String delivery_form_company_notes2 = "社内備考2";
  // 納入先マスタ画面-Form表单-会社
  String delivery_form_company = "会社名";
  // 納入先マスタ画面-检索条件按钮
  String delivery_search_conditions_button = "絞り込み検索";
  // 納入先マスタ画面-检索按钮
  String delivery_search_button = "検索";
  // 納入先マスタ画面-移除检索条件按钮
  String delivery_search_remove_button = "全ての選択を解除";
  // 納入先マスタ画面-检索条件整合内容
  String delivery_search_conditions = "検索条件";
  // 納入先マスタ画面-检索条件-納入先ID
  String delivery_search_id = "納入先ID";
  // 納入先マスタ画面-检索条件-名称
  String delivery_search_name = "名称";
  // 納入先マスタ画面-检索条件-略称
  String delivery_search_abbreviation = "略称";
  // 納入先マスタ画面-检索条件-担当者名
  String delivery_search_chargePerson = "担当者名";
  // 納入先マスタ画面-检索条件-会社名
  String delivery_search_company = "会社名";
  // 納入先マスタ画面-table表格-納入先ID
  String delivery_table_id = "納入先ID";
  // 納入先マスタ画面-table表格-名称
  String delivery_table_name = "名称";
  // 納入先マスタ画面-table表格-カナ名称
  String delivery_table_canaName = "カナ名称";
  // 納入先マスタ画面-table表格-略称
  String delivery_table_abbreviation = "略称";
  // 納入先マスタ画面-table表格-郵便番号
  String delivery_table_zipCode = "郵便番号";
  // 納入先マスタ画面-table表格-都道府県
  String delivery_table_prefecture = "都道府県";
  // 納入先マスタ画面-table表格-市区町村
  String delivery_table_municipal = "市区町村";
  // 納入先マスタ画面-table表格-住所
  String delivery_table_address = "住所";
  // 納入先マスタ画面-table表格-電話番号
  String delivery_table_tel = "電話番号";
  // 納入先マスタ画面-table表格-FAX番号
  String delivery_table_fax = "FAX番号";
  // 納入先マスタ画面-table表格-担当者名
  String delivery_table_chargePerson = "担当者名";
  // 納入先マスタ管理 zhangbr - 终

  // 返品照会 wanggs - 始
  @override
  String returns_note_1 = "返品区分";
  @override
  String returns_note_2 = "入荷予定番号/出荷指示番号";
  @override
  String returns_note_3 = "返品照会一覧";
  @override
  String returns_note_id = 'Return ID';
  // 返品照会 wanggs - 终

  // メニューマスタ管理 xcy - 始
  @override
  String menu_master = "メニュー";
  @override
  String menu_master_form_1 = "メニューID";
  @override
  String menu_master_form_2 = "親メニュー";
  @override
  String menu_master_form_3 = "メニュー名称";
  @override
  String menu_master_form_4 = "メニュー説明";
  @override
  String menu_master_form_5 = "メニューパス";
  @override
  String menu_check_exists = "関連テーブル（権限マスタ）にはデータが存在しますので、削除できません";
  // メニューマスタ管理 xcy - 终

  // 設定----------------------------------------------
  // 権限マスタ zhangbr - 始
  // 権限マスタ-Form表单 - 権限ID
  @override
  String auth_Form_1 = "権限ID";
  // 権限マスタ-Form表单 - ロール名称
  @override
  String auth_Form_2 = "ロール名称";
  // 権限マスタ-Form表单 - ロール名称
  @override
  String auth_Form_2_check = "現在入力されているロール名とメニュー名の組み合わせはすでに存在します!";
  // 権限マスタ-Form表单 - メニュー名称
  @override
  String auth_Form_3 = "メニュー名称";
  // 権限マスタ-Form表单 - 権限
  @override
  String auth_Form_4 = "権限";
  // 権限マスタ-Form表单 - 権限check
  @override
  String auth_Form_4_check = "大文字で入力してください";
  // 権限マスタ-search - 権限ID
  @override
  String auth_Search_1 = "権限ID";
  // 権限マスタ-search - ロール名称
  @override
  String auth_Search_2 = "ロール名称";
  // 権限マスタ-search - メニュー名称
  @override
  String auth_Search_3 = "メニュー名称";
  // 権限マスタ-search - 権限
  @override
  String auth_Search_4 = "権限";
  // 権限マスタ-table - 権限ID
  @override
  String auth_Table_1 = "権限ID";
  // 権限マスタ-table - ロール名称
  @override
  String auth_Table_2 = "ロール名称";
  // 権限マスタ-table - メニュー名称
  @override
  String auth_Table_3 = "メニュー名称";
  // 権限マスタ-table - 権限
  @override
  String auth_Table_4 = "権限";
  // 権限マスタ zhangbr - 终

  //会社マスタ wanggs - 始
  @override
  String company_information_1 = "会社ID";
  @override
  String company_information_2 = "会社名";
  @override
  String company_information_3 = "略称";
  @override
  String company_information_4 = "法人番号";
  @override
  String company_information_5 = "適格請求登録番号";
  @override
  String company_information_6 = "郵便番号";
  @override
  String company_information_7 = "都道府県";
  @override
  String company_information_8 = "市区町村";
  @override
  String company_information_9 = "住所";
  @override
  String company_information_10 = "電話番号";
  @override
  String company_information_11 = "FAX番号";
  @override
  String company_information_12 = "Webサイト";
  @override
  String company_information_13 = "E-MAIL";
  @override
  String company_information_14 = "状態";
  @override
  String company_information_15 = "強制出荷";
  @override
  String company_information_16 = "発注点";
  @override
  String company_information_17 = "会社明細一覧";
  @override
  String company_information_18 = "查看";
  @override
  String company_check_1 = "は1～4桁のアルファベット大文字で入力してください";
  @override
  String company_check_2 = "は13桁の半角数字で入力してください";
  @override
  String company_check_3 = "は6桁の半角数字で入力してください";
  //会社マスタ wanggs - 终

  // メッセージマスタ xiongcy - 始
  @override
  String message_master_1 = "タイトル";
  @override
  String message_master_2 = "メッセージ";
  @override
  String message_master_3 = "通信完了区分";
  @override
  String message_master_4 = "ユーザーID";
  @override
  String message_master_5 = "ユーザー名称";
  @override
  String message_master_6 = "送信されたメッセージは変更できません";
  @override
  String message_master_7 = "送信されたメッセージは再送信できません";
  @override
  String message_master_sendMail = '送信確認';
  // メッセージマスタ xiongcy - 终
  // メッセージタイトル
  @override
  String message_title = 'メッセージタイトル';
  // メッセージの内容
  @override
  String message_content = 'メッセージの内容';
  // は30文字以内
  @override
  String message_cannot_exceed_30_characters = 'は30文字以内';
  // 許可確認
  @override
  String message_button_1_1 = '許可確認';
  // リンクを共有してアカウント開設をお願いする
  @override
  String message_button_1_2 = 'リンクを共有してアカウント開設をお願いする';
  // お客様用のログインURLをコピー
  @override
  String message_button_1_3 = 'お客様用のログインURLをコピー';
  // 解約確認
  @override
  String message_button_2_1 = '解約確認';
  // リンクを共有して解約をお願いする
  @override
  String message_button_2_2 = 'リンクを共有して解約をお願いする';
  // 解約URLをコピー
  @override
  String message_button_2_3 = '解約URLをコピー';
  //得意先マスタ wanggs - 始
  @override
  String customer_master_1 = "得意先ID";
  @override
  String customer_master_2 = "名称";
  @override
  String customer_master_3 = "カナ名称";
  @override
  String customer_master_4 = "略称";
  @override
  String customer_master_5 = "郵便番号";
  @override
  String customer_master_6 = "都道府県";
  @override
  String customer_master_7 = "市区町村";
  @override
  String customer_master_8 = "住所";
  @override
  String customer_master_9 = "電話番号";
  @override
  String customer_master_10 = "FAX番号";
  @override
  String customer_master_11 = "代表者名";
  @override
  String customer_master_12 = "担当者名";
  @override
  String customer_master_13 = "担当者-電話番号";
  @override
  String customer_master_14 = "担当者-FAX番号";
  @override
  String customer_master_15 = "担当者-EMAIL";
  @override
  String customer_master_16 = "社内備考1";
  @override
  String customer_master_17 = "社内備考2";
  @override
  String customer_master_18 = "会社";
  @override
  String customer_master_19 = "一覧";
  @override
  String customer_master_20 = "法人番号";
  @override
  String customer_master_21 = "大分類";
  @override
  String customer_master_22 = "中分類";
  @override
  String customer_master_23 = "小分類";
  @override
  String customer_master_24 = "国";
  @override
  String customer_master_25 = "地域";
  @override
  String customer_master_26 = "住所詳細2";
  @override
  String customer_master_27 = "適用開始日";
  @override
  String customer_master_28 = "適用終了日";
  @override
  String customer_master_29 = "住所詳細1";
  @override
  String customer_master_30 = "適用開始日は適用終了日より前にしなければならない";
  @override
  String customer_master_31 = "消費期限";
  @override
  String customer_master_32 = "消費期限制御";
  @override
  String customer_master_day = "日";
  //得意先マスタ wanggs - 终

  //運用基本情報管理 wanggs - 始
  @override
  String information_management_1 = "自動応答用メール";
  String information_management_2 = "営業時間";
  String information_management_3 = "無料時間";
  //運用基本情報管理 wanggs - 终

  //ロールマスタ管理 -cuihr 始
  //ロール
  @override
  String role_basic = "ロール";
  //基本情报 -id
  @override
  String role_basic_id = "ロールID";
  //基本情报 -名称
  @override
  String role_basic_name = "ロール名称";
  //基本情报 -说明
  @override
  String role_basic_explain = "ロール説明";

  //检索条件 -id
  @override
  String role_search_id = "ロールID";
  //检索条件 -名称
  @override
  String role_search_name = "ロール名称";
  //检索条件 -说明
  @override
  String role_search_explain = "ロール説明";

  //明细一览 -id
  @override
  String role_overview_id = "ロールID";
  //明细一览 -名称
  @override
  String role_overview_name = "ロール名称";
  //明细一览 -说明
  @override
  String role_overview_explain = "ロール説明";
  //删除存在check文言（ytb_use_type(ライセンス・課金管理)）
  @override
  String role_check_exists_1 = "関連テーブル（ライセンス・課金管理）にはデータが存在しますので、削除できません";
  //删除存在check文言（mtb_authority(権限マスタ)）
  @override
  String role_check_exists_2 = "関連テーブル（権限マスタ）にはデータが存在しますので、削除できません";
  //删除存在check文言（mtb_user(ユーザーマスタ)）
  @override
  String role_check_exists_3 = "関連テーブル（ユーザーマスタ）にはデータが存在しますので、削除できません";

  //ロールマスタ管理 -cuihr 终

  //倉庫マスタ wanggs - 始
  @override
  String warehouse_master_1 = "倉庫ID";
  @override
  String warehouse_master_2 = "倉庫CD";
  @override
  String warehouse_master_3 = "倉庫名称";
  @override
  String warehouse_master_4 = "倉庫区分";
  @override
  String warehouse_master_5 = "エリア";
  @override
  String warehouse_master_6 = "倉庫明細一覧";
  @override
  String warehouse_master_7 = "倉庫略称";

  //倉庫マスタ wanggs - 终

  // ロケーションマスタ  xiongcy - 始
  @override
  String location_master_1 = "倉庫名";
  @override
  String location_master_2 = "区分";
  @override
  String location_master_3 = "間口";
  @override
  String location_master_4 = "保管容量";
  @override
  String location_master_5 = "エリア";
  @override
  String location_master_locCode_check = "ロケーションコードは重複できません。再度入力してください";
  // ロケーションマスタ  xiongcy - 终

  //仕入先マスタ管理 -cuihr 始
  @override
  String supplier_basic_id = "仕入先ID";
  @override
  String supplier_basic_name = "名称";
  @override
  String supplier_basic_kana = "カナ名称";
  @override
  String supplier_basic_abbreviation = "略称";
  @override
  String supplier_basic_zip_code = "郵便番号";
  @override
  String supplier_basic_province = "都道府県";
  @override
  String supplier_basic_villages = "市区町村";
  @override
  String supplier_basic_address = "住所";
  @override
  String supplier_basic_telephone_number = "電話番号";
  @override
  String supplier_basic_fax_number = "FAX番号";
  @override
  String supplier_basic_representative_name = "代表者名";
  @override
  String supplier_basic_contact_name = "担当者名";
  @override
  String supplier_basic_contact_telephone_number = "担当者-電話番号";
  @override
  String supplier_basic_contact_fax_number = "担当者-FAX番号";
  @override
  String supplier_basic_contact_email = "担当者-EMAIL";
  @override
  String supplier_basic_internal_remarks_1 = "社内備考1";
  @override
  String supplier_basic_internal_remarks_2 = "社内備考2";
  @override
  String supplier_basic_company = "会社";
  @override
  String supplier_search_id = "仕入先ID";
  @override
  String supplier_search_name = "名称";
  @override
  String supplier_search_representative_name = "代表者名";
  @override
  String supplier_search_contact_name = "担当者名";
  @override
  String supplier_id = "仕入先ID";
  @override
  String supplier_name = "名称";
  @override
  String supplier_kana = "カナ名称";
  @override
  String supplier_abbreviation = "略称";
  @override
  String supplie_zip_code = "郵便番号";
  @override
  String supplier_province = "都道府県";
  @override
  String supplier_villages = "市区町村";
  @override
  String supplier_address = "住所";
  @override
  String supplier_telephone_number = "電話番号";
  @override
  String supplier_fax_number = "FAX番号";
  @override
  String supplier_representative_name = "代表者名";
  @override
  String supplier_contact_name = "担当者名";
  @override
  String supplier_contact_telephone_number = "担当者-電話番号";
  @override
  String supplier_contact_fax_number = "担当者-FAX番号";
  @override
  String supplier_contact_email = "担当者-EMAIL";
  //仕入先マスタ管理 -cuihr 终

  // 账户 - 赵士淞 始
  // 用户状態 - 本会員
  @override
  String user_status_text_1 = '本会員';
  // 用户状態 - 仮会員
  @override
  String user_status_text_2 = '仮会員';
  // 用户状態 - 退会
  @override
  String user_status_text_3 = '退会';

  // 支払状態 - 未支払
  @override
  String manage_pay_status_text_1 = '未支払';
  // 支払状態 - 支払済み
  @override
  String manage_pay_status_text_2 = '支払済み';

  // 密码发生变更，请重新登录！
  @override
  String password_changed_log_again = 'パスワードが変更されました。再ログインしてください';

  // 入荷指示照会 - 入荷状態
  @override
  String inquiry_schedule_table_title_5 = '入荷状態';

  // 入荷状態 - 検品待ち
  @override
  String receive_kbn_text_1 = '検品待ち';
  // 入荷状態 - 入庫待ち
  @override
  String receive_kbn_text_2 = '入庫待ち';
  // 入荷状態 - 入庫中
  @override
  String receive_kbn_text_3 = '入庫中';
  // 入荷状態 - 入荷確定待ち
  @override
  String receive_kbn_text_4 = '入荷確定待ち';
  // 入荷状態 - 入荷済み
  @override
  String receive_kbn_text_5 = '入荷済み';

  // 取込状態 - 導入された商品IDは存在しません
  @override
  String importerror_flg_text_1 = 'インポートされた商品IDは存在しません。インポート失敗しました';
  // 取込状態 - インポート時にエラーが発生しました
  @override
  String importerror_flg_text_2 = 'インポート時にエラーが発生しました。詳しくはログファイルをご参照ください';
  // 取込状態 - マスターテーブルのインポート中にエラーが発生しました
  @override
  String importerror_flg_text_3 = 'マスターテーブルのインポート中にエラーが発生しました';
  // 取込状態 - サブテーブルのインポート中にエラーが発生しました
  @override
  String importerror_flg_text_4 = 'サブテーブルのインポート中にエラーが発生しました';
  // 取込状態 - インポートされたフィールドの数またはタイプが一致しません
  @override
  String importerror_flg_text_5 = 'インポートされたフィールドの数またはタイプが一致しません。ご確認ください';

  // 取込状態 - エラーあり
  @override
  String importerror_flg_query_1 = 'エラーあり';
  // 取込状態 - エラーなし
  @override
  String importerror_flg_query_2 = 'エラーなし';

  // 入荷指示照会明细 - 入荷予定明細行No
  @override
  String inquiry_schedule_details_row_no = '入荷予定明細行No';

  // 在庫照会 - 前月残
  @override
  String inventory_inquiry_last_month = '前月残';
  // 在庫照会 - 調整数
  @override
  String inventory_inquiry_adjustment_number = '調整数';
  // 在庫照会 - 棚卸数
  @override
  String inventory_inquiry_inventory = '棚卸数';
  // 在庫照会 - 入庫移動数
  @override
  String inventory_inquiry_entry_number = '入庫移動数';
  // 在庫照会 - 出庫移動数
  @override
  String inventory_inquiry_exit_number = '出庫移動数';
  // 在庫照会 - 場所明細
  @override
  String inventory_inquiry_location_details = '場所明細';
  // 在庫照会 - 在庫id
  @override
  String inventory_inquiry_stock_id = '在庫id';
  // 在庫照会 - 返品数
  @override
  String inventory_inquiry_return_stock = '返品数';
  // 账户 - 赵士淞 终
  @override
  String ship_csv_submit = '現在出荷データが連携中です。出荷確認をキャンセルしますか';
  @override
  String ship_kbn_no_cancel = '出荷処理が正常に完了していないため、キャンセルに失敗しました';
  @override
  String ship_kbn_cancel = 'キャンセルに失敗した';
  @override
  String ship_kbn_cancel_success = 'キャンセルに成功した';
  @override
  String ship_confirm_error = '既に確定済です';
  @override
  String ship_prompt_error = '未確定データが残っているため、確認処理は失敗しました';
  @override
  String ship_prompt_error_2 = '入荷済み以外のデータが含まれています。';
  @override
  String ship_cancel_error = '現在選択されている出荷データは連携済みのデータです、出荷確認をキャンセルしますか';
  @override
  String income_cancel_error = '現在選択されている入荷データは連携済みのデータです、入荷確定待ちの状態に戻しますか。';
  @override
  String income_cancel_error_2 = '現在選択されている入荷データは入荷確認済みのデータです、入荷確定待ちの状態に戻しますか。';
  @override
  String shipdetail_cancel_error = 'キャンセル済みのデータなので、キャンセルできません';
  @override
  String warehousing_status = '入庫状態';
  @override
  String receive_status = '入荷状態';
  @override
  String receive_status_no = '入荷処理が正常に完了していないため、キャンセルに失敗しました';
  @override
  String display_message_Confim = 'メッセージを送信してもよろしいですか';

  // 出荷指示照会
  // 出荷状態 - 引当失敗
  @override
  String ship_kbn_text_1 = '引当失敗';
  // 出荷状態 - 引当待ち
  @override
  String ship_kbn_text_2 = '引当待ち';
  // 出荷状態 - 出庫待ち
  @override
  String ship_kbn_text_3 = '出庫待ち';
  // 出荷状態 - 出庫中
  @override
  String ship_kbn_text_4 = '出庫中';
  // 出荷状態 - 検品待ち
  @override
  String ship_kbn_text_5 = '検品待ち';
  // 出荷状態 - 梱包待ち
  @override
  String ship_kbn_text_6 = '梱包待ち';
  // 出荷状態 - 出荷確定待ち
  @override
  String ship_kbn_text_7 = '出荷確定待ち';
  // 出荷状態 - 出荷済み
  @override
  String ship_kbn_text_8 = '出荷済み';

  // 棚卸开始 - 赵士淞 始
  @override
  String start_inventory_text_1 = '未確定の棚卸日が存在するため、登録に失敗しました';
  @override
  String start_inventory_text_2 = '現在の棚卸日に対応する倉庫の棚卸が完了しているので、入力内容を確認してください';
  @override
  String start_inventory_text_3 = '入力したデータをクリアします。よろしいでしょうか';
  @override
  String start_inventory_text_4 = '入力必須のデータを入力してください';
  @override
  String start_inventory_text_5 = '選択したロケーションの商品在庫はありません。ご確認ください';
  @override
  String inventory_confirmed_text_1 = '現在のシステム実在庫数<在庫ロック数、ご確認ください';
  @override
  String inventory_query_search_text_1 = '差異ステータス';
  @override
  String inventory_query_search_text_2 = '完了ステータス';
  // 棚卸开始 - 赵士淞 终

  // 引当状态
  // 引当待ち
  @override
  String lock_kbn_text_0 = '引当待ち';
  // 引当済
  @override
  String lock_kbn_text_1 = '引当済';
  // 引当不足
  @override
  String lock_kbn_text_2 = '引当不足';

  // 現在の状態は削除できません
  @override
  String this_status_cannot_delete = '現在の状態は削除できません';
  // 現在の状態を変更できません
  @override
  String this_status_cannot_edit = '現在の状態を変更できません';

  // 操作ログ -start
  @override
  String menu_content_99_6_1 = '操作内容';
  @override
  String menu_content_99_6_2 = 'ログレベル';
  @override
  String menu_content_99_6_3 = '方法';
  @override
  String menu_content_99_6_4 = '異常詳細';
  @override
  String menu_content_99_6_5 = 'リクエスト';
  @override
  String menu_content_99_6_6 = '操作日時';
  @override
  String menu_content_99_6_7 = '操作者';
  // 操作ログ -end

  //配送業者マスタ start
  @override
  String operator_text_1 = '運送会社ID';
  @override
  String operator_text_2 = '運送会社名称';
  @override
  String operator_text_3 = '適用開始日';
  @override
  String operator_text_4 = '適用終了日';
  @override
  String operator_text_5 = '「適用開始日」は「適用終了日」より後にすることはできません';
  //配送業者マスタ end

  // 組織マスタ - 熊草云 始
  @override
  String organization_master_form_1 = '親ID';
  @override
  String organization_master_form_2 = '組織コード';
  @override
  String organization_master_form_3 = '組織名';
  @override
  String organization_master_form_4 = '説明';
  @override
  String organization_master_form_5 = '会社名';
  @override
  String organization_master_tip_1 = 'の選択ミスです';
  @override
  String organization_master_tip_2 = '自分の親IDとして自分を選ぶことはできません';
  @override
  String organization_master_tip_3 = '選択した親IDが自分の子IDではありません';
  @override
  String organization_master_tip_4 = 'このデータには親IDがありますので、社名の変更はできません';
  @override
  String organization_master_tip_5 = '正しい社名を入力してください';
  @override
  String organization_master_tip_6 = 'このデータは他のデータの親データなので、変更できません';
  @override
  String organization_master_tip_7 = 'このデータは他のデータの親なので削除できません';
  @override
  String organization_master_tip_8 = '組織コードは既に存在します';
  @override
  String organization_master_tip_9 = '組織階級はせいぜい3層である';
  // 組織マスタ - 熊草云 终

  // カレンダーマスタ - 赵士淞 始
  // 営業ID
  @override
  String mtb_calendar_text_1 = '営業ID';
  // 営業日
  @override
  String mtb_calendar_text_2 = '営業日';
  // 営業種類
  @override
  String mtb_calendar_text_3 = '営業種類';
  // 営業種類-自社休日
  @override
  String mtb_calendar_text_3_1 = '自社休日';
  // 営業種類-納入先休日
  @override
  String mtb_calendar_text_3_2 = '納入先休日';
  // 営業種類-仕入先休日
  @override
  String mtb_calendar_text_3_3 = '仕入先休日';
  // 営業備考
  @override
  String mtb_calendar_text_4 = '営業備考';
  // カレンダーマスタ - 赵士淞 终

  // 荷主マスタ -start
  @override
  String shipping_master_form_1 = '荷主ID';
  @override
  String shipping_master_form_2 = '荷主名称';
  @override
  String shipping_master_form_3 = 'カナ名称';
  @override
  String shipping_master_form_4 = '略称';
  @override
  String shipping_master_form_5 = '郵便番号';
  @override
  String shipping_master_form_6 = '都道府県';
  @override
  String shipping_master_form_7 = '市区町村';
  @override
  String shipping_master_form_8 = '住所';
  @override
  String shipping_master_form_9 = '電話番号';
  @override
  String shipping_master_form_10 = 'FAX番号';
  @override
  String shipping_master_form_11 = '代表者名';
  @override
  String shipping_master_form_12 = '担当者名';
  @override
  String shipping_master_form_13 = '担当者電話番号';
  @override
  String shipping_master_form_14 = '担当者FAX番号';
  @override
  String shipping_master_form_15 = '担当者EMAIL';
  @override
  String shipping_master_form_16 = '適用開始日';
  @override
  String shipping_master_form_17 = '適用終了日';
  // 荷主マスタ -end

  // 課金法人管理 - 熊草云 始
  @override
  String charge_management_form_1 = '管理員';
  @override
  String charge_management_form_2 = '備考';
  @override
  String charge_management_tip_1 = '正しい管理者を選んでください';
  @override
  String charge_management_tip_2 =
      '同社は現在、管理者リストを設定していないため、管理者を選択することはできません。適当な社名をお願いします';
  // 課金法人管理  - 熊草云 终

  // ライセンス管理 -start
  @override
  String license_management_1 = 'サポート内容';
  @override
  String license_management_2 = '有効期間(年)';
  @override
  String license_management_3 = '有効期間(月)';
  @override
  String license_management_4 = '有効期間(日)';
  @override
  String license_management_5 = '入力する必要があります';
  @override
  String license_management_6 = '開始日は終了日より後にすることはできません';
  // ライセンス管理 -end

  //サービス解約 -start
  @override
  String contract_cancel_1 = '解約';
  @override
  String contract_cancel_2 = '解約申請を送信しますが、よろしいでしょうか';
  @override
  String contract_text_1 = 'サービス解約';
  @override
  String contract_text_2 = '次へ';
  @override
  String contract_text_3 = '会社名名称';
  @override
  String contract_text_4 = '会社名略称';
  @override
  String contract_text_5 = '会社情報';
  @override
  String contract_text_6 = '解約確認';
  @override
  String contract_text_7 =
      'ライセンス期間内は利用可能です、ライセンス期間の終了をもって貴社の環境をすべて削除致します。ご承知おきください';
  @override
  String contract_text_8 = '上記すべてに同意し、解約を確定します。';
  @override
  String contract_text_9 = '解約する';

  @override
  String contract_text_10 = '情報をお読みいただいた後、同意の意思表示としてチェックボックスにチェックを入れてください。';

  @override
  String contract_text_11 = 'ご利用いただきましてありがとうございました。';

  //サービス解約 -end

  // Stripe - start
  // 支払い開始に失敗しました
  @override
  String payment_initiation_failed = '支払いは開始できませんでした';
  // ジャンプ支払いに失敗しました
  @override
  String transfer_payment_failed = '支払いページのジャンプに失敗しました';
  // 支払ステータスの更新に失敗しました
  @override
  String payment_status_update_failed = '支払ステータスの更新に失敗しました';
  // おめでとう、支払い成功！
  @override
  String congratulations_payment_successful =
      '支払処理は成功しました。POTTZの利用開始を楽しみにお待ちください';
  // Stripe - end

  //申込 -cuihr start
  // luxy start
  @override
  String register_header_text_1 = '事業内容';
  @override
  String register_header_text_2 = 'BXについて';
  @override
  String register_header_text_3 = '会社概要';
  @override
  String register_header_text_4 = 'お問い合わせ';
  @override
  String register_header_text_5 = 'お申し込み';
  @override
  String register_header_text_6 = 'application';
  @override
  String register_text_1 = '以下のフォームに情報をご入力いただき、確認画面へお進みください。';
  @override
  String register_text_2 = '必須';
  @override
  String register_text_3 = '株式会社BX/BX CORPORATION';
  @override
  String register_text_4 = '〒106-0031 東京都港区西麻布１－１５－１森口ビル１０Ｆ';
  @override
  String register_text_5 =
      '©︎ 2023 BXCORPORATION Co., Ltd. All rights reserved.';
  // luxy end
  @override
  String register_title = 'トップ ﹥ お申し込み';
  @override
  String register_user_form_1 = '２段階認証';
  @override
  String register_company_form_1 = '決済が完了しました';
  @override
  String register_user_1 = '会社名（アカウント登録名）';
  @override
  String register_user_2 = '担当者名';
  @override
  String register_user_3 = '電話番号';
  @override
  String register_user_4 = 'メールアドレス';
  @override
  String register_company_1 = '入力';
  @override
  String register_company_2 = '確認';
  @override
  String register_company_3 = '決済';
  @override
  String register_company_4 = '都道府県';
  @override
  String register_company_5 = '住所';
  @override
  String register_company_6 = 'FAX番号';
  @override
  String register_btn_1 = 'この内容で送信する';
  @override
  String register_btn_2 = '決済画面へ遷移する';
  @override
  String register_btn_3 = 'TOPに戻る';
  @override
  String register_btn_4 = '送信する';
  @override
  String register_table_1 = 'プランを選ぶ';
  @override
  String register_table_2 = '特定商取引';
  @override
  String register_table_3 = 'プライバシーポリシー';
  @override
  String register_table_4 = 'に同意の上、送信してください。';
  @override
  String register_error_1 = 'このメールは申請済みですので、確認してください';
  @override
  String register_choose = '確認コードを入力してください';
  @override
  String register_choose_type = '確認コードが届かない場合';
  @override
  String register_choose_status = '確認コードを送る';
  @override
  String register_sub_success = '電話番号を入力してください。';
  @override
  String register_sub_error = '購買依頼の送信に失敗しました';
  @override
  String register_send_message = 'お申し込みいただき、ありがとうございます。';
  @override
  String register_send_message_1 = '2-3営業日以内に、担当者からアカウント情報をご連絡させていただきます。';
  //申込 -cuihr end

  // バーコード
  @override
  String barcode = 'バーコード';
  // ユーザーライセンス管理 熊草云 - start
  // ユーザー_名称
  @override
  String user_license_management_form_1 = 'ユーザー名称';
  // 言語
  @override
  String user_license_management_form_2 = '言語';
  // アイコン
  @override
  String user_license_management_form_3 = 'アイコン';
  // ユーザー明細
  @override
  String user_license_management_detail_form_1 = '従業員明細';
  // パスワードリセット
  @override
  String user_license_management_detail_form_2 = 'パスワードリセット';
  // 支払金額
  @override
  String user_license_management_detail_table_1 = '支払金額';
  // オーダー番号
  @override
  String user_license_management_detail_table_2 = 'オーダー番号';
  // 有効期間(年)
  @override
  String user_license_management_detail_table_3 = '有効期間(年)';
  // 有効期間(月)
  @override
  String user_license_management_detail_table_4 = '有効期間(月)';
  // 有効期間(日)
  @override
  String user_license_management_detail_table_5 = '有効期間(日)';
  // サポート内容
  @override
  String user_license_management_detail_table_6 = 'サポート内容';
  // 消費税（10％）
  @override
  String user_license_management_detail_table_7 = '消費税（10％）';
  // 追加
  @override
  String user_license_management_detail_table_8 = '追加';
  // このメールアドレスは登録されています。他のメールアドレスを使用してみてください
  @override
  String user_license_management_tip_1 =
      'このメールアドレスは登録されています、他のメールアドレスを使用してください';
  // 成功メッセージ
  @override
  String user_license_management_tip_2 = '成功メッセージ';
  // 修正不可
  @override
  String user_license_management_tip_3 = 'の修正不可です';
  // ライセンス追加/修正
  @override
  String user_license_management_tip_4 = 'ライセンス追加/修正';
  // ライセンス追加/修正しました
  @override
  String user_license_management_tip_5 = 'ライセンス追加/修正しました';
  // 決済完了の場合、支払ステータスを確認してください
  @override
  String user_license_management_tip_6 = '決済完了の場合、支払ステータスを確認してください';
  // ライセンスの種類を入力してください
  @override
  String user_license_management_tip_7 = 'ライセンスの種類を入力してください';
  // パスワードビット数少なくとも6ビット
  @override
  String user_license_management_tip_8 = 'パスワードビット数少なくとも6ビット';
  // ユーザーライセンス管理 熊草云 - end

  //申込受付 cuihr -start
  @override
  String app_cceptance_status = '申込状態';
  @override
  String app_cceptance_time = '申込時間';
  @override
  String app_cancel_status = '解約状態';
  @override
  String app_cancel_time = '解約時間';
  @override
  String app_cancel_status_not_confirm = '未確認';
  @override
  String app_cancel_status_confirm = '確認';
  @override
  String app_cancel_confirmed_no_operation = '解約は確認済みで、重複操作は不要';
  @override
  String app_cancel_confirm_finish = '解約確認完了';
  @override
  String app_cancel_finish = '解約完了';
  @override
  String app_cceptance_btn = '受付';
  @override
  String app_error_text_1 = '受付済みまたは却下のデータは操作できません';
  @override
  String app_error_text_2 = '受付確認';
  @override
  String app_error_text_3 = '支払がまだお済ではないお申込は受付できません';
  @override
  String app_error_text_4 = '現在、このメールアドレスにアカウントが登録されています。ご確認ください';
  @override
  String app_send_text_1 = '残念なお知らせですが、今回のお申し込み「';
  @override
  String app_send_text_2 = '申請はレビューに合格しました';
  @override
  String app_send_text_3 = '申込通知';
  @override
  String app_send_text_4 = '」は受付不可です。';
  @override
  String app_send_text_5 = 'なお、このメールは自動メールとなっております。';
  @override
  String app_send_text_6 = 'このメールに返信を頂いても回答出来ませんのでご了承下さい。';
  @override
  String app_send_text_7 = '不明点などあれば、pottz.biz-x.appに連絡頂ければと思います。';
  @override
  String app_send_text_8 = 'おめでとうございます、お申し込み「';
  @override
  String app_send_text_9 = '」はパスされました。';
  @override
  String app_send_text_10 = '下記URLをログインしてください。';
  @override
  String app_send_text_11 = 'pottz.biz-x.app';
  @override
  String app_send_text_12 = '申込却下通知';
  @override
  String app_send_text_13 = '申込受付通知';
  @override
  String app_cceptance_company_name = '会社名';
  @override
  String app_cceptance_user_name = '担当者名';
  @override
  String app_cceptance_user_email = 'メールアドレス';
  @override
  String app_cceptance_user_phone = '電話番号';
  @override
  String app_cceptance_pay_total = '支払金額';
  @override
  String app_cceptance_pay_status = '支払状態';
  @override
  String app_cceptance_info_1 = '申込情報';
  @override
  String app_cceptance_info_2 = 'プラン情報';
  @override
  String app_cceptance_info_3 = '支払情報';
  @override
  String app_cceptance_plan = '従量課金';
  @override
  String app_cceptance_account_num = 'アカウント数';
  @override
  String app_cceptance_option = 'オプション';
  @override
  String app_cceptance_pay_cycle = 'お支払いサイクル';

  //申込受付 cuihr -end

  // 帳票マスタ - 赵士淞 - 始
  // 区分
  @override
  String form_distinguish = '区分';
  // 会社アイコン
  @override
  String form_company_icon = '会社アイコン';
  // 用紙の向き
  @override
  String form_paper_rotation = '用紙の向き';
  // 説明
  @override
  String form_paper_explanation = '説明';
  // 横方向
  @override
  String form_paper_transverse = '横方向';
  // 縦方向
  @override
  String form_paper_direction = '縦方向';
  // 帳票マスタ詳細
  @override
  String form_detail_title = "帳票マスタ詳細";
  // 1行目の左部分
  @override
  String form_location_one_left = "1行目の左部分";
  // 1行目の中間部分
  @override
  String form_location_one_center = "1行目の中間部分";
  // 1行目の右部分
  @override
  String form_location_one_right = "1行目の右部分";
  // 2行目の左部分
  @override
  String form_location_two_left = "2行目の左部分";
  // 2行目の中間部分
  @override
  String form_location_two_center = "2行目の中間部分";
  // 2行目の右部分
  @override
  String form_location_two_right = "2行目の右部分";
  // テーブル
  @override
  String form_location_table = "テーブル";
  // テキスト
  @override
  String form_assort_text = "テキスト";
  // バーコード
  @override
  String form_assort_bar_code = "バーコード";
  // 計算テキスト
  @override
  String form_assort_calculation_text = "計算テキスト";
  // かさん
  @override
  String form_mode_calculation_addition = "かさん";
  // 減算
  @override
  String form_mode_calculation_subtraction = "減算";
  // 乗算
  @override
  String form_mode_calculation_multiplication = "乗算";
  // 除算
  @override
  String form_mode_calculation_division = "除算";
  // 表示
  @override
  String form_show_true = "表示";
  // 非表示
  @override
  String form_show_false = "非表示";
  // 位置
  @override
  String form_location = "位置";
  // 位置ID
  @override
  String form_location_id = "位置ID";
  // 順序番号
  @override
  String form_sequence_number = "順序番号";
  // 分類
  @override
  String form_assort = "分類";
  // 数式
  @override
  String form_formula = "数式";
  // フィールド名を表示
  @override
  String form_show_field_name = "フィールド名を表示";
  // サイズ
  @override
  String form_word_size = "サイズ";
  // コンテンツテーブル
  @override
  String content_table = "コンテンツテーブル";
  // コンテンツフィールド
  @override
  String content_fields = "コンテンツフィールド";
  // 計算表1
  @override
  String calculation_table1 = "計算表1";
  // 計算フィールド1
  @override
  String calculation_fields1 = "計算フィールド1";
  // 計算表2
  @override
  String calculation_table2 = "計算表2";
  // 計算フィールド2
  @override
  String calculation_fields2 = "計算フィールド2";
  // 計算モード
  @override
  String calculation_mode = "計算モード";
  // 接頭辞テキスト
  @override
  String form_prefix_text = "接頭辞テキスト";
  // 接尾辞テキスト
  @override
  String form_suffix_text = "接尾辞テキスト";
  // 帳票マスタ - 赵士淞 - 终

  // 商品はすでに存在します
  @override
  String product_exists = "商品はすでに存在します";
  // 会社の略称はすでに存在している
  @override
  String company_abbreviation_exists = "同一の「会社略称」はすでに存在します。別の略称をご入力ください";
  // メニューにサブレベルが存在して削除できません
  @override
  String menu_have_child_not_delete = "メニューにサブレベルが存在します。削除できません";

  // 入荷予定照会 muzd start
  // 少なくとも 1 つのデータを選択する
  @override
  String inquiry_schedule_print_select_one = '少なくとも 1 つのデータを選択してください';
  // 提示
  @override
  String inquiry_schedule_print_tip = 'ヒント';
  // 入荷予定一覧
  @override
  String inquiry_schedule_print_receivelist = '入荷予定一覧';
  // オーダー番号
  @override
  String inquiry_schedule_print_head_1 = 'オーダー番号';
  // 仕入先名称
  @override
  String inquiry_schedule_print_head_2 = '仕入先名称';
  // 入荷予定番号
  @override
  String inquiry_schedule_print_head_3 = '入荷予定番号';
  // 入荷予定日
  @override
  String inquiry_schedule_print_head_4 = '入荷予定日';
  // 入荷予定明細行No
  @override
  String inquiry_schedule_print_table_1 = '入荷予定明細行No';
  // 商品名
  @override
  String inquiry_schedule_print_table_2 = '商品名';
  // 入荷予定数
  @override
  String inquiry_schedule_print_table_3 = '入荷予定数';
  // 仕入単価
  @override
  String inquiry_schedule_print_table_4 = '単価';
  // 金額
  @override
  String inquiry_schedule_print_table_5 = '金額';
  // 入荷予定明細
  @override
  String inquiry_schedule_print_table_detail = '入荷予定明細';
  // 入荷予定照会 muzd end

  // 计划管理：プラン管理
  @override
  String plan_title_text = "プラン管理";
  // 计划管理：プラン追加・削除
  @override
  String plan_menu_text_1 = 'プラン追加・削除';
  // 计划管理：プラン内容変更
  @override
  String plan_menu_text_2 = 'プラン内容変更';
  // 计划管理：削除する
  @override
  String plan_button_text_1 = '削除する';
  // 计划管理：追加する
  @override
  String plan_button_text_2 = '追加する';
  // 计划管理：編集する
  @override
  String plan_button_text_3 = '編集する';
  // 计划管理：ユーザーを追加
  @override
  String plan_button_text_4 = 'ユーザーを追加';
  // 计划管理：ストレージ量を変更
  @override
  String plan_button_text_5 = 'ストレージ量を変更';
  // 计划管理：無償ライセンスを付与
  @override
  String plan_button_text_6 = '無償ライセンスを付与';
  // 计划管理：有償ライセンスを付与
  @override
  String plan_button_text_7 = '有償ライセンスを付与';
  // 计划管理：ユーザー数
  @override
  String plan_content_text_1 = 'ユーザー数';
  // 计划管理：ストレージ
  @override
  String plan_content_text_2 = 'ストレージ';
  // 计划管理：その他制限事項を記載
  @override
  String plan_content_text_3 = 'その他制限事項を記載';
  // 计划管理：現在の最大ユーザー数
  @override
  String plan_content_text_4 = '現在の最大ユーザー数';
  // 计划管理：現在の最大ストレージ量
  @override
  String plan_content_text_5 = '現在の最大ストレージ量';
  // 计划管理：ライセンス割り当て
  @override
  String plan_content_text_6 = 'ライセンス割り当て';
  // 计划管理：最大10人
  @override
  String plan_content_text_7 = '最大10人';
  // 计划管理：最大
  @override
  String plan_content_text_7_1 = '最大';
  // 计划管理：人
  @override
  String plan_content_text_7_2 = '人';
  // 计划管理：最大30GB
  @override
  String plan_content_text_8 = '最大30GB';
  // 计划管理：最大
  @override
  String plan_content_text_8_1 = '最大';
  // 计划管理：GB
  @override
  String plan_content_text_8_2 = 'GB';
  // 计划管理：ユーザー
  @override
  String plan_content_text_9 = 'ユーザー';
  // 计划管理：ライセンス
  @override
  String plan_content_text_10 = 'ライセンス';
  // 计划管理：現在のプラン
  @override
  String plan_content_text_11 = '現在のプラン';
  // 计划管理：お支払い方法
  @override
  String plan_content_text_12 = 'お支払い方法';
  // 计划管理：利用開始日
  @override
  String plan_content_text_13 = '利用開始日';
  // 计划管理：次回請求日
  @override
  String plan_content_text_14 = '次回請求日';
  // 计划管理：DB容量
  @override
  String plan_content_text_15 = 'DB容量';
  // 计划管理：ストレージ
  @override
  String plan_content_text_16 = 'ストレージ';
  // 计划管理：DBDL
  @override
  String plan_content_text_17 = 'DBDL';
  // 计划管理：ストレージDL
  @override
  String plan_content_text_18 = 'ストレージDL';
  // 计划管理：円/月
  @override
  String plan_content_text_19 = '円/月';
  // 计划管理：プラン
  @override
  String plan_content_text_20 = 'プラン';
  // 计划管理：プラン名
  @override
  String plan_content_text_21 = 'プラン名';
  // 计划管理：プラン金額
  @override
  String plan_content_text_22 = 'プラン金額';
  // 计划管理：新規ユーザー
  @override
  String plan_content_text_23 = '新規ユーザー';
  // 计划管理：新規アカウント
  @override
  String plan_content_text_24 = '新規アカウント';
  // 计划管理：数量が上限に達しました
  @override
  String plan_content_text_25 = '数量が上限に達しました';
  // 计划管理：入力値
  @override
  String plan_content_text_26 = '入力値';

  // 法人管理 muzd start
  // 法人管理
  @override
  String corporate_management_title = '法人管理';
  // 契約内容の確認
  @override
  String corporate_management_menu_1 = '契約内容の確認';
  // アカウント追加
  @override
  String corporate_management_menu_2 = 'アカウント追加';
  // アカウント停止
  @override
  String corporate_management_menu_3 = 'アカウント停止';
  // 検索文言
  @override
  String corporate_management_search_tip = '会社を検索';
  // 契約内容
  @override
  String corporate_management_tab_1 = '契約内容';
  // 申込時の内容
  @override
  String corporate_management_tab_2 = '申込時の内容';
  // ユーザー情報
  @override
  String corporate_management_text_1 = 'ユーザー情報';
  // 契約内容の詳細
  @override
  String corporate_management_text_2 = '契約内容の詳細';
  // 現在のユーザー数
  @override
  String corporate_management_text_3 = '現在のユーザー数';
  // 現在のストレージ使用量
  @override
  String corporate_management_text_4 = '現在のストレージ使用量';
  // 連携中のアカウント
  @override
  String corporate_management_text_5 = '連携中のアカウント';
  // アカウント
  @override
  String corporate_management_text_5_1 = 'アカウント';
  // 会員
  @override
  String corporate_management_text_6 = '会員';
  // 非会員
  @override
  String corporate_management_text_7 = '非会員';
  // お客様に替わって、お客様用アカウントを管理者が新設することができます。
  @override
  String corporate_management_text_8 = 'お客様に替わって、お客様用アカウントを管理者が新設することができます。';
  // ※決済はお客様にて行っていただきます。
  @override
  String corporate_management_text_9 = '※決済はお客様にて行っていただきます。';
  // メールアドレスを入力して下さい
  @override
  String corporate_management_text_10 = 'メールアドレスを入力して下さい';
  // パスワードを入力して下さい
  @override
  String corporate_management_text_11 = 'パスワードを入力して下さい';
  // 会社名（アカウント登録名）
  @override
  String corporate_management_text_12 = '会社名（アカウント登録名）';
  // プランを選ぶ
  @override
  String corporate_management_text_13 = 'プランを選ぶ';
  // ユーザーを検索
  @override
  String corporate_management_text_14 = '会社を検索';
  // メッセージを検索
  @override
  String corporate_management_text_15 = 'メッセージを検索';
  // アカウントを切替える
  @override
  String corporate_management_button_1 = 'アカウントを切替える';
  // アカウントを追加
  @override
  String corporate_management_button_2 = 'アカウントを追加';
  // 確認する
  @override
  String corporate_management_button_3 = '確認する';
  // 確認する
  @override
  String corporate_management_button_4 = '停止する';
  // 法人管理 muzd end

  // 消息管理 赵士淞 start
  // メッセージ
  @override
  String message_master_base_title = 'メッセージ';
  // メッセージ作成
  @override
  String message_master_title = 'メッセージ作成';
  // メッセージ一覧
  @override
  String message_master_menu_1 = 'メッセージ一覧';
  // 個別メッセージ
  @override
  String message_master_menu_2 = '個別メッセージ';
  // 全体メッセージ
  @override
  String message_master_menu_3 = '全体メッセージ';
  // 下書き
  @override
  String message_master_menu_4 = '下書き';
  // 返信
  @override
  String message_master_content_button_1 = '返信';
  // 転送
  @override
  String message_master_content_button_2 = '転送';
  // 全体へ送信
  @override
  String message_master_content_button_3 = '全体へ送信';
  // ライセンスある方へ送信
  @override
  String message_master_content_button_4 = 'ライセンスある方へ送信';
  // 消息管理 赵士淞 end

  // 用戸は会社法人、キャラクターは変更できない
  @override
  String user_is_legal_role_cannot_changed = '用戸は会社法人、キャラクターは変更できない';
  // 用戸は会社法人、削除できない
  @override
  String user_is_legal_cannot_delete = '用戸は会社法人、削除できない';
  // 会社には既に関連レコードが存在し、重複追加はできません
  @override
  String company_has_records_cannot_add = '御社データには既に関連レコードが存在します。重複追加はできません';
  // データが変更されましたので、再操作してください
  @override
  String data_changed_operate_again = 'データが変更されましたので、再度操作してください';
  // 削除をしますか
  @override
  String want_to_delete_it = '削除をしますか';
  // すでに解約状態であり、再申請は必要ありません
  @override
  String is_termination_no_apply_again = 'すでに解約状態であり、再申請は必要ありません';
  // 会社はすでに解約しており、再度の解約はできません
  @override
  String company_terminated_cannot_again = '会社はすでに解約しており、再度の解約はできません';
  // 会社は存在しません
  @override
  String company_not_exist = '会社は存在しません';

  // 项目check
  @override
  String check_half_width_alphanumeric = "は半角英数字で入力してください";
  @override
  String check_half_width_numbers = "は半角数字で入力してください";
  @override
  String check_half_width_numbers_in_10 = "は9桁以内の半角数字で入力してください";
  @override
  String check_half_width_numbers_in_3 = "は3桁以内の半角数字で入力してください";
  @override
  String check_half_width_numbers_with_hyphen = "は半角数字、ハイフンで入力してください";
  @override
  String check_email = "はメールの形式が正しく入力されていません";
  @override
  String check_half_width_alphanumeric_with_symbol = "は半角英数字、記号で入力してください";
  @override
  String check_kana = "は半角カナで入力してください";
  @override
  String check_password = "はアルファベット大文字と小文字と数字を含む、8桁以上で入力してください";
  @override
  String check_postal = "は3桁の数字-4桁の数字でなければなりません";

  // 商品情報
  @override
  String product_information = "商品情報";
  // 仕掛情報
  @override
  String design_information = "仕掛情報";
  // 在庫情報
  @override
  String inventory_information = '在庫情報';
  // トレンド情報
  @override
  String information_trend = 'トレンド情報';
  // 詳細を見る
  @override
  String product_information_look_at_details = '詳細を見る';
  // 関連商品情報が見つかりませんでした
  @override
  String product_information_no_product_information_found = '関連商品情報が見つかりませんでした';
  // 関連する複数の商品情報を見つける
  @override
  String product_information_multiple_product_information_found =
      '関連する複数の商品情報を見つける';
  // 出荷指示済数
  @override
  String design_information_shipment_number = '出荷指示済数';
  // 未出荷数
  @override
  String design_information_unshipped_number = '未出荷数';
  // 本日出荷指示数
  @override
  String design_information_shipment_number_today = '本日出荷指示数';
  // 本日未出荷数
  @override
  String design_information_unshipped_number_today = '本日未出荷数';
  // 未出庫数
  @override
  String design_information_unoutbound_number = '未出庫数';
  // 未ピッキング数
  @override
  String design_information_unpicking_number = '未ピッキング数';
  // 未入荷数
  @override
  String design_information_unexpected_number = '未入荷数';
  // 本日入荷予定数
  @override
  String design_information_expected_number_today = '本日入荷予定数';
  // 本日未入荷数
  @override
  String design_information_unexpected_number_today = '本日未入荷数';
  // 未検品数
  @override
  String design_information_unchecked_number = '未検品数';
  // 未入庫数
  @override
  String design_information_unlisted_number = '未入庫数';
  // 棚番
  @override
  String inventory_information_shelf = '棚番';
  // ロット
  @override
  String inventory_information_lot = 'ロット';
  // 価格
  @override
  String inventory_information_price = '価格';
  // 現在庫数
  @override
  String inventory_information_current_inventory = '現在庫数';
  // 出荷先（上位５社）
  @override
  String trend_information_shipment_top_five = '出荷先（上位５社）';
  // 出荷先
  @override
  String trend_information_shipment = '出荷先';
  // 入荷元（上位５社）
  @override
  String trend_information_entrance_top_five = '入荷元（上位５社）';
  // 入荷元
  @override
  String trend_information_entrance = '入荷元';
  // 出荷数（月単位）
  @override
  String trend_information_shipment_month = '出荷数（月単位）';
  // 入荷数（月単位）
  @override
  String trend_information_entrance_month = '入荷数（月単位）';
  // 商品情報が見つかりませんでした、商品マスタを登録しますか？
  @override
  String did_you_find_the_item_master = '商品情報が見つかりませんでした、商品マスタを登録しますか？';

  // ログインしたままにする
  @override
  String login_remember_me = 'ログインしたままにする';

  // 商品コード / JANCD
  @override
  String home_menu_product_code_or_jan_cd = '商品コード / JANCD';
  // 関連商品は検索されていませんが、新たに商品を追加しますか？
  @override
  String no_products_found_want_to_add_new = '関連商品は検索されていませんが、新たに商品を追加しますか？';

  // お申し込み
  @override
  String login_application_title = 'お申し込み';
  // 申込
  @override
  String login_application_step_1 = '申込';
  // 認証
  @override
  String login_application_step_2 = '認証';
  // プラン選択
  @override
  String login_application_step_3 = 'プラン選択';
  // 完了
  @override
  String login_application_step_4 = '完了';
  // 以下のフォームに情報をご入力いただき、確認画面へお進みください。
  @override
  String login_application_enter_form_text = '以下のフォームに情報をご入力いただき、確認画面へお進みください。';
  // 会社名
  @override
  String login_application_company_name = '会社名';
  // 担当者名
  @override
  String login_application_person_charge = '担当者名';
  // メールアドレス
  @override
  String login_application_email_address = 'メールアドレス';
  // 電話番号
  @override
  String login_application_phone_number = '電話番号';
  // キャンペーンコード
  @override
  String login_application_campaign_code = 'キャンペーンコード';
  // パスワード
  @override
  String login_application_password = 'パスワード';
  // 必須
  @override
  String login_application_required = '必須';
  // 任意
  @override
  String login_application_optional = '任意';
  // 申込
  @override
  String login_application_button_1 = '申込';
  @override
  // Eメールが使用されているので、新しいEメールを交換してください
  String login_application_email_address_error_exist =
      'このメールは申請済みですので、再度申請することはできません';
  // 複数のアクティビティ例外が見つかりました。管理者に連絡して処理してください。
  @override
  String login_application_campaign_code_error_multiple =
      '複数のアクティビティ例外が見つかりました。管理者に連絡して処理してください。';
  // アクティビティが存在しないか、アクティビティの有効期間内にありません。
  @override
  String login_application_campaign_code_error_invalid =
      'アクティビティが存在しないか、アクティビティの有効期間内にありません。';
  // 複数のメールボックス申請の例外が見つかりました。管理者に連絡して処理してください。
  @override
  String login_application_password_error_multiple =
      '複数のメールボックス申請の例外が見つかりました。管理者に連絡して処理してください。';
  // メールボックスが存在しないか、パスワードが正しくありません。
  @override
  String login_application_password_error_invalid =
      'メールボックスが存在しないか、パスワードが正しくありません。';
  // 購買依頼オーダ支払済、管理者確認待ち
  @override
  String login_application_password_error_paid = '購買依頼オーダ支払済、管理者確認待ち';
  // ２段階認証
  @override
  String login_application_authentication_title = '２段階認証';
  // 入力された電話番号に確認コードを送信しました。
  @override
  String login_application_authentication_text_1 = '入力された電話番号に確認コードを送信しました。';
  // 送信された確認コードを入力してください。
  @override
  String login_application_authentication_text_2 = '送信された確認コードを入力してください。';
  // スキャンコード検証
  @override
  String login_application_verify_tab_1 = 'スキャンコード検証';
  // メールボックスの検証
  @override
  String login_application_verify_tab_2 = 'メールボックスの検証';
  // Microsoft Authenticator認証APPの使用
  @override
  String login_application_verify_tab_1_text = 'Authenticator認証APPの使用';
  // メールを送信
  @override
  String login_application_verify_tab_2_button = 'メールを送信';
  // 検証法が送信されました。5分後に再試行してください
  @override
  String login_application_verify_tab_2_error_text =
      '検証法が送信されました。1分後に再試行してください';
  // プラン選択へ
  @override
  String login_application_button_2 = 'プラン選択へ';
  // 認証エラーメッセージ
  @override
  String login_application_button_2_error_1 = '認証コードが正しくありません';
  // mail認証タイトル
  @override
  String login_application_mail_subject = 'POTTZ mail認証認証コード';
  // mail認証内容1
  @override
  String login_application_mail_send_text_1 = 'メール認証';
  // mail認証内容2
  @override
  String login_application_mail_send_text_2 = '認証コード：';
  // プランを選ぶ
  @override
  String login_application_choose_plan = 'プランを選ぶ';
  // 必要な機能
  @override
  String login_application_choose_required = '必要な機能';
  // 必要な機能を選択
  @override
  String login_application_choose_required_text = '必要な機能を選択';
  // 出荷管理、入荷管理、在庫管理の3つの機能があります。
  @override
  String login_application_choose_required_text_1 =
      '出荷管理、入荷管理、在庫管理の3つの機能があります。';
  // 1機能だけだと19,800円。2機能の場合29,800円。3機能全て選択の場合39,800円。
  @override
  String login_application_choose_required_text_2 =
      '1機能だけだと19,800円。2機能の場合29,800円。3機能全て選択の場合39,800円。';
  // 出荷管理
  @override
  String login_application_choose_required_button_1 = '出荷管理';
  // 入荷管理
  @override
  String login_application_choose_required_button_2 = '入荷管理';
  // 在庫管理
  @override
  String login_application_choose_required_button_3 = '在庫管理';
  // アカウント数を選ぶ
  @override
  String login_application_choose_number_accounts = 'アカウント数を選ぶ';
  // 1.データ容量 ※従量課金部分
  @override
  String login_application_choose_plan_title = '1.データ容量 ※従量課金部分';
  // ご利用の容量に応じて、ベースプランとは別に以下の従量課金が月単位に発生いたします。締日（各月末日）の翌月に通常のお支払い分に加算してご請求させていただきますので、予めご了承ください。
  @override
  String login_application_choose_plan_text =
      'ご利用の容量に応じて、ベースプランとは別に以下の従量課金が月単位に発生いたします。締日（各月末日）の翌月に通常のお支払い分に加算してご請求させていただきますので、予めご了承ください。';
  // 上限
  @override
  String login_application_choose_plan_upper_limit = '上限';
  // DB容量
  @override
  String login_application_choose_plan_db_capacity = 'DB容量';
  // DBDL
  @override
  String login_application_choose_plan_db_dl = 'DBDL';
  // ストレージ
  @override
  String login_application_choose_plan_storage = 'ストレージ';
  // ストレージDL
  @override
  String login_application_choose_plan_storage_dl = 'ストレージDL';
  // 2.アカウント数を選ぶ
  @override
  String login_application_choose_account_title = '2.アカウント数を選ぶ';
  // 標準
  @override
  String login_application_choose_account_option_title_1 = '標準';
  // 初期設定でアカウントは3つあります
  @override
  String login_application_choose_account_option_text_1 = '初期設定でアカウントは3つあります';
  // 1アカウント追加
  @override
  String login_application_choose_account_option_title_2 = '1アカウント追加';
  // アカウントを新たに１つ追加（合計4つ）
  @override
  String login_application_choose_account_option_text_2 = 'アカウントを新たに１つ追加（合計4つ）';
  // アカウント追加
  @override
  String login_application_choose_account_input_text = 'アカウント追加';
  // 正の整数値を入力する必要があります
  @override
  String login_application_choose_account_input_error = '正の整数値を入力する必要があります';
  // 3.オプションを選ぶ
  @override
  String login_application_choose_supply_title = '3.オプションを選ぶ';
  // 標準
  @override
  String login_application_choose_supply_option_title_1 = '標準';
  // オプション不要
  @override
  String login_application_choose_supply_option_text_1 = 'オプション不要';
  // 連携オプション
  @override
  String login_application_choose_supply_option_title_2 = '連携オプション';
  // 上位（基幹系）システム、会計システムとのデータ連携をサポート
  @override
  String login_application_choose_supply_option_text_2 =
      '上位（基幹系）システム、会計システムとのデータ連携をサポート';
  // 文書管理オプション
  @override
  String login_application_choose_supply_option_title_3 = '文書管理オプション';
  // ファイリング可能画面でのファイル保管をサポート
  @override
  String login_application_choose_supply_option_text_3 =
      'ファイリング可能画面でのファイル保管をサポート';
  // 取引先公開オプション
  @override
  String login_application_choose_supply_option_title_4 = '取引先公開オプション';
  // 取引先への在庫情報公開をサポート
  @override
  String login_application_choose_supply_option_text_4 = '取引先への在庫情報公開をサポート';
  // 4.お支払いサイクル
  @override
  String login_application_choose_cycle_title = '4.お支払いサイクル';
  // 月払い
  @override
  String login_application_choose_cycle_month = '月払い';
  // 年払い
  @override
  String login_application_choose_cycle_year = '年払い';
  // ※ 従量課金プランは月払いとなります
  @override
  String login_application_choose_cycle_year_text = '※ 従量課金プランは月払いとなります';
  // 選択したプランの合計金額をご確認ください
  @override
  String login_application_choose_amount_text = '選択したプランの合計金額をご確認ください';
  // 初期費用
  @override
  String login_application_choose_amount_initial = '初期費用';
  // ベースプラン
  @override
  String login_application_choose_amount_module = 'ベースプラン';
  // 従量課金
  @override
  String login_application_choose_amount_plan = '従量課金';
  // アカウント
  @override
  String login_application_choose_amount_account = 'アカウント';
  // オプション
  @override
  String login_application_choose_amount_option = 'オプション';
  // 合計
  @override
  String login_application_choose_amount_sum = '合計';
  // 円(税抜)
  @override
  String login_application_choose_amount_tax = '円(税抜)';
  // 円(税抜)/月
  @override
  String login_application_choose_amount_tax_month = '円(税抜)/月';
  // 日間無料でお試し
  @override
  String login_application_choose_amount_free = '日間無料でお試し';
  // 次へ
  @override
  String login_application_step_button_1 = '次へ';
  // 特定商取引法に基づく表記
  @override
  String login_application_step_confirm_item_1 = '特定商取引法に基づく表記';
  // プライバシーポリシー
  @override
  String login_application_step_confirm_item_2 = 'プライバシーポリシー';
  // に同意してください
  @override
  String login_application_step_confirm_item_text = 'に同意してください';
  // 特定商取引法に基づく表記をチェックしてください
  @override
  String login_application_step_button_1_tip_text_1 = '特定商取引法に基づく表記をチェックしてください';
  // プライバシーポリシーをチェックしてください
  @override
  String login_application_step_button_1_tip_text_2 = 'プライバシーポリシーをチェックしてください';
  // ※ 価格は全て税抜表示となります。
  @override
  String login_application_pure_text_title = '※ 価格は全て税抜表示となります。';
  // 1.従量過金部分（データ容量）に関して、サーチャージ等が影響しますので事前の告知なしに変更となる場合があります。
  @override
  String login_application_pure_text_1 =
      '1.従量過金部分（データ容量）に関して、サーチャージ等が影響しますので事前の告知なしに変更となる場合があります。';
  // 2.年払い選択時の従量課金プランについてベースプランとは別に従量課金部分に関しては月払いのサブスクリプションが発生します。
  @override
  String login_application_pure_text_2 =
      '2.年払い選択時の従量課金プランについてベースプランとは別に従量課金部分に関しては月払いのサブスクリプションが発生します。';
  // 無料キャンペーンについての注意事項
  @override
  String login_application_pure_text_2_1 = '無料キャンペーンについての注意事項';
  // 無料期間が終了後、自動的に有料プランへ移行となります。ご継続をご希望されない場合は、期間終了までにマイページよりご解約のお手続きをお願いいたします。ご解約はいつでも可能ですが、期限を過ぎると自動更新となるためお早目のご対応をよろしくお願いいたします。
  @override
  String login_application_pure_text_2_2 =
      '無料期間が終了後、自動的に有料プランへ移行となります。ご継続をご希望されない場合は、期間終了までにマイページよりご解約のお手続きをお願いいたします。ご解約はいつでも可能ですが、期限を過ぎると自動更新となるためお早目のご対応をよろしくお願いいたします。';
  // ※ お申し込み日から無料期間経過後の23:59までにマイページよりご解約を完了してください。
  @override
  String login_application_pure_text_2_3 =
      '※ お申し込み日から無料期間経過後の23:59までにマイページよりご解約を完了してください。';
  // 3.無料キャンペーン時の従量課金について無料キャンペーン中の従量課金プランはフリーのみに制限されます。
  @override
  String login_application_pure_text_3 =
      '3.無料キャンペーン時の従量課金について無料キャンペーン中の従量課金プランはフリーのみに制限されます。';
  // ログインページに戻る
  @override
  String login_application_button_4 = 'ログインページに戻る';
  // 決済完了
  @override
  String login_application_step_4_text_1 = '決済完了';
  // お申し込みいただき、ありがとうございます。
  @override
  String login_application_step_4_text_2 = 'お申し込みいただき、ありがとうございます。';
  // 後ほど担当者からアカウント情報をご連絡させていただきます。
  @override
  String login_application_step_4_text_3 = '後ほど担当者からアカウント情報をご連絡させていただきます。';
  // 申請通知
  @override
  String login_application_end_email_title = '申請通知';
  // 決済が完了しました。
  @override
  String login_application_end_email_text1 = '決済が完了しました。';
  // お申し込みいただき、ありがとうごさいます。
  @override
  String login_application_end_email_text2 = 'お申し込みいただき、ありがとうごさいます。';
  // 2-3営業日以内に、担当者からアカツント情報をご連絡させていただきます。
  @override
  String login_application_end_email_text3 =
      '2-3営業日以内に、担当者からアカツント情報をご連絡させていただきます。';

  // 継続料金
  @override
  String login_renewal_title = '継続料金';
  // メールボックスには複数のアカウントが存在します
  @override
  String email_multiple_accounts = 'メールボックスには複数のアカウントが存在します';
  // メールボックスは存在しません
  @override
  String email_not_exist = 'メールボックスは存在しません';
  // ユーザーは会社購買依頼管理者ではありません
  @override
  String user_not_company_application_admin = 'ユーザーは会社購買依頼管理者ではありません';
  // 最終支払レコードが見つかりません
  @override
  String last_payment_record_not_found = '最終支払レコードが見つかりません';
  // チャージバック有効期間ではなくオプションを変更できません
  @override
  String option_cannot_changed_text_1 = 'チャージバック有効期間ではなくオプションを変更できません';
  // 年間支払期限が切れていない場合はオプションを変更できません
  @override
  String option_cannot_changed_text_2 = '年間支払期限が切れていない場合はオプションを変更できません';
  // 使用中のユーザー数が3より大きい場合はオプションを変更できません
  @override
  String users_in_use_than_3_option_cannot_changed =
      '使用中のユーザー数が3より大きい場合はオプションを変更できません';
  // ユーザー数を使用中のユーザー数よりも多く入力してください
  @override
  String users_enter_must_then_users_in_use = 'ユーザー数を使用中のユーザー数よりも多く入力してください';

  // 2段階認証
  @override
  String login_verification_code_text_title = '2段階認証';
  // 認証コードを入力してください
  @override
  String login_verification_code_text_content = '認証コードを入力してください';
  // 送信する
  @override
  String login_verification_code_button = '認証する';

  // 提交
  @override
  String login_company_complete_submit = '登録';
  // 存在未填写的信息，无法执行提交操作
  @override
  String login_company_complete_submit_error = 'コミット操作を実行できない未記入の情報があります';

  // POTTZ 申込
  @override
  String legal_person_email_title = 'POTTZ 申込';
  // お客様
  @override
  String legal_person_email_text1 = 'お客様';
  // お客様用アカウントを管理者が新設しました.
  @override
  String legal_person_email_text2 = 'お客様用アカウントを管理者が新設しました.';
  // 下記URLにログインして申し込みを完了してください.
  @override
  String legal_person_email_text3 = '下記URLにログインして申し込みを完了してください.';
  // アカウントやパスワードがわからない場合は、管理者にお問い合わせください。
  @override
  String legal_person_email_text4 = 'アカウントやパスワードがわからない場合は、管理者にお問い合わせください。';

  // アカウントの追加に成功しました
  @override
  String legal_person_add_success = 'アカウントの追加に成功しました';

  // データベース領域が不足しています計画をアップグレードしてください
  @override
  String database_space_low_upgrade_plan = 'データベース領域が不足しています計画をアップグレードしてください';
  // ストレージが不足しています計画をアップグレードしてください
  @override
  String storage_space_low_upgrade_plan = 'ストレージが不足しています計画をアップグレードしてください';

  //-------------------------------- 修正追加start
  @override
  String table_sort_column = 'ソート';
  //-------------------------------- 修正追加end
}
