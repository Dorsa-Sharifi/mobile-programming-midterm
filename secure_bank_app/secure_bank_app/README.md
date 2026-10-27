## Project Overview
This project is a Secure Educational Banking Application developed using Flutter. It is designed as a demonstration framework to highlight mobile security principles, runtime application self-protection (RASP), and cryptographic local storage. Built purely for educational and training purposes, the application operates entirely on simulated data while implementing rigorous enterprise-grade defense mechanisms to safeguard user interactions and mitigate mobile operating system vulnerabilities.

## 1. Project Architecture Overview

The application utilizes a decoupled **Layered Architecture** to separate concerns:

* **Presentation Layer (`/screens`)**: Manages the user interface, navigation flows, and state updates.
* **Service Layer (`/services`)**: Interfaces with device hardware, platform channels, and local secure storage.

```
lib/
│
├── main.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── otp_screen.dart
│   ├── biometric_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── security_report_screen.dart
│
└── services/
    ├── security_service.dart
    └── storage_service.dart

```

---

## 2. Infrastructure & Services Layer Logic

### `StorageService` (`storage_service.dart`)

This class acts as the application's secure data vault. Standard storage options like `SharedPreferences` write data in plaintext XML files, which are easily stolen on rooted devices. This service wraps `FlutterSecureStorage`, which interfaces directly with platform-specific secure enclaves: **Keychain** on iOS and **KeyStore (using hardware-backed AES encryption)** on Android.

* **`saveToken(String token)`**: Hardware-encrypts the mock session token generated upon login and commits it to the secure sandbox.
* **`getToken()`**: Asynchronously decrypts and retrieves the active session token. Returns `null` if the token has expired or does not exist.
* **`savePhoneNumber(String phone)` & `getPhoneNumber()**`: Securely registers and reads the user's primary identity identifier to prevent sniffing by other applications.
* **`deleteToken()`**: Triggered during logouts. It completely wipes all stored keys inside the secure enclave, preventing Session Hijacking attacks.

### `SecurityService` (`security_service.dart`)

This is the core defensive engine. It cross-examines hardware traits and application metadata to build a comprehensive risk assessment.

* **`checkDeviceIntegrity()`**: A lightweight, high-speed abstraction that filters critical flags (`isRooted`, `isEmulator`, `isDevMode`) to gate app startup.
* **`getSecurityReport()`**: The primary diagnostic coordinator that fires concurrent platform channels to build a comprehensive security diagnostic map.
* **`_verifyAppSource()`**: Queries `PackageInfo` to ensure the unique package name (`packageName`) exactly matches the expected signature (`"secure_bank_app"`). This prevents clone/re-packaging attacks.
* **`_verifyAppSignature()`**: Inspects active build metadata. In production, this checks the runtime SHA-256 hash against your official store certificate to flag modified binaries (tampered APKs/IPAs).
* **`_checkBiometricStatus()`**: Evaluates local hardware using `LocalAuthentication`. It returns `true` only if the device has biometric capabilities and they are actively set up by the user.
* **`_checkSecureStorageStatus()`**: Performs a quick runtime write-read-delete operation inside the hardware enclave. If this fails, it flags that the secure storage subsystem is compromised.

---

## 3. Presentation Layer & UI Logic

### `SplashScreen` (`splash_screen.dart`)

Acts as the initial gatekeeper. Its absolute rule is to block the user interface thread from loading until the device is certified safe.

* **`_initializeApp()`**: Triggers `checkDeviceIntegrity()`. If the device environment is compromised (`_isSafe = false` due to rooting or emulation), execution halts completely, and the exact error message requested by the prompt is displayed.
* **`_handleNavigation()`**: If the environment is safe, it checks for an existing secure token. If found, it routes to `BiometricScreen`; if not, it routes to `LoginScreen`.

### `LoginScreen` (`login_screen.dart`) & `OtpScreen` (`otp_screen.dart`)

Manages the mock two-factor entry system.

* **`LoginScreen`**: Captures the mobile number inputs and initiates the mock sequence by exposing the test code (`123456`).
* **`_simulateOtpAutoFill()`**: Uses a `Future.delayed` routine to simulate a 2-second network latency. Once triggered, it programmatically injects the code into the text controller, modeling how native Android/iOS SMS Autofill APIs read incoming SMS buffers without manual user entry.
* **`_verifyOtp()`**: A strict validation gate. Upon matching `123456`, it commits the generated session payload to `StorageService` and safely hands off execution down the stack.

### `BiometricScreen` (`biometric_screen.dart`)

Forces an active step-up authentication check using native operating system micro-kernels before exposing any financial dashboard tools.

* **`_authenticate(BuildContext context)`**:
* Evaluates hardware readiness (`canCheckBiometrics`).
* Fires native system biometric overlay prompts using `auth.authenticate`.
* **`biometricOnly: false`**: Acts as a defensive fallback, allowing the user to input their secure device PIN, Password, or Pattern if hardware scanners fail.
* **`stickyAuth: true`**: Prevents the authentication channel from instantly crashing or failing if an external system overlay (like a phone call or system notification) interrupts the application.
* **`context.mounted`**: A vital asynchronous programming check that ensures the widget still exists in the element tree before executing routing commands, preventing memory leaks.



### `HomeScreen` (`home_screen.dart`)

The centralized dashboard framework. It renders static widgets displaying fake assets, recent mock transactions, and acts as the structural hub for advanced navigation actions.

### `ProfileScreen` (`profile_screen.dart`)

Renders highly sensitive user profile and account account parameters.

* **`_loadUserPhoneNumber()`**: Safely fetches stored inputs asynchronously during the `initState` loop before updating the widget UI tree.
* **Screenshot Protection Integration**: This screen integrates explicit instructional warnings regarding native window protection. In a native environment, this corresponds to setting `WindowManager.LayoutParams.FLAG_SECURE` in Android, which forces the hardware GPU to completely black out video captures, system screenshots, and recent apps task-switcher caching.

### `SecurityReportScreen` (`security_report_screen.dart`)

A diagnostic control center mapping out the metrics built by `SecurityService`.

* **`_buildSecurityItem()`**: Features an **inversion logical switch** via the `inverseColor` parameter. Normal system properties (like Biometric Enabled) are marked safe/green when **true**. However, attack threats (like Rooted or Emulator status) are secure only when **false**, meaning a true evaluation properly triggers an unsafe/red alert.

### `SettingsScreen` (`settings_screen.dart`)

Handles configurations and session lifecycles.

* **`_logout(BuildContext context)`**: Invokes the `deleteToken()` command inside `StorageService` to clear hardware-encrypted variables, then uses `Navigator.pushAndRemoveUntil` to purge the entire backstack history, preventing history-traversal attacks.

