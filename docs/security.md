# Security

This document records the security posture of Bito Business at the time of the v1.0.0 repository preparation. It distinguishes issues that are **fixed now** from those that are **documented and require future architectural change**.

## Status legend

- **FIXED NOW** — mitigated in this release.
- **DOCUMENTED — REQUIRES FUTURE ARCHITECTURAL CHANGE** — known issue; requires design/implementation work beyond this GitHub-preparation task.

---

## CRITICAL — Client-side TOTP authentication

**Status:** `DOCUMENTED — REQUIRES FUTURE ARCHITECTURAL CHANGE`

**Finding:** The admin gate (`lib/auth_screen.dart`) is a **client-side TOTP check**. The shared secret is supplied at compile time via `--dart-define=ADMIN_TOTP_SECRET` and the one-time code is generated and verified **entirely in the app**. There is no server-side validation.

**Risk:** Because the secret is compiled into a Flutter client, it can be extracted from the distributed application or release bundle. Anyone with the secret can generate valid admin codes. Moving the literal secret out of tracked source (into a compile-time define) **reduces repository exposure but does not make the mechanism secure**.

**Recommended fix (future):** Replace the client-side TOTP gate with **server-side authentication/verification**, for example:

- Admin sign-in through Firebase Authentication with proper admin role claims, and
- server-enforced authorization (e.g. Firestore security rules / a trusted backend) for admin operations.

**Action taken now:** the real secret was removed from tracked source; it is supplied at compile time and is never committed, printed, or documented. **The TOTP secret should be rotated** because it previously existed in the source tree.

---

## Secrets found during preparation

| File | Item | Type | Status |
|---|---|---|---|
| `lib/auth_screen.dart` | Real base32 TOTP shared secret (literal) | Authentication secret | **FIXED NOW** — removed from source; now a compile-time define with a placeholder default |
| `android/app/google-services.json` | Firebase client identifiers (API keys, app IDs, OAuth client IDs, package names, certificate hashes) | Firebase client config | **FIXED NOW** — file gitignored; `google-services.json.example` committed instead |
| `lib/firebase_options.dart` | GA4 measurement ID | Non-secret client identifier | LOW — kept (measurement IDs are public-facing) |
| `lib/telegram_service.dart` | Telegram bot token and chat ID | — | None found — both are `YOUR_*` placeholders |
| `lib/notification_sender_screen.dart` | Cloud Run endpoint URL | Infrastructure reference | LOW — kept; endpoint auth status below |

**Secrets found in Git history:** none — no Git history exists for this project directory prior to this preparation.

**Telegram token:** no real token was found in the project. If a real token is ever added, treat it as compromised once it leaves a secure store and rotate it via BotFather (`/revoke`).

---

## Firebase security status

**Firestore security rules:** not present in this repository. **Status: review required (HIGH).** The app writes directly to Firestore from the client (e.g. onboarding creates vendor documents, block/unblock writes, notification writes). Firestore rules must be reviewed and applied in the Firebase console; default or overly permissive rules such as `allow read, write: if true;` must be avoided.

**Storage security rules:** not present in this repository. **Status: review required (HIGH).** `cors.json` (Cloud Storage CORS) allows `*` origins for GET/POST/PUT; this is typical for web clients but must be paired with restrictive Storage rules.

**Authentication configuration:** Firebase Auth is used for vendor account creation. Admin operations are not protected by Firebase Auth or claims (admin access is the client-side TOTP gate). **Status: review required (HIGH).**

---

## Cloud Run security status

**Status:** `DOCUMENTED — REQUIRES FUTURE ARCHITECTURAL CHANGE` (verify endpoint configuration)

**Finding:** The push-notification endpoint referenced in `lib/notification_sender_screen.dart` is invoked from the client with only a `Content-Type` header and **no authentication header**, implying it is publicly callable (code inspection only — no access attempts were made). Anyone who can reach the URL could send push notifications.

**Recommended fix:** Configure the Cloud Run service to require authentication (e.g. require an identity token / API key, restrict invocation to admin callers) and add corresponding client handling.

---

## Recommended future security improvements

1. Move admin authentication to **server-side verification** (Firebase Auth + admin claims + Firestore security rules).
2. Add and enforce **Firestore and Storage security rules** in the Firebase console; review all collection paths the app writes to.
3. **Protect the Cloud Run push endpoint** (require auth; restrict callers).
4. Provide Telegram credentials via a build-time secret channel; never commit.
5. Configure **production Android signing** (release builds currently use the debug key per the `build.gradle.kts` TODO).
6. Add **secret scanning** (e.g. GitHub secret-scanning / `gitleaks`) to CI.
7. Rotate the **admin TOTP secret** and any other credential that previously appeared in un-released or shared source.

---

## Repository policy

- `.gitignore` excludes environment files, `google-services.json`, keystores, and key properties.
- `.env.example` is documentation-only and contains no real values.
- CI builds with a harmless placeholder (`ADMIN_TOTP_SECRET=CI_PLACEHOLDER`); production values are supplied through a secure channel.
- The release package contains no credentials.
