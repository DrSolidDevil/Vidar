package com.drsoliddevil.vidar

import android.Manifest
import android.content.Context
import android.os.Build
import android.telephony.PhoneNumberUtils
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.annotation.RequiresPermission

// Returns phone own phone number in international format
@RequiresPermission(Manifest.permission.READ_PHONE_NUMBERS)
fun getOwnPhoneNumber(context: Context): String? {
    val telephonyManager: TelephonyManager =
        context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        val subscriptionManager: SubscriptionManager =
            context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
        return subscriptionManager.getPhoneNumber(1)
    } else {
        @Suppress("DEPRECATION")
        return telephonyManager.line1Number
    }
}
