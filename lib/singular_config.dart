import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:singular_flutter_sdk/singular_global_property.dart';
import 'package:singular_flutter_sdk/singular_link_params.dart';


typedef void SingularLinksHandler(SingularLinkParams params);
typedef void ConversionValueUpdatedCallback(int conversionValue);
typedef void ShortLinkCallback(String ? data, String ? error);
typedef void ConversionValuesUpdatedCallback(int conversionValue, int coarse, bool lock);
typedef void DeviceAttributionCallback(Map<String, dynamic> attributes);
typedef void SdidAccessorCallback(String sdid);

class SingularConfig {
  static const MethodChannel _channel = const MethodChannel('singular-api');

  String _apiKey;
  String _secretKey;
  bool skAdNetworkEnabled = true;
  bool clipboardAttribution = false;
  bool manualSkanConversionManagement = false;
  int waitForTrackingAuthorizationWithTimeoutInterval = 0;
  double shortLinkResolveTimeOut = 10.0;
  SingularLinksHandler? singularLinksHandler;
  ConversionValueUpdatedCallback? conversionValueUpdatedCallback;
  ConversionValuesUpdatedCallback? conversionValuesUpdatedCallback;
  DeviceAttributionCallback? deviceAttributionCallback;
  double sessionTimeout = -1;
  String? customUserId;
  bool? limitDataSharing;
  String? imei;
  String? facebookAppId;
  bool collectOAID = false;
  bool enableLogging = false;
  ShortLinkCallback ? shortLinkCallback;
  List<SingularGlobalProperty> globalProperties = [];
  List <String> espDomains = [];
  int logLevel = -1;

  // sdid
  String? customSdid;
  SdidAccessorCallback? didSetSdidCallback;
  SdidAccessorCallback? sdidReceivedCallback;

  SingularConfig(this._apiKey, this._secretKey) {
    _channel.setMethodCallHandler((MethodCall call) async {
      try {
        switch (call.method) {
          case 'singularLinksHandlerName':
            if (singularLinksHandler != null) {
              singularLinksHandler!(SingularLinkParams.fromMap(call.arguments));
            }
            break;
          case 'shortLinkCallbackName':
            if (shortLinkCallback != null){
              shortLinkCallback?.call(call.arguments['data'], call.arguments['error']);
              shortLinkCallback = null;
            }
            break;
          case 'conversionValueUpdatedCallbackName':
            if (conversionValueUpdatedCallback != null) {
              conversionValueUpdatedCallback!(call.arguments);
            }
            break;
          case 'conversionValuesUpdatedCallbackName':
            if (conversionValuesUpdatedCallback != null) {
              conversionValuesUpdatedCallback!(call.arguments['conversionValue'], call.arguments['coarse'], call.arguments['lock']);
            }
            break;
          case 'deviceAttributionCallbackName':
            if (deviceAttributionCallback != null) {
              Map<String, dynamic>? decodedData = jsonDecode(call.arguments);
              if (decodedData != null) {
                deviceAttributionCallback!(decodedData);
              }
            }
            break;
          case 'sdidReceivedCallbackName':
            if(sdidReceivedCallback != null) {
              sdidReceivedCallback!(call.arguments);
            }
            break;
          case 'didSetSdidCallbackName':
            if(didSetSdidCallback != null) {
              didSetSdidCallback!(call.arguments);
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

    if (conversionValuesUpdatedCallback != null) {
      configMap['conversionValuesUpdatedCallback'] =
      'conversionValuesUpdatedCallbackName';
    }

    if (deviceAttributionCallback != null) {
      configMap['deviceAttributionCallback'] = 'deviceAttributionCallbackName';
    }
    
    // SDID
    if (customSdid != null && customSdid!.isNotEmpty) {
      configMap['customSdid'] = customSdid;
    }

    if (sdidReceivedCallback != null) {
      configMap['sdidReceivedCallback'] = 'sdidReceivedCallbackName';
    }

    if (didSetSdidCallback != null) {
      configMap['didSetSdidCallback'] = 'didSetSdidCallbackName';
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

    if (facebookAppId != null) {
      configMap['facebookAppId'] = facebookAppId;
    }

    configMap['sessionTimeout'] = sessionTimeout;
    configMap['collectOAID'] = collectOAID;
    configMap['enableLogging'] = enableLogging;
    configMap['logLevel'] = logLevel;
    configMap['espDomains'] = espDomains;

    List<Map<String, dynamic>> propertiesList = [];
    for (SingularGlobalProperty prop in this.globalProperties) {
      propertiesList.add(prop.toMap);
    }
    configMap['globalProperties'] = propertiesList;

    return configMap;
  }

  void setShortLinkCallback(ShortLinkCallback shortLinkCallback) {
    this.shortLinkCallback = shortLinkCallback;
  }

  void withGlobalProperty(String key, String value, bool overrideExisting){
    this.globalProperties.add(new SingularGlobalProperty(key, value, overrideExisting));
  }

}
