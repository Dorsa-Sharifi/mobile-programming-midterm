package com.example.secure_bank_app

import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Preventing ScreenShot
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }
}
