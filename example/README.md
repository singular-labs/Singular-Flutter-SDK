# flutter_sdk_example

Demonstrates how to use the flutter_sdk plugin.

## Singular credentials

The app reads its API key and secret from `example/singular_keys.json`, which is gitignored and
must be created locally:

```json
{
  "SINGULAR_API_KEY": "your-api-key",
  "SINGULAR_SECRET_KEY": "your-api-secret"
}
```

The file is not picked up automatically — pass it explicitly, or the placeholder credentials in
`main.dart` are used instead:

```
flutter run --dart-define-from-file=singular_keys.json
```

The same flag works for `flutter build`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
