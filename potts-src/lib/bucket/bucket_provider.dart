import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/utils/supabase_untils.dart';

enum BucketType {
  pic('pic');

  final String bucketName;
  const BucketType(this.bucketName);
}

class BucketProvider {

  Future<String> uploadByBinary(BucketType bucketType, String path, Uint8List data) async { // 会社IDをパスに付けて
    SupabaseStorageClient supabaseStorageClient = SupabaseUtils.getSupabaseStorageClient();
    String result = await supabaseStorageClient.from(bucketType.bucketName).uploadBinary(path, data);
    return result;
  }

  Future<Uint8List> download(BucketType bucketType, String path) async { // 会社IDをパスに付けて
    SupabaseStorageClient supabaseStorageClient = SupabaseUtils.getSupabaseStorageClient();
    await supabaseStorageClient.from(bucketType.bucketName).list(path: path);
    Uint8List result = await supabaseStorageClient.from(bucketType.bucketName).download(path);
    return result;
  }

  // 赵士淞 - 始
  // 预览
  Future<String> preview(BucketType bucketType, String path) async {
    // Supabase Storage 实例化
    SupabaseStorageClient supabaseStorageClient =
        SupabaseUtils.getSupabaseStorageClient();
    // 生成签署路径
    String signedUrl = await supabaseStorageClient
        .from(bucketType.bucketName)
        .createSignedUrl(path, 60);
    return signedUrl;
  }
  // 赵士淞 - 终
}
