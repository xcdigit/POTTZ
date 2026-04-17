import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wms/common/utils/supabase_untils.dart';

/**
 * 统计工具类
 * 作者：赵士淞
 * 时间：2025-01-23
 */
class StatisticsUtils {
  // 初始化
  static void init(int companyId, int companyPlanId) async {
    // 数据大小
    double databaseSize = 0;
    // 数据统计
    List<dynamic> databaseData = await SupabaseUtils.getClient().rpc(
        'func_zhaoss_database_statistics',
        params: {'p_company_id': companyId}).select('*');
    // 数据大小
    databaseSize = double.parse(databaseData[0]['size'].toString());

    // 存储大小
    double storageSize = 0;
    // avatar文件夹数据
    List<FileObject> avatarData = await SupabaseUtils.getClient()
        .storage
        .from('pic')
        .list(path: 'avatar/' + companyId.toString());
    for (int i = 0; i < avatarData.length; i++) {
      // 存储大小
      storageSize += avatarData[i].metadata?['size'];
    }
    // form文件夹数据
    List<FileObject> formData = await SupabaseUtils.getClient()
        .storage
        .from('pic')
        .list(path: 'form/' + companyId.toString());
    for (int i = 0; i < formData.length; i++) {
      // 存储大小
      storageSize += formData[i].metadata?['size'];
    }
    // product文件夹数据
    List<FileObject> productData = await SupabaseUtils.getClient()
        .storage
        .from('pic')
        .list(path: 'product/' + companyId.toString());
    for (int i = 0; i < productData.length; i++) {
      // 存储大小
      storageSize += productData[i].metadata?['size'];
    }

    // 更新会社计划
    await SupabaseUtils.getClient().from('ytb_company_plan_manage').update({
      'database_size': databaseSize / 1024 / 1024 / 1024,
      'storage_size': storageSize / 1024 / 1024 / 1024,
      'update_time': DateTime.now().toString(),
      'update_id': 1
    }).eq('id', companyPlanId);
  }
}
