class SingularIAP {
  String? _revenue;
  String? _currencyCode;

  SingularIAP(this._revenue, this._currencyCode);

  Map<String, dynamic> get toMap {
    Map<String, dynamic> eventInformation = new Map<String, dynamic>();
    if (_currencyCode != null) {
      eventInformation['pcc'] = _currencyCode;
    }
    if (_revenue != null) {
      eventInformation['r'] = _revenue;
    }
    eventInformation["is_revenue_event"] = true;

    return eventInformation;
  }
}

class SingularIOSIAP extends SingularIAP {
  String? _productId;
  String? _transactionId;
  String? _receipt;

  SingularIOSIAP(String? revenue, String? currencyCode, this._productId,
      this._transactionId, this._receipt)
      : super(revenue, currencyCode);

  Map<String, dynamic> get toMap {
    Map<String, dynamic> eventInformation = super.toMap;
    if (_receipt != null) {
      eventInformation['ptr'] = _receipt;
    }
    if (_transactionId != null) {
      eventInformation['pti'] = _transactionId;
    }
    if (_productId != null) {
      eventInformation['pk'] = _productId;
    }

    return eventInformation;
  }
}

class SingularAndroidIAP extends SingularIAP {
  String? _signature;
  String? _receipt;

  SingularAndroidIAP(
      String? revenue, String? currencyCode, this._signature, this._receipt)
      : super(revenue, currencyCode);

  Map<String, dynamic> get toMap {
    Map<String, dynamic> eventInformation = super.toMap;
    if (_receipt != null) {
      eventInformation['ptr'] = _receipt;
    }
    if (_receipt != null) {
      eventInformation['receipt'] = _receipt;
    }
    if (_signature != null) {
      eventInformation['receipt_signature'] = _signature;
    }
    return eventInformation;
  }
}
