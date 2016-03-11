package org.qtproject.example.admobqt;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.AdListener;

import android.os.Bundle;

import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

import android.widget.Button;
import android.widget.RelativeLayout;

public class AdMobQtActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    private static ViewGroup viewGroup;

    private static AdView mAdView;
    private boolean adAdded = false;
    private static AdMobQtActivity _instance;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        _instance = this;

        mAdView = new AdView(this);
        mAdView.setAdUnitId("ca-app-pub-6171591881699090/7100205733");
        mAdView.setAdSize(AdSize.BANNER);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                             WindowManager.LayoutParams.FLAG_FULLSCREEN);

        View view = getWindow().getDecorView().getRootView();

        if (view instanceof ViewGroup) {
            viewGroup = (ViewGroup) view;

            ViewGroup.LayoutParams ad_layout_params = new ViewGroup.LayoutParams( ViewGroup.LayoutParams.FILL_PARENT, 100);
            mAdView.setLayoutParams(ad_layout_params);


            mAdView.setAdListener( new AdListener() {
                public void onAdLoaded(){
                    if( adAdded)
                        return;
                    adAdded = true;

                    mAdView.setVisibility(android.view.View.INVISIBLE);
                    viewGroup.addView( mAdView);
                }
            });

            AdRequest adRequest = new AdRequest.Builder()
//                .addTestDevice(AdRequest.DEVICE_ID_EMULATOR)
                //.addTestDevice("INSERT_YOUR_HASHED_DEVICE_ID_HERE")
                .build();
            mAdView.loadAd( adRequest);
        }

    }

    @Override
    public void onPause() {
        mAdView.pause();
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();
        mAdView.resume();
    }

    @Override
    public void onDestroy() {
        mAdView.destroy();
        super.onDestroy();
    }

    public static void showAd()
     {
       _instance.runOnUiThread(new Runnable() {
         public void run() {
           mAdView.setVisibility(android.view.View.VISIBLE);
         }
       });
     }
     public static void hideAd()
     {
       _instance.runOnUiThread(new Runnable() {
         public void run() {
           mAdView.setVisibility(android.view.View.INVISIBLE);
         }
       });
     }
}
