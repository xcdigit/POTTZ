// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

/**
 * 内容：解约信息清除API
 * 作者：赵士淞
 * 时间：2024-01-15
 */
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// 标头
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// Supabase初始化
const supabaseClient = createClient(
  'https://culnohqxtcpbghvuvetv.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1bG5vaHF4dGNwYmdodnV2ZXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTA1MzE4MzEsImV4cCI6MjAwNjEwNzgzMX0.wH_RUm0RgO846tIsEnDBu04Zl1MIS0snPoTznZyrPjw'
)

serve(async (req) => {
  // 跨域处理
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  // 当前时间
  let date = new Date()
  // 八小时后时间
  let endDate = new Date(date.getTime() + 8 * 60 *60 * 1000)
  // 八小时后时间字符串
  let endDateStr = endDate.getFullYear() + '-' + (endDate.getMonth() + 1 < 10 ? '0' + (endDate.getMonth() + 1) : endDate.getMonth() + 1) + '-' + (endDate.getDate() < 10 ? '0' + endDate.getDate() : endDate.getDate()) 

  try {
    // 查询会社
    let supabseCompanyData: Map<string, any> = await supabaseClient.from('mtb_company').select('*').eq('status', '3');
    // 判断会社是否异常
    if (supabseCompanyData['error'] != null) {
      // 返回
      throw supabseCompanyData['error']['message'];
    }
    // 会社
    let companyData: Array<any> = supabseCompanyData['data'] != null ? supabseCompanyData['data'] : [];

    // 循环会社
    for (let i: number = 0; i < companyData.length; i ++) {
      // 当前会社
      let currentCompany: Map<string, any> = companyData[i];

      // 查询運用会社けいかく管理
      let supabseCompanyManageData: Map<string, any> = await supabaseClient.from('ytb_company_plan_manage').select('*')
                                                                                                          .eq('company_id', currentCompany['id'])
                                                                                                          .order('id', { ascending: false });
      // 判断運用会社けいかく管理是否异常
      if (supabseCompanyManageData['error'] != null) {
        // 返回
        throw supabseCompanyManageData['error']['message'];
      }
      // 運用会社けいかく管理
      let companyManageData: Map<string, any> = supabseCompanyManageData['data'] != null ? supabseCompanyManageData['data'][0] : {};
      
      // 判断是否已过利用終了日
      if (companyManageData['end_date'] != undefined && companyManageData['end_date'].toString() < endDateStr) {
        // 删除運用会社管理
        await supabaseClient.from('ytb_company_manage').delete().eq('company_id', currentCompany['id'])
        // 删除運用会社ユーザー管理
        await supabaseClient.from('ytb_user_manage').delete().eq('company_id', currentCompany['id'])
        // 删除商品マスタ
        await supabaseClient.from('mtb_product').delete().eq('company_id', currentCompany['id'])
        // 删除帳票編集
        await supabaseClient.from('mtb_form').delete().eq('company_id', currentCompany['id'])
        // 删除帳票編集明细
        await supabaseClient.from('mtb_form_detail').delete().eq('company_id', currentCompany['id'])
        // 删除在庫引当
        await supabaseClient.from('mtb_allowance').delete().eq('company_id', currentCompany['id'])
        // 删除社内メッセージマスタ
        await supabaseClient.from('mtb_company_message').delete().eq('company_id', currentCompany['id'])
        // 删除ユーザーマスタ
        await supabaseClient.from('mtb_user').delete().eq('company_id', currentCompany['id'])
        // 删除組織マスタ
        await supabaseClient.from('mtb_organization').delete().eq('company_id', currentCompany['id'])
        // 删除操作履歴
        await supabaseClient.from('sys_log').delete().eq('company_id', currentCompany['id'])
        // 删除得意先マスタ
        await supabaseClient.from('mtb_customer').delete().eq('company_id', currentCompany['id'])
        // 删除納入先マスタ
        await supabaseClient.from('mtb_customer_address').delete().eq('company_id', currentCompany['id'])
        // 删除仕入先マスタ
        await supabaseClient.from('mtb_supplier').delete().eq('company_id', currentCompany['id'])
        // 删除荷主マスタ
        await supabaseClient.from('mtb_owner').delete().eq('company_id', currentCompany['id'])
        // 删除運送会社マスタ
        await supabaseClient.from('mtb_delivery').delete().eq('company_id', currentCompany['id'])
        // 删除倉庫マスタ
        await supabaseClient.from('mtb_warehouse').delete().eq('company_id', currentCompany['id'])
        // 删除ロケーションマスタ
        await supabaseClient.from('mtb_location').delete().eq('company_id', currentCompany['id'])
        // 删除採番マスタ
        await supabaseClient.from('mtb_number').delete().eq('company_id', currentCompany['id'])
        // 删除営業日マスタ
        await supabaseClient.from('mtb_calendar').delete().eq('company_id', currentCompany['id'])
        // 删除入荷予定
        await supabaseClient.from('dtb_receive').delete().eq('company_id', currentCompany['id'])
        // 删除出荷指示
        await supabaseClient.from('dtb_ship').delete().eq('company_id', currentCompany['id'])
        // 删除梱包
        await supabaseClient.from('dtb_packing_detail').delete().eq('company_id', currentCompany['id'])
        // 删除在庫
        await supabaseClient.from('dtb_store').delete().eq('company_id', currentCompany['id'])
        // 删除受払明細
        await supabaseClient.from('dtb_store_history').delete().eq('company_id', currentCompany['id'])
        // 删除棚卸
        await supabaseClient.from('dtb_inventory').delete().eq('company_id', currentCompany['id'])
        // 删除返品
        await supabaseClient.from('dtb_return').delete().eq('company_id', currentCompany['id'])
        // 删除在庫調整
        await supabaseClient.from('dtb_store_move').delete().eq('company_id', currentCompany['id'])
        // 更新会社情報マスタ状态为4 停止
        await supabaseClient.from('mtb_company').update({'status':'4'}).eq('id', currentCompany['id'])
      }
    }
  } catch (error) {
    // 返回响应
    return returnResponse(error);
  }

  // 返回响应
  return returnResponse('200');
})

// 返回响应
function returnResponse(message: string): Response {
  // 判断编码
  if (message == '200') {
    console.info('解約関連情報消去完了');
    return new Response('解約関連情報消去完了', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200 
    });
  } else {
    console.error(message);
    return new Response(message, { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400 
    });
  }
}

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
