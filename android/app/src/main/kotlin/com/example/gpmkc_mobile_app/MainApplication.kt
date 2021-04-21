package com.wahegurulive.gpmkc_mobile_app

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class MainApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}