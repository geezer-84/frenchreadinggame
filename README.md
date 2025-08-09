# French Reading Game (TTS) - Prototype

This is a simple Flutter prototype app that helps a child learn to read French.
The app uses text-to-speech (flutter_tts) to speak a word and shows multiple-choice
written options for the child to pick.

## What's included
- Flutter project skeleton (minimal)
- `lib/main.dart` — main app with TTS, multiple-choice UI, scoring
- `assets/words.json` — sample word list (editable)

## How to build an APK (locally)
1. Install Flutter: https://flutter.dev
2. From the project directory run:
   ```bash
   flutter pub get
   flutter run            # to test on a connected device
   flutter build apk      # to build release APK
   ```
3. The generated APK will be in `build/app/outputs/flutter-apk/app-release.apk` (or app-debug.apk for debug builds)

## Notes
- The app uses the device's system TTS voices. On Android, ensure a French voice/language is available in system settings.
- You can edit `assets/words.json` to add/remove words. Each entry should be:
  ```json
  { "word": "chat", "options": ["chat","chien","chaud","chou"] }
  ```
