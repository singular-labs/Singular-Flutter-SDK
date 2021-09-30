class SingularLinkParams {
  String? deeplink;
  String? passthrough;
  bool? isDeferred;

  SingularLinkParams({this.deeplink, this.passthrough, this.isDeferred});

  static fromMap(dynamic map) {
    try {
      return SingularLinkParams(
        deeplink: map['deeplink'],
        passthrough: map['passthrough'],
        isDeferred: map['isDeferred'],
      );
    } catch (e) {
      return null;
    }
  }
}
