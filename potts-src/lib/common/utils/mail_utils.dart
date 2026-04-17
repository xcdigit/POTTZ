import 'package:resend_dart/resend_dart.dart';
import 'package:wms/env/dev.dart';
import 'package:wms/env/env_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/**
 * send mail工具类
 * 作者：muzd
 * 时间：2023-12-07
 */
class MailUtils {
  //发送邮件
  static Future<bool> sendMail(
      List<String> toMail, String subject, String html) async {
    EnvConfig? envConfig = EnvConfig.fromJson(config);
    final resend = Resend(apiKey: envConfig.resend_api_key);
    try {
      await resend.email.send(
          from: 'onboarding@resend.dev',
          to: toMail,
          subject: subject,
          html: html);
    } catch (e) {
      //送信失败的场合
      print("----------send mail error--------");
      print(e);
      print("----------send mail error--------");
      return false;
    }
    //送信成功的场合
    return true;
  }

  //发送邮件（自己邮箱为from）
  static Future<bool> sendEmailWithSMTP(
      String toMail, String subject, String content) async {
    //发送邮件参数设定
    Map<String, String> body = new Map();
    body['tomail'] = toMail;
    body['subject'] = subject;
    body['content'] = content;

    final response = await http.post(
      Uri.parse(
          'https://culnohqxtcpbghvuvetv.supabase.co/functions/v1/send-email-smtp'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1bG5vaHF4dGNwYmdodnV2ZXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTA1MzE4MzEsImV4cCI6MjAwNjEwNzgzMX0.wH_RUm0RgO846tIsEnDBu04Zl1MIS0snPoTznZyrPjw',
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      //送信成功的场合
      return true;
    } else {
      print("----------send mail error--------");
      print(response.body);
      print("----------send mail error--------");
      //送信失败的场合
      return false;
    }
  }
}
