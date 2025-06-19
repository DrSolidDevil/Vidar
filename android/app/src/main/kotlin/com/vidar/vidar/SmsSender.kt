package com.vidar.vidar

import android.telephony.SmsManager
import android.content.Context

public fun sendSms(context: Context, body: String, phoneNumber: String) {
    val smsManager: SmsManager = context.getSystemService(SmsManager::class.java)
    smsManager.sendTextMessage(phoneNumber, null, body, null, null)
}
