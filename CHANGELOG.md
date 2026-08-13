# Changelog

All notable changes to this project are documented in this file.

## [1.0.0] - 2026-08-13

### Added

- Initial Biteo Business release.
- Official Biteo website reference: https://www.biteo.in/
- Admin dashboard with vendor, user, order, and earnings views.
- Vendor onboarding flow (Firebase Auth account creation, logo upload to Cloud Storage, Firestore vendor document with geolocation).
- User management (list, block/unblock, per-user analytics and order history).
- Vendor management (activate/block, open/closed toggle) and vendor join-request approval.
- Notifications: Firestore-based targeting (all users, all vendors, single user, single vendor) and push via Cloud Run endpoint.
- Offers and coupons management.
- Support tickets and admin chat.
- AI chat monitoring and AI settings management.
- Telegram alerts for support tickets, AI representative requests, and blocked users.
- Firebase (Auth, Firestore, Storage) integration for Android and Web.
- Repository readiness: `.gitignore`, `.env.example`, CI workflow, documentation (`README.md`, `docs/`), MIT license.
