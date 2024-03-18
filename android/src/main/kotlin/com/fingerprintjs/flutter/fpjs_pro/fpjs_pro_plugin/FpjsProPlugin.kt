package com.fingerprintjs.flutter.fpjs_pro.fpjs_pro_plugin

import android.content.Context
import androidx.annotation.NonNull
import com.fingerprintjs.android.fingerprint.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler


/** FpjsProPlugin */
class FpjsProPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    private lateinit var fpjsClient: Fingerprinter

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "fpjs_pro_plugin")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            INIT -> {
                initFpjs()
                result.success("Successfully initialized FingerprintJS Pro Client")
            }

            GET_DEVICE_ID -> {
                fpjsClient.getDeviceId(version = Fingerprinter.Version.V_5) { res ->
                    val deviceId = res.deviceId
                    result.success(deviceId)
                }

                result.error(500, "Unable to retreive device id", null)
            }

            GET_FINGERPRINT -> {
                fpjsClient.getFingerprint(version = Fingerprinter.Version.V_5) { fingerprint ->
                    result.success(fingerprint)
                }
                result.error(500, "Unable to retreive fingerprint", null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initFpjs() {
        fpjsClient = FingerprinterFactory.create(applicationContext)
    }

}

const val INIT = "init"
const val GET_DEVICE_ID = "getDeviceId"
const val GET_FINGERPRINT = "getFingerprint"
