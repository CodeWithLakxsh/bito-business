# Deployment Guide

## Overview

Biteo Business is a Flutter client that depends on Google Firebase services. Deploying it involves:

1. Building the client (web and/or Android).
2. Configuring the Firebase project (Authentication, Firestore, Storage).
3. Providing the external services the app calls (Cloud Run push endpoint, Telegram bot).

This repository does **not** own the backend — Firebase rules and services must be configured in the Firebase console.

## Runtime configuration supply

The application receives configuration at **compile time** (no runtime `.env` loading):

| Configuration | Supply mechanism |
|---|---|
| Firebase options | `flutterfire configure` (regenerates `lib/firebase_options.dart`) |
| Android Firebase config | `android/app/google-services.json` (gitignored; provided locally or via CI secrets) |
| Admin TOTP secret | `--dart-define=ADMIN_TOTP_SECRET=<value>` |
| Telegram bot token / chat ID | constants in `lib/telegram_service.dart` (currently placeholders) |
| Push endpoint URL | constant in `lib/notification_sender_screen.dart` |

> **Security:** never bake real secrets into a public build that you do not control. Client-side TOTP is inherently weak; see [docs/security.md](docs/security.md).

## Web deployment

```bash
flutter build web --release --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>
```

The output is the static site in `build/web/`. Host it with Firebase Hosting, Cloud Run, or any static host:

```bash
# Example: Firebase Hosting (requires firebase-tools and a hosting config)
firebase deploy --only hosting
```

Add the web origin to Firestore/Storage authentication where applicable.

## Android deployment

```bash
flutter build apk --release --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>
# or
flutter build appbundle --release --dart-define=ADMIN_TOTP_SECRET=<your-base32-secret>
```

**Before a store release:**

- Configure a **production signing config** — `android/app/build.gradle.kts` currently signs with the debug key (see the TODO in that file).
- Verify the `applicationId` and package configuration match your Play Console app.

## Firebase project configuration

The following are configured in the Firebase console and are **not** stored in this repository:

- **Authentication** — enable the providers you use (email/password for vendor onboarding).
- **Cloud Firestore** — create the collections used by the app and apply **security rules** (none exist in this repo; see [docs/security.md](docs/security.md)).
- **Cloud Storage** — enable storage for `vendor_images/` uploads, set **storage rules**, and apply CORS if hosting a web build that uploads files (`firebase storage:set-cors cors.json`).
- **Cloud Run push endpoint** — the endpoint referenced in `lib/notification_sender_screen.dart` must be deployed and reachable. Verify its authentication configuration (see [docs/security.md](docs/security.md)).
- **Telegram bot** — create a bot via BotFather and place the token/chat ID in `lib/telegram_service.dart` (or configure via a build-time mechanism) if operational alerts are required.

## CI

The CI workflow (`.github/workflows/ci.yml`) validates the project on a clean checkout:

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build web --release` (with a harmless `ADMIN_TOTP_SECRET=CI_PLACEHOLDER` define)

It does **not** deploy. A deployment pipeline (e.g. Firebase Hosting) can be added later; if it needs `google-services.json` or Firebase secrets, supply them via GitHub Actions **Secrets** — never inline in the workflow file.
