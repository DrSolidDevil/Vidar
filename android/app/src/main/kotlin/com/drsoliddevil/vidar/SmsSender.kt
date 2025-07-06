package com.drsoliddevil.vidar

import android.telephony.SmsManager
import android.content.Context

fun sendSms(context: Context, body: String, phoneNumber: String) {
    val smsManager: SmsManager = context.getSystemService(SmsManager::class.java)
    val bodySplit: ArrayList<String> = smsManager.divideMessage(body)
    smsManager.sendMultipartTextMessage(phoneNumber, null, bodySplit, null, null)
}
