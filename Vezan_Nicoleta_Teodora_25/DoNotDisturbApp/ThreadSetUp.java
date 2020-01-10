package com.example.donotdisturbapp;

import android.media.AudioManager;

import java.util.Date;

public class ThreadSetUp implements Runnable {

    private Date startDate;
    private Date endDate;
    private boolean enable;

    public ThreadSetUp(Date startTime, Date endTime, Boolean enable){
            this.startDate = startTime;
            this.endDate = endTime;
            this.enable = enable;
    }

    int ok =1;

    @Override
    public void run() {
        Date actualDate;
        while(enable) {
            actualDate = new Date();
            if ((actualDate.after(startDate) || actualDate.equals(startDate)) && actualDate.before(endDate)){
                MainActivity.wifiManager.setWifiEnabled(false);
                MainActivity.wifiSwitch.setText("WiFi is OFF");
                MainActivity.bluetoothSwitch.setText("Bluetooth is OFF");
                MainActivity.bluetoothAdapter.disable();
                MainActivity.audioManager.setRingerMode(AudioManager.RINGER_MODE_VIBRATE);
                MainActivity.audioSwitch.setText("Audio is OFF");
                ok=0;
            } else {
                MainActivity.wifiManager.setWifiEnabled(true);
                MainActivity.wifiSwitch.setText("WiFi is ON");
                MainActivity.bluetoothSwitch.setText("Bluetooth is ON");
                MainActivity.bluetoothAdapter.enable();
                MainActivity.audioManager.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
                MainActivity.audioSwitch.setText("Audio is ON");
                if(ok !=1)
                enable = false;
            }
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
