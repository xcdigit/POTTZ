import 'package:json_annotation/json_annotation.dart';

part 'env_config.g.dart';

///环境配置
@JsonSerializable(createToJson: false)
class EnvConfig {
  final String env;
  final String supabase_url;
  final String supabase_anon_key;
  final String supabase_role_key;
  final String resend_api_key;

  EnvConfig(this.env, this.supabase_url, this.supabase_anon_key,
      this.supabase_role_key, this.resend_api_key);

  factory EnvConfig.fromJson(Map<String, dynamic> json) =>
      _$EnvConfigFromJson(json);
}
