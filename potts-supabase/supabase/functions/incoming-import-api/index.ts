// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

/**
 * 内容：入荷予定导入API
 * 作者：赵士淞
 * 时间：2023-12-12
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

  // 获取参数
  // companyId 公司ID
  // userId 用户ID
  // content 内容
  const { companyId, userId, content } = await req.json();

  try {
    // 内容字符串
    let contentString: string = content;
    contentString = contentString.replace(/\'/g, '\"');

    // 内容数组
    const contentArray: Array<Array<Map<string, any>>> = JSON.parse(contentString);

    // 判断内容长度
    if (contentArray.length == 0) {
      // 返回响应
      throw '410';
    }

    // 判断内容长度
    if (contentArray.length > 0 && contentArray.length < 3) {
      // 入荷予定列表
      let receiveList: Array<Map<string, any>> = [];
      // 入荷予定明细列表
      let receiveDetailList: Array<Map<string, any>> = [];

      // 判断内容长度
      if (contentArray.length == 1) {
        // 入荷予定列表
        receiveList = contentArray[0];
      } else if (contentArray.length == 2) {
        // 入荷予定列表
        receiveList = contentArray[0];
        // 入荷予定明细列表
        receiveDetailList = contentArray[1];
      }

      // 循环入荷予定列表
      for (let i: number = 0; i < receiveList.length; i ++) {
        // 入荷予定ID
        let receiveId: number = 0;
        // 入荷予定番号
        let receiveNo: string = '';
        // 当前入荷予定ID
        let currentReceiveId: number = 0;

        // 当前入荷予定
        let currentReceive: Map<string, any> = receiveList[i];
        // 判断当前入荷予定ID
        if (currentReceive['id'] != null && currentReceive['id'] != '') {
          // 当前入荷予定ID
          currentReceiveId = currentReceive['id'] as number;
          // 当前入荷予定ID
          currentReceive['id'] = '';
        }

        // 保存入荷予定表单验证
        let receiveStructure: Map<string, any> = saveReceiveFormCheck(currentReceive);
        // 判断验证结果
        if (receiveStructure.size == 0) {
          // 返回响应
          throw '411';
        }

        // 入荷予定
        let receive: Map<string, any> = receiveStructure;

        // 创建入荷予定表单处理
        receive = await createReceiveFormHandle(companyId, userId, receive);

        // 新增入荷予定
        let supabaseReceiveData: Array<Map<string, any>> = await supabaseClient.from('dtb_receive').insert([receive]).select('*');
        // 判断入荷予定是否异常
        if (supabaseReceiveData['error'] != null) {
          // 返回
          throw supabaseReceiveData['error']['message'];
        }
        // 入荷予定
        let receiveData: Array<any> = supabaseReceiveData['data'] != null ? supabaseReceiveData['data'] : [];
        
        // 判断入荷予定数据
        if (receiveData.length == 0) {
          // 返回响应
          throw '415';
        }
        // 入荷予定ID
        receiveId = receiveData[0]['id'];
        // 入荷予定番号
        receiveNo = receiveData[0]['receive_no'];

        // 循环入荷予定明细列表
        for (let j: number = 0; j < receiveDetailList.length; j ++) {
          // 判断当前入荷予定ID
          if (receiveDetailList[j]['receive_id'] != null && receiveDetailList[j]['receive_id'] != '' && receiveDetailList[j]['receive_id'] as number == currentReceiveId) {
            // 当前入荷予定明细
            let currentReceiveDetail: Map<string, any> = receiveDetailList[j];
            currentReceiveDetail['id'] = '';
            // 保存入荷予定明细表单验证
            let receiveDetailStructure: Map<string, any> = saveReceiveDetailFormCheck(currentReceiveDetail);
            // 判断验证结果
            if (receiveDetailStructure.size == 0) {
              // 返回响应
              throw '416';
            }

            // 检查商品ID
            await judgeProductId(companyId, currentReceiveDetail);

            let receiveDetail: Map<string, any> = new Map<string, any>();

            // 入荷予定明细
            receiveDetail = receiveDetailStructure;

            // 创建入荷予定明细表单处理
            receiveDetail = await createreceiveDetailFormHandle(companyId, receiveDetail, receiveId, receiveNo);
            
            // 新增入荷予定明细
            let supabaseReceiveDetailData: Map<string, any> = await supabaseClient.from('dtb_receive_detail').insert([receiveDetail]).select('*');
            // 判断入荷予定明细是否异常
            if (supabaseReceiveDetailData['error'] != null) {
              // 返回
              throw supabaseReceiveDetailData['error']['message'];
            }
            // 入荷予定明细
            let receiveDetailData: Array<any> = supabaseReceiveDetailData['data'] != null ? supabaseReceiveDetailData['data'] : [];
            
            // 判断入荷予定明细数据
            if (receiveDetailData.length == 0) {
              // 返回响应
              throw '418';
            }
          }
        }
      }
    } else {
      // 返回响应
      throw '419';
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
    console.info('インポート成功');
    return new Response('インポート成功', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200 
    });
  } else if (message == '410') {
    console.error('ファイルの内容が空です');
    return new Response('ファイルの内容が空です', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 410 
    });
  } else if (message == '411') {
    console.error('入荷予定内容チェックに失敗しました');
    return new Response('入荷予定内容チェックに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 411 
    });
  } else if (message == '412') {
    console.error('自動採番失敗');
    return new Response('自動採番失敗', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 412 
    });
  } else if (message == '413') {
    console.error('会社情報の読み取りに失敗しました');
    return new Response('会社情報の読み取りに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 413 
    });
  } else if (message == '414') {
    console.error('番号の更新に失敗しました');
    return new Response('番号の更新に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 414 
    });
  } else if (message == '415') {
    console.error('入荷予定の作成に失敗しました');
    return new Response('入荷予定の作成に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 415 
    });
  } else if (message == '416') {
    console.error('入荷予定詳細チェックに失敗しました');
    return new Response('入荷予定詳細チェックに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 416 
    });
  } else if (message == '417') {
    console.error('商品情報の読み取りに失敗しました');
    return new Response('商品情報の読み取りに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 417 
    });
  } else if (message == '418') {
    console.error('入荷予定詳細の作成に失敗しました');
    return new Response('入荷予定詳細の作成に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 418 
    });
  } else if (message == '419') {
    console.error('ファイルコンテンツがありません');
    return new Response('ファイルコンテンツがありません', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 419 
    });
  } else {
    console.error(message);
    return new Response(message, { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400 
    });
  }
}

// 保存入荷予定表单验证
function saveReceiveFormCheck(receiveStructure: Map<string, any>): Map<string, any> {
  // 判断是否为空
  if (receiveStructure['rcv_sch_date'] == null || receiveStructure['rcv_sch_date'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['order_no'] == null || receiveStructure['order_no'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['name'] == null || receiveStructure['name'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['name_kana'] == null || receiveStructure['name_kana'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['postal_cd'] == null || receiveStructure['postal_cd'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['addr_1'] == null || receiveStructure['addr_1'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['addr_2'] == null || receiveStructure['addr_2'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['addr_3'] == null || receiveStructure['addr_3'] == '') {
    return new Map<string, any>();
  } else if (receiveStructure['addr_tel'] == null || receiveStructure['addr_tel'] == '') {
    return new Map<string, any>();
  }

  // 处理入荷予定-结构
  if (receiveStructure['id'] == null || receiveStructure['id'] == '') {
    delete receiveStructure['id'];
  } else {
    receiveStructure['id'] = receiveStructure['id'] as number;
  }
  if (receiveStructure['supplier_id'] == null || receiveStructure['supplier_id'] == '') {
    delete receiveStructure['supplier_id'];
  } else {
    receiveStructure['supplier_id'] = receiveStructure['supplier_id'] as number;
  }
  if (receiveStructure['company_id'] == null || receiveStructure['company_id'] == '') {
    delete receiveStructure['company_id'];
  } else {
    receiveStructure['company_id'] = receiveStructure['company_id'] as number;
  }

  // 返回
  return receiveStructure;
}

// 创建入荷予定表单处理
async function createReceiveFormHandle(companyId: number, userId: number, receive: Map<string, any>): Promise<Map<string, any>> {
  try {
    // 获取自动采番连番
    let receiveNo: string = await selectNumber(companyId, 'A');
    // 入荷予定
    receive['receive_no'] = receiveNo;
    // 更新自动采番连番
    updateNumberSeqNo(companyId, 'A', receive['receive_no']!);
  } catch (error) {
    // 返回
    throw error;
  }

  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);

  // 入荷予定
  receive['receive_kbn'] = '1';
  receive['csv_kbn'] = '2';
  receive['company_id'] = companyId;
  receive['del_kbn'] = '2';
  receive['create_time'] = now;
  receive['create_id'] = userId;
  receive['update_time'] = now;
  receive['update_id'] = userId;

  // 返回
  return receive;
}

// 查询自动采番
async function selectNumber(companyId: number, wmsChannel: string): Promise<string> {
  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);
  // 当前年份
  let year: number = now.getFullYear();
  // 当前月份
  let month: number = now.getMonth() + 1;
  // 当前年月
  let yearMonth: string = year.toString() + (month < 10 ? '0' + month.toString() : month.toString());

  // 查询自动采番
  let supabaseNumber: Map<string, any> = await supabaseClient.from('mtb_number').select('*').eq('company_id', companyId).eq('wms_channel', wmsChannel).eq('year_month', yearMonth);
  // 判断自动采番是否异常
  if (supabaseNumber['error'] != null) {
    // 返回
    throw supabaseNumber['error']['message'];
  }
  // 自动采番
  let number: Array<any> = supabaseNumber['data'] != null ? supabaseNumber['data'] : [];

  // 判断自动采番数量
  if (number.length == 1) {
    // 自动采番
    let numberEntity: Map<string, any> = number[0];

    // 查询会社情报
    let supabseCompany: Map<string, any> = await supabaseClient.from('mtb_company').select('*').eq('id', companyId);
    // 判断会社情报是否异常
    if (supabseCompany['error'] != null) {
      // 返回
      throw supabseCompany['error']['message'];
    }
    // 会社情报
    let company: Array<any> = supabseCompany['data'] != null ? supabseCompany['data'] : [];

    // 判断会社情报数量
    if (company.length == 1) {
      // 会社情报
      let companyEntity: Map<string, any> = company[0];
      // 返回
      return companyEntity['name_short'] + '-' + wmsChannel + '-' + yearMonth + '-' + numberSupplement(numberEntity['seq_no'] + 1, 8);
    } else {
      // 返回
      throw '413';
    }
  } else {
    // 返回
    throw '412';
  }
}

// 番号补充
function numberSupplement(number: number, digit: number): string {
  // 番号字符串
  let numberString: string = number.toString();
  // 补充位数
  let supplementDigit: number = digit - numberString.length;
  // 补充
  let supplement: string = '';
  // 判断补充位数
  if (supplementDigit > 0) {
    // 循环补充位数
    for (let i: number = 0; i < supplementDigit; i ++) {
      // 补充
      supplement += '0';
    }
  }
  // 返回
  return supplement + number.toString();
}

// 更新自动采番连番
async function updateNumberSeqNo(companyId: number, wmsChannel: string, no: string): Promise<void> {
  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);
  // 当前年份
  let year: number = now.getFullYear();
  // 当前月份
  let month: number = now.getMonth() + 1;
  // 当前年月
  let yearMonth: string = year.toString() + (month < 10 ? '0' + month.toString() : month.toString());
  
  // 查询自动采番
  let supabaseNumber: Map<string, any> = await supabaseClient.from('mtb_number').select('*').eq('company_id', companyId).eq('wms_channel', wmsChannel).eq('year_month', yearMonth);
  // 判断自动采番是否异常
  if (supabaseNumber['error'] != null) {
    // 返回
    throw supabaseNumber['error']['message'];
  }
  // 自动采番
  let number: Array<any> = supabaseNumber['data'] != null ? supabaseNumber['data'] : [];
  
  // 判断自动采番数量
  if (number.length == 1) {
    // 自动采番
    let numberEntity: Map<string, any> = number[0];

    // 番号编码
    let noCode: number = parseInt(no.substring(no.lastIndexOf('-') + 1));
    // 比较两者
    if (noCode > numberEntity['seq_no']!) {
      // 自动采番
      numberEntity['seq_no'] = noCode;
      // 修改自动采番
      let supabaseNumberUpdate: Map<string, any> = await supabaseClient.from('mtb_number').update(numberEntity).eq('id', numberEntity['id']).select('*');
      // 判断自动采番是否异常
      if (supabaseNumberUpdate['error'] != null) {
        // 返回
        throw supabaseNumberUpdate['error']['message'];
      }
      // 自动采番
      let numberUpdate: Array<any> = supabaseNumberUpdate['data'] != null ? supabaseNumberUpdate['data'] : [];

      // 判断自动采番数量
      if (numberUpdate.length == 0) {
        // 返回
        throw '414';
      }
    }
  } else {
    // 返回
    throw '412';
  }
}

// 保存入荷予定明细表单验证
function saveReceiveDetailFormCheck(receiveDetailStructure: Map<string, any>): Map<string, any> {
  // 判断是否为空
  if (receiveDetailStructure['product_id'] == null || receiveDetailStructure['product_id'] == '') {
    return new Map<string, any>();
  } else if (receiveDetailStructure['product_num'] == null || receiveDetailStructure['product_num'] == '') {
    return new Map<string, any>();
  } else if (receiveDetailStructure['product_price'] == null || receiveDetailStructure['product_price'] == '') {
    return new Map<string, any>();
  }

  // 处理入荷予定明细-结构
  if (receiveDetailStructure['id'] == null || receiveDetailStructure['id'] == '') {
    delete receiveDetailStructure['id'];
  } else {
    receiveDetailStructure['id'] = receiveDetailStructure['id'] as number;
  }
  if (receiveDetailStructure['receive_id'] == null || receiveDetailStructure['receive_id'] == '') {
    delete receiveDetailStructure['receive_id'];
  } else {
    receiveDetailStructure['receive_id'] = receiveDetailStructure['receive_id'] as number;
  }
  if (receiveDetailStructure['product_id'] == null || receiveDetailStructure['product_id'] == '') {
    delete receiveDetailStructure['product_id'];
  } else {
    receiveDetailStructure['product_id'] = receiveDetailStructure['product_id'] as number;
  }
  if (receiveDetailStructure['product_num'] == null || receiveDetailStructure['product_num'] == '') {
    delete receiveDetailStructure['product_num'];
  } else {
    receiveDetailStructure['product_num'] = receiveDetailStructure['product_num'] as number;
  }
  if (receiveDetailStructure['product_price'] == null || receiveDetailStructure['product_price'] == '') {
    delete receiveDetailStructure['product_price'];
  } else {
    receiveDetailStructure['product_price'] = receiveDetailStructure['product_price'] as number;
  }
  if (receiveDetailStructure['store_num'] == null || receiveDetailStructure['store_num'] == '') {
    delete receiveDetailStructure['store_num'];
  } else {
    receiveDetailStructure['store_num'] = receiveDetailStructure['store_num'] as number;
  }
  if (receiveDetailStructure['check_num'] == null || receiveDetailStructure['check_num'] == '') {
    delete receiveDetailStructure['check_num'];
  } else {
    receiveDetailStructure['check_num'] = receiveDetailStructure['check_num'] as number;
  }

  // 返回
  return receiveDetailStructure;
}

// 检查商品ID
async function judgeProductId(companyId: number, receiveDetailStructure: Map<string, any>): Promise<void> {
  // 查询商品信息
  let supabaseProductData = await supabaseClient.from('mtb_product').select('*').eq('id', receiveDetailStructure['product_id']).eq('company_id', companyId).eq('del_kbn', '2');
  // 判断商品是否异常
  if (supabaseProductData['error'] != null) {
    // 返回
    throw supabaseProductData['error']['message'];
  }
  // 商品
  let productData: Array<any> = supabaseProductData['data'] != null ? supabaseProductData['data'] : [];
  
  // 判断商品数量
  if (productData.length == 0) {
    // 返回
    throw '417';
  }
}

// 创建入荷予定明细表单处理
async function createreceiveDetailFormHandle(userId: number, receiveDetail: Map<string, any>, receiveId: number, receiveNo: string): Promise<Map<string, any>> {
  // 番号
  let lineNo: string = '001';
  // 查询入荷予定明细
  let supabaseReceiveDetailData: Map<string, any> = await supabaseClient.from('dtb_receive_detail').select('*').eq('receive_id', receiveId).order('id', { ascending: false });
  // 判断入荷予定明细是否异常
  if (supabaseReceiveDetailData['error'] != null) {
    // 返回
    throw supabaseReceiveDetailData['error']['message'];
  }
  // 入荷予定明细
  let receiveDetailData: Array<any> = supabaseReceiveDetailData['data'] != null ? supabaseReceiveDetailData['data'] : [];
  
  // 判断入荷予定明细长度
  if (receiveDetailData.length != 0) {
    // 上一个入荷予定明细番号
    let lastReceiveLineNo: string = receiveDetailData[0]['receive_line_no'];
    // 判断上一个入荷予定明细番号
    if (lastReceiveLineNo != null && lastReceiveLineNo != '') {
      // 上一个番号
      let lastLineNo: number = parseInt(lastReceiveLineNo.substring(lastReceiveLineNo.length - 3, lastReceiveLineNo.length));
      // 当前番号
      let nowLineNo: number = lastLineNo + 1;
      // 判断当前番号
      if (nowLineNo < 10) {
        // 番号
        lineNo = '00' + nowLineNo.toString();
      } else if (lastLineNo < 100) {
        // 番号
        lineNo = '0' + nowLineNo.toString();
      } else {
        // 番号
        lineNo = nowLineNo.toString();
      }
    }
  }

  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);

  // 入荷予定明细
  receiveDetail['receive_id'] = receiveId;
  receiveDetail['receive_line_no'] = receiveNo + lineNo;
  receiveDetail['store_kbn'] = '2';
  receiveDetail['check_kbn'] = '2';
  receiveDetail['confirm_kbn'] = '2';
  receiveDetail['del_kbn'] = '2';
  receiveDetail['create_time'] = now;
  receiveDetail['create_id'] = userId;
  receiveDetail['update_time'] = now;
  receiveDetail['update_id'] = userId;

  // 返回
  return receiveDetail;
}

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
