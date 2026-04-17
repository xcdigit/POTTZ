import '../common/utils/supabase_untils.dart';
import '../model/company.dart';
import '../model/number.dart';
import 'wms_common_bloc_utils.dart';

/**
 * 内容：共通BLOC
 * 作者：赵士淞
 * 时间：2023/09/06
 */
class WMSCommonBloc {
  // 查询自动采番
  static Future<String> selectNumber(int? companyId, String wmsChannel) async {
    // 当前日期时间
    DateTime now = DateTime.now();
    // 当前年份
    int year = now.year;
    // 当前月份
    int month = now.month;
    // 当前年月
    String yearMonth = year.toString() +
        (month < 10 ? '0' + month.toString() : month.toString());
    // 查询自动采番
    List<dynamic> number = await SupabaseUtils.getClient()
        .from('mtb_number')
        .select('*')
        .eq('company_id', companyId)
        .eq('wms_channel', wmsChannel)
        .eq('year_month', yearMonth);
    // 判断自动采番数量
    if (number.length == 1) {
      // 自动采番
      Number numberEntity = Number.fromJson(number[0]);
      // 查询会社情报
      List<dynamic> company = await SupabaseUtils.getClient()
          .from('mtb_company')
          .select('*')
          .eq('id', companyId);
      // 判断会社情报数量
      if (company.length == 1) {
        // 会社情报
        Company companyEntity = Company.fromJson(company[0]);
        // 返回
        return companyEntity.name_short! +
            '-' +
            wmsChannel +
            '-' +
            yearMonth +
            '-' +
            WMSCommonBlocUtils.numberSupplement(numberEntity.seq_no! + 1, 8);
      } else {
        // 返回
        throw Exception();
      }
    } else {
      // 返回
      throw Exception();
    }
  }

  // 更新自动采番连番
  static void updateNumberSeqNo(
      int? companyId, String wmsChannel, String no) async {
    // 当前日期时间
    DateTime now = DateTime.now();
    // 当前年份
    int year = now.year;
    // 当前月份
    int month = now.month;
    // 当前年月
    String yearMonth = year.toString() +
        (month < 10 ? '0' + month.toString() : month.toString());
    // 查询自动采番
    List<dynamic> number = await SupabaseUtils.getClient()
        .from('mtb_number')
        .select('*')
        .eq('company_id', companyId)
        .eq('wms_channel', wmsChannel)
        .eq('year_month', yearMonth);
    // 判断自动采番数量
    if (number.length == 1) {
      // 自动采番
      Number numberEntity = Number.fromJson(number[0]);
      // 番号编码
      int noCode = int.parse(no.substring(no.lastIndexOf('-') + 1));
      // 比较两者
      if (noCode > numberEntity.seq_no!) {
        // 自动采番
        numberEntity.seq_no = noCode;
        // 修改自动采番
        await SupabaseUtils.getClient()
            .from('mtb_number')
            .update(numberEntity.toJson())
            .eq('id', numberEntity.id);
      }
    }
  }
}
