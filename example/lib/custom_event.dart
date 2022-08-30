import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singular_flutter_sdk/singular.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:singular_flutter_sdk/singular_iap.dart';


class CustomEvent extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

const String _kConsumableId = 'prod_1';
const List<String> _kProductIds = <String>[
  _kConsumableId,
];

class MainPageState extends State<CustomEvent> {
  final textController = TextEditingController();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  String? _queryProductError;
  // called on every foreground
  @override
  void initState() {

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
      });
      return;
    }

    setState(() {
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
    });
  }


    Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          SingularIAP singularPurchase = new SingularIOSIAP(
            '',
            '',
            '',
            '',
            ''
          );
        

          if (Platform.isIOS) {
          singularPurchase = new SingularIOSIAP(
            _products[0].price,
            _products[0].currencyCode,
            purchaseDetails.productID,
            purchaseDetails.purchaseID,
            purchaseDetails.verificationData.serverVerificationData
          );
          } else if (Platform.isAndroid) {
            singularPurchase = new SingularAndroidIAP(
              _products[0].price,
              _products[0].currencyCode,
              purchaseDetails.verificationData.serverVerificationData,
              purchaseDetails.verificationData.localVerificationData
            );
          }
          Singular.inAppPurchase("purchase_event", singularPurchase);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Event Name',
            ),
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Custom Event',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String eventName = textController.text;
              if (eventName.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid event name"),
                    );
                  },
                );
                return;
              }
              // Set Conversion Value manually (when using manualSkanConversionManagement)
              // Note that conversion values may only increase, so only the first call will update it
              Singular.skanUpdateConversionValue(7);

              // Reporting a simple event to Singular
              Singular.event(eventName);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Event sent"),
                  );
                },
              );
            },
          ),
        ),
        Center(
          child: TextButton(
            child: Text(
              'Custom Event With Attributes',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              String eventName = textController.text;
              if (eventName.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      // Retrieve the text the that user has entered by using the
                      // TextEditingController.
                      content: Text("Please enter a valid event name"),
                    );
                  },
                );
                return;
              }
              // Set Conversion Value manually (when using manualSkanConversionManagement)
              // Note that conversion values may only increase, so only the first call will update it
              Singular.skanUpdateConversionValue(3);

              Map<String, dynamic> args = {"key1": "value1", "key2": "value2"};

              // Reporting a simple event to Singular
              Singular.eventWithArgs(eventName, args);

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text("Event sent"),
                  );
                },
              );
            },
          ),
        ),
          Center(
          child: TextButton(
            child: Text(
              'Short link',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              Map<String, dynamic> args = {"channel": "sms"};
              // Reporting a simple event to Singular
              Singular.createReferrerShortLink("https://sample.sng.link/B4tbm/v8fp?_dl=https%3A%2F%2Fabc.com",  "refName", "refID",  args, (String ? data, String ? error) {
                showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("link: " + (data!=null?data:"") + " error: " + (error!=null?error:"") ),
                  );
                },
              );
              });

            },
          ),
        ),
          Center(
            child: TextButton(
            child: Text(
              'Buy product',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
                    late PurchaseParam purchaseParam;

                    if (Platform.isAndroid) {
                      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                      // verify the latest status of you your subscription by using server side receipt validation
                      // and update the UI accordingly. The subscription purchase status shown
                      // inside the app may not be accurate.
                     

                      purchaseParam = GooglePlayPurchaseParam(
                          productDetails: _products[0],
                          applicationUserName: null,
                          changeSubscriptionParam:  null);
                    } else {
                      purchaseParam = PurchaseParam(
                        productDetails: _products[0],
                        applicationUserName: null,
                      );
                    }

                 /*   if (productDetails.id == _kConsumableId) {
                      _inAppPurchase.buyConsumable(
                          purchaseParam: purchaseParam,
                          autoConsume: _kAutoConsume || Platform.isIOS);
                    } else {*/
                      _inAppPurchase.buyNonConsumable(
                          purchaseParam: purchaseParam);
                   // }

            },
          ),
        )
        
      ],
    );
  }
}
