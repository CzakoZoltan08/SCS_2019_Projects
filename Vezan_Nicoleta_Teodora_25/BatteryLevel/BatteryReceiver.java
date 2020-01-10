package com.example.batterylevel;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.BatteryManager;
import android.os.Handler;
import android.widget.ImageView;
import android.widget.TextView;

public class BatteryReceiver extends BroadcastReceiver {

    ImageView fullbatery;
    TextView percentage;
    TextView charging;

    Handler handler;
    Runnable runnable;

    @Override
    public void onReceive(final Context context, final Intent intent) {
        percentage = ((MainActivity) context).findViewById(R.id.percentage);
        fullbatery = ((MainActivity) context).findViewById(R.id.fullB);
        charging = ((MainActivity) context).findViewById(R.id.charging);

        runnable = new Runnable() {
            @Override
            public void run() {
                int level = bateryLevel(intent);
                percentage.setText("Battery: " + level + "%");
                String message = bateryStatus(intent);
                charging.setText(message);
                batteryImage(context, level);
                handler.postDelayed(runnable, 5000);
            }
        };
        handler = new Handler();
        handler.postDelayed(runnable, 0);

    }

    public int bateryLevel(Intent batteryIntent) {
        int level = batteryIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
        int scale = batteryIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);

        return (level * 100 / scale);
    }

    public String bateryStatus(Intent batteryIntent) {
        String action = batteryIntent.getAction();
        String message = "";
        if (action != null && action.equals(Intent.ACTION_BATTERY_CHANGED)) {
            int status = batteryIntent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            switch (status) {
                case BatteryManager.BATTERY_STATUS_FULL:
                    message = "Full";
                    break;
                case BatteryManager.BATTERY_STATUS_CHARGING:
                    message = "Charging";
                    break;
                case BatteryManager.BATTERY_STATUS_DISCHARGING:
                    message = "Discharging";
                    break;
                case BatteryManager.BATTERY_STATUS_NOT_CHARGING:
                    message = "Not charging";
                    break;
                case BatteryManager.BATTERY_STATUS_UNKNOWN:
                    message = "Unknown";
                    break;
            }
        }
        return message;
    }

    public void batteryImage(Context context, Integer batteryPercentage){
        Resources res = context.getResources();

        if (batteryPercentage >= 90) {
            fullbatery.setImageDrawable(res.getDrawable(R.drawable.battery1));

        } else if (90 > batteryPercentage && batteryPercentage >= 65) {
            fullbatery.setImageDrawable(res.getDrawable(R.drawable.battery2));

        } else if (65 > batteryPercentage && batteryPercentage >= 40) {
            fullbatery.setImageDrawable(res.getDrawable(R.drawable.battery2));

        } else if (40 > batteryPercentage && batteryPercentage >= 15) {
            fullbatery.setImageDrawable(res.getDrawable(R.drawable.battery3));

        } else {
            fullbatery.setImageDrawable(res.getDrawable(R.drawable.battery3));

        }
    }
}
