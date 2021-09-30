package net.singular.singularsampleapp;

import android.content.Intent;
import androidx.annotation.NonNull;
import com.singular.flutter_sdk.SingularBridge;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        SingularBridge.onNewIntent(intent);
    }
}
