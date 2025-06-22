package com.vidar.vidar

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel
import android.provider.Telephony.Sms.Intents as SmsIntents

class SmsReceiver(private val eventSink: EventChannel.EventSink?) : BroadcastReceiver() {
    /*
    val filter = IntentFilter().apply {
        addAction(SmsIntents.SMS_RECEIVED_ACTION)
    }
    */

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == SmsIntents.SMS_RECEIVED_ACTION) {
            // getMessagesFromIntent returns an array of pdus, only the first one is relevant
            // For getOriginatingAddress, if the address is a GSM-formatted address, it will be in a format specified by 3GPP 23.040 Sec 9.1.2.5. 
            // If it is a CDMA address, it will be a format specified by 3GPP2 C.S005-D Table 2.7.1.3.2.4-2. 
            // The choice of format is carrier-specific, so callers of the should be careful to avoid assumptions about the returned content.
            /*
            val phoneNumber = SmsMessage.createFromPdu(
                SmsIntents.getMessagesFromIntent(intent)[0], 
                intent?.extras?.getString("format")
            )?.originatingAddress;
            */
            
            eventSink?.success("smsreceived")
        }
    }
}
