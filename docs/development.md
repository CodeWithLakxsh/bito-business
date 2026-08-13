# Development Guide

## Prerequisites

- Flutter SDK (stable channel), Dart `^3.11.4`.
- Android SDK and/or Chrome for the platforms you target.
- A Firebase project. Biteo Business targets **Android** and **Web** (other platforms throw `UnsupportedError` in `lib/firebase_options.dart`).
- Optional: FlutterFire CLI (`dart pub global activate flutterfire_cli`) to regenerate Firebase config.
- General information about Biteo: official website — https://www.biteo.in/

## Setup

```bash
git clone <your-repository-url> biteo-business
cd biteo-business
flutter pub get
```

### Firebase configuration

`lib/firebase_options.dart` ships with `YOUR_*` placeholders and must be regenerated against a real Firebase project:

```bash
# Option A — FlutterFire CLI (regenerates firebase_options.dart and google-services.json)
flutterfire configure -p <your-firebase-project-id>

# Option B — Manual
#  1. Firebase console → Project settings → Your Android app → google-services.json
#  2. Place it at android/app/google-services.json
#     (see android/app/google-services.json.example for the expected shape)
#  3. Fill lib/firebase_options.dart with the Web/Android client values.
```

> `android/app/google-services.json` is **gitignored**. It must be provided locally (and, if needed, via CI secrets) — never committed.

### Admin TOTP secret

The admin gate (`lib/auth_screen.dart`) reads the shared secret at compile time:

```bash
flutter run --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>
```

If omitted, the placeholder default `YOUR_TOTP_SECRET` is used and admin access will not authenticate.

> **Security:** this is a client-side TOTP gate. The secret is extractable from the compiled app. See [docs/security.md](docs/security.md) for the recommended replacement.

## Running

```bash
# Web (Chrome)
flutter run -d chrome --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>

# Android
flutter run -d <android-device-id> --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>
```

## Testing

```bash
flutter test
```

`test/widget_test.dart` is a smoke test that pumps the app and verifies the auth screen renders. It does not require Firebase at runtime.

## Static analysis

```bash
flutter analyze
```

The project uses `package:flutter_lints` (see `analysis_options.yaml`).

## Building

```bash
# Web (release)
flutter build web --release --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>

# Android APK (release) — requires android/app/google-services.json
flutter build apk --release --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>
```

> Note: `android/app/build.gradle.kts` currently signs release builds with the **debug key** (template TODO). Configure a production signing key before shipping an Android release.

## Cleanup / hygiene

- `flutter clean` removes build artifacts.
- Never commit: `.env*` (except `.env.example`), `google-services.json`, keystores, `key.properties`, or any real credential.

## Code conventions

- Dart files follow the project's existing style (the codebase uses `package:flutter_lints` defaults).
- Do not introduce new dependencies for configuration; use the established compile-time (`--dart-define` / generated files) approach.
