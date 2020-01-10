package com.example.donotdisturbapp;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TimePicker;

import androidx.appcompat.app.AppCompatActivity;

import java.util.Calendar;
import java.util.Date;

public class MainActivity extends AppCompatActivity {
    protected static Switch wifiSwitch;
    protected static WifiManager wifiManager;
    protected static Switch bluetoothSwitch;
    protected static BluetoothAdapter bluetoothAdapter;
    protected static Switch audioSwitch;
    protected static AudioManager audioManager;
    private TimePicker timePicker;
    private TimePicker timePicker2;
    private Button button1;
    private Button button2;
    private Button setTime;
    private Date startDate;
    private Date endDate;
    private boolean enable;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        timePicker = findViewById(R.id.timePicker);
        setTime = findViewById(R.id.setTime);

        setTime.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                setTime.setVisibility(View.INVISIBLE);
                wifiSwitch.setVisibility(View.INVISIBLE);
                bluetoothSwitch.setVisibility(View.INVISIBLE);
                audioSwitch.setVisibility(View.INVISIBLE);
                timePicker.setVisibility(View.VISIBLE);
                button1.setVisibility(View.VISIBLE);
            }
        });
        timePicker.setVisibility(View.INVISIBLE);

        findViewById(R.id.timePicker2).setVisibility(View.INVISIBLE);
        button2 = findViewById(R.id.buttonAlarm2);
        button2.setVisibility(View.INVISIBLE);

        button1 =  findViewById(R.id.buttonAlarm);
        button1.setVisibility(View.INVISIBLE);
        timePicker2 = findViewById(R.id.timePicker2);

         button1.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View view) {
                Calendar calendar = Calendar.getInstance();
                if (android.os.Build.VERSION.SDK_INT >= 23) {
                    calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH),
                            timePicker.getHour(), timePicker.getMinute(), 0);
                } else {
                    calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH),
                            timePicker.getCurrentHour(), timePicker.getCurrentMinute(), 0);
                }


                startDate = calendar.getTime();
                timePicker.setVisibility(View.INVISIBLE);
                timePicker2.setVisibility(View.VISIBLE);
                button2.setVisibility(View.VISIBLE);

            }
        });

        button2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Calendar calendar = Calendar.getInstance();
                if (android.os.Build.VERSION.SDK_INT >= 23) {
                    calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH),
                            timePicker2.getHour(), timePicker2.getMinute(), 0);
                } else {
                    calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH),
                            timePicker2.getCurrentHour(), timePicker2.getCurrentMinute(), 0);
                }


                endDate = calendar.getTime();
                timePicker.setVisibility(View.INVISIBLE);
                timePicker2.setVisibility(View.INVISIBLE);
                button2.setVisibility(View.INVISIBLE);
                setTime.setVisibility(View.VISIBLE);
                wifiSwitch.setVisibility(View.VISIBLE);
                bluetoothSwitch.setVisibility(View.VISIBLE);
                audioSwitch.setVisibility(View.VISIBLE);
                button1.setVisibility(View.INVISIBLE);
                enable = true;
                ThreadSetUp componentSetUp = new ThreadSetUp(startDate, endDate, enable);
                new Thread(componentSetUp).start();
            }
        });


        wifiSwitch = findViewById(R.id.wifi_switch);
        wifiManager = (WifiManager) getApplicationContext().getSystemService(Context.WIFI_SERVICE);

        wifiSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    wifiManager.setWifiEnabled(true);
                    wifiSwitch.setText("WiFi is ON");

                } else {
                    wifiManager.setWifiEnabled(false);
                    wifiSwitch.setText("WiFi is OFF");
                }
            }
        });

        bluetoothSwitch = findViewById(R.id.bluetooth_switch);
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        if(bluetoothAdapter.isEnabled()){
            bluetoothSwitch.setChecked(true);
            bluetoothSwitch.setText("Bluetooth is ON");
        }
        bluetoothSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    bluetoothSwitch.setText("Bluetooth is ON");
                    bluetoothAdapter.enable();
                } else {
                    bluetoothSwitch.setText("Bluetooth is OFF");
                    bluetoothAdapter.disable();
                }
            }
        });

        audioSwitch = findViewById(R.id.audio_switch);
        audioManager = (AudioManager) getApplicationContext().getSystemService(Context.AUDIO_SERVICE);



        audioSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    audioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
                    audioSwitch.setText("Audio is ON");

                } else {
                    audioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
                    audioSwitch.setText("Audio is OFF");
                }

            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        IntentFilter intentFilter = new IntentFilter(WifiManager.WIFI_STATE_CHANGED_ACTION);
        registerReceiver(wifiStateReceiver, intentFilter);

        IntentFilter filter1 = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        registerReceiver(bluetoothStateReceiver, filter1);

        IntentFilter filter3= new IntentFilter(AudioManager.RINGER_MODE_CHANGED_ACTION);
        registerReceiver(audioStateReceiver, filter3);

    }

    @Override
    protected void onStop() {
        super.onStop();
        unregisterReceiver(wifiStateReceiver);
        unregisterReceiver(bluetoothStateReceiver);
        unregisterReceiver(audioStateReceiver);
        enable = false;
    }

    private BroadcastReceiver wifiStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            int wifiStateExtra = intent.getIntExtra(WifiManager.EXTRA_WIFI_STATE,
                    WifiManager.WIFI_STATE_UNKNOWN);

            switch (wifiStateExtra) {
                case WifiManager.WIFI_STATE_ENABLED:
                    wifiSwitch.setChecked(true);
                    wifiSwitch.setText("WiFi is ON");
                    break;
                case WifiManager.WIFI_STATE_DISABLED:
                    wifiSwitch.setChecked(false);
                    wifiSwitch.setText("WiFi is OFF");
                    break;
            }

        }
    };

    private BroadcastReceiver audioStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            int currentAudioMode = intent.getIntExtra(AudioManager.EXTRA_RINGER_MODE, AudioManager.USE_DEFAULT_STREAM_TYPE);

            switch (currentAudioMode) {
                case AudioManager.RINGER_MODE_NORMAL:
                    audioSwitch.setChecked(true);
                    audioSwitch.setText("Audio is ON");
                    break;
                case AudioManager.RINGER_MODE_VIBRATE:
                    audioSwitch.setChecked(false);
                    audioSwitch.setText("Audio is OFF");
                    break;
            }

        }
    };

    private BroadcastReceiver bluetoothStateReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

                final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);

                switch(state) {
                    case BluetoothAdapter.STATE_OFF:
                    case BluetoothAdapter.STATE_TURNING_OFF:
                        bluetoothSwitch.setText("Bluetooth is OFF");
                        bluetoothSwitch.setChecked(false);
                        break;
                    case BluetoothAdapter.STATE_ON:
                    case BluetoothAdapter.STATE_TURNING_ON:
                        bluetoothSwitch.setText("Bluetooth is ON");
                        bluetoothSwitch.setChecked(true);
                        break;
                }

        }
    };

}