class SingularLinkParams {
  String? deeplink;
  String? passthrough;
  bool? isDeferred;
  Map<Object?, Object?>? urlParameters;

  SingularLinkParams({this.deeplink, this.passthrough, this.isDeferred, this.urlParameters});

  static fromMap(dynamic map) {
    try {
      return SingularLinkParams(
        deeplink: map['deeplink'],
        passthrough: map['passthrough'],
        isDeferred: map['isDeferred'],
        urlParameters: map['urlParameters'],
      );
    } catch (e) {
      return null;
    }
  }
}
