package com.example.cpsincapplication

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.method.LinkMovementMethod
import android.view.View
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    lateinit var websiteHyperlinkTextView: TextView
    lateinit var instructionsBtnTextView: TextView
    lateinit var findDeviceBtn: ImageButton
    lateinit var runTestBtn: ImageButton
    lateinit var logbookBtn: ImageButton
    lateinit var accountBtn: ImageButton
    lateinit var settingsBtn: ImageButton

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        setViewComponents();
        setButtonListeners();
    }

    fun setViewComponents(){
        websiteHyperlinkTextView = findViewById(R.id.textView7)
        websiteHyperlinkTextView.movementMethod = LinkMovementMethod.getInstance();
        instructionsBtnTextView = findViewById(R.id.textView8)
        findDeviceBtn = findViewById(R.id.imageButton)
        runTestBtn = findViewById(R.id.imageButton2)
        logbookBtn = findViewById(R.id.imageButton3)
        accountBtn = findViewById(R.id.imageButton4)
        settingsBtn = findViewById(R.id.imageButton5)
    }

    fun setButtonListeners(){
        instructionsBtnTextView.setOnClickListener(instructionsTextViewOnClickListener)
        findDeviceBtn.setOnClickListener(findDeviceBtnOnClickListener)
        runTestBtn.setOnClickListener(runTestBtnOnClickListener)
        logbookBtn.setOnClickListener(logbookBtnOnClickListener)
        accountBtn.setOnClickListener(accountBtnOnClickListener)
        settingsBtn.setOnClickListener(settingsBtnOnClickListener)
    }

    val instructionsTextViewOnClickListener = object: View.OnClickListener {
        override fun onClick(view: View) {
            val intent = Intent(this@MainActivity, InstructionsActivity::class.java)
            startActivity(intent)
        }
    }

    val findDeviceBtnOnClickListener = object: View.OnClickListener {
        override fun onClick(view: View) {
            val intent = Intent(this@MainActivity, FindDeviceActivity::class.java)
            startActivity(intent)
        }
    }

    val runTestBtnOnClickListener = object: View.OnClickListener {
        override fun onClick(view: View) {
            val intent = Intent(this@MainActivity, RunTestActivity::class.java)
            startActivity(intent)
        }
    }

    val logbookBtnOnClickListener = object: View.OnClickListener {
        override fun onClick(view: View) {
            val intent = Intent(this@MainActivity, LogbookActivity::class.java)
            startActivity(intent)
        }
    }

    val accountBtnOnClickListener = object: View.OnClickListener {
        override fun onClick(view: View) {
            val intent = Intent(this@MainActivity, AccountActivity::class.java)
            startActivity(intent)
        }
    }

    val settingsBtnOnClickListener = object: View.OnClickListener {
        override fun onClick(view: View) {
            val intent = Intent(this@MainActivity, SettingsActivity::class.java)
            startActivity(intent)
        }
    }

}
