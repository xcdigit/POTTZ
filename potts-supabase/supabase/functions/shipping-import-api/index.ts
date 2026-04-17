// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

/**
 * 内容：出荷指示导入API
 * 作者：赵士淞
 * 时间：2023-12-11
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
      // 出荷指示列表
      let shipList: Array<Map<string, any>> = [];
      // 出荷指示明细列表
      let shipDetailList: Array<Map<string, any>> = [];

      // 判断内容长度
      if (contentArray.length == 1) {
        // 出荷指示列表
        shipList = contentArray[0];
      } else if (contentArray.length == 2) {
        // 出荷指示列表
        shipList = contentArray[0];
        // 出荷指示明细列表
        shipDetailList = contentArray[1];
      }

      // 循环出荷指示列表
      for (let i: number = 0; i < shipList.length; i ++) {
        // 出荷指示ID
        let shipId: number = 0;
        // 出荷指示番号
        let shipNo: string = '';
        // 当前出荷指示ID
        let currentShipId: number = 0;

        // 当前出荷指示
        let currentShip: Map<string, any> = shipList[i];
        // 判断当前出荷指示ID
        if (currentShip['id'] != null && currentShip['id'] != '') {
          // 当前出荷指示ID
          currentShipId = currentShip['id'] as number;
          // 当前出荷指示ID
          currentShip['id'] = '';
        }
        
        // 保存出荷指示表单验证
        let shipStructure: Map<string, any> = saveShipFormCheck(currentShip);
        // 判断验证结果
        if (shipStructure.size == 0) {
          // 返回响应
          throw '411';
        }

        // 出荷指示
        let ship: Map<string, any> = shipStructure;

        // 创建出荷指示表单处理
        ship = await createShipFormHandle(companyId, userId, ship);
          
        // 新增出荷指示
        let supabseShipData: Map<string, any> = await supabaseClient.from('dtb_ship').insert([ship]).select('*');
        // 判断出荷指示是否异常
        if (supabseShipData['error'] != null) {
          // 返回
          throw supabseShipData['error']['message'];
        }
        // 出荷指示
        let shipData: Array<any> = supabseShipData['data'] != null ? supabseShipData['data'] : [];
        // 判断出荷指示数据
        if (shipData.length == 0) {
          // 返回
          throw '414';
        }
        // 出荷指示ID
        shipId = shipData[0]['id'];
        // 出荷指示番号
        shipNo = shipData[0]['ship_no'];

        // 循环出荷指示明细列表
        for (let j: number = 0; j < shipDetailList.length; j ++) {
          // 判断当前出荷指示ID
          if (shipDetailList[j]['ship_id'] != null && shipDetailList[j]['ship_id'] != '' && shipDetailList[j]['ship_id'] as number == currentShipId) {
            // 当前出荷指示明细
            let currentShipDetail: Map<string, any> = shipDetailList[j];
            currentShipDetail['id'] = '';

            // 保存出荷指示明细表单验证
            let shipDetailStructure: Map<string, any> = saveShipDetailFormCheck(currentShipDetail);
            // 判断验证结果
            if (shipDetailStructure.size == 0) {
              // 出荷指示导入异常字段更新
              let supabseShipUpdateData: Map<string, any> = await supabaseClient.from('dtb_ship').update({'importerror_flg': 5}).eq('id', shipId).select('*');
              // 判断出荷指示是否异常
              if (supabseShipUpdateData['error'] != null) {
                // 返回
                throw supabseShipUpdateData['error']['message'];
              }
              // 出荷指示
              let shipUpdateData: Array<any> = supabseShipUpdateData['data'] != null ? supabseShipUpdateData['data'] : [];

              // 判断出荷指示数据
              if (shipUpdateData.length == 0) {
                // 返回
                throw '416';
              }

              // 返回
              throw '415';
            }

            // 出荷指示明细
            let shipDetail: Map<string, any> = shipDetailStructure;

            // 创建出荷指示明细表单处理
            shipDetail = await createShipDetailFormHandle(shipId, shipNo, userId, shipDetail);

            // 查询商品
            let supabaseProductData = await supabaseClient.from('mtb_product').select('*').eq('id', shipDetail['product_id']).eq('company_id', companyId);
            // 判断商品是否异常
            if (supabaseProductData['error'] != null) {
              // 返回
              throw supabaseProductData['error']['message'];
            }
            // 商品
            let productData: Array<any> = supabaseProductData['data'] != null ? supabaseProductData['data'] : [];
            // 判断商品数据
            if (productData.length == 0) {
              // 出荷指示导入异常字段更新
              let supabseShipUpdateData: Map<string, any> = await supabaseClient.from('dtb_ship').update({'importerror_flg': 1}).eq('id', shipId).select('*');
              // 判断出荷指示是否异常
              if (supabseShipUpdateData['error'] != null) {
                // 返回
                throw supabseShipUpdateData['error']['message'];
              }
              // 出荷指示
              let shipUpdateData: Array<any> = supabseShipUpdateData['data'] != null ? supabseShipUpdateData['data'] : [];

              // 判断出荷指示数据
              if (shipUpdateData.length == 0) {
                // 返回
                throw '416';
              }

              // 返回
              throw '417';
            }

            // 新增出荷指示明细
            let supabaseShipDetailData = await supabaseClient.from('dtb_ship_detail').insert([shipDetail]).select('*');
            // 判断出荷指示明细是否异常
            if (supabaseShipDetailData['error'] != null) {
              // 返回
              throw supabaseShipDetailData['error']['message'];
            }
            // 出荷指示明细
            let shipDetailData: Array<any> = supabaseShipDetailData['data'] != null ? supabaseShipDetailData['data'] : [];
            // 判断出荷指示明细数据
            if (shipDetailData.length == 0) {
              // 出荷指示导入异常字段更新
              let supabseShipUpdateData: Map<string, any> = await supabaseClient.from('dtb_ship').update({'importerror_flg': 4}).eq('id', shipId).select('*');
              // 判断出荷指示是否异常
              if (supabseShipUpdateData['error'] != null) {
                // 返回
                throw supabseShipUpdateData['error']['message'];
              }
              // 出荷指示
              let shipUpdateData: Array<any> = supabseShipUpdateData['data'] != null ? supabseShipUpdateData['data'] : [];

              // 判断出荷指示数据
              if (shipUpdateData.length == 0) {
                // 返回
                throw '416';
              }

              // 返回
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
    console.error('出荷指示内容チェックに失敗しました');
    return new Response('出荷指示内容チェックに失敗しました', { 
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
    console.error('出荷指示の作成に失敗しました');
    return new Response('出荷指示の作成に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 414 
    });
  } else if (message == '415') {
    console.error('出荷指示詳細チェックに失敗しました');
    return new Response('出荷指示詳細チェックに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 415 
    });
  } else if (message == '416') {
    console.error('出荷指示の更新に失敗しました');
    return new Response('出荷指示の更新に失敗しました', { 
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
    console.error('出荷指示詳細の作成に失敗しました');
    return new Response('出荷指示詳細の作成に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 418 
    });
  } else if (message == '419') {
    console.error('ファイルコンテンツがありません');
    return new Response('ファイルコンテンツがありません', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 419 
    });
  } else if (message == '420') {
    console.error('番号の更新に失敗しました');
    return new Response('番号の更新に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 420 
    });
  } else {
    console.error(message);
    return new Response(message, { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400 
    });
  }
}

// 保存出荷指示表单验证
function saveShipFormCheck(shipStructure: Map<string, any>): Map<string, any> {
  // 判断是否为空
  if (shipStructure['rcv_sch_date'] == null || shipStructure['rcv_sch_date'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['cus_rev_date'] == null || shipStructure['cus_rev_date'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_name'] == null || shipStructure['customer_name'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_name_kana'] == null || shipStructure['customer_name_kana'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_postal_cd'] == null || shipStructure['customer_postal_cd'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_addr_1'] == null || shipStructure['customer_addr_1'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_addr_2'] == null || shipStructure['customer_addr_2'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_addr_3'] == null || shipStructure['customer_addr_3'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['customer_tel'] == null || shipStructure['customer_tel'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['name'] == null || shipStructure['name'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['name_kana'] == null || shipStructure['name_kana'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['postal_cd'] == null || shipStructure['postal_cd'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['addr_1'] == null || shipStructure['addr_1'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['addr_2'] == null || shipStructure['addr_2'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['addr_3'] == null || shipStructure['addr_3'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['addr_tel'] == null || shipStructure['addr_tel'] == '') {
    return new Map<string, any>();
  } else if (shipStructure['person'] == null || shipStructure['person'] == '') {
    return new Map<string, any>();
  }

  // 处理出荷指示-结构
  if (shipStructure['id'] == null || shipStructure['id'] == '') {
    delete shipStructure['id'];
  } else {
    shipStructure['id'] = shipStructure['id'] as number;
  }
  if (shipStructure['delivery_company_id'] == null || shipStructure['delivery_company_id'] == '') {
    delete shipStructure['delivery_company_id'];
  } else {
    shipStructure['delivery_company_id'] = shipStructure['delivery_company_id'] as number;
  }
  if (shipStructure['customer_id'] == null || shipStructure['customer_id'] == '') {
    delete shipStructure['customer_id'];
  } else {
    shipStructure['customer_id'] = shipStructure['customer_id'] as number;
  }
  if (shipStructure['customer_addr_id'] == null || shipStructure['customer_addr_id'] == '') {
    delete shipStructure['customer_addr_id'];
  } else {
    shipStructure['customer_addr_id'] = shipStructure['customer_addr_id'] as number;
  }

  // 返回
  return shipStructure;
}

// 创建出荷指示表单处理
async function createShipFormHandle(companyId: number, userId: number, ship: Map<string, any>): Promise<Map<string, any>> {
  try {
    // 获取自动采番连番
    let shipNo: string = await selectNumber(companyId, 'B');
    // 出荷指示
    ship['ship_no'] = shipNo;
    // 更新自动采番连番
    updateNumberSeqNo(companyId, 'B', ship['ship_no']!);
  } catch (error) {
    // 返回
    throw error;
  }

  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);

  // 出荷指示
  ship['ship_kbn'] = '1';
  ship['pick_list_kbn'] = '2';
  ship['pdf_kbn'] = '1';
  ship['csv_kbn'] = '2';
  ship['company_id'] = companyId;
  ship['del_kbn'] = '2';
  ship['create_time'] = now;
  ship['create_id'] = userId;
  ship['update_time'] = now;
  ship['update_id'] = userId;

  // 返回
  return ship;
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
        throw '420';
      }
    }
  } else {
    // 返回
    throw '412';
  }
}

// 保存出荷指示明细表单验证
function saveShipDetailFormCheck(shipDetailStructure: Map<string, any>): Map<string, any> {
  // 判断是否为空
  if (shipDetailStructure['product_id'] == null || shipDetailStructure['product_id'] == '') {
    return new Map<string, any>();
  } else if (shipDetailStructure['product_price'] == null || shipDetailStructure['product_price'] == '') {
    return new Map<string, any>();
  } else if (shipDetailStructure['ship_num'] == null || shipDetailStructure['ship_num'] == '') {
    return new Map<string, any>();
  }

  // 处理出荷指示明细-结构
  if (shipDetailStructure['id'] == null || shipDetailStructure['id'] == '') {
    delete shipDetailStructure['id'];
  } else {
    shipDetailStructure['id'] = shipDetailStructure['id'] as number;
  }
  if (shipDetailStructure['ship_id'] == null || shipDetailStructure['ship_id'] == '') {
    delete shipDetailStructure['ship_id'];
  } else {
    shipDetailStructure['ship_id'] = shipDetailStructure['ship_id'] as number;
  }
  if (shipDetailStructure['product_id'] == null || shipDetailStructure['product_id'] == '') {
    delete shipDetailStructure['product_id'];
  } else {
    shipDetailStructure['product_id'] = shipDetailStructure['product_id'] as number;
  }
  if (shipDetailStructure['ship_num'] == null || shipDetailStructure['ship_num'] == '') {
    delete shipDetailStructure['ship_num'];
  } else {
    shipDetailStructure['ship_num'] = shipDetailStructure['ship_num'] as number;
  }
  if (shipDetailStructure['product_price'] == null || shipDetailStructure['product_price'] == '') {
    delete shipDetailStructure['product_price'];
  } else {
    shipDetailStructure['product_price'] = shipDetailStructure['product_price'] as number;
  }
  if (shipDetailStructure['location_id'] == null || shipDetailStructure['location_id'] == '') {
    delete shipDetailStructure['location_id'];
  } else {
    shipDetailStructure['location_id'] = shipDetailStructure['location_id'] as number;
  }
  if (shipDetailStructure['lock_num'] == null || shipDetailStructure['lock_num'] == '') {
    delete shipDetailStructure['lock_num'];
  } else {
    shipDetailStructure['lock_num'] = shipDetailStructure['lock_num'] as number;
  }
  if (shipDetailStructure['store_num'] == null || shipDetailStructure['store_num'] == '') {
    delete shipDetailStructure['store_num'];
  } else {
    shipDetailStructure['store_num'] = shipDetailStructure['store_num'] as number;
  }
  if (shipDetailStructure['check_num'] == null || shipDetailStructure['check_num'] == '') {
    delete shipDetailStructure['check_num'];
  } else {
    shipDetailStructure['check_num'] = shipDetailStructure['check_num'] as number;
  }
  if (shipDetailStructure['packing_num'] == null || shipDetailStructure['packing_num'] == '') {
    delete shipDetailStructure['packing_num'];
  } else {
    shipDetailStructure['packing_num'] = shipDetailStructure['packing_num'] as number;
  }

  // 返回
  return shipDetailStructure;
}

// 创建出荷指示明细表单处理
async function createShipDetailFormHandle(shipId: number, shipNo: string, userId: number, shipDetail: Map<string, any>): Promise<Map<string, any>> {
  // 番号
  let lineNo: string = '001';

  // 查询出荷指示明细
  let supabaseShipDetail: Map<string, any> = await supabaseClient.from('dtb_ship_detail').select('*').eq('ship_id', shipId).order('id', { ascending: false });
  // 判断出荷指示明细是否异常
  if (supabaseShipDetail['error'] != null) {
    // 返回
    throw supabaseShipDetail['error']['message'];
  }
  // 出荷指示明细
  let shipDetailData: Array<any> = supabaseShipDetail['data'] != null ? supabaseShipDetail['data'] : [];

  // 判断出荷指示明细长度
  if (shipDetailData.length != 0) {
    // 上一个出荷指示明细番号
    let lastShipLineNo: string = shipDetailData[0]['ship_line_no'];
    // 判断上一个出荷指示明细番号
    if (lastShipLineNo != null && lastShipLineNo != '') {
      // 上一个番号
      let lastLineNo: number = parseInt(lastShipLineNo.substring(lastShipLineNo.length - 3, lastShipLineNo.length));
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

  // 出荷指示明细
  shipDetail['ship_id'] = shipId;
  shipDetail['ship_line_no'] = shipNo + lineNo;
  shipDetail['lock_kbn'] = '0';
  shipDetail['store_kbn'] = '2';
  shipDetail['check_kbn'] = '2';
  shipDetail['packing_kbn'] = '2';
  shipDetail['confirm_kbn'] = '2';
  shipDetail['del_kbn'] = '2';
  shipDetail['create_time'] = now;
  shipDetail['create_id'] = userId;
  shipDetail['update_time'] = now;
  shipDetail['update_id'] = userId;

  // 返回
  return shipDetail;
}

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
