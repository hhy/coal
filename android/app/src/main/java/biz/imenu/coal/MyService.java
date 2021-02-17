package biz.imenu.coal;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

public class MyService extends Service {
    static final String TAG = "BlePeripheral";
    public class MyBinder extends Binder {
        MyService getService() {
            return MyService.this;
        }
    }
    private final IBinder mBinder = new MyBinder();



    @Override
    public IBinder onBind(Intent intent) {
        return this.mBinder;
    }

    MyThread myThread;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate: created");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        Log.d(TAG, "onCreate: create service and start");
        this.myThread = new MyThread(this);
                myThread.start();
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public boolean stopService(Intent name) {

        return super.stopService(name);
    }

    public void stop(){
        this.myThread.suicide();
        this.stopSelf();
    }

    static class MyThread extends Thread {
        private Service s;
        private boolean _suicide=false;
        void suicide(){
            this._suicide=true;
        }
        int _currentValue=0;
        public MyThread(Service s){
            super();
            this.s=s;
        }
        @Override
        public void run() {
            // for (int i = 0; i < 1; i++)
            while(true){
                Log.d(TAG, "run: b4 bc-ing");
                try {
                    if(this._suicide) break;
                    Thread.sleep(2500);
                    Intent intent = new Intent();
                    intent.setAction("porn");
                    intent.putExtra("v", this._currentValue++);
                    //  s.sendBroadcast(intent);
                    Log.d(TAG, "run: braodcasting "+this._currentValue);
                } catch (InterruptedException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }}
            // s.stopSelf();

        }

}