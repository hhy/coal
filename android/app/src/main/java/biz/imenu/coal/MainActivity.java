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
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements ServiceConnection, MethodChannel.MethodCallHandler {
    final static String TAG="nativeBle";
    private static final String CHANNEL = "samples.flutter.dev/battery";

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
                .setMethodCallHandler(
                        (call, result) -> {
                            Log.d(TAG, "configureFlutterEngine: method name : "+call.method);
                            if(call.method.equals("peripheral")){
                                Log.d(TAG, "configureFlutterEngine: "+call.arguments.getClass().getName());
                                String act=call.argument("act");
                                if(act==null){
                                    Log.d(TAG, "no action found");
                                    result.error("no input", "no input found", null);
                                }                               else if("on".equals(act)) {
                                    Log.d(TAG, "configureFlutterEngine: start service");
                                    // this.startService(new Intent(this, MyService.class));
                                    Intent intent=new Intent(this, MyService.class);
                                    this.startService(intent);
                                    boolean b = this.bindService(intent, this, Context.BIND_AUTO_CREATE);
                                    result.success("start & good");
                                }else if ("off".equals(act)){
                                    Log.d(TAG, "configureFlutterEngine: stop service");
                                    // this.s.stopSelf();
                                    this.s.stop();
                                    result.success("stop & good");
                                }else{
                                    Log.d(TAG, "configureFlutterEngine: unknow action: "+act);
                                    result.notImplemented();
                                }


                            }
                            else if (call.method.equals("getBatteryLevel")) {
                                Log.d("j4f", "configureFlutterEngine: hi flutter is calling");
                                List<String> rr=new ArrayList<String>();
                                for(String s :  new String[]{"abc", "def", "ajjj"}) rr.add(s);
                                // result.success(rr);
                                result.success(21);
                                Log.d("to flutter", "start calling flutter----------------------");
                                // callFlutter();
                                Log.d("to flutter", "done=================================");


                                int batteryLevel = getBatteryLevel();

                                if (batteryLevel != -1) {
                                    Log.d("j4f", "configureFlutterEngine: returun the value "+batteryLevel);
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
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



}
