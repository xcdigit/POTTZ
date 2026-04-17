// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

/**
 * 内容：棚卸导出API
 * 作者：赵士淞
 * 时间：2023-12-20
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

// 返回数据
let returnData: Array<any> = [];

serve(async (req) => {
  // 跨域处理
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  // 获取参数
  // companyId 公司ID
  // title 标题
  const { companyId, title } = await req.json();

  // 返回数据
  returnData = [];

  try {
    // 标题字符串
    let titleString: string = title;
    titleString = titleString.replace(/\'/g, '\"');

    // 标题数组
    const titleArray: Array<string> = JSON.parse(titleString);

    // 判断标题长度
    if (titleArray.length == 0) {
      // 返回响应
      throw '410';
    }

    // 查询棚卸
    let supabseInventoryData: Map<string, any> = await supabaseClient.from('dtb_inventory').select('*').eq('confirm_flg', '1').eq('del_kbn', '2').eq('csv_kbn', '2').eq('company_id', companyId);
    // 判断棚卸是否异常
    if (supabseInventoryData['error'] != null) {
      // 返回
      throw supabseInventoryData['error']['message'];
    }
    // 棚卸
    let inventoryData: Array<any> = supabseInventoryData['data'] != null ? supabseInventoryData['data'] : [];

    // 判断棚卸数量
    if (inventoryData.length == 0) {
      // 返回
      throw '411';
    }

    // 循环棚卸
    for (let i: number = 0; i < inventoryData.length; i ++) {
      // 当前棚卸
      let currentInventory: Map<string, any> = inventoryData[i];

      // 更新棚卸
      let supabseInventoryUpdateData: Map<string, any> = await supabaseClient.from('dtb_inventory').update({'csv_kbn': '1'}).eq('id', currentInventory['id']).select('*');
      // 判断棚卸是否异常
      if (supabseInventoryUpdateData['error'] != null) {
        // 返回
        throw supabseInventoryUpdateData['error']['message'];
      }
      // 棚卸
      let inventoryUpdateData: Array<any> = supabseInventoryUpdateData['data'] != null ? supabseInventoryUpdateData['data'] : [];

      // 判断棚卸数量
      if (inventoryUpdateData.length == 0) {
        // 返回
        throw '412';
      }

      // 返回单项
      let returnItem: Map<string, any> = new Map<string, any>();
      // 循环标题
      for (let j: number = 0; j < titleArray.length; j ++) {
        // 当前标题
        let currentTitle: string = titleArray[j];

        // 返回单项
        returnItem[currentTitle] = currentInventory[currentTitle];
      }
      // 返回数据
      returnData.push(returnItem);
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
    console.info(JSON.stringify(returnData));
    return new Response(JSON.stringify(returnData), { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200 
    });
  } else if (message == '410') {
    console.error('タイトルパラメータを空にすることはできません');
    return new Response('タイトルパラメータを空にすることはできません', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 410 
    });
  } else if (message == '411') {
    console.error('エクスポート可能なデータがありません');
    return new Response('エクスポート可能なデータがありません', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 411 
    });
  } else if (message == '412') {
    console.error('連携済の更新に失敗しました');
    return new Response('連携済の更新に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 412 
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
