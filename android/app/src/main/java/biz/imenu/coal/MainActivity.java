package biz.imenu.coal;

import android.content.ComponentName;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.BatteryManager;
import android.os.Build;
import android.os.IBinder;
import android.util.EventLog;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements ServiceConnection, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    // public class MainActivity extends FlutterActivity implements ServiceConnection{
    final static String TAG = "nativeBle";
    private static final String CHANNEL = "samples.flutter.dev/battery";
    private static final String StreamCHANNEL = "samples.flutter.dev/bleStream";

    MyService s;

    @Override
    public void onServiceConnected(ComponentName name, IBinder binder) {
        Log.d(TAG, "onServiceConnected: ");
        MyService.MyBinder b = (MyService.MyBinder) binder;
        s = b.getService();

        // Toast.makeText(MainActivity.this, "Connected", Toast.LENGTH_SHORT).show();

    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
        Log.d(TAG, "onServiceDisconnected: ");
        s = null;
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(this);
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), StreamCHANNEL).setStreamHandler(this);
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }


    private void peripheral(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        Log.d(TAG, "configureFlutterEngine: " + call.arguments.getClass().getName());
        String act = call.argument("act");
        if (act == null) {
            Log.d(TAG, "no action found");
            result.error("no input", "no input found", null);
        } else if ("on".equals(act)) {
            Log.d(TAG, "configureFlutterEngine: start service");
            // this.startService(new Intent(this, MyService.class));
            Intent intent = new Intent(this, MyService.class);
            this.startService(intent);
            boolean b = this.bindService(intent, this, Context.BIND_AUTO_CREATE);
            result.success("start & good");
        } else if ("off".equals(act)) {
            Log.d(TAG, "configureFlutterEngine: stop service");
            // this.s.stopSelf();
            this.s.stop();
            result.success("stop & good");
        } else {
            Log.d(TAG, "configureFlutterEngine: unknow action: " + act);
            result.notImplemented();
        }
    }

    private void fa(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.d("j4f", "configureFlutterEngine: hi flutter is calling");
        List<String> rr = new ArrayList<String>();
        for (String s : new String[]{"abc", "def", "ajjj"}) rr.add(s);
        // result.success(rr);
        result.success(21);
        Log.d("to flutter", "start calling flutter----------------------");
        // callFlutter();
        Log.d("to flutter", "done=================================");


        int batteryLevel = getBatteryLevel();

        if (batteryLevel != -1) {
            Log.d("j4f", "configureFlutterEngine: returun the value " + batteryLevel);
            result.success(batteryLevel);
        } else {
            result.error("UNAVAILABLE", "Battery level not available.", null);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        Log.d(TAG, "configureFlutterEngine: method name : " + call.method);
        if (call.method.equals("peripheral")) {
            this.peripheral(call, result);
        } else if (call.method.equals("getBatteryLevel")) {
            this.fa(call, result);
        } else {
            result.notImplemented();
        }
    }


    int i = 0;

    private void startFeed(){
        Runnable r= new Runnable() {
            @Override
            public void run() {
                for(int i=0; i<10; i++){

                    try {
                        Thread.sleep(1000);
                        if(events!=null) events.success(i);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }

            }
        };
        Thread t=new Thread(r);
        t.start();

    }

    EventChannel.EventSink events;

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.w(TAG, "adding listener");
        this.events=events;
    }

    @Override
    public void onCancel(Object arguments) {
        this.events=null;
    }
}
