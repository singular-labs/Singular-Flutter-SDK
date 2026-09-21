class SingularUserDetails {
  /// Cleartext email — the SDK normalizes and hashes it.
  String? email;

  /// Cleartext phone number — the SDK normalizes and hashes it.
  String? phoneNumber;

  /// Pre-hashed email (trimmed + lowercased before hashing). Stored as-is.
  String? emailSTD;

  /// Pre-hashed email with the gmail no-dots normalization. Stored as-is.
  String? emailNoDots;

  /// Pre-hashed phone in E.164 form (leading '+' kept). Stored as-is.
  String? phoneE164;

  /// Pre-hashed phone, digits only. Stored as-is.
  String? phoneDigits;

  SingularUserDetails();

  Map<String, dynamic> get toMap {
    Map<String, dynamic> userDetailsMap = {};

    if (email != null) {
      userDetailsMap['email'] = email;
    }

    if (phoneNumber != null) {
      userDetailsMap['phoneNumber'] = phoneNumber;
    }

    if (emailSTD != null) {
      userDetailsMap['emailSTD'] = emailSTD;
    }

    if (emailNoDots != null) {
      userDetailsMap['emailNoDots'] = emailNoDots;
    }

    if (phoneE164 != null) {
      userDetailsMap['phoneE164'] = phoneE164;
    }

    if (phoneDigits != null) {
      userDetailsMap['phoneDigits'] = phoneDigits;
    }

    return userDetailsMap;
  }
}
