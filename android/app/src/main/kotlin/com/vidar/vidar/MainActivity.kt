package com.vidar.vidar

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.native/helper"
    private val SMS_NOTIFIER_CHANNEL = "flutter.native/smsnotifier"
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var smsReceiver: SmsReceiver
    private val context = this

    @ExperimentalStdlibApi
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    smsReceiver = SmsReceiver()
                }

                override fun onCancel(arguments: Any?) {
                    unregisterReceiver(smsReceiver)
                    eventSink = null
                }
            })
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_NOTIFIER_CHANNEL).setMethodCallHandler {
            call, result ->
            if call.method == "querySms" {
                result.success(querySms(context, call.argument("phoneNumber"))) 
            } else if call.method = "sendSms" {
                sendSms(context, call.argument("body"), call.argument("phoneNumber"))
                result.success()
            } else if call.method = "smsConstants" {
                result.success(smsConstants)
            } else {
                result.notImplemented()
            }
        }
    }
}