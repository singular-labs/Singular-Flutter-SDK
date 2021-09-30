package com.singular.flutter_sdk;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.singular.sdk.*;

import java.util.HashMap;
import java.util.Map;


/** FlutterSdkPlugin */
public class SingularSDK implements FlutterPlugin, ActivityAware, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private static Context mContext;
  private Intent mIntent;
  private Handler uiThreadHandler = new Handler(Looper.getMainLooper());
  private static int currentIntentHash = 0;
  private static Map configDict;
  private static SingularLinkHandler singularLinkHandler;
  private static SingularConfig singularConfig;

  public static void onNewIntent(Intent intent) {

    // We save the intent hash code to make sure that the intent we get is a new one to avoid resolving an old deeplink.
    if (singularConfig != null &&
            singularLinkHandler != null && intent != null && intent.hashCode() != currentIntentHash && intent.getData() != null &&
            Intent.ACTION_VIEW.equals(intent.getAction())) {
      currentIntentHash = intent.hashCode();

      singularConfig.withSingularLink(intent, singularLinkHandler);
      Singular.init(mContext, singularConfig);
    }
  }

  // Notify the plugin that it has been attached to an engine.
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "singular-api");
    channel.setMethodCallHandler(this);

    mContext = flutterPluginBinding.getApplicationContext();
  }

  // ActivityAware
  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    mIntent = binding.getActivity().getIntent();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    if (channel != null) {
      channel.setMethodCallHandler(null);
    }
    channel = null;
    mContext = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(
          ActivityPluginBinding binding) {
  }

  @Override
  public void onDetachedFromActivity() {
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    switch (call.method) {
      case SingularConstants.START:
        start(call, result);
        break;
      case SingularConstants.SET_CUSTOM_USER_ID:
        setCustomUserId(call, result);
        break;
      case SingularConstants.UNSET_CUSTOM_USER_ID:
        unsetCustomUserId(call, result);
        break;
      case SingularConstants.SET_DEVICE_CUSTOM_USER_ID:
        setDeviceCustomUserId(call, result);
        break;
      case SingularConstants.EVENT:
        event(call, result);
        break;
      case SingularConstants.EVENT_WITH_ARGS:
        eventWithArgs(call, result);
        break;
      case SingularConstants.CUSTOM_REVENUE:
        customRevenue(call, result);
        break;
      case SingularConstants.CUSTOM_REVENUE_WITH_ATTRIBUTES:
        customRevenueWithArgs(call, result);
        break;
      case SingularConstants.TRACKING_OPT_IN:
        trackingOptIn(call, result);
        break;
      case SingularConstants.TRACKING_UNDER13:
        trackingUnder13(call, result);
        break;
      case SingularConstants.STOP_ALL_TRACKING:
        stopAllTracking(call, result);
        break;
      case SingularConstants.RESUME_ALL_TRACKING:
        resumeAllTracking(call, result);
        break;
      case SingularConstants.IS_ALL_TRACKING_STOPPED:
        isAllTrackingStopped(call, result);
        break;
      case SingularConstants.LIMIT_DATA_SHARING:
        limitDataSharing(call, result);
        break;
      case SingularConstants.GET_LIMIT_DATA_SHARING:
        getLimitDataSharing(call, result);
        break;
      case SingularConstants.CLEAR_GLOBAL_PROPERTIES:
        clearGlobalProperties(call, result);
        break;
      case SingularConstants.UNSET_GLOBAL_PROPERTY:
        unsetGlobalProperty(call, result);
        break;
      case SingularConstants.SET_GLOBAL_PROPERTY:
        setGlobalProperty(call, result);
        break;
      case SingularConstants.GET_GLOBAL_PROPERTIES:
        getGlobalProperties(call, result);
        break;
      case SingularConstants.SET_WRAPPER_NAME_AND_VERSION:
        setWrapperNameAndVersion(call, result);
        break;
      case SingularConstants.SET_FCM_TOKEN:
        setFCMDeviceToken(call, result);
        break;
      case SingularConstants.SET_GCM_TOKEN:
        setGCMDeviceToken(call, result);
        break;
      case SingularConstants.REGISTER_DEVICE_TOKEN_FOR_UNINSTALL:
        setFCMDeviceToken(call, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  void initSDK() {
    if (configDict == null) {
      return;
    }

    String apiKey = (String)configDict.get("apiKey");
    String secretKey = (String)configDict.get("secretKey");
    boolean collectOAID = (boolean) configDict.get("collectOAID");
    boolean enableLogging = (boolean) configDict.get("enableLogging");

    double shortLinkResolveTimeOut = (double)configDict.get("shortLinkResolveTimeOut");

    singularConfig = new SingularConfig(apiKey, secretKey);

    String customUserId = (String) configDict.get("customUserId");

    if (customUserId != null) {
      singularConfig.withCustomUserId(customUserId);
    }
    if (collectOAID) {
      singularConfig.withOAIDCollection();
    }
    if (enableLogging) {
      singularConfig.withLoggingEnabled();
    }
    double sessionTimeout = (double)configDict.get("sessionTimeout");

    if (sessionTimeout >= 0) {
      singularConfig.withSessionTimeoutInSec((long) sessionTimeout);
    }

    Object limitDataSharing = configDict.get("limitDataSharing");
    if (limitDataSharing != null) {
      singularConfig.withLimitDataSharing((boolean)limitDataSharing);
    }

    String imei = (String) configDict.get("imei");
    if (imei != null) {
      singularConfig.withIMEI(imei);
    }

    singularLinkHandler = new SingularLinkHandler() {
      @Override
      public void onResolved(SingularLinkParams params) {
        // The deep link destination, as configured in the Manage Links page
        String deeplink = params.getDeeplink();

        // The passthrough parameters added to the link, if any.
        String passthrough = params.getPassthrough();

        // Whether the link configured as a deferred deep link.
        boolean isDeferred = params.isDeferred();

        // Add deep link handling code here
        final Map<String, Object> linkParams = new HashMap<>();
        linkParams.put("deeplink", deeplink);
        linkParams.put("passthrough", passthrough);
        linkParams.put("isDeferred", isDeferred);

        uiThreadHandler.post(new Runnable() {
          @Override
          public void run() {
            channel.invokeMethod("singularLinksHandlerName",linkParams);
          }
        });
      }
    };

    if (mIntent != null) {
      int intentHash = mIntent.hashCode();

      if (intentHash != currentIntentHash) {
        currentIntentHash = intentHash;
        singularConfig.withSingularLink(mIntent, singularLinkHandler,(long) shortLinkResolveTimeOut);
      }
    }

    Singular.init(mContext, singularConfig);
  }

  private void start(final MethodCall call, final Result result) {
    configDict = (Map) call.arguments;
    initSDK();
  }

  private void setCustomUserId(final MethodCall call, final Result result) {
    String customUserId = call.argument("customUserId");
    Singular.setCustomUserId(customUserId);
  }

  private void unsetCustomUserId(final MethodCall call, final Result result) {
    Singular.unsetCustomUserId();
  }

  private void setDeviceCustomUserId(final MethodCall call, final Result result) {
    String customUserId = call.argument("customUserId");
    Singular.setDeviceCustomUserId(customUserId);
  }

  private void event(final MethodCall call, final Result result) {
    String eventName =  call.argument("eventName");
    Singular.event(eventName);
  }

  private void eventWithArgs(final MethodCall call, final Result result) {
    String eventName =  call.argument("eventName");
    Map<String, Object> extra = call.argument("args");
    Singular.event(eventName, extra.toString());
}

  private void customRevenue(final MethodCall call, final Result result) {
    String currency = call.argument("currency");
    String eventName = call.argument("eventName");

    double amount = call.argument("amount");

    Singular.customRevenue(eventName, currency, amount);
  }

  private void customRevenueWithArgs(final MethodCall call, final Result result) {
    String currency = call.argument("currency");
    String eventName = call.argument("eventName");
    double amount = call.argument("amount");
    Map args = call.argument("attributes");

     Singular.customRevenue(eventName, currency, amount, args);
  }

  private void trackingOptIn(final MethodCall call, final Result result) {
    Singular.trackingOptIn();
  }

  private void trackingUnder13(final MethodCall call, final Result result) {
    Singular.trackingUnder13();
  }

  private void stopAllTracking(final MethodCall call, final Result result) {
    Singular.stopAllTracking();
  }

  private void resumeAllTracking(final MethodCall call, final Result result) {
    Singular.resumeAllTracking();
  }

  private void isAllTrackingStopped(final MethodCall call, final Result result) {
    result.success(Singular.isAllTrackingStopped());
  }

  private void limitDataSharing(final MethodCall call, final Result result) {
    boolean shouldLimitDataSharing =  call.argument("limitDataSharing");
    Singular.limitDataSharing(shouldLimitDataSharing);
  }

  private void getLimitDataSharing(final MethodCall call, final Result result) {
    result.success(Singular.getLimitDataSharing());
  }

  private void clearGlobalProperties(final MethodCall call, final Result result) {
    Singular.clearGlobalProperties();
  }

  private void unsetGlobalProperty(final MethodCall call, final Result result) {
    String key = call.argument("key");
    Singular.unsetGlobalProperty(key);
  }

  private void setGlobalProperty(final MethodCall call, final Result result) {
    String key =  call.argument("key");
    String value =  call.argument("value");
    boolean overrideExisting =  call.argument("overrideExisting");
    result.success(Singular.setGlobalProperty(key, value, overrideExisting));
  }

  private void getGlobalProperties(final MethodCall call, final Result result) {
    result.success(Singular.getGlobalProperties());
  }

  private void setFCMDeviceToken(final MethodCall call, final Result result) {
    String fcmToken =  call.argument("fcmToken");
    Singular.setFCMDeviceToken(fcmToken);
  }

  private void setGCMDeviceToken(final MethodCall call, final Result result) {
    String gcmToken =  call.argument("gcmToken");
    Singular.setGCMDeviceToken(gcmToken);
  }

  private void setWrapperNameAndVersion(final MethodCall call, final Result result) {
    String name =  call.argument("name");
    String version =  call.argument("version");

    Singular.setWrapperNameAndVersion(name, version);
  }
}
