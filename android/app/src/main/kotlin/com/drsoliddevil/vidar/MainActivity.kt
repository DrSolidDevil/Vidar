package com.drsoliddevil.vidar

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import io.flutter.plugin.common.EventChannel
import android.provider.Telephony.Sms.Intents as SmsIntents
import android.content.IntentFilter

@Suppress("PrivatePropertyName")
class MainActivity : FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"
    private val SMS_NOTIFIER_CHANNEL = "flutter.native/smsnotifier"
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var smsReceiver: SmsReceiver
    private val context: Context = this

    @ExperimentalStdlibApi
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_NOTIFIER_CHANNEL)
        .setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                SmsReceiver.eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                SmsReceiver.eventSink = null
            }
        })
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "querySms" -> {
                    result.success(querySms(context, call.argument("phoneNumber")))
                }

                "sendSms" -> {
                    sendSms(context, call.argument("body")!!, call.argument("phoneNumber")!!)
                    result.success(0)
                }

                "smsConstants" -> {
                    result.success(smsConstants)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}