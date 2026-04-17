// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

console.info("Insert-mtb-number!")

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

/*   月次处理边缘函数
     更新表mtb_number
*/
serve(async (req) => {
  //参数取得
  // const { name } = await req.json()
  try {
    // Create a Supabase client
    const supabaseClient = createClient(
      // Supabase API URL - env var exported by default.
       'https://culnohqxtcpbghvuvetv.supabase.co',
      // Supabase API ANON KEY - env var exported by default.
       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1bG5vaHF4dGNwYmdodnV2ZXR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTA1MzE4MzEsImV4cCI6MjAwNjEwNzgzMX0.wH_RUm0RgO846tIsEnDBu04Zl1MIS0snPoTznZyrPjw'
      //Supabase API URL Online
      //'https://oianbeiuiprnkxybukox.supabase.co',
      // Supabase API ANON KEY Online
      //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9pYW5iZWl1aXBybmt4eWJ1a294Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwNzkwODUsImV4cCI6MjAzNTY1NTA4NX0.9hMbxOpboz0Fx4Xf6abG8XALkxF8YTcJrI62Q9zZbsc'
    )

    // 获取前月日期（当前supabase时间为UTC时间，需要转成东九区时间）
    const currentDate = new Date();
    currentDate.setUTCHours(currentDate.getUTCHours() + 9);
    console.log("当前日本时间：" + currentDate)
    //判断当前时间是日本时间1号
    if (currentDate.getUTCDate() != 1) {
      throw "Not yet until next month"
    }
    // console.log(currentDate)
    // 上个月的年月
    let lastYearMonth;
    // 当前年月
    let currentYearMonth;
    if (currentDate.getUTCMonth() == 0) {
      lastYearMonth = (currentDate.getUTCFullYear() - 1).toString() + "12"
      currentYearMonth = currentDate.getUTCFullYear().toString() + "01";
    } else if (currentDate.getUTCMonth() < 10) {
      lastYearMonth = currentDate.getUTCFullYear().toString() + "0" + currentDate.getUTCMonth().toString();
      currentYearMonth = currentDate.getUTCFullYear().toString() + (currentDate.getUTCMonth() == 9 ? "10" : "0" + (currentDate.getUTCMonth() + 1).toString());
    } else {
      lastYearMonth = currentDate.getUTCFullYear().toString() + currentDate.getUTCMonth().toString();
      currentYearMonth = currentDate.getUTCFullYear().toString() + (currentDate.getUTCMonth() + 1).toString();
    }

    console.log(lastYearMonth);
    console.log(currentYearMonth);

    //查询当前是否存在数据
    const currentResult = await supabaseClient.from('mtb_number').select('*').eq("year_month", currentYearMonth);
    // console.log(currentResult);
    if (currentResult.error) throw currentResult.error
    if (currentResult.data != null && currentResult.data.length > 0) {
      throw "Current month data exists"
    }

    //查询上个月数据
    const { data, error } = await supabaseClient.from('mtb_number').select('*').eq("year_month", lastYearMonth);
    // console.log(data);
    if (error) throw error
    if (data == null || data.length == 0) {
      throw "Last month's data does not exist"
    } else {
      console.log("Insert new month data!")
      console.log("size:" + data.length)
      //循环插入当月採番数据
      data.forEach(item => {
        //设定当月时间
        item["year_month"] = currentYearMonth;
        //设置採番初始值
        item["seq_no"] = 1;
        //设置创建时间
        item["create_time"] = currentDate;
        //设置更新时间
        item["update_time"] = currentDate;
        //删除主键值
        delete item["id"];
      });
    }
    //插入表数据
    const InsertResult = await supabaseClient.from('mtb_number').insert(data).select('*');
    if (InsertResult.error) throw InsertResult.error

    console.info("insert mtb_number success")
    return new Response("insert mtb_number success", {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (e) {
    console.error("insert mtb_number error:" + (e.message != null && e.message != undefined ? e.message : e));
    return new Response("insert mtb_number error:" + (e.message != null && e.message != undefined ? e.message : e), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
