// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import nodemailer from 'npm:nodemailer@6.9.10'

const transport = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 465,
  secure: true,
  auth: {
    user: "pottsNoreply@gmail.com",
    pass: "apcsxwqumucwlqdn",
  }
})

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

console.log("send email smtp!")

serve(async (req) => {
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }
    const { tomail, subject, content } = await req.json()
    if ((tomail == null || tomail.length == 0) || (subject == null || subject.length == 0) || (content == null || content.length == 0)) {
      throw "Parameter does not exist"
    }
    console.info("send email content" + JSON.stringify(content) )

    try {
     await transport.sendMail({
        from: "pottsNoreply@gmail.com",
        to: tomail,
        subject: subject,
        html: content,
      }, e => {
        console.error("send email smtp error:" + (e.message != null && e.message != undefined ? e.message : e));
        return new Response("send email smtp error:" + (e.message != null && e.message != undefined ? e.message : e), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 400,
        })
      })
    } catch (e) {
      console.error("send email smtp error:" + (e.message != null && e.message != undefined ? e.message : e));
      return new Response("send email smtp error:" + (e.message != null && e.message != undefined ? e.message : e), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 400,
      })
    }
  
    console.info("send email smtp success")
    return new Response("send email smtp success", {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })

})
