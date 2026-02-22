# Are You Alive - Safety Check-in App

A digital "dead man's switch" built with Flutter. Requires users to check in periodically; otherwise, it sends alerts to trusted contacts via Email.

## Tech Stack
- Frontend: Flutter (Dart 3)
- State Management: Riverpod
- Routing: GoRouter
- Backend: Supabase (Auth provided by Clerk)
- Email API: Brevo

## Setup Guide

### 1. Clerk Authentication
1. Go to [Clerk Dashboard](https://dashboard.clerk.dev/) and create an application.
2. In `lib/main.dart` replace `publishableKey` with your Clerk Publishable API from the dashboard.
3. For Android Google Auth, you must generate a SHA-1 and SHA-256 fingerprint:
   `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
4. Add the generated keys to your Google Cloud Console for OAuth.

### 2. Supabase Configuration
1. Create a project on [Supabase.com](https://supabase.com/).
2. Setup the following tables:
   - `users (uuid, name, phone, check_interval_hours, ...)`
   - `medical_info`
   - `emergency_contacts`
   - `check_ins (user_id, timestamp, location)`
3. Update `lib/main.dart` Supabase `url` and `anonKey`.

### 3. Brevo (Sendinblue) Setup
1. Get an API key from [Brevo Dashboard](https://app.brevo.com/settings/keys/api).
2. Update `lib/services/brevo_service.dart` with your API key.

## Background Execution Notes
- Uses `workmanager` for background periodic tracking.
- Fallback for lock screen interrupts utilizes `flutter_callkeep` (iOS) and `flutter_overlay_window` (Android).