class SingularGlobalProperty {

  String _key = "";
  String _value = "";
  bool _overrideExisting = false;
  
  SingularGlobalProperty(this._key, this._value, this._overrideExisting);

  Map<String, dynamic> get toMap {
    Map<String, dynamic> propertyMap = {
      'key': _key,
      'value': _value,
      'overrideExisting': _overrideExisting
    };

    return propertyMap;
  }
}
