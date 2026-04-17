import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '/common/utils/supabase_untils.dart';

///基类
abstract class BaseDbProvider<T> {

  tableName();

  T fromJson(dynamic record);

  dynamic toJson(T model);

  ///查询数据
  Future<List<T>> queryAll(Map<String, dynamic>? matchMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    List<dynamic> response;
    if (matchMap == null) {
      response = await client.from(tableName()).select();
    } else {
      response = await client.from(tableName()).select().match(matchMap);
    }
    return response.map((item) => fromJson(item)).toList();
  }

    ///查询数据
  Future<List<T>> queryPage(Map<String, dynamic> matchMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return await client.from(tableName()).select();
  }

  ///插入数据
  Future<void> insert(Map<String, dynamic> dataMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return client.from(tableName()).insert(dataMap);
  }

  ///插入数据
  Future<T> insertAndFetch(Map<String, dynamic> dataMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return await client.from(tableName()).insert(dataMap).select();
  }

  ///更新数据
  Future<void> update(Map<String, dynamic> matchMap, Map<String, dynamic> dataMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return client.from(tableName()).update(dataMap).match(matchMap);
  }

  ///更新数据
  Future<T> updateAndFetch(Map<String, dynamic> matchMap, Map<String, dynamic> dataMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return await client.from(tableName()).update(dataMap).match(matchMap).select();
  }

  ///删除数据
  Future<void> delete(Map<String, dynamic> matchMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return client.from(tableName()).delete().match(matchMap);
  }

  ///删除数据
  Future<T> deleteAndFetch(Map<String, dynamic> matchMap) async {
    SupabaseClient client = SupabaseUtils.getClient();
    return await client.from(tableName()).delete().match(matchMap).select();
  }
}
