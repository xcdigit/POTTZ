import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;
import '../../model/login.dart' as _;
import '../config/config.dart';
import '../storage/local_storage.dart';

class SupabaseUtils {
  static initialize(String? url, String? anonKey) async {
    if (url == null) {
      throw Exception('need url');
    }
    if (anonKey == null) {
      throw Exception('need anonKey');
    }
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  static dispose() {
    Supabase.instance.dispose();
  }

  static _.Login? getCurrentUser() {
    var currentUser = Supabase.instance.client.auth.currentUser;
    return _.Login(
      currentUser?.email,
      // 赵士淞 - 始
      currentUser?.id,
      // 赵士淞 - 终
      '',
      '',
    );
  }

  static Future<bool> loginByMail(
      String mailAdress, String password, bool remember) async {
    try {
      AuthResponse response = await Supabase.instance.client.auth
          .signInWithPassword(email: mailAdress, password: password);
      print(response.user);
      if (remember) {
        await LocalStorage.save(Config.USER_NAME_KEY, mailAdress);
        await LocalStorage.save(Config.PW_KEY, password);
      } else {
        await LocalStorage.remove(Config.USER_NAME_KEY);
        await LocalStorage.remove(Config.PW_KEY);
      }
      await LocalStorage.save(Config.REMEMBER_ME, remember.toString());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logout() async {
    Supabase.instance.client.auth.signOut();
    await LocalStorage.remove(Config.USER_NAME_KEY);
    await LocalStorage.remove(Config.PW_KEY);
  }

  static SupabaseClient getClient() {
    return Supabase.instance.client;
  }

  static FunctionsClient getFunctionClient() {
    return Supabase.instance.client.functions;
  }

  static RealtimeClient getRealTimeClient() {
    return Supabase.instance.client.realtime;
  }

  static PostgrestClient getPostgrestClient() {
    return Supabase.instance.client.rest;
  }

  static SupabaseStorageClient getSupabaseStorageClient() {
    return Supabase.instance.client.storage;
  }
}
