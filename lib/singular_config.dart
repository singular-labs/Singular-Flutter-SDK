import 'package:flutter/services.dart';
import 'package:singular_flutter_sdk/singular_link_params.dart';

typedef void SingularLinksHandler(SingularLinkParams params);
typedef void ConversionValueUpdatedCallback(int conversionValue);

class SingularConfig {
  static const MethodChannel _channel = const MethodChannel('singular-api');

  String _apiKey;
  String _secretKey;
  bool skAdNetworkEnabled = false;
  bool clipboardAttribution = false;
  bool manualSkanConversionManagement = false;
  int waitForTrackingAuthorizationWithTimeoutInterval = 0;
  double shortLinkResolveTimeOut = 10.0;
  SingularLinksHandler? singularLinksHandler;
  ConversionValueUpdatedCallback? conversionValueUpdatedCallback;
  double sessionTimeout = -1;
  String? customUserId;
  // Limit Data Sharing
  bool? limitDataSharing;
  String? imei;
  bool collectOAID = false;
  bool enableLogging = false;

  SingularConfig(this._apiKey, this._secretKey) {
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case 'singularLinksHandlerName':
            if (singularLinksHandler != null) {
              singularLinksHandler!(SingularLinkParams.fromMap(call.arguments));
            }
            break;
          case 'conversionValueUpdatedCallbackName':
            if (conversionValueUpdatedCallback != null) {
              conversionValueUpdatedCallback!(call.arguments);
            }
            break;
          default:
            print('Received unknown native method: ${call.method}');
            break;
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }

  Map<String, dynamic> get toMap {
    Map<String, dynamic> configMap = {
      'apiKey': _apiKey,
      'secretKey': _secretKey,
      'skAdNetworkEnabled': skAdNetworkEnabled,
      'clipboardAttribution': clipboardAttribution,
      'manualSkanConversionManagement': manualSkanConversionManagement,
      'waitForTrackingAuthorizationWithTimeoutInterval':
          waitForTrackingAuthorizationWithTimeoutInterval,
      'shortLinkResolveTimeOut': shortLinkResolveTimeOut
    };
    if (singularLinksHandler != null) {
      configMap['singularLinksHandler'] = 'singularLinksHandlerName';
    }
    if (conversionValueUpdatedCallback != null) {
      configMap['conversionValueUpdatedCallback'] =
          'conversionValueUpdatedCallbackName';
    }
    if (customUserId != null) {
      configMap['customUserId'] = customUserId;
    }
    if (limitDataSharing != null) {
      configMap['limitDataSharing'] = limitDataSharing;
    }
    if (imei != null) {
      configMap['imei'] = imei;
    }
    configMap['sessionTimeout'] = sessionTimeout;
    configMap['collectOAID'] = collectOAID;
    configMap['enableLogging'] = enableLogging;
    return configMap;
  }
}
