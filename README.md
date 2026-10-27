# Mobile Programming Midterm — Flutter Apps

Midterm project for the **Mobile Programming** course (Sharif University of Technology, 2026). It contains three Flutter apps: two centred on **mobile app security** (secure storage, biometric authentication, device integrity checks, encrypted local data) and one on **device sensors**.

> Educational project. All banking data is simulated — never store real banking credentials in these apps.

## Questions

| # | Folder | What it is | Stack |
|---|--------|------------|-------|
| 1 | [`q1/secure_bank_app`](q1/secure_bank_app) | Secure mock banking app: device integrity check, phone + OTP login, biometric gate, security report | Flutter, Android |
| 2 | [`q2/sensor_dashbord_app`](q2/sensor_dashbord_app) | Sensor dashboard: compass, GPS map, light meter, step counter, proximity, barometer, NFC reader, shake detection, parallax background | Flutter, Android |
| 3 | [`q3/encrypted_bank_card_app`](q3/encrypted_bank_card_app) | Bank card wallet with AES-encrypted SQLite storage, biometric lock, NFC scan, installed banking-app detection | Flutter, Android |

Each app has its own README with architecture and details; screenshots are in `secure_bank_app\Q1_Screenshots`, `sensor_dashbord_app\Q2_Screenshots` and `encrypted_bank_card_app/screenshots/`.

> **Note on screenshots:** some areas are blurred on purpose. I used my own phone number as test input while trying the login flow, so I blurred it (along with a few other personal details like my username and GPS test coordinates). 😄

## Highlights

**Q1 — Secure Bank App**
- Blocks startup on rooted or emulated devices (`safe_device`).
- Mock phone-number login with a simulated SMS OTP and autofill.
- Session token kept in `flutter_secure_storage` (Android Keystore).
- Biometric / device-PIN step-up authentication before the dashboard.
- Security report screen, and `FLAG_SECURE` to block screenshots and screen recording.

**Q2 — Sensor Dashboard**
- Splash screen, then a biometric lock before the dashboard (with a bypass button for emulators).
- Compass (magnetometer), GPS tracking on a live map, barometer with altitude estimate, proximity sensor, and an NFC reader with a simulation mode.
- Light meter that switches the whole app between light and dark theme (threshold: 80 lux).
- Software step counter based on accelerometer peaks, shake detection, and an accelerometer-driven parallax background.
- State handled with `provider` (theme) and per-screen `StatefulWidget` streams, each cancelled in `dispose()`.

**Q3 — Encrypted Bank Card App**
- Card number, CVV2 and expiry are AES-encrypted before they are written to SQLite; the key is generated on first launch and stored in secure storage.
- Layered design: screens → repository → encryption service → database.
- Biometric lock on every launch, masked card numbers, live search, NFC tag scanner, and detection and launch of installed Iranian banking apps.

## Running

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) and an Android emulator or device.

```bash
# Q1
cd q1/secure_bank_app
flutter pub get
flutter run

# Q2
cd q2/sensor_dashbord_app
flutter pub get
flutter run

# Q3
cd q3/encrypted_bank_card_app
flutter pub get
flutter run
```

- Biometrics: enroll a fingerprint on the emulator (*Extended controls → Fingerprint*) or use a physical device.
- Emulator sensors (Q2): use *Extended controls → Virtual sensors* to change light, proximity, pressure, and orientation, and *Location* to set a GPS point.
- NFC (Q2, Q3) needs a physical device with NFC hardware. Q2 also has a "Simulate NFC Tag" demo button.
- The Q2 map needs an internet connection to load tiles.
- Q1 refuses to start on devices flagged as rooted or emulated. If your emulator is flagged, use a physical device.
- Q1 ships only the `android/` and `lib/` folders, so it targets Android only.
