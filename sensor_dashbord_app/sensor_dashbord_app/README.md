# Implementation Details

The project is organized into multiple screens, each demonstrating a different hardware sensor or system capability. The application follows Flutter's StatefulWidget architecture, where each screen is responsible for managing a specific sensor stream.

---

## main.dart

This is the application's entry point.

### Responsibilities

- Initializes the Flutter application.
- Wraps the application with `ChangeNotifierProvider`.
- Provides an instance of `ThemeNotifier` to the entire widget tree.
- Configures the application's light and dark themes.
- Sets `SplashScreen` as the initial screen.

### Main Classes

#### MyApp

Creates the root `MaterialApp` and listens to `ThemeNotifier` to dynamically switch between light and dark themes.

---

## theme_notifier.dart

Manages the application's global theme.

### Class

#### ThemeNotifier

A `ChangeNotifier` that stores the current `ThemeMode`.

### Functions

#### updateThemeBasedOnLux(double lux)

Updates the application theme according to the ambient light sensor.

- Lux < 80 → Dark theme
- Lux ≥ 80 → Light theme

Whenever the theme changes, `notifyListeners()` rebuilds the application.

---

## splash_screen.dart

Displays the application's splash screen.

### Responsibilities

- Shows the application logo.
- Displays a loading animation.
- Waits three seconds before navigating to the biometric authentication screen.

### Functions

#### initState()

Starts a delayed timer that automatically opens `BiometricLockScreen`.

---

## biometric_lock_screen.dart

Provides secure access to the dashboard.

### Responsibilities

- Checks whether biometric authentication is available.
- Requests fingerprint or face authentication.
- Handles authentication failures.
- Allows bypass for unsupported devices or emulators.

### Important Functions

#### _authenticate()

- Checks hardware availability.
- Starts biometric authentication.
- Navigates to the dashboard after successful authentication.

#### _navigateToDashboard()

Replaces the current page with `SensorDashboard`.

---

## sensor_dashboard.dart

The central navigation screen of the application.

### Responsibilities

- Displays all available sensor modules.
- Detects phone shake events.
- Creates navigation cards for each sensor screen.

### Important Functions

#### initState()

Initializes a `ShakeDetector` that continuously monitors accelerometer data.

#### _buildCard()

Creates reusable dashboard cards containing

- icon
- title
- destination screen

This avoids repeating widget code for every sensor.

---

## parallax_background.dart

Provides an animated background.

### Responsibilities

Reads accelerometer values and moves the background image to create a parallax effect.

### Important Variables

- `x`
- `y`
- `lastX`
- `lastY`

These variables store the current and previous offsets to prevent unnecessary widget rebuilds.

### initState()

Subscribes to the accelerometer stream and updates the background position.

---

## compass_screen.dart

Displays compass information.

### Responsibilities

- Reads magnetometer heading.
- Converts heading angles into compass directions.
- Rotates the compass image.

### Important Functions

#### _getDirection(double heading)

Converts numerical heading values into compass directions.

Example:

- 0° → North
- 90° → East
- 180° → South
- 270° → West

The compass image is rotated using

```dart
Transform.rotate(...)
```

so that it always points north.

---

## map_screen.dart

Provides real-time GPS tracking.

### Responsibilities

- Requests location permission.
- Monitors GPS updates.
- Displays the current position on a map.

### Important Functions

#### _initLocationTracking()

Performs all GPS initialization:

- checks whether GPS is enabled
- requests permissions
- retrieves the last known position
- starts listening to live location updates

#### dispose()

Stops the position stream to prevent memory leaks.

---

## light_meter_screen.dart

Reads the ambient light sensor.

### Responsibilities

- Displays light intensity in Lux.
- Automatically updates the application's theme.

### StreamBuilder

A `StreamBuilder<int>` continuously receives Lux values from

```dart
LightSensor.luxStream()
```

Every new reading is forwarded to

```dart
ThemeNotifier.updateThemeBasedOnLux()
```

which updates the global theme.

---

## step_counter_screen.dart

Implements a simple software-based pedometer.

Unlike Android's hardware step counter, this implementation estimates steps using accelerometer data.

### Important Variables

- `_steps`
- `_magnitudePrevious`

### _startListening()

Subscribes to

```dart
userAccelerometerEvents
```

For every event:

1. Computes acceleration magnitude.
2. Calculates the difference from the previous reading.
3. If the difference exceeds a threshold (`8.0`), one step is counted.

This demonstrates a basic threshold-based step detection algorithm.

---

## proximity_screen.dart

Monitors the proximity sensor.

### Responsibilities

- Detects nearby objects.
- Updates the displayed status.
- Changes the icon based on sensor readings.

### initState()

Creates a subscription to

```dart
ProximitySensor.events
```

which continuously updates `_isNear`.

---

## barometer_screen.dart

Reads atmospheric pressure.

### Responsibilities

- Displays pressure in hPa.
- Estimates altitude.

### Altitude Calculation

Altitude is computed using the standard barometric formula:

```dart
44330 * (1 - (pressure / 1013.25)^(1 / 5.255))
```

where

- 1013.25 hPa is standard sea-level pressure.
- The result is displayed in meters.

---

## nfc_reader_screen.dart

Provides NFC tag scanning functionality.

### Responsibilities

- Detects NFC availability.
- Reads tag identifiers.
- Extracts NDEF payloads.
- Supports simulation mode.

### Important Functions

#### _checkNFCAvailability()

Determines whether the device supports NFC.

#### _scanNFC()

Starts an NFC session and waits for a nearby tag.

After discovery it

- extracts the tag ID
- reads cached NDEF records
- displays payload information
- closes the NFC session

#### _simulateNFCTag()

Creates fake NFC data for testing on emulators.

---

# State Management

The project uses the **Provider** package for global state management.

Only one global state object exists:

- `ThemeNotifier`

All other sensor data is managed locally inside each screen using `StatefulWidget` and updated through `setState()` whenever new sensor events arrive.

---

# Sensor Streams

Most screens subscribe to continuous sensor streams.

| Screen | Sensor Stream |
|---------|---------------|
| Compass | `FlutterCompass.events` |
| Barometer | `barometerEventStream()` |
| Step Counter | `userAccelerometerEvents` |
| Parallax Background | `accelerometerEventStream()` |
| Light Meter | `LightSensor.luxStream()` |
| GPS Map | `Geolocator.getPositionStream()` |
| Proximity | `ProximitySensor.events` |

Each subscription is properly cancelled in `dispose()` to avoid memory leaks.