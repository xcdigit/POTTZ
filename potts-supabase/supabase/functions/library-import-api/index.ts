// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

/**
 * 内容：在库导入API
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
      // 在库列表
      let storeList: Array<Map<string, any>> = [];
      // 商品在库位置列表
      let productLocationList: Array<Map<string, any>> = [];

      // 判断内容长度
      if (contentArray.length == 2) {
        // 在库列表
        storeList = contentArray[0];
        // 商品在库位置列表
        productLocationList = contentArray[1];
      } else {
        // 返回响应
        throw '411'
      }

      // 循环商品在库位置列表
      for (let i: number = 0; i < productLocationList.length; i ++) {
        // 在库ID
        let storeId: number = 0;
        // 当前在库ID
        let currentStockId: number = 0;

        // 商品在库位置-结构
        let productLocationStructure: Map<string, any> = saveProductLocationFormCheck(productLocationList[i]);
        // 判断验证结果
        if (productLocationStructure.size == 0) {
          // 返回响应
          throw '412';
        }

        // 当前在库ID
        currentStockId = productLocationStructure['stock_id'];

        // 在库-结构
        let storeStructure: Map<string, any> = new Map<string, any>();
        // 循环在库列表
        for (let j: number = 0; j < storeList.length; j ++) {
          // 判断是否一致
          if (currentStockId.toString() == storeList[j]['id']) {
            // 在库-结构
            storeStructure = saveStoreFormCheck(storeList[j]);
            break;
          }
        }
        // 判断验证结果
        if (storeStructure.size == 0) {
          // 返回响应
          throw '413';
        }

        // 查询位置
        let supabaseLocationData: Map<string, any> = await supabaseClient.from('mtb_location').select('*').eq('id', productLocationStructure['location_id']);
        // 判断位置是否异常
        if (supabaseLocationData['error'] != null) {
          // 返回
          throw supabaseLocationData['error']['message'];
        }
        // 位置
        let locationData: Array<any> = supabaseLocationData['data'] != null ? supabaseLocationData['data'] : [];
        // 判断位置数据
        if (locationData.length == 0) {
          // 返回响应
          throw '414';
        }

        // 查询商品
        let supabaseProductData: Map<string, any> = await supabaseClient.from('mtb_product').select('*').eq('id', productLocationStructure['product_id']);
        // 判断商品是否异常
        if (supabaseProductData['error'] != null) {
          // 返回
          throw supabaseProductData['error']['message'];
        }
        // 商品
        let productData: Array<any> = supabaseProductData['data'] != null ? supabaseProductData['data'] : [];
        // 判断商品数据
        if (productData.length == 0) {
          // 返回响应
          throw '415';
        }

        // 查询商品在库位置
        let supabaseProductLocationTemp: Map<string, any> = await supabaseClient.from('dtb_product_location').select('*').eq('location_id', productLocationStructure['location_id']).eq('product_id', productLocationStructure['product_id']);
        // 判断商品在库位置是否异常
        if (supabaseProductLocationTemp['error'] != null) {
          // 返回
          throw supabaseProductLocationTemp['error']['message'];
        }
        // 商品在库位置
        let productLocationTemp: Array<any> = supabaseProductLocationTemp['data'] != null ? supabaseProductLocationTemp['data'] : [];
        // 判断商品在库位置数量
        if (productLocationTemp.length == 0) {
          // 在库
          let store: Map<string, any> = storeStructure;
          // 创建在库表单处理
          store = createStoreFormHandle(companyId, userId, store);

          // 在库数据
          let supabaseStoreData: Map<string, any> = await supabaseClient.from('dtb_store').insert([store]).select('*');
          // 判断在库是否异常
          if (supabaseStoreData['error'] != null) {
            // 返回
            throw supabaseStoreData['error']['message'];
          }
          // 在库
          let storeData: Array<any> = supabaseStoreData['data'] != null ? supabaseStoreData['data'] : [];
          // 判断在库数据
          if (storeData.length == 0) {
            // 返回响应
            throw '416';
          }
          // 在库ID
          storeId = storeData[0]['id'];

          // 商品在库位置
          let productLocation: Map<string, any> = productLocationStructure;
          productLocation['stock_id'] = storeId;
          // 创建商品在库位置表单处理
          productLocation = createProductLocationFormHandle(userId, productLocation);

          // 商品在库位置数据
          let supabaseProductLocationData: Map<string, any> = await supabaseClient.from('dtb_product_location').insert([productLocation]).select('*');
          // 判断商品在库位置是否异常
          if (supabaseProductLocationData['error'] != null) {
            // 返回
            throw supabaseProductLocationData['error']['message'];
          }
          // 商品在库位置
          let productLocationData: Array<any> = supabaseProductLocationData['data'] != null ? supabaseProductLocationData['data'] : [];
          // 判断商品在库位置数据
          if (productLocationData.length == 0) {
            // 返回响应
            throw '417';
          }
        } else {
          // 商品在库位置
          let productLocation: Map<string, any> = productLocationTemp[0];
          // 更新商品在库位置表单处理
          productLocation = updateProductLocationFormHandle(userId, productLocation, productLocationStructure);

          // 商品在库位置数据
          let supabaseProductLocationData: Map<string, any> = await supabaseClient.from('dtb_product_location').update(productLocation).eq('id', productLocation['id']).select('*');          
          // 判断商品在库位置是否异常
          if (supabaseProductLocationData['error'] != null) {
            // 返回
            throw supabaseProductLocationData['error']['message'];
          }
          // 商品在库位置
          let productLocationData: Array<any> = supabaseProductLocationData['data'] != null ? supabaseProductLocationData['data'] : [];
          // 判断商品在库位置数据
          if (productLocationData.length == 0) {
            // 返回响应
            throw '418';
          }
          // 在库ID
          storeId = productLocationData[0]['stock_id'];

          // 查询在库
          let supabaseStoreTemp: Map<string, any> = await supabaseClient.from('dtb_store').select('*').eq('id', storeId);
          // 判断在库是否异常
          if (supabaseStoreTemp['error'] != null) {
            // 返回
            throw supabaseStoreTemp['error']['message'];
          }
          // 在库
          let storeTemp: Array<any> = supabaseStoreTemp['data'] != null ? supabaseStoreTemp['data'] : [];
          // 判断在库数量
          if (storeTemp.length != 0) {
            // 在库
            let store: Map<string, any> = storeTemp[0];
            // 更新在库表单处理
            store = updateStoreFormHandle(userId, store, storeStructure);

            // 在库数据
            let supabaseStoreData: Map<string, any> = await supabaseClient.from('dtb_store').update(store).eq('id', store['id']).select('*');
            // 判断在库是否异常
            if (supabaseStoreData['error'] != null) {
              // 返回
              throw supabaseStoreData['error']['message'];
            }
            // 在库
            let storeData: Array<any> = supabaseStoreData['data'] != null ? supabaseStoreData['data'] : [];        
            // 判断在库数据
            if (storeData.length == 0) {
              // 返回响应
              throw '420';
            }
          } else {
            // 返回响应
            throw '419';
          }
        }
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
    console.error('ファイルコンテンツがありません');
    return new Response('ファイルコンテンツがありません', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 411 
    });
  } else if (message == '412') {
    console.error('商品在库位置内容チェックに失敗しました');
    return new Response('商品在库位置内容チェックに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 412 
    });
  } else if (message == '413') {
    console.error('在庫内容チェックに失敗しました');
    return new Response('在庫内容チェックに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 413 
    });
  } else if (message == '414') {
    console.error('位置情報の読み取りに失敗しました');
    return new Response('位置情報の読み取りに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 414 
    });
  } else if (message == '415') {
    console.error('商品情報の読み取りに失敗しました');
    return new Response('商品情報の読み取りに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 415 
    });
  } else if (message == '416') {
    console.error('在庫の作成に失敗しました');
    return new Response('在庫の作成に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 416 
    });
  } else if (message == '417') {
    console.error('商品在庫位置の作成に失敗しました');
    return new Response('商品在庫位置の作成に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 417 
    });
  } else if (message == '418') {
    console.error('商品在庫位置の更新に失敗しました');
    return new Response('商品在庫位置の更新に失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 418 
    });
  } else if (message == '419') {
    console.error('在庫情報の読み取りに失敗しました');
    return new Response('在庫情報の読み取りに失敗しました', { 
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 419 
    });
  } else if (message == '420') {
    console.error('在庫の更新に失敗しました');
    return new Response('在庫の更新に失敗しました', { 
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

// 保存商品在库位置表单验证
function saveProductLocationFormCheck(productLocationStructure: Map<string, any>): Map<string, any> {
  // 判断是否为空
  if (productLocationStructure['location_id'] == null || productLocationStructure['location_id'] == '') {
    return new Map<string, any>();
  } else if (productLocationStructure['stock_id'] == null || productLocationStructure['stock_id'] == '') {
    return new Map<string, any>();
  } else if (productLocationStructure['product_id'] == null || productLocationStructure['product_id'] == '') {
    return new Map<string, any>();
  } else if (productLocationStructure['stock'] == null || productLocationStructure['stock'] == '') {
    return new Map<string, any>();
  } else if (productLocationStructure['lock_stock'] == null || productLocationStructure['lock_stock'] == '') {
    return new Map<string, any>();
  }

  // 处理商品在库位置-结构
  delete productLocationStructure['id'];
  if (productLocationStructure['location_id'] == null || productLocationStructure['location_id'] == '') {
    delete productLocationStructure['location_id'];
  } else {
    productLocationStructure['location_id'] = productLocationStructure['location_id'] as number;
  }
  if (productLocationStructure['stock_id'] == null || productLocationStructure['stock_id'] == '') {
    delete productLocationStructure['stock_id'];
  } else {
    productLocationStructure['stock_id'] = productLocationStructure['stock_id'] as number;
  }
  if (productLocationStructure['product_id'] == null || productLocationStructure['product_id'] == '') {
    delete productLocationStructure['product_id'];
  } else {
    productLocationStructure['product_id'] = productLocationStructure['product_id'] as number;
  }
  if (productLocationStructure['stock'] == null || productLocationStructure['stock'] == '') {
    delete productLocationStructure['stock'];
  } else {
    productLocationStructure['stock'] = productLocationStructure['stock'] as number;
  }
  if (productLocationStructure['lock_stock'] == null || productLocationStructure['lock_stock'] == '') {
    delete productLocationStructure['lock_stock'];
  } else {
    productLocationStructure['lock_stock'] = productLocationStructure['lock_stock'] as number;
  }
  if (productLocationStructure['create_id'] == null || productLocationStructure['create_id'] == '') {
    delete productLocationStructure['create_id'];
  } else {
    productLocationStructure['create_id'] = productLocationStructure['create_id'] as number;
  }
  if (productLocationStructure['update_id'] == null || productLocationStructure['update_id'] == '') {
    delete productLocationStructure['update_id'];
  } else {
    productLocationStructure['update_id'] = productLocationStructure['update_id'] as number;
  }

  // 返回
  return productLocationStructure;
}

// 保存在库表单验证
function saveStoreFormCheck(storeStructure: Map<string, any>): Map<string, any> {
  // 判断是否为空
  if (storeStructure['product_id'] == null || storeStructure['product_id'] == '') {
    return new Map<string, any>();
  } else if (storeStructure['year_month'] == null || storeStructure['year_month'] == '') {
    return new Map<string, any>();
  } else if (storeStructure['stock'] == null || storeStructure['stock'] == '') {
    return new Map<string, any>();
  }

  // 处理商品在库位置-结构
  delete storeStructure['id'];
  if (storeStructure['product_id'] == null || storeStructure['product_id'] == '') {
    delete storeStructure['product_id'];
  } else {
    storeStructure['product_id'] = storeStructure['product_id'] as number;
  }
  if (storeStructure['stock'] == null || storeStructure['stock'] == '') {
    delete storeStructure['stock'];
  } else {
    storeStructure['stock'] = storeStructure['stock'] as number;
  }
  if (storeStructure['lock_stock'] == null || storeStructure['lock_stock'] == '') {
    delete storeStructure['lock_stock'];
  } else {
    storeStructure['lock_stock'] = storeStructure['lock_stock'] as number;
  }
  if (storeStructure['before_stock'] == null || storeStructure['before_stock'] == '') {
    delete storeStructure['before_stock'];
  } else {
    storeStructure['before_stock'] = storeStructure['before_stock'] as number;
  }
  if (storeStructure['in_stock'] == null || storeStructure['in_stock'] == '') {
    delete storeStructure['in_stock'];
  } else {
    storeStructure['in_stock'] = storeStructure['in_stock'] as number;
  }
  if (storeStructure['out_stock'] == null || storeStructure['out_stock'] == '') {
    delete storeStructure['out_stock'];
  } else {
    storeStructure['out_stock'] = storeStructure['out_stock'] as number;
  }
  if (storeStructure['adjust_stock'] == null || storeStructure['adjust_stock'] == '') {
    delete storeStructure['adjust_stock'];
  } else {
    storeStructure['adjust_stock'] = storeStructure['adjust_stock'] as number;
  }
  if (storeStructure['inventory_stock'] == null || storeStructure['inventory_stock'] == '') {
    delete storeStructure['inventory_stock'];
  } else {
    storeStructure['inventory_stock'] = storeStructure['inventory_stock'] as number;
  }
  if (storeStructure['move_in_stock'] == null || storeStructure['move_in_stock'] == '') {
    delete storeStructure['move_in_stock'];
  } else {
    storeStructure['move_in_stock'] = storeStructure['move_in_stock'] as number;
  }
  if (storeStructure['move_out_stock'] == null || storeStructure['move_out_stock'] == '') {
    delete storeStructure['move_out_stock'];
  } else {
    storeStructure['move_out_stock'] = storeStructure['move_out_stock'] as number;
  }
  if (storeStructure['return_stock'] == null || storeStructure['return_stock'] == '') {
    delete storeStructure['return_stock'];
  } else {
    storeStructure['return_stock'] = storeStructure['return_stock'] as number;
  }
  if (storeStructure['company_id'] == null || storeStructure['company_id'] == '') {
    delete storeStructure['company_id'];
  } else {
    storeStructure['company_id'] = storeStructure['company_id'] as number;
  }
  if (storeStructure['create_id'] == null || storeStructure['create_id'] == '') {
    delete storeStructure['create_id'];
  } else {
    storeStructure['create_id'] = storeStructure['create_id'] as number;
  }
  if (storeStructure['update_id'] == null || storeStructure['update_id'] == '') {
    delete storeStructure['update_id'];
  } else {
    storeStructure['update_id'] = storeStructure['update_id'] as number;
  }

  // 返回
  return storeStructure;
}

// 创建在库表单处理
function createStoreFormHandle(companyId: number, userId: number, store: Map<string, any>): Map<string, any> {
  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);
  
  // 在库
  store['company_id'] = companyId;
  store['create_time'] = now;
  store['create_id'] = userId;
  store['update_time'] = now;
  store['update_id'] = userId;

  // 返回
  return store;
}

// 创建商品在库位置表单处理
function createProductLocationFormHandle(userId: number, productLocation: Map<string, any>): Map<string, any> {
  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);

  // 商品在库位置
  productLocation['create_time'] = now;
  productLocation['create_id'] = userId;
  productLocation['update_time'] = now;
  productLocation['update_id'] = userId;

  // 返回
  return productLocation;
}

// 更新商品在库位置表单处理
function updateProductLocationFormHandle(userId: number, productLocation: Map<string, any>, productLocationStructure: Map<string, any>): Map<string, any> {
  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);
  
  // 商品在库位置
  if (productLocationStructure['stock'] != null && productLocationStructure['stock'] != '') {
    productLocation['stock'] = productLocation['stock']! + productLocationStructure['stock'] as number;
  }
  if (productLocationStructure['lock_stock'] != null && productLocationStructure['lock_stock'] != '') {
    productLocation['lock_stock'] = productLocation['lock_stock']! + productLocationStructure['lock_stock'] as number;
  }
  if (productLocationStructure['limit_date'] != null && productLocationStructure['limit_date'] != '') {
    productLocation['limit_date'] = productLocationStructure['limit_date'];
  }
  if (productLocationStructure['lot_no'] != null && productLocationStructure['lot_no'] != '') {
    productLocation['lot_no'] = productLocationStructure['lot_no'];
  }
  if (productLocationStructure['serial_no'] != null && productLocationStructure['serial_no'] != '') {
    productLocation['serial_no'] = productLocationStructure['serial_no'];
  }
  if (productLocationStructure['note'] != null && productLocationStructure['note'] != '') {
    productLocation['note'] = productLocationStructure['note'];
  }
  productLocation['update_time'] = now;
  productLocation['update_id'] = userId;

  // 返回
  return productLocation;
}

// 更新在库表单处理
function updateStoreFormHandle(userId: number, store: Map<string, any>, storeStructure: Map<string, any>): Map<string, any> {
  // 当前日期时间
  let now: Date = new Date();
  now.setUTCHours(now.getUTCHours() + 9);

  // 在库
  if (storeStructure['year_month'] != null && storeStructure['year_month'] != '') {
    store['year_month'] = storeStructure['year_month'];
  }
  if (storeStructure['stock'] != null && storeStructure['stock'] != '') {
    store['stock'] = store['stock']! + storeStructure['stock'] as number;
  }
  if (storeStructure['lock_stock'] != null && storeStructure['lock_stock'] != '') {
    store['lock_stock'] = store['lock_stock']! + storeStructure['lock_stock'] as number;
  }
  if (storeStructure['before_stock'] != null && storeStructure['before_stock'] != '') {
    store['before_stock'] = store['before_stock']! + storeStructure['before_stock'] as number;
  }
  if (storeStructure['in_stock'] != null && storeStructure['in_stock'] != '') {
    store['in_stock'] = store['in_stock']! + storeStructure['in_stock'] as number;
  }
  if (storeStructure['out_stock'] != null && storeStructure['out_stock'] != '') {
    store['out_stock'] = store['out_stock']! + storeStructure['out_stock'] as number;
  }
  if (storeStructure['adjust_stock'] != null && storeStructure['adjust_stock'] != '') {
    store['adjust_stock'] = store['adjust_stock']! + storeStructure['adjust_stock'] as number;
  }
  if (storeStructure['inventory_stock'] != null && storeStructure['inventory_stock'] != '') {
    store['inventory_stock'] = store['inventory_stock']! + storeStructure['inventory_stock'] as number;
  }
  if (storeStructure['move_in_stock'] != null && storeStructure['move_in_stock'] != '') {
    store['move_in_stock'] = store['move_in_stock']! + storeStructure['move_in_stock'] as number;
  }
  if (storeStructure['move_out_stock'] != null && storeStructure['move_out_stock'] != '') {
    store['move_out_stock'] = store['move_out_stock']! + storeStructure['move_out_stock'] as number;
  }
  if (storeStructure['return_stock'] != null && storeStructure['return_stock'] != '') {
    store['return_stock'] = store['return_stock']! + storeStructure['return_stock'] as number;
  }
  store['update_time'] = now;
  store['update_id'] = userId;

  // 返回
  return store;
}

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
